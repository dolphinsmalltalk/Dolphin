/*
============
Interprt.cpp
============
Implementation of Smalltalk interpreter
*/

#include "Ist.h"
#include <float.h>
//#include "rc_vm.h"

#ifndef _DEBUG
	//#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#pragma code_seg(INTERPMISC_SEG)

#include "Interprt.h"
#include "InterprtProc.inl"
#include <stdarg.h>
#include <process.h>
#include "thrdcall.h"
#include "VMExcept.h"
#include "regkey.h"

// Smalltalk classes
#include "STProcess.h"
#include "STArray.h"
#include "STString.h"
#include "STContext.h"
#include "STMethod.h"			// To determine if in primitive when fault occurs
#include "STByteArray.h"
#include "STBlockClosure.h"

#ifdef _DEBUG
	// Execution trace
	BOOL Interpreter::executionTrace = 0;
	//extern unsigned contextDepth;
	static unsigned nTotalBlocksAllocated = 0;
#endif
#define VMWNDCLASS "_VMWnd"

InterpreterRegisters16 Interpreter::m_registers = {0, 0, 0, 0, 0, 0, 0, 0};

SymbolOTE*		Interpreter::m_oopMessageSelector;

// The only Oops ref'd by the Interpreter which are not stored in the global pointers registry (VMPointers)
ProcessOTE* Interpreter::m_oteNewProcess;
POTE Interpreter::m_oteUnderConstruction;

// Input Polling is initially off (negative interval) so that it doesn't interfere if not wanted
SHAREDLONG Interpreter::m_nInputPollCounter;	// When this goes to zero, its time to poll for input
LONG Interpreter::m_nInputPollInterval;		// Poll counter reset to this after each message queue poll

SHAREDLONG Interpreter::m_bAsyncPending = FALSE;
SHAREDLONG Interpreter::m_nAPCsPending = 0;

SHAREDLONG* Interpreter::m_pbAsyncPending = &m_bAsyncPending;
SHAREDLONG Interpreter::m_bAsyncPendingIOff = FALSE;

// Context related registers
ProcessorScheduler* Interpreter::m_pProcessor;

// Number of failed callback exits which have occurred since last successful callback
// These get signalled when a successful callback occurs to try again
unsigned Interpreter::m_nCallbacksPending;

unsigned Interpreter::m_nOTOverflows;

// Pools of reusable objects (just linked list of previously allocated and free'd objects of
// correct size and class)
ObjectMemory::OTEPool Interpreter::m_otePools[Interpreter::NUMOTEPOOLS];

POTE* Interpreter::m_roots[] = {
	reinterpret_cast<POTE*>(&m_oteNewProcess),
	reinterpret_cast<POTE*>(&m_oteTimerSem),
	&m_oteUnderConstruction,
	0
};

__declspec(align(16))
Interpreter::MethodCacheEntry Interpreter::methodCache[MethodCacheSize];

__declspec(align(16))
Interpreter::AtCacheEntry Interpreter::AtCache[AtCacheEntries];
__declspec(align(16))
Interpreter::AtCacheEntry Interpreter::AtPutCache[AtCacheEntries];

DWORD Interpreter::m_dwThreadId;
HANDLE Interpreter::m_hThread;

BOOL Interpreter::m_bStepping;

bool Interpreter::m_bInterruptsDisabled;
bool Interpreter::m_bAsyncGCDisabled;
bool Interpreter::m_bShutDown;

ATOM Interpreter::m_atomVMWndClass;
HWND Interpreter::m_hWndVM;

//==========
//Initialise
//==========
#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#pragma code_seg(INIT_SEG)
HRESULT Interpreter::initialize(const char* szFileName, LPVOID imageData, UINT imageSize, bool isDevSys)
{
	HRESULT hr = initializeBeforeLoad();
	if (FAILED(hr))
		return hr;

	// Load in the basic image. We do this here to avoid allocating memory
	// in the static constructor of the ObjectMemory class.
	//

#ifdef OAD
	DWORD timeStart = timeGetTime();
#endif
	hr = ObjectMemory::LoadImage(szFileName, imageData, imageSize, isDevSys);
	if (FAILED(hr))
		return hr;
#ifdef OAD
	DWORD timeEnd = timeGetTime();
	TRACESTREAM << "Time to load image: " << (timeEnd - timeStart) << " mS" << endl;
#endif

	ObjectMemory::HeapCompact();
	return initializeAfterLoad();
}

#pragma code_seg(INIT_SEG)
HRESULT Interpreter::initializeBeforeLoad()
{
	m_bShutDown = m_bInterruptsDisabled = m_bAsyncGCDisabled = m_bStepping = false;
	m_nOTOverflows = 0;

	InitializeCriticalSection(&m_csAsyncProtect);
	m_dwThreadId = ::GetCurrentThreadId();
	HANDLE hProc = GetCurrentProcess();
	VERIFY(::DuplicateHandle(hProc, GetCurrentThread(), hProc, &m_hThread, 0, FALSE, DUPLICATE_SAME_ACCESS));

	WNDCLASS wndClass;
	wndClass.style = 0;
	wndClass.lpfnWndProc = VMWndProc;
	wndClass.cbClsExtra = 0;
	wndClass.cbWndExtra = 0;
	wndClass.hInstance = GetModuleContaining(VMWndProc);
	wndClass.hIcon = NULL;
	wndClass.hCursor = NULL;
	wndClass.hbrBackground = (HBRUSH)COLOR_WINDOW;
	wndClass.lpszMenuName = NULL;
	wndClass.lpszClassName = VMWNDCLASS;
	m_atomVMWndClass = RegisterClass(&wndClass);

	m_hWndVM = CreateWindow(VMWNDCLASS, "", WS_CHILD, 0, 0, 0, 0, HWND_MESSAGE, NULL, wndClass.hInstance, NULL);
	if (m_hWndVM == NULL)	// early OSs did not support message-only windows
	{
		m_hWndVM = CreateWindow(VMWNDCLASS, "", 0, 0, 0, 0, 0, NULL, NULL, wndClass.hInstance, NULL);
	}
	if (m_hWndVM == NULL)
	{
		LPSTR errText = GetLastErrorText();
		ReportError(IDP_FAILTOCREATEVMWND, ::GetLastError(), errText);
		::LocalFree(errText);
	}

	OverlappedCall::Initialize();

	// ObjectMemory is an entirely static class, so to avoid an instance
	return ObjectMemory::Initialize();
}

#pragma code_seg(INIT_SEG)
HRESULT Interpreter::initializeAfterLoad()
{
	// This must now be done after load so Pointers.Nil available
	HRESULT hr = initializeTimer();
	if (FAILED(hr))
		return hr;

	m_oteNewProcess = reinterpret_cast<ProcessOTE*>(Pointers.Nil);
    m_oteUnderConstruction = Pointers.Nil;

	hr = ObjectMemory::InitializeImage();
	if (FAILED(hr))
		return hr;

	//CreateVMReferences();
	initializeVMReferences();

	#if defined(_DEBUG)
		//ObjectMemory::checkReferences();	// If this fails, the saved image has a ref. count problem
	#endif

	initializeCaches();

	m_registers.m_pActiveFrame = firstFrame();
	m_registers.FetchContextRegisters();

#ifdef _DEBUG
	TRACESTREAM << "Startup process: " << actualActiveProcessPointer() << endl;
#endif

	// Populate the ZCT with zero count objects in the startup process' stack
	ObjectMemory::PopulateZct();

	// Set the callback pending count correctly to take account of any processes that were waiting
	// on the pendingReturns Semaphore when the image was saved.
	m_nCallbacksPending = countPendingCallbacks();

	hr = InitializeSampler();
	if (FAILED(hr))
		return hr;

	// Initialize the image. This must be performed after the above
	// creation of the active context.

	::SetLastError(0);

	return initializeImage();
}

#pragma code_seg(TERM_SEG)
void Interpreter::ShutDown()
{
	_ASSERTE(!m_bShutDown);
	m_bShutDown = true;
	// Nulling out the handle means that any further attempts to queue APCs, etc, will fail
	HANDLE hThread = LPVOID(::OAInterlockedExchange(LPLONG(&m_hThread), 0));

	TerminateSampler();

	GuiShutdown();

	if (m_hWndVM)
	{
		DestroyWindow(m_hWndVM);
		m_hWndVM = NULL;
	}
	if (m_atomVMWndClass)
	{
		UnregisterClass(VMWNDCLASS, GetModuleContaining(initializeBeforeLoad));
		m_atomVMWndClass = NULL;
	}
	
	terminateTimer();
	OverlappedCall::Uninitialize();

	// Close the duplicated main thread handle
	::CloseHandle(hThread);
	::DeleteCriticalSection(&m_csAsyncProtect);

	ObjectMemory::Terminate();
}

#pragma code_seg(INIT_SEG)
inline void Interpreter::initializeCaches()
{
	// If either of these two assertions fails, update the method cache size
	// in ISTASM.INC (METHODCACHEDWORDS), change the constants, and rebuild
	// You may also need to change
	ASSERT(sizeof(OTE) == 16);
	ASSERT(sizeof(MethodCacheEntry) == sizeof(OTE));
	ASSERT(MethodCacheSize == 1024);

	ASSERT(sizeof(AtCacheEntry) == sizeof(OTE));

	flushCaches();
}

#ifdef NDEBUG
	#pragma auto_inline(on)
#endif

///////////////////////////////////

/*OTE* NewLinkedList()
{
	return ObjectMemory::instantiateClassWithPointers(Pointers.ClassLinkedList);
}*/

#ifdef _DEBUG
	#pragma code_seg(DEBUG_SEG)

	static MWORD ResizeProcInContext(InterpreterRegisters& reg)
	{
		ProcessOTE* oteProc = reg.m_oteActiveProcess;
		MWORD size = oteProc->getSize();
		reg.ResizeProcess();
		if (size != oteProc->getSize() && Interpreter::executionTrace)
		{
			tracelock lock(TRACESTREAM);
			TRACESTREAM << "Check Refs: Resized proc " << oteProc << " from " 
				<< dec << size << " to " << oteProc->getSize() << endl;
		}
		return size;
	}

	// Check references without upsetting the current active process size (otherwise
	// this may mask bugs in the release version)
	void Interpreter::checkReferences(InterpreterRegisters& reg)
	{
		HARDASSERT(ObjectMemory::isKindOf(m_registers.m_oteActiveProcess, Pointers.ClassProcess));
		MWORD oldProcSize = ResizeProcInContext(reg);
		if (reg.m_pActiveProcess != m_registers.m_pActiveProcess)
		{
			// Resize active process as well as the one in the context passed
			MWORD oldActiveProcSize = ResizeProcInContext(m_registers);
			ObjectMemory::checkReferences();
			m_registers.m_oteActiveProcess->setSize(oldActiveProcSize);
		}
		else
			ObjectMemory::checkReferences();
		reg.m_oteActiveProcess->setSize(oldProcSize);
	}
#endif

///////////////////////////////////////////////////////////////////////////////
// Terminate Smalltalk

#pragma code_seg(TERM_SEG)

void Interpreter::exitSmalltalk(int exitCode)
{
	#ifdef _DEBUG
	{
		extern void DumpPrimitiveCounts(bool);
		extern void DumpBytecodeCounts(bool);

		DumpPrimitiveCounts(false);
		DumpBytecodeCounts(false);
	}
	#endif

	DolphinExit(exitCode);
}


///////////////////////////////////////////////////////////////////////////////
// Main Interpreter entry point. Handles OTE overflows and Stack overflows,
// looping through GP/FP faults in primitives too.

#pragma code_seg(INTERP_SEG)

void Interpreter::interpret()
{
#pragma warning(push)
#pragma warning(disable:4127)
	while(true)
#pragma warning(pop)
	{
		// Using Win32 structured exception handling here NOT C++
		DWORD dwCode;
		__try 
		{ 
			_asm jmp byteCodeLoop
		}
		// I'd like to just test for IS_ERROR() here, but due to some macro nastiness
		// it GPFs in a release build
		__except ((dwCode=GetExceptionCode()) > SE_VMCALLBACKUNWIND 
					? interpreterExceptionFilter(GetExceptionInformation()) 
					: EXCEPTION_CONTINUE_SEARCH)
		{
			TRACE("interpret: Looping after exception %#x\n\r", dwCode);
		}
	}
	// We don't tend to get here as callback returns go to the enclosing exception handler
	ASSERT(FALSE);
}

//////////////////////////////////////////////////////////////////////////////////
// Save IP/SP down after a fault occurs
//
// Faults may either occur outside primitives, or in assembler primitives for which IP/SP
// have not been saved. IP is probably not so critical, since most faults result in unrecoverable
// errors, but if we don't save it down, then the picture in the debugger may be confusing.
// SP is critical, because if we don't save it down we are likely to get a crash attempting
// to produce the walkback. If the fault occurs in a primitive, then SP will already have been
// saved.
// Attempts to saved down IP/SP from CPP primitives will not often be helpful
// as these often use EDI/ESI, but I rarely use it in the assembler
// prims, so it should have the correct value in the context record
//
// CPP prims should save down IP if there is any possibility of them generating
// a trappable fault
//
#pragma code_seg(INTERPMISC_SEG)
void Interpreter::saveContextAfterFault(LPEXCEPTION_POINTERS info)
{
	BYTE* ip = reinterpret_cast<BYTE*>(info->ContextRecord->Edi);
	Oop byteCodes = m_registers.m_pMethod->m_byteCodes;
	BYTE* pBytes = ObjectMemory::ByteAddressOfObjectContents(byteCodes);
	int numByteCodes = ObjectMemoryIsIntegerObject(byteCodes) ?
							sizeof(MWORD) : reinterpret_cast<BytesOTE*>(byteCodes)->bytesSize();
	if (ip >= pBytes && ip < pBytes + numByteCodes)
		m_registers.m_instructionPointer = ip;
	Oop* sp = reinterpret_cast<Oop*>(info->ContextRecord->Esi);
	Process* pProc = actualActiveProcess();
	if (sp > reinterpret_cast<Oop*>(pProc))
	{
		VirtualObject* pVObj = reinterpret_cast<VirtualObject*>(pProc);
		VirtualObjectHeader* pBase = pVObj->getHeader();
		//unsigned maxByteSize = pBase->getMaxAllocation();
		unsigned cbCurrent = pBase->getCurrentAllocation();
		if (sp < reinterpret_cast<Oop*>(reinterpret_cast<BYTE*>(pBase) + cbCurrent))
			m_registers.m_stackPointer = sp;
	}
}

#pragma code_seg(INTERPMISC_SEG)
// Answer whether the interpreter is currently executing a primitive. We determine this
// by testing to see whether the new method is not the same as the active method (primitives
// do not activate until they fail). We must also ensure that the oop is still a method
// 
BOOL Interpreter::isInPrimitive()
{
	if (!m_registers.m_oopNewMethod->isFree())
	{
		// HARDASSERT(ObjectMemory::isKindOf(m_oopNewMethod, Pointers.ClassCompiledMethod));
		CompiledMethod* newMethod = m_registers.m_oopNewMethod->m_location;
		if (newMethod == m_registers.m_pMethod)
			return FALSE;
		STMethodHeader header = newMethod->m_header;
		// If really a primitive, then flags in header will be 0
		return header.primitiveIndex != PRIMITIVE_ACTIVATE_METHOD;
	}
	else
		return FALSE;
}

#pragma code_seg(DEBUG_SEG)
void Interpreter::queueGPF(Oop oopInterrupt, LPEXCEPTION_POINTERS pExInfo)
{
	saveContextAfterFault(pExInfo);
	ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(ObjectMemory::newUninitializedByteObject(Pointers.ClassByteArray, sizeof(EXCEPTION_RECORD)));
	ByteArray *bytes = oteBytes->m_location;
	memcpy(bytes->m_elements, pExInfo->ExceptionRecord, sizeof(EXCEPTION_RECORD));
	queueInterrupt(oopInterrupt, Oop(oteBytes));
	m_bStepping = false;						// We do not want to break now

	ResetInputPollCounter();
}

#pragma code_seg(DEBUG_SEG)
static BOOL WantGPFTrap()
{
	CRegKey rk;
	return OpenDolphinKey(rk, "DisableGPFTrap") != ERROR_SUCCESS;
}

#pragma code_seg(DEBUG_SEG)
static BOOL PleaseTrapGPFs()
{
	static BOOL TrapEm = -1;
	if (TrapEm == -1)
		TrapEm = WantGPFTrap();
	return TrapEm;
}

#pragma code_seg(INTERPMISC_SEG)
// Exception filter to handle continuable win32 exceptions for the interpreter, may return
// EXCEPTION_EXECUTE_HANDLER, in which case the interpreter loops - this is how GP faults
// and FP faults in primitives are handled.
int Interpreter::interpreterExceptionFilter(LPEXCEPTION_POINTERS pExInfo)
{
	EXCEPTION_RECORD* pExRec = pExInfo->ExceptionRecord;
	if (pExRec->ExceptionFlags == EXCEPTION_NONCONTINUABLE)
		return EXCEPTION_CONTINUE_SEARCH;

	DWORD exceptionCode = pExRec->ExceptionCode;

	// Non-errors are supposed to have been filtered out before we get here
	// if they haven't it won't be a disaster, but it won't be as efficient
	// as it might be, as we'll end up doing a lot of work for the VM
	// callback exits.
	ASSERT(exceptionCode > SE_VMCALLBACKUNWIND);

	int action = EXCEPTION_CONTINUE_SEARCH;
	switch(exceptionCode)
	{
		case EXCEPTION_ACCESS_VIOLATION:
#if !defined(NO_GPF_TRAP)
			action = memoryExceptionFilter(pExRec);

			if (action == EXCEPTION_CONTINUE_SEARCH)
			{
				void* pExceptionAddr = reinterpret_cast<void*>(pExRec->ExceptionInformation[1]);
				bool bConstWrite = pExRec->ExceptionInformation[0] != 0 &&
									ObjectMemory::IsConstObj(pExceptionAddr);

				if (bConstWrite)
				{
					queueGPF(VMI_CONSTWRITE, pExInfo);
					if (isInPrimitive())
					{
						CompiledMethod* primMethod = m_registers.m_oopNewMethod->m_location;
						activateNewMethod(primMethod);
					}
					action = EXCEPTION_EXECUTE_HANDLER;
				}
				else if (isInPrimitive() && PleaseTrapGPFs())
				{
					queueGPF(VMI_ACCESSVIOLATION, pExInfo);
					CompiledMethod* primMethod = m_registers.m_oopNewMethod->m_location;
					activateNewMethod(primMethod);
					{
						tracelock lock(TRACESTREAM);
						TRACESTREAM << "GP Fault in primitive " << m_registers.m_oopNewMethod << endl;
					}
					action = EXCEPTION_EXECUTE_HANDLER;
				}
				// else
				//		continue search for next handler, if any
			}
#endif
			break;

		case STATUS_NO_MEMORY:
			if (PleaseTrapGPFs())
			{
				queueGPF(VMI_NOMEMORY, pExInfo);
				if (isInPrimitive())
					activateNewMethod(m_registers.m_oopNewMethod->m_location);
				#ifdef _DEBUG
				{
					tracelock lock(TRACESTREAM);
					TRACESTREAM << "Out of memory in " << m_registers.m_pMethod << endl;
				}
				#endif
				action = EXCEPTION_EXECUTE_HANDLER;
			}
			break;

		case EXCEPTION_INT_DIVIDE_BY_ZERO:
			saveContextAfterFault(pExInfo);
			queueInterrupt(VMI_ZERODIVIDE, Integer::NewSigned32(pExInfo->ContextRecord->Eax));
			if (isInPrimitive())
				activateNewMethod(m_registers.m_oopNewMethod->m_location);
			#ifdef _DEBUG
			{
				tracelock lock(TRACESTREAM);
				TRACESTREAM << "Divide by zero in " << m_registers.m_pMethod << endl;
			}
			#endif
			action = EXCEPTION_EXECUTE_HANDLER;
			break;

		case EXCEPTION_FLT_STACK_CHECK:
			if (PleaseTrapGPFs())
			{
				_asm fninit;
				queueGPF(VMI_FPSTACK, pExInfo);
				if (isInPrimitive())
					activateNewMethod(m_registers.m_oopNewMethod->m_location);
				#ifdef _DEBUG
				{
					tracelock lock(TRACESTREAM);
					TRACESTREAM << "FP stack under/overflow in " << m_registers.m_pMethod << endl;
				}
				#endif
				action = EXCEPTION_EXECUTE_HANDLER;
			}
			break;

		case EXCEPTION_INT_OVERFLOW:
		case EXCEPTION_PRIV_INSTRUCTION:
		case EXCEPTION_ILLEGAL_INSTRUCTION:
			if (isInPrimitive() && PleaseTrapGPFs())
			{
				queueGPF(VMI_EXCEPTION, pExInfo);
				activateNewMethod(m_registers.m_oopNewMethod->m_location);
				#ifdef _DEBUG
				{
					tracelock lock(TRACESTREAM);
					TRACESTREAM << "Unhandled exception " << exceptionCode << " in " << m_registers.m_pMethod << endl;
				}
				#endif
				action = EXCEPTION_EXECUTE_HANDLER;
			}
			break;

		case SE_VMCRTFAULT:
			if (isInPrimitive())
			{
				queueGPF(VMI_CRTFAULT, pExInfo);
				activateNewMethod(m_registers.m_oopNewMethod->m_location);
				action = EXCEPTION_EXECUTE_HANDLER;
			}
			break;
		case SE_VMEXIT:
			break;

		default:
			saveContextAfterFault(pExInfo);
			action = _fpieee_flt(exceptionCode, pExInfo, IEEEFPHandler);
			break;
	}

	return action;
}

#if !defined(NO_GPF_TRAP)

#pragma code_seg(INTERPMISC_SEG)
// Exception filter to handle continuable win32 exceptions caused by object table/process
// stack overflows
int Interpreter::memoryExceptionFilter(LPEXCEPTION_RECORD pExRec)
{
	// This "filter" is only designed to handle GPFs
	ASSERT(pExRec->ExceptionCode == EXCEPTION_ACCESS_VIOLATION);

	int action = EXCEPTION_CONTINUE_SEARCH;

	// Determine if the fault is a stack overflow, and if so try
	// growing the stack. If the stack has reached max. size, then
	// pass control to the exception handler
	DWORD dwAddress = pExRec->ExceptionInformation[1];

	VirtualObjectHeader* pBase = m_registers.activeProcess()->getHeader();
	MWORD activeProcAlloc = pBase->getCurrentAllocation();
	DWORD dwNext = DWORD(pBase) + activeProcAlloc;

	#ifdef OAD
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM << "Access violation: " << LPVOID(dwAddress) << ", stack top " << LPVOID(dwNext) << endl;
	}
	#endif

	if (dwAddress >= dwNext && dwAddress <= dwNext + sizeof(StackFrame))
	{
		#ifdef OAD
		{
			tracelock lock(TRACESTREAM);
			TRACESTREAM << "Stack overflow detected" << endl;
		}
		#endif

		if (::VirtualAlloc(LPVOID(dwNext), dwPageSize, MEM_COMMIT, PAGE_READWRITE))
		{
			// Note that the max allocation is actually one page greater since we adjust
			// the reserved space to accomodate an overrun page for detection
			if (activeProcAlloc >= pBase->getMaxAllocation())
			{
				TRACESTREAM << "Stack max'd out at " << hex << activeProcAlloc << endl;
				// Even though stack has hit max. we can still continue (to handle the error)
				// We'll just add an interrupt to the queue, which'll be detected later.
				// In order for this to continue to work, the stack must be shrunk at some
				// point after the stack overflow is handled
				queueInterrupt(VMI_STACKOVERFLOW, ObjectMemoryIntegerObjectOf(activeProcAlloc));
			}
			else
			{
				TRACE("Stack successfully grown to %u\n\r", pBase->getCurrentAllocation());
			}

			// Whether the stack has max'd out or not, we're going to continue executing
			// and detect the overflow interrupt synchronously (if it was signalled).
			// This avoids any synchronisation issues, and means that in general, we
			// don't have to code defensively where exceptions might be raised.
			action = EXCEPTION_CONTINUE_EXECUTION;

			// Flesh out the new stack page
			pBase->addPage();

			#ifdef _DEBUG
				// Let's see whether we got the rounding correct!
				MEMORY_BASIC_INFORMATION mbi;
				Process* pActive = m_registers.m_pActiveProcess;
				VERIFY(::VirtualQuery(pActive, &mbi, sizeof(mbi)) == sizeof(mbi));
				ASSERT(mbi.AllocationBase == pActive->getHeader());
				ASSERT(mbi.BaseAddress == mbi.AllocationBase);
				ASSERT(mbi.AllocationProtect == PAGE_NOACCESS);
				ASSERT(mbi.Protect == PAGE_READWRITE);
				ASSERT(mbi.RegionSize == pBase->getCurrentAllocation());
				ASSERT(mbi.State == MEM_COMMIT);
				ASSERT(mbi.Type == MEM_PRIVATE);
			#endif
		}
		else
		{
			// A crash will soon result, and there's nowt we can do but to terminate
			RaiseFatalError(IDP_STACKOVERFLOW, 4, actualActiveProcessPointer()->getWordSize(), dwNext, dwAddress, activeProcAlloc);
		}
	}
	else
	{
		// The ObjectMemory may be able to handle it
		action = ObjectMemory::gpFaultExceptionFilter(pExRec);
	}

	return action;
}

#endif
