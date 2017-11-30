/******************************************************************************

	File: ObjMem.cpp

	Description:

	Object Memory management miscellaneous data and functions.

******************************************************************************/

#include "Ist.h"
#pragma code_seg(MEM_SEG)

#include <wtypes.h>
#include "ObjMem.h"
#include "ObjMemPriv.inl"
#include "Interprt.h"
#include "rc_vm.h"
#include "VMExcept.h"
#include "regkey.h"

HANDLE ObjectMemory::m_hHeap;
extern "C" { HANDLE _crtheap; }

#ifdef MEMSTATS
	unsigned m_nLargeAllocated = 0;
	unsigned m_nLargeFreed = 0;
	unsigned m_nSmallAllocated = 0;
	unsigned m_nSmallFreed = 0;
#endif

#ifdef _DEBUG
	int ObjectMemory::m_nFreeOTEs = 0;
#endif

// Smalltalk classes
#include "STString.h"
#include "STArray.h"
#include "STClassDesc.h"

// Compile auto inlining is too stupid
#pragma auto_inline(off)

///////////////////////////////////////////////////////////////////////////////
// It is important that these members remain ordered and contiguous

/*const*/ VMPointers Pointers;

DWORD	ObjectMemory::m_nNextIdHash;

unsigned ObjectMemory::m_nOTSize;
unsigned ObjectMemory::m_nOTMax;

OTE* 	ObjectMemory::m_pOT;					// The Object Table itself
OTE*	ObjectMemory::m_pFreePointerList;		// Head of list of free Object Table Entries
OTEFlags ObjectMemory::m_spaceOTEBits[OTEFlags::NumSpaces];

DWORD ObjectMemory::m_imageVersionMajor;
DWORD ObjectMemory::m_imageVersionMinor;

// The number of OT pages to be allocated each time an OT overflow occurs
// Higher numbers could waste more space, but will reduce the frequency of the overflows
// It is important that the result be exactly divisible by the OTE size (hence 16, because 16*4096%16==0)
static const int OTPagesAllocatedPerOverflow = 16;	// i.e. 64Kb per overflow, 4096 objects

#pragma code_seg(PROCESS_SEG)

void __fastcall ObjectMemory::oneWayBecome(OTE* ote1, OTE* ote2)
{
	Interpreter::resizeActiveProcess();

	CHECKREFERENCES

	const Oop oop1 = Oop(ote1);
	const Oop oop2 = Oop(ote2);

	ASSERT(!ObjectMemoryIsIntegerObject(oop1));
	ASSERT(!ObjectMemoryIsIntegerObject(oop2));


	const OTE* pEnd = m_pOT+m_nOTSize;
	for (OTE* ote=m_pOT; ote < pEnd; ote++)
	{
		if (!ote->isFree())
		{
			// Must do class separately as in the OT
			if (ote->m_oteClass == reinterpret_cast<const BehaviorOTE*>(ote1))
				ote->m_oteClass = reinterpret_cast<BehaviorOTE*>(ote2);

			if (ote->isPointers())
			{
				
				VariantObject* obj = static_cast<VariantObject*>(ote->m_location);
				const MWORD lastPointer = ote->pointersSize();
				for (MWORD j = 0; j < lastPointer; j++)
				{
					Oop fieldPointer = obj->m_fields[j];
					if (fieldPointer == oop1)
						obj->m_fields[j] = oop2;
				}
			}
		}
	}

	unsigned newCount = ote1->m_count + ote2->m_count;
	if (newCount > OTE::MAXCOUNT)
		ote2->beSticky();
	else
		ote2->m_count = static_cast<BYTE>(newCount);

	// The old object must be placed in the ZCT since all references have been lost
	// (we place it in the ZCT rather than free it, since it may reference other objects
	// that are in the stack but are otherwise unreferenced)
	ote1->m_count = 1;
	ote1->countDown();

	CHECKREFERENCES
}

///////////////////////////////////////////////////////////////////////////////
// Instance Enumeration

#pragma code_seg(GC_SEG)

// Return an array containing all instances of the specified class
ArrayOTE* __fastcall ObjectMemory::instancesOf(BehaviorOTE* classPointer)
{
	ASSERT(isBehavior(Oop(classPointer)));

	// Use the ref. count as an initial size
	unsigned size = classPointer->m_count;
	
	ArrayOTE* arrayPointer = Array::New(size);
	Array* pInstances = arrayPointer->m_location;

	unsigned cnt = 0;
	const OTE* pEnd = m_pOT+m_nOTSize;
	for (OTE* ote=m_pOT; ote < pEnd; ote++)
	{
		if (!ote->isFree())
		{
			if (ote->m_oteClass == classPointer)
			{
				if (cnt == size)
				{
					// Resize the array to hold twice as many objects
					size = size * 2;
					pInstances = static_cast<Array*>(basicResize(reinterpret_cast<OTE*>(arrayPointer), SizeOfPointers(size), 0));
				}
				pInstances->m_elements[cnt++] = Oop(ote);
				ote->countUp();
			}
		}
	}
	ASSERT(cnt <= size);
	if (cnt < size)
		basicResize(reinterpret_cast<OTE*>(arrayPointer), SizeOfPointers(cnt), 0);

	// WARNING: Ref. count of arrayPointer currently 0
	return arrayPointer;
}

Oop* __fastcall Interpreter::primitiveAllInstances(Oop* const sp)
{
	BehaviorOTE* receiver = reinterpret_cast<BehaviorOTE*>(*sp);
	ArrayOTE* instances = ObjectMemory::instancesOf(receiver);
	*sp = reinterpret_cast<Oop>(instances);
	ObjectMemory::AddToZct(reinterpret_cast<OTE*>(instances));
	return sp;
}

#pragma code_seg(MEM_SEG)

bool __fastcall ObjectMemory::isBehavior(Oop objectPointer)
{
	return !isIntegerObject(objectPointer) && reinterpret_cast<OTE*>(objectPointer)->isBehavior();
}

#pragma code_seg(MEM_SEG)

bool __fastcall ObjectMemory::isAMetaclass(const OTE* ote)
{
	return ote->isMetaclass();
}

#pragma code_seg(MEM_SEG)

bool __fastcall ObjectMemory::inheritsFrom(const BehaviorOTE* behaviorPointer, const BehaviorOTE* classPointer)
{
	ASSERT(isBehavior(Oop(classPointer)));
	ASSERT(isBehavior(Oop(behaviorPointer)));

	// This loop should optimize nicely because the compiler can see that there is 
	// no aliasing and that the loop condiations are therefore invariant
	const Oop nil = Oop(Pointers.Nil);
	while (behaviorPointer != classPointer)
	{
		// Coded for speed rather than beauty !
		if (Oop(behaviorPointer) == nil)
			return false;
		Behavior* behavior = behaviorPointer->m_location;
		behaviorPointer = behavior->m_superclass;
	}
	return true;
}

#pragma code_seg(GC_SEG)

// Return an array containing all subinstances of the specified class
// Exactly the same as the above routine, but uses isKindOf() instead of 
// class identity test, also allocates a minimum array size of 16 as obviously
// the ref. count is not much use.
ArrayOTE* __fastcall ObjectMemory::subinstancesOf(BehaviorOTE* classPointer)
{
	ASSERT(isBehavior(Oop(classPointer)));

	// Use the ref. count as an initial size
	unsigned size = classPointer->m_count;
	if (size < 32)
		size = 32;
	
	ArrayOTE* arrayPointer = Array::New(size);
	Array* pInstances = arrayPointer->m_location;

	unsigned cnt = 0;
	const OTE* pEnd = m_pOT+m_nOTSize;
	for (OTE* ote=m_pOT; ote < pEnd; ote++)
	{
		if (!ote->isFree())
		{
			if (isKindOf(ote, classPointer))		// As above apart from this
			{
				if (cnt == size)
				{
					// Resize the array to hold twice as many objects
					size = size * 2;
					pInstances = static_cast<Array*>(basicResize(reinterpret_cast<OTE*>(arrayPointer), SizeOfPointers(size), 0));
				}
				pInstances->m_elements[cnt++] = Oop(ote);
				ote->countUp();
			}
		}
	}
	ASSERT(cnt <= size);
	if (cnt < size)
		basicResize(reinterpret_cast<OTE*>(arrayPointer), SizeOfPointers(cnt), 0);

	// WARNING: Ref. count of arrayPointer currently 0
	return arrayPointer;
}

// Disable warning about exception handling (we compile with exception handling disabled)
#pragma warning (disable:4530)
#include <unordered_map>

template <class T> inline size_t hash_value(TOTE<T>* ote)
{
	return stdext::hash_value(ote->getIndex());
}

struct InstStats
{
	int count;
	int bytes;

	InstStats() { count = bytes = 0; }
	InstStats(int count, int bytes) { this->count = count; this->bytes = bytes; }
};

template<class _Kty,
	class _Pr = _STD less<_Kty> >
	class hash_compare2
	{	// traits class for hash containers
public:
	enum
		{	// parameters for hash table
		bucket_size = 4,	// 0 < bucket_size
		min_buckets = 2048};	// min_buckets = 2 ^^ N, 0 < N

	hash_compare2()
		: comp()
		{	// construct with default comparator
		}

	hash_compare2(_Pr _Pred)
		: comp(_Pred)
		{	// construct with _Pred comparator
		}

	size_t operator()(const _Kty& _Keyval) const
		{	// hash _Keyval to size_t value
		return ((size_t)hash_value(_Keyval));
		}

	bool operator()(const _Kty& _Keyval1, const _Kty& _Keyval2) const
		{	// test if _Keyval1 ordered before _Keyval2
		return (comp(_Keyval1, _Keyval2));
		}

protected:
	_Pr comp;	// the comparator object
	};
typedef unordered_map<BehaviorOTE*,InstStats, hash_compare2<BehaviorOTE*> > ClassCountMap;

static int storageSize(OTE* ote)
{
	int bodySize = ote->sizeOf();
	// The body is rounded to a multiple of 8 bytes
	return _ROUND2(bodySize, 8) + sizeof(OTE);
}

#if 1
ArrayOTE* __fastcall ObjectMemory::instanceCounts(ArrayOTE* oteClasses)
{
	ClassCountMap counts;

	const OTE* pEnd = m_pOT+m_nOTSize;
	InstStats* stats = NULL;
	const BehaviorOTE* oteLastClass = NULL;
	for (OTE* ote=m_pOT; ote < pEnd; ote++)
	{
		if (!ote->isFree())
		{
			BehaviorOTE* oteClass = ote->m_oteClass;
			if (oteClass != oteLastClass)
			{
				stats = &counts[oteClass];
				oteLastClass = oteClass;
			}
			stats->count++;
			stats->bytes += storageSize(ote);
		}
	}

	ArrayOTE* oteClassStats;

	if (oteClasses->isNil())
	{
		int n = counts.size();
		oteClassStats = Array::NewUninitialized(n * 3);
		Array* classStats = oteClassStats->m_location;
		int i = 0;
		ClassCountMap::const_iterator end = counts.end();
		for (ClassCountMap::const_iterator it = counts.begin();it != end; it++,i+=3)
		{
			BehaviorOTE* oteClass = (*it).first;
			oteClass->countUp();
			classStats->m_elements[i] = reinterpret_cast<Oop>(oteClass);
			const InstStats& stats = (*it).second;
			SMALLINTEGER count = stats.count;
			classStats->m_elements[i+1] = integerObjectOf(count);
			SMALLINTEGER bytesUsed = stats.bytes;
			classStats->m_elements[i+2] = integerObjectOf(bytesUsed);
		}
	}
	else
	{
		int n = oteClasses->pointersSize();
		oteClassStats = Array::NewUninitialized(n * 3);
		Array* classStats = oteClassStats->m_location;
		Array* array = oteClasses->m_location;
		MWORD count = oteClasses->pointersSize();
		ClassCountMap::const_iterator end = counts.end();
		for (MWORD i=0;i<count;i++)
		{
			Oop obj = array->m_elements[i];
			countUp(obj);
			classStats->m_elements[i] = obj;
			if (isBehavior(obj))
			{
				BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(obj);
				ClassCountMap::const_iterator it = counts.find(oteClass);
				if (it != end)
				{
					const InstStats& stats = (*it).second;
					SMALLINTEGER count = stats.count;
					classStats->m_elements[i+1] = integerObjectOf(count);
					SMALLINTEGER bytesUsed = stats.bytes;
					classStats->m_elements[i+2] = integerObjectOf(bytesUsed);
				}
			}
			else
			{
				classStats->m_elements[i+1] = classStats->m_elements[i+2] = ZeroPointer;
			}
		}
	}

	// WARNING: Ref. count of arrayPointer currently 0
	return oteClassStats;
}
#else

ArrayOTE* __fastcall ObjectMemory::instanceCounts(ArrayOTE* oteClasses)
{
	const bool allClasses = oteClasses->isNil();
	ClassCountMap counts;

	if (!allClasses)
	{
		Array* array = oteClasses->m_location;
		MWORD count = oteClasses->pointersSize();
		for (MWORD i=0;i<count;i++)
		{
			Oop obj = array->m_elements[i];
			if (isBehavior(obj))
			{
				BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(obj);
				counts.insert(ClassCountMap::value_type(oteClass, InstStats()));
			}
		}
	}

	const OTE* pEnd = m_pOT+m_nOTSize;
	for (OTE* ote=m_pOT; ote < pEnd; ote++)
	{
		if (!ote->isFree())
		{
			BehaviorOTE* oteClass = ote->m_oteClass;
			ClassCountMap::iterator it = counts.find(oteClass);
			if (it == counts.end())
			{
				if (allClasses)
					counts.insert(ClassCountMap::value_type(oteClass, InstStats(1,storageSize(ote))));
			}
			else
			{
				InstStats& stats = (*it).second;
				stats.count++;
				stats.bytes += storageSize(ote);
			}
		}
	}

	int n = counts.size();
	ArrayOTE* oteClassStats = Array::NewUninitialized(n * 3);
	Array* classStats = oteClassStats->m_location;
	int i = 0;
	const ClassCountMap::iterator loopEnd = counts.end();
	for (ClassCountMap::const_iterator it = counts.begin();it != loopEnd; it++,i+=3)
	{
		BehaviorOTE* oteClass = (*it).first;
		oteClass->countUp();
		classStats->m_elements[i] = reinterpret_cast<Oop>(oteClass);
		const InstStats& stats = (*it).second;
		SMALLINTEGER count = stats.count;
		classStats->m_elements[i+1] = integerObjectOf(count);
		SMALLINTEGER bytesUsed = stats.bytes;
		classStats->m_elements[i+2] = integerObjectOf(bytesUsed);
	}

	// WARNING: Ref. count of arrayPointer currently 0
	return oteClassStats;
}

#endif

#pragma code_seg(GC_SEG)

Oop* __fastcall Interpreter::primitiveAllReferences(Oop* const sp)
{
	// Make sure we don't include refs above TOS as these are invalid - also don't include the ref to the receiver on the stack
	bool includeWeakRefs = *sp == reinterpret_cast<Oop>(Pointers.True);

	// Resize the active process to exclude the receiver and arg (if any) to the primitive
	ST::Process* pActiveProcess = m_registers.m_pActiveProcess;
	MWORD words = sp - 1 - reinterpret_cast<const Oop*>(pActiveProcess);
	m_registers.m_oteActiveProcess->setSize(words * sizeof(MWORD));

	Oop receiver = *(sp - 1);
	ArrayOTE* refs = ObjectMemory::referencesTo(receiver, includeWeakRefs);

	*(sp - 1) = reinterpret_cast<Oop>(refs);
	ObjectMemory::AddToZct((OTE*)refs);
	return sp - 1;
}

// Return an array containing all objects which reference
// objectPointer (which may be a SmallInteger)
ArrayOTE* __stdcall ObjectMemory::referencesTo(Oop referencedObjectPointer, bool includeWeakRefs)
{
	WeaknessMask = includeWeakRefs ? 0 : OTE::WeakMask;

	unsigned size;
	if (!isIntegerObject(referencedObjectPointer))
		size = reinterpret_cast<OTE*>(referencedObjectPointer)->m_count;
	else
		size = 32;

	ArrayOTE* arrayPointer = Array::New(size);
	Array* pRefs = arrayPointer->m_location;
	// Temporarily mark the ref array as being free to prevent it appearing as a ref. 
	// to the object, which may happen if we are unfortunate enough to uncover a
	// circular reference before the oop of the new array is considered
	arrayPointer->beFree();

	unsigned refCnt = 0;
	const OTE* pEnd = m_pOT + m_nOTSize;
	for (OTE* ote = m_pOT; ote < pEnd; ote++)
	{
		if (!ote->isFree())
		{
			if (Oop(ote->m_oteClass) == referencedObjectPointer)
			{
				if (refCnt == size)
				{
					// Resize the array to hold twice as many objects
					size = size * 2;
					pRefs = static_cast<Array*>(basicResize(reinterpret_cast<OTE*>(arrayPointer), SizeOfPointers(size), 0));
				}
				pRefs->m_elements[refCnt++] = Oop(ote);
				// Having created another ref. to the referencing
				// object, we need to inc. its ref. count!
				ote->countUp();
			}
			else
			{
				VariantObject* obj = static_cast<VariantObject*>(ote->m_location);
				const MWORD lastPointer = lastStrongPointerOf(ote);
				for (MWORD i = 0; i < lastPointer; i++)
				{
					if (obj->m_fields[i] == referencedObjectPointer)
					{
						if (refCnt == size)
						{
							// Resize the array to hold twice as many objects
							size = size * 2;
							pRefs = static_cast<Array*>(basicResize(reinterpret_cast<OTE*>(arrayPointer), SizeOfPointers(size), 0));
						}
						pRefs->m_elements[refCnt++] = Oop(ote);
						ote->countUp();
						// Don't want an objectPointer in the array 
						// of references more than once
						break;
					}
				}
			}
		}
	}
	// Undo the 'ignore' flag
	arrayPointer->beAllocated();

	ASSERT(refCnt <= size);
	if (refCnt < size)
	{
		basicResize(reinterpret_cast<OTE*>(arrayPointer), SizeOfPointers(refCnt), 0);
	}

	// Ref. count of arrayPointer currently 0
	return arrayPointer;
}

/*****************************************************************************
	
	Methods

*****************************************************************************/

///////////////////////////////////////////////////////////////////////////////
// Low-level memory chunk (not object) management routines
//
// These map directly onto C or Win32 heap

#ifdef _DEBUG
	MWORD ObjectMemory::chunkSize(void* pChunk)
	{
		#ifdef PRIVATE_HEAP
			return ::HeapSize(m_hHeap, 0, pChunk);
		#else
			return _msize(pChunk);
		#endif
	}
#endif

///////////////////////////////////////////////////////////////////////////////
//	OT Allocation

#pragma code_seg(GC_SEG)

HRESULT ObjectMemory::allocateOT(unsigned reserve, unsigned commit)
{
	//ASSERT(!m_pOT);
//	ASSERT(m_nInCritSection > 0);	// Must obviously be performed exclusively as OT is globally shared

	// Calculations based on an OTE size of 16 - rounds up to multiples of 4 for this reason
	ASSERT(sizeof(OTE) == 16);

	m_nOTMax = _ROUND2(reserve, dwAllocationGranularity);
	const unsigned reserveBytes = m_nOTMax * sizeof(OTE);
	
	OTE* pOTReserve = reinterpret_cast<OTE*>(::VirtualAlloc(NULL, reserveBytes, MEM_RESERVE, PAGE_NOACCESS));
	if (!pOTReserve)
		return ReportError(IDP_OTRESERVEFAIL, m_nOTMax);

	// Can use _ROUND2 if dwPageSize is a power of 2
	m_nOTSize = _ROUND2(commit, dwAllocationGranularity);
	const unsigned commitBytes = m_nOTSize*sizeof(OTE);

	OTE* pNewOT = reinterpret_cast<OTE*>(::VirtualAlloc(pOTReserve, commitBytes, MEM_COMMIT, PAGE_READWRITE));
	if (!pNewOT)
	{
		::VirtualFree(pOTReserve, 0, MEM_RELEASE);
		return ReportError(IDP_OTCOMMITFAIL, 0, m_nOTSize, m_nOTMax);
	}

	// Successfully reserved and committed, so now we can overwrite the old OT pointer
	m_pOT = pNewOT;
	m_pFreePointerList = m_pOT+OTBase;
	const OTE* pEnd = m_pOT + m_nOTSize;	// Loop invariant
#ifdef _DEBUG
	m_nFreeOTEs = 0;
#endif
	for (OTE* ote=m_pFreePointerList; ote < pEnd; ote++)
	{
#ifdef _DEBUG
		m_nFreeOTEs++;
		ASSERT((Oop(ote)&3) == 0);
		ZeroMemory(ote, sizeof(OTE));	// Mainly to check all writeable
#endif

		ote->beFree();
		ote->m_location = reinterpret_cast<POBJECT>(ote+1);
	}

	//TRACE("%d OTEs on free list\n", m_nFreeOTEs);
	// Last ObjectTable entry is at end of list
	//m_pObjectTable[i-1].m_location 	= 0;

	return S_OK;
}


///////////////////////////////////////////////////////////////////////////////
//	Cleanup

#pragma code_seg(GC_SEG)

// Compact any object memory heaps to minimize working set
void ObjectMemory::HeapCompact()
{
	// Minimize space occuppied by the heap
	__sbh_heapmin();
	#ifdef PRIVATE_HEAP
		::HeapCompact(m_hHeap, 0);
	#endif

	_heapmin();
}

#pragma code_seg(TERM_SEG)

void ObjectMemory::FixedSizePool::Terminate()
{
	const unsigned loopEnd = m_nAllocations;
	for (unsigned i=0;i<loopEnd;i++)
		VERIFY(::VirtualFree(m_pAllocations[i], 0, MEM_RELEASE));

	free(m_pAllocations);
	m_pFreePages = 0;
	m_pAllocations = 0;
	m_nAllocations = 0;
}

#pragma code_seg(TERM_SEG)

void ObjectMemory::Terminate()
{
//	ASSERT(!m_nInCritSection);		// A thread is still running, or other problem
//	::DeleteCriticalSection(&m_csAsyncProtect);

	// Free up all the memory used by the object table. We need to call this
	// before the statically allocated object is destroyed to avoid spurious
	// messages from the heap about lost memory allocations.
	if (m_pOT)
	{
		// Deallocate all objects that need deallocating to avoid leaking when loaded in-proc
		for (unsigned i=NumPermanent; i < m_nOTSize; i++)
		{
			OTE& ote = m_pOT[i];
			if (!ote.isFree())
			{
				bool bNeedsDealloc;
				#ifdef PRIVATE_HEAP
					OTEFlags::Spaces space = ote.heapSpace();
					bNeedsDealloc = space != OTEFlags::PoolSpace || (ote.sizeOf() > MaxSizeOfPoolObject);
				#else
					bNeedsDealloc = ote.getSpace != PoolSpace;
				#endif

				if (bNeedsDealloc)
				{
					ote.m_count = 0;	// To avoid assertion
					deallocate(&ote);
				}
			}
		}
	}

	// Clean up the OTE pools before object table is deleted
	Interpreter::freePools();
	//for (int j=0;j<NUMOTEPOOLS;j++)
	//	m_otePools[j].terminate();

	// Clean up the GC cache
	ClearGCInfo();

	// Clean up the pools by freeing the pages
	for (int j=0;j<NumPools;j++)
		m_pools[j].terminate();
	FixedSizePool::Terminate();

	HeapCompact();

// Leave heap around for use next time?
//	::HeapDestroy(m_hHeap);
//	m_hHeap = 0;
//	_crtheap = 0;
	

	if (m_pOT)
	{
		// Delete the OT itself
		::VirtualFree(m_pOT, 0, MEM_RELEASE);
	}

	m_pOT = 0;
	m_nOTSize = 0;
	m_pFreePointerList = 0;
}

/*
void ObjectMemory::Reset()
{
	Terminate();
	Initialize();
}
*/

#pragma code_seg(GC_SEG)

SMALLINTEGER ObjectMemory::OopsLeft()
{
	SMALLINTEGER count = 0;
	const OTE* pEnd = m_pOT+m_nOTSize;
	for (OTE* ote=m_pOT+OTBase; ote < pEnd; ote++)
		if (ote->isFree())
			count++;
	return count;
}

#pragma code_seg(GC_SEG)

int ObjectMemory::OopsUsed()
{
	unsigned nFreeOTEs=0;
	const OTE* pEnd = m_pOT+m_nOTSize;
	OTE* ote=m_pFreePointerList;
	while (ote < pEnd)
	{
		nFreeOTEs++;
		ote = reinterpret_cast<OTE*>(ote->m_location);
	}

	for (unsigned i=0;i<Interpreter::NUMOTEPOOLS;i++)
		nFreeOTEs += Interpreter::m_otePools[i].FreeCount();

	return m_nOTSize - nFreeOTEs;
}

/////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef MEMSTATS
	#pragma code_seg(DEBUG_SEG)

	void ObjectMemory::OTEPool::registerNew(OTE* ote, BehaviorOTE* classPointer) 
	{
		m_nAllocated++;
		#ifdef VERBOSE_MEMSTATS
			Behavior* cl = classPointer->m_location;
			TRACESTREAM << "OTEPool(" << this << "): Allocated new " 
				<< cl << ", " << LPVOID(ote) << ", total "
				<< m_nAllocated << ", free " << m_nFree << endl;
		#endif
	}
#endif

///////////////////////////////////////////////////////////////////////////////
#pragma code_seg(MEM_SEG)

int ObjectMemory::gpFaultExceptionFilter(LPEXCEPTION_POINTERS pExInfo)
{
	LPEXCEPTION_RECORD pExRec = pExInfo->ExceptionRecord;

	// This "filter" is designed to handle GPFs only
	ASSERT(pExRec->ExceptionCode == EXCEPTION_ACCESS_VIOLATION);

	int action = EXCEPTION_CONTINUE_SEARCH;

	OTE* pFault = reinterpret_cast<OTE*>(pExRec->ExceptionInformation[1]);
	// If GPF is within the next OTE
	OTE* otNext = m_pOT + m_nOTSize;
	if (pFault >= otNext && pFault <= otNext+1)
	{
		HARDASSERT(m_nFreeOTEs == 0);
		// The OT overflowed
		TRACE("Object table overflow detected at %p (OT next %p, free %p)\n", pFault, otNext, m_pFreePointerList);
		#ifdef MEMSTATS
			trace("Small Allocated %u, freed %u, large allocated %u, freed %u\n",
					m_nSmallAllocated, m_nSmallFreed, m_nLargeAllocated, m_nLargeFreed);
			m_nLargeAllocated = m_nLargeFreed = m_nSmallAllocated = m_nSmallFreed = 0;
		#endif
		const unsigned extraBytes = OTPagesAllocatedPerOverflow*dwPageSize;
		const unsigned extraOTEs = extraBytes/sizeof(OTE);
		// Note we can't allocate right up to the end, as we need at least one guard page, hence < rather than <=
		if ((m_nOTSize + extraOTEs) < m_nOTMax)
		{
			ASSERT(extraOTEs * sizeof(OTE) == extraBytes);
			OTE* pLink = otNext;
			if (::VirtualAlloc(pLink, extraBytes, MEM_COMMIT, PAGE_READWRITE))
			{
				const OTE* pEnd = pLink+extraOTEs;
				while (pLink < pEnd)
				{
					#ifdef _DEBUG
						ASSERT((Oop(pLink)&3) == 0);
						ZeroMemory(pLink, sizeof(OTE));	// Mainly to check all writeable
						m_nFreeOTEs++;
					#endif

					pLink->beFree();
					pLink->m_location = reinterpret_cast<POBJECT>(pLink+1);
					pLink++;
				}
				m_nOTSize += extraOTEs;
				TRACE("Successfully committed more OT space, size now %u\n", m_nOTSize);
#ifdef _DEBUG
				Interpreter::DumpOTEPoolStats();
#endif

				Interpreter::NotifyOTOverflow();
				action = EXCEPTION_CONTINUE_EXECUTION;
			}
			else
			{
				RaiseFatalError(IDP_OTCOMMITFAIL, 3, m_nOTSize, extraOTEs, m_nOTMax);
			}
		}
		else
		{
			RaiseFatalError(IDP_OTFULL, 3, m_nOTSize, extraOTEs, m_nOTMax);
		}
	}

	return action;
}
