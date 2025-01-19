// thin_main.cpp

#include "ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#pragma comment(lib, "version.lib")

#include "environ.h"
#include "rc_vm.h"
#include "interprt.h"
#include "VMExcept.h"
#include "ComModule.h"

extern void InitializeVtbl(bool isInProc);
extern void DestroyVtbl();

//////////////////////////////////////////////////////////////////
// Global Variables:

wchar_t achImagePath[_MAX_PATH+1];	// Loaded image path

// Basic registry key path (from HKLM)
static const char* szRegRoot = "HKEY_LOCAL_MACHINE";

HINSTANCE hApplicationInstance;

static LPTOP_LEVEL_EXCEPTION_FILTER lpTopFilter;

/////////////////////////////////////////////////////////////////////////////

HMODULE GetVMModule()
{
	return Module::GetHModuleContaining(GetVMModule);
}

BOOL __stdcall GetVersionInfo(VS_FIXEDFILEINFO* lpInfoOut)
{
	BOOL bRet = FALSE;
	DWORD dwHandle;

	wchar_t vmFileName[MAX_PATH+1];
	::GetModuleFileNameW(GetVMModule(), vmFileName, _countof(vmFileName) - 1);

	DWORD dwLen = ::GetFileVersionInfoSizeW(vmFileName, &dwHandle);
	if (dwLen)
	{
		LPVOID lpData = malloc(dwLen);
		if (lpData != nullptr)
		{
			if (::GetFileVersionInfoW(vmFileName, 0, dwLen, lpData))
			{
				void* lpFixedInfo = 0;
				UINT uiBytes = 0;
				VERIFY(::VerQueryValueW(lpData, L"\\", &lpFixedInfo, &uiBytes));
				ASSERT(uiBytes == sizeof(VS_FIXEDFILEINFO));
				memcpy(lpInfoOut, lpFixedInfo, sizeof(VS_FIXEDFILEINFO));
				bRet = TRUE;
			}

			free(lpData);
		}
		else
			TRACESTREAM << L"Fail to get ver info for '" << vmFileName<< L"' (" << ::GetLastError() << L')' << std::endl;
	}
	else
		TRACESTREAM << L"Fail to get ver info size for '" << vmFileName<< L"' (" << ::GetLastError() << L')' << std::endl;
	return bRet;
}


#pragma code_seg()

// The purpose of this structure exception filter is to ignore any "extra" unwind/exits 
// that pop-up in the base loop, which would otherwise cause Dolphin to terminate
static long __stdcall ignoreUnwindsFilter(EXCEPTION_POINTERS *pExceptionInfo)
{
	EXCEPTION_RECORD* pExRec = pExceptionInfo->ExceptionRecord;
	DWORD exceptionCode = pExRec->ExceptionCode;

	switch((VMExceptions)exceptionCode)
	{
	case VMExceptions::CallbackUnwind:
	case VMExceptions::CallbackExit:
		{
			tracelock lock(TRACESTREAM);
			TRACESTREAM<< L"Warning: Ignoring extraneous unwind " << std::hex << PVOID(exceptionCode) << std::endl;
		}
		return EXCEPTION_CONTINUE_EXECUTION;
	
	case VMExceptions::DumpStatus:
		CrashDump(pExceptionInfo, achImagePath);
		return EXCEPTION_CONTINUE_EXECUTION;

	case VMExceptions::Exit:
	default:
		break;
	}

	return EXCEPTION_CONTINUE_SEARCH;
}

// The purpose of this structure exception filter is to ignore any "extra" unwind/exits 
// that pop-up in the base loop, which would otherwise cause Dolphin to terminate
static long __stdcall unhandledExceptionFilter(EXCEPTION_POINTERS *pExceptionInfo)
{
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM<< L"ERROR: An unhandled exception occurred in thread " << GetCurrentThreadId() 
					<< L", see Dolphin Crash Dump (if configured)" << std::endl;
		//_asm int 3;
	}
	CrashDump(pExceptionInfo, achImagePath);

	return lpTopFilter ? lpTopFilter(pExceptionInfo) : EXCEPTION_CONTINUE_SEARCH;
}

static HRESULT DolphinInit(LPCWSTR szFileName, LPVOID imageData, size_t imageSize, bool isDevSys)
{
	// Find the fileName of the image to load by the VM
	wcsncpy_s(achImagePath, szFileName, _MAX_PATH);
	return Interpreter::initialize(achImagePath, imageData, imageSize, isDevSys);
}

#pragma code_seg(TERM_SEG)

void DolphinExitInstance()
{
	Interpreter::ShutDown();
	DestroyVtbl();
}

static int vmmainFilter(LPEXCEPTION_POINTERS pEx, EXCEPTION_RECORD& exRec)
{
	exRec = *pEx->ExceptionRecord;
	int action;
	DWORD code = pEx->ExceptionRecord->ExceptionCode;

	if (code >= SE_VMFIRST && code <= SE_VMLAST)
	{
		action = EXCEPTION_EXECUTE_HANDLER;
		if (code != static_cast<DWORD>(VMExceptions::Exit))
			CrashDump(pEx, achImagePath);
	}
	else
		action = EXCEPTION_CONTINUE_SEARCH;

	return action;
}

void __cdecl invalidParameterHandler(
	wchar_t const* expression,
	wchar_t const* function,
	wchar_t const* file,
	unsigned int line,
	uintptr_t pReservered
	)
{
	TRACE(L"CRT parameter fault in '%s' of %s, %s(%u)", expression, function, file, line);
	ULONG_PTR args[1];
	args[0] = errno;
	::RaiseException(static_cast<DWORD>(VMExceptions::CrtFault), 0, 1, (CONST ULONG_PTR*)args);
}

#ifndef BOOT

void DolphinRun(uintptr_t arg)
{
	Interpreter::sendStartup(achImagePath, arg);

	// Start the interpreter (should not return here)
	__try
	{
		Interpreter::interpret();
	}
	__except (ignoreUnwindsFilter(GetExceptionInformation()))
	{
		_ASSERTE(FALSE);
	}
}

#pragma code_seg(INIT_SEG)

HRESULT InitApplication()
{
#if defined(VMDLL) && !defined(_DEBUG)
	::DisableThreadLibraryCalls(GetVMModule());
#endif
	return S_OK;
}

static inline void DolphinInitInstance(DWORD dwFlags)
{
	// Ensure that Dolphin has a message queue, or the box will not appear
	MSG dummy;
	::PeekMessage(&dummy, 0, 0, 0, PM_NOREMOVE | PM_NOYIELD);

	InitializeVtbl(dwFlags & VmInitFlags::VmInitIsInProc);
}

HRESULT APIENTRY VMInit(LPCWSTR szImageName,
					LPVOID imageData, size_t imageSize,
					DWORD flags)
{
	if (imageData == NULL || imageSize == 0)
		return E_INVALIDARG;

	// Perform instance initialization:
	HRESULT hr = InitApplication();
	if (FAILED(hr))
		return hr;

	DolphinInitInstance(flags);

	return DolphinInit(szImageName, imageData, imageSize, flags & 1);
}

#endif

int APIENTRY VMRun(uintptr_t arg)
{
	extern void DolphinRun(uintptr_t arg);

	int exitCode = 0;
	EXCEPTION_RECORD exRec = { 0 };

	lpTopFilter = SetUnhandledExceptionFilter(unhandledExceptionFilter);
	_invalid_parameter_handler outerInvalidParamHandler = _set_invalid_parameter_handler(invalidParameterHandler);

	__try
	{
		DolphinRun(arg);
	}
	__except (vmmainFilter(GetExceptionInformation(), exRec))
	{
		SetUnhandledExceptionFilter(lpTopFilter);
		lpTopFilter = NULL;
		_set_invalid_parameter_handler(outerInvalidParamHandler);

		if (exRec.ExceptionCode == static_cast<DWORD>(VMExceptions::Exit))
			exitCode = exRec.ExceptionInformation[0];
		else
			FatalException(exRec);
	}

	DolphinExitInstance();

	return exitCode;
}
