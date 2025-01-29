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
			CHECKREFERENCES
			queueInterrupt(VMInterrupts::OtOverflow, ObjectMemoryIntegerObjectOf(ObjectMemory::GetOTSize()));
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
		CHECKREFERENCES
		queueInterrupt(VMInterrupts::OtOverflow, ObjectMemoryIntegerObjectOf(ObjectMemory::GetOTSize()));
	}
}

void Interpreter::syncGC(uintptr_t gcFlags)
{
	FlushPools();
	asyncGC(gcFlags);
	CheckProcessSwitch();
}

void Interpreter::asyncGC(uintptr_t gcFlags)
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
		Interpreter::DumpOTEPoolStats();
	}
#endif

	ObjectMemory::asyncGC(gcFlags, m_registers.m_stackPointer);
}

#ifndef _DEBUG
	#pragma auto_inline(on)
#endif


// This has been usurped for GC primitive
Oop* PRIMCALL Interpreter::primitiveCoreLeft(Oop* const sp , primargcount_t argCount)
{
	CHECKREFERENCESSP(sp);

	uintptr_t gcFlags = 0;
	if (argCount)
	{
		ASSERT(argCount == 1);
		Oop intPointer = *sp;
		ASSERT(ObjectMemoryIsIntegerObject(intPointer));
		gcFlags = ObjectMemoryIntegerValueOf(intPointer);
		m_registers.m_stackPointer -= argCount;
	}

	syncGC(gcFlags);
	return m_registers.m_stackPointer;
}

#ifdef _DEBUG
void Interpreter::DumpOTEPoolStats()
{
	m_blockPool.DumpStats();
	m_contextPool.DumpStats();
	m_floatPool.DumpStats();
	m_dwordPool.DumpStats();

}
#endif

void Interpreter::FlushPools()
{
	m_blockPool.clear();
	m_contextPool.clear();
	m_floatPool.clear();
	m_dwordPool.clear();
}

Oop* PRIMCALL Interpreter::primitiveOopsLeft(Oop* const sp, primargcount_t)
{
	// Ensure active process has the correct size and that the Zct is empty
	// and all ref counts are correct
	resizeActiveProcess();

	// Compact will perform a GC, and will also change the Oops of objects
	// so any that are saved down in Smalltalk will be invalidated.
	GrabAsyncProtect();
	// It is OK for compact to perform additional GrabAsyncProtects()
	SmallInteger oopsLeft = ObjectMemory::compact(sp);
	RelinquishAsyncProtect();

	// compact() returns -1 if unable to reserve space for a new OT. This can happen
	// if a very large maximum object setting is used on a machine with relatively little
	// virtual memory
	if (oopsLeft < 0)
		return primitiveFailure(_PrimitiveFailureCode::NoMemory);

	// Adjust stack before any process switch!
	*sp = ObjectMemoryIntegerObjectOf(oopsLeft);

	// N.B. May cause a process switch
	CheckProcessSwitch();

	return m_registers.m_stackPointer;
}
