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
#include "rc_vm.h"
#include "RegKey.h"

// Smalltalk classes
#include "STVirtualObject.h"

enum { 
		ZCTMINSIZE = 64,		// Minimum size, and initial high water mark, of the ZCT.
		ZCTINITIALSIZE = 2048,	// Benchmarking shows this to be the best size at present.
		ZCTMINRESERVE = 16*1024,
		ZCTRESERVE = 512*1024   // Allow up to 0.5 million objects to be ref'd only from stack of active process
		};

OTE** ObjectMemory::m_pZct;
int ObjectMemory::m_nZctEntries;
int ObjectMemory::m_nZctHighWater;
static DWORD ZctMinSize;
static DWORD ZctReserve;
bool ObjectMemory::m_bIsReconcilingZct;

#ifdef _DEBUG
	static int nDeleted;
	static DWORD dwLastReconcileTicks;
	bool alwaysReconcileOnAdd = true;

	bool ObjectMemory::IsInZct(OTE* ote)
	{
		// Expensive serial search needed because we don't have a flag free in the OTE at present
		for (int i=0;i<m_nZctEntries;i++)
			if (m_pZct[i] == ote) return true;
		return false;
	}
#endif

HRESULT ObjectMemory::InitializeZct()
{
	CRegKey rkDump;
	ZctReserve = ZCTRESERVE;
	ZctMinSize = ZCTINITIALSIZE;
	if (OpenDolphinKey(rkDump, "ObjMem", KEY_READ)==ERROR_SUCCESS)
	{
		DWORD dwValue;
		if (rkDump.QueryDWORDValue("ZMax", dwValue) == ERROR_SUCCESS && dwValue > ZCTMINRESERVE)
			ZctReserve = dwValue;
		if (rkDump.QueryDWORDValue("ZMin", ZctMinSize) == ERROR_SUCCESS && dwValue > ZCTMINSIZE &&
				dwValue < ZctReserve)
			ZctMinSize = dwValue;
	}

	//trace("ZctMinSize = %u, ZctReserve = %u\n", ZctMinSize, ZctReserve);
	m_nZctEntries = 0;
	m_bIsReconcilingZct = false;
	m_pZct = static_cast<OTE**>(::VirtualAlloc(NULL, ZctReserve*sizeof(OTE*), MEM_RESERVE, PAGE_NOACCESS));
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
	TRACE("ZCT overflow at %d entries (%d in use), growing to %d\n", m_nZctHighWater, m_nZctEntries, m_nZctHighWater*2);
	m_nZctHighWater <<= 1;
	// Reserve and high water must be powers of 2, so this should be unless about to overflow reserve
	HARDASSERT((DWORD)m_nZctHighWater <= ZctReserve);
	m_pZct = static_cast<OTE**>(::VirtualAlloc(m_pZct, m_nZctHighWater*sizeof(OTE*), MEM_COMMIT, PAGE_READWRITE));
	if (!m_pZct)
		RaiseFatalError(IDP_ZCTRESERVEFAIL, 2, m_nZctHighWater, ZctReserve);
}

void ObjectMemory::ShrinkZct()
{
	TRACE("Shrink ZCT from %d entries (%d in use) to %d\n", m_nZctHighWater, m_nZctEntries, m_nZctHighWater/2);
	m_nZctHighWater >>= 1;

	// Can't shrink below one page
	if (m_nZctHighWater >= (dwPageSize/sizeof(OTE*)))
	{
		::VirtualFree(m_pZct+m_nZctHighWater, m_nZctHighWater*sizeof(OTE*), MEM_DECOMMIT);
	}
}


OTE* ObjectMemory::ReconcileZct(OTE* ote)
{
#ifdef _DEBUG
	DWORD dwTicksNow = timeGetTime();
	if (!alwaysReconcileOnAdd)
	{
		TRACELOCK();
		TRACESTREAM << "Reconciling Zct after " << dec << dwTicksNow - dwLastReconcileTicks << " mS: ";
		//Interpreter::DumpOTEPoolStats();
		TRACESTREAM << "..." << endl;
	}
	dwLastReconcileTicks = dwTicksNow;
	const int nOldZctEntries = m_nZctEntries;
#endif

	Interpreter::flushAtCaches();

	EmptyZct();
	PopulateZct();

	#ifdef _DEBUG
	if (!alwaysReconcileOnAdd)
	{
		DWORD dwTicksAfter = timeGetTime();
		trace("Zct reconciled in %dmS: %d objects were deleted, %d slots free'd, %d still in use\n", dwTicksAfter - dwTicksNow, nDeleted, nOldZctEntries - m_nZctEntries, m_nZctEntries);
		//Interpreter::DumpOTEPoolStats();
		if (m_nZctEntries > 0 && Interpreter::executionTrace != 0)
			DumpZct();
	}
	#endif

	return ote;
}

void ObjectMemory::EmptyZct()
{
	if (m_bIsReconcilingZct)
		__debugbreak();
#ifdef _DEBUG
	nDeleted = 0;

	if (!alwaysReconcileOnAdd || Interpreter::executionTrace)
		CHECKREFSNOFIX
	else
		checkStackRefs();
#endif

	// Bump the refs from the stack. Any objects remaining in the ZCT with zero counts
	// are truly garbage.
	Interpreter::IncStackRefs();

	OTE** pZct = m_pZct;
	// This tells us that we are in the process of reconcilation
	m_bIsReconcilingZct = true;
	const int nOldZctEntries = m_nZctEntries;
	m_nZctEntries = -1;

	for (int i=0;i<nOldZctEntries;i++)
	{
		OTE* ote = pZct[i];
		if (!ote->isFree() && ote->m_flags.m_count == 0)
		{
			// Note that deallocate cannot make new Zct entries
			// Because we have bumped the ref. counts of all stack ref'd objects, only true
			// garbage objects can ever have a ref. count of zero. Therefore if recursively
			// counting down throws up new zero ref. counts, these should not be added to 
			// the Zct, but deallocated. To achieve this we set a global flag to indicate
			// that we are reconciling, see AddToZct() above. 
#ifdef _DEBUG
			nDeleted++;
#endif
			recursiveFree(ote);
		}
	}

//	CHECKREFSNOFIX
}

void ObjectMemory::PopulateZct()
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
	Interpreter::DecStackRefs();
#ifdef _DEBUG
	alwaysReconcileOnAdd = bLast;
	//CHECKREFSNOFIX
#endif

	if (m_nZctEntries > (m_nZctHighWater - m_nZctHighWater/4))
	{
		// More than 75% full, then grow it
		GrowZct();
	}
	else if ((m_nZctHighWater > (int)ZctMinSize) && (m_nZctEntries < m_nZctHighWater/4))
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
	TRACESTREAM << "===========================================================" << endl;
	TRACESTREAM << "ZCT @ " << hex << m_pZct << ", size: " << dec << m_nZctEntries << endl;
	TRACESTREAM << "===========================================================" << endl;

	for (int i=0;i<m_nZctEntries;i++)
		TRACESTREAM << dec << i << ": " << hex << (DWORD)m_pZct[i] << ": " << m_pZct[i] << endl;

	TRACESTREAM << "===========================================================" << endl;
}
#endif