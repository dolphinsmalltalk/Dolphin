/******************************************************************************

	File: Interprt.h

	Description:

	Specification of the Smalltalk Interpreter

******************************************************************************/
#pragma once

///////////////////////////////////
#include "ObjMem.h"
#include "OopQ.h"
#include "STExternal.h"
#include "STBehavior.h"
#include "STClassDesc.h"
#include "InterpRegisters.h"

#include "DolphinX.h"
#include "bytecdes.h"

using namespace ST;

///////////////////////////////////

#ifdef _DEBUG
	#define TRACEARG(x)	,(x)
	#define	TRACEPARM	,TRACEFLAG traceFlag
	#define TRACEDEFAULT	TRACEPARM=TraceOff
	#define CHECKREFERENCESSP(sp)	Interpreter::checkReferences(sp)
	#define CHECKREFERENCES	Interpreter::checkReferences(Interpreter::GetRegisters());
	#define CHECKREFERENCESIF(x) { if (x) CHECKREFERENCES }
	#define CHECKREFSNOFIX \
	{\
		bool bAsyncGCDisabled = Interpreter::m_bAsyncGCDisabled;\
		Interpreter::m_bAsyncGCDisabled = true;\
		CHECKREFERENCES\
		Interpreter::m_bAsyncGCDisabled = bAsyncGCDisabled;\
	}
#else
	#define TRACEPARM
	#define TRACEARG(x)
	#define TRACEDEFAULT
	#define CHECKREFERENCES
	#define CHECKREFERENCESSP(sp)
	#define CHECKREFERENCESIF(x)
	#define CHECKREFSNOFIX
#endif

// Entry point (from CPP) for invocation of assembler interpreter
// This is where the stack overflow handling is carried out

extern "C" void __cdecl byteCodeLoop();	// See byteasm.asm

typedef volatile LONG SHAREDLONG;

#define pop(number) (Interpreter::m_registers.m_stackPointer -=(number))
#define popStack()	(*Interpreter::m_registers.m_stackPointer--)

class Interpreter
{
	friend class ObjectMemory; 
	friend class BootLoader;

public:
	#ifdef _DEBUG
		enum TRACEFLAG { TraceInherit, TraceOff, TraceForce };
	#endif

	static HRESULT initialize(const wchar_t* szFileName, LPVOID imageData, UINT imageSize, bool isDevSys);

	// Fire off the startup message
	static void sendStartup(const wchar_t* szImagePath, DWORD dwArg);

	// Clear down current image, etc
	static void ShutDown();

	// Run the interpreter
	static void interpret();

	// Initialise
	static HRESULT initializeAfterLoad();

	// To allow the ObjectMemory to account for objects referenced from the VM we maintain an "Array"
	// to keep the ref. count on our behalf
	//
	enum { INITIALVMREFERENCES = 16 };

public:
	#if defined(_DEBUG)
		static void AddVMReference(Oop);
		static void AddVMReference(OTE*);
		static void RemoveVMReference(Oop);
		static void RemoveVMReference(OTE*);

		static void checkReferences(Oop* const sp);
		static void checkReferences(InterpreterRegisters&);

		// Only needed for non-Debug because of C++ walkback code
		static void WarningWithStackTrace(const wchar_t* warningCaption, StackFrame* pFrame=NULL);
		static void WarningWithStackTraceBody(const wchar_t* warningCaption, StackFrame* pFrame);
		static BOOL isCallbackFrame(Oop framePointer);
	#endif

	static void StackTraceOn(std::wostream& dc, StackFrame* pFrame=NULL, unsigned depth=10);
	static void DumpStack(std::wostream&, unsigned);
	static void DumpContext(EXCEPTION_POINTERS *pExceptionInfo, std::wostream& logStream);
	static void DumpContext(std::wostream& logStream);
	static std::wstring PrintString(Oop);
	
	#ifdef _DEBUG
		static void DumpOTEPoolStats();
		static void ReincrementVMReferences();
	#endif

	// Snapshotting
	//static BOOL SaveImageFile(const char* szFileName=0);

	// External interface
	static SymbolOTE* __stdcall NewSymbol(const char* name);
	
	// Private helpers
	
	static BytesOTE* __fastcall NewDWORD(DWORD dwValue, BehaviorOTE* classPointer);

	// Users of callback(), or any routine which invokes it (basically, anything which sends
	// a message into Smalltalk for evaluation), needs to be prepared to catch the SE code
	// for callback unwinds, and do the appropriate thing. If not caught at every callback
	// point, then must be caught at some major entry point from Smalltalk to prevent it
	// unwinding other callbacks (esp. window procedure entry points).
	static Oop	__stdcall callback(SymbolOTE* selector, unsigned argCount TRACEPARM) 
		/* throws  SE_VMCALLBACKUNWIND */;

	static LRESULT lResultFromOop(Oop objectPointer, HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	static LRESULT CALLBACK DolphinWndProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	static LRESULT CALLBACK VMWndProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	static LRESULT CALLBACK DolphinDlgProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	static LRESULT CALLBACK CbtFilterHook(int code, WPARAM wParam, LPARAM lParam);
	static void subclassWindow(OTE* window, HWND hWnd);

	static DWORD callbackResultFromOop(Oop objectPointer);

	enum
	{
		SyncMsg = WM_USER,
		SyncCallbackMsg,
		SyncVirtualMsg
	};
	static DWORD __stdcall GenericCallbackMain(SMALLINTEGER id, BYTE* lpArgs);
	static DWORD __stdcall GenericCallback(SMALLINTEGER id, BYTE* lpArgs);

	struct COMThunk
	{
		PROC*	vtbl;
		DWORD*	argSizes;
		DWORD	id;
		DWORD	subId;
	};

	static DWORD __fastcall VirtualCallback(SMALLINTEGER id, COMThunk** thisPtr);
	static DWORD __fastcall VirtualCallbackMain(SMALLINTEGER id, COMThunk** thisPtr);

	// CompiledMethod bytecode decoding (in decode.cpp)
	#if defined(_DEBUG)
		static const wchar_t* activeMethod();
		static void decodeMethod(CompiledMethod*, std::wostream* pstream=NULL);
		static void decodeMethodAt(CompiledMethod*, unsigned ip, std::wostream&);
#endif

	// Contexts
	static StackFrame* activeFrame();
	static void __fastcall resizeActiveProcess();

	static void IncStackRefs(Oop* const sp);
	static void DecStackRefs(Oop* const sp);

	// Stack

	static void push(Oop object);					// Most general, push SmallInteger OR object
	static void pushNewObject(Oop);					// Push newly created objects (add to Zct)
	static void pushUnknown(Oop);					// Push an object that might be new, might be old
	static void pushBool(BOOL bValue);				// Push the appropriate Smalltalk boolean object
	static void pushSmallInteger(SMALLINTEGER n);	// Push a gtd SmallInteger (no overflow check)
	static void pushUnsigned32(DWORD value);
	static void pushSigned32(SDWORD value);
	static void pushUIntPtr(UINT_PTR value);
	static void pushIntPtr(INT_PTR value);
	static void push(LPCSTR psz);					// Push ANSI string
	static void push(LPCWSTR pwsz);					// Push Wide string
	static void pushNil();
	static void pushHandle(HANDLE h);
	static void push(double d);

	// To be used when pushing a known non-SmallInteger (skips the SmallInteger check)
	static void pushObject(OTE* object)
	{
		push(reinterpret_cast<Oop>(object));
	}

	// Push newly created objects (add to Zct)
	static void pushNewObject(OTE* object)
	{
		// Note that object is pushed on stack before being added to Zct, this means
		// that on ZCT overflow the reconciliation will work correctly
		pushObject(object);
		ObjectMemory::AddToZct(object);
	}

	static Oop popAndCountUp();
	
	// N.B. pop() merely adjusts the stackPointer, remember that
	// it is necessary to ensure that no ref. counted objects
	// remain above the stackPointer (this is why there's no unPop)
	static SMALLUNSIGNED indexOfSP(Oop* sp);

	// Method lookup

	__declspec(align(16)) struct MethodCacheEntry
	{
		// Note that the method cache must include the class, as if one tests against
		// the method's methodClass inherited methods will always result in a cache miss
		// (e.g. for #new:, which is deeply inherited by many classes such as Array)
		// The selector, on the other hand, can be tested against in the method itself.
		const SymbolOTE*	selector;
		const BehaviorOTE* 	classPointer;
		MethodOTE* 			method;
		intptr_t			primAddress;
	};

	static MethodCacheEntry* __fastcall findNewMethodInClass(BehaviorOTE* classPointer, const unsigned argCount);
	static MethodCacheEntry* __stdcall findNewMethodInClassNoCache(BehaviorOTE* classPointer, const unsigned argCount);
	static MethodOTE* __fastcall lookupMethod(BehaviorOTE* aClass, SymbolOTE* selector);
	static MethodCacheEntry* __fastcall messageNotUnderstood(BehaviorOTE* aClass, const unsigned argCount);
	static void __fastcall createActualMessage(const unsigned argCount);

	//Misc

	// Garbage collection and Finalization/Bereavement Queue management
	static void syncGC(DWORD gcFlags);
	static void asyncGC(DWORD gcFlags);

#ifdef PROFILING
	static void StartProfiling();
	static void StopProfiling();
#endif

public:

	enum VMInterrupts { 
						VMI_TERMINATE = ObjectMemoryIntegerObjectOf(1),
						VMI_STACKOVERFLOW = ObjectMemoryIntegerObjectOf(2), 
						VMI_BREAKPOINT = ObjectMemoryIntegerObjectOf(3),
						VMI_SINGLESTEP = ObjectMemoryIntegerObjectOf(4),
						VMI_ACCESSVIOLATION = ObjectMemoryIntegerObjectOf(5), 
						VMI_IDLEPANIC = ObjectMemoryIntegerObjectOf(6),
						VMI_GENERIC = ObjectMemoryIntegerObjectOf(7),
						VMI_STARTED = ObjectMemoryIntegerObjectOf(8),
						VMI_KILL = ObjectMemoryIntegerObjectOf(9),
						VMI_FPFAULT = ObjectMemoryIntegerObjectOf(10),
						VMI_USERINTERRUPT = ObjectMemoryIntegerObjectOf(11),
						VMI_ZERODIVIDE = ObjectMemoryIntegerObjectOf(12),
						VMI_OTOVERFLOW = ObjectMemoryIntegerObjectOf(13),
						VMI_CONSTWRITE = ObjectMemoryIntegerObjectOf(14),
						// Miscellaneous exceptions
						VMI_EXCEPTION = ObjectMemoryIntegerObjectOf(15),
						VMI_FPSTACK = ObjectMemoryIntegerObjectOf(16),
						VMI_NOMEMORY = ObjectMemoryIntegerObjectOf(17),
						VMI_HOSPICECRISIS = ObjectMemoryIntegerObjectOf(18),
						VMI_BEREAVEDCRISIS = ObjectMemoryIntegerObjectOf(19),
						VMI_CRTFAULT = ObjectMemoryIntegerObjectOf(20)
						};

#ifdef _DEBUG
	static const char* InterruptNames[static_cast<int>(VMI_CRTFAULT) + 1];
#endif

	static bool __fastcall disableInterrupts(bool bDisable);

	static bool disableAsyncGC(bool bDisable);
	static void OnCompact();
	static void MarkRoots();

	// Clear down the object caches for VM alloc'd objects
	static void freePools();

	// All of these may throw SE_VMCALLBACKUNWIND, as well as stack/OT overflow access violations, and
	// so should be called within a callbackExceptionFilter() __try/__except block
	static Oop	__stdcall perform(Oop receiver, SymbolOTE* selector TRACEDEFAULT);
	static Oop	__stdcall performWith(Oop receiver, SymbolOTE* selector, Oop arg TRACEDEFAULT);
	static Oop	__stdcall performWithWith(Oop receiver, SymbolOTE* selector, Oop arg1, Oop arg2 TRACEDEFAULT);
	static Oop	__stdcall performWithWithWith(Oop receiver, SymbolOTE* selector, Oop arg1, Oop arg2, Oop arg3 TRACEDEFAULT);
	static Oop	__stdcall performWithArguments(Oop receiver, SymbolOTE* selector, Oop argArray TRACEDEFAULT);

	// Exception filter for use with above methods - catches callback unwinds and activates handler (also
	// memory exceptions from pushing parms etc on the stack)
	static int __stdcall callbackExceptionFilter(LPEXCEPTION_POINTERS info);

	static void __fastcall activateNewMethod(CompiledMethod* methodPointer);

private:

	//////////////////////////////////////////////////////////
	// Private initialisation/termination

	static HRESULT initializeBeforeLoad();
	static HRESULT initializeImage();
	static void initializeVMReferences();

	static void GuiShutdown();

	// Timer init and shutdown
	static HRESULT initializeTimer();
	static void terminateTimer();

	static HRESULT initializeCharMaps();

private:
	///////////////////////////////////////////////////////////////////////////
	// Byte Code Interpretation methods
	
	static void exitSmalltalk(int exitCode);

	static int interpreterExceptionFilter(LPEXCEPTION_POINTERS info);
	static int memoryExceptionFilter(LPEXCEPTION_POINTERS pExInfo);
	static int callbackTerminationFilter(LPEXCEPTION_POINTERS info, Process* callbackProcess, Oop prevCallbackContext);

	static void recoverFromFault(LPEXCEPTION_POINTERS pExRec);
	static void sendExceptionInterrupt(Oop oopInterrupt, LPEXCEPTION_POINTERS pExRec);
	static void saveContextAfterFault(LPEXCEPTION_POINTERS info, bool isInPrimitive);

	static void wakePendingCallbacks();
	static unsigned countPendingCallbacks();

	static void sendSelectorArgumentCount(SymbolOTE* selector, unsigned count);
	static void sendSelectorToClass(BehaviorOTE* classPointer, unsigned argCount);
	static void sendVMInterrupt(ProcessOTE* processPointer, Oop nInterrupt, Oop argPointer);
	static void __fastcall sendVMInterrupt(Oop nInterrupt, Oop argPointer);

	static BOOL __stdcall MsgSendPoll();
	static BOOL	__stdcall BytecodePoll();
	static BOOL sampleInput();
	static bool __stdcall IsUserBreakRequested();
	
	static void __fastcall executeNewMethod(MethodOTE* methodOTE, unsigned argCount);
	static void __fastcall returnValueTo(Oop resultPointer, Oop contextPointer);
	static void __fastcall returnValueToCaller(Oop resultPointer, Oop contextPointer);
	static void __fastcall nonLocalReturnValueTo(Oop resultPointer, Oop contextPointer);
	static void __fastcall invalidReturn(Oop resultPointer);

	static BlockOTE* __fastcall blockCopy(DWORD ext);

public:
	static void basicQueueForFinalization(OTE* ote);
	static void queueForFinalization(OTE* ote, int);
	static void queueForBereavementOf(OTE* ote, Oop argPointer);
	// Number of entries in the bereavement queue per object (one for the object, the other the loss count)
	enum { OopsPerBereavementQEntry = 2 };

	// Queue a process interrupt to be executed at the earliest opportunity
	static void __stdcall queueInterrupt(ProcessOTE* processPointer, Oop nInterrupt, Oop argPointer);
	static void __stdcall queueInterrupt(Oop nInterrupt, Oop argPointer);

	// Queue up a semaphore signal to be performed in sync with byte code execution
	// at the next possible opportunity. Used from interrupts and from external sources
	static void asynchronousSignal(SemaphoreOTE* aSemaphore);
	static void asynchronousSignalNoProtect(SemaphoreOTE* aSemaphore);

	static InterpreterRegisters& GetRegisters();

	static bool IsShuttingDown();
	static DWORD MainThreadId();
	static HANDLE MainThreadHandle();

private:

	// Primitive helpers
	static OTE* __fastcall dequeueForFinalization();
	static OTE* dequeueBereaved(ST::VariantObject* out);
	static void scheduleFinalization();

	#ifdef INLINEMEMFNS
		static BOOL success();
		static BOOL setSuccess(BOOL bValue);
		static BOOL primitiveFail();
	#endif

	static void CALLBACK TimeProc(UINT uID, UINT uMsg, DWORD dwUser, DWORD dw1, DWORD dw2);

	// Signal a semaphore; synchronously if no interrupts are pending, else asynchronously.
	// May initiate a Process switch, but does not perform the actual context switch
	// This one is used when in sync with byte code execution
	static void signalSemaphore(SemaphoreOTE* semaphorePointer);

public:
	static void GrabAsyncProtect();
	static void RelinquishAsyncProtect();
	static void NotifyAsyncPending();
	static bool QueueAPC(PAPCFUNC pfnAPC, DWORD dwClosure);
	static void BeginAPC();
	static BOOL SetWakeupEvent();
	static void NotifyOTOverflow();

	#undef Yield
	static void Yield();
	static BOOL FastYield();
	static void sleep(ProcessOTE* aProcess);
	static int SuspendProcess(ProcessOTE* oteProc);
	static void QueueProcessOn(ProcessOTE* oteProc, LinkedListOTE* oteList);
	static BOOL __stdcall Reschedule();

	// Return the active process to a list on which it was previously
	// suspended - this may (if the list is a Semaphore) actually
	// leave the process in a runnable condition.
	static LinkedListOTE* __fastcall ResuspendActiveOn(LinkedListOTE* oteList);
	static LinkedListOTE* ResuspendProcessOn(ProcessOTE* oteProcess, LinkedListOTE* oteList);

	static ProcessOTE* schedule();
	static ProcessOTE* resume(ProcessOTE* aProcess);

	// Accessors to retrieve ProcessorScheduler singleton instance
	static ProcessorScheduler* scheduler();
	static SchedulerOTE* schedulerPointer();

	// Accessors to retrieve active Process (which may be waiting to be started)
	static ProcessOTE* activeProcessPointer();
	static Process* activeProcess();

	// Accessors to retrieve actual active Process (which may be waiting to be suspended)
	static ProcessOTE* actualActiveProcessPointer();
	static Process* actualActiveProcess();

private:
	static SemaphoreOTE* pendingCallbacksPointer();
	static Semaphore* pendingCallbacks();

	static StackFrame* firstFrame();

	static ProcessOTE* wakeHighestPriority();
	static ProcessOTE* resumeFirst(LinkedList* list);
	static ProcessOTE* resumeFirst(Semaphore* sem);
	static BOOL	__fastcall FireAsyncEvents();
	static BOOL __fastcall CheckProcessSwitch();
	static void switchTo(ProcessOTE* processPointer);
	
	#ifdef _DEBUG
		static int highestWaitingPriority();
	#endif

	static bool TerminateOverlapped(ProcessOTE* oteProc);

	static BOOL isAFloat(Oop objectPointer);

private:
	static HANDLE	m_hSampleTimer;

	static HRESULT InitializeSampler();
	static void TerminateSampler();
	static HRESULT SetSampleTimer(SMALLINTEGER newInterval);
	static void CancelSampleTimer();
	static VOID CALLBACK SamplerProc(PVOID lpParam, BOOLEAN TimerOrWaitFired);
	static void ResetInputPollCounter();
	static void AbandonStepping();
	static uint64_t GetMicrosecondClock(); 

public:
	///////////////////////////////////////////////////////////////////////////
	// Primitive Methods
	// Note: All primitives (EXCEPT THOSE INVOKED BY SPECIAL
	//		SELECTORS) are actually passed a reference to the
	//		method from which they are being invoked and the
	// 		argumentCount of that method, but only a very few of
	//		them actually need to look at these values (passed in
	//		the registers ECX and EDX respectively). In the case
	//		of primitives invoked by special selectors, then only
	//		the argumentCount can be relied upon.

	static Oop* primitiveFailure(int failureCode);
	static Oop* primitiveFailureWith(int failureCode, Oop failureOop);
	static Oop* primitiveFailureWith(int failureCode, OTE* failureObject);
	static Oop* primitiveFailureWithInt(int failureCode, SMALLINTEGER failureInt);

private:
	// Answer whether the Interpreter is currently executing a primitive method
	static bool isInPrimitive();

	static Oop* __fastcall unusedPrimitive(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveActivateMethod(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveReturnSelf(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveReturnTrue(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveReturnFalse(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveReturnNil(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveReturnLiteralZero(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveReturnInstVar(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSetInstVar(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveReturnStaticZero(Oop* const sp, unsigned argCount);

	// SmallInteger Arithmetic
	static Oop* __fastcall primitiveAdd(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSubtract(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveMultiply(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveDivide(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveDiv(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveMod(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveQuo(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveQuoAndRem(Oop* const sp, unsigned argCount);

	// SmallInteger relational ops
	static Oop* __fastcall primitiveEqual(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLessThan(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLessOrEqual(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveGreaterThan(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveGreaterOrEqual(Oop* const sp, unsigned argCount);

	// SmallInteger bit manipulation
	static Oop* __fastcall primitiveBitAnd(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveBitOr(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveBitXor(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveBitShift(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveHighBit(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLowBit(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveAnyMask(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveAllMask(Oop* const sp, unsigned argCount);
	
	static Oop* __fastcall primitiveSmallIntegerAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSmallIntegerPrintString(Oop* const sp, unsigned argCount);

	// LargeInteger Arithmetic
	static Oop* __fastcall primitiveLargeIntegerAdd(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerSub(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerMul(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerDivide(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerDiv(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerMod(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerQuoAndRem(Oop* const sp, unsigned argCount);

	// LargeInteger relational ops
	static Oop* __fastcall primitiveLargeIntegerEqual(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerLessThan(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerLessOrEqual(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerGreaterThan(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerGreaterOrEqual(Oop* const sp, unsigned argCount);

	// LargeInteger bit manipulation
	static Oop* __fastcall primitiveLargeIntegerBitInvert(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerNegate(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerBitAnd(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerBitOr(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerBitXor(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerBitShift(Oop* const sp, unsigned argCount);

	// LargeInteger miscellaneous
	static Oop* __fastcall primitiveLargeIntegerNormalize(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLargeIntegerAsFloat(Oop* const sp, unsigned argCount);

	// Float primitives
	static Oop* __fastcall primitiveAsFloat(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatAdd(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatSubtract(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatLessThan(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatLessOrEqual(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatGreaterThan(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatGreaterOrEqual(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatEqual(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatMultiply(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatDivide(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveTruncated(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatSin(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatCos(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatTan(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatArcSin(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatArcCos(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatArcTan(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatArcTan2(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatExp(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatLog(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatLog10(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatSqrt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatTimesTwoPower(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatAbs(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatRaisedTo(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatFloor(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatCeiling(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatExponent(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatNegated(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatFractionPart(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatIntegerPart(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFloatClassify(Oop* const sp, unsigned argCount);

	static Oop* __fastcall primitiveSize(Oop* const sp, unsigned argCount);
   	
	// Object Indexing Primitives
	static Oop* __fastcall primitiveBasicAt(Oop* const sp, const unsigned argCount);
	static Oop* __fastcall primitiveBasicAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveInstVarAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveInstVarAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveNextIndexOfFromTo(Oop* const sp, unsigned argCount);

	///////////////////////////////////////////////////////////////////////////
	// External Buffer access primitives

	enum { PrimitiveFailureNonInteger, PrimitiveFailureBoundsError, PrimitiveFailureBadValue, PrimitiveFailureSystemError, PrimitiveFailureWrongNumberOfArgs };

	static Oop* __fastcall primitiveStructureIsNull(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveBytesIsNull(Oop* const sp, unsigned argCount);

	static Oop* __fastcall primitiveDWORDAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveDWORDAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIndirectDWORDAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIndirectDWORDAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSDWORDAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIndirectSDWORDAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSDWORDAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIndirectSDWORDAtPut(Oop* const sp, unsigned argCount);

	static Oop* __fastcall primitiveWORDAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIndirectWORDAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveWORDAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIndirectWORDAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSWORDAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIndirectSWORDAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSWORDAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIndirectSWORDAtPut(Oop* const sp, unsigned argCount);

	static Oop* __fastcall primitiveQWORDAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSQWORDAt(Oop* const sp, unsigned argCount);

	// Floating point number accessors
	static Oop* __fastcall primitiveSinglePrecisionFloatAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSinglePrecisionFloatAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveDoublePrecisionFloatAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveDoublePrecisionFloatAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLongDoubleAt(Oop* const sp, unsigned argCount);

	// Most of the External Buffer primitives handle indirect addresses
	// as well, but bytes are normally accessed via the standard primitives 
	// for #at: and #at:put:, which we'd rather not complicate and/or slow 
	// these down.
	static Oop* __fastcall primitiveByteAtAddress(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveByteAtAddressPut(Oop* const sp, unsigned argCount);

	// Get address of contents of a byte object
	static Oop* __fastcall primitiveAddressOf(Oop* const sp, unsigned argCount);

	static void PushCharacter(Oop* const sp, MWORD codePoint);

	static Oop* primitiveNewCharacter(Oop * const sp, unsigned);

	///////////////////////////////////////////////////////////////////////////
	// String Class Primitives
	static Oop* __fastcall primitiveStringAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveStringAtPut(Oop* const sp, unsigned argCount);

	// Helper for memory moves
	static void memmove(BYTE* dst, const BYTE* src, size_t count);
	static Oop* __fastcall primitiveReplaceBytes(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIndirectReplaceBytes(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveReplacePointers(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveStringConcatenate(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveCopyFromTo(Oop* const sp, unsigned argCount);

	static Oop* __fastcall primitiveHashBytes(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveStringSearch(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveStringNextIndexOfFromTo(Oop* const sp, unsigned argCount);

	static Oop* __fastcall primitiveStringCollate(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveStringCmp(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveStringCmpOrdinal(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveStringEqual(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveBytesEqual(Oop* const sp, unsigned argCount);

	static Oop* __fastcall primitiveStringAsUtf16String(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveStringAsUtf8String(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveStringAsByteString(Oop* const sp, unsigned argCount);

	// Stream Primitives
	static Oop* __fastcall primitiveNext(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveBasicNext(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveNextSDWORD(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveNextPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveBasicNextPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveNextPutAll(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveAtEnd(Oop* const sp, unsigned argCount);

	// Storage Management Primitives
	static Oop* __fastcall primitiveObjectCount(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveNew(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveNewWithArg(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveNewPinned(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveNewInitializedObject(Oop* sp, unsigned argCount);
	static Oop* __fastcall primitiveNewFromStack(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveNewVirtual(Oop* const sp, unsigned argCount);

	// Object mutation
	static Oop* __fastcall primitiveChangeBehavior(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveResize(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveBecome(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveOneWayBecome(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveGetImmutable(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSetImmutable(Oop* const sp, unsigned argCount);

	// Object Memory primitives
	static Oop* __fastcall primitiveBasicIdentityHash(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIdentityHash(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveAllReferences(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveAllInstances(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveAllSubinstances(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveInstanceCounts(Oop* const sp, unsigned argCount);
	
	// Control Primitives
	static Oop* __fastcall primitiveValue(Oop* const sp, unsigned argumentCount);
	static Oop* __fastcall primitiveValueWithArgs(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveValueWithArgsThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitivePerform(Oop* const sp, unsigned argumentCount);
	static Oop* __fastcall primitivePerformThunk(Oop* const sp, unsigned argumentCount);
	static Oop* __fastcall primitivePerformWithArgs(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitivePerformWithArgsThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitivePerformMethod(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitivePerformMethodThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveReturn(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveReturnFromCallback(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveReturnFromInterrupt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveValueOnUnwind(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveUnwindCallback(Oop* const sp, unsigned argCount);

	// Process primitives
	static Oop* __fastcall primitiveSignal(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSignalThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveWait(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveWaitThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveResume(Oop* const sp, unsigned argumentCount);
	static Oop* __fastcall primitiveResumeThunk(Oop* const sp, unsigned argumentCount);
	static Oop* __fastcall primitiveYield(Oop* const sp, unsigned argumentCount);
	static Oop* __fastcall primitiveYieldThunk(Oop* const sp, unsigned argumentCount);
	static Oop* __fastcall primitiveSingleStep(Oop* const sp, unsigned argumentCount);
	static Oop* __fastcall primitiveSingleStepThunk(Oop* const sp, unsigned argumentCount);
	static Oop* __fastcall primitiveSuspend(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSuspendThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSetSignals(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSetSignalsThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveInputSemaphore(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSampleInterval(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveProcessPriority(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveProcessPriorityThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveTerminateProcess(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveTerminateProcessThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveEnableInterrupts(Oop* const sp, unsigned argCount);
	// Specialized primitive for storing into process stacks. Allows for Zct
	static Oop* __fastcall primitiveStackAtPut(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIndexOfSP(Oop* const sp, unsigned argCount);

	// Timer primitives
	static Oop* __fastcall primitiveSignalAtTick(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSignalAtTickThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveMicrosecondClockValue(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveMillisecondClockValue(Oop* const sp, unsigned argCount);

	// Input/Out Primitives
	static Oop* __fastcall primitiveSnapshot(Oop* const sp, unsigned argCount);

	// Dispatcher Primitives
	static Oop* __fastcall primitiveHookWindowCreate(Oop* const sp, unsigned argCount);

	// System Primitives
	static Oop* __fastcall primitiveIdentical(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveClass(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIsKindOf(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveIsSuperclassOf(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveCoreLeft(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveCoreLeftThunk(Oop* const sp, unsigned argCount);
	static void __fastcall primitiveQuit(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveOopsLeft(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveOopsLeftThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveInheritsFrom(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveShallowCopy(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveSetSpecialBehavior(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveQueueInterrupt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveExtraInstanceSpec(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveDeQBereavement(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveDeQForFinalize(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveLookupMethod(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveFlushCache(Oop* const sp, unsigned argCount);

	// Extension system primitives
	static Oop* __fastcall primitiveDLL32Call(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveVirtualCall(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveAsyncDLL32Call(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveAsyncDLL32CallThunk(Oop* const sp, unsigned argCount);

	static Oop* __fastcall primitivePerformWithArgsAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitivePerformWithArgsAtThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveValueWithArgsAt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveValueWithArgsAtThunk(Oop* const sp, unsigned argCount);

	static Oop* __fastcall primitiveUnwindInterrupt(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveUnwindInterruptThunk(Oop* const sp, unsigned argCount);
	static Oop* __fastcall primitiveVariantValue(Oop* const sp, unsigned argCount);

private:

	static BOOL __stdcall callExternalFunction(FARPROC pProc, unsigned argCount, DolphinX::CallDescriptor* argTypes, BOOL isVirtual);
	
	// Pushs object on stack instantiated from address, and returns size of object pushed
	static void pushArgsAt(CallbackDescriptor* descriptor, unsigned argCount, BYTE* lpParms);
	static unsigned pushArgsAt(const ExternalDescriptor* descriptor, BYTE* lpParms);
	
	static int __cdecl IEEEFPHandler(_FPIEEE_RECORD *pIEEEFPException);

	static void failTrace();

public:
	#ifdef _DEBUG
		// Execution trace
		static int executionTrace;
		static void __fastcall debugExecTrace(BYTE* ip, Oop* sp);
		static void __fastcall debugMethodActivated(Oop* sp);
		static void __fastcall debugReturnToMethod(Oop* sp);
		static void checkStack(Oop* sp);
		static void DumpMethodCacheStats();
		static void DumpCacheStats();
	#endif

public:
	// Special Selector Table
	enum {NumSpecialSelectors = 32};

private:
	// Method cache is a hash table with overwrite on collision
	// If changing method cache size, then must also modify METHODCACHEWORDS in ISTASM.INC!
	enum { MethodCacheSize = 1024 };
	static MethodCacheEntry methodCache[MethodCacheSize];

	static void flushCaches();
	static void initializeCaches();
	
	enum { FIXEDVMREFERENCES };
	enum { SIGNALQGROWTH=32, SIGNALQSIZE=64 };
	enum { INTERRUPTQGROWTH=8, INTERRUPTQSIZE=16 };
	enum { FINALIZEQSIZE = 128 };
	enum { FINALIZEQGROWTH = 128 };
	enum { BEREAVEMENTQSIZE = 64 };
	enum { BEREAVEMENTQGROWTH=64 };

private:
	// Critical section to protect the async queues
	static CRITICAL_SECTION m_csAsyncProtect;

public:
	// Pools
	enum { DWORDPOOL, FLOATPOOL, CONTEXTPOOL, BLOCKPOOL, NUMOTEPOOLS };
	static ObjectMemory::OTEPool m_otePools[NUMOTEPOOLS];
private:

	// Process related registers
	static BOOL newProcessWaiting();

private:
	// Dispatched message
	static HHOOK m_hHookOldCbtFilter;

	static ATOM	 m_atomVMWndClass;
	static HWND	 m_hWndVM;

	// Context related registers
	static DWORD				m_dwThreadId;	// Interpreter thread
	static HANDLE				m_hThread;
	static ProcessorScheduler*	m_pProcessor;
public:
	static InterpreterRegisters16 m_registers;

private:
	static SymbolOTE*			m_oopMessageSelector;

	// Should this be one of the registers?
	static ProcessOTE* m_oteNewProcess;

	static uint64_t m_clockFrequency;

	static OTE* m_oteUnderConstruction;				// Window currently under construction

	// Interpreter referenced objects (roots as may have no other refs)
	static OTE** m_roots[];

	// Process Switching - these are used with InterlockedExchange, so must be longs (not BYTE sized bool)
	static SHAREDLONG	m_bAsyncPending;			// Set when interrupts or async signals are pending.
	static SHAREDLONG	m_bAsyncPendingIOff;		// Ditto, used to buffer when interrupts are off
	static SHAREDLONG*	m_pbAsyncPending; 
	static SHAREDLONG	m_nAPCsPending;				// Count of APCs queued for the interpreter thread

	static BOOL		m_bStepping;					// Flag to indicate whether to break when input sampler drops to 0
	static bool		m_bInterruptsDisabled;			// Flag to indicate whether accepting interrupts or not
	static bool		m_bAsyncGCDisabled;			
	static bool		m_bShutDown;					// Is the interpreter shutting down?

	static unsigned m_nCallbacksPending;			// Number of failed callback exits pending
	static unsigned	m_nOTOverflows;

	// Circular queues to hold the semaphores and interrupts, etc
	static OopQueue<SemaphoreOTE*>	m_qAsyncSignals;
	static OopQueue<Oop>			m_qInterrupts;
	static OopQueue<OTE*>			m_qForFinalize;		// Queue of objects requiring finalization
	static OopQueue<Oop>			m_qBereavements;	// Queue of weakly referencing objects which have suffered bereavements

	// Win32 input queue management
	static SHAREDLONG	m_nInputPollCounter;			// When this goes to zero, its time to poll for input
	static LONG			m_nInputPollInterval;			// Poll counter reset to this after each message queue poll
	static DWORD		m_dwQueueStatusMask;			// Input flags passed to GetQueueStatus to poll for arriving input events

	typedef Oop* (__fastcall *PrimitiveFp)(Oop* const sp, unsigned argCount);
	static PrimitiveFp primitivesTable[256];

public:
	static UINT			m_ansiCodePage;
	static WCHAR		m_unicodeReplacementChar;
	static char			m_ansiReplacementChar;
	static WCHAR		m_ansiToUnicodeCharMap[256];
	static CHAR			m_unicodeToAnsiCharMap[65536];


public:
	#if defined(_DEBUG)
		// List of VM referenced objects (generic mechanism for avoiding GC problems with
		// objects ref'd only from the VM)
		static Oop*	m_pVMRefs;
		static int	m_nFreeVMRef;
		static int	m_nMaxVMRefs;				// Current size of VM References array

		enum { VMREFSINITIAL = 16 };
		enum { VMREFSGROWTH = 64 };
	#endif
};

std::wostream& operator<<(std::wostream& stream, const CONTEXT* pCtx);

///////////////////////////////////

#include "Interprt.inl"
