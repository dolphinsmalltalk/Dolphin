/******************************************************************************

	File: GCPrim.cpp

	Description:

	Implementation of the Interpreter class' GC primitive methods

******************************************************************************/
#include "Ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#pragma code_seg(GC_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

// Smalltalk objects
#include "STMethod.h"
#include "STBlockClosure.h"

bool Interpreter::disableAsyncGC(bool bDisable)
{
	if (bDisable == m_bAsyncGCDisabled) return bDisable;
	
	m_bAsyncGCDisabled = bDisable;
	if (!m_bAsyncGCDisabled)
	{
		// If previously disabled, may be OT overflow interrupts pending that we should consolidate
		// into one
		if (m_nOTOverflows > 0)
		{
			m_nOTOverflows = 0;
			queueInterrupt(VMI_OTOVERFLOW, ObjectMemoryIntegerObjectOf(ObjectMemory::GetOTSize()));
		}
		return true;
	}
	else
		return false;
}

void Interpreter::NotifyOTOverflow()
{
	if (m_bAsyncGCDisabled)
	{
		m_nOTOverflows++;
	}
	else
	{
		queueInterrupt(VMI_OTOVERFLOW, ObjectMemoryIntegerObjectOf(ObjectMemory::GetOTSize()));
	}
}

void Interpreter::syncGC(DWORD gcFlags)
{
	asyncGC(gcFlags);
	CheckProcessSwitch();
}

void Interpreter::asyncGC(DWORD gcFlags)
{
	if (m_bAsyncGCDisabled)
	{
		m_nOTOverflows++;
		return;
	}

	resizeActiveProcess();

#ifdef _DEBUG
	if (Interpreter::executionTrace != 0)
	{
		for (unsigned i=0;i<NUMOTEPOOLS;i++)
			m_otePools[i].DumpStats();
	}
#endif

	ObjectMemory::asyncGC(gcFlags, m_registers.m_stackPointer);
}

#ifndef _DEBUG
	#pragma auto_inline(on)
#endif


// This has been usurped for GC primitive
Oop* __fastcall Interpreter::primitiveCoreLeft(void* , unsigned argCount)
{
	DWORD gcFlags = 0;
	if (argCount)
	{
		ASSERT(argCount == 1);
		Oop intPointer = popStack();
		ASSERT(ObjectMemoryIsIntegerObject(intPointer));
		gcFlags = ObjectMemoryIntegerValueOf(intPointer);
	}

	syncGC(gcFlags);
	return primitiveSuccess(0);
}

#ifdef _DEBUG
void Interpreter::DumpOTEPoolStats()
{
	for (unsigned i=0;i<NUMOTEPOOLS;i++)
		m_otePools[i].DumpStats();
}
#endif

void Interpreter::freePools()
{
	#if defined(_DEBUG) && defined(VMDLL)
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM << "Clearing down OTE pools. Stats before clear..." << endl;
	}
	#endif

	// Must first adjust context size back to normal for free
	// in case from a pool (avoids freeing mem back to smaller pool)
	{
		OTE* ote = m_otePools[CONTEXTPOOL].m_pFreeList;
		const MWORD sizeOfPoolContext = SizeOfPointers(Context::FixedSize+Context::MaxEnvironmentTemps);
		while (ote)
		{
			VariantObject* obj = static_cast<VariantObject*>(ote->m_location);
			ote->setSize(sizeOfPoolContext);
			ote = reinterpret_cast<OTE*>(obj->m_fields[0]);
		}
	}

	{
		OTE* ote = m_otePools[BLOCKPOOL].m_pFreeList;
		const MWORD sizeOfPoolBlock = SizeOfPointers(BlockClosure::FixedSize+BlockClosure::MaxCopiedValues);
		while (ote)
		{
			VariantObject* obj = static_cast<VariantObject*>(ote->m_location);
			ote->setSize(sizeOfPoolBlock);
			ote = (OTE*)obj->m_fields[0];
		}
	}

	#ifdef _DEBUG
		//DumpOTEPoolStats();
	#endif

	for (unsigned i=0;i<NUMOTEPOOLS;i++)
		m_otePools[i].clear();

	#if defined(_DEBUG) && defined(VMDLL)
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM << endl;
	}
	#endif
}

Oop* __fastcall Interpreter::primitiveOopsLeft()
{
	// Ensure active process has the correct size and that the Zct is empty
	// and all ref counts are correct
	resizeActiveProcess();

	// Compact will perform a GC, and will also change the Oops of objects
	// so any that are saved down in Smalltalk will be invalidated.
	GrabAsyncProtect();
	// It is OK for compact to perform additional GrabAsyncProtects()
	SMALLINTEGER oopsLeft = ObjectMemory::compact(m_registers.m_stackPointer);
	RelinquishAsyncProtect();

	// compact() returns -1 if unable to reserve space for a new OT. This can happen
	// if a very large maximum object setting is used on a machine with relatively little
	// virtual memory
	if (oopsLeft < 0)
		return primitiveFailure(1);

	// Adjust stack before any process switch!
	stackTop() = ObjectMemoryIntegerObjectOf(oopsLeft);

	// N.B. May cause a process switch
	CheckProcessSwitch();

	return primitiveSuccess(0);
}
