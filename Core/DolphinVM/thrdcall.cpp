/******************************************************************************

	File: thrdcall.cpp

	Description:

	External threaded calls.

******************************************************************************/
#include "Ist.h"
#pragma code_seg(FFI_SEG)

#include "Interprt.h"
#include "InterprtProc.inl"
#include "STExternal.h"
#include "VMExcept.h"
#include "RaiseThreadException.h"
#include "RegKey.h"
#include "STInteger.h"

#include "thrdcall.h"

void __cdecl DebugCrashDump(LPCWSTR szFormat, ...);
void __cdecl DebugDump(LPCWSTR szMsg);

// Disable warning about use of SEH in conjunction with objects with destructors
#pragma warning (disable : 4509)

///////////////////////////////////////////////////////////////////////////////
// Static data members
///////////////////////////////////////////////////////////////////////////////

// Note that this static must only be accessed from the main interpreter thread
// Its purpose is to maintain a list of all overlapped calls objects for admin
// of same.
OverlappedCallList OverlappedCall::s_activeList;

// Time permitted for threads to complete before main thread gives up
static DWORD s_dwTerminateTimeout;
static bool bIsNT;

const DWORD SE_VMTERMINATETHREAD = MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, 0x300);


inline void Process::NewOverlapSemaphore()
{
	ObjectMemory::storePointerWithValue(*reinterpret_cast<Oop*>(&m_waitOverlap), reinterpret_cast<OTE*>(Semaphore::New()));
}

inline void Process::SetThread(void* handle)
{
	ObjectMemory::storePointerWithUnrefCntdValue(m_thread, Oop(handle) + 1);
}

///////////////////////////////////////////////////////////////////////////////
// List management
///////////////////////////////////////////////////////////////////////////////

// The overlapped thread has completed a call, return to the idle state
bool OverlappedCall::CallFinished()
{
	return InterlockedCompareExchange(reinterpret_cast<SHAREDLONG*>(&m_state), Resting, Returned) == Returned;
}

OverlappedCallPtr OverlappedCall::GetActiveProcessOverlappedCall()
{
	// We no longer have a pool (for simplicity), so just answer a new thread every time.
	// The thread will be retained for use for all subseqeunt overlapped calls from the 
	// associated process.
	// The new OverlappedCall will have an initial reference of one from its
	// own thread. At the moment we have no ref. count on it.

	Process* pActiveProcess = Interpreter::actualActiveProcess();
	OverlappedCallPtr pOverlapped = pActiveProcess->GetOverlappedCall();
	if (!pOverlapped)
	{
		ProcessOTE* oteProcess = Interpreter::actualActiveProcessPointer();
		pOverlapped = OverlappedCall::New(oteProcess);
		pActiveProcess->SetThread(pOverlapped);
		pActiveProcess->NewOverlapSemaphore();
	}

	return pOverlapped;
}

// Allocate an OverlappedCall from the pool, or create a new one if none available
OverlappedCallPtr OverlappedCall::New(ProcessOTE* oteProcess)
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	OverlappedCall* answer = new OverlappedCall(oteProcess);
	s_activeList.AddFirst(answer);
	return answer;
}

///////////////////////////////////////////////////////////////////////////////
// Init and cleanup
///////////////////////////////////////////////////////////////////////////////

// Static initialization of async call support
void OverlappedCall::Initialize()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	CRegKey rkOverlap;
	if (OpenDolphinKey(rkOverlap, L"Overlapped")==ERROR_SUCCESS)
	{
		rkOverlap.QueryDWORDValue(L"TerminateTimeout", s_dwTerminateTimeout);
		s_dwTerminateTimeout = max(s_dwTerminateTimeout, 100);
	}
	else
	{
		s_dwTerminateTimeout = 500;
	}
}

// Note that this is only called on shutdown
void OverlappedCall::TerminateThread()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	QueueTerminate();
	DWORD dwWaitRet = ::WaitForSingleObject(m_hThread, s_dwTerminateTimeout); dwWaitRet;
	
	#if TRACING == 1
	{
		tracelock lock(::thinDump);
		::thinDump << GetCurrentThreadId()<< L": " << *this<< L" terminated (" << dwWaitRet<< L")" << std::endl;
	}
	#endif
}

OverlappedCallPtr OverlappedCall::RemoveFirstFromList(OverlappedCallList& list)
{
	return list.RemoveFirst();
}

// Static clean up async call support on shutdown
void OverlappedCall::Uninitialize()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	// Terminate all overlapped call threads
	OverlappedCallPtr next = RemoveFirstFromList(s_activeList);
	while (next)
	{
		next->TerminateThread();
		next = RemoveFirstFromList(s_activeList);
	}
}


///////////////////////////////////////////////////////////////////////////////
// Static member functions
///////////////////////////////////////////////////////////////////////////////

inline Semaphore* OverlappedCall::pendingTerms()
{
	return Interpreter::scheduler()->m_pendingTerms->m_location;
}

static HANDLE NewAutoResetEvent()
{
	HANDLE hEvt = ::CreateEvent(NULL, 
			FALSE,	// auto reset
			FALSE,	// initially unsignalled
			NULL);	// unnamed
	if (!hEvt)
	{
		// Unable to initialize the VM, so raise an exception
		DWORD dwErr = ::GetLastError();
		::RaiseException(HRESULT_FROM_WIN32(dwErr), EXCEPTION_NONCONTINUABLE, 0, NULL);
	}
	return hEvt;
}

void OverlappedCall::OnCompact()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	// A compact is in progress, we need to ask the ObjectMemory to update
	// our instances which might have stored down process Oops (i.e. any
	// active or pending termination/completion).

#if TRACING == 1
	{
		tracelock lock(::thinDump);
		::thinDump << L"Compacting outstanding overlapped calls..." << std::endl;
	}
#endif
	{
		CompactCallsOnList(s_activeList);
	}
}

void OverlappedCall::CompactCallsOnList(OverlappedCallList& list)
{
	OverlappedCall* next = list.First();
	while (next)
	{
		next->compact();
		next = next->Next();
	}
}

void OverlappedCall::compact()
{
	HARDASSERT((POTE)m_oteProcess != Pointers.Nil);
	ObjectMemory::compactOop(m_oteProcess);

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L"Compacting " << *this << std::endl;
	}
	#endif

	ObjectMemory::compactOop(m_interpContext.m_oopNewMethod);
}

// Queue an APC to the main interpreter thread
bool Interpreter::QueueAPC(PAPCFUNC pfnAPC, ULONG_PTR closure)
{
	HANDLE hMain = MainThreadHandle();
	if (hMain && ::QueueUserAPC(pfnAPC, hMain, closure))
	{
		InterlockedIncrement(&m_nAPCsPending);

		// The async pending flag is modified in a thread safe manner
		NotifyAsyncPending();

		if (!bIsNT)
			SetWakeupEvent();

		return true;
	}
	else
		return false;
}

void Interpreter::BeginAPC()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());
	InterlockedDecrement(&m_nAPCsPending);
}

OverlappedCallPtr OverlappedCall::BeginMainThreadAPC(ULONG_PTR param)
{
	Interpreter::BeginAPC();
	return BeginAPC(param);
}

OverlappedCallPtr OverlappedCall::BeginAPC(ULONG_PTR param)
{
	// Assume ref. from the APC queue, will Release() when goes out of scope
	return OverlappedCallPtr(reinterpret_cast<OverlappedCall*>(param), false);
}

// Queue an APC to the main interpreter thread
bool OverlappedCall::QueueForInterpreter(PAPCFUNC pfnAPC)
{
	AddRef();	// Reference we are about to create from main threads APC queue
	if (Interpreter::QueueAPC(pfnAPC, reinterpret_cast<ULONG_PTR>(this)))
		return true;
	else
	{
		Release();
		return false;
	}
}

// Queue an APC to the overlapped call thread
bool OverlappedCall::QueueForMe(PAPCFUNC pfnAPC)
{
	AddRef();	// Ref we are about to create from the APC queue
	if (m_hThread && ::QueueUserAPC(pfnAPC, m_hThread, reinterpret_cast<ULONG_PTR>(this)))
		return true;
	else
	{
		Release();
		return false;
	}
}


///////////////////////////////////////////////////////////////////////////////
// Debug Printing

std::wostream& operator<<(std::wostream& stream, const OverlappedCall& oc)
{
	return stream<< L"OverlappedCall(" << &oc 
		<< L", id:" << oc.m_dwThreadId 
		<< L", state: " << oc.m_state
		<< L", suspend:" << oc.m_nSuspendCount 
		<< L", process: " << oc.m_oteProcess
#ifdef _DEBUG
		<< L", refs: " << oc.m_nRefs 
#endif
		<< L")";
}


///////////////////////////////////////////////////////////////////////////////
// Construction

OverlappedCall::OverlappedCall(ProcessOTE* oteProcess) : 
			// Initial ref of 1 for the associated thread, released by smart pointer in ThreadMain
			m_nRefs(1),
			m_hThread(0), m_dwThreadId(0),
			m_hEvtGo(0), m_hEvtCompleted(0),
			m_oteProcess(oteProcess),
			m_nSuspendCount(0),
			m_state(OverlappedCall::Starting),
			m_primitiveFailureCode(_PrimitiveFailureCode::NoError)
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": Created " << *this << std::endl;
	}
	#endif

	oteProcess->countUp();
	Init();
}


///////////////////////////////////////////////////////////////////////////////
// Destruction

OverlappedCall::~OverlappedCall()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": Destroy " << *this << std::endl;
	}
	#endif
}


///////////////////////////////////////////////////////////////////////////////
// Initialization helpers


// Start off the thread, answering whether it worked or not
bool OverlappedCall::BeginThread()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	HARDASSERT(m_hThread == 0);
	// N.B. Start it suspended
	m_hThread = (HANDLE)_beginthreadex(
							/*security=*/		NULL, 
							/*stack_size=*/		0,
							/*start_address*/	ThreadMain,
							/*arglist=*/		this,
							/*initflag=*/		0, //CREATE_SUSPENDED,
							/*thrdaddr=*/		reinterpret_cast<unsigned int*>(&m_dwThreadId));
	return m_hThread != 0;
}

void OverlappedCall::Init()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	m_hEvtGo = NewAutoResetEvent();
	m_hEvtCompleted = NewAutoResetEvent();
	BeginThread();
}

void OverlappedCall::Term()
{
	HARDASSERT(::GetCurrentThreadId() == m_dwThreadId);

	Free();
}

void OverlappedCall::Free()
{
	if (m_hThread != nullptr)
	{
		::CloseHandle(m_hThread);
		m_hThread = nullptr;
	}

	if (m_hEvtGo != nullptr)
	{
		::CloseHandle(m_hEvtGo);
		m_hEvtGo = nullptr;
	}

	if (m_hEvtCompleted != nullptr)
	{
		::CloseHandle(m_hEvtCompleted);
		m_hEvtCompleted = nullptr;
	}
}

///////////////////////////////////////////////////////////////////////////////
// States changes (answers if successful)

OverlappedCall::States OverlappedCall::beTerminated()
{
	// Answer the previous state
	return (States)InterlockedExchange(reinterpret_cast<SHAREDLONG*>(&m_state), Terminated);
}

///////////////////////////////////////////////////////////////////////////////
// Thread loop

extern "C" Oop* __fastcall asyncDLL32Call(CompiledMethod* pMethod, size_t argCount, OverlappedCall* pThis, InterpreterRegisters* pContext);

DWORD OverlappedCall::WaitForRequest()
{
	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": Waiting for call requests: " << *this << std::endl;
	}
	#endif

	DWORD dwRet;
	while ((dwRet = ::WaitForSingleObjectEx(m_hEvtGo, INFINITE, TRUE)) == WAIT_IO_COMPLETION)
	{
		#if TRACING == 1
		{
			TRACELOCK();
			TRACESTREAM << std::hex << GetCurrentThreadId() << L": Processed APCs while waiting: " << *this << std::endl;
		}
		#endif
	}

	return dwRet;
}

int OverlappedCall::ProcessRequests()
{
	// This is the main loop of the background worker (overlapped call) thread
	HARDASSERT(::GetCurrentThreadId() == m_dwThreadId);

	DWORD dwRet;
	// Wait until either there is work to do - a terminate exception could be delivered in an APC, 
	// so the wait is interruptable.
	while ((dwRet = WaitForRequest()) == WAIT_OBJECT_0
		&& InterlockedCompareExchange(reinterpret_cast<SHAREDLONG*>(&m_state), Calling, Resting) == Resting)
	{
		#if TRACING == 1
		{
			TRACELOCK();
			TRACESTREAM << std::hex << GetCurrentThreadId() << L": Calling " << *m_pMethod << "; " << *this << std::endl;
		}
		#endif

		PerformCall();

		#if TRACING == 1
		{
			TRACELOCK();
			TRACESTREAM << std::hex << GetCurrentThreadId() << L": Looping; " << *this << std::endl;
		}
		#endif
	}

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": Exiting (" << dwRet << L"); " << m_dwThreadId << std::endl;
	}
	#endif

	// Allow it to terminate
	return dwRet;
}

bool OverlappedCall::PerformCall()
{
	// Must only be called from the overlapped thread
	HARDASSERT(::GetCurrentThreadId() == m_dwThreadId);

	// Run a call - this will finish by calling SignalCompletion, which will return to it
	// and it (after placing the return value on the stack) then returns here.
	Oop* sp = asyncDLL32Call(m_pMethod, m_nArgCount, this, &m_interpContext);

	HARDASSERT(m_oteProcess->m_location->Thread() == this);

	if (!ObjectMemoryIsIntegerObject(reinterpret_cast<Oop>(sp)))
	{
		#if TRACING == 1
		{
			TRACELOCK();
			TRACESTREAM << std::hex << GetCurrentThreadId() << L": Completed " << *m_pMethod << "; " << *this << std::endl;
		}
		#endif

		InterpreterRegisters& regs = Interpreter::GetRegisters();
		ASSERT(m_interpContext.m_pActiveProcess == regs.m_pActiveProcess);
		regs.m_stackPointer = sp;
		regs.m_pActiveFrame->setStackPointer(sp);
	}
	else
	{
		// The call failed as if it were a primitive failure - the args have
		// not been popped and we need to activate the backup smalltalk code. 
		// However, since the calling Process is in a wait state, we need to 
		// notify the main thread to wake it up
		m_primitiveFailureCode = static_cast<_PrimitiveFailureCode>(ObjectMemoryIntegerValueOf(reinterpret_cast<Oop>(sp)));

		#if TRACING == 1
		{
			TRACELOCK();
			TRACESTREAM << std::hex << GetCurrentThreadId() << L": Call failed: " << static_cast<uint32_t>(m_primitiveFailureCode) << L": " << *this << std::endl;
		}
		#endif

		if (m_state == Calling)
		{
			// Failed before the call was attempted, e.g. due to invalid arguments, so we must notify the Interpreter
			// accordingly to wake the calling thread
			NotifyInterpreterOfCallReturn();
			WaitForInterpreter();
		}
	}

	#ifdef _DEBUG
		//Interpreter::checkReferences(m_interpContext);
	#endif

	bool stayAlive = CallFinished();

	// We don't use any of the old context after here, so even if this thread is immediately
	// reused before it gets a chance to suspend itself, it wont matter
	VERIFY(::SetEvent(m_hEvtCompleted));

	return stayAlive;
}

bool OverlappedCall::Initiate(CompiledMethod* pMethod, argcount_t argCount)
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": Initiate; " << *this << std::endl;
	}
	#endif

	if (IsInCall())
		// Nested overlapped calls are not currently supported
		return false;

	// Now save down contextual information
	m_pMethod = pMethod;
	m_nArgCount = argCount;
	ASSERT(m_oteProcess == Interpreter::actualActiveProcessPointer());

	// Copy context from Interpreter
	// ?? Not sure we'll need all this
	m_interpContext = Interpreter::GetRegisters();

	// As we are about to suspend the process, we must also store down the active frame into
	// the suspended frame, and update the active frame with the current IP/SP.
	m_interpContext.PrepareToSuspendProcess();

	Process* proc = m_oteProcess->m_location;

	// Block the process on its own private Semaphore - this simplifies the completion
	// handling since all that is needed is to async signal the Semaphore from the
	// background thread, and then let the process activation code (in process.cpp)
	// spot that an overlapped call completion is pending. However it does create
	// a ref. count issue since the Semaphore may be the only ref. to the process, and
	// the process is probably the only ref. to the Semaphore.
	Interpreter::QueueProcessOn(m_oteProcess, reinterpret_cast<LinkedListOTE*>(proc->OverlapSemaphore()));

	// OK to start the async. operation now
	// We don't use Suspend/Resume because if thread is not suspended yet 
	// (i.e. it hasn't reached its SuspendThread() call), then calling Resume() here
	// will do nothing, and the thread will suspend itself for ever!
	::SetEvent(m_hEvtGo);

	TODO("Try a deliberate SwitchToThread here to see effect of call completing before we reschedule")

	// Reschedule as we probably need another process to run
	if (Interpreter::schedule() == m_oteProcess)
		DebugBreak();

	//CHECKREFERENCES
	return true;
}

///////////////////////////////////////////////////////////////////////////////
// Thread management to be used from main interpreter thread

bool OverlappedCall::CanComplete()
{
	// Only Process safe if called from main thread
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	InterpreterRegisters& activeContext = Interpreter::GetRegisters();
	HARDASSERT(m_interpContext.m_pActiveProcess == activeContext.m_pActiveProcess);

	if (m_interpContext.m_pActiveFrame != activeContext.m_pActiveFrame)
		return false;

	if (m_nSuspendCount > 0 || m_state != Returned)
		return false;

	HARDASSERT(m_interpContext.m_stackPointer == activeContext.m_stackPointer);
	return true;
}

void OverlappedCall::OnActivateProcess()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	if (CanComplete())
	{
		ASSERT(IsInCall());

		// Let the overlapped thread continue
		::SetEvent(m_hEvtGo);

		// And wait for it to finish (non-alertable since we don't want other completions to interfere)
		DWORD dwRet = ::WaitForSingleObject(m_hEvtCompleted, INFINITE);
		if (dwRet != WAIT_OBJECT_0)
			trace(L"%#x: OverlappedCall(%#x) completion wait terminated abnormally with %#x\n", GetCurrentThreadId(), this, dwRet);

		if (m_primitiveFailureCode != _PrimitiveFailureCode::NoError)
		{
#if TRACING == 1
			{
				TRACELOCK();
				TRACESTREAM << std::hex << GetCurrentThreadId() << L": OnActivateProcess(): Call failed " << *this << std::endl;
			}
#endif

			ASSERT(m_interpContext.m_stackPointer == Interpreter::m_registers.m_stackPointer);
			ASSERT(m_interpContext.m_basePointer == Interpreter::m_registers.m_basePointer);
			Interpreter::m_registers.m_oopNewMethod = m_interpContext.m_oopNewMethod;
			Interpreter::activatePrimitiveMethod(m_interpContext.m_oopNewMethod->m_location, m_primitiveFailureCode);

			m_primitiveFailureCode = _PrimitiveFailureCode::NoError;
		}

		m_interpContext.m_oopNewMethod = reinterpret_cast<MethodOTE*>(Pointers.Nil);
	}
	else
	{
		#if TRACING == 1
		if (m_state != Resting)
		{
			TRACELOCK();
			TRACESTREAM << std::hex << GetCurrentThreadId() << L": OnActivateProcess() state = " << this->m_state << std::endl;
		}
		#endif
	}
}

// Fire off an exception from the main thread into the overlapped thread to cause it
// to terminate the next time it enters an alertable wait state. This may not happen
// immediately.
bool OverlappedCall::QueueTerminate()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());
	
	// Although there is a race condition here, in that the thread may terminate after this
	// test, we don't care because the thread handle will be nulled, and the operations against
	// a NULL thread handle are benign.
	States previousState = beTerminated();
	if (previousState == Terminated || m_hThread == NULL)
		// Already terminated/terminating
		return false;

	// If the thread has entered its base try/catch block then we must use an exception
	// to terminate it. If it hasn't then when it does it will not be able to transition to
	// the running state, and will recognise that as a termination request and drop out.
	if (previousState != Starting)
	{
		#if TRACING == 1
		{
			TRACELOCK();
			TRACESTREAM << std::hex << GetCurrentThreadId()<< L": Queue terminate; " << *this << std::endl;
		}
		#endif

		// Terminate the thread by queueing an APC to it which will raise the terminate exception
		// This will be trapped in the entry point routine, which is static and will not access
		// any of the state herein
		DWORD adwArgs[1];
		adwArgs[0] = (DWORD)this;
		RaiseThreadException(m_hThread, SE_VMTERMINATETHREAD, EXCEPTION_NONCONTINUABLE, 1, adwArgs);
	}

	// Ensure running and therefore able to receive termination request
	InterlockedExchange(&m_nSuspendCount, 0);
	while (long(::ResumeThread(m_hThread)) > 0)
		continue;

	return true;
}

// Handler for suspend message from the main thread. The overlapped thread suspends itself
// to avoid being suspended inside a critical section
void __stdcall OverlappedCall::SuspendAPC(ULONG_PTR param)
{
	// Assume ref. from the APC queue
	OverlappedCallPtr pThis = BeginAPC(param);

	#if TRACING == 1
	{
		CAutoLock<tracestream> lock(pThis->thinDump);
		pThis->thinDump << std::hex << GetCurrentThreadId()<< L": SuspendAPC; " << *pThis << std::endl;
	}
	#endif

	pThis->SuspendThread();
}

///////////////////////////////////////////////////////////////////////////////
// Safely suspend the overlapped call thread when it enters an alertable wait
// state
bool OverlappedCall::QueueSuspend()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	// The resumption count records whether the thread is suspended, or has a suspend queued,
	// so that we can avoid. The APC may not actually suspend the thread if a resume arrives
	// in the meantime and inc's the count.
	InterlockedIncrement(&m_nSuspendCount);

	// To avoid suspending the thread in the middle of a critical section we use APCs again
	// so that can only be suspended when in an alertable wait state.
	// Note this quote from the CRT lib help:
	//	"Using SuspendThread can lead to a deadlock when more than one thread is 
	//	blocked waiting for the suspended thread to complete its access to a C run-time data structure."

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId()<< L": Queue suspend;  " << *this << std::endl;
	}
	#endif

	return QueueForMe(SuspendAPC);
}

// Attempt to resume the thread
DWORD OverlappedCall::Resume()
{
	HARDASSERT(::GetCurrentThreadId() != m_dwThreadId);
	#if TRACING == 1
	{
		tracelock lock(::thinDump);
		::thinDump << std::hex << GetCurrentThreadId()<< L": Resume; " << *this << std::endl;
	}
	#endif
	InterlockedDecrement(&m_nSuspendCount);
	return ResumeThread();
}

// Used by an overlapped thread to suspend itself
void OverlappedCall::SuspendThread()
{
	// Should only be called from the overlapped call thread itself for safety
	HARDASSERT(::GetCurrentThreadId() == m_dwThreadId);

	// Only really suspend if there is at least one suspend still pending (an intervening
	// resume may revoke the pending suspend)
	if (m_nSuspendCount > 0)
	{
		DWORD dwRet = ::SuspendThread(GetCurrentThread());
		dwRet;
#if TRACING == 1
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId()<< L": Suspending (count=" << m_nSuspendCount << "); " << *this << dwRet << std::endl;
	}
	else
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId()<< L": Suspend ignored (count=" << m_nSuspendCount << "); " << *this << std::endl;
#endif
	}
}

DWORD OverlappedCall::ResumeThread()
{
	return ::ResumeThread(m_hThread);
}

///////////////////////////////////////////////////////////////////////////////
// Thread main function

int OverlappedCall::MainExceptionFilter(LPEXCEPTION_POINTERS pExInfo)
{
	switch (pExInfo->ExceptionRecord->ExceptionCode)
	{
	case SE_VMTERMINATETHREAD:
		return EXCEPTION_EXECUTE_HANDLER;

	case EXCEPTION_FLT_STACK_CHECK:
	case EXCEPTION_INT_DIVIDE_BY_ZERO:
	case EXCEPTION_ACCESS_VIOLATION:
	case SE_VMCRTFAULT:
		return EXCEPTION_EXECUTE_HANDLER;
	}

	return EXCEPTION_CONTINUE_SEARCH;
}

static void __cdecl InvalidCrtParameterHandler(
	wchar_t const* expression,
	wchar_t const* function,
	wchar_t const* file,
	unsigned int line,
	uintptr_t pReservered
)
{
	TRACE(L"%x: CRT parameter fault in '%s' of %s, %s(%u)", GetCurrentThreadId(), expression, function, file, line);
	TODO("Raise an exception and report the error in a similar way to the main VM thread");
	return;
}

int OverlappedCall::TryMain()
{
	int ret;
	__try
	{
		_set_thread_local_invalid_parameter_handler(InvalidCrtParameterHandler);
		ret = Main();
	}
	__except(MainExceptionFilter(GetExceptionInformation()))
	{
		#if TRACING == 1
		{
			TRACELOCK();
			TRACESTREAM << std::hex << GetCurrentThreadId()<< L": Terminating; " << *this << std::endl;
		}
		#endif
		
		NotifyInterpreterOfTermination();
		ret = 0;
	}

	Term();	// Thread is terminating, so don't want handles (also lets Complete() know we have terminated)

	return ret;
}

// Static entry point required by _beginthreadex()
unsigned __stdcall OverlappedCall::ThreadMain(void* pvClosure)
{
	HARDASSERT(::GetCurrentThreadId() != Interpreter::MainThreadId());

	// Take over the initial reference (while thread is running, 
	// this keeps a reference on the OverlappedCall object which will then
	// be released when the smart pointer goes out of scope at the end of
	// this function, at which point the call will normally be deleted,
	// unless that is something else is holding a reference to it.)
	OverlappedCallPtr pThis(static_cast<OverlappedCall*>(pvClosure), false);

	// N.B. OC may not actually deleted as may still be ref'd from APC queue, etc
	return pThis->TryMain();
}

int OverlappedCall::Main()
{
	int ret;

	if (InterlockedCompareExchange(reinterpret_cast<SHAREDLONG*>(&m_state), Resting, Starting) == Starting)
		ret = ProcessRequests();
	else
	{
		// Terminated even before the try block could be entered. This will happen if the beStarted() call
		// found that the state had already transitioned away from the Starting state, probably to the
		// Terminated state.
		NotifyInterpreterOfTermination();
		ret = -1;
	}

	return ret;
}

// Queue an APC to let the main thread know that the overlapped thread has terminated
// this allows it to update its pending terminations list
bool OverlappedCall::NotifyInterpreterOfTermination()
{
	HARDASSERT(::GetCurrentThreadId() == m_dwThreadId);
	return QueueForInterpreter(TerminatedAPC);
}


// APC fired off to main thread when an overlapped thread has actually terminated as requested,
// i.e. the overlapped call thread is no longer running (or as good as dead)
void __stdcall OverlappedCall::TerminatedAPC(ULONG_PTR param)
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	// Message queued from overlapped thread to main thread
	OverlappedCallPtr pThis = BeginMainThreadAPC(param);

	#if TRACING == 1
	{
		CAutoLock<tracestream> lock(pThis->thinDump);
		pThis->thinDump << std::hex << GetCurrentThreadId()<< L": TerminatedAPC; " << *pThis << std::endl;
	}
	#endif

	// Remove associated Process from the interpreters list and reschedule it
	pThis->RemoveFromPendingTerminations();
}

// The receiver has terminated. Remove from the Processor's Pending Terminations
// list. Answer whether the process was actually on that list.
void OverlappedCall::RemoveFromPendingTerminations()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	ProcessOTE* oteProc = pendingTerms()->remove(m_oteProcess);
	if (oteProc == m_oteProcess)
	{
		Process* myProc = oteProc->m_location;
		HARDASSERT(myProc->Thread() == this);
		myProc->ClearThread();

		// Return it to the scheduling queues - we resume it to cause a scheduling decision to be made. 
		Interpreter::resume(oteProc);
		// Remove the reference that was from the pending terminations list
		oteProc->countDown();
	}
	else
	{
		HARDASSERT(oteProc->isNil());
	}

	NilOutPointer(m_oteProcess);

	// Remove the call from the active list as it is being destroyed
	Unlink();
}

// Let the interpreter know that this thread has completed the call, and is ready to finish
// up the external call (clear arguments off the stack of the calling process and push
// on the return value). We have to do this in synchronisation with the main thread since it 
// may involve memory management activities, etc, therefore we signal the Semaphore
// on which the process is waiting, and when the main thread processes this signal it
// will realise that a completion is waiting and send back an appropriate notification
// and then itself wait for the completion to take place on this thread.
void OverlappedCall::NotifyInterpreterOfCallReturn()
{
	// Must only be called from the overlapped thread
	HARDASSERT(::GetCurrentThreadId() == m_dwThreadId);

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": NotifyInterpreterOfCallReturn(), failure code = " << (SmallInteger)m_primitiveFailureCode << std::endl;
	}
	#endif

	InterlockedCompareExchange(reinterpret_cast<SHAREDLONG*>(&m_state), Returned, Calling);
	Process* myProc = GetProcess();
	Interpreter::asynchronousSignal(myProc->OverlapSemaphore());

	// We must set this event in case the main thread has quiesced
	Interpreter::SetWakeupEvent();
}

void OverlappedCall::WaitForInterpreter()
{
	// Must only be called from the overlapped thread
	HARDASSERT(::GetCurrentThreadId() == m_dwThreadId);

	// Wait for main thread to process the async signal and permit us to continue
	DWORD dwRet;
	while ((dwRet = ::WaitForSingleObjectEx(m_hEvtGo, 5000, TRUE)) != WAIT_OBJECT_0)
	{
		thinDump << std::hex << GetCurrentThreadId() << L": WaitForInterpreter, wait interrupted (" << dwRet << "); " << *this << std::endl;
		if (dwRet == WAIT_ABANDONED)
		{
			// Event deleted, etc, so terminate the thread
			::RaiseException(SE_VMTERMINATETHREAD, EXCEPTION_NONCONTINUABLE, 0, NULL);
		}

		// Interrupted to process an APC (probably a suspend/terminate) or due to a timeout
		HARDASSERT(dwRet == WAIT_IO_COMPLETION || dwRet == WAIT_TIMEOUT);
	}
}

///////////////////////////////////////////////////////////////////////////////
// The call on the worker thread has returned to the assembler call primitive.
// We can't complete the call until the main thread is ready to accept it, so 
// we must notify it that there is a call pending completion, and wait for it 
// to reactivate the blocked process associated with this overlapped call.
//
void OverlappedCall::OnCallReturned()
{
	// Must always be called from the worker thread
	HARDASSERT(::GetCurrentThreadId() == m_dwThreadId);

	NotifyInterpreterOfCallReturn();

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": OnCallReturned, waiting to complete; " << *this << std::endl;
	}
	#endif

	//if (inPrim) DebugBreak();

	WaitForInterpreter();

	if (GetProcess()->Thread() != this || m_state != Returned)
	{
		HARDASSERT(FALSE);
		::DebugCrashDump(L"Terminated overlapped call got though to completion (%#x)\nPlease contact Object Arts.", GetProcess()->Thread());
		RaiseException(SE_VMTERMINATETHREAD, EXCEPTION_NONCONTINUABLE, 0, NULL);
	}

	// We should now be running to the exclusion of the interpreter main thread, and no other
	// threads should be accessing any of the interpreter or object memory state

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": OnCallReturned, completing; " << *this << std::endl;
	}
	#endif

	// OK, now ready to pop args and push result on stack (in sync with main thread)
	InterpreterRegisters& activeContext = Interpreter::GetRegisters();
	// The process must be the active one in order to complete
	HARDASSERT(m_interpContext.m_pActiveProcess == activeContext.m_pActiveProcess);

	if (m_interpContext.m_stackPointer != activeContext.m_stackPointer)
	{
		DebugCrashDump(L"Overlapped call stack modified before could complete!");
		DEBUGBREAK();
	}

	// Our event will be signalled again when we return to the 
}

///////////////////////////////////////////////////////////////////////////////
// Interpreter primitive helpers

OverlappedCallPtr OverlappedCall::Do(CompiledMethod* pMethod, argcount_t argCount)
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());
	OverlappedCallPtr pCall = GetActiveProcessOverlappedCall();
	return pCall->Initiate(pMethod, argCount) ? pCall : nullptr;
}

///////////////////////////////////////////////////////////////////////////////
// Interpreter primitive helpers

void OverlappedCall::MarkRoots()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	OverlappedCallPtr next = s_activeList.First();
	while (next)
	{
		if (next->IsInCall())
		{
			ObjectMemory::MarkObjectsAccessibleFromRoot(reinterpret_cast<POTE>(next->m_oteProcess));
		}
		next = next->Next();
	}
}

#ifdef _DEBUG
void OverlappedCall::ReincrementProcessReferences()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());

	OverlappedCallPtr next = s_activeList.First();
	while (next)
	{
		next->m_oteProcess->countUp();
		next = next->Next();
	}
}
#endif
///////////////////////////////////////////////////////////////////////////////
// Interpreter methods related to overlapped calls
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Interpreter primitive 

Oop* __fastcall Interpreter::primitiveAsyncDLL32Call(Oop* const, primargcount_t argCount)
{
	CompiledMethod* method = m_registers.m_oopNewMethod->m_location;

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << L"primAsync32: Prepare to call " << *method << L" from " << Interpreter::actualActiveProcessPointer() << std::endl;
	}
	#endif

	OverlappedCallPtr pCall = OverlappedCall::Do(method, argCount);
	if (!pCall)
		// Nested overlapped calls are not supported
		return primitiveFailure(_PrimitiveFailureCode::NotSupported);

	HARDASSERT(newProcessWaiting());

	// The overlapped call may already have returned, in which case a process switch
	// will not occur, so we must notify the overlapped call that it can complete as 
	// it will not receive a notification from either finishing the handling of an interrupt
	// or by switching back to the process
	if (!CheckProcessSwitch())
	{
		pCall->OnActivateProcess();
	}

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << L"registers.sp = " << m_registers.m_stackPointer<< L" frame.sp = " <<
				m_registers.m_pActiveFrame->stackPointer() << std::endl;
	}
	#endif

	return m_registers.m_stackPointer;
}
