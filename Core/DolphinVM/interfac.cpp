/*
============
Interfac.cpp
============
Interpreter interface functions
*/
							
#include "Ist.h"

#ifndef _DEBUG
	//#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "Interprt.h"
#include "ObjMem.h"
#include "rc_vm.h"
#include "InterprtPrim.inl"
#include "InterprtProc.inl"
#include "VMExcept.h"
#include "thrdcall.h"
#include "STArray.h"

const wchar_t* SZREGKEYBASE = L"Software\\Object Arts\\Dolphin Smalltalk 7.1";

// Smalltalk classes
#include "STByteArray.h"
#include "STString.h"		// For instantiating new strings
#include "STInteger.h"		// NewDWORD uses to create new integer, also for winproc return
#include "STExternal.h"		// Primary purpos of this module is external i/f'ing

#define USESETJMP
static Oop currentCallbackContext = ZeroPointer;

///////////////////////////////////////////////////////////////////////////////
// Virtual function call-in tables

#define NUMVTBLENTRIES	1024

typedef int (__stdcall *FP)();

#pragma pack(push, 1)
struct VTblThunk
{
	//		mov		ecx, id
	//BYTE	int3;
	BYTE	movEcx;
	DWORD	id;
	// jmp		commonVfnEntryPoint
	BYTE	jmp;
	SDWORD	commonVfnEntryPoint;
};

static VTblThunk* aVtblThunks;
// This is deliberately uninitialized so as not to reserve any space in the executable
VTblThunk* VTable[NUMVTBLENTRIES];

#pragma pack(pop)

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Callback entry point. Executes until a callback exit primitive is executed from Smalltalk

inline void __fastcall Interpreter::returnValueTo(Oop resultPointer, Oop contextPointer)
{
	if (m_registers.m_pActiveFrame->m_caller == contextPointer)
		returnValueToCaller(resultPointer, contextPointer);
	else
		nonLocalReturnValueTo(resultPointer, contextPointer);
}

// Private - common part of perform callback routines
Oop __stdcall Interpreter::callback(SymbolOTE* selector, unsigned argCount TRACEPARM) /* throws SE_VMCALLBACKUNWIND */
{
	//CHECKREFERENCES

 	HARDASSERT(ObjectMemoryIntegerValueOf(m_registers.m_pActiveFrame->m_ip) < 4096);

	// We use this to see if Smalltalk is attempting to exit from callbacks out of sync (because of Process
	// switches in the Smalltalk - e.g. Process1 receives a callback
	Process* callbackProcess = actualActiveProcess();

	// Increase the callback depth
	callbackProcess->IncrementCallbackDepth();

	Oop returnFrame = /*(Oop volatile)*/m_registers.activeFrameOop();
	MethodOTE* savedNewMethod = /*(OTE* volatile)*/m_registers.m_oopNewMethod;

	#ifdef _DEBUG
		InterpreterRegisters savedContext = m_registers;
		savedContext.m_stackPointer = m_registers.m_stackPointer-argCount;

		int lastTrace=executionTrace;
		if (traceFlag==TraceOff && unsigned(executionTrace) < 2)
			executionTrace=0;
	#endif

	Oop retVal;

#ifdef USESETJMP
	jmp_buf callbackContext;
	Oop prevCallbackContext = currentCallbackContext;

#pragma warning(push)
#pragma warning(disable:4611)	// interaction between '_setjmp' and C++ object destruction is non-portable
	int nExitCode = setjmp(callbackContext);
#pragma warning(pop)
	
	switch(nExitCode)
	{
	case 0:
		currentCallbackContext = Oop(&callbackContext)+1;
#else
		const Oop prevCallbackContext = ZeroPointer;

#endif

		push(currentCallbackContext);

		// Using Win32 structured exception handling here NOT C++, for performance reasons, and
		// because we need a resumption capability
		__try
		{
			// N.B. This could cause a process switch if an async. signal is waiting for a higher priority
			// process, therefore the activeFrame() and process may not be those which are going to process
			// our callback.
			sendSelectorArgumentCount(selector, argCount+1);

			#ifdef _DEBUG
				Oop callbackFrameOop;
				Process* pActive = m_registers.m_pActiveProcess;
				if (callbackProcess == pActive)
					callbackFrameOop = m_registers.activeFrameOop();
				else
				{
					#ifdef OAD
						TRACESTREAM<< L"WARNING: Context switch occurred during callback message send" << std::endl;
					#endif
					callbackFrameOop = callbackProcess->SuspendedFrame();
				}

				//executionTrace=1;
				StackFrame* pCallbackFrame = StackFrame::FromFrameOop(callbackFrameOop);
				if (executionTrace)
				{
					TRACESTREAM.Lock();
					TRACESTREAM<< L"C entrypoint at context " << returnFrame<< L"/" << StackFrame::FromFrameOop(returnFrame)<< L", frame " << callbackFrameOop<< L"/" << pCallbackFrame << std::endl;
					TRACESTREAM.Unlock();
				}

				ASSERT(!pCallbackFrame->isBlockFrame());
				ASSERT(pCallbackFrame->m_caller == returnFrame);
			#endif

			// Invoke asembler byte code loop in a handler which can detect and
			// handle GP and FP faults in primitives.
			interpret();
		}
		__except (callbackTerminationFilter(GetExceptionInformation(), callbackProcess, prevCallbackContext))
		{
			// All stuff we used to do in here now done after switch statement
		}

#ifdef USESETJMP
		break;

	case SE_VMCALLBACKEXIT:
		// Pop the top of the callback context stack
		currentCallbackContext = prevCallbackContext;
		wakePendingCallbacks();
		break;

	case SE_VMCALLBACKUNWIND:
	default:
		return Oop(Pointers.Nil);
	}
#endif

	// We received a callback exit exception - i.e. the SUCCESSFULL completion of a callback
	retVal = popStack();

	ASSERT(ObjectMemoryIsIntegerObject(retVal) || !(reinterpret_cast<OTE*>(retVal)->isFree()));

	// This will restore all interpreter registers except m_oopNewMethod;
	returnValueTo(retVal, returnFrame);

	m_registers.m_oopNewMethod = savedNewMethod;

	#ifdef _DEBUG
		if (traceFlag==TraceOff && executionTrace < 2)
			executionTrace=lastTrace;
		ASSERT(actualActiveProcess() == callbackProcess);
		ASSERT(returnFrame == m_registers.activeFrameOop());
		ASSERT(ObjectMemoryIntegerValueOf(m_registers.m_pActiveFrame->m_ip) < 1024);
		ASSERT(ObjectMemoryIsIntegerObject(retVal) || !(reinterpret_cast<OTE*>(retVal)->isFree()));

		//ASSERT(!memcmp(&savedContext, &m_registers, sizeof(InterpreterRegisters)));
	#endif

	// Must countUp to prevent it being GC'd since it is no longer ref'd from the stack
	VERIFY(retVal == popAndCountUp());
	return retVal;
}

// Exception filter to look for callback unwinds and exits. The former execute the handler
// thus terminating the callback (if the callback exit request is in sequence), the latter
// unwind the callback, but continue out from the callback method to an outer handler
// (which will be the enclosing callback handlers, and eventually the main interpreter handler
// or a wnd proc handler).
int Interpreter::callbackTerminationFilter(LPEXCEPTION_POINTERS info, Process* callbackProcess, Oop prevCallbackContext)
{
	EXCEPTION_RECORD* pExRec = info->ExceptionRecord;

	switch (pExRec->ExceptionCode)
	{
		case SE_VMCALLBACKEXIT:
		{
			// Its a callback exception, now lets see if its in sync.
			if (callbackProcess == actualActiveProcess())
			{
				// Allow any pending callback exits to retry - we only signal the semaphore if necessary to avoid
				// building up a huge number of excess signals, and to avoid the overhead.
				wakePendingCallbacks();
				return EXCEPTION_EXECUTE_HANDLER;	// In sync., exit this callback returning value atop the stack
			}
			else
			{
				// Note: The primitive which raised the callback termination exception will
				// increment the count of pending (failed) callback exits so that on the next
				// successful callback, the appropriate number of signals will be sent to the pending
				// callbacks semaphore.
				return EXCEPTION_CONTINUE_EXECUTION;	// Out of sync. continue and fail primitiveCallbackReturn
			}
			break;
		}
		case SE_VMCALLBACKUNWIND:			// N.B. Similar, but subtly different (we continue the search)
		{
			// Its a callback unwind, now lets see if its in sync.
			if (callbackProcess == actualActiveProcess())
			{
				// Pop the top of the callback context stack
				currentCallbackContext = prevCallbackContext;

				// Allow any pending callback exits to retry
				wakePendingCallbacks();
				ASSERT(reinterpret_cast<SchedulerOTE*>(*m_registers.m_stackPointer) == schedulerPointer());
				return EXCEPTION_CONTINUE_SEARCH;
			}
			else
			{
				// This unwind must wait its turn as there are other pending callback exits
				// above it.

				// Note: The primitive which raised the callback termination exception will
				// increment the count of pending (failed) callback exits so that on the next
				// successful callback, the appropriate number of signals will be sent to the pending
				// callbacks semaphore.
				return EXCEPTION_CONTINUE_EXECUTION;	// Out of sync. continue and fail primitiveCallbackReturn
			}
			break;
		}
	}

	return EXCEPTION_CONTINUE_SEARCH;		// Not a callback exit (successful unwind or other)
}

inline SemaphoreOTE* Interpreter::pendingCallbacksPointer()
{
	return scheduler()->m_pendingReturns;
}

inline Semaphore* Interpreter::pendingCallbacks()
{
	return pendingCallbacksPointer()->m_location;
}

unsigned Interpreter::countPendingCallbacks()
{
	const Semaphore* pendingReturns = pendingCallbacks();

	const ProcessOTE* nil = reinterpret_cast<ProcessOTE*>(Pointers.Nil);
	const ProcessOTE* oteLink = pendingReturns->m_firstLink;
	unsigned count = 0;

	while (oteLink != nil)
	{
		_ASSERTE(oteLink->m_oteClass == Pointers.ClassProcess);
		const Process* proc = oteLink->m_location;
		count++;
		oteLink = proc->Next();
	}
	return count;
}

// A callback has completed - wake ALL the processes waiting for callback exits (we do this to 
// guarantee we wake the next one, and because it is very unlikely that there will be even one).
void Interpreter::wakePendingCallbacks()
{
	// We cannot get in here unless the current active process is the callback process
	
	Process* process = actualActiveProcess();

	process->DecrementCallbackDepth();

	SemaphoreOTE* pendingSemOop = pendingCallbacksPointer();
	while (m_nCallbacksPending)
	{
		asynchronousSignal(pendingSemOop);
		m_nCallbacksPending--;
		//char buf[256];
		//sprintf(buf, "Signalling callback semaphore (%u signals, %u total)\n", m_qAsyncSignals.Count(), m_nAsyncPending);
		//OutputDebugString(buf);
	}
}

void Interpreter::pushUnknown(Oop object)
{
	push(object);
	if (!ObjectMemoryIsIntegerObject(object))
	{
		OTE* ote = reinterpret_cast<OTE*>(object);
		if (ote->m_count == 0)
		{
			HARDASSERT(!ote->isFree());
			ObjectMemory::AddToZct(ote);
		}
	}
}

// Public methods for performing callbacks
Oop	__stdcall Interpreter::perform(Oop receiver, SymbolOTE* selector TRACEPARM) /* throws SE_VMCALLBACKUNWIND */
{
	pushObject((OTE*)Pointers.Scheduler);
	pushUnknown(receiver);
	pushObject((OTE*)selector);
	return callback(Pointers.callbackPerformSymbol, 2 TRACEARG(traceFlag));
}

Oop	__stdcall Interpreter::performWith(Oop receiver, SymbolOTE* selector, Oop arg TRACEPARM) /* throws SE_VMCALLBACKUNWIND */
{
	pushObject((OTE*)Pointers.Scheduler);
	pushUnknown(receiver);
	pushObject((OTE*)selector);
	pushUnknown(arg);
	return callback(Pointers.callbackPerformWithSymbol, 3 TRACEARG(traceFlag));
}

Oop	__stdcall Interpreter::performWithWith(Oop receiver, SymbolOTE* selector, Oop arg1, Oop arg2 TRACEPARM) /* throws SE_VMCALLBACKUNWIND */
{
	pushObject((OTE*)Pointers.Scheduler);
	pushUnknown(receiver);
	pushObject((OTE*)selector);
	pushUnknown(arg1);
	pushUnknown(arg2);
	return callback(Pointers.callbackPerformWithWithSymbol, 4 TRACEARG(traceFlag));
}

Oop	__stdcall Interpreter::performWithWithWith(Oop receiver, SymbolOTE* selector, Oop arg1, Oop arg2, Oop arg3 TRACEPARM) /* throws SE_VMCALLBACKUNWIND */
{
	pushObject((OTE*)Pointers.Scheduler);
	pushUnknown(receiver);
	pushObject((OTE*)selector);
	pushUnknown(arg1);
	pushUnknown(arg2);
	pushUnknown(arg3);
	return callback(Pointers.callbackPerformWithWithWithSymbol, 5 TRACEARG(traceFlag));
}


Oop	__stdcall Interpreter::performWithArguments(Oop receiver, SymbolOTE* selector, Oop anArray TRACEPARM) /* throws SE_VMCALLBACKUNWIND */
{
	pushObject((OTE*)Pointers.Scheduler);
	pushUnknown(receiver);
	pushObject((OTE*)selector);
	ASSERT(ObjectMemory::fetchClassOf(anArray) == Pointers.ClassArray);
	pushUnknown(anArray);
	return callback(Pointers.callbackPerformWithArgumentsSymbol, 3 TRACEARG(traceFlag));
}

#pragma code_seg(MEM_SEG)

// Allocate a new four byte object of the specified (unref counted) class from the DWORD pool
BytesOTE* __fastcall Interpreter::NewDWORD(DWORD dwValue, BehaviorOTE* classPointer)
{
	BytesOTE* ote = m_otePools[DWORDPOOL].newByteObject(classPointer, sizeof(DWORD), OTEFlags::DWORDSpace);
	ASSERT(ObjectMemory::hasCurrentMark(ote));

	// Assign class as this can differ in this particular pool, which is used for all manner of 32-bit objects
	ote->m_oteClass = classPointer;

	DWORDBytes* dwObj = reinterpret_cast<DWORDBytes*>(ote->m_location);
	dwObj->m_dwValue = dwValue;

	return ote;
}

#pragma code_seg(XIF_SEG)

// Symbol result has correct ref. count
SymbolOTE* __stdcall Interpreter::NewSymbol(const char* name) /* throws SE_VMCALLBACKUNWIND */
{
	// Run some Smalltalk code in the interpreter's current context
	// to intern the symbol (Symbol intern: aString)
	//

	pushObject((OTE*)Pointers.ClassSymbol);
	pushNewObject((OTE*)Utf8String::New(name));
	SymbolOTE* symbolPointer = reinterpret_cast<SymbolOTE*>(callback(Pointers.InternSelector, 1 TRACEARG(TraceOff)));
	ASSERT(symbolPointer->m_oteClass == Pointers.ClassSymbol);
	ASSERT(symbolPointer->m_count > 1);
	ASSERT(symbolPointer->isNullTerminated());
	// Since it is a symbol, we don't need the extra ref. added by callback
	// and this won't cause it to be added to the Zct (see previous assertion)
	symbolPointer->countDown();
	return symbolPointer;
}

///////////////////////////////////

#pragma code_seg(GC_SEG)

void Interpreter::MarkRoots()
{
	unsigned i=0;
	while (m_roots[i])
	{
		ObjectMemory::MarkObjectsAccessibleFromRoot(*m_roots[i]);
		i++;
	}

	OverlappedCall::MarkRoots();
}

// A compacting GC has occurred, ask ObjectMemory to update any stored down Oops
void Interpreter::OnCompact()
{
	// Reinitialize the various VM circular queues
	m_qForFinalize.onCompact();
	m_qBereavements.onCompact();
	m_qAsyncSignals.onCompact();
	m_qInterrupts.onCompact();

	unsigned i=0;
	while (m_roots[i])
	{
		ObjectMemory::compactOop(*m_roots[i]);
		i++;
	}	

	ASSERT(m_oteNewProcess->isNil() || m_oteNewProcess->m_oteClass == Pointers.ClassProcess);
	ObjectMemory::compactOop(m_oopMessageSelector);
	ObjectMemory::compactOop(m_registers.m_oopNewMethod);
	ASSERT(ObjectMemory::isKindOf(m_registers.m_oopNewMethod, Pointers.ClassCompiledMethod));
	ObjectMemory::compactOop(m_registers.m_oteActiveProcess);
	ASSERT(ObjectMemory::isKindOf(m_registers.m_oteActiveProcess, Pointers.ClassProcess));

	flushCaches();

	OverlappedCall::OnCompact();
	//compiler->onCompact();
}

#pragma code_seg()

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//

inline LRESULT Interpreter::lResultFromOop(Oop objectPointer, HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	if (ObjectMemoryIsIntegerObject(objectPointer))
		// The result is a SmallInteger (the most common answer we hope)
		return ObjectMemoryIntegerValueOf(objectPointer);
	
	OTE* ote = reinterpret_cast<OTE*>(objectPointer);
	if (ote->isBytes())
	{
		ASSERT(ote->bytesSize() <= 8);
		LargeInteger* l32i = static_cast<LargeInteger*>(ote->m_location);
		LRESULT lResult = l32i->m_digits[0];
		ote->countDown();
		return lResult;
	}

	trace(L"DolphinWndProc: Non-LRESULT value returned for MSG(hwnd:%p, msg:%u, wParam:%x, lParam:%x)\n",
				hWnd, uMsg, wParam, lParam);

	ote->countDown();

	// Non-LRESULT returned, so do the only thing possible - call the default window procedure
	return ::DefWindowProc(hWnd, uMsg, wParam, lParam);
}

// Common window procedure for all Dolphin Windows (dispatching handled in Smalltalk)
LRESULT CALLBACK Interpreter::DolphinWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	//CHECKREFERENCES
	#ifdef _DEBUG
		if (ObjectMemoryIntegerValueOf(m_registers.m_pActiveFrame->m_ip) > 1024)
			_asm int 3;
	#endif

	ResetInputPollCounter();

	LRESULT lResult;

	__try 
	{
		// N.B. All allocation and pushing must be performed within the try
		// block in case either stack or object table overflow occurs,
		// and we must not pass exceptions back over the window process
		// boundary as the originator could be a send message in non-Smalltalk
		// code.


		#ifdef _DEBUG
			// InterpreterRegisters savedContext = m_registers;
		#endif

		// Dispatch to Smalltalk
		pushObject(Pointers.Dispatcher);
		pushUnsigned32(DWORD(hWnd));
		pushUnsigned32(uMsg);
		pushUnsigned32(wParam);
		pushUnsigned32(lParam);

		disableInterrupts(true);
		Oop lResultOop = callback(Pointers.wndProcSelector, 4 TRACEARG(TraceOff));

		#ifdef _DEBUG
			// Sanity check - remember that activeContext may be unwind block if error occurred
			//if (savedActiveContext == activeContext)
			{
				//ASSERT(!memcmp(&savedContext, &m_registers, sizeof(InterpreterRegisters)));
			}
		#endif

		// Decode result
		lResult = lResultFromOop(lResultOop, hWnd, uMsg, wParam, lParam);
	}
	__except(callbackExceptionFilter(GetExceptionInformation()))
	{
		// N.B. callbackExceptionFilter() catches SE_VMCALLBACKUNWIND exceptions
		// and passes them to this handler

		lResult = 0;

		// Answer some default return value appropriate for the window message
		switch(uMsg)
		{
		case WM_CREATE:
			// Fail creation
			lResult = -1;
			break;

		case WM_PAINT:
			// We don't want to get the paint again, so just validate it
			::ValidateRect(hWnd, NULL);
			break;

		default:
			//lResult = ::DefWindowProc(hWnd, uMsg, wParam, lParam);
			break;
		}

		#ifdef _DEBUG
		{
			trace(L"WARNING: Unwinding DolphinWndProc(%#x, %d, %d, %d) ret: %d\n",
				hWnd, uMsg, wParam, lParam, lResult);
		}
		#endif
	}

	// On exit from WndProc, interrupts are always enabled
	disableInterrupts(false);
	return lResult;
}


///////////////////////////////////////////////////////////////////////////////
// Exception filter for uses of the callback() routine. Handles memory errors due to 
// OT/process stack overflow, and passes control to the user defined exception handler
// should an unwind occur. This is the handler which actually unwinds a callback when
// SE_VMCALLBACKUNWIND is thrown, and is an outer handler within which the callback()
// function is called.

int __stdcall Interpreter::callbackExceptionFilter(LPEXCEPTION_POINTERS info)
{
	EXCEPTION_RECORD* pExRec = info->ExceptionRecord;
	switch(pExRec->ExceptionCode)
	{
		case SE_VMCALLBACKUNWIND:
			// Abnormal exit from callback (unwind not return)
			resizeActiveProcess();
			return EXCEPTION_EXECUTE_HANDLER;

		case EXCEPTION_ACCESS_VIOLATION:
#if !defined(NO_GPF_TRAP)
			// Handle errors due to stack/OT overflow
			return memoryExceptionFilter(info);
#endif
		default:
			return EXCEPTION_CONTINUE_SEARCH;
	}
}


inline DWORD __stdcall Interpreter::GenericCallbackMain(SMALLINTEGER id, BYTE* lpArgs)
{
	DWORD result;
	__try
	{
		// All accesses to stack/OT allocations must be inside the
		// memoryExceptionFilter to implement stack and OT growth-on-demand
		pushObject((OTE*)Pointers.Scheduler);
		pushSmallInteger(id);
		// Add sizeof(DWORD*) to the stack pointer as it includes the return address for
		// the call which invoked the function
		pushUIntPtr(reinterpret_cast<UINT_PTR>(reinterpret_cast<DWORD*>(lpArgs)+1));
		Oop oopAnswer = callback(Pointers.genericCallbackSelector, 2 TRACEARG(TraceOff));
		result = callbackResultFromOop(oopAnswer);
	}
	__except (callbackExceptionFilter(GetExceptionInformation()))
	{
		#ifdef _DEBUG
		{
			wchar_t buf[128];
			wsprintfW(buf, L"WARNING: Unwinding GenericCallback(%d, %p)\n", id, lpArgs);
			WarningWithStackTrace(buf);
		}
		#endif
		result = 0;
	}

	return result;
}

LRESULT CALLBACK Interpreter::VMWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch(uMsg)
	{
	case SyncMsg:
		return DolphinWndProc(hWnd, uMsg, wParam, lParam);
		break;
	case SyncCallbackMsg:
		return GenericCallbackMain(static_cast<SMALLINTEGER>(wParam), reinterpret_cast<BYTE*>(lParam));
		break;
	case SyncVirtualMsg:
		return VirtualCallbackMain(static_cast<SMALLINTEGER>(wParam), reinterpret_cast<COMThunk**>(lParam));
		break;
	default:
		return DefWindowProc(hWnd, uMsg, wParam, lParam);
	}
}

///////////////////////////////////////////////////////////////////////////////
// GenericCallback is the routine used for constructing function pointers for passing to external
// libraries as callback functions.
DWORD __stdcall Interpreter::GenericCallback(SMALLINTEGER id, BYTE* lpArgs)
{
	DWORD dwResult;
	// We must perform this all inside our standard SEH catcher to handle the stack/OT overflows etc 
	// As we have entered from an external function
	if (GetCurrentThreadId() != MainThreadId())
	{
		dwResult = SendMessage(m_hWndVM, SyncCallbackMsg, static_cast<WPARAM>(id), reinterpret_cast<LPARAM>(lpArgs));
	}
	else
		dwResult = GenericCallbackMain(id, lpArgs);

	return dwResult;
}


DWORD Interpreter::callbackResultFromOop(Oop objectPointer)
{
	if (ObjectMemoryIsIntegerObject(objectPointer))
		// The result is a SmallInteger (the most common answer we hope)
		return ObjectMemoryIntegerValueOf(objectPointer);

	OTE* ote = reinterpret_cast<OTE*>(objectPointer);
	if (ote->isBytes())
	{
		ASSERT(ote->bytesSize() <= 8);
		LargeInteger* l32i = static_cast<LargeInteger*>(ote->m_location);
		LRESULT lResult = l32i->m_digits[0];
		// Remove the ref. added by callback()
		ote->countDown();
		return lResult;
	}
	else
		if (ote->isNil())
			return 0;

#ifdef _DEBUG
	TRACESTREAM<< L"WARNING: Returned non-Integer object from callback: " << ote << std::endl;
	WarningWithStackTrace(L"");
#else
	tracelock lock(TRACESTREAM);
	trace(L"WARNING: Returned non-Integer object from callback\n");
#endif

	ote->countDown();

	return 0;	// The best we can do is to answer 0
}

Oop* __fastcall Interpreter::primitiveReturnFromCallback(Oop* const sp, unsigned)
{
	// Raise a special exception caught by the callback entry point routine - the result will still be on top
	// of the stack

	// Don't want to do anything if callbackDepth = 0
	if (m_registers.m_pActiveProcess->m_callbackDepth != ZeroPointer)
	{
		Oop callbackCookie = *sp;

		// IP already saved down - if we succeed in returning, we want to pop the arg
		m_registers.m_stackPointer = sp - 1;

		// Is it current callback ?
		if (callbackCookie == currentCallbackContext)
		{
			int* pJumpBuf = reinterpret_cast<int*>(callbackCookie ^ 1);
			longjmp(pJumpBuf, SE_VMCALLBACKEXIT);

			// Can't get here
			__assume(false);
		}
		else
		{
			// Passed zero?
			if (callbackCookie == ZeroPointer)
			{
				// I don't think this is used any more. The cookie will always be non-zero

				::RaiseException(SE_VMCALLBACKEXIT, 0, 1, reinterpret_cast<const ULONG_PTR*>(&callbackCookie));

				// Push the cookie argument back on the stack
				*(sp + 1) = callbackCookie;

				// The exception filter will specify continued execution if the current active process is not the
				// process active when the last callback was entered, so we fail the primitive.The backup Smalltalk
				// will yield and recursively try again
			}

			m_nCallbacksPending++;	 // record that callbacks are waiting to exit
			return nullptr;
		}

	}
	else
	{
		return nullptr;
	}
}

Oop* __fastcall Interpreter::primitiveUnwindCallback(Oop* const sp, unsigned)
{
	// Don't want to do anything if callbackDepth = 0
	if (m_registers.m_pActiveProcess->m_callbackDepth != ZeroPointer)
	{
		Oop callbackCookie = *sp;

		// IP already saved down - if we succeed in unwindind, we want to pop the arg
		m_registers.m_stackPointer = sp - 1;

		// Is it current callback ?
		if (callbackCookie == currentCallbackContext || callbackCookie == ZeroPointer)
		{
			::RaiseException(SE_VMCALLBACKUNWIND, 0, 1, reinterpret_cast<const ULONG_PTR*>(&callbackCookie));

			// Note that the exception handler never executes handler, but may return here(if not continues search)

			// Push the cookie argument back on the stack
			*(sp + 1) = callbackCookie;

			// The exception filter will specify continued execution if the current active process is not the
			// process active when the last callback was entered, so we fail the primitive.The backup Smalltalk
			// will yield and recursively try again
		}

		// Fail and try again as this was not current callback - record that callbacks are waiting to exit
		m_nCallbacksPending++;
	}

	return nullptr;
}

///////////////////////////////////////////////////////////////////////////////
// Virtual function call-ins

DWORD __fastcall Interpreter::VirtualCallback(SMALLINTEGER offset, COMThunk** args)
{
		DWORD dwResult;
		// We must perform this all inside our standard SEH catcher to handle the stack/OT overflows etc 
		// As we have entered from an external function
		if (GetCurrentThreadId() != MainThreadId())
		{
			dwResult = SendMessage(m_hWndVM, SyncVirtualMsg, static_cast<WPARAM>(offset), reinterpret_cast<LPARAM>(args));
		}
		else
			dwResult = VirtualCallbackMain(offset, args);

		return dwResult;
}

DWORD __fastcall Interpreter::VirtualCallbackMain(SMALLINTEGER offset, COMThunk** args)
{
	// We must perform this all inside our standard SEH catcher to handle the stack/OT overflows etc 
	// and also to handle unwinds
	DWORD result;
	__try
	{
		pushObject((OTE*)Pointers.Scheduler);
		pushSmallInteger(offset+1);	// Smalltalk expects 1-based index
		COMThunk* thisPtr = *args;
		pushSmallInteger(thisPtr->id);
		pushSmallInteger(thisPtr->subId);
		// Arguments are underneath thisPtr on stack
		pushUIntPtr(reinterpret_cast<UINT_PTR>(args+1));
		Oop oopAnswer = callback(Pointers.virtualCallbackSelector, 4 TRACEARG(Interpreter::TraceOff));
		result = callbackResultFromOop(oopAnswer);
	}
	__except (callbackExceptionFilter(GetExceptionInformation()))
	{
		TRACESTREAM<< L"WARNING: Unwinding VirtualCallback(" << std::dec << offset << L',' << args << L')' << std::endl; 
		result = static_cast<DWORD>(E_UNEXPECTED);
	}

	return result;
};

__declspec(naked) int __stdcall _commonVfnEntryPoint()
{
	_asm 
	{
		mov		eax, [esp+4]
		mov		edx, esp
		add		edx, 4							; Edx now points at this pointer in stack (assume stdcall)
		mov		eax, [eax].argSizes
		mov		eax, [eax+ecx*4]
		push	eax								; Save arg size for later
		call	Interpreter::VirtualCallback
		pop		ecx								; Account for this pointer in arg size
		pop		edx								; Pop the return address
		add		esp, ecx
		mov		[esp], edx
		ret
	}
}

#pragma code_seg(INIT_SEG)

void InitializeVtbl()
{
	ASSERT(sizeof(VTblThunk) == 10);

	aVtblThunks = static_cast<VTblThunk*>(::VirtualAlloc(NULL, NUMVTBLENTRIES*sizeof(VTblThunk), MEM_COMMIT, PAGE_READWRITE));

	for (unsigned i=0;i<NUMVTBLENTRIES;i++)
	{
		VTable[i] = &aVtblThunks[i];
		//aVtblThunks[i].int3 = 0xCC;
		aVtblThunks[i].movEcx = 0xB9;
		aVtblThunks[i].id = i;
		aVtblThunks[i].jmp = 0xE9;	// Near jump to relative location
		// Offset is relative to next instruction
		aVtblThunks[i].commonVfnEntryPoint = 
				reinterpret_cast<BYTE*>(_commonVfnEntryPoint) 
					- reinterpret_cast<BYTE*>(&aVtblThunks[i+1]);
	}

	DWORD dwOldProtect;
	VERIFY(::VirtualProtect(aVtblThunks, NUMVTBLENTRIES*sizeof(VTblThunk), PAGE_EXECUTE_READ, &dwOldProtect));
	VERIFY(FlushInstructionCache(GetCurrentProcess(), aVtblThunks, NUMVTBLENTRIES*sizeof(VTblThunk)));
}

#pragma code_seg(TERM_SEG)

void DestroyVtbl()
{
	// When specifying MEM_RELEASE, must pass 0 as the size
	VERIFY(::VirtualFree(aVtblThunks, /*NUMVTBLENTRIES*sizeof(VTblThunk)*/ 0, MEM_RELEASE));
	aVtblThunks = NULL;
}

