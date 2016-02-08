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
extern char achImagePath[];

// Warning about SEH and destructable objects
#pragma warning (disable : 4509)

ostream& operator<<(ostream& stream, const CONTEXT* pCtx)
{
	char cFill = stream.fill('0');
	stream.setf(ios::uppercase);
	stream << hex 
		<< "EAX = " << setw(8) << pCtx->Eax << " EBX = " << setw(8) << pCtx->Ebx << " ECX = " << setw(8) << pCtx->Ecx << endl
		<< "ESI = " << setw(8) << pCtx->Esi << " EDI = " << setw(8) << pCtx->Edi << " EIP = " << setw(8) << pCtx->Eip << endl
		<< "ESP = " << setw(8) << pCtx->Esp << " EBP = " << setw(8) << pCtx->Ebp << " EFL = " << setw(8) << pCtx->EFlags << endl
		<< "CS = " << setw(4) << pCtx->SegCs << " SS = " << setw(4) << pCtx->SegSs << " DS = " << setw(4) << pCtx->SegDs << endl
		<< "ES = " << setw(4) << pCtx->SegEs << " FS = " << setw(4) << pCtx->SegFs << " GS = " << setw(4) << pCtx->SegGs << endl;
	stream.fill(cFill);
	stream.unsetf(ios::uppercase);
	return stream;
}

void CrashDump(EXCEPTION_POINTERS *pExceptionInfo, ostream* pStream, DWORD nStackDepth, DWORD nWalkbackDepth)
{
	SYSTEMTIME stNow;
	GetLocalTime(&stNow);

	if (pStream == NULL)
		pStream = &TRACESTREAM;

	*pStream << endl;
	for (int i=0;i<80;i++)
		*pStream << '*';

	EXCEPTION_RECORD* pExRec = pExceptionInfo->ExceptionRecord;
	DWORD exceptionCode = pExRec->ExceptionCode;

	*pStream << endl;
	for (int i=0;i<26;i++)
		*pStream << '*';
	*pStream << " Dolphin Crash Dump Report ";
	for (int i=0;i<27;i++)
		*pStream << '*';

	char szModule[_MAX_PATH+1];
	LPSTR szFileName = 0;
	{
		char szPath[_MAX_PATH+1];
		::GetModuleFileName(GetModuleHandle(NULL), szPath, _MAX_PATH);
		::GetFullPathName(szPath, _MAX_PATH, szModule, &szFileName);
	}

	*pStream << endl << endl << stNow
		<< ": " << szFileName
		<< " caused an unhandled Win32 Exception " 
		<< PVOID(exceptionCode) << endl
		<<"at " << pExRec->ExceptionAddress;

	// Determine the module in which it occurred
	MEMORY_BASIC_INFORMATION mbi;
	::VirtualQuery(pExRec->ExceptionAddress, &mbi, sizeof(mbi));
	HMODULE hMod = HMODULE(mbi.AllocationBase);

	strcpy(szModule, "<UNKNOWN>");
	GetModuleFileName(hMod, szModule, _MAX_PATH);
	*pStream << " in module " << hMod << " (" << szModule << ")" << endl << endl;

	const DWORD NumParms = pExRec->NumberParameters;
	if (NumParms > 0)
	{
		*pStream << "*----> Exception Parameters <----*" << endl;
		char cFill = pStream->fill('0');
		pStream->setf(ios::uppercase);
		*pStream << hex;
		for (unsigned i=0;i<NumParms;i++)
		{
			DWORD dwParm = pExRec->ExceptionInformation[i];
			*pStream << setw(8) << dwParm << "	";
			BYTE* pBytes = reinterpret_cast<BYTE*>(dwParm);
			if (!IsBadReadPtr(pBytes, MAXDUMPPARMCHARS))
			{
				char buf[MAXDUMPPARMCHARS+1];
				strncpy_s(buf, reinterpret_cast<LPCSTR>(pBytes), MAXDUMPPARMCHARS);
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
	*pStream << "*----> CPU Context for thread 0x" << hex << dwThreadId
		<< " <----*" << endl
		<< pCtx << endl;

	DWORD dwMainThreadId = Interpreter::MainThreadId();
	if (dwThreadId == dwMainThreadId)
	{
		DWORD dwCode=0;
		_try
		{
			Interpreter::DumpContext(pExceptionInfo, *pStream);

			*pStream << endl << "*----> Stack Back Trace <----*" << endl;
			Interpreter::StackTraceOn(*pStream, NULL, nWalkbackDepth);

			Interpreter::DumpStack(*pStream, nStackDepth);
		}
		_except((dwCode=GetExceptionCode()), EXCEPTION_EXECUTE_HANDLER)
		{
			*pStream << endl << "***Unable to generate complete exception report (" 
						<< hex << dwCode << ')' << endl;
		}
	}
	else
	{
		*pStream <<"****N.B. This exception did NOT occur in the main Dolphin execution thread ****" << endl << endl;

		*pStream << "*----> CPU Context for main thread 0x" << hex << dwMainThreadId
					<< " <----*" << endl;

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

				strcpy(szModule, "<UNKNOWN>");
				GetModuleFileName(hMod, szModule, _MAX_PATH);
				*pStream << "In module " << hMod << " (" << szModule << ")" << endl << endl;
			}
			else
				*pStream << endl << "*** Unable to access main interpter thread context (" 
					<< dec << GetLastError() << ")" << endl;

			::ResumeThread(hMain);
		}
		else
		{
			*pStream << endl << "*** Unable to suspend main interpreter thread (" << dec << GetLastError() << ")" 
						<< endl;
		}
	}

	*pStream << endl << "***** End of crash report *****" << endl << endl;
	pStream->flush();
}


ostream* OpenLogStream(const char* achLogPath, const char* achImagePath, ofstream& fStream)
{
	char path[_MAX_PATH];

	if (achLogPath == NULL || !strlen(achLogPath))
	{
		// Write the dump to the errors file
		char drive[_MAX_DRIVE];
		char dir[_MAX_DIR];
		char fname[_MAX_FNAME];
		_splitpath_s(achImagePath, drive, _MAX_DRIVE, dir, _MAX_DIR, fname, _MAX_FNAME, NULL, 0);
		_makepath(path, drive, dir, fname, ".ERRORS");
		achLogPath = path;
	}

	trace("Dolphin: Writing dump to '%.260s'\n", achLogPath);

	ostream* pStream = NULL;
	// Open the error log for appending
	fStream.open(achLogPath, ios::out | ios::app | ios::ate);
	if (fStream.fail())
		trace("Dolphin: Unable to open crash dump log '%.260s', dump follows:\n\n", achLogPath);
	else
		pStream = &fStream;

	return pStream;
}

void CrashDump(EXCEPTION_POINTERS *pExceptionInfo, const char* achImagePath)
{
	DWORD nStackDepth = DefaultStackDepth;
	DWORD nWalkbackDepth = DefaultWalkbackDepth;
	ostream* pStream = NULL;
	ofstream fStream;
	CRegKey rkDump;
	if (OpenDolphinKey(rkDump, "CrashDump", KEY_READ)==ERROR_SUCCESS)
	{
		char achLogPath[_MAX_PATH+1];
		achLogPath[0] = 0;
		unsigned long size = _MAX_PATH;
		rkDump.QueryStringValue("", achLogPath, &size);
		pStream = OpenLogStream(achLogPath, achImagePath, fStream);

		if (rkDump.QueryDWORDValue("StackDepth", nStackDepth)!=ERROR_SUCCESS || nStackDepth == 0)
			nStackDepth = DefaultStackDepth;

		if (rkDump.QueryDWORDValue("WalkbackDepth", nWalkbackDepth)!=ERROR_SUCCESS || nWalkbackDepth == 0)
			nWalkbackDepth = DefaultWalkbackDepth;
	}
	else
		pStream = OpenLogStream(NULL, achImagePath, fStream);

	CrashDump(pExceptionInfo, pStream, nStackDepth, nWalkbackDepth);
}


void __cdecl DebugCrashDump(LPCTSTR szFormat, ...)
{
	TCHAR buf[1024];

	va_list args;
	va_start(args, szFormat);
	::StringCbVPrintf(buf, sizeof(buf), szFormat, args);
	va_end(args);

	DWORD dwArgs[1];
	dwArgs[0] = reinterpret_cast<DWORD>(&buf);
	RaiseException(SE_VMDUMPSTATUS, 0, 1, dwArgs);
}

void __stdcall Dump2(LPCTSTR szMsg, ostream* pStream, int nStackDepth, int nWalkbackDepth)
{
	if (pStream == NULL)
		pStream = &TRACESTREAM;

	*pStream << endl;
	for (int i=0;i<26;i++)
		*pStream << '*';
	*pStream << " Dolphin Virtual Machine Dump Report ";
	for (int i=0;i<27;i++)
		*pStream << '*';

	// Dump the time and message
	{
		SYSTEMTIME stNow;
		GetLocalTime(&stNow);
		*pStream << endl << endl << stNow
			<< ": " << szMsg << endl << endl;
	}

	Interpreter::DumpContext(*pStream);
	*pStream << endl << "*----> Stack Back Trace <----*" << endl;
	Interpreter::StackTraceOn(*pStream, NULL, nWalkbackDepth);
	Interpreter::DumpStack(*pStream, nStackDepth);
	*pStream << endl << "***** End of dump *****" << endl << endl;

	pStream->flush();
}

extern"C" void __stdcall Dump(LPCTSTR szMsg, LPCTSTR szPath, int nStackDepth, int nWalkbackDepth)
{
	ofstream fStream;
	ostream* pStream = OpenLogStream(szPath, achImagePath, fStream);
	Dump2(szMsg, pStream, nStackDepth, nWalkbackDepth);
}

void __stdcall DebugDump(LPCTSTR szFormat, ...)
{
	TCHAR buf[1024];

	va_list args;
	va_start(args, szFormat);
	::StringCbVPrintf(buf, sizeof(buf), szFormat, args);
	va_end(args);

	tracelock lock(TRACESTREAM);
	Dump2(buf, &TRACESTREAM, 0, -1);
}
