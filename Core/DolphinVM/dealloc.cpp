/******************************************************************************

	File: Dealloc.cpp

	Description:

	Object Memory management class deallocation routines


******************************************************************************/

#include "Ist.h"
#include "ObjMem.h"
#include "Interprt.h"

// Smalltalk classes
#include "STVirtualObject.h"

#pragma code_seg(MEM_SEG)

///////////////////////////////////////////////////////////////////////////////
//	Methods


inline void ObjectMemory::releasePointer(OTE* ote)
{
	HARDASSERT(ote->m_count == 0);
	HARDASSERT(!ote->isFree());
	ote->beFree();

	ote->m_location = MarkFree(m_pFreePointerList);
	m_pFreePointerList = ote;

#ifdef TRACKFREEOTEs
	m_nFreeOTEs++;
#endif

	//HARDASSERT(m_nFreeOTEs == CountFreeOTEs());
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
	HARDASSERT(ote->m_count == 0);
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
			Interpreter::m_blockPool.deallocate(ote);
			break;

		case Spaces::Contexts:
			// Return it to the interpreter's free list of contexts
			Interpreter::m_contextPool.deallocate(ote);
			break;

		case Spaces::Dwords:
			Interpreter::m_dwordPool.deallocate(ote);
			break;

		case Spaces::Heap:
			//_asm int 3;
			HARDASSERT(FALSE);
			break;
		
		case Spaces::Floats:
			Interpreter::m_floatPool.deallocate(ote);
			break;

		default:
			ASSERT(false);
			__assume(false);
	}
}


// Return to default setting
//#pragma auto_inline(on)

#pragma code_seg(GC_SEG)
