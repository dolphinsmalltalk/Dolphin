/******************************************************************************

	File: Alloc.cpp

	Description:

	Object Memory management allocation/coping routines

******************************************************************************/

#include "Ist.h"

#pragma code_seg(MEM_SEG)

#include "ObjMem.h"
#include "ObjMemPriv.inl"
#include "Interprt.h"

#ifdef DOWNLOADABLE
#include "downloadableresource.h"
#else
#include "rc_vm.h"
#endif

#ifdef MEMSTATS
	extern unsigned m_nLargeAllocated;
	extern unsigned m_nSmallAllocated;
#endif

// Smalltalk classes
#include "STVirtualObject.h"
#include "STByteArray.h"

// No auto-inlining in this module please
#pragma auto_inline(off)

//MWORD ObjectMemory::MaxSizeOfPoolObject;
//int ObjectMemory::NumPools;
ObjectMemory::FixedSizePool	ObjectMemory::m_pools[MaxPools];
ObjectMemory::FixedSizePool::Link* ObjectMemory::FixedSizePool::m_pFreePages;
void** ObjectMemory::FixedSizePool::m_pAllocations;
unsigned ObjectMemory::FixedSizePool::m_nAllocations;

///////////////////////////////////////////////////////////////////////////////
// Public object allocation routines

// Rarely used, so don't inline it
POBJECT ObjectMemory::allocLargeObject(MWORD objectSize, OTE*& ote)
{
#ifdef MEMSTATS
	++m_nLargeAllocated;
#endif

	POBJECT pObj = static_cast<POBJECT>(allocChunk(_ROUND2(objectSize, sizeof(DWORD))));

	// allocateOop expects crit section to be used
	ote = allocateOop(pObj);
	ote->setSize(objectSize);
	ote->m_flags.m_space = OTEFlags::NormalSpace;
	return pObj;
}

inline POBJECT ObjectMemory::allocObject(MWORD objectSize, OTE*& ote)
{
	// Callers are expected to round requests to DWORD granularity
	if (objectSize > MaxSmallObjectSize)
		return allocLargeObject(objectSize, ote);

	// Smallblock heap already has space for object size at start of obj which includes
	// heap overhead,etc, and is rounded to a paragraph size
	// Why not alloc. four bytes less, overwrite this size with our object size, and then
	// move back the object body pointer by four. On delete need to reapply the object
	// size back into the object? - No wouldn't work because of the way heap accesses
	// adjoining objects when freeing!

	POBJECT pObj = static_cast<POBJECT>(allocSmallChunk(objectSize));
	ote = allocateOop(pObj);
	ote->setSize(objectSize);
	ASSERT(ote->heapSpace() == OTEFlags::PoolSpace);
	return pObj;
}


///////////////////////////////////////////////////////////////////////////////
// Object copying (mostly allocation)


PointersOTE* __fastcall ObjectMemory::shallowCopy(PointersOTE* ote)
{
	ASSERT(!ote->isBytes());

	// A pointer object is a bit more tricky to copy (but not much)
	VariantObject* obj = ote->m_location;
	BehaviorOTE* classPointer = ote->m_oteClass;

	PointersOTE* copyPointer;
	MWORD size;

	if (ote->heapSpace() == OTEFlags::VirtualSpace)
	{
		Interpreter::resizeActiveProcess();

		//size = obj->PointerSize();
		size = ote->pointersSize();

		VirtualObject* pVObj = reinterpret_cast<VirtualObject*>(obj);
		VirtualObjectHeader* pBase = pVObj->getHeader();
		unsigned maxByteSize = pBase->getMaxAllocation();
		unsigned currentTotalByteSize = pBase->getCurrentAllocation();

		VirtualOTE* virtualCopy = ObjectMemory::newVirtualObject(classPointer,
			currentTotalByteSize / sizeof(MWORD),
			maxByteSize / sizeof(MWORD));

		pVObj = virtualCopy->m_location;
		pBase = pVObj->getHeader();
		ASSERT(pBase->getMaxAllocation() == maxByteSize);
		ASSERT(pBase->getCurrentAllocation() == currentTotalByteSize);
		virtualCopy->setSize(ote->getSize());

		copyPointer = reinterpret_cast<PointersOTE*>(virtualCopy);
	}
	else
	{
		//size = obj->PointerSize();
		size = ote->pointersSize();
		copyPointer = newPointerObject(classPointer, size);
	}

	// Now copy over all the fields
	VariantObject* copy = copyPointer->m_location;
	ASSERT(copyPointer->pointersSize() == size);
	for (unsigned i = 0; i<size; i++)
	{
		copy->m_fields[i] = obj->m_fields[i];
		countUp(obj->m_fields[i]);
	}
	return copyPointer;
}

Oop* __fastcall Interpreter::primitiveShallowCopy(Oop* const sp)
{
	OTE* receiver = reinterpret_cast<OTE*>(*sp);
	ASSERT(!isIntegerObject(receiver));

	OTE* copy = receiver->m_flags.m_pointer
		? (OTE*)ObjectMemory::shallowCopy(reinterpret_cast<PointersOTE*>(receiver))
		: (OTE*)ObjectMemory::shallowCopy(reinterpret_cast<BytesOTE*>(receiver));
	*sp = (Oop)copy;
	ObjectMemory::AddToZct(copy);
	return sp;
}

///////////////////////////////////////////////////////////////////////////////
// Public object Instantiation (see also Objmem.h)
//
// These methods return Oops rather than OTE*'s because we want the type to be
// opaque to external users, and to be interchangeable with MWORDs.
//

Oop* __fastcall Interpreter::primitiveNewFromStack(Oop* sp)
{
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*(sp - 1));

	Oop oopArg = (*sp);
	SMALLINTEGER count;
	if (isIntegerObject(oopArg) && (count = ObjectMemoryIntegerValueOf(oopArg)) >= 0)
	{
		// Note that instantiateClassWithPointers counts up the class,
		PointersOTE* oteObj = ObjectMemory::newUninitializedPointerObject(oteClass, count);
		VariantObject* obj = oteObj->m_location;

		sp = sp - count - 1;
		while (--count >= 0)
		{
			Oop oopArg = *(sp + count);
			ObjectMemory::countUp(oopArg);
			obj->m_fields[count] = oopArg;
		}

		// Save down SP in case ZCT is reconciled on adding result
		m_registers.m_stackPointer = sp;
		*sp = reinterpret_cast<Oop>(oteObj);
		ObjectMemory::AddToZct((OTE*)oteObj);
		return sp;
	}
	else
	{
		return primitiveFailure(0);
	}
}

Oop* __fastcall Interpreter::primitiveNewInitializedObject(Oop* sp, unsigned argCount)
{
	Oop oopReceiver = *(sp - argCount);
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(oopReceiver);
	InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;

	if ((instSpec.m_value & (InstanceSpecification::PointersMask | InstanceSpecification::NonInstantiableMask)) == InstanceSpecification::PointersMask)
	{
		size_t minSize = instSpec.m_fixedFields;
		size_t i;
		if (instSpec.m_indexable)
		{
			i = max(minSize, argCount);
		}
		else
		{
			if (argCount > minSize)
			{
				// Not indexable, and too many fields
				return primitiveFailure(2);
			}
			i = minSize;
		}

		// Note that instantiateClassWithPointers counts up the class,
		PointersOTE* oteObj = ObjectMemory::newUninitializedPointerObject(oteClass, i);
		VariantObject* obj = oteObj->m_location;

		// nil out any extra fields
		const Oop nil = reinterpret_cast<Oop>(Pointers.Nil);
		while (i > argCount)
		{
			obj->m_fields[--i] = nil;
		}

		while (i != 0)
		{
			i--;
			Oop oopArg = *sp--;
			ObjectMemory::countUp(oopArg);
			obj->m_fields[i] = oopArg;
		}

		// Save down SP in case ZCT is reconciled on adding result, allowing unref'd args to be reclaimed
		m_registers.m_stackPointer = sp;
		*sp = reinterpret_cast<Oop>(oteObj);
		ObjectMemory::AddToZct((OTE*)oteObj);
		return sp;
	}
	else
	{
		return primitiveFailure(instSpec.m_nonInstantiable ? 1 : 0);
	}
}

Oop* __fastcall Interpreter::primitiveNew(Oop* const sp)
{
	// This form of C code results in something very close to the hand-coded assembler original for primitiveNew

	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*sp);
	InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;
	if (!(instSpec.m_indexable || instSpec.m_nonInstantiable))
	{
		PointersOTE* newObj = ObjectMemory::newPointerObject(oteClass, instSpec.m_fixedFields);
		*sp = reinterpret_cast<Oop>(newObj);
		ObjectMemory::AddToZct((OTE*)newObj);
		return sp;
	}
	else
	{
		return primitiveFailure(instSpec.m_nonInstantiable ? 1 : 0);
	}
}

Oop* __fastcall Interpreter::primitiveNewWithArg(Oop* const sp)
{
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*(sp - 1));
	Oop oopArg = (*sp);
	// Unfortunately the compiler can't be persuaded to perform this using just the sar and conditional jumps on no-carry and signed;
	// it generates both the bit test and the shift.
	SMALLINTEGER size;
	if (isIntegerObject(oopArg) && (size = ObjectMemoryIntegerValueOf(oopArg)) >= 0)
	{
		InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;
		if ((instSpec.m_value & (InstanceSpecification::IndexableMask | InstanceSpecification::NonInstantiableMask)) == InstanceSpecification::IndexableMask)
		{
			if (instSpec.m_pointers)
			{
				PointersOTE* newObj = ObjectMemory::newPointerObject(oteClass, size + instSpec.m_fixedFields);
				*(sp - 1) = reinterpret_cast<Oop>(newObj);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObj));
				return sp - 1;
			}
			else
			{
				BytesOTE* newObj = ObjectMemory::newByteObject(oteClass, size);
				*(sp - 1) = reinterpret_cast<Oop>(newObj);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObj));
				return sp - 1;
			}
		}
		else
		{
			// Not indexable, or non-instantiable
			return primitiveFailure(instSpec.m_nonInstantiable ? 1 : 2);
		}
	}
	else
	{
		return primitiveFailure(0);	// Size must be positive SmallInteger
	}
}

PointersOTE* __fastcall ObjectMemory::newPointerObject(BehaviorOTE* classPointer)
{
	ASSERT(isBehavior(Oop(classPointer)));
	return newPointerObject(classPointer, classPointer->m_location->fixedFields());
}

PointersOTE* __fastcall ObjectMemory::newPointerObject(BehaviorOTE* classPointer, MWORD oops)
{
	PointersOTE* ote = newUninitializedPointerObject(classPointer, oops);

	// Initialise the fields to nils
	const Oop nil = Oop(Pointers.Nil);		// Loop invariant (otherwise compiler reloads each time)
	VariantObject* pLocation = ote->m_location;
#ifdef _M_IX86
	__stosd(reinterpret_cast<DWORD*>(pLocation->m_fields), nil, oops);
#else
	const MWORD loopEnd = oops;
	for (MWORD i = 0; i<loopEnd; i++)
		pLocation->m_fields[i] = nil;
#endif
	ASSERT(ote->isPointers());

	return reinterpret_cast<PointersOTE*>(ote);
}

PointersOTE* __fastcall ObjectMemory::newUninitializedPointerObject(BehaviorOTE* classPointer, MWORD oops)
{
	// Total size must fit in a DWORD bits
	ASSERT(oops < ((DWORD(1) << 30) - ObjectHeaderSize));

	// Don't worry, compiler will not really use multiply instruction here
	MWORD objectSize = SizeOfPointers(oops);
	OTE* ote;
	allocObject(objectSize, ote);
	ASSERT((objectSize > MaxSizeOfPoolObject && ote->heapSpace() == OTEFlags::NormalSpace)
			|| ote->heapSpace() == OTEFlags::PoolSpace);

	// These are stored in the object itself
	ASSERT(ote->getSize() == objectSize);
	classPointer->countUp();
	ote->m_oteClass = classPointer;

	// DO NOT Initialise the fields to nils

	ASSERT(ote->isPointers());
	
	return reinterpret_cast<PointersOTE*>(ote);
}

BytesOTE* __fastcall ObjectMemory::newByteObject(BehaviorOTE* classPointer, MWORD byteSize)
{
	Behavior& byteClass = *classPointer->m_location;
	int nullTerm = byteClass.m_instanceSpec.m_nullTerminated;

	// Don't worry, compiler will not really use multiply instruction here
	MWORD objectSize = byteSize + nullTerm;

	OTE* ote;
	VariantByteObject* newBytes = static_cast<VariantByteObject*>(allocObject(objectSize+SizeOfPointers(0), ote));
	ASSERT((objectSize > MaxSizeOfPoolObject && ote->heapSpace() == OTEFlags::NormalSpace)
		|| ote->heapSpace() == OTEFlags::PoolSpace);

	// Byte objects are initialized to zeros (but not the header)
	// Note that we round up to initialize to the next DWORD
	// This can be useful when working on a 32-bit word machine
	ZeroMemory(newBytes->m_fields, _ROUND2(objectSize, sizeof(DWORD)));

	ASSERT(ote->getSize()== objectSize+SizeOfPointers(0));

	// These are stored in the object itself
	classPointer->countUp();
	ote->m_oteClass = classPointer;

	if (nullTerm)
	{
		ote->beNullTerminated();
		HARDASSERT(ote->isBytes());
	}
	else
	{
		ote->beBytes();
	}

	return reinterpret_cast<BytesOTE*>(ote);
}

Oop* __fastcall Interpreter::primitiveNewPinned(Oop* const sp)
{
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*(sp - 1));
	Oop oopArg = (*sp);
	SMALLINTEGER size;
	if (isIntegerObject(oopArg) && (size = ObjectMemoryIntegerValueOf(oopArg)) >= 0)
	{
		InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;
		if (!(instSpec.m_pointers || instSpec.m_nonInstantiable))
		{
			BytesOTE* newObj = ObjectMemory::newByteObject(oteClass, size);
			*(sp - 1) = reinterpret_cast<Oop>(newObj);
			ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObj));
			return sp - 1;
		}
		else
		{
			// Not indexable, or non-instantiable
			return primitiveFailure(instSpec.m_nonInstantiable ? 1 : 2);
		}
	}
	else
	{
		return primitiveFailure(0);	// Size must be positive SmallInteger
	}
}


BytesOTE* __fastcall ObjectMemory::newUninitializedByteObject(BehaviorOTE* classPointer, MWORD byteSize)
{
	int nullTerm = classPointer->m_location->m_instanceSpec.m_nullTerminated;

	MWORD objectSize = byteSize + nullTerm;

	OTE* ote;
	POBJECT newBytes= static_cast<POBJECT>(allocObject(objectSize+SizeOfPointers(0), ote));
	ASSERT((objectSize > MaxSizeOfPoolObject && ote->heapSpace() == OTEFlags::NormalSpace)
		|| ote->heapSpace() == OTEFlags::PoolSpace);

	// These are stored in the object itself
	ASSERT(ote->getSize() == objectSize+SizeOfPointers(0)); newBytes;
	ote->m_oteClass = classPointer;	// Ref. counting done later if necessary
	ote->beBytes();

	if (nullTerm)
		ote->beNullTerminated();

	return reinterpret_cast<BytesOTE*>(ote);
}


BytesOTE* __fastcall ObjectMemory::shallowCopy(BytesOTE* ote)
{
	ASSERT(ote->isBytes());

	// Copying byte objects is simple and fast
	VariantByteObject& bytes = *ote->m_location;
	BehaviorOTE* classPointer = ote->m_oteClass;
	MWORD objectSize = ote->sizeOf();

	OTE* copyPointer;
	// Allocate an uninitialized object ...
	VariantByteObject* pLocation = static_cast<VariantByteObject*>(allocObject(objectSize, copyPointer));
	ASSERT((objectSize > MaxSizeOfPoolObject && copyPointer->heapSpace() == OTEFlags::NormalSpace)
		|| copyPointer->heapSpace() == OTEFlags::PoolSpace);

	ASSERT(copyPointer->getSize() == objectSize);
	// This set does not want to copy over the immutability bit - i.e. even if the original was immutable, the 
	// copy will never be.
	copyPointer->setSize(ote->getSize());
	copyPointer->m_dwFlags = (copyPointer->m_dwFlags & ~OTEFlags::WeakMask) | (ote->m_dwFlags & OTEFlags::WeakMask);
	ASSERT(copyPointer->isBytes());
	copyPointer->m_oteClass = classPointer;
	classPointer->countUp();

	// Copy the entire object over the other one, including any null terminator and object header
	memcpy(pLocation, &bytes, objectSize);

	return reinterpret_cast<BytesOTE*>(copyPointer);
}


///////////////////////////////////////////////////////////////////////////////
// Virtual object space allocation

// Answer a new process with an initial stack size specified by the first argument, and a maximum
// stack size specified by the second argument.
Oop* __fastcall Interpreter::primitiveNewVirtual(Oop* const sp)
{
	Oop maxArg = *sp;
	SMALLINTEGER maxSize;
	if (ObjectMemoryIsIntegerObject(maxArg) && (maxSize = ObjectMemoryIntegerValueOf(maxArg)) >= 0)
	{
		Oop initArg = *(sp - 1);
		SMALLINTEGER initialSize;
		if (ObjectMemoryIsIntegerObject(initArg) && (initialSize = ObjectMemoryIntegerValueOf(initArg)) >= 0)
		{
			BehaviorOTE* receiverClass = reinterpret_cast<BehaviorOTE*>(*(sp - 2));
			InstanceSpecification instSpec = receiverClass->m_location->m_instanceSpec;
			if (instSpec.m_indexable && !instSpec.m_nonInstantiable)
			{
				unsigned fixedFields = instSpec.m_fixedFields;
				VirtualOTE* newObject = ObjectMemory::newVirtualObject(receiverClass, initialSize + fixedFields, maxSize + fixedFields);
				*(sp - 2) = reinterpret_cast<Oop>(newObject);
				// No point saving down SP before potential Zct reconcile as the init & max args must be SmallIntegers
				ObjectMemory::AddToZct((OTE*)newObject);
				return sp - 2;
			}
			else
			{
				return primitiveFailure(instSpec.m_nonInstantiable ? 3 : 2);	// Non-indexable or abstract class
			}
		}
		else
		{
			return primitiveFailure(1);	// initialSize arg not a SmallInteger
		}
	}
	else
	{
		return primitiveFailure(0);	// maxsize arg not a SmallInteger
	}
}

/*
	Allocate a new virtual object from virtual space, which can grow up to maxBytes (including the
	virtual allocation overhead) but which has an initial size of initialBytes (NOT including the
	virtual allocation overhead). Should the allocation request fail, then a memory exception is 
	generated.
*/
MWORD* __stdcall AllocateVirtualSpace(MWORD maxBytes, MWORD initialBytes)
{
	unsigned reserveBytes = _ROUND2(maxBytes + dwPageSize, dwAllocationGranularity);
	ASSERT(reserveBytes % dwAllocationGranularity == 0);
	VirtualObjectHeader* pLocation;
	
	pLocation = static_cast<VirtualObjectHeader*>(::VirtualAlloc(NULL, reserveBytes, MEM_RESERVE, PAGE_NOACCESS));
	if (!pLocation)
		// This is continuable
		::RaiseException(STATUS_NO_MEMORY, 0, 0, NULL);

	#ifdef _DEBUG
		// Let's see whether we got the rounding correct!
		MEMORY_BASIC_INFORMATION mbi;
		VERIFY(::VirtualQuery(pLocation, &mbi, sizeof(mbi)) == sizeof(mbi));
		ASSERT(mbi.AllocationBase == pLocation);
		ASSERT(mbi.BaseAddress == pLocation);
	ASSERT(mbi.AllocationProtect == PAGE_NOACCESS);
	//	ASSERT(mbi.Protect == PAGE_NOACCESS);
		ASSERT(mbi.RegionSize == reserveBytes);
		ASSERT(mbi.State == MEM_RESERVE);
		ASSERT(mbi.Type == MEM_PRIVATE);
	#endif

	// We expect the initial byte size to be a integral number of pages, and it must also take account
	// of the virtual allocation overhead (currently 4 bytes)
	initialBytes = _ROUND2(initialBytes + sizeof(VirtualObjectHeader), dwPageSize);
	ASSERT(initialBytes % dwPageSize == 0);

	// Note that VirtualAlloc initializes the committed memory to zeroes.
	pLocation = static_cast<VirtualObjectHeader*>(::VirtualAlloc(pLocation, initialBytes, MEM_COMMIT, PAGE_READWRITE));
	if (!pLocation)
		// This is also continuable
		::RaiseException(STATUS_NO_MEMORY, 0, 0, NULL);

	#ifdef _DEBUG
		// Let's see whether we got the rounding correct!
		VERIFY(::VirtualQuery(pLocation, &mbi, sizeof(mbi)) == sizeof(mbi));
		ASSERT(mbi.AllocationBase == pLocation);
		ASSERT(mbi.BaseAddress == pLocation);
		ASSERT(mbi.AllocationProtect == PAGE_NOACCESS);
		ASSERT(mbi.Protect == PAGE_READWRITE);
		ASSERT(mbi.RegionSize == initialBytes);
		ASSERT(mbi.State == MEM_COMMIT);
		ASSERT(mbi.Type == MEM_PRIVATE);
	#endif

	// Use first slot to hold the maximum size for the object
	pLocation->setMaxAllocation(maxBytes);
	return reinterpret_cast<MWORD*>(pLocation+1);
}

// N.B. Like the other instantiate methods in ObjectMemory, this method for instantiating
// objects in virtual space (used for allocating Processes, for example), does not adjust
// the ref. count of the class, because this is often unecessary, and does not adjust the
// sizes to allow for fixed fields - callers must do this
VirtualOTE* ObjectMemory::newVirtualObject(BehaviorOTE* classPointer, MWORD initialSize, MWORD maxSize)
{
	#ifdef _DEBUG
	{
		ASSERT(isBehavior(Oop(classPointer)));
		Behavior& behavior = *classPointer->m_location;
		ASSERT(behavior.isIndexable());
	}
	#endif

	// Trim the sizes to acceptable bounds
	if (initialSize <= dwOopsPerPage)
		initialSize = dwOopsPerPage;
	else
		initialSize = _ROUND2(initialSize, dwOopsPerPage);

	if (maxSize < initialSize)
		maxSize = initialSize;
	else
		maxSize = _ROUND2(maxSize, dwOopsPerPage);

	// We have to allow for the virtual allocation overhead. The allocation function will add in
	// space for this. The maximum size should include this, the initial size should not
	initialSize -= sizeof(VirtualObjectHeader)/sizeof(MWORD);

	unsigned byteSize = initialSize*sizeof(MWORD);
	VariantObject* pLocation = reinterpret_cast<VariantObject*>(AllocateVirtualSpace(maxSize * sizeof(MWORD), byteSize));

	// No need to alter ref. count of process class, as it is sticky

	// Fill space with nils for initial values
	const Oop nil = Oop(Pointers.Nil);
	
#ifdef _M_IX86
	__stosd(reinterpret_cast<DWORD*>(pLocation->m_fields), nil, initialSize);
#else
	const unsigned loopEnd = initialSize;
	for (unsigned i = 0; i< loopEnd; i++)
		pLocation->m_fields[i] = nil;
#endif

	// All of the above doesn't touch any shared static member vars
//	EnterCritSection();

	OTE* ote = ObjectMemory::allocateOop(static_cast<POBJECT>(pLocation));
	ote->setSize(byteSize);
	ote->m_oteClass = classPointer;
	classPointer->countUp();
	ote->m_flags = m_spaceOTEBits[OTEFlags::VirtualSpace];
	ASSERT(ote->isPointers());

//	ExitCritSection();

	return reinterpret_cast<VirtualOTE*>(ote);
}

///////////////////////////////////////////////////////////////////////////////
// Low-level memory chunk (not object) management routines
//
void ObjectMemory::FixedSizePool::morePages()
{
	const int nPages = dwAllocationGranularity / dwPageSize;
	UNREFERENCED_PARAMETER(nPages);
	ASSERT(dwPageSize*nPages == dwAllocationGranularity);

	BYTE* pStart = static_cast<BYTE*>(::VirtualAlloc(NULL, dwAllocationGranularity, MEM_COMMIT, PAGE_READWRITE));
	if (!pStart)
		::RaiseException(STATUS_NO_MEMORY, EXCEPTION_NONCONTINUABLE, 0, NULL);	// Fatal - we must exit Dolphin

	#ifdef _DEBUG
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM << "FixedSizePool: new pages @ " << LPVOID(pStart) << endl;
	}
	#endif

	// Put the allocation (64k) into the allocation list so we can free it later
	{
		m_nAllocations++;
		m_pAllocations = static_cast<void**>(realloc(m_pAllocations, m_nAllocations*sizeof(void*)));
		m_pAllocations[m_nAllocations-1] = pStart;
	}

	// We don't know whether the chunks are to contain zeros or nils, so we don't bother to init the space
	#ifdef _DEBUG
		memset(pStart, 0xCD, dwAllocationGranularity);
	#endif

	BYTE* pLast = pStart + dwAllocationGranularity - dwPageSize;

	#ifdef _DEBUG
		// ASSERT that pLast is correct by causing a GPF if it isn't!
		memset(reinterpret_cast<BYTE*>(pLast), 0xCD, dwPageSize);
	#endif

	for (BYTE* p = pStart; p < pLast; p += dwPageSize)
		reinterpret_cast<Link*>(p)->next = reinterpret_cast<Link*>(p + dwPageSize);

	reinterpret_cast<Link*>(pLast)->next = 0;
	m_pFreePages = reinterpret_cast<Link*>(pStart);

	#ifdef _DEBUG
	//		m_nPages++;
	#endif
}

inline BYTE* ObjectMemory::FixedSizePool::allocatePage()
{
	if (!m_pFreePages)
	{
		morePages();
		ASSERT(m_pFreePages);
	}

	Link* pPage = m_pFreePages;
	m_pFreePages = pPage->next;
	
	return reinterpret_cast<BYTE*>(pPage);
}

// Allocate another page for a fixed size pool
void ObjectMemory::FixedSizePool::moreChunks()
{
	const int nOverhead = 0;//12;
	const int nBlockSize = dwPageSize - nOverhead;
	const int nChunks = nBlockSize / m_nChunkSize;

	BYTE* pStart = allocatePage();

	#ifdef _DEBUG
		if (abs(Interpreter::executionTrace) > 0)
		{
			tracelock lock(TRACESTREAM);
			TRACESTREAM << "FixedSizePool(" << this 
				<< " new page @ " << pStart 
				<< " (" << m_nPages << " pages of " 
				<< nChunks <<" chunks of "
				<< m_nChunkSize <<" bytes, total waste "
				<< m_nPages*(nBlockSize-(nChunks*m_nChunkSize)) << ')' << endl;
		}
		memset(pStart, 0xCD, nBlockSize);
	#else
		// We don't know whether the chunks are to contain zeros or nils, so we don't bother to init the space
	#endif

	BYTE* pLast = &pStart[(nChunks-1) * m_nChunkSize];

	#ifdef _DEBUG
		// ASSERT that pLast is correct by causing a GPF if it isn't!
		memset(static_cast<BYTE*>(pLast), 0xCD, m_nChunkSize);
	#endif

	const unsigned chunkSize = m_nChunkSize;			// Loop invariant
	for (BYTE* p = pStart; p < pLast; p += chunkSize)
		reinterpret_cast<Link*>(p)->next = reinterpret_cast<Link*>(p + chunkSize);

	reinterpret_cast<Link*>(pLast)->next = 0;
	m_pFreeChunks = reinterpret_cast<Link*>(pStart);

	#ifdef _DEBUG
		m_nPages++;
		m_pages = static_cast<void**>(realloc(m_pages, m_nPages*sizeof(void*)));
		m_pages[m_nPages-1] = pStart;
	#endif
}

void ObjectMemory::FixedSizePool::setSize(unsigned nChunkSize)
{
	m_nChunkSize = nChunkSize;
// Must be on 4 byte boundaries
	ASSERT(m_nChunkSize % PoolGranularity == 0);
	ASSERT(m_nChunkSize >= MinObjectSize);
//	m_dwPageUsed = (dwPageSize / m_nChunkSize) * m_nChunkSize;
}

inline ObjectMemory::FixedSizePool::FixedSizePool(unsigned nChunkSize) : m_pFreeChunks(0)
#ifdef _DEBUG
	, m_pages(0), m_nPages(0)
#endif
{
	setSize(nChunkSize);
}

//#ifdef NDEBUG
//	#pragma auto_inline(on)
//#endif

inline POBJECT ObjectMemory::reallocChunk(POBJECT pChunk, MWORD newChunkSize)
{
	#ifdef PRIVATE_HEAP
		return static_cast<POBJECT>(::HeapReAlloc(m_hHeap, HEAP_NO_SERIALIZE, pChunk, newChunkSize));
	#else
		void *oldPointer = pChunk;
		void *newPointer = realloc(pChunk, newChunkSize);
		_ASSERT(newPointer);
		if (NULL == newPointer)
			free(oldPointer);
		return newPointer;
	#endif
}


#ifdef MEMSTATS
	void ObjectMemory::OTEPool::DumpStats()
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM << "OTEPool(" << this << "): total " << dec << m_nAllocated <<", free " << m_nFree << endl;
	}

	static _CrtMemState CRTMemState;
	void ObjectMemory::DumpStats()
	{
		tracelock lock(TRACESTREAM);

		TRACESTREAM << endl << "Object Memory Statistics:" << endl
			<< "------------------------------" << endl;

		CheckPoint();
		_CrtMemDumpStatistics(&CRTMemState);

#ifdef _DEBUG
		checkPools();
#endif

		TRACESTREAM << endl << "Pool Statistics:" << endl
			  << "------------------" << endl << dec
			  << NumPools << " pools in the interval ("
			  << m_pools[0].getSize() << " to: "
			  << m_pools[NumPools-1].getSize() << " by: "
			  << PoolGranularity << ')' << endl << endl;

		int pageWaste=0;
		int totalPages=0;
		int totalFreeBytes=0;
		int totalChunks=0;
		int totalFreeChunks=0;
		for (int i=0;i<NumPools;i++)
		{
			int nSize = m_pools[i].getSize();
			int perPage = dwPageSize/nSize;
			int wastePerPage = dwPageSize - (perPage*nSize);
			int nPages = m_pools[i].getPages();
			int nChunks = perPage*nPages;
			int waste = nPages*wastePerPage;
			int nFree = m_pools[i].getFree();
			TRACE("%d: size %d, %d objects on %d pgs (%d per pg, %d free), waste %d (%d per page)\n",
				i, nSize, nChunks-nFree, nPages, perPage, nFree, waste, wastePerPage);
			totalChunks += nChunks;
			pageWaste += waste;
			totalPages += nPages;
			totalFreeBytes += nFree*nSize;
			totalFreeChunks += nFree;
		}

		int objectWaste = 0;
		int totalObjects = 0;
		const OTE* pEnd = m_pOT+m_nOTSize;
		for (OTE* ote=m_pOT; ote < pEnd; ote++)
		{
			if (!ote->isFree())
			{
				totalObjects++;
				if (ote->heapSpace() == OTEFlags::PoolSpace)
				{
					int size = ote->sizeOf();
					int chunkSize = _ROUND2(size, PoolGranularity);
					objectWaste += chunkSize - size;
				}
			}
		}

		int wastePercentage = (totalChunks - totalFreeChunks) == 0 
								? 0 
								: int(double(objectWaste)/
										double(totalChunks-totalFreeChunks)*100.0);

		TRACESTREAM << "===============================================" << endl;
		TRACE("Total objects	= %d\n"
			  "Total pool objs	= %d\n"
			  "Total chunks		= %d\n"
			  "Total Pages		= %d\n"
			  "Total Allocs		= %d\n"
			  "Total allocated	= %d\n"
			  "Page Waste		= %d bytes\n"
			  "Object Waste		= %d bytes (avg 0.%d)\n"
			  "Total Waste		= %d\n"
			  "Total free chks	= %d\n"
			  "Total Free		= %d bytes\n",
				totalObjects,
				totalChunks-totalFreeChunks,
				totalChunks,
				totalPages, 
				FixedSizePool::m_nAllocations,
				totalPages*dwPageSize, 
				pageWaste, 
				objectWaste, wastePercentage,
				pageWaste+objectWaste,
				totalFreeChunks,
				totalFreeBytes);
	}

	void ObjectMemory::CheckPoint()
	{
		_CrtMemCheckpoint(&CRTMemState);
	}

	int ObjectMemory::FixedSizePool::getFree()
	{
		Link* pChunk = m_pFreeChunks; 
		int tally = 0;
		while (pChunk)
		{
			tally++;
			pChunk = pChunk->next;
		}
		return tally;
	}
#endif

#if defined(_DEBUG)
	#include <crtdbg.h>

	bool ObjectMemory::FixedSizePool::isMyChunk(void* pChunk)
	{
		const unsigned loopEnd = m_nPages;
		for (unsigned i=0;i<loopEnd;i++)
		{
			void* pPage = m_pages[i];
			if (pChunk >= pPage && static_cast<BYTE*>(pChunk) <= (static_cast<BYTE*>(pPage)+dwPageSize))
				return true;
		}
		return false;
	}

	bool ObjectMemory::FixedSizePool::isValid()
	{
		Link* pChunk = m_pFreeChunks; 
		while (pChunk)
		{
			if (!isMyChunk(pChunk))
				return false;
			pChunk = pChunk->next;
		}
		return true;
	}

#endif

