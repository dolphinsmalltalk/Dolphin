/******************************************************************************

	File: Sampler.cpp

	Description:

	Backtround sampler thread - doesn't do the actual sampling, just notifies
	the main thread when it needs to be done.

******************************************************************************/
#include "Ist.h"

#include "ObjMem.h"
#include "Interprt.h"
#include "rc_vm.h"				// For error message ids
#include "InterprtPrim.inl"
#include "InterprtProc.inl"

// Smalltalk classes
#include "STExternal.h"

HANDLE Interpreter::m_hSampleTimer;
#ifdef _DEBUG
	DWORD dwTicksReset;
#endif

VOID CALLBACK Interpreter::SamplerProc(PVOID , BOOLEAN TimerOrWaitFired)
{
	if (!TimerOrWaitFired)
		return;
	if (::InterlockedDecrement((LPLONG)&m_nInputPollCounter) == 0)
	{
		NotifyAsyncPending();
#if 0//def _DEBUG
		DWORD dwTicksNow = timeGetTime();
		Semaphore* sem = Pointers.InputSemaphore->m_location;
		TRACE("Fired after %d, last reset at %d, signals %d\n\r", dwTicksNow-dwTicksReset, dwTicksReset, ObjectMemoryIntegerValueOf(sem->m_excessSignals));
#endif
	}
}

HRESULT Interpreter::InitializeSampler()
{
	m_hSampleTimer = NULL;
	m_nInputPollInterval = -1;
	ResetInputPollCounter();
#ifdef _DEBUG
	dwTicksReset = 0;
#endif
	return S_OK;
}

HRESULT Interpreter::SetSampleTimer(SMALLINTEGER newInterval)
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	if (newInterval == 0)
		newInterval = m_nInputPollInterval;
	else
		m_nInputPollInterval = newInterval;

	BOOL bSuccess = TRUE;
	if (m_hSampleTimer == NULL)
		bSuccess = ::CreateTimerQueueTimer(&m_hSampleTimer, NULL, SamplerProc, NULL, m_nInputPollInterval, m_nInputPollInterval, WT_EXECUTEINTIMERTHREAD);
	else
		if (newInterval != m_nInputPollInterval)
			bSuccess = ::ChangeTimerQueueTimer(NULL, m_hSampleTimer, m_nInputPollInterval, m_nInputPollInterval);

	if (!bSuccess)
	{
		DWORD dwErr = GetLastError();
		return HRESULT_FROM_WIN32(dwErr);
	}

#ifdef _DEBUG
	dwTicksReset = timeGetTime();
#endif

	return S_OK;
}

void Interpreter::CancelSampleTimer()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	if (m_hSampleTimer != NULL)
	{
		if (!::DeleteTimerQueueTimer(NULL, m_hSampleTimer, INVALID_HANDLE_VALUE))
		{
			DWORD dwErr = GetLastError();
			dwErr;
		}
		m_hSampleTimer = NULL;
	}
}

void Interpreter::TerminateSampler()
{
	CancelSampleTimer();
}