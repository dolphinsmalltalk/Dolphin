#include "ist.h"
#include "vmexcept.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "rc_vm.h"
#include <process.h>
#include <stdlib.h>

extern int __stdcall DolphinMessage(UINT flags, const char* msg);
extern void __stdcall DolphinFatalExit(int exitCode, const char* msg);

#ifndef VM

int __stdcall DolphinMessage(UINT flags, const char* msg)
{
	char szCaption[512];
	HMODULE hExe = GetModuleHandle(NULL);
	if (!::LoadString(hExe, IDS_APP_TITLE, szCaption, sizeof(szCaption)-1))
		GetModuleFileName(hExe, szCaption, sizeof(szCaption));
	return  ::MessageBox(NULL, msg, szCaption, flags|MB_TASKMODAL);
}

#endif

static int __cdecl DolphinMessageBox(const char* szFormat, UINT flags, va_list args)
{
	LPSTR buf;
	::FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_STRING,
						szFormat, 0, 0, LPSTR(&buf), 0, &args);

	int result = DolphinMessage(flags, buf);

	::LocalFree(buf);
	
	return result;
}

int __cdecl DolphinMessageBox(int nPromptId, UINT flags, ...)
{
	va_list args;
	va_start(args, flags);
	char szPrompt[512];
	::LoadString(GetResLibHandle(), nPromptId, szPrompt, sizeof(szPrompt)-1);
	int result = DolphinMessageBox(szPrompt, flags, args);
	va_end(args);
	return result;
}

#pragma code_seg()

LPSTR __stdcall GetLastErrorText()
{
	return GetErrorText(::GetLastError());
}

// Answer some suitable text for the last system error
LPSTR __stdcall GetErrorText(DWORD win32ErrorCode)
{
	LPSTR buf;
	::FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
		0, win32ErrorCode, 0, LPSTR(&buf), 0, 0);
	return buf;
}

void __stdcall vtrace(const char* szFormat, va_list args)
{
	char buf[1024];
	::vsprintf_s(buf, sizeof(buf), szFormat, args);
	::OutputDebugString(buf);
}

void __cdecl trace(const char* szFormat, ...)
{
	va_list args;
	va_start(args, szFormat);
	vtrace(szFormat, args);
	va_end(args);
}

HRESULT __stdcall ReportErrorV(int nPrompt, HRESULT hr, va_list args)
{
	char szFormat[256];
	::LoadString(GetResLibHandle(), nPrompt, szFormat, sizeof(szFormat)-1);

	DolphinMessageBox(szFormat, MB_SETFOREGROUND|MB_ICONHAND|MB_SYSTEMMODAL, args);

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

HRESULT __cdecl ReportWin32Error(int nPrompt, DWORD errorCode, LPCSTR arg)
{
	LPSTR errorText = GetErrorText(errorCode);
	HRESULT hr = ReportError(nPrompt, errorCode, errorText, arg);
	::LocalFree(errorText);
	return hr;
}

void __cdecl RaiseFatalError(int nCode, int nArgs, ...)
{
	va_list args;
	va_start(args, nArgs);
	::RaiseException(MAKE_CUST_SCODE(SEVERITY_ERROR, FACILITY_NULL, nCode), EXCEPTION_NONCONTINUABLE, nArgs, (CONST ULONG_PTR*)args);
}

void __stdcall FatalException(const EXCEPTION_RECORD& exRec)
{
	int nPrompt = exRec.ExceptionCode & 0x2FF;

	char szFormat[256];
	::LoadString(GetResLibHandle(), nPrompt, szFormat, sizeof(szFormat)-1);

	LPSTR buf;
	::FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_STRING|FORMAT_MESSAGE_ARGUMENT_ARRAY,
						szFormat, 0, 0, LPSTR(&buf), 0, (va_list*)exRec.ExceptionInformation);


	DolphinFatalExit(exRec.ExceptionCode, buf);

	::LocalFree(buf);
}

#include "vmexcept.h"

void __stdcall DolphinExit(int exitCode)
{
	RaiseFatalError(IDP_EXIT, 1, exitCode);
}

#ifndef VM

void __stdcall DolphinFatalExit(int /*exitCode*/, const char* msg)
{
	FatalAppExit(0, msg);
}

#endif