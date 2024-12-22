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
#include "STByteArray.h"

#include "thrdcall.h"

// Disable warning about use of SEH in conjunction with objects with destructors
#pragma warning (disable : 4509)

///////////////////////////////////////////////////////////////////////////////
// Static data members
///////////////////////////////////////////////////////////////////////////////

// Note that this static must only be accessed from the main interpreter thread
// Its purpose is to maintain a list of all overlapped calls objects for admin
// of same.
OverlappedCallList OverlappedCall::s_activeList;

thread_local OverlappedCall* OverlappedCall::m_pThis;

// Time permitted for threads to complete before main thread gives up
static DWORD s_dwTerminateTimeout;
static bool bIsNT;

inline void Process::NewOverlapSemaphore()
{
	ObjectMemory::storePointerWithValue(*reinterpret_cast<Oop*>(&m_waitOverlap), reinterpret_cast<OTE*>(Semaphore::New()));
}

inline void Process::SetThread(void* handle)
{
	ObjectMemory::storePointerWithUnrefCntdValue(m_thread, Oop(handle) + 1);
}

inline void OverlappedCall::AssertCalledFromInterpreterThread()
{
	HARDASSERT(::GetCurrentThreadId() == Interpreter::MainThreadId());
}

inline void OverlappedCall::AssertCalledFromOverlappedThread()
{
	HARDASSERT(::GetCurrentThreadId() == m_dwThreadId);
}

///////////////////////////////////////////////////////////////////////////////
// List management
///////////////////////////////////////////////////////////////////////////////

OverlappedCallPtr OverlappedCall::GetActiveProcessOverlappedCall()
{
	AssertCalledFromInterpreterThread();

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
		if (pOverlapped)
		{
			pActiveProcess->SetThread(pOverlapped);
			pActiveProcess->NewOverlapSemaphore();
		}
	}

	return pOverlapped;
}

// Allocate an OverlappedCall from the pool, or create a new one if none available
OverlappedCallPtr OverlappedCall::New(ProcessOTE* oteProcess)
{
	AssertCalledFromInterpreterThread();

	OverlappedCallPtr answer = new OverlappedCall(oteProcess);
	// The list doesn't use smart ptrs, instead we just add a ref here, and remove one when we unlink
	answer->AddRef();
	s_activeList.AddFirst(answer);
	return answer;
}

///////////////////////////////////////////////////////////////////////////////
// Init and cleanup
///////////////////////////////////////////////////////////////////////////////

// Static initialization of async call support
void OverlappedCall::Initialize()
{
	AssertCalledFromInterpreterThread();

	RegKey rkOverlap;
	if (rkOverlap.OpenDolphinKey(L"Overlapped") == ERROR_SUCCESS && 
		rkOverlap.QueryDWORDValue(L"TerminateTimeout", s_dwTerminateTimeout) == ERROR_SUCCESS)
	{
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
	AssertCalledFromInterpreterThread();

	QueueTerminate();
	DWORD dwWaitRet = ::WaitForSingleObject(m_hThread, s_dwTerminateTimeout); dwWaitRet;
	
	#if TRACING == 1
	{
		tracelock lock(::thinDump);
		::thinDump << GetCurrentThreadId()<< L": " << *this<< L" terminated (" << dwWaitRet<< L")" << std::endl;
	}
	#endif
}

// Static clean up async call support on shutdown
void OverlappedCall::Uninitialize()
{
	AssertCalledFromInterpreterThread();

	// Terminate all overlapped call threads
	OverlappedCallPtr next(s_activeList.RemoveFirst(), false);
	while (next)
	{
		next->TerminateThread();
		next = OverlappedCallPtr(s_activeList.RemoveFirst(), false);
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
	AssertCalledFromInterpreterThread();

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
	OverlappedCall::AssertCalledFromInterpreterThread();
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
	stream << L"OverlappedCall(" << &oc
		<< L", id:" << oc.m_dwThreadId
		<< L", state: " << static_cast<std::underlying_type<OverlappedCall::States>::type>(oc.m_state);
	if (oc.IsInCall()) 
	{
		stream << L", process: " << oc.m_oteProcess;
	}
	return stream
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
			m_state(States::Starting),
			m_primitiveFailureCode(_PrimitiveFailureCode::NoError),
			m_pExInfo(nullptr),
			m_pFpIeeeRecord(nullptr)
{
	AssertCalledFromInterpreterThread();

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
	AssertCalledFromInterpreterThread();

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": Destroy " << *this << std::endl;
	}
	#endif

	if (m_pExInfo != nullptr)
	{
		delete m_pExInfo;
	}
	if (m_pFpIeeeRecord != nullptr)
	{
		_aligned_free_dbg(m_pFpIeeeRecord);
	}
	m_pThis = nullptr;
}


///////////////////////////////////////////////////////////////////////////////
// Initialization helpers


// Start off the thread, answering whether it worked or not
bool OverlappedCall::BeginThread()
{
	AssertCalledFromInterpreterThread();

	HARDASSERT(m_hThread == 0);
	m_hThread = (HANDLE)_beginthreadex(
							/*security=*/		NULL, 
							/*stack_size=*/		0,
							/*start_address*/	ThreadMain,
							/*arglist=*/		this,
							/*initflag=*/		0,
							/*thrdaddr=*/		reinterpret_cast<unsigned int*>(&m_dwThreadId));
	return m_hThread != 0;
}

void OverlappedCall::Init()
{
	AssertCalledFromInterpreterThread();

	m_hEvtGo = NewAutoResetEvent();
	m_hEvtCompleted = NewAutoResetEvent();
	if (!BeginThread())
		::RaiseException(STATUS_NO_MEMORY, 0, 0, NULL);
}

void OverlappedCall::Term()
{
	AssertCalledFromOverlappedThread();

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

// Forced state change. Returns previous state.
OverlappedCall::States OverlappedCall::ExchangeState(States exchange)
{
	return static_cast<States>(InterlockedExchange(reinterpret_cast<SHAREDLONG*>(&m_state), static_cast<std::underlying_type<States>::type>(exchange)));
}

// Conditional state change. Returns previous state.
OverlappedCall::States OverlappedCall::ExchangeState(States exchange, States comperand)
{
	return static_cast<States>(InterlockedCompareExchange(reinterpret_cast<SHAREDLONG*>(&m_state),
		static_cast<std::underlying_type<States>::type>(exchange),
		static_cast<std::underlying_type<States>::type>(comperand)));
}

OverlappedCall::States OverlappedCall::beUnwinding()
{
	return ExchangeState(States::Unwinding);
}

// Return interrupted overlapped call to Ready state. This should only be done if the OC was in the Ready state when interrupted
OverlappedCall::States OverlappedCall::beUnwound()
{
	return ExchangeState(States::Ready, States::Unwinding);
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
	AssertCalledFromOverlappedThread();

	DWORD dwRet;
	// Wait until either there is work to do - a terminate exception could be delivered in an APC, 
	// so the wait is interruptable.
	while ((dwRet = WaitForRequest()) == WAIT_OBJECT_0
		&& ExchangeState(States::Calling, States::Pending) == States::Pending)
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

int OverlappedCall::CallExceptionFilter(LPEXCEPTION_POINTERS pExInfo)
{
	// Save away details of the exception. It will be "re-raised" (actually converted to an interrupt) on the main Interpreter thread

	DWORD exceptionCode = pExInfo->ExceptionRecord->ExceptionCode;
	switch (exceptionCode)
	{
	case STATUS_FLOAT_DENORMAL_OPERAND:
	case STATUS_FLOAT_DIVIDE_BY_ZERO:
	case STATUS_FLOAT_INEXACT_RESULT:
	case STATUS_FLOAT_INVALID_OPERATION:
	case STATUS_FLOAT_OVERFLOW:
	case STATUS_FLOAT_STACK_CHECK:
	case STATUS_FLOAT_UNDERFLOW:
	case STATUS_FLOAT_MULTIPLE_FAULTS:
	case STATUS_FLOAT_MULTIPLE_TRAPS:
		m_primitiveFailureCode = static_cast<_PrimitiveFailureCode>(PFC_FROM_NT(exceptionCode));
		_fpieee_flt(exceptionCode, pExInfo, IEEEFPHandler);
		m_oteProcess->m_location->ResetFP();
		return EXCEPTION_EXECUTE_HANDLER;

	case STATUS_INTEGER_DIVIDE_BY_ZERO:
	case STATUS_INTEGER_OVERFLOW:
	case STATUS_PRIVILEGED_INSTRUCTION:
	case STATUS_ILLEGAL_INSTRUCTION:
		CopyExceptionInfo(pExInfo);
		m_primitiveFailureCode = static_cast<_PrimitiveFailureCode>(PFC_FROM_NT(exceptionCode));
		return EXCEPTION_EXECUTE_HANDLER;

	case STATUS_STACK_OVERFLOW:
		CopyExceptionInfo(pExInfo);
		m_primitiveFailureCode = _PrimitiveFailureCode::StackOverflow;
		return EXCEPTION_EXECUTE_HANDLER;

	case STATUS_ACCESS_VIOLATION:
		CopyExceptionInfo(pExInfo);
		m_primitiveFailureCode = _PrimitiveFailureCode::AccessViolation;
		return EXCEPTION_EXECUTE_HANDLER;

	case static_cast<DWORD>(VMExceptions::CrtFault):
		CopyExceptionInfo(pExInfo);
		m_primitiveFailureCode = _PrimitiveFailureCode::CrtFault;
		return EXCEPTION_EXECUTE_HANDLER;
	}

	return EXCEPTION_CONTINUE_SEARCH;
}

void OverlappedCall::CopyExceptionInfo(const LPEXCEPTION_POINTERS& pExInfo)
{
	if (m_pExInfo == nullptr)
	{
		m_pExInfo = new ExceptionInfo();
	}
	m_pExInfo->Copy(pExInfo);
}

void ExceptionInfo::Copy(const LPEXCEPTION_POINTERS& pExInfo)
{
	memcpy(&m_exceptionRecord, pExInfo->ExceptionRecord, sizeof(m_exceptionRecord));
	memcpy(&m_contextRecord, pExInfo->ContextRecord, sizeof(m_contextRecord));
}

void OverlappedCall::PerformCall()
{
	// Must only be called from the overlapped thread
	AssertCalledFromOverlappedThread();

	// Run a call - this will finish by calling SignalCompletion, which will return to it
	// and it (after placing the return value on the stack) then returns here.
	__try
	{
		Oop* sp = asyncDLL32Call(m_pMethod, m_nArgCount, this, &m_interpContext);
		if (!ObjectMemoryIsIntegerObject(reinterpret_cast<Oop>(sp)))
		{
			// Successful call

#if TRACING == 1
			{
				TRACELOCK();
				TRACESTREAM << std::hex << GetCurrentThreadId() << L": Completed " << *m_pMethod << "; " << *this << std::endl;
			}
#endif

			InterpreterRegisters& regs = Interpreter::GetRegisters();
			regs.m_stackPointer = sp;
			regs.m_pActiveFrame->setStackPointer(sp);
		}
		else
		{
			// The call failed as if it were a primitive failure - the args have
			// not been popped and we need to activate the backup smalltalk code. 
			// However, since the calling Process is in a wait state, we need to 
			// notify the main thread to wake it up
			m_primitiveFailureCode = static_cast<_PrimitiveFailureCode>(reinterpret_cast<Oop>(sp));

			// We have to simulate return of the call even though we never made it in order that the main thread transitions through the states to take back control
			ReturnFromFailedCall();
		}
	}
	__except (CallExceptionFilter(GetExceptionInformation()))
	{
		// The call was made, but a UHE occurred in it.
		ReturnFromFailedCall();
	}

	HARDASSERT(m_oteProcess->m_location->Thread() == this);

	// Transition from Completing back to Ready
	ExchangeState(States::Ready, States::Completing);

	// We don't use any of the old context after here, so even if this thread is immediately
	// reused before it gets a chance quiesce, it wont matter
	VERIFY(::SetEvent(m_hEvtCompleted));
}

void OverlappedCall::ReturnFromFailedCall()
{
#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": Call failed: " << static_cast<uint32_t>(m_primitiveFailureCode) << L": " << *this << std::endl;
	}
#endif

	if (ExchangeState(States::Returned, States::Calling) == States::Calling)
	{
		// Failed before the call was attempted, e.g. due to invalid arguments, so we must notify the Interpreter
		// accordingly to wake the calling thread
		NotifyInterpreterOfCallReturn();
		WaitForInterpreter();
	}
}

_PrimitiveFailureCode OverlappedCall::Initiate(CompiledMethod* pMethod, argcount_t argCount)
{
	AssertCalledFromInterpreterThread();

#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": Initiate; " << *this << std::endl;
	}
#endif

	// Spin until the call thread is Ready
	States state;
	do { state = ExchangeState(States::Pending, States::Ready); } while (state == States::Starting);

	// If the thread did not transition from Ready to Pending, e.g. because a nested overlapped call 
	// has been made, we can't continue
	switch (state)
	{
	case States::Starting:
	case States::Pending:
		// Cannot happen - the loop should not have exited without transitioning Starting->Ready->Pending
		return _PrimitiveFailureCode::AssertionFailure;

	case States::Ready:
		// The call thread was ready, and must how have successfully transitioned from to Pending, so we can proceed
		break;

	case States::Calling:
	case States::Completing:
	case States::Returned:
		// Currently in a call; nested calls are not supported
		return _PrimitiveFailureCode::NotSupported;

	case States::Terminated:
	case States::Unwinding:
		return _PrimitiveFailureCode::IllegalStateChange;

	default:
		// Invalid state
		return _PrimitiveFailureCode::InternalError;
	}

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
	::SetEvent(m_hEvtGo);

	TODO("Try a deliberate SwitchToThread here to see effect of call completing before we reschedule")

	// Reschedule as we probably need another process to run
	if (Interpreter::schedule() == m_oteProcess)
		DebugBreak();

	//CHECKREFERENCES
	return _PrimitiveFailureCode::NoError;
}

///////////////////////////////////////////////////////////////////////////////
// Thread management to be used from main interpreter thread

bool OverlappedCall::CanComplete()
{
	// Only Process safe if called from main thread
	AssertCalledFromInterpreterThread();

	InterpreterRegisters& activeContext = Interpreter::GetRegisters();
	HARDASSERT(m_interpContext.m_pActiveProcess == activeContext.m_pActiveProcess);

	// If the process has been interrupted, there may be some additional stack frames on top, so we can't complete until the interrupt has returned
	if (m_interpContext.m_pActiveFrame != activeContext.m_pActiveFrame)
		return false;

	if (ExchangeState(States::Completing, States::Returned) != States::Returned)
		return false;

	HARDASSERT(m_interpContext.m_stackPointer == activeContext.m_stackPointer);
	return true;
}

void OverlappedCall::OnActivateProcess()
{
	AssertCalledFromInterpreterThread();

	if (CanComplete())
	{
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

			CallFailed();

			m_primitiveFailureCode = _PrimitiveFailureCode::NoError;
		}

		m_interpContext.m_oopNewMethod = reinterpret_cast<MethodOTE*>(Pointers.Nil);
	}
	else
	{
		#if TRACING == 1
		if (m_state != States::Ready)
		{
			TRACELOCK();
			TRACESTREAM << std::hex << GetCurrentThreadId() << L": OnActivateProcess() state = " << static_cast<std::underlying_type<States>::type>(this->m_state) << std::endl;
		}
		#endif
	}
}

void OverlappedCall::SendExceptionInterrupt(Interpreter::VMInterrupts oopInterrupt)
{
	Interpreter::sendVMInterrupt(oopInterrupt, reinterpret_cast<Oop>(ByteArray::NewWithRef(sizeof(EXCEPTION_RECORD), m_pExInfo->ExceptionRecord)));
}

void OverlappedCall::CallFailed()
{
	AssertCalledFromInterpreterThread();
	assert(Interpreter::m_registers.m_oteActiveProcess == m_oteProcess);

	ASSERT(m_interpContext.m_stackPointer == Interpreter::m_registers.m_stackPointer);
	ASSERT(m_interpContext.m_basePointer == Interpreter::m_registers.m_basePointer);
	Interpreter::m_registers.m_oopNewMethod = m_interpContext.m_oopNewMethod;
	Interpreter::activatePrimitiveMethod(m_interpContext.m_oopNewMethod->m_location, m_primitiveFailureCode);

	switch (m_primitiveFailureCode)
	{
	case _PrimitiveFailureCode::AccessViolation:
		SendExceptionInterrupt(Interpreter::VMInterrupts::AccessViolation);
		break;
	case _PrimitiveFailureCode::CrtFault:
		SendExceptionInterrupt(Interpreter::VMInterrupts::CrtFault);
		break;
	case _PrimitiveFailureCode::FloatStackCheck:
		SendExceptionInterrupt(Interpreter::VMInterrupts::FpStack);
		break;

	case _PrimitiveFailureCode::FloatDenormalOperand:
	case _PrimitiveFailureCode::FloatDivideByZero:
	case _PrimitiveFailureCode::FloatInexactReult:
	case _PrimitiveFailureCode::FloatInvalidOperation:
	case _PrimitiveFailureCode::FloatOverflow:
	case _PrimitiveFailureCode::FloatUnderflow:
	case _PrimitiveFailureCode::FloatMultipleFaults:
	case _PrimitiveFailureCode::FloatMultipleTraps:
		Interpreter::sendVMInterrupt(Interpreter::VMInterrupts::FpFault, reinterpret_cast<Oop>(ByteArray::NewWithRef(sizeof(_FPIEEE_RECORD), m_pFpIeeeRecord)));
		break;
	
	case _PrimitiveFailureCode::IntegerOverflow:
	case _PrimitiveFailureCode::PrivilegedInstruction:
	case _PrimitiveFailureCode::IllegalInstruction:
		SendExceptionInterrupt(Interpreter::VMInterrupts::Exception);
		break;
	case _PrimitiveFailureCode::IntegerDivideByZero:
		Interpreter::sendZeroDivideInterrupt(m_pExInfo);
		break;
	case _PrimitiveFailureCode::NoMemory:
		Interpreter::OutOfMemory(m_pExInfo);
		break;

	case _PrimitiveFailureCode::StackOverflow:
		// We don't translate this to the StackOverflow interrupt, as this is a native stack overflow, not Smalltalk stack
		SendExceptionInterrupt(Interpreter::VMInterrupts::Exception);
		break;

	default:
		// Handle as normal primitive failure
		break;
	}
}

int __cdecl OverlappedCall::IEEEFPHandler(_FPIEEE_RECORD* pIEEEFPException)
{
	OverlappedCall* pThis = m_pThis;
	if (pThis->m_pFpIeeeRecord == nullptr)
	{
		pThis->m_pFpIeeeRecord = (_FPIEEE_RECORD*)_aligned_malloc_dbg(sizeof(_FPIEEE_RECORD), 16, __FILE__, __LINE__);
	}
	memcpy(pThis->m_pFpIeeeRecord, pIEEEFPException, sizeof(_FPIEEE_RECORD));
	return EXCEPTION_EXECUTE_HANDLER;
}

// Fire off an exception from the main thread into the overlapped thread to cause it
// to terminate the next time it enters an alertable wait state. This may not happen
// immediately.
bool OverlappedCall::QueueTerminate()
{
	AssertCalledFromInterpreterThread();
	
	// Although there is a race condition here, in that the thread may terminate after this
	// test, we don't care because the thread handle will be nulled, and the operations against
	// a NULL thread handle are benign.
	States previousState = ExchangeState(States::Terminated);
	if (previousState == States::Terminated || m_hThread == nullptr)
		// Already terminated/terminating
		return false;

	// If the thread has entered its base try/catch block then we must use an exception
	// to terminate it. If it hasn't then when it does it will not be able to transition to
	// the running state, and will recognise that as a termination request and drop out.
	if (previousState != States::Starting)
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
		RaiseThreadException(m_hThread, static_cast<DWORD>(VMExceptions::TerminateThread), EXCEPTION_NONCONTINUABLE, 1, adwArgs);
	}

	// Ensure running and therefore able to receive termination request
	while (long(::ResumeThread(m_hThread)) > 0)
		continue;

	return true;
}

///////////////////////////////////////////////////////////////////////////////
// Thread main function

int OverlappedCall::MainExceptionFilter(DWORD exceptionCode)
{
	switch (static_cast<VMExceptions>(exceptionCode))
	{
	case VMExceptions::CrtFault:
		// CRT faults occurring in the function called on the thread should have been trapped by the call filter
		return EXCEPTION_CONTINUE_EXECUTION;

	case VMExceptions::TerminateThread:
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
	ULONG_PTR args[1];
	args[0] = errno;
	::RaiseException(static_cast<DWORD>(VMExceptions::CrtFault), 0, 1, (CONST ULONG_PTR*)args);
}

int OverlappedCall::TryMain()
{
	m_pThis = this;
	int ret;
	__try
	{
		_set_thread_local_invalid_parameter_handler(InvalidCrtParameterHandler);
		// Pick up the FP control word settings from the owning process
		m_oteProcess->m_location->ResetFP();
		ret = Main();
	}
	__except(MainExceptionFilter(GetExceptionCode()))
	{
		#if TRACING == 1
		{
			TRACELOCK();
			TRACESTREAM << std::hex << GetCurrentThreadId()<< L": Terminating; " << *this << std::endl;
		}
		#endif
		
		ret = 0;
	}

	NotifyInterpreterOfTermination();

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

	// The main thread should spin waiting for us to become Ready, then it will normally change the state to Pending 
	// and allow the call request to proceed.
	if (ExchangeState(States::Ready, States::Starting) == States::Starting)
		ret = ProcessRequests();
	else
	{
		// Terminated even before ready for first request
		ret = -1;
	}

	return ret;
}

// Queue an APC to let the main thread know that the overlapped thread has terminated
// this allows it to update its pending terminations list
bool OverlappedCall::NotifyInterpreterOfTermination()
{
	AssertCalledFromOverlappedThread();
	return QueueForInterpreter(TerminatedAPC);
}


// APC fired off to main thread when an overlapped thread has actually terminated as requested,
// i.e. the overlapped call thread is no longer running (or as good as dead)
void __stdcall OverlappedCall::TerminatedAPC(ULONG_PTR param)
{
	AssertCalledFromInterpreterThread();

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
	AssertCalledFromInterpreterThread();

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
		HARDASSERT(isNil(oteProc));
	}

	NilOutPointer(m_oteProcess);

	// Remove the call from the active list as it is being destroyed
	Unlink();
	// Remove the reference added for the list
	Release();
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
	AssertCalledFromOverlappedThread();

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": NotifyInterpreterOfCallReturn(), failure code = " << (SmallInteger)m_primitiveFailureCode << std::endl;
	}
	#endif

	ExchangeState(States::Returned, States::Calling);
	Process* myProc = GetProcess();
	Interpreter::asynchronousSignal(myProc->OverlapSemaphore());

	// We must set this event in case the main thread has quiesced
	Interpreter::SetWakeupEvent();
}

void OverlappedCall::WaitForInterpreter()
{
	// Must only be called from the overlapped thread
	AssertCalledFromOverlappedThread();

	// Wait for main thread to process the async signal and permit us to continue
	DWORD dwRet;
	while ((dwRet = ::WaitForSingleObjectEx(m_hEvtGo, 5000, TRUE)) != WAIT_OBJECT_0)
	{
		thinDump << std::hex << GetCurrentThreadId() << L": WaitForInterpreter, wait interrupted (" << dwRet << "); " << *this << std::endl;
		if (dwRet == WAIT_ABANDONED)
		{
			// Event deleted, etc, so terminate the thread
			::RaiseException(static_cast<DWORD>(VMExceptions::TerminateThread), EXCEPTION_NONCONTINUABLE, 0, NULL);
		}

		// Interrupted to process an APC (probably a termination request) or due to a timeout
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
	AssertCalledFromOverlappedThread();

	NotifyInterpreterOfCallReturn();

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << std::hex << GetCurrentThreadId() << L": OnCallReturned, waiting to complete; " << *this << std::endl;
	}
	#endif

	//if (inPrim) DebugBreak();

	WaitForInterpreter();

	if (GetProcess()->Thread() != this || m_state != States::Completing)
	{
		HARDASSERT(FALSE);
		::DebugCrashDump(L"Terminated overlapped call got though to completion (%#x)\nPlease contact Object Arts.", GetProcess()->Thread());
		RaiseException(static_cast<DWORD>(VMExceptions::TerminateThread), EXCEPTION_NONCONTINUABLE, 0, NULL);
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
	const InterpreterRegisters& activeContext = Interpreter::GetRegisters();
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

void OverlappedCall::MarkRoots()
{
	AssertCalledFromInterpreterThread();

	OverlappedCall* next = s_activeList.First();
	while (next)
	{
		ObjectMemory::MarkObjectsAccessibleFromRoot(reinterpret_cast<POTE>(next->m_oteProcess));
		next = next->Next();
	}
}

#ifdef _DEBUG
void OverlappedCall::ReincrementProcessReferences()
{
	AssertCalledFromInterpreterThread();

	OverlappedCall* next = s_activeList.First();
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

Oop* PRIMCALL Interpreter::primitiveUnwindInterrupt(Oop* const, primargcount_t)
{
	// Terminate any overlapped call outstanding for the process, this may need to suspend the process
	// and so this may cause a context switch
	ProcessOTE* oteActive = actualActiveProcessPointer();
	OverlappedCallPtr pOverlapped = oteActive->m_location->GetOverlappedCall();
	if (pOverlapped)
	{
		OverlappedCall::States state = pOverlapped->beUnwinding();
		if (state == OverlappedCall::States::Ready)
		{
			// Thread was just waiting calls - return it to idle
			pOverlapped->beUnwound();
		}
		else
		{
			TerminateOverlapped(oteActive);
		}
}
	return primitiveSuccess(0);
}

Oop* PRIMCALL Interpreter::primitiveAsyncDLL32Call(Oop* const, primargcount_t argCount)
{
	CompiledMethod* method = m_registers.m_oopNewMethod->m_location;

	#if TRACING == 1
	{
		TRACELOCK();
		TRACESTREAM << L"primAsync32: Prepare to call " << *method << L" from " << Interpreter::actualActiveProcessPointer() << std::endl;
	}
	#endif

	OverlappedCallPtr pCall = OverlappedCall::GetActiveProcessOverlappedCall();
	if (pCall)
	{
		_PrimitiveFailureCode retCode = pCall->Initiate(method, argCount);
		if (retCode == _PrimitiveFailureCode::NoError)
		{

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
				TRACESTREAM << L"registers.sp = " << m_registers.m_stackPointer << L" frame.sp = " <<
					m_registers.m_pActiveFrame->stackPointer() << std::endl;
			}
#endif

			return m_registers.m_stackPointer;
		}

		return primitiveFailure(retCode);
	}
	else
		return primitiveFailure(_PrimitiveFailureCode::NoMemory);
}
