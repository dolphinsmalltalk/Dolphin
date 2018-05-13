#include "ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#pragma code_seg(DEBUG_SEG)

#include "environ.h"
#include <wtypes.h>
#include "rc_vm.h"
#include "interprt.h"
#include "VMExcept.h"
#include "RegKey.h"
#include <Strsafe.h>

static const DWORD DefaultStackDepth = 300;
static const DWORD DefaultWalkbackDepth = static_cast<DWORD>(-1);
static const int MAXDUMPPARMCHARS = 40;
extern wchar_t achImagePath[];

// Warning about SEH and destructable objects
#pragma warning (disable : 4509)

wostream& operator<<(wostream& stream, const CONTEXT* pCtx)
{
	wostream::char_type cFill = stream.fill('0');
	stream.setf(ios::uppercase);
	stream << hex 
		<< L"EAX = " << setw(8) << pCtx->Eax<< L" EBX = " << setw(8) << pCtx->Ebx<< L" ECX = " << setw(8) << pCtx->Ecx << endl
		<< L"ESI = " << setw(8) << pCtx->Esi<< L" EDI = " << setw(8) << pCtx->Edi<< L" EIP = " << setw(8) << pCtx->Eip << endl
		<< L"ESP = " << setw(8) << pCtx->Esp<< L" EBP = " << setw(8) << pCtx->Ebp<< L" EFL = " << setw(8) << pCtx->EFlags << endl
		<< L"CS = " << setw(4) << pCtx->SegCs<< L" SS = " << setw(4) << pCtx->SegSs<< L" DS = " << setw(4) << pCtx->SegDs << endl
		<< L"ES = " << setw(4) << pCtx->SegEs<< L" FS = " << setw(4) << pCtx->SegFs<< L" GS = " << setw(4) << pCtx->SegGs << endl;
	stream.fill(cFill);
	stream.unsetf(ios::uppercase);
	return stream;
}

void CrashDump(EXCEPTION_POINTERS *pExceptionInfo, wostream* pStream, DWORD nStackDepth, DWORD nWalkbackDepth)
{
	SYSTEMTIME stNow;
	GetLocalTime(&stNow);

	if (pStream == NULL)
		pStream = &TRACESTREAM;

	*pStream << endl;
	for (int i=0;i<80;i++)
		*pStream << L'*';

	EXCEPTION_RECORD* pExRec = pExceptionInfo->ExceptionRecord;
	DWORD exceptionCode = pExRec->ExceptionCode;

	*pStream << endl;
	for (int i=0;i<26;i++)
		*pStream << L'*';
	*pStream<< L" Dolphin Crash Dump Report ";
	for (int i=0;i<27;i++)
		*pStream << L'*';

	wchar_t szModule[_MAX_PATH+1];
	LPWSTR szFileName = 0;
	{
		wchar_t szPath[_MAX_PATH+1];
		::GetModuleFileNameW(GetModuleHandle(NULL), szPath, _MAX_PATH);
		::GetFullPathNameW(szPath, _MAX_PATH, szModule, &szFileName);
	}

	*pStream << endl << endl << stNow
		<< L": " << szFileName
		<< L" caused an unhandled Win32 Exception " 
		<< PVOID(exceptionCode) << endl
		<< L"at " << pExRec->ExceptionAddress;

	// Determine the module in which it occurred
	MEMORY_BASIC_INFORMATION mbi;
	::VirtualQuery(pExRec->ExceptionAddress, &mbi, sizeof(mbi));
	HMODULE hMod = HMODULE(mbi.AllocationBase);

	wcscpy_s(szModule, L"<UNKNOWN>");
	::GetModuleFileNameW(hMod, szModule, _MAX_PATH);
	*pStream<< L" in module " << hMod<< L" (" << szModule<< L")" << endl << endl;

	const DWORD NumParms = pExRec->NumberParameters;
	if (NumParms > 0)
	{
		*pStream << L"*----> Exception Parameters <----*" << endl;
		wostream::char_type cFill = pStream->fill(L'0');
		pStream->setf(ios::uppercase);
		*pStream << hex;
		for (unsigned i=0;i<NumParms;i++)
		{
			DWORD dwParm = pExRec->ExceptionInformation[i];
			*pStream << setw(8) << dwParm<< L"	";
			BYTE* pBytes = reinterpret_cast<BYTE*>(dwParm);
			if (!IsBadReadPtr(pBytes, MAXDUMPPARMCHARS))
			{
				wchar_t buf[MAXDUMPPARMCHARS+1];
				wcsncpy_s(buf, reinterpret_cast<LPCWSTR>(pBytes), MAXDUMPPARMCHARS);
				buf[MAXDUMPPARMCHARS] = 0;
				*pStream << buf; 
			}
			*pStream << endl;
		}
		pStream->fill(cFill);
		pStream->unsetf(ios::uppercase);
		*pStream << endl;
	}

	DWORD dwThreadId = GetCurrentThreadId();
	PCONTEXT pCtx = pExceptionInfo->ContextRecord;
	*pStream<< L"*----> CPU Context for thread 0x" << hex << dwThreadId
		<< L" <----*" << endl
		<< pCtx << endl;

	DWORD dwMainThreadId = Interpreter::MainThreadId();
	if (dwThreadId == dwMainThreadId)
	{
		DWORD dwCode=0;
		_try
		{
			Interpreter::DumpContext(pExceptionInfo, *pStream);

			*pStream << endl<< L"*----> Stack Back Trace <----*" << endl;
			Interpreter::StackTraceOn(*pStream, NULL, nWalkbackDepth);

			Interpreter::DumpStack(*pStream, nStackDepth);
		}
		_except((dwCode=GetExceptionCode()), EXCEPTION_EXECUTE_HANDLER)
		{
			*pStream << endl<< L"***Unable to generate complete exception report (" 
						<< hex << dwCode << L')' << endl;
		}
	}
	else
	{
		*pStream <<L"****N.B. This exception did NOT occur in the main Dolphin execution thread ****" << endl << endl;

		*pStream<< L"*----> CPU Context for main thread 0x" << hex << dwMainThreadId
					<< L" <----*" << endl;

		// An overlapped thread
		HANDLE hMain = Interpreter::MainThreadHandle();
		DWORD dwRet = SuspendThread(hMain);
		if (int(dwRet) >= 0)
		{
			CONTEXT ctxMain;
			memset(&ctxMain, 0, sizeof(CONTEXT));
			ctxMain.ContextFlags = CONTEXT_FULL;
			if (::GetThreadContext(hMain, &ctxMain))
			{
				*pStream << &ctxMain << endl;

				::VirtualQuery(reinterpret_cast<void*>(ctxMain.Eip), &mbi, sizeof(mbi));
				hMod = HMODULE(mbi.AllocationBase);

				wcscpy_s(szModule, L"<UNKNOWN>");
				::GetModuleFileNameW(hMod, szModule, _MAX_PATH);
				*pStream<< L"In module " << hMod<< L" (" << szModule<< L")" << endl << endl;
			}
			else
				*pStream << endl<< L"*** Unable to access main interpter thread context (" 
					<< dec << GetLastError()<< L")" << endl;

			::ResumeThread(hMain);
		}
		else
		{
			*pStream << endl<< L"*** Unable to suspend main interpreter thread (" << dec << GetLastError()<< L")" 
						<< endl;
		}
	}

	*pStream << endl<< L"***** End of crash report *****" << endl << endl;
	pStream->flush();
}


wostream* OpenLogStream(const wchar_t* achLogPath, const wchar_t* achImagePath, wofstream& fStream)
{
	wchar_t path[_MAX_PATH];

	if (achLogPath == NULL || !wcslen(achLogPath))
	{
		// Write the dump to the errors file
		wchar_t drive[_MAX_DRIVE];
		wchar_t dir[_MAX_DIR];
		wchar_t fname[_MAX_FNAME];
		_wsplitpath_s(achImagePath, drive, _MAX_DRIVE, dir, _MAX_DIR, fname, _MAX_FNAME, NULL, 0);
		_wmakepath(path, drive, dir, fname, L".ERRORS");
		achLogPath = path;
	}

	trace(L"Dolphin: Writing dump to '%.260s'\n", achLogPath);

	wostream* pStream = NULL;
	// Open the error log for appending
	fStream.open(achLogPath, ios::out | ios::app | ios::ate);
	if (fStream.fail())
		trace(L"Dolphin: Unable to open crash dump log '%.260s', dump follows:\n\n", achLogPath);
	else
		pStream = &fStream;

	return pStream;
}

void CrashDump(EXCEPTION_POINTERS *pExceptionInfo, const wchar_t* achImagePath)
{
	DWORD nStackDepth = DefaultStackDepth;
	DWORD nWalkbackDepth = DefaultWalkbackDepth;
	wostream* pStream = NULL;
	wofstream fStream;
	CRegKey rkDump;
	if (OpenDolphinKey(rkDump, L"CrashDump", KEY_READ)==ERROR_SUCCESS)
	{
		wchar_t achLogPath[_MAX_PATH+1];
		achLogPath[0] = 0;
		unsigned long size = _MAX_PATH;
		rkDump.QueryStringValue(L"", achLogPath, &size);
		pStream = OpenLogStream(achLogPath, achImagePath, fStream);

		if (rkDump.QueryDWORDValue(L"StackDepth", nStackDepth)!=ERROR_SUCCESS || nStackDepth == 0)
			nStackDepth = DefaultStackDepth;

		if (rkDump.QueryDWORDValue(L"WalkbackDepth", nWalkbackDepth)!=ERROR_SUCCESS || nWalkbackDepth == 0)
			nWalkbackDepth = DefaultWalkbackDepth;
	}
	else
		pStream = OpenLogStream(nullptr, achImagePath, fStream);

	CrashDump(pExceptionInfo, pStream, nStackDepth, nWalkbackDepth);
}


void __cdecl DebugCrashDump(const wchar_t* szFormat, ...)
{
	wchar_t buf[1024];

	va_list args;
	va_start(args, szFormat);
	::StringCbVPrintfW(buf, sizeof(buf), szFormat, args);
	va_end(args);

	DWORD dwArgs[1];
	dwArgs[0] = reinterpret_cast<DWORD>(&buf);
	RaiseException(SE_VMDUMPSTATUS, 0, 1, dwArgs);
}

void __stdcall Dump2(const wchar_t* szMsg, wostream* pStream, int nStackDepth, int nWalkbackDepth)
{
	if (pStream == NULL)
		pStream = &TRACESTREAM;

	*pStream << endl;
	for (int i=0;i<26;i++)
		*pStream << L'*';
	*pStream<< L" Dolphin Virtual Machine Dump Report ";
	for (int i=0;i<27;i++)
		*pStream << L'*';

	// Dump the time and message
	{
		SYSTEMTIME stNow;
		GetLocalTime(&stNow);
		*pStream << endl << endl << stNow
			<< L": " << szMsg << endl << endl;
	}

	Interpreter::DumpContext(*pStream);
	*pStream << endl<< L"*----> Stack Back Trace <----*" << endl;
	Interpreter::StackTraceOn(*pStream, NULL, nWalkbackDepth);
	Interpreter::DumpStack(*pStream, nStackDepth);
	*pStream << endl<< L"***** End of dump *****" << endl << endl;

	pStream->flush();
}

extern"C" void __stdcall Dump(const wchar_t* szMsg, const wchar_t* szPath, int nStackDepth, int nWalkbackDepth)
{
	wofstream fStream;
	wostream* pStream = OpenLogStream(szPath, achImagePath, fStream);
	Dump2(szMsg, pStream, nStackDepth, nWalkbackDepth);
}

void __stdcall DebugDump(const wchar_t* szFormat, ...)
{
	wchar_t buf[1024];

	va_list args;
	va_start(args, szFormat);
	::StringCbVPrintfW(buf, sizeof(buf), szFormat, args);
	va_end(args);

	tracelock lock(TRACESTREAM);
	Dump2(buf, &TRACESTREAM, 0, -1);
}
