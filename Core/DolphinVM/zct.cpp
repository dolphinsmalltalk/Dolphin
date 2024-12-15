/******************************************************************************

	File: Zct.cpp

	Description:

	Object Memory Zero Count Table related members

******************************************************************************/

#include "Ist.h"

#pragma code_seg(MEM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "rc_vm.h"
#include "RegKey.h"

// Smalltalk classes
#include "STVirtualObject.h"

constexpr size_t ZCTMINSIZE = 64;			// Minimum size, and initial high water mark, of the ZCT.
constexpr size_t ZCTINITIALSIZE = 2048;		// Benchmarking shows this to be the best size at present.
constexpr size_t ZCTMINRESERVE = 16 * 1024;
constexpr size_t ZCTRESERVE = 512 * 1024;   // Allow up to 0.5 million objects to be ref'd only from stack of active process

OTE** ObjectMemory::m_pZct;
ptrdiff_t ObjectMemory::m_nZctEntries;
ptrdiff_t ObjectMemory::m_nZctHighWater;
static uint32_t ZctMinSize;
static uint32_t ZctReserve;
bool ObjectMemory::m_bIsReconcilingZct;

#ifdef _DEBUG
static size_t nDeleted;
static DWORD dwLastReconcileTicks;
bool ObjectMemory::alwaysReconcileOnAdd = true;

bool ObjectMemory::IsInZct(OTE* ote)
{
	// Expensive serial search needed because we don't have a flag free in the OTE at present
	for (auto i = 0; i < m_nZctEntries; i++)
		if (m_pZct[i] == ote) return true;
	return false;
}
#endif

HRESULT ObjectMemory::InitializeZct()
{
	CRegKey rkDump;
	ZctReserve = ZCTRESERVE;
	ZctMinSize = ZCTINITIALSIZE;
	if (OpenDolphinKey(rkDump, L"ObjMem", KEY_READ) == ERROR_SUCCESS)
	{
		DWORD dwValue;
		if (rkDump.QueryDWORDValue(L"ZMax", dwValue) == ERROR_SUCCESS && dwValue > ZCTMINRESERVE)
			ZctReserve = dwValue;
		if (rkDump.QueryDWORDValue(L"ZMin", dwValue) == ERROR_SUCCESS && dwValue > ZCTMINSIZE &&
			dwValue < ZctReserve)
			ZctMinSize = dwValue;
	}

	//trace("ZctMinSize = %u, ZctReserve = %u\n", ZctMinSize, ZctReserve);
	m_nZctEntries = 0;
	m_bIsReconcilingZct = false;
	m_pZct = static_cast<OTE**>(::VirtualAlloc(NULL, ZctReserve * sizeof(OTE*), MEM_RESERVE, PAGE_NOACCESS));
	if (!m_pZct)
		return ReportError(IDP_ZCTRESERVEFAIL, ZctReserve, 0);

	m_nZctHighWater = ZctMinSize >> 1;
	GrowZct();

#ifdef _DEBUG
	dwLastReconcileTicks = timeGetTime();
#endif

	return S_OK;
}

void ObjectMemory::GrowZct()
{
	TRACE(L"ZCT overflow at %d entries (%d in use), growing to %d\n", m_nZctHighWater, m_nZctEntries, m_nZctHighWater * 2);
	m_nZctHighWater <<= 1;
	// Reserve and high water must be powers of 2, so this should be unless about to overflow reserve
	HARDASSERT((DWORD)m_nZctHighWater <= ZctReserve);
	m_pZct = static_cast<OTE**>(::VirtualAlloc(m_pZct, m_nZctHighWater * sizeof(OTE*), MEM_COMMIT, PAGE_READWRITE));
	if (!m_pZct)
		RaiseFatalError(IDP_ZCTCOMMITFAIL, 2, m_nZctHighWater, ZctReserve);
}

void ObjectMemory::ShrinkZct()
{
	TRACE(L"Shrink ZCT from %d entries (%d in use) to %d\n", m_nZctHighWater, m_nZctEntries, m_nZctHighWater / 2);
	m_nZctHighWater >>= 1;

	// Can't shrink below one page
	if (m_nZctHighWater >= (dwPageSize / sizeof(OTE*)))
	{
		::VirtualFree(m_pZct + m_nZctHighWater, m_nZctHighWater * sizeof(OTE*), MEM_DECOMMIT);
	}
}


Oop* ObjectMemory::ReconcileZct()
{
#ifdef _DEBUG
	DWORD dwTicksNow = timeGetTime();
	if (!alwaysReconcileOnAdd)
	{
		TRACELOCK();
		TRACESTREAM << L"Reconciling Zct after " << std::dec << dwTicksNow - dwLastReconcileTicks<< L" mS: ";
		//Interpreter::DumpOTEPoolStats();
		TRACESTREAM << L"..." << std::endl;
	}
	dwLastReconcileTicks = timeGetTime();
	const auto nOldZctEntries = m_nZctEntries;
#endif

	Oop* const sp = Interpreter::m_registers.m_stackPointer;

	EmptyZct(sp);
	PopulateZct(sp);

#ifdef _DEBUG
	if (!alwaysReconcileOnAdd)
	{
		DWORD dwTicksAfter = timeGetTime();
		trace(L"Zct reconciled in %dmS: %d objects were deleted, %d slots free'd, %d still in use\n", dwTicksAfter - dwTicksNow, nDeleted, nOldZctEntries - m_nZctEntries, m_nZctEntries);
		//Interpreter::DumpOTEPoolStats();
		if (m_nZctEntries > 0 && Interpreter::executionTrace != 0)
			DumpZct();
	}
#endif

	return sp;
}

void ObjectMemory::EmptyZct(Oop* const sp)
{
	if (m_bIsReconcilingZct)
		__debugbreak();
#ifdef _DEBUG
	nDeleted = 0;

	if (!alwaysReconcileOnAdd || Interpreter::executionTrace)
		CHECKREFSNOFIX
	else
		checkStackRefs(sp);
#endif

	// Bump the refs from the stack. Any objects remaining in the ZCT with zero counts
	// are truly garbage.
	Interpreter::IncStackRefs(sp);

	OTE** pZct = m_pZct;
	// This tells us that we are in the process of reconcilation
	m_bIsReconcilingZct = true;
	const auto nOldZctEntries = m_nZctEntries;
	m_nZctEntries = -1;

	for (auto i = 0; i < nOldZctEntries; i++)
	{
		OTE* ote = pZct[i];
		if (!ote->isFree() && ote->m_count == 0)
		{
			// Note that deallocate cannot make new Zct entries
			// Because we have bumped the ref. counts of all stack ref'd objects, only true
			// garbage objects can ever have a ref. count of zero. Therefore if recursively
			// counting down throws up new zero ref. counts, these should not be added to 
			// the Zct, but deallocated. To achieve this we set a global flag to indicate
			// that we are reconciling, see AddToZct() above. 
#ifdef _DEBUG
			nDeleted++;
			//TRACESTREAM << L"Zct ote " << std::hex << reinterpret_cast<uintptr_t>(ote) << " deleted: " << ote << std::endl;
#endif
			recursiveFree(ote);
		}
	}

	//	CHECKREFSNOFIX
}


OTE* __fastcall ObjectMemory::recursiveFree(OTE* rootOTE)
{
	HARDASSERT(!isIntegerObject(rootOTE));
	HARDASSERT(!isPermanent(rootOTE));
	HARDASSERT(!rootOTE->isFree());
	HARDASSERT(rootOTE->m_count == 0);

	if (!rootOTE->isFinalizable())
	{
		// Deal with the class first, as this is now held in the OTE
		BehaviorOTE* oteClass = rootOTE->m_oteClass;
		if (oteClass->decRefs())
			recursiveFree(reinterpret_cast<POTE>(oteClass));

		if (rootOTE->isPointers())
		{
			// Recurse through referenced objects as necessary
			const auto lastPointer = rootOTE->getWordSize();
			Oop* pFields = reinterpret_cast<Oop*>(rootOTE->m_location);
			// Start after the header (only includes size now, which is not an Oop)
			for (auto i = ObjectHeaderSize; i < lastPointer; i++)
			{
				Oop fieldPointer = pFields[i];
				if (!isIntegerObject(fieldPointer))
				{
					OTE* fieldOTE = reinterpret_cast<OTE*>(fieldPointer);
					if (fieldOTE->decRefs())
						recursiveFree(reinterpret_cast<POTE>(fieldOTE));
				}
			}
		}

		deallocate(rootOTE);
	}
	else
	{
		finalize(rootOTE);
		rootOTE->beUnfinalizable();
	}

	return rootOTE;		// Important for some assembler routines - will be non-zero, so can act as TRUE
}

void Interpreter::IncStackRefs(Oop* const sp)
{
	Process* pProcess = actualActiveProcess();
	for (Oop* pOop = pProcess->m_stack; pOop <= sp; pOop++)
	{
		if (!isIntegerObject(*pOop))
		{
			OTE* ote = reinterpret_cast<OTE*>(*pOop);
			ote->countUp();
		}
	}
}

void Interpreter::DecStackRefs(Oop* const sp)
{
	Process* pProcess = actualActiveProcess();
	for (Oop* pOop = pProcess->m_stack; pOop <= sp; pOop++)
	{
		if (!isIntegerObject(*pOop))
		{
			OTE* rootOTE = reinterpret_cast<OTE*>(*pOop);
			rootOTE->countDownStackRef();
		}
	}
}

void ObjectMemory::PopulateZct(Oop* const sp)
{
	HARDASSERT(m_nZctEntries <= 0);

	// To build the new Zct all we need do is countDown() everything in the current process 
	// stack. Any counts that dropped to zero, will get put back in the new Zct.
	m_nZctEntries = 0;

#ifdef _DEBUG
	bool bLast = alwaysReconcileOnAdd;
	alwaysReconcileOnAdd = false;
#endif

	// This will populate the Zct with all objects ref'd only from the active process stack
	Interpreter::DecStackRefs(sp);
#ifdef _DEBUG
	alwaysReconcileOnAdd = bLast;
	//CHECKREFSNOFIX
#endif

	if (m_nZctEntries > (m_nZctHighWater - (m_nZctHighWater >> 2)))
	{
		// More than 75% full, then grow it
		GrowZct();
	}
	else if ((m_nZctHighWater > (ptrdiff_t)ZctMinSize) && (m_nZctEntries < (m_nZctHighWater >> 2)))
	{
		// Less than 25% full, so shrink it
		ShrinkZct();
	}

	// Reconciliation complete
	m_bIsReconcilingZct = false;
}

#ifdef _DEBUG
void ObjectMemory::DumpZct()
{
	TRACESTREAM<< L"===========================================================" << std::endl;
	TRACESTREAM<< L"ZCT @ " << std::hex << m_pZct<< L", size: " << std::dec << m_nZctEntries << std::endl;
	TRACESTREAM<< L"===========================================================" << std::endl;

	for (auto i = 0; i < m_nZctEntries; i++)
		TRACESTREAM << std::dec << i<< L": " << std::hex << (uintptr_t)m_pZct[i]<< L": " << m_pZct[i] << std::endl;

	TRACESTREAM<< L"===========================================================" << std::endl;
}
#endif