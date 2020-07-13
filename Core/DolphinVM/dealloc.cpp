/******************************************************************************

	File: Dealloc.cpp

	Description:

	Object Memory management class deallocation routines


******************************************************************************/

#include "Ist.h"
#include "ObjMem.h"
#include "Interprt.h"
#include "ObjMemPriv.inl"

// Smalltalk classes
#include "STVirtualObject.h"

#ifdef MEMSTATS
	extern size_t m_nLargeFreed;
#endif

#pragma code_seg(MEM_SEG)

///////////////////////////////////////////////////////////////////////////////
//	Methods


inline void ObjectMemory::releasePointer(OTE* ote)
{
	HARDASSERT(ote->m_count == 0);
	HARDASSERT(!ote->isFree());
	ote->beFree();

	ote->m_location = MakeNextFree(m_pFreePointerList);
	m_pFreePointerList = ote;

#ifdef TRACKFREEOTEs
	m_nFreeOTEs++;
#endif

	//HARDASSERT(m_nFreeOTEs == CountFreeOTEs());
}

///////////////////////////////////////////////////////////////////////////////
// Low-level memory chunk (not object) management routines
//
// These map directly onto C or Win32 heap

void ObjectMemory::freeChunk(POBJECT pObj)
{
#ifdef MEMSTATS
	++m_nLargeFreed;
#endif

	#ifdef PRIVATE_HEAP
		::HeapFree(m_hHeap, 0, pObj);
	#else
		free(pObj);
	#endif
}

///////////////////////////////////////////////////////////////////////////////
// Prevent inline expansion of this routine in private count down and elsewhere
//#pragma auto_inline(off)

void ObjectMemory::deallocate(OTE* ote)
{
	#ifdef _DEBUG
		ASSERT(!ote->isFree());
		if (Interpreter::executionTrace)
		{
			tracelock lock(TRACESTREAM);
			TRACESTREAM << ote<< L" (" << std::hex << (uintptr_t)ote<< L"), refs " << std::dec << (int)ote->m_count<< L", is being deallocated" << std::endl;
		}
	#endif

	ASSERT(!isPermanent(ote));
	// We can have up to 256 different destructors (8 bits)
	switch (ote->heapSpace())
	{
		case Spaces::Normal:
			freeChunk(ote->m_location);
 			releasePointer(ote);
			break;

		case Spaces::Virtual:
			::VirtualFree(static_cast<VirtualObject*>(ote->m_location)->getHeader(), 0, MEM_RELEASE);
 			releasePointer(ote);
			break;

		case Spaces::Blocks:
			Interpreter::m_otePools[static_cast<size_t>(Interpreter::Pools::Blocks)].deallocate(ote);
			break;

		case Spaces::Contexts:
			// Return it to the interpreter's free list of contexts
			Interpreter::m_otePools[static_cast<size_t>(Interpreter::Pools::Contexts)].deallocate(ote);
			break;

		case Spaces::Dwords:
			Interpreter::m_otePools[static_cast<size_t>(Interpreter::Pools::Dwords)].deallocate(ote);
			break;

		case Spaces::Heap:
			//_asm int 3;
			HARDASSERT(FALSE);
			break;
		
		case Spaces::Floats:
			Interpreter::m_otePools[static_cast<size_t>(Interpreter::Pools::Floats)].deallocate(ote);
			break;

		case Spaces::Pools:
		{
			size_t size = ote->sizeOf();
			HARDASSERT(size <= MaxSmallObjectSize);
			freeSmallChunk(ote->m_location, size);
			releasePointer(ote);
		}
		break;

		default:
			ASSERT(false);
			__assume(false);
	}
}


// Return to default setting
//#pragma auto_inline(on)

#pragma code_seg(GC_SEG)

// Free up a pool of objects maintained by the interpreter on request
void ObjectMemory::OTEPool::clear()
{
	#ifdef MEMSTATS
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM<< L"OTEPool(" << this<< L") before clear, " << std::dec << m_nAllocated<< L" allocated, " 
			<< m_nFree<< L" free" << std::endl;
	}
	#endif

	while (m_pFreeList)
	{
		OTE* ote = m_pFreeList;
		ote->beAllocated();
		
		// All objects on the free list originated from pool space, so we need to
		// send them back there
		ote->m_flags.m_space = static_cast<space_t>(Spaces::Pools);

		VariantObject* pObj = static_cast<VariantObject*>(ote->m_location);
		m_pFreeList = reinterpret_cast<OTE*>(pObj->m_fields[0]);
		ObjectMemory::deallocate(ote);
	}

	#ifdef MEMSTATS
	{
		ASSERT(m_nFree <= m_nAllocated);
		m_nAllocated -= m_nFree;
		m_nFree = 0;
		tracelock lock(TRACESTREAM);
		TRACESTREAM<< L"OTEPool(" << this<< L") after clear, " << std::dec << m_nAllocated<< L" allocated" << std::endl;
	}
	#endif
}
