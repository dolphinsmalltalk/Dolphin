///////////////////////////////////////////////////////////////////////////////
// ObjectMemory Private Inlines

#include "objmem.h"
#include "STBehavior.h"

#define _CRTBLD
#include "winheap.h"
#undef _CRTBLD

#ifdef MEMSTATS
	extern unsigned m_nSmallAllocated;
	extern unsigned m_nSmallFreed;
#endif

///////////////////////////////////////////////////////////////////////////////
// Low-level memory allocation

inline POBJECT ObjectMemory::allocChunk(MWORD chunkSize)
{
	#if defined(PRIVATE_HEAP)
		return static_cast<POBJECT>(::HeapAlloc(m_hHeap, HEAP_NO_SERIALIZE, chunkSize));
	#else
		return malloc(chunkSize);
	#endif
}

inline POBJECT ObjectMemory::allocSmallChunk(MWORD chunkSize)
{
#ifdef MEMSTATS
	++m_nSmallAllocated;
#endif

	ASSERT(chunkSize <= MaxSmallObjectSize);
	return chunkSize > MaxSizeOfPoolObject 
		? static_cast<POBJECT>(__sbh_alloc_block(chunkSize))
		: chunkSize == 0 
				? NULL
				: // Use Blair's very fast pools which tend to fragment a fair bit
					spacePoolForSize(chunkSize).allocate();
}

inline void ObjectMemory::freeSmallChunk(POBJECT pBlock, MWORD size)
{
#ifdef MEMSTATS
	++m_nSmallFreed;
#endif

	ASSERT(size <= MaxSmallObjectSize);
	if (size > MaxSizeOfPoolObject)
	{
		// Locate and dealloc SBH block
		PHEADER pHeader = __sbh_find_block(pBlock);
		ASSERT(pHeader != NULL);
	    __sbh_free_block(pHeader, pBlock);
	}
	else
	{
		if (pBlock != NULL)
			spacePoolForSize(size).deallocate(pBlock);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Oop allocation

inline OTE* __fastcall ObjectMemory::allocateOop(POBJECT pLocation)
{
	// OT is globally shared, so access must be in crit section
//	ASSERT(m_nInCritSection > 0);
	ASSERT(m_pFreePointerList != NULL);

	// N.B. By not ref. counting class here, we make a useful saving of a redundant
	// ref. counting operation in primitiveNew and primitiveNewWithArg

	OTE* ote = m_pFreePointerList;
	m_pFreePointerList = reinterpret_cast<OTE*>(ote->m_location);

	ASSERT(ote->isFree());
	_ASSERTE(--m_nFreeOTEs >= 0);

	// Set OTE fields of the Oop
	ote->m_location = pLocation;

	// Maintain the last used garbage collector mark to speed up collections
	// Doing this will also reset the free bit and set the pointer bit
	// so byte allocations will need to reset it
	ote->m_dwFlags = *reinterpret_cast<BYTE*>(&m_spaceOTEBits[OTEFlags::PoolSpace]);

	return ote;
}

