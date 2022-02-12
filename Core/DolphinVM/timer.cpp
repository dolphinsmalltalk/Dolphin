/******************************************************************************

	File: Timer.cpp

	Description:

	Implementation of the Interpreter class' timer related methods

	Only one timer should every be active at any one time, so bear
	that in mind when examining the code herein.

******************************************************************************/
#include "Ist.h"

#pragma comment(lib, "winmm.lib")

#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "rc_vm.h"				// For error message ids
#include "InterprtPrim.inl"
#include "InterprtProc.inl"

// Smalltalk classes
#include "STExternal.h"

static UINT wTimerMax = 0xFFFF;

// Defines the maximum acceptable timer resolution, over which the VM refuses to run
static const UINT MAXTIMERRES = 60;

// Private timer function static. Modified by two threads.
static volatile UINT timerID;

uint64_t Interpreter::m_clockFrequency;

///////////////////////////////////////////////////////////////////////////////
// Smalltalk Alarm/Delay/Timers
//
// We use the Multimedia Timers because these do not fire via the message loop
// (i.e. they come back directly as under as separate thread of control in Win32), 
// and are therefore much closer to the Smalltalk timer concept. These have a 
// further advantage that they can operate at a much finer granularity 
// (down to 1 millisecond).
//
// When we are unable to use an MM timer (e.g. because the period requested is
// too long) we can fall back on a normal Win32 timer, but these are less
// accurate, and require that the message loop is active (which SHOULD normally
// be the case, but somebody could have fiddled with the Smalltalk so there's no
// guarantee).
//

// Callback proc for MM timers
// N.B. This routine is called from a separate thread (in Win32), rather than in
// interrupt time, but careful coding is still important. The recommended 
// list of routines is limited to:
//		EnterCriticalSection	ReleaseSemaphore
//		LeaveCriticalSection	SetEvent
//		timeGetSystemTime		timeGetTime
//		OutputDebugString		timeKillEvent
//		PostMessage				timeSetEvent
//
// "If a Win32 low-level audio callback [we are using mm timers here] shares data 
// with other code, a Critical Section or similar mutual exclusion mechanism should 
// be used to protect the integrity of the data".
// Access to the asynchronous semaphore array is protected by a critical section
// in the asynchronousSignal and CheckProcessSwitch routines. We don't really care
// that much about the timerID
void CALLBACK Interpreter::TimeProc(UINT uID, UINT /*uMsg*/, DWORD_PTR /*dwUser*/, DWORD_PTR /*dw1*/, DWORD_PTR /*dw2*/)
{
	// Avoid firing a timer which has been cancelled (or is about to be cancelled!)
	// We use an InterlockedExchange() to set the value to 0 so that the main thread
	// can recognise that the timer has fired without race conditions

	if (InterlockedExchange(reinterpret_cast<SHAREDLONG*>(&timerID), 0) != 0)
	{
		// If not previously killed (which is very unlikely except in certain exceptional
		// circumstances where the timer is killed at the exact moment it is about to fire)
		// then go ahead and signal the semaphore and the wakeup event

		// We mustn't access Pointers from an async thread when object memory is compacting
		// as the Pointer will be wrong
		GrabAsyncProtect();

		SemaphoreOTE* timerSemaphore = Pointers.TimingSemaphore;
		HARDASSERT(!ObjectMemoryIsIntegerObject(timerSemaphore));
		HARDASSERT(!timerSemaphore->isFree());
		HARDASSERT(timerSemaphore->m_oteClass == Pointers.ClassSemaphore);

		// Asynchronously signal the required semaphore asynchronously, which will be detected
		// in sync. with the dispatching of byte codes, and properly signalled
		asynchronousSignalNoProtect(timerSemaphore);
		// Signal the timing Event, in case the idle process has put the VM to sleep
		SetWakeupEvent();

		RelinquishAsyncProtect();
	}
	else
		// An old timer (which should have been cancelled) has fired
		TRACE(L"Old timer %d fired, current %d\n", uID, timerID);
}

///////////////////////////////////////////////////////////////////////////////
// Timer/Idling Primitives

// Signal a specified semaphore after the specified milliseconds duration (the argument). 
// NOTE: NOT ABSOLUTE VALUE!
// If the specified time has already passed, then the TimingSemaphore is signalled immediately. 
Oop* PRIMCALL Interpreter::primitiveSignalAtTick(Oop* const sp, primargcount_t)
{
	Oop tickPointer = *sp;
	SmallInteger nDelay;

	if (ObjectMemoryIsIntegerObject(tickPointer))
		nDelay = ObjectMemoryIntegerValueOf(tickPointer);
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// ticks must be SmallInteger
	}

	// To avoid any race conditions against the global timerID value (it is quite
	// common for the timer to fire, for example, before the timeSetEvent() call
	// has actually returned in the duration is very short because the timer thread
	// is operating at a very high priority), we use an interlocked operation

	UINT outstandingID = InterlockedExchange(reinterpret_cast<SHAREDLONG*>(&timerID), 0);
	// If outstanding timer now fires, it will do nothing. We'll end up killing something which is already
	// dead of course, but that should be OK
	if (outstandingID)
	{
#ifdef OAD
		TRACESTREAM<< L"Killing existing timer with id " << outstandingID << std::endl;
#endif
		UINT kill = ::timeKillEvent(outstandingID);
		if (kill != TIMERR_NOERROR)
			trace(L"Failed to kill timer %u (%d,%d)!\n\r", outstandingID, kill, GetLastError());
	}

	if (nDelay > 0)
	{
		// Clamp the requested delay to the maximum if it is too large. This simplifies the Delay code in the image a little.
		if (nDelay > SmallInteger(wTimerMax))
		{
			nDelay = wTimerMax;
		}

		// Set the timerID to a non-zero value just in case the timer fires before timeSetEvent() returns.
		// This allows the TimerProc to recognise the timer as valid (it doesn't really care about the 
		// timerID anyway, just that we're interested in it).
		// N.B. We shouldn't need an interlocked operation here because, assuming no bugs in the Win32 MM
		// timers, we've killed any outstanding timer, and the timer thread should be dormant
		InterlockedExchange(&timerID, static_cast<UINT>(-1));		// -1 is not used as a timer ID.

		UINT newTimerID = ::timeSetEvent(nDelay, 0, TimeProc, 0, TIME_ONESHOT);
		if (newTimerID && newTimerID != UINT(-1))
		{
			// Unless timer has already fired, record the timer id so can cancel if necessary
			InterlockedCompareExchange(reinterpret_cast<SHAREDLONG*>(&timerID), newTimerID, -1);
			pop(1);		// No ref. counting required
		}
		else
		{
			DWORD dwErr = GetLastError();
			// System refused to set timer for some reason
			trace(L"Oh no, failed to set a timer for %d mS (%d)!\n\r", nDelay, dwErr);
			return primitiveFailure(static_cast<_PrimitiveFailureCode>(PFC_FROM_WIN32(dwErr)));
		}
	}
	else if (nDelay == 0)
	{
#ifdef _DEBUG
		TRACESTREAM<< L"Requested delay " << std::dec << nDelay<< L" passed, signalling immediately" << std::endl;
#endif
		// The request time has already passed, or does not fall within the
		// available timer resolution (i.e. it will happen too soon), so signal
		// it immediately
		// We must adjust stack before signalling, as may change Process (and therefore stack!)
		pop(1);

		// N.B. Signalling may detect a process switch, but does not actually perform it
		signalSemaphore(Pointers.TimingSemaphore);
	}
	// else requested delay was negative - we allow this to clear down the existing timer

#ifdef _DEBUG
	if (newProcessWaiting())
	{
		ASSERT(m_oteNewProcess->m_oteClass == Pointers.ClassProcess);
		ProcessOTE* activeProcess = scheduler()->m_activeProcess;

		TRACESTREAM<< L"signalAtTick: Caused process switch to " << m_oteNewProcess
			<< std::endl<< L"\t\tfrom " << activeProcess << std::endl
			<< L"\tasync signals " << m_qAsyncSignals.isEmpty() << L')' << std::endl;
	}
#endif

	// Delay could already have fired
	CheckProcessSwitch();

	return primitiveSuccess(0);
}

Oop* PRIMCALL Interpreter::primitiveMillisecondClockValue(Oop* const sp, primargcount_t)
{
	Oop result = Integer::NewUnsigned64(GetMicrosecondClock()/1000);
	*sp = result;
	ObjectMemory::AddOopToZct(result);
	return sp;
}

Oop* PRIMCALL Interpreter::primitiveMicrosecondClockValue(Oop* const sp, primargcount_t)
{
	Oop result = Integer::NewUnsigned64(GetMicrosecondClock());
	*sp = result;
	ObjectMemory::AddOopToZct(result);
	return sp;
}

uint64_t Interpreter::GetMicrosecondClock()
{
	// QPC is declared as returning (via out param) a signed value, but this makes no sense because
	// the function boils down to a wrapper around the RDTSC instruction, which Intel's docs make
	// clear provides an unsigned 64-bit counter.
	// Treating the value as unsigned allows for more efficient division operations, and of course
	// we never want a negative value for this counter (even if we'd have turned to stone long before)

	uint64_t counter;
	// Don't bother checking return value as according to the MSDN docs this won't fail on XP and later 
	::QueryPerformanceCounter(reinterpret_cast<LARGE_INTEGER*>(&counter));

	uint64_t seconds = counter / m_clockFrequency;
	uint64_t remainder = counter % m_clockFrequency;
	uint64_t microsecs = seconds * 1000000 + (remainder * 1000000 / m_clockFrequency);
	return microsecs;
}

// Establish the desired timer resolution and create the Win32 event used to terminate
// VM idling when a timer fires
#pragma code_seg(INIT_SEG)
HRESULT Interpreter::initializeTimer()
{
	if (::QueryPerformanceFrequency(reinterpret_cast<LARGE_INTEGER*>(&m_clockFrequency)) == 0)
	{
		// MSDN says this shouldn't happen: "On systems that run Windows XP or later, the function will always succeed and will thus never return zero."
		return ReportWin32Error(IDP_NOHIRESCLOCK, ::GetLastError());
	}

	timerID = 0;
	TIMECAPS tc;
	::timeGetDevCaps(&tc, sizeof(TIMECAPS));
	wTimerMax = tc.wPeriodMax;

	return S_OK;
}

#pragma code_seg(TERM_SEG)
void Interpreter::terminateTimer()
{
	MMRESULT err;
	if (timerID != 0)
	{
		err = ::timeKillEvent(timerID);
		if (err != TIMERR_NOERROR)
			trace(L"Shutdown Error %u calling %s(%u)\n", err, L"timeKillEvent", timerID);
	}
}


