///////////////////////////////////////////////////////////////////////////////
// ObjectMemory Private Inlines

#include "objmem.h"
#include "STBehavior.h"

#define _CRTBLD
#include "winheap.h"
#undef _CRTBLD

#ifdef MEMSTATS
	extern size_t m_nSmallAllocated;
	extern size_t m_nSmallFreed;
#endif

///////////////////////////////////////////////////////////////////////////////
// Low-level memory allocation

inline POBJECT ObjectMemory::allocChunk(size_t chunkSize)
{
	#if defined(PRIVATE_HEAP)
		POBJECT pObj = static_cast<POBJECT>(::HeapAlloc(m_hHeap, 0, chunkSize));
		#ifdef _DEBUG
			memset(pObj, 0xCD, chunkSize);
		#endif
		return pObj;
	#else
		return malloc(chunkSize);
	#endif
}

extern "C" ST::Object emptyObj;

inline POBJECT ObjectMemory::allocSmallChunk(size_t chunkSize)
{
#ifdef MEMSTATS
	++m_nSmallAllocated;
#endif

	ASSERT(chunkSize <= MaxSmallObjectSize);
	return chunkSize > MaxSizeOfPoolObject 
		? static_cast<POBJECT>(__sbh_alloc_block(chunkSize))
		: chunkSize == 0 
				? &emptyObj
				: // Use chunk pools, which are fast but can cause memory fragmentation
					spacePoolForSize(chunkSize).allocate();
}

inline void ObjectMemory::freeSmallChunk(POBJECT pBlock, size_t size)
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
		if (pBlock != &emptyObj)
			spacePoolForSize(size).deallocate(pBlock);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Oop allocation

inline OTE* __fastcall ObjectMemory::allocateOop(POBJECT pLocation)
{
	__assume(m_pFreePointerList != nullptr);

	// N.B. By not ref. counting class here, we make a useful saving of a redundant
	// ref. counting operation in primitiveNew and primitiveNewWithArg

	OTE* ote = m_pFreePointerList;
	m_pFreePointerList = reinterpret_cast<OTE*>(ote->m_location);

	ASSERT(ote->isFree());
#ifdef TRACKFREEOTEs
	--m_nFreeOTEs;
	assert(m_nFreeOTEs >= 0);
	//assert(m_nFreeOTEs == CountFreeOTEs());
#endif

	// Set OTE fields of the Oop
	ote->m_location = pLocation;

	// Maintain the last used garbage collector mark to speed up collections
	// Doing this will also reset the free bit and set the pointer bit
	// so byte allocations will need to reset it
	ote->m_flagsWord = *reinterpret_cast<uint8_t*>(&m_spaceOTEBits[static_cast<space_t>(Spaces::Pools)]);

	return ote;
}

