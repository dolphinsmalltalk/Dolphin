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
//	if (!m_pFreePointerList)
//		_asm int 3;

	ote->m_location = reinterpret_cast<POBJECT>(m_pFreePointerList);
	m_pFreePointerList = ote;

#ifdef _DEBUG
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
		::HeapFree(m_hHeap, HEAP_NO_SERIALIZE, pObj);
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
		case OTEFlags::NormalSpace:
			freeChunk(ote->m_location);
 			releasePointer(ote);
			break;

		case OTEFlags::VirtualSpace:
			::VirtualFree(static_cast<VirtualObject*>(ote->m_location)->getHeader(), 0, MEM_RELEASE);
 			releasePointer(ote);
			break;

		case OTEFlags::BlockSpace:
			Interpreter::m_otePools[Interpreter::BLOCKPOOL].deallocate(ote);
			break;

		case OTEFlags::ContextSpace:
			// Return it to the interpreter's free list of contexts
			Interpreter::m_otePools[Interpreter::CONTEXTPOOL].deallocate(ote);
			break;

		case OTEFlags::DWORDSpace:
			Interpreter::m_otePools[Interpreter::DWORDPOOL].deallocate(ote);
			break;

		case OTEFlags::HeapSpace:
			//_asm int 3;
			HARDASSERT(FALSE);
			break;
		
		case OTEFlags::FloatSpace:
			Interpreter::m_otePools[Interpreter::FLOATPOOL].deallocate(ote);
			break;

		case OTEFlags::PoolSpace:
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
		ote->m_flags.m_space = OTEFlags::PoolSpace;

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
