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
#include "STBlockClosure.h"
#include "InterpRegisters.h"

#include "DolphinX.h"
#include "bytecdes.h"
#include "DolphinSmalltalk_i.h"
#include "PrimitiveFailureCode.h"

using namespace ST;

#ifndef PRIMTABLEDECL
#define PRIMTABLEDECL __declspec(align(16)) const
#endif

///////////////////////////////////

#ifdef _DEBUG
	#define TRACEARG(x)	,(x)
	#define	TRACEPARM	,TRACEFLAG traceFlag
	#define TRACEDEFAULT	TRACEPARM=TRACEFLAG::TraceOff
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
extern "C" void __cdecl invalidByteCode();	// See byteasm.asm

typedef volatile LONG SHAREDLONG;

#define pop(number) (Interpreter::m_registers.m_stackPointer -=(number))
#define popStack()	(*Interpreter::m_registers.m_stackPointer--)

#ifdef _DEBUG
enum class TRACEFLAG { TraceInherit, TraceOff, TraceForce };
#endif

typedef uintptr_t argcount_t;

class Interpreter
{
	friend class ObjectMemory; 
	friend class BootLoader;

public:

	static HRESULT initialize(const wchar_t* szFileName, LPVOID imageData, size_t imageSize, bool isDevSys);

	// Fire off the startup message
	static void sendStartup(const wchar_t* szImagePath, uintptr_t arg);

	// Clear down current image, etc
	static void ShutDown();

	// Run the interpreter
	static void interpret();

	// Initialise
	static HRESULT initializeAfterLoad();

	// To allow the ObjectMemory to account for objects referenced from the VM we maintain an "Array"
	// to keep the ref. count on our behalf
	//
	static constexpr size_t INITIALVMREFERENCES = 16;

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

	static void StackTraceOn(std::wostream& dc, StackFrame* pFrame=NULL, size_t depth=10);
	static void DumpStack(std::wostream&, size_t);
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
	
	static BytesOTE* __fastcall NewUint32(uint32_t value, BehaviorOTE* classPointer);

	// Users of callback(), or any routine which invokes it (basically, anything which sends
	// a message into Smalltalk for evaluation), needs to be prepared to catch the SE code
	// for callback unwinds, and do the appropriate thing. If not caught at every callback
	// point, then must be caught at some major entry point from Smalltalk to prevent it
	// unwinding other callbacks (esp. window procedure entry points).
	static Oop	__stdcall callback(SymbolOTE* selector, argcount_t argCount TRACEPARM) 
		/* throws  SE_VMCALLBACKUNWIND */;

	static LRESULT lResultFromOop(Oop objectPointer, HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	static LRESULT CALLBACK DolphinWndProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	static LRESULT CALLBACK VMWndProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	static LRESULT CALLBACK DolphinDlgProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
	static LRESULT CALLBACK CbtFilterHook(int code, WPARAM wParam, LPARAM lParam);
	static void subclassWindow(OTE* window, HWND hWnd);

	static LRESULT callbackResultFromOop(Oop objectPointer);

	enum class VmWndMsgs : UINT
	{
		Sync = WM_USER,
		SyncCallback,
		SyncVirtual
	};
	static LRESULT __stdcall GenericCallbackMain(SmallInteger id, uint8_t* lpArgs);
	static LRESULT __stdcall GenericCallback(SmallInteger id, uint8_t* lpArgs);

	struct COMThunk
	{
		PROC*		vtbl;
		uint32_t*	argSizes;
		uint32_t	id;
		uint32_t	subId;
	};

	static LRESULT __fastcall VirtualCallback(SmallInteger offset, COMThunk** thisPtr);
	static LRESULT __fastcall VirtualCallbackMain(SmallInteger offset, COMThunk** thisPtr);

	// CompiledMethod bytecode decoding (in decode.cpp)
	#if defined(_DEBUG)
		static const wchar_t* activeMethod();
		static void decodeMethod(CompiledMethod*, std::wostream* pstream=NULL);
		static void decodeMethodAt(CompiledMethod*, size_t ip, std::wostream&);
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
	static void pushSmallInteger(SmallInteger n);	// Store a gtd SmallInteger (no overflow check)
	static void pushUint32(uint32_t value);
	static void pushInt32(int32_t value);
	static void pushUintPtr(uintptr_t value);
	static void pushIntPtr(intptr_t value);
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
	static SmallUinteger indexOfSP(Oop* sp);

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

	static MethodCacheEntry* __fastcall findNewMethodInClass(BehaviorOTE* classPointer, const argcount_t argCount);
	static MethodCacheEntry* __stdcall findNewMethodInClassNoCache(BehaviorOTE* classPointer, const argcount_t argCount);
	static MethodOTE* __fastcall lookupMethod(BehaviorOTE* aClass, SymbolOTE* selector);
	static MethodCacheEntry* __fastcall messageNotUnderstood(BehaviorOTE* aClass, const argcount_t argCount);
	static void __fastcall createActualMessage(const argcount_t argCount);

	//Misc

	// Garbage collection and Finalization/Bereavement Queue management
	static void syncGC(uintptr_t gcFlags);
	static void asyncGC(uintptr_t gcFlags);

#ifdef PROFILING
	static void StartProfiling();
	static void StopProfiling();
#endif

public:

	enum class VMInterrupts : SmallInteger { 
						Terminate = ObjectMemoryIntegerObjectOf(1),
						StackOverflow = ObjectMemoryIntegerObjectOf(2), 
						Breakpoint = ObjectMemoryIntegerObjectOf(3),
						SingleStep = ObjectMemoryIntegerObjectOf(4),
						AccessViolation = ObjectMemoryIntegerObjectOf(5), 
						IdlePanic = ObjectMemoryIntegerObjectOf(6),
						Generic = ObjectMemoryIntegerObjectOf(7),
						Started = ObjectMemoryIntegerObjectOf(8),
						Kill = ObjectMemoryIntegerObjectOf(9),
						FpFault = ObjectMemoryIntegerObjectOf(10),
						UserInterrupt = ObjectMemoryIntegerObjectOf(11),
						ZeroDivide = ObjectMemoryIntegerObjectOf(12),
						OtOverflow = ObjectMemoryIntegerObjectOf(13),
						ConstWrite = ObjectMemoryIntegerObjectOf(14),
						// Miscellaneous exceptions
						Exception = ObjectMemoryIntegerObjectOf(15),
						FpStack = ObjectMemoryIntegerObjectOf(16),
						NoMemory = ObjectMemoryIntegerObjectOf(17),
						HospiceCrisis = ObjectMemoryIntegerObjectOf(18),
						BereavedCrisis = ObjectMemoryIntegerObjectOf(19),
						CrtFault = ObjectMemoryIntegerObjectOf(20)
						};

#ifdef _DEBUG
	static constexpr size_t NumInterrupts = static_cast<size_t>(VMInterrupts::CrtFault) + 1;
	static const char* InterruptNames[NumInterrupts];
#endif

	static bool __fastcall disableInterrupts(bool bDisable);

	static bool disableAsyncGC(bool bDisable);
	static void OnCompact();
	static void CompactVirtualObject(OTE*);
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

	static void __fastcall activatePrimitiveMethod(CompiledMethod* methodPointer, _PrimitiveFailureCode failureCode);

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

	static int interpreterExceptionFilter(const LPEXCEPTION_POINTERS info);
	static int memoryExceptionFilter(const LPEXCEPTION_POINTERS pExInfo);
	static int callbackTerminationFilter(const LPEXCEPTION_POINTERS info, Process* callbackProcess, Oop prevCallbackContext);

	static void recoverFromFault(const LPEXCEPTION_POINTERS pExRec);
	static bool saveContextAfterFault(const LPEXCEPTION_POINTERS info);
	static void sendExceptionInterrupt(VMInterrupts oopInterrupt, const LPEXCEPTION_POINTERS pExInfo);

	static void wakePendingCallbacks();
	static size_t countPendingCallbacks();

	static void sendSelectorArgumentCount(SymbolOTE* selector, argcount_t count);
	static void sendSelectorToClass(BehaviorOTE* classPointer, argcount_t argCount);
	static void sendVMInterrupt(ProcessOTE* processPointer, VMInterrupts nInterrupt, Oop argPointer);

	static BOOL __stdcall MsgSendPoll();
	static BOOL	__stdcall BytecodePoll();
	static BOOL sampleInput();
	static bool __stdcall IsUserBreakRequested();
	
	static void __fastcall executeNewMethod(MethodOTE* methodOTE, argcount_t argCount);
	static void __fastcall returnValueTo(Oop resultPointer, Oop contextPointer);
	static void __fastcall returnValueToCaller(Oop resultPointer, Oop contextPointer);
	static void __fastcall nonLocalReturnValueTo(Oop resultPointer, Oop contextPointer);
	static void __fastcall invalidReturn(Oop resultPointer);

	static BlockOTE* __stdcall blockCopy(BlockCopyExtension ext);

public:
	static void __fastcall sendVMInterrupt(VMInterrupts nInterrupt, Oop argPointer);
	static int OutOfMemory(const LPEXCEPTION_POINTERS pExInfo);
	static int __cdecl IEEEFPHandler(_FPIEEE_RECORD* pIEEEFPException);
	static void sendZeroDivideInterrupt(const LPEXCEPTION_POINTERS pExInfo);


	static void basicQueueForFinalization(OTE* ote);
	static void queueForFinalization(OTE* ote, SmallUinteger);
	static void queueForBereavementOf(OTE* ote, Oop argPointer);
	// Number of entries in the bereavement queue per object (one for the object, the other the loss count)
	static constexpr size_t OopsPerBereavementQEntry = 2;

	// Queue a process interrupt to be executed at the earliest opportunity
	static void __stdcall queueInterrupt(ProcessOTE* processPointer, VMInterrupts nInterrupt, Oop argPointer);
	static void __stdcall queueInterrupt(VMInterrupts nInterrupt, Oop argPointer);

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

	static void CALLBACK TimeProc(UINT uID, UINT uMsg, DWORD_PTR dwUser, DWORD_PTR dw1, DWORD_PTR dw2);

	// Signal a semaphore; synchronously if no interrupts are pending, else asynchronously.
	// May initiate a Process switch, but does not perform the actual context switch
	// This one is used when in sync with byte code execution
	static void signalSemaphore(SemaphoreOTE* semaphorePointer);

public:
	static void GrabAsyncProtect();
	static void RelinquishAsyncProtect();
	static void NotifyAsyncPending();
	static bool QueueAPC(PAPCFUNC pfnAPC, ULONG_PTR closure);
	static void BeginAPC();
	static BOOL SetWakeupEvent();
	static void NotifyOTOverflow();

	#undef Yield
	static void Yield();
	static BOOL FastYield();
	static void sleep(ProcessOTE* aProcess);
	static _PrimitiveFailureCode SuspendProcess(ProcessOTE* oteProc);
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
	static HRESULT SetSampleTimer(SmallInteger newInterval);
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

	static Oop* primitiveFailure(_PrimitiveFailureCode failureCode);

private:
	// Answer whether an exception occurred in a primitive
	static bool isInPrimitive(const LPEXCEPTION_POINTERS pExInfo);

public:
	typedef argcount_t primargcount_t;

	typedef Oop* (__fastcall *PrimitiveFp)(Oop* const sp, primargcount_t argCount);

	static Oop* __fastcall unusedPrimitive(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveActivateMethod(Oop* const sp, primargcount_t argCount);

	template<int Index> static Oop * __fastcall primitiveReturnConst(Oop * const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveReturnSelf(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveReturnLiteralZero(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveReturnInstVar(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSetInstVar(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveReturnStaticZero(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSetMutableInstVar(Oop* const sp, primargcount_t argCount);

	// SmallInteger Arithmetic
	static Oop* __fastcall primitiveAdd(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSubtract(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveMultiply(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveDivide(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveDiv(Oop* const sp, primargcount_t argCount);		// Still in SmallIntPrim.asm
	static Oop* __fastcall primitiveMod(Oop* const sp, primargcount_t argCount);		// Still in SmallIntPrim.asm
	static Oop* __fastcall primitiveQuo(Oop* const sp, primargcount_t argCount);		// Still in SmallIntPrim.asm

	// SmallInteger relational ops
	template <typename Cmp, bool Lt> static Oop* __fastcall primitiveIntegerCmp(Oop* const sp, primargcount_t);
	static Oop* __fastcall primitiveEqual(Oop* const sp, primargcount_t argCount);

	// SmallInteger bit manipulation
	
	template <typename Op> static Oop* __fastcall primitiveIntegerOp(Oop* const sp, primargcount_t);

	static Oop* __fastcall primitiveBitShift(Oop* const sp, primargcount_t argCount);		// Still in SmallIntPrim.asm
	static Oop* __fastcall primitiveHighBit(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveLowBit(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveAnyMask(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveAllMask(Oop* const sp, primargcount_t argCount);
	
	static Oop* __fastcall primitiveSmallIntegerAt(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSmallIntegerPrintString(Oop* const sp, primargcount_t argCount);

	// LargeInteger Arithmetic - mostly templated
	template<class Op, class OpSingle> static Oop * __fastcall primitiveLargeIntegerOpZ(Oop * const sp, primargcount_t);
	template<class Op, class OpSingle> static Oop * __fastcall primitiveLargeIntegerOpR(Oop * const sp, primargcount_t);
	static Oop* __fastcall primitiveLargeIntegerDivide(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveLargeIntegerQuo(Oop* const sp, primargcount_t argCount);

	// LargeInteger relational ops - mostly templated
	template<bool Lt, bool Eq> static Oop * __fastcall primitiveLargeIntegerCmp(Oop * const sp, primargcount_t);
	static Oop* __fastcall primitiveLargeIntegerEqual(Oop* const sp, primargcount_t argCount);

	// LargeInteger bit manipulation
	static Oop* __fastcall primitiveLargeIntegerBitInvert(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveLargeIntegerBitShift(Oop* const sp, primargcount_t argCount);
	static Oop * __fastcall primitiveLargeIntegerHighBit(Oop * const sp, primargcount_t);

	// LargeInteger miscellaneous
	template<typename Op> static Oop * __fastcall primitiveLargeIntegerUnaryOp(Oop * const sp, primargcount_t);
	static Oop* __fastcall primitiveLargeIntegerAsFloat(Oop* const sp, primargcount_t argCount);

	// Float primitives
	static Oop* __fastcall primitiveAsFloat(Oop* const sp, primargcount_t argCount);
	template <typename Pred> static Oop* __fastcall primitiveFloatCompare(Oop* const sp, primargcount_t);
	template <typename Op> static Oop* __fastcall primitiveFloatBinaryOp(Oop* const sp, primargcount_t);
	template <typename Op> static Oop* __fastcall primitiveFloatUnaryOp(Oop* const sp, primargcount_t);

	static Oop* __fastcall primitiveFloatTimesTwoPower(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveFloatExponent(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveFloatClassify(Oop* const sp, primargcount_t argCount);

	template <typename Op> static Oop* __fastcall primitiveFloatTruncationOp(Oop* const sp, primargcount_t);
	
	static Oop* __fastcall primitiveSize(Oop* const sp, primargcount_t argCount);
   	
	// Object Indexing Primitives
	static Oop* __fastcall primitiveBasicAt(Oop* const sp, const primargcount_t argCount);
	static Oop* __fastcall primitiveBasicAtPut(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveInstVarAt(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveInstVarAtPut(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveNextIndexOfFromTo(Oop* const sp, primargcount_t argCount);

	///////////////////////////////////////////////////////////////////////////
	// External Buffer access primitives
	
	static Oop* __fastcall primitiveStructureIsNull(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveBytesIsNull(Oop* const sp, primargcount_t argCount);

	template<typename T, typename P> static Oop * __fastcall primitiveIndirectIntegerAtOffset(Oop * const sp, primargcount_t);
	template<typename T, typename P> static Oop * __fastcall primitiveIntegerAtOffset(Oop * const sp, primargcount_t);
	template<typename T, SmallInteger MinVal, SmallInteger MaxVal> static Oop * __fastcall primitiveAtOffsetPutInteger(Oop * const sp, primargcount_t);
	template<typename T, SmallInteger MinVal, SmallInteger MaxVal> static Oop * __fastcall primitiveIndirectAtOffsetPutInteger(Oop * const sp, primargcount_t);

	// These have specialised implementations as they accept other than just SmallInteger values to 'put'
	static Oop* __fastcall primitiveUint32AtPut(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveIndirectUint32AtPut(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveInt32AtPut(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveIndirectInt32AtPut(Oop* const sp, primargcount_t argCount);

	// Floating point number accessors
	template<typename T> static Oop * __fastcall primitiveFloatAtOffset(Oop * const sp, primargcount_t);
	template<typename T> static Oop * __fastcall primitiveFloatAtOffsetPut(Oop * const sp, primargcount_t);

	static Oop* __fastcall primitiveLongDoubleAt(Oop* const sp, primargcount_t argCount);

	// Get address of contents of a byte object
	static Oop* __fastcall primitiveAddressOf(Oop* const sp, primargcount_t argCount);

	static void PushCharacter(Oop* const sp, char32_t codePoint);

	static Oop* primitiveNewCharacter(Oop * const sp, primargcount_t);

	///////////////////////////////////////////////////////////////////////////
	// String Class Primitives
	static Oop* __fastcall primitiveStringAt(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveStringAtPut(Oop* const sp, primargcount_t argCount);

	// Helper for memory moves
	static void memmove(uint8_t* dst, const uint8_t* src, size_t count);
	static Oop* __fastcall primitiveReplaceBytes(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveIndirectReplaceBytes(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveReplacePointers(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveStringConcatenate(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveCopyFromTo(Oop* const sp, primargcount_t argCount);

	static Oop* __fastcall primitiveHashBytes(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveStringSearch(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveStringNextIndexOfFromTo(Oop* const sp, primargcount_t argCount);

	// String comparisons - mostly templated
	template<class OpA, class OpW> static Oop * __fastcall primitiveStringComparison(Oop * const sp, primargcount_t);
	static Oop* __fastcall primitiveStringEqual(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveBytesEqual(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveBeginsWith(Oop* const sp, primargcount_t);

	// String conversions
	static Oop* __fastcall primitiveStringAsUtf32String(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveStringAsUtf16String(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveStringAsUtf8String(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveStringAsByteString(Oop* const sp, primargcount_t argCount);

	// Stream Primitives
	static Oop* __fastcall primitiveNext(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveBasicNext(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveNextInt32(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveNextPut(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveBasicNextPut(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveNextPutAll(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveAtEnd(Oop* const sp, primargcount_t argCount);

	// Storage Management Primitives
	static Oop* __fastcall primitiveObjectCount(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveNew(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveNewWithArg(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveNewPinned(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveNewInitializedObject(Oop* sp, primargcount_t argCount);
	static Oop* __fastcall primitiveNewFromStack(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveNewVirtual(Oop* const sp, primargcount_t argCount);

	// Object mutation
	static Oop* __fastcall primitiveChangeBehavior(Oop* const sp, primargcount_t argCount);
	static boolean hasCompatibleShape(OTE* oteReceiver, ST::Behavior* argClass);

	static Oop* __fastcall primitiveResize(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveBecome(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveOneWayBecome(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveGetImmutable(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSetImmutable(Oop* const sp, primargcount_t argCount);

	// Object Memory primitives
	static Oop* __fastcall primitiveBasicIdentityHash(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveIdentityHash(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveHashMultiply(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveAllReferences(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveAllInstances(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveAllSubinstances(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveInstanceCounts(Oop* const sp, primargcount_t argCount);
	
	// Control Primitives
	static Oop* __fastcall primitiveValue(Oop* const sp, primargcount_t argumentCount);
	static Oop* __fastcall primitiveValueWithArgs(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveValueWithArgsThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitivePerform(Oop* const sp, primargcount_t argumentCount);
	static Oop* __fastcall primitivePerformThunk(Oop* const sp, primargcount_t argumentCount);
	static Oop* __fastcall primitivePerformWithArgs(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitivePerformWithArgsThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitivePerformMethod(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitivePerformMethodThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveReturn(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveReturnFromCallback(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveReturnFromInterrupt(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveValueOnUnwind(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveUnwindCallback(Oop* const sp, primargcount_t argCount);

	// Process primitives
	static Oop* __fastcall primitiveSignal(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSignalThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveWait(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveWaitThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveResume(Oop* const sp, primargcount_t argumentCount);
	static Oop* __fastcall primitiveResumeThunk(Oop* const sp, primargcount_t argumentCount);
	static Oop* __fastcall primitiveYield(Oop* const sp, primargcount_t argumentCount);
	static Oop* __fastcall primitiveYieldThunk(Oop* const sp, primargcount_t argumentCount);
	static Oop* __fastcall primitiveSingleStep(Oop* const sp, primargcount_t argumentCount);
	static Oop* __fastcall primitiveSingleStepThunk(Oop* const sp, primargcount_t argumentCount);
	static Oop* __fastcall primitiveSuspend(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSuspendThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSetSignals(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSetSignalsThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveInputSemaphore(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSampleInterval(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveProcessPriority(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveProcessPriorityThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveTerminateProcess(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveTerminateProcessThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveEnableInterrupts(Oop* const sp, primargcount_t argCount);
	// Specialized primitive for storing into process stacks. Allows for Zct
	static Oop* __fastcall primitiveStackAtPut(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveIndexOfSP(Oop* const sp, primargcount_t argCount);

	// Timer primitives
	static Oop* __fastcall primitiveSignalAtTick(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSignalAtTickThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveMicrosecondClockValue(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveMillisecondClockValue(Oop* const sp, primargcount_t argCount);

	// Input/Out Primitives
	static Oop* __fastcall primitiveSnapshot(Oop* const sp, primargcount_t argCount);

	// Dispatcher Primitives
	static Oop* __fastcall primitiveHookWindowCreate(Oop* const sp, primargcount_t argCount);

	// System Primitives
	static Oop* __fastcall primitiveIdentical(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveClass(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveIsKindOf(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveIsSuperclassOf(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveCoreLeft(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveCoreLeftThunk(Oop* const sp, primargcount_t argCount);
	static void __fastcall primitiveQuit(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveOopsLeft(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveOopsLeftThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveInheritsFrom(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveShallowCopy(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveSetSpecialBehavior(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveQueueInterrupt(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveExtraInstanceSpec(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveDeQBereavement(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveDeQForFinalize(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveLookupMethod(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveFlushCache(Oop* const sp, primargcount_t argCount);

	// Extension system primitives
	static Oop* __fastcall primitiveDLL32Call(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveVirtualCall(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveAsyncDLL32Call(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveAsyncDLL32CallThunk(Oop* const sp, primargcount_t argCount);

	static Oop* __fastcall primitivePerformWithArgsAt(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitivePerformWithArgsAtThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveValueWithArgsAt(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveValueWithArgsAtThunk(Oop* const sp, primargcount_t argCount);

	static Oop* __fastcall primitiveUnwindInterrupt(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveUnwindInterruptThunk(Oop* const sp, primargcount_t argCount);
	static Oop* __fastcall primitiveVariantValue(Oop* const sp, primargcount_t argCount);

private:

	static BOOL __stdcall callExternalFunction(FARPROC pProc, argcount_t argCount, DolphinX::CallDescriptor* argTypes, BOOL isVirtual);
	static FARPROC GetDllCallProcAddress(DolphinX::ExternalMethodDescriptor* descriptor, LibraryOTE* oteReceiver);

	// Pushs object on stack instantiated from address, and returns size of object pushed
	static void pushArgsAt(CallbackDescriptor* descriptor, argcount_t argCount, uint8_t* lpParms);
	static argcount_t pushArgsAt(const ExternalDescriptor* descriptor, uint8_t* lpParms);

	static void failTrace();

public:
	#ifdef _DEBUG
		// Execution trace
		static int executionTrace;
		static void __fastcall debugExecTrace(uint8_t* ip, Oop* sp);
		static void __fastcall debugMethodActivated(Oop* sp);
		static void __fastcall debugReturnToMethod(Oop* sp);
		static void checkStack(Oop* sp);
		static void DumpMethodCacheStats();
		static void DumpCacheStats();
	#endif

public:
	// Special Selector Table
	static constexpr size_t NumSpecialSelectors = 32;

private:
	// Method cache is a hash table with overwrite on collision
	// If changing method cache size, then must also modify METHODCACHEWORDS in ISTASM.INC!
	static constexpr size_t MethodCacheSize = 4096;
	static MethodCacheEntry methodCache[MethodCacheSize];

	static void flushCaches();
	static void initializeCaches();
	
	static constexpr size_t FixedVmReferences = 0;
	static constexpr size_t SignalQueueGrowth=32, SignalQueueSize=64;
	static constexpr size_t InterruptQueueGrowth=8, InterruptQueueSize=16;
	static constexpr size_t FinalizeQueueSize = 128;
	static constexpr size_t FinalizeQueueGrowth = 128;
	static constexpr size_t BereavementQueueSize = 64;
	static constexpr size_t BereavementQueueGrowth=64;

private:
	// Critical section to protect the async queues
	static CRITICAL_SECTION m_csAsyncProtect;

public:
	// Pools
	enum class Pools { Dwords, Floats, Contexts, Blocks };
	static constexpr size_t NumOtePools = static_cast<size_t>(Pools::Blocks) + 1;
	static ObjectMemory::OTEPool m_otePools[NumOtePools];
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
	static unsigned m_numberOfProcessors;			// Logical cores

	static OTE* m_oteUnderConstruction;				// Window currently under construction

	// Interpreter referenced objects (roots as may have no other refs)
	static OTE** m_roots[];

	// Process Switching - these are used with InterlockedExchange, so must be longs (not uint8_t sized bool)
	static SHAREDLONG	m_bAsyncPending;			// Set when interrupts or async signals are pending.
	static SHAREDLONG	m_bAsyncPendingIOff;		// Ditto, used to buffer when interrupts are off
	static SHAREDLONG*	m_pbAsyncPending; 
	static SHAREDLONG	m_nAPCsPending;				// Count of APCs queued for the interpreter thread

	static BOOL		m_bStepping;					// Flag to indicate whether to break when input sampler drops to 0
	static bool		m_bInterruptsDisabled;			// Flag to indicate whether accepting interrupts or not
	static bool		m_bAsyncGCDisabled;			
	static bool		m_bShutDown;					// Is the interpreter shutting down?

	static size_t	m_nCallbacksPending;			// Number of failed callback exits pending
	static size_t	m_nOTOverflows;

	// Circular queues to hold the semaphores and interrupts, etc
	static OopQueue<SemaphoreOTE*>	m_qAsyncSignals;
	static OopQueue<Oop>			m_qInterrupts;
	static OopQueue<OTE*>			m_qForFinalize;		// Queue of objects requiring finalization
	static OopQueue<Oop>			m_qBereavements;	// Queue of weakly referencing objects which have suffered bereavements

	// Win32 input queue management
	static SHAREDLONG	m_nInputPollCounter;			// When this goes to zero, its time to poll for input
	static LONG			m_nInputPollInterval;			// Poll counter reset to this after each message queue poll
	static DWORD		m_dwQueueStatusMask;			// Input flags passed to GetQueueStatus to poll for arriving input events

public:
	static codepage_t	m_ansiCodePage;
	static WCHAR		m_unicodeReplacementChar;
	static char			m_ansiReplacementChar;
	static WCHAR		m_ansiToUnicodeCharMap[256];
	static CHAR			m_unicodeToAnsiCharMap[65536];


public:
	#if defined(_DEBUG)
		// List of VM referenced objects (generic mechanism for avoiding GC problems with
		// objects ref'd only from the VM)
		static Oop*	m_pVMRefs;
		static SmallInteger	m_nFreeVMRef;
		static SmallInteger	m_nMaxVMRefs;				// Current size of VM References array

		static constexpr size_t VMREFSINITIAL = 16;
		static constexpr size_t VMREFSGROWTH = 64;
	#endif
};

extern "C" PRIMTABLEDECL Interpreter::PrimitiveFp primitivesTable[256];

std::wostream& operator<<(std::wostream& stream, const CONTEXT* pCtx);

///////////////////////////////////

#include "Interprt.inl"
