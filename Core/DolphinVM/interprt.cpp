#include "Interprt.h"
/*
============
Interprt.cpp
============
Implementation of Smalltalk interpreter
*/

#include "Ist.h"
#include "rc_vm.h"

#ifndef _DEBUG
	//#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

#pragma code_seg(INTERPMISC_SEG)

#include "Interprt.h"
#include "InterprtProc.inl"
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
#define VMWNDCLASS L"_VMWnd"

InterpreterRegisters16 Interpreter::m_registers = { 0, 0, 0, 0, 0, 0, 0, 0 };

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
	&m_oteUnderConstruction,
	0
};

__declspec(align(16))
Interpreter::MethodCacheEntry Interpreter::methodCache[MethodCacheSize];

DWORD Interpreter::m_dwThreadId;
HANDLE Interpreter::m_hThread;

BOOL Interpreter::m_bStepping;

bool Interpreter::m_bInterruptsDisabled;
bool Interpreter::m_bAsyncGCDisabled;
bool Interpreter::m_bShutDown;

ATOM Interpreter::m_atomVMWndClass;
HWND Interpreter::m_hWndVM;

DWORD Interpreter::m_dwQueueStatusMask;

//==========
//Initialise
//==========
#ifndef _DEBUG
#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

#pragma code_seg(INIT_SEG)
HRESULT Interpreter::initialize(const wchar_t* szFileName, LPVOID imageData, UINT imageSize, bool isDevSys)
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
	TRACESTREAM<< L"Time to load image: " << (timeEnd - timeStart)<< L" mS" << std::endl;
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

	WNDCLASSW wndClass;
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

	m_hWndVM = CreateWindowW(VMWNDCLASS, L"", WS_CHILD, 0, 0, 0, 0, HWND_MESSAGE, NULL, wndClass.hInstance, NULL);
	if (m_hWndVM == NULL)	// early OSs did not support message-only windows
	{
		m_hWndVM = CreateWindowW(VMWNDCLASS, L"", 0, 0, 0, 0, 0, NULL, NULL, wndClass.hInstance, NULL);
	}
	if (m_hWndVM == NULL)
	{
		return ReportWin32Error(IDP_FAILTOCREATEVMWND, ::GetLastError());
	}

	// Use the same logic as is present in the image to determine the correct status flags for the platform
	m_dwQueueStatusMask = 
		(IsWindows8OrGreater()
			? QS_MOUSE | QS_KEY | QS_RAWINPUT | QS_TOUCH | QS_POINTER
			: IsWindowsXPOrGreater()
				? QS_MOUSE | QS_KEY | QS_RAWINPUT
				: QS_MOUSE | QS_KEY)
		| (QS_POSTMESSAGE | QS_TIMER | QS_PAINT | QS_HOTKEY | QS_SENDMESSAGE);

	initializeCharMaps();

	OverlappedCall::Initialize();

	// ObjectMemory is an entirely static class, so to avoid an instance
	return ObjectMemory::Initialize();
}

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

	initializeVMReferences();

#if defined(_DEBUG)
	ObjectMemory::checkReferences();	// If this fails, the saved image has a ref. count problem
#endif

	initializeCaches();

	m_registers.m_pActiveFrame = firstFrame();
	m_registers.FetchContextRegisters();

#ifdef _DEBUG
	TRACESTREAM<< L"Startup process: " << actualActiveProcessPointer() << std::endl;
#endif

	// Populate the ZCT with zero count objects in the startup process' stack
	ObjectMemory::PopulateZct(m_registers.m_stackPointer);

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

HRESULT Interpreter::initializeCharMaps()
{
	char byteCharSet[256];
	for (unsigned i = 0; i < 256; i++)
		byteCharSet[i] = static_cast<char>(i);

	CPINFOEX cpInfo;
	::GetCPInfoExW(::GetACP(), 0, &cpInfo);

	// First check some assumptions about the code page
	// 1. We expect code page to have a maximum character size of 1.
	// 2. Empirical evidence is that none of the standard code pages will map any of the ansi code units to more 
	// than one UTF16 code unit. 
	// If either assumption is not true, the implementation will not work correctly, so we switch to Windows 1252
	if (cpInfo.MaxCharSize != 1 || ::MultiByteToWideChar(cpInfo.CodePage, 0, byteCharSet, 256, nullptr, 0) > 256)
	{
		trace(IDP_UNSUPPORTED_ACP, m_ansiCodePage);
		::GetCPInfoExW(1252, 0, &cpInfo);
	}

	m_ansiCodePage = cpInfo.CodePage;
	m_ansiReplacementChar = cpInfo.DefaultChar[0];

	::GetCPInfoExW(CP_UTF8, 0, &cpInfo);
	m_unicodeReplacementChar = cpInfo.UnicodeDefaultChar;

	// Map the ansi code units to unicode code points using the current code page. 
	::MultiByteToWideChar(m_ansiCodePage, MB_PRECOMPOSED, byteCharSet, 256, m_ansiToUnicodeCharMap, 256);

	// Create the reverse map - it will be very sparse, but as it only consumes 64Kb it isn't worth using a hash table
	memset(m_unicodeToAnsiCharMap, 0, sizeof(m_unicodeToAnsiCharMap));
	WCHAR wideChars[65536];
	unsigned i = 0;
	for (; i < 0xd800; i++)
		wideChars[i] = static_cast<WCHAR>(i);
	for (; i <= 0xdfff; i++)
		wideChars[i] = 0;
	for (; i <= 0xffff; i++)
		wideChars[i] = static_cast<WCHAR>(i);
	
	VERIFY(::WideCharToMultiByte(m_ansiCodePage, WC_NO_BEST_FIT_CHARS, wideChars, 65536, m_unicodeToAnsiCharMap, 65536, "\0", nullptr) == 65536);

	return S_OK;
}

#pragma code_seg(TERM_SEG)
void Interpreter::ShutDown()
{
	_ASSERTE(!m_bShutDown);
	m_bShutDown = true;
	// Nulling out the handle means that any further attempts to queue APCs, etc, will fail
	HANDLE hThread = LPVOID(InterlockedExchange(reinterpret_cast<SHAREDLONG*>(&m_hThread), 0));

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
	// You may also need to change the cache hashing/lookup code
	ASSERT(sizeof(OTE) == 16);
	ASSERT(sizeof(MethodCacheEntry) == sizeof(OTE));
	ASSERT(MethodCacheSize == 1024);

	flushCaches();
}

#ifdef NDEBUG
#pragma auto_inline(on)
#endif

///////////////////////////////////

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
		TRACESTREAM<< L"Check Refs: Resized proc " << oteProc<< L" from "
			<< std::dec << size<< L" to " << oteProc->getSize() << std::endl;
	}
	return size;
}

void Interpreter::checkReferences(Oop* const sp)
{
	m_registers.m_stackPointer = sp;
	checkReferences(GetRegisters());
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
	while (true)
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
		__except ((dwCode = GetExceptionCode()) > SE_VMCALLBACKUNWIND
			? interpreterExceptionFilter(GetExceptionInformation())
			: EXCEPTION_CONTINUE_SEARCH)
		{
			TRACE(L"interpret: Looping after exception %#x\n\r", dwCode);
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
void Interpreter::saveContextAfterFault(LPEXCEPTION_POINTERS info, bool isInPrimitive)
{
	BYTE* ip = reinterpret_cast<BYTE*>(info->ContextRecord->Edi);
	Oop byteCodes = m_registers.m_pMethod->m_byteCodes;
	BYTE* pBytes = ObjectMemory::ByteAddressOfObjectContents(byteCodes);
	int numByteCodes = ObjectMemoryIsIntegerObject(byteCodes) ?
		sizeof(MWORD) : reinterpret_cast<BytesOTE*>(byteCodes)->bytesSize();
	if (ip >= pBytes && ip < pBytes + numByteCodes)
	{
		m_registers.m_instructionPointer = ip;
	}
	// SP is saved down before primitives are executed, and we don't want to rely on primitive not
	// updating the SP register until there is no possibility of a fault
	if (!isInPrimitive)
	{
		Oop* sp = reinterpret_cast<Oop*>(info->ContextRecord->Esi);
		Process* pProc = actualActiveProcess();
		if (sp > reinterpret_cast<Oop*>(pProc))
		{
			VirtualObject* pVObj = reinterpret_cast<VirtualObject*>(pProc);
			VirtualObjectHeader* pBase = pVObj->getHeader();
			unsigned cbCurrent = pBase->getCurrentAllocation();
			if (sp < reinterpret_cast<Oop*>(reinterpret_cast<BYTE*>(pBase) + cbCurrent))
				m_registers.m_stackPointer = sp;
		}
	}
}

#pragma code_seg(INTERPMISC_SEG)
// Answer whether the interpreter is currently executing a primitive. We determine this
// by testing to see whether the new method is not the same as the active method (primitives
// do not activate until they fail). We must also ensure that the oop is still a method
// 
bool Interpreter::isInPrimitive()
{
	if (!m_registers.m_oopNewMethod->isFree())
	{
		// HARDASSERT(ObjectMemory::isKindOf(m_oopNewMethod, Pointers.ClassCompiledMethod));
		CompiledMethod* newMethod = m_registers.m_oopNewMethod->m_location;
		if (newMethod == m_registers.m_pMethod)
		{
			return false;
		}
		STMethodHeader header = newMethod->m_header;
		// If really a primitive, then flags in header will be 0
		return header.primitiveIndex != PRIMITIVE_ACTIVATE_METHOD;
	}
	else
		return false;
}

void Interpreter::AbandonStepping()
{
	m_bStepping = false;						// We do not want to break now
	ResetInputPollCounter();
}

void Interpreter::recoverFromFault(LPEXCEPTION_POINTERS pExInfo)
{
	AbandonStepping();
	bool inPrim = isInPrimitive();
	saveContextAfterFault(pExInfo, inPrim);
	if (inPrim)
	{
		activateNewMethod(m_registers.m_oopNewMethod->m_location);
	}
}

void Interpreter::sendExceptionInterrupt(Oop oopInterrupt, LPEXCEPTION_POINTERS pExInfo)
{
	recoverFromFault(pExInfo);
#ifdef _DEBUG
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM << std::hex << pExInfo->ExceptionRecord->ExceptionCode<< L" exception trapped in " << *m_registers.m_pMethod << std::endl;
	}
#endif
	sendVMInterrupt(oopInterrupt, reinterpret_cast<Oop>(ByteArray::NewWithRef(sizeof(EXCEPTION_RECORD), pExInfo->ExceptionRecord)));
}

static BOOL WantGPFTrap()
{
	CRegKey rk;
	return OpenDolphinKey(rk, L"DisableGPFTrap") != ERROR_SUCCESS;
}

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
	switch (exceptionCode)
	{
	case EXCEPTION_ACCESS_VIOLATION:
#if !defined(NO_GPF_TRAP)
		action = memoryExceptionFilter(pExInfo);

		if (action == EXCEPTION_CONTINUE_SEARCH)
		{
			void* pExceptionAddr = reinterpret_cast<void*>(pExRec->ExceptionInformation[1]);
			bool bConstWrite = pExRec->ExceptionInformation[0] != 0 &&
				ObjectMemory::IsConstObj(pExceptionAddr);

			if (bConstWrite)
			{
				sendExceptionInterrupt(VMI_CONSTWRITE, pExInfo);
				action = EXCEPTION_EXECUTE_HANDLER;
			}
			else if (isInPrimitive() && PleaseTrapGPFs())
			{
				sendExceptionInterrupt(VMI_ACCESSVIOLATION, pExInfo);
				action = EXCEPTION_EXECUTE_HANDLER;
			}
			// else
			//		continue search for next handler, if any
		}
#endif
		break;

	case STATUS_NO_MEMORY:
		sendExceptionInterrupt(VMI_NOMEMORY, pExInfo);
		action = EXCEPTION_EXECUTE_HANDLER;
		break;

	case EXCEPTION_INT_DIVIDE_BY_ZERO:
	{
		bool inPrim = isInPrimitive();
		saveContextAfterFault(pExInfo, inPrim);
		if (inPrim)
		{
			activateNewMethod(m_registers.m_oopNewMethod->m_location);
		}
#ifdef _DEBUG
		{
			tracelock lock(TRACESTREAM);
			TRACESTREAM<< L"Divide by zero in " << *m_registers.m_pMethod << std::endl;
		}
#endif
		sendVMInterrupt(VMI_ZERODIVIDE, Integer::NewSigned32WithRef(pExInfo->ContextRecord->Eax));
		action = EXCEPTION_EXECUTE_HANDLER;
	}
	break;

	case EXCEPTION_FLT_STACK_CHECK:
		if (PleaseTrapGPFs())
		{
			_asm fninit;
			sendExceptionInterrupt(VMI_FPSTACK, pExInfo);
			action = EXCEPTION_EXECUTE_HANDLER;
		}
		break;

	case EXCEPTION_INT_OVERFLOW:
	case EXCEPTION_PRIV_INSTRUCTION:
	case EXCEPTION_ILLEGAL_INSTRUCTION:
		if (isInPrimitive() && PleaseTrapGPFs())
		{
			sendExceptionInterrupt(VMI_EXCEPTION, pExInfo);
#ifdef _DEBUG
			{
				tracelock lock(TRACESTREAM);
				TRACESTREAM<< L"Unhandled exception " << exceptionCode<< L" in " << *m_registers.m_pMethod << std::endl;
			}
#endif
			action = EXCEPTION_EXECUTE_HANDLER;
		}
		break;

	case SE_VMCRTFAULT:
		if (isInPrimitive())
		{
			sendExceptionInterrupt(VMI_CRTFAULT, pExInfo);
			action = EXCEPTION_EXECUTE_HANDLER;
		}
		break;

	case SE_VMEXIT:
		break;

	default:
		saveContextAfterFault(pExInfo, isInPrimitive());
		action = _fpieee_flt(exceptionCode, pExInfo, IEEEFPHandler);
		break;
	}

	return action;
}

int __cdecl Interpreter::IEEEFPHandler(_FPIEEE_RECORD *pIEEEFPException)
{
	actualActiveProcess()->ResetFP();
	AbandonStepping();
	if (isInPrimitive())
	{
		activateNewMethod(m_registers.m_oopNewMethod->m_location);
	}
#ifdef _DEBUG
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM<< L"FP Fault in " << *m_registers.m_pMethod << std::endl;
	}
#endif
	sendVMInterrupt(VMI_FPFAULT, reinterpret_cast<Oop>(ByteArray::NewWithRef(sizeof(_FPIEEE_RECORD), pIEEEFPException)));
	return EXCEPTION_EXECUTE_HANDLER;
}

#if !defined(NO_GPF_TRAP)

#pragma code_seg(INTERPMISC_SEG)
// Exception filter to handle continuable win32 exceptions caused by object table/process
// stack overflows
int Interpreter::memoryExceptionFilter(LPEXCEPTION_POINTERS pExInfo)
{
	LPEXCEPTION_RECORD pExRec = pExInfo->ExceptionRecord;

	// This "filter" is only designed to handle GPFs
	ASSERT(pExRec->ExceptionCode == EXCEPTION_ACCESS_VIOLATION);

	int action = EXCEPTION_CONTINUE_SEARCH;

	// Determine if the fault is a stack overflow, and if so try
	// growing the stack. If the stack has reached max. size, then
	// pass control to the exception handler
	DWORD dwAddress = pExRec->ExceptionInformation[1];

	VirtualObjectHeader* pBase = actualActiveProcess()->getHeader();
	MWORD activeProcAlloc = pBase->getCurrentAllocation();
	DWORD dwNext = DWORD(pBase) + activeProcAlloc;

#ifdef OAD
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM<< L"Access violation: " << LPVOID(dwAddress)<< L", stack top " << LPVOID(dwNext) << std::endl;
	}
#endif

	if (dwAddress >= dwNext && dwAddress <= dwNext + sizeof(StackFrame))
	{
#ifdef OAD
		{
			tracelock lock(TRACESTREAM);
			TRACESTREAM<< L"Stack overflow detected" << std::endl;
		}
#endif

		if (::VirtualAlloc(LPVOID(dwNext), dwPageSize, MEM_COMMIT, PAGE_READWRITE))
		{
			// Note that the max allocation is actually one page greater since we adjust
			// the reserved space to accomodate an overrun page for detection
			if (activeProcAlloc >= pBase->getMaxAllocation())
			{
				TRACESTREAM<< L"Stack max'd out at " << std::hex << activeProcAlloc << std::endl;
				// Even though stack has hit max. we can still continue (to handle the error)
				// We'll just add an interrupt to the queue, which'll be detected later.
				// In order for this to continue to work, the stack must be shrunk at some
				// point after the stack overflow is handled
				queueInterrupt(VMI_STACKOVERFLOW, ObjectMemoryIntegerObjectOf(activeProcAlloc));
			}
			else
			{
				TRACE(L"Stack successfully grown to %u\n\r", pBase->getCurrentAllocation());
			}

			// Whether the stack has max'd out or not, we're going to continue executing
			// and detect the overflow interrupt synchronously (if it was signalled).
			// This avoids any synchronisation issues, and means that in general, we
			// don't have to code defensively where exceptions might be raised.
			action = EXCEPTION_CONTINUE_EXECUTION;

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
		action = ObjectMemory::gpFaultExceptionFilter(pExInfo);
	}

	return action;
}

#endif
