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
#include "InterlockedOps.h"

// Smalltalk classes
#include "STExternal.h"

// Timer resolution (hopefully 1 millisecond)
static UINT wTimerRes = 1;
static UINT wTimerMax = 0xFFFF;

// Defines the maximum acceptable timer resolution, over which the VM refuses to run
static const UINT MAXTIMERRES = 60;

// Private timer function static. Modified by two threads.
static volatile UINT timerID;

SemaphoreOTE* Interpreter::m_oteTimerSem;

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
void CALLBACK Interpreter::TimeProc(UINT uID, UINT /*uMsg*/, DWORD /*dwUser*/, DWORD /*dw1*/, DWORD /*dw2*/)
{
	// Avoid firing a timer which has been cancelled (or is about to be cancelled!)
	// We use an InterlockedExchange() to set the value to 0 so that the main thread
	// can recognise that the timer has fired without race conditions

	if (::InterlockedExchange(LPLONG(&timerID), 0) != 0)
	{
		// If not previously killed (which is very unlikely except in certain exceptional
		// circumstances where the timer is killed at the exact moment it is about to fire)
		// then go ahead and signal the semaphore and the wakeup event

		// We mustn't access Pointers from an async thread when object memory is compacting
		// as the Pointer will be wrong
		GrabAsyncProtect();
		SemaphoreOTE* timerSemaphore = m_oteTimerSem;
		if (!timerSemaphore->isNil())
		{
			HARDASSERT(!ObjectMemoryIsIntegerObject(timerSemaphore));
			HARDASSERT(!timerSemaphore->isFree());
			HARDASSERT(timerSemaphore->m_oteClass == Pointers.ClassSemaphore);

			// Asynchronously signal the required semaphore asynchronously, which will be detected
			// in sync. with the dispatching of byte codes, and properly signalled
			asynchronousSignalNoProtect(timerSemaphore);
			// Signal the timing Event, in case the idle process has put the VM to sleep
			SetWakeupEvent();
		}
		RelinquishAsyncProtect();
	}
	else
		// An old timer (which should have been cancelled) has fired
		trace("Old timer %d fired, current %d\n", uID, timerID);
}

///////////////////////////////////////////////////////////////////////////////
// Timer/Idling Primitives

// Signal a specified semaphore after the specified milliseconds duration. 
// NOTE: NOT ABSOLUTE VALUE!
// The first argument is a Semaphore, and the second is a millisecond value
// (a SmallInteger). If the specified time has already passed,
// then the Semaphore is signalled immediately. Note that the primitive only remembers
// one Semaphore to signal, so if a new call is made before the last Semaphore has
// been signalled, then the last semaphore will not be signalled. If the first argument
// is not a Semaphore, then any currently waiting Semaphore will also be forgotten.
BOOL __fastcall Interpreter::primitiveSignalAtTick(CompiledMethod&, unsigned argumentCount)
{
	argumentCount;
	HARDASSERT(argumentCount == 2);

	Oop tickPointer = stackTop();
	SMALLINTEGER nDelay;

	if (ObjectMemoryIsIntegerObject(tickPointer))
		nDelay = ObjectMemoryIntegerValueOf(tickPointer);
	else
	{
		OTE* oteArg = reinterpret_cast<OTE*>(tickPointer);
		return primitiveFailureWith(PrimitiveFailureNonInteger, oteArg);	// ticks must be SmallInteger
	}

	if (nDelay > SMALLINTEGER(wTimerMax))
		return primitiveFailureWithInt(PrimitiveFailureBadValue, nDelay);			// Too large

	// To avoid any race conditions against the global timerID value (it is quite
	// common for the timer to fire, for example, before the timeSetEvent() call
	// has actually returned in the duration is very short because the timer thread
	// is operating at a very high priority), we use an interlocked operation

	UINT outstandingID = ::InterlockedExchange(LPLONG(&timerID), 0);
	// If outstanding timer now fires, it will do nothing. We'll end up killing something which is already
	// dead of course, but that should be OK
	if (outstandingID)
	{
		#ifdef OAD
			TRACESTREAM << "Killing existing timer with id " << outstandingID << endl;
		#endif
		UINT kill = ::timeKillEvent(outstandingID);
		if (kill != TIMERR_NOERROR)
			trace("Failed to kill timer %u (%d,%d)!\n\r", outstandingID, kill, GetLastError());
	}

	::InterlockedExchange(LPLONG(&m_oteTimerSem), LONG(Pointers.Nil));
	SemaphoreOTE* semaphorePointer = reinterpret_cast<SemaphoreOTE*>(stackValue(1));

	if (ObjectMemory::fetchClassOf(Oop(semaphorePointer)) == Pointers.ClassSemaphore)
	{
		if (nDelay < int(wTimerRes))
		{
#ifdef _DEBUG
			TRACESTREAM << "Requested delay " << dec << nDelay << " passed, signalling immediately" << endl;
#endif
			// The request time has already passed, or does not fall within the
			// available timer resolution (i.e. it will happen too soon), so signal
			// it immediately
			// We must adjust stack before signalling, as may change Process (and therefore stack!)
			pop(2);
			// The semaphore must not go away, as we retain no ref. to it
			ASSERT(!semaphorePointer->isFree());

			// N.B. Signalling may detect a process switch, but does not actually perform it
			signalSemaphore(semaphorePointer);
		}
		else
		{
			// Set the timerID to a non-zero value just in case the timer fires before timeSetEvent() returns.
			// This allows the TimerProc to recognise the timer as valid (it doesn't really care about the 
			// timerID anyway, just that we're interested in it).
			// N.B. We shouldn't need an interlocked operation here because, assuming no bugs in the Win32 MM
			// timers, we've killed any outstanding timer, and the timer thread should be dormant
			timerID = UINT(-1);		// Rely on the fact that -1 is not used as a timer ID. Unsafe?

			// Because a compact may occur while the Timer is outstanding, we can't pass an Oop out
			// as the cookie, but have to store down the value in m_oteTimerSem instead
			semaphorePointer->beSticky();
			::InterlockedExchange(LPLONG(&m_oteTimerSem), LONG(semaphorePointer));
			UINT newTimerID = ::timeSetEvent(nDelay, 0, TimeProc, 0, TIME_ONESHOT);
			if (newTimerID && newTimerID != UINT(-1))
			{
				// Unless timer has already fired, record the timer id so can cancel if necessary
				::OAInterlockedCompareExchange((PVOID*)(&timerID), PVOID(newTimerID), PVOID(-1));
				pop(2);		// No ref. counting required
			}
			else
			{
				// System refused to set timer for some reason
				::InterlockedExchange(LPLONG(&m_oteTimerSem), LONG(Pointers.Nil));
				trace("Oh no, failed to set a timer for %d mS (%d)!\n\r", nDelay, GetLastError());
				return primitiveFailureWithInt(PrimitiveFailureSystemError, newTimerID);
			}
		}
	}
	// else we allow this to clear down the existing timer


	#ifdef _DEBUG
		if (newProcessWaiting())
		{
			ASSERT(m_oteNewProcess->m_oteClass ==Pointers.ClassProcess);
			ProcessOTE* activeProcess = scheduler()->m_activeProcess;

			TRACESTREAM << "signalAtTick: Caused process switch to " << m_oteNewProcess
				<< endl << "\t\tfrom " << activeProcess << endl
				<< "\tasync signals " << m_qAsyncSignals.isEmpty()<< ')' << endl;
		}
	#endif


	// Delay could already have fired
	CheckProcessSwitch();
	return primitiveSuccess();
}

#ifndef _M_IX86
BOOL __fastcall Interpreter::primitiveMillisecondClockValue()
{
	return replaceStackTopObjectNoRefCnt(Integer::NewUnsigned32WithRef(timeGetTime()));
}
#endif

// Establish the desired timer resolution and create the Win32 event used to terminate
// VM idling when a timer fires
#pragma code_seg(INIT_SEG)
HRESULT Interpreter::initializeTimer()
{
	m_oteTimerSem = reinterpret_cast<SemaphoreOTE*>(Pointers.Nil);
	timerID = 0;
	TIMECAPS tc;
	tc.wPeriodMin = tc.wPeriodMax = wTimerRes;
	::timeGetDevCaps(&tc, sizeof(TIMECAPS));
	wTimerRes = min(max(tc.wPeriodMin, wTimerRes), tc.wPeriodMax) - 1;
	wTimerMax = tc.wPeriodMax;
	do
	{
		wTimerRes++;
		if (wTimerRes > MAXTIMERRES)
			return ReportError(IDP_BADTIMERRES, MAXTIMERRES);
	} while (::timeBeginPeriod(wTimerRes) != TIMERR_NOERROR);

#ifdef _DEBUG
	trace("Established timer resolution of %u mS\n", wTimerRes);
#endif

	return S_OK;
}

#pragma code_seg(TERM_SEG)
void Interpreter::terminateTimer()
{
	static const char* szFmt = "Shutdown Error %u calling %s(%u)\n";
	MMRESULT err;
	if (timerID != 0)
	{
		err = ::timeKillEvent(timerID);
		if (err != TIMERR_NOERROR)
			trace(szFmt, err, "timeKillEvent", timerID);
	}

	err = ::timeEndPeriod(wTimerRes);
	if (TIMERR_NOERROR != err)
		trace(szFmt, err, "timeEndPeriod", wTimerRes);
}


