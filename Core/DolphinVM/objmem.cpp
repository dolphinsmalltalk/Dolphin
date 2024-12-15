/******************************************************************************

	File: ObjMem.cpp

	Description:

	Object Memory management miscellaneous data and functions.

******************************************************************************/

#include "Ist.h"
#pragma code_seg(MEM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "rc_vm.h"
#include "VMExcept.h"
#include "regkey.h"
#include <unordered_set>

using namespace concurrency;

#ifdef MEMSTATS
	size_t m_nAllocated = 0;
	size_t m_nFreed = 0;
#endif

#ifdef TRACKFREEOTEs
	size_t ObjectMemory::m_nFreeOTEs = 0;
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

uint32_t ObjectMemory::m_nNextIdHash;

size_t ObjectMemory::m_nOTSize;
size_t ObjectMemory::m_nOTMax;

OTE* 	ObjectMemory::m_pOT;					// The Object Table itself
OTE*	ObjectMemory::m_pFreePointerList;		// Head of list of free Object Table Entries
OTEFlags ObjectMemory::m_spaceOTEBits[OTEFlags::NumSpaces];

uint32_t ObjectMemory::m_imageVersionMajor;
uint32_t ObjectMemory::m_imageVersionMinor;

// The number of OT pages to be allocated each time an OT overflow occurs
// Higher numbers could waste more space, but will reduce the frequency of the overflows
// It is important that the result be exactly divisible by the OTE size (hence 16, because 16*4096%16==0)
constexpr int OTPagesAllocatedPerOverflow = 16;	// i.e. 64Kb per overflow, 4096 objects

#pragma code_seg(PROCESS_SEG)

void __fastcall ObjectMemory::oneWayBecome(OTE* ote1, OTE* ote2)
{
	Interpreter::resizeActiveProcess();
	ReconcileZct();

	CHECKREFERENCES

	const Oop oop1 = Oop(ote1);
	const Oop oop2 = Oop(ote2);

	ASSERT(!ObjectMemoryIsIntegerObject(oop1));
	ASSERT(!ObjectMemoryIsIntegerObject(oop2));

	size_t range = m_nOTSize / Interpreter::m_numberOfProcessors;
	parallel_for_each(m_pOT, m_pOT + m_nOTSize, [&](OTE& ote) {
		if (!ote.isFree())
		{
			// Must do class separately as in the OT
			if (ote.m_oteClass == reinterpret_cast<const BehaviorOTE*>(ote1))
				ote.m_oteClass = reinterpret_cast<BehaviorOTE*>(ote2);

			if (ote.isPointers())
			{
				VariantObject* obj = static_cast<VariantObject*>(ote.m_location);
				const size_t lastPointer = ote.pointersSize();
				for (size_t j = 0; j < lastPointer; j++)
				{
					Oop fieldPointer = obj->m_fields[j];
					if (fieldPointer == oop1)
						obj->m_fields[j] = oop2;
				}
			}
		}
	}, simple_partitioner(max(range, 16384)));

	unsigned newCount = ote1->m_count + ote2->m_count;
	if (newCount > OTE::MAXCOUNT)
		ote2->beSticky();
	else
		ote2->m_count = static_cast<uint8_t>(newCount);

	// The old object must be placed in the ZCT since all references have been lost
	// (we place it in the ZCT rather than free it, since it may reference other objects
	// that are in the stack but are otherwise unreferenced)
	ote1->m_count = 1;
	ote1->countDown();

	CHECKREFERENCES
}

Oop* PRIMCALL Interpreter::primitiveOneWayBecome(Oop* const sp, primargcount_t)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;

	if (!ObjectMemoryIsIntegerObject(receiver) && !ObjectMemoryIsIntegerObject(arg))
	{
		if (receiver != arg)
		{
			OTE* oteReceiver = reinterpret_cast<OTE*>(receiver);
			if (oteReceiver > ObjectMemory::PointerFromIndex(ObjectMemory::FirstCharacterIdx + 255))
			{
				OTE* oteArg = reinterpret_cast<OTE*>(arg);
				ObjectMemory::oneWayBecome(oteReceiver, oteArg);
				return sp - 1;
			}
			else
				return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);
		}
		else
			return sp - 1;
	}
	return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);
}

///////////////////////////////////////////////////////////////////////////////
// Instance Enumeration

typedef std::vector<OTE*> OTEVector;
typedef std::pair<OTEVector*, size_t> Batch;

// Parallel memory scan - This is mainly an experiment, but depending on the particular scan it can be between two and five times asfast as a single 
// threaded scan on a machine with 12 logical cores.
// A 2x speed up can be expected for the simplest scan (allInstances), because the amount of work being done is small and probably limited by memory bandwidth. 
// A 2-5x speed up can be expected for a sub-instances scan, depending on the number of matches. Where there are few matches the isKindOf test takes most time 
// and so there is most benefit from parallelization.
// allReferences scans are around 4x as fast. 
// All of these scans can now take less than 1mS, depending on the total number of Objects in the system, and the number of matches, and of course the speed 
// of the host machine.
// To measure the performance of scans, be sure to use primAllInstances and primAllSubinstances, as allInstances/allSubinstances trigger a GC first.
template<typename Partitioner, typename Predicate> ArrayOTE* ObjectMemory::selectObjects(const Partitioner&& part, const Predicate& pred)
{
	ReconcileZct();

	combinable<OTEVector> selected;

	// Parallel scan of the object table
	parallel_for_each(m_pOT, m_pOT + m_nOTSize, [&](OTE& ote) {
		if (!ote.isFree() && pred(&ote))
			selected.local().emplace_back(&ote);
	 }, part);

	// Assemble batch results
	size_t total = 0;
	std::vector<Batch> batches;
	batches.reserve(Interpreter::m_numberOfProcessors);
	selected.combine_each([&](OTEVector& v) {
		batches.emplace_back(Batch(&v, total));
		total += v.size();
		});

	ArrayOTE* arrayPointer = Array::NewUninitialized(total);
	Array* array = arrayPointer->m_location;
	
	constexpr size_t minParallelBatch = 8192;

	// If there are only a few results, it is not worth parallelizing the merge (although it is never of huge benefit anyway)
	if (total < minParallelBatch * 2)
	{
		auto pElem = array->m_elements;
		selected.combine_each([&](OTEVector& v) {
			for (auto it = v.cbegin(); it != v.cend(); ++it, ++pElem)
			{
				auto ote = *it;
				*pElem = reinterpret_cast<Oop>(ote);
				ote->countUp();
			}
			});
	}
	else
	{
		size_t range = total / Interpreter::m_numberOfProcessors;
		parallel_for_each(batches.cbegin(), batches.cend(), [&](const Batch& batch) {
			auto results = batch.first;
			auto pElem = &(array->m_elements[batch.second]);
			for (auto it = batch.first->cbegin(); it != batch.first->cend(); ++it, ++pElem)
			{
				auto ote = *it;
				*pElem = reinterpret_cast<Oop>(ote);
				ote->countUp();
			}
			}, simple_partitioner(max(range, minParallelBatch)));
	}

	// WARNING: Ref. count of arrayPointer currently 0
	return arrayPointer;
}

#pragma code_seg(GC_SEG)

ArrayOTE* __stdcall ObjectMemory::instancesOf(const BehaviorOTE* classPointer)
{
	size_t range = m_nOTSize / Interpreter::m_numberOfProcessors;
	return selectObjects(simple_partitioner(max(range, 16384)), [&](const OTE* ote) { return ote->m_oteClass == classPointer; });
}

Oop* PRIMCALL Interpreter::primitiveAllInstances(Oop* const sp, primargcount_t)
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
	return !isIntegerObject(objectPointer) && ::isBehavior(reinterpret_cast<OTE*>(objectPointer));
}

#pragma code_seg(MEM_SEG)

bool __fastcall ObjectMemory::isAMetaclass(const OTE* ote)
{
	return ::isMetaclass(ote);
}

#pragma code_seg(MEM_SEG)

bool __stdcall ObjectMemory::inheritsFrom(const BehaviorOTE* behaviorPointer, const BehaviorOTE* classPointer)
{
	ASSERT(isBehavior(Oop(classPointer)));
	ASSERT(isBehavior(Oop(behaviorPointer)));

	while (behaviorPointer != classPointer)
	{
		Behavior* behavior = behaviorPointer->m_location;
		if (behavior == nullptr)
			return false;
		behaviorPointer = behavior->m_superclass;
	}
	return true;
}

#pragma code_seg(GC_SEG)

namespace stdext {
	template <class _Kty>
	_NODISCARD size_t hash_value(const _Kty& _Keyval) noexcept {
		if constexpr (_STD is_pointer_v<_Kty> || _STD is_null_pointer_v<_Kty>) {
			return reinterpret_cast<size_t>(_Keyval) ^ 0xdeadbeefu;
		}
		else {
			return static_cast<size_t>(_Keyval) ^ 0xdeadbeefu;
		}
	}
};

template <class T> inline size_t hash_value(const TOTE<T>* ote)
{
	return stdext::hash_value(ote->getIndex());
}

template<class _Kty,
	class _Pr = _STD less<_Kty> >
	class hash_compare2
{	// traits class for hash containers
public:
	enum
	{	// parameters for hash table
		bucket_size = 4,	// 0 < bucket_size
		min_buckets = 2048
	};	// min_buckets = 2 ^^ N, 0 < N

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

typedef std::unordered_set<const BehaviorOTE*, hash_compare2<const BehaviorOTE*>> BehaviorSet;

ArrayOTE* __stdcall ObjectMemory::subinstancesOf(const BehaviorOTE* classPointer)
{
	BehaviorSet allInstantiableSubclasses;
	size_t range = m_nOTSize / Interpreter::m_numberOfProcessors;
	return ObjectMemory::selectObjects(simple_partitioner(max(range, 16384)),
		[&](const OTE* ote) { 
			const BehaviorOTE* behaviorPointer = ote->m_oteClass;
			return inheritsFrom(behaviorPointer, classPointer);
		});
}

Oop* PRIMCALL Interpreter::primitiveAllSubinstances(Oop* const sp, primargcount_t)
{
	BehaviorOTE* receiver = reinterpret_cast<BehaviorOTE*>(*sp);
	ArrayOTE* instances = ObjectMemory::subinstancesOf(receiver);
	*sp = reinterpret_cast<Oop>(instances);
	ObjectMemory::AddToZct(reinterpret_cast<OTE*>(instances));
	return sp;
}

struct InstStats
{
	size_t count;
	size_t bytes;

	InstStats() { count = bytes = 0; }
	InstStats(size_t count, size_t bytes) { this->count = count; this->bytes = bytes; }
};

typedef std::unordered_map<BehaviorOTE*,InstStats, hash_compare2<BehaviorOTE*> > ClassCountMap;

static size_t storageSize(OTE* ote)
{
	size_t bodySize = ote->sizeOf();
	// The body is rounded to a multiple of 8 bytes
	return _ROUND2(bodySize, 8) + sizeof(OTE);
}

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

	if (isNil(oteClasses))
	{
		auto n = counts.size();
		oteClassStats = Array::NewUninitialized(n * 3);
		Array* classStats = oteClassStats->m_location;
		size_t i = 0;
		ClassCountMap::const_iterator end = counts.end();
		for (ClassCountMap::const_iterator it = counts.begin();it != end; it++,i+=3)
		{
			BehaviorOTE* oteClass = (*it).first;
			oteClass->countUp();
			classStats->m_elements[i] = reinterpret_cast<Oop>(oteClass);
			const InstStats& stats = (*it).second;
			SmallInteger count = stats.count;
			classStats->m_elements[i+1] = integerObjectOf(count);
			SmallInteger bytesUsed = stats.bytes;
			classStats->m_elements[i+2] = integerObjectOf(bytesUsed);
		}
	}
	else
	{
		auto n = oteClasses->pointersSize();
		oteClassStats = Array::NewUninitialized(n * 3);
		Array* classStats = oteClassStats->m_location;
		Array* array = oteClasses->m_location;
		size_t count = oteClasses->pointersSize();
		ClassCountMap::const_iterator end = counts.end();
		for (size_t i=0;i<count;i++)
		{
			Oop obj = array->m_elements[i];
			countUp(obj);
			size_t j = i * 3;
			classStats->m_elements[j] = obj;
			ClassCountMap::const_iterator it;
			if (isBehavior(obj) && (it = counts.find(reinterpret_cast<BehaviorOTE*>(obj))) != end)
			{
				const InstStats& stats = (*it).second;
				SmallInteger count = stats.count;
				classStats->m_elements[j+1] = integerObjectOf(count);
				SmallInteger bytesUsed = stats.bytes;
				classStats->m_elements[j+2] = integerObjectOf(bytesUsed);
			}
			else
			{
				classStats->m_elements[j+1] = classStats->m_elements[j+2] = ZeroPointer;
			}
		}
	}

	// WARNING: Ref. count of arrayPointer currently 0
	return oteClassStats;
}

Oop* PRIMCALL Interpreter::primitiveInstanceCounts(Oop* const sp, primargcount_t)
{
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		OTE* oteArg = reinterpret_cast<OTE*>(arg);
		if (oteArg == Pointers.Nil || oteArg->m_oteClass == Pointers.ClassArray)
		{
			ArrayOTE* counts = ObjectMemory::instanceCounts(reinterpret_cast<ArrayOTE*>(oteArg));
			*(sp-1) = reinterpret_cast<Oop>(counts);
			ObjectMemory::AddToZct(reinterpret_cast<OTE*>(counts));
			return sp - 1;
		}
	}

	return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);
}

#pragma code_seg(GC_SEG)

Oop* PRIMCALL Interpreter::primitiveAllReferences(Oop* const sp, primargcount_t)
{
	// Make sure we don't include refs above TOS as these are invalid - also don't include the ref to the receiver on the stack
	bool includeWeakRefs = *sp == reinterpret_cast<Oop>(Pointers.True);

	// Resize the active process to exclude the receiver and arg (if any) to the primitive
	ST::Process* pActiveProcess = m_registers.m_pActiveProcess;
	size_t words = sp - 1 - reinterpret_cast<const Oop*>(pActiveProcess);
	m_registers.m_oteActiveProcess->setSize(words * sizeof(Oop));

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
	WeaknessMask = includeWeakRefs ? 0 : OTEFlags::WeakOrZMask;

	size_t range = m_nOTSize / Interpreter::m_numberOfProcessors;
	return selectObjects(simple_partitioner(max(range, 16384)), [&](const OTE* ote) {
		if (Oop(ote->m_oteClass) == referencedObjectPointer)
		{
			return true;
		}
		else
		{
			VariantObject* obj = static_cast<VariantObject*>(ote->m_location);
			const size_t lastPointer = lastStrongPointerOf(ote);
			for (size_t i = 0; i < lastPointer; i++)
			{
				if (obj->m_fields[i] == referencedObjectPointer)
				{
					return true;
				}
			}
		}
		return false;
	});
}

/*****************************************************************************
	
	Methods

*****************************************************************************/

//////////////////////////////////////////////////////////////////////////////
//	OT Allocation

#pragma code_seg(GC_SEG)

HRESULT ObjectMemory::allocateOT(size_t reserve, size_t commit)
{
	//ASSERT(!m_pOT);
//	ASSERT(m_nInCritSection > 0);	// Must obviously be performed exclusively as OT is globally shared

	// Calculations based on an OTE size of 16 - rounds up to multiples of 4 for this reason
	ASSERT(sizeof(OTE) == 16);

	m_nOTMax = _ROUND2(reserve, dwAllocationGranularity);
	const size_t reserveBytes = m_nOTMax * sizeof(OTE);
	
	OTE* pOTReserve = reinterpret_cast<OTE*>(::VirtualAlloc(NULL, reserveBytes, MEM_RESERVE, PAGE_NOACCESS));
	if (!pOTReserve)
		return ReportError(IDP_OTRESERVEFAIL, m_nOTMax);

	// Can use _ROUND2 if dwPageSize is a power of 2
	m_nOTSize = _ROUND2(commit, dwAllocationGranularity);
	const size_t commitBytes = m_nOTSize*sizeof(OTE);

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
#ifdef TRACKFREEOTEs
	m_nFreeOTEs = 0;
#endif
	for (OTE* ote=m_pFreePointerList; ote < pEnd; ote++)
	{
#ifdef TRACKFREEOTESs
		m_nFreeOTEs++;
#endif
#ifdef _DEBUG
		ASSERT((Oop(ote)&3) == 0);
		ZeroMemory(ote, sizeof(OTE));	// Mainly to check all writeable
#endif

		ote->beFree();
		ote->m_location = MarkFree(ote+1);
	}

	//TRACE("%d OTEs on free list\n", m_nFreeOTEs);
	// Last ObjectTable entry is at end of list
	//m_pObjectTable[i-1].m_location 	= 0;

	return S_OK;
}


///////////////////////////////////////////////////////////////////////////////
//	Cleanup

#pragma code_seg(GC_SEG)

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
		for (auto i=NumPermanent; i < m_nOTSize; i++)
		{
			OTE& ote = m_pOT[i];
			if (!ote.isFree())
			{
				ote.m_count = 0;	// To avoid assertion
				deallocate(&ote);
			}
		}
	}

	// Clean up the GC cache
	ClearGCInfo();
	HeapCompact();

#ifdef MEMSTATS
	DumpStats(L"");
#endif

	UninitializeHeap();

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

SmallInteger ObjectMemory::OopsLeft()
{
	SmallInteger count = 0;
	const OTE* pEnd = m_pOT+m_nOTSize;
	for (OTE* ote=m_pOT+OTBase; ote < pEnd; ote++)
		if (ote->isFree())
			count++;
	return count;
}

#pragma code_seg(GC_SEG)

size_t ObjectMemory::OopsUsed()
{
	size_t nFreeOTEs=0;
	const OTE* pEnd = m_pOT+m_nOTSize;
	OTE* ote=m_pFreePointerList;
	while (ote < pEnd)
	{
		nFreeOTEs++;
		ote = NextFree(ote);
	}

	for (auto i=0u;i<Interpreter::NumOtePools;i++)
		nFreeOTEs += Interpreter::m_otePools[i].FreeCount();

	return m_nOTSize - nFreeOTEs;
}

Oop* PRIMCALL Interpreter::primitiveObjectCount(Oop* const sp, primargcount_t)
{
	*sp = ObjectMemoryIntegerObjectOf(ObjectMemory::OopsUsed());
	return sp;
}

/////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef MEMSTATS
	#pragma code_seg(DEBUG_SEG)

	void ObjectMemory::OTEPool::registerNew(OTE* ote, BehaviorOTE* classPointer) 
	{
		m_nAllocated++;
		#ifdef VERBOSE_MEMSTATS
			Behavior* cl = classPointer->m_location;
			TRACESTREAM<< L"OTEPool(" << this<< L"): Allocated new " 
				<< cl<< L", " << LPVOID(ote)<< L", total "
				<< m_nAllocated<< L", free " << m_nFree << std::endl;
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
		TRACE(L"OT overflowed at %p (OT next %p, free %p), sp=%p (m_stackPointer=%p)\n", pFault, otNext, m_pFreePointerList, pExInfo->ContextRecord->Esi, Interpreter::m_registers.m_stackPointer);
		#ifdef MEMSTATS
			trace(L"Objects allocated %u, freed %u\n",
					m_nAllocated, m_nFreed);
			m_nAllocated = m_nFreed = 0;
		#endif
		const size_t extraBytes = OTPagesAllocatedPerOverflow*dwPageSize;
		const size_t extraOTEs = extraBytes/sizeof(OTE);
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
					#endif			
					#ifdef TRACKFREEOTEs
						m_nFreeOTEs++;
					#endif

					pLink->beFree();
					pLink->m_location = MarkFree(pLink+1);
					pLink++;
				}
				m_nOTSize += extraOTEs;
				TRACE(L"Successfully committed more OT space, size now %u\n", m_nOTSize);
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
