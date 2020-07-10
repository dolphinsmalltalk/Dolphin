#include "ist.h"
#include "vmexcept.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "rc_vm.h"

extern int __stdcall DolphinMessage(UINT flags, const wchar_t* msg);

// Set aside a 1024 character buffer for error messages so no memory allocation is needed to report errors (such as out of memory errors)
wchar_t messageBuf[1024];

LPCWSTR GetResourceString(HMODULE hMod, int resId, int& len)
{
	LPCWSTR pchFormat;
	len = ::LoadStringW(hMod, resId, reinterpret_cast<LPWSTR>(&pchFormat), 0);
	return pchFormat;
}

std::wstring GetResourceString(int resId)
{
	int length;
	LPCWSTR szRes = GetResourceString(GetResLibHandle(), resId, length);
	return std::wstring(szRes, length);
}

std::wstring GetAppTitle()
{
	HMODULE hExe = GetModuleHandle(NULL);
	int length;
	LPCWSTR appTitle = GetResourceString(hExe, IDS_APP_TITLE, length);
	if (appTitle != nullptr)
	{
		return std::wstring(appTitle, length);
	}
	else
	{
		WCHAR filename[_MAX_PATH + 1];
		length = GetModuleFileNameW(hExe, filename, _countof(filename));
		return std::wstring(filename, length);
	}
}

int __cdecl DolphinMessageBoxV(int resId, UINT flags, va_list args)
{
	std::wstring strFormat = GetResourceString(resId);
	if (::FormatMessageW(FORMAT_MESSAGE_FROM_STRING, strFormat.c_str(), 0, 0, messageBuf, _countof(messageBuf), &args) != 0)
	{
		int result = DolphinMessage(flags, messageBuf);
		return result;
	}
	else
		return -1;
}

int __cdecl DolphinMessageBox(int nPromptId, UINT flags, ...)
{
	va_list args;
	va_start(args, flags);
	int result = DolphinMessageBoxV(nPromptId, flags, args);
	va_end(args);
	return result;
}

#pragma code_seg()

std::wstring __stdcall GetLastErrorText()
{
	return GetErrorText(::GetLastError());
}

// Answer some suitable text for the last system error
std::wstring __stdcall GetErrorText(DWORD win32ErrorCode)
{
	messageBuf[0] = L'\0';
	::FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM, 0, win32ErrorCode, 0, messageBuf, _countof(messageBuf), 0);
	return messageBuf;
}

void __stdcall vtrace(const wchar_t* szFormat, va_list args)
{
	::vswprintf_s(messageBuf, _countof(messageBuf), szFormat, args);
	::OutputDebugStringW(messageBuf);
}

void __cdecl trace(const wchar_t* szFormat, ...)
{
	va_list args;
	va_start(args, szFormat);
	vtrace(szFormat, args);
	va_end(args);
}

void __cdecl trace(int nPrompt, ...)
{
	std::wstring szFormat = GetResourceString(nPrompt);

	va_list args;
	va_start(args, nPrompt);

	vtrace(szFormat.c_str(), args);

	va_end(args);
}

HRESULT __stdcall ReportErrorV(int nPrompt, HRESULT hr, va_list args)
{
	DolphinMessageBoxV(nPrompt, MB_SETFOREGROUND|MB_ICONHAND|MB_SYSTEMMODAL, args);
	return hr;
}

HRESULT __cdecl ReportError(int nPrompt, ...)
{
	va_list args;
	va_start(args, nPrompt);

	HRESULT hr = ReportErrorV(nPrompt, MAKE_HRESULT(SEVERITY_ERROR, FACILITY_ITF, 2000+nPrompt), args);
	va_end(args);

	return hr;
}

HRESULT __cdecl ReportWin32Error(int nPrompt, DWORD errorCode, LPCWSTR arg)
{
	std::wstring errorText = GetErrorText(errorCode);
	HRESULT hr = ReportError(nPrompt, errorCode, errorText.c_str(), arg);
	return hr;
}

__declspec(noreturn) void __cdecl RaiseFatalError(int nCode, int nArgs, ...) 
{
	va_list args;
	va_start(args, nArgs);
	::RaiseException(MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, nCode), EXCEPTION_NONCONTINUABLE, nArgs, (CONST ULONG_PTR*)args);
}

__declspec(noreturn) void __stdcall FatalException(const EXCEPTION_RECORD& exRec)
{
	DWORD nPrompt = exRec.ExceptionCode & 0x2FF;

	std::wstring strFormat = GetResourceString(nPrompt);
	::FormatMessageW(FORMAT_MESSAGE_FROM_STRING|FORMAT_MESSAGE_ARGUMENT_ARRAY,
						strFormat.c_str(), 0, 0, messageBuf, _countof(messageBuf), (va_list*)exRec.ExceptionInformation);

	DolphinFatalExit(exRec.ExceptionCode, messageBuf);
}

__declspec(noreturn) void __stdcall FatalError(int nCode, ...)
{
	va_list args;
	va_start(args, nCode);
	std::wstring strFormat = GetResourceString(nCode);
	::FormatMessageW(FORMAT_MESSAGE_FROM_STRING, strFormat.c_str(), 0, 0, messageBuf, _countof(messageBuf), &args);
	DolphinFatalExit(nCode, messageBuf);
}

#include "vmexcept.h"

__declspec(noreturn) void __stdcall DolphinExit(int exitCode)
{
	RaiseFatalError(IDP_EXIT, 1, exitCode);
}

#ifndef VM
int __stdcall DolphinMessage(UINT flags, const wchar_t* msg)
{
	std::wstring appTitle = GetAppTitle();
	return MessageBoxW(NULL, msg, appTitle.c_str(), flags | MB_TASKMODAL);
}

__declspec(noreturn) void __stdcall DolphinFatalExit(int /*exitCode*/, const wchar_t* msg)
{
	FatalAppExitW(0, msg);
}

#else
__declspec(noreturn) void __stdcall FatalSystemException(const LPEXCEPTION_POINTERS exInfo)
{
	CrashDump(exInfo, nullptr);
	DWORD statusCode = exInfo->ExceptionRecord->ExceptionCode;
	DWORD len = ::FormatMessageW(FORMAT_MESSAGE_FROM_HMODULE | FORMAT_MESSAGE_ARGUMENT_ARRAY,
		GetModuleHandleW(L"ntdll"), statusCode, 0, messageBuf, _countof(messageBuf), (va_list*)exInfo->ExceptionRecord->ExceptionInformation);
	std::wstring strApp = GetAppTitle();
	std::wstring strFormat = L"%n" + GetResourceString(IDP_CRASHDUMPED);
	DWORD args[2] = { reinterpret_cast<DWORD>(strApp.c_str()), reinterpret_cast<DWORD>(achLogPath) };
	::FormatMessageW(FORMAT_MESSAGE_FROM_STRING | FORMAT_MESSAGE_ARGUMENT_ARRAY, strFormat.c_str(), 0, 0, messageBuf + len, _countof(messageBuf) - len, (va_list*)args);

	DolphinFatalExit(statusCode, messageBuf);
}
#endif
