/******************************************************************************

	File: Realloc.cpp

	Description:

	Object Memory management class object resizing routines

******************************************************************************/

#include "Ist.h"
#pragma code_seg(MEM_SEG)

#include "ObjMem.h"
#include "interprt.h"

// Smalltalk classes
#include "STBehavior.h"		// Need to look at class flags, and fixed fields
#include "STVirtualObject.h"
#include "STByteArray.h"

///////////////////////////////////////////////////////////////////////////////
// Use with care. Neither initialises new space, or cleans up old pointers
// which are sized away!!  Although this is a public function, since sometimes
// we don't need the ref. count adjustment and initialisation performed by the
// safer high-level resize() functions. Use of the latter is, however, encouraged.

#pragma auto_inline(off)

template <size_t Extra> POBJECT ObjectMemory::basicResize(POTE ote, size_t byteSize)
{
	ASSERT(!isIntegerObject(ote));
	POBJECT pObject;

/*	#ifdef _DEBUG
		TRACESTREAM<< L"Resizing ";
		Interpreter::printObject(Oop(ote), TRACESTREAM);
		TRACESTREAM<< L" (" << ote->m_location<< L") from size " << ObjectMemory::sizeOf(ote)<< L" to size " << byteSize<< L"\n";
	#endif
*/
	switch(ote->heapSpace())
	{
		case Spaces::Normal:
		{
//			TRACE("Resizing normal object...\n");
			pObject = ote->m_location;
			pObject = static_cast<POBJECT>(reallocChunk(pObject, byteSize+Extra));

			if (pObject)
			{
				ote->m_location = pObject;
				ote->setSize(byteSize);
			}
			break;
		}

		case Spaces::Virtual:
//			TRACE("Resizing virtual object...\n");
			pObject = resizeVirtual(ote, byteSize+Extra);
			break;
	
		default:
			// Not resizeable
			return nullptr;
	}

	#if defined(_DEBUG)
		if (abs(Interpreter::executionTrace) > 0)
			checkPools();
//		TRACESTREAM<< L"After Resize: ";
//		Interpreter::printObject(Oop(ote), TRACESTREAM);
//		TRACESTREAM<< L"\n";
	#endif

	return pObject;
}

// Resize an object in VirtualSpace (commit/decommit some memory)
// N.B. Assumes that there are no ref. counted object above shrinkTo (primarily intended for
// Process stacks)
POBJECT ObjectMemory::resizeVirtual(OTE* ote, size_t newByteSize)
{
	ASSERT(ote->heapSpace() == Spaces::Virtual);

	VariantObject* pObject = static_cast<VariantObject*>(ote->m_location);
	VirtualObject* pVObj = reinterpret_cast<VirtualObject*>(pObject);
	VirtualObjectHeader* pBase = pVObj->getHeader();
	size_t maxByteSize = pBase->getMaxAllocation(); maxByteSize;
	size_t currentTotalByteSize = pBase->getCurrentAllocation();
	ASSERT(_ROUND2(currentTotalByteSize, dwPageSize) == currentTotalByteSize);
	auto newTotalByteSize = _ROUND2(newByteSize + sizeof(VirtualObjectHeader), dwPageSize);
	// Minimum virtual allocation is one page (4k normally)
	ASSERT(newTotalByteSize >= dwPageSize);
	
	if (newTotalByteSize > currentTotalByteSize)
	{
		// The object is increasing in size - commit some more memory
		ASSERT(newByteSize <= maxByteSize);
		size_t allocSize = newTotalByteSize - currentTotalByteSize;
		ASSERT(_ROUND2(allocSize, dwPageSize) == allocSize);
		if (!::VirtualAlloc(reinterpret_cast<uint8_t*>(pBase) + currentTotalByteSize, allocSize, MEM_COMMIT, PAGE_READWRITE))
			return 0;	// Request to resize failed
	}
	else if (newTotalByteSize < currentTotalByteSize)
	{
		const Behavior* behavior = ote->m_oteClass->m_location; behavior;
		// The object is shrinking - decommit some memory
		ASSERT(newByteSize > (ObjectHeaderSize+behavior->fixedFields())*sizeof(Oop));

		auto pCeiling = reinterpret_cast<Oop*>(reinterpret_cast<uint8_t*>(pBase) + newTotalByteSize);

		// Determine the size of the committed region above shrinkTo
		MEMORY_BASIC_INFORMATION mbi;
		VERIFY(::VirtualQuery(pCeiling, &mbi, sizeof(mbi)) == sizeof(mbi));
		ASSERT(mbi.AllocationBase == pBase);
		if (mbi.State == MEM_COMMIT)
		{
			// Decommit memory above new ceiling
			VERIFY(::VirtualFree(pCeiling, mbi.RegionSize, MEM_DECOMMIT));
		}
	}
	
	// And resize the object as far as Smalltalk is concerned to the nearest page boundary
	// above and including shrinkTo
	//pBase->setCurrentAllocation(newTotalByteSize);
	ote->setSize(newByteSize);

	return pObject;
}

#pragma auto_inline(on)


///////////////////////////////////////////////////////////////////////////////
// Safe public resizing functions.

VariantByteObject* ObjectMemory::resize(BytesOTE* ote, size_t newByteSize)
{
	ASSERT(!ObjectMemoryIsIntegerObject(ote) && ote->isBytes());

	auto totalByteSize = newByteSize + SizeOfPointers(0);	// Add header size

	auto pByteObj = ote->m_location;
	auto oldByteSize = ote->getSize();

	if (ote->isNullTerminated())
	{
		pByteObj = reinterpret_cast<VariantByteObject*>(ObjectMemory::basicResize<NULLTERMSIZE>(reinterpret_cast<POTE>(ote), totalByteSize));
		ASSERT(pByteObj != nullptr);	// Null-terminated objects should always be resizeable
		__assume(pByteObj != nullptr);

		// Ensure we have a null-terminator
		*reinterpret_cast<NULLTERMTYPE*>(&pByteObj->m_fields[totalByteSize]) = 0;
	}
	else
		pByteObj = reinterpret_cast<VariantByteObject*>(ObjectMemory::basicResize<0>(reinterpret_cast<POTE>(ote), totalByteSize));

	if (pByteObj && totalByteSize > oldByteSize)
	{
		// The object grew, so ensure it is properly initialized
		memset(reinterpret_cast<uint8_t*>(pByteObj)+oldByteSize, 0, totalByteSize-oldByteSize);
	}

	return pByteObj;
}

VariantObject* ObjectMemory::resize(PointersOTE* ote, size_t newPointers, bool bRefCount)
{
	ASSERT(!ObjectMemoryIsIntegerObject(ote) && ote->isPointers());

	VariantObject* pObj = ote->m_location;
	const auto oldPointers = ote->pointersSize();

	// If resizing the active process, then we don't do any ref. counting as refs from
	// the current stack are not counted (we used deferred ref. counting)
	if (bRefCount)
	{
		for (auto i=newPointers;i<oldPointers;i++)
			countDown(pObj->m_fields[i]);
	}

	// Reallocate the object to the new size (bigger or smaller)
	pObj = reinterpret_cast<VariantObject*>(basicResize<0>(reinterpret_cast<POTE>(ote), SizeOfPointers(newPointers)));

	if (pObj)
	{
		ASSERT(newPointers == ote->pointersSize());
		newPointers = ote->pointersSize();

		// Initialize any new pointers to Nil (indices must fit in a SmallInteger)
		const Oop nil = Oop(Pointers.Nil);
		for (auto i=oldPointers; i<newPointers; i++)
			pObj->m_fields[i] = nil;
	}

	return pObj;
}


//POBJECT ObjectMemory::resize(OTE* ote, MWORD newSize)
//{
//	ASSERT(!ote->isImmutable());
//
//	POBJECT pNewBody;
//	if (ote->isPointers())
//	{
//		// Add fixed fields of class, so newSize is now VM word length excluding header
//		// Some objects may size with a granularity greater than one pointer, so we
//		// must ask the object what size it would like to be for the new requested size.
//		// This is all down by the sizeOfObjectFor() method
//
//		bool bCountDownRemoved = reinterpret_cast<OTE*>(Interpreter::actualActiveProcessPointer()) != ote;
//		pNewBody = resize(reinterpret_cast<PointersOTE*>(ote), 
//							sizeOfObjectFor(ote, newSize),
//							bCountDownRemoved);
//	}
//	else
//	{
//		pNewBody = resize(reinterpret_cast<BytesOTE*>(ote), newSize);
//	}
//
//	return pNewBody;
//}

