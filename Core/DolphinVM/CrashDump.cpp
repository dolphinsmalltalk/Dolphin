#include "ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#pragma code_seg(DEBUG_SEG)

#include "environ.h"
#include "rc_vm.h"
#include "interprt.h"
#include "VMExcept.h"
#include "RegKey.h"
#include "VirtualMemoryStats.h"
#include <codecvt>

constexpr size_t DefaultStackDepth = 300;
constexpr size_t DefaultWalkbackDepth = static_cast<size_t>(-1);
constexpr int MAXDUMPPARMCHARS = 40;
extern wchar_t achImagePath[];
wchar_t achLogPath[_MAX_PATH + 1];

// Warning about SEH and destructable objects
#pragma warning (disable : 4509)

using namespace std;

wostream& operator<<(wostream& stream, const CONTEXT* pCtx)
{
	wostream::char_type cFill = stream.fill('0');
	stream.setf(ios::uppercase);
	stream << std::hex 
#ifdef _M_X64
		<< L"RAX = " << setw(16) << pCtx->Rax << L" RBX = " << setw(16) << pCtx->Rbx << L" RCX = " << setw(16) << pCtx->Rcx << std::endl
		<< L"RSI = " << setw(16) << pCtx->Rsi << L" EDI = " << setw(16) << pCtx->Rdi << L" R8 = " << setw(16) << pCtx->R8 << std::endl
		<< L"R9 = " << setw(16) << pCtx->R9 << L" R10 = " << setw(16) << pCtx->R10 << L" R11 = " << setw(16) << pCtx->R11 << std::endl
		<< L"R12 = " << setw(16) << pCtx->R12 << L" R13 = " << setw(16) << pCtx->R13 << L" R14 = " << setw(16) << pCtx->R14 << std::endl
		<< L"R15 = " << setw(16) << pCtx->R15 << std::endl
		<< L"RIP = " << setw(16) << pCtx->Rip << L"RSP = " << setw(16) << pCtx->Rsp << L" RBP = " << setw(16) << pCtx->Rbp << L" EFL = " << setw(8) << pCtx->EFlags << std::endl
		<< L"CS = " << setw(4) << pCtx->SegCs << L" SS = " << setw(4) << pCtx->SegSs << L" DS = " << setw(4) << pCtx->SegDs << std::endl
		<< L"ES = " << setw(4) << pCtx->SegEs << L" FS = " << setw(4) << pCtx->SegFs << L" GS = " << setw(4) << pCtx->SegGs << std::endl;
#else
		<< L"EAX = " << setw(8) << pCtx->Eax << L" EBX = " << setw(8) << pCtx->Ebx << L" ECX = " << setw(8) << pCtx->Ecx << std::endl
		<< L"ESI = " << setw(8) << pCtx->Esi << L" EDI = " << setw(8) << pCtx->Edi << L" EIP = " << setw(8) << pCtx->Eip << std::endl
		<< L"ESP = " << setw(8) << pCtx->Esp << L" EBP = " << setw(8) << pCtx->Ebp << L" EFL = " << setw(8) << pCtx->EFlags << std::endl
		<< L"CS = " << setw(4) << pCtx->SegCs << L" SS = " << setw(4) << pCtx->SegSs << L" DS = " << setw(4) << pCtx->SegDs << std::endl
		<< L"ES = " << setw(4) << pCtx->SegEs << L" FS = " << setw(4) << pCtx->SegFs << L" GS = " << setw(4) << pCtx->SegGs << std::endl;
#endif
	stream.fill(cFill);
	stream.unsetf(ios::uppercase);
	return stream;
}

wostream& operator<<(wostream& stream, const VirtualMemoryStats& vmStats)
{
	return stream << std::dec << "Virtual memory used: " << vmStats.VirtualMemoryUsedMb << "Mb" << endl
		<< "Virtual memory available: " << vmStats.VirtualMemoryFreeMb << "Mb" << endl;
}

std::wstring GetVmVersion()
{
	BOOL bRet = FALSE;
	DWORD dwHandle;
	wchar_t vmFileName[MAX_PATH + 1];
	::GetModuleFileNameW(GetVMModule(), vmFileName, _countof(vmFileName) - 1);

	DWORD dwLen = ::GetFileVersionInfoSizeW(vmFileName, &dwHandle);
	if (dwLen)
	{
		LPVOID lpData = _malloca(dwLen);
		if (lpData != nullptr)
		{
			if (::GetFileVersionInfoW(vmFileName, 0, dwLen, lpData))
			{
				LPWSTR szProductVersion = nullptr;
				UINT len = 0;
				VerQueryValue(lpData, L"\\StringFileInfo\\040904e4\\ProductVersion", reinterpret_cast<void**>(&szProductVersion), &len);
				std::wstring productVersion(szProductVersion, len);
				_freea(lpData);
				return productVersion;
			}
		}
	}
	return std::wstring();
}

void EmitHeaderLine(wostream& stream, const wchar_t* sz)
{
	auto len = sz == nullptr ? 0u : wcslen(sz) + 2;
	auto prefix = (80u - len) / 2;
	for (auto i = 0u; i < prefix; i++)
		stream << L'*';
	if (len > 0)
	{
		stream << L' ' << sz << L' ';
	}
	auto suffix = 80u - len - prefix;
	for (auto i = 0u; i < suffix; i++)
		stream << L'*';
	stream << endl;
}

void CrashDump(EXCEPTION_POINTERS *pExceptionInfo, wostream* pStream, size_t nStackDepth, size_t nWalkbackDepth)
{
	SYSTEMTIME stNow;
	GetLocalTime(&stNow);

	if (pStream == NULL)
		pStream = &TRACESTREAM;

	*pStream << std::endl;
	EmitHeaderLine(*pStream, nullptr);

	EXCEPTION_RECORD* pExRec = pExceptionInfo->ExceptionRecord;
	DWORD exceptionCode = pExRec->ExceptionCode;

	EmitHeaderLine(*pStream, L"Dolphin Crash Dump Report");

	{
		std::wstring vmVersionString = GetVmVersion();
		if (vmVersionString.size() > 0)
		{
			EmitHeaderLine(*pStream, (L"VM version: " + vmVersionString).c_str());
		}
	}

	wchar_t szModule[_MAX_PATH+1];
	LPWSTR szFileName = 0;
	{
		wchar_t szPath[_MAX_PATH+1];
		::GetModuleFileNameW(GetModuleHandle(NULL), szPath, _MAX_PATH);
		::GetFullPathNameW(szPath, _MAX_PATH, szModule, &szFileName);
	}

	*pStream << std::endl << stNow
		<< L": " << szFileName
		<< L" caused an unhandled Win32 Exception " 
		<< PVOID(exceptionCode) << std::endl
		<< L"at " << pExRec->ExceptionAddress;

	// Determine the module in which it occurred
	MEMORY_BASIC_INFORMATION mbi;
	::VirtualQuery(pExRec->ExceptionAddress, &mbi, sizeof(mbi));
	HMODULE hMod = HMODULE(mbi.AllocationBase);

	wcscpy_s(szModule, L"<UNKNOWN>");
	::GetModuleFileNameW(hMod, szModule, _MAX_PATH);
	*pStream << L" in module " << hMod<< L" (" << szModule<< L")" << std::endl << std::endl;

	const DWORD NumParms = pExRec->NumberParameters;
	if (NumParms > 0)
	{
		*pStream << L"*----> Exception Parameters <----*" << std::endl;
		wostream::char_type cFill = pStream->fill(L'0');
		pStream->setf(ios::uppercase);
		*pStream << std::hex;
		for (auto i=0u;i<NumParms;i++)
		{
			uintptr_t parm = pExRec->ExceptionInformation[i];
			*pStream << setw(sizeof(uintptr_t)<<1) << parm<< L"	";
			uint8_t* pBytes = reinterpret_cast<uint8_t*>(parm);
			if (!IsBadReadPtr(pBytes, MAXDUMPPARMCHARS))
			{
				wchar_t buf[MAXDUMPPARMCHARS+1];
				wcsncpy_s(buf, reinterpret_cast<LPCWSTR>(pBytes), MAXDUMPPARMCHARS);
				buf[MAXDUMPPARMCHARS] = 0;
				*pStream << buf; 
			}
			*pStream << std::endl;
		}
		pStream->fill(cFill);
		pStream->unsetf(ios::uppercase);
		*pStream << std::endl;
	}

	DWORD dwThreadId = GetCurrentThreadId();
	PCONTEXT pCtx = pExceptionInfo->ContextRecord;
	*pStream<< L"*----> CPU Context for thread 0x" << std::hex << dwThreadId
		<< L" <----*" << std::endl
		<< pCtx << std::endl;

	{
		VirtualMemoryStats memStats;
		*pStream << L"*----> Memory Statistics <----*" << std::endl << memStats << std::endl;
	}
	
	DWORD dwMainThreadId = Interpreter::MainThreadId();
	if (dwThreadId == dwMainThreadId)
	{
		DWORD dwCode=0;
		_try
		{
			Interpreter::DumpContext(pExceptionInfo, *pStream);

			*pStream << std::endl<< L"*----> Stack Back Trace <----*" << std::endl;
			Interpreter::StackTraceOn(*pStream, NULL, nWalkbackDepth);

			Interpreter::DumpStack(*pStream, nStackDepth);
		}
		_except((dwCode=GetExceptionCode()), EXCEPTION_EXECUTE_HANDLER)
		{
			*pStream << std::endl<< L"***Unable to generate complete exception report (" 
						<< std::hex << dwCode << L')' << std::endl;
		}
	}
	else
	{
		*pStream <<L"****N.B. This exception did NOT occur in the main Dolphin execution thread ****" << std::endl << std::endl;

		*pStream<< L"*----> CPU Context for main thread 0x" << std::hex << dwMainThreadId
					<< L" <----*" << std::endl;

		// An overlapped thread
		HANDLE hMain = Interpreter::MainThreadHandle();
		DWORD dwRet = SuspendThread(hMain);
		if (static_cast<int32_t>(dwRet) >= 0)
		{
			CONTEXT ctxMain;
			memset(&ctxMain, 0, sizeof(CONTEXT));
			ctxMain.ContextFlags = CONTEXT_FULL;
			if (::GetThreadContext(hMain, &ctxMain))
			{
				*pStream << &ctxMain << std::endl;

				::VirtualQuery(reinterpret_cast<void*>(ctxMain.Eip), &mbi, sizeof(mbi));
				hMod = HMODULE(mbi.AllocationBase);

				wcscpy_s(szModule, L"<UNKNOWN>");
				::GetModuleFileNameW(hMod, szModule, _MAX_PATH);
				*pStream<< L"In module " << hMod<< L" (" << szModule<< L")" << std::endl << std::endl;
			}
			else
				*pStream << std::endl<< L"*** Unable to access main interpter thread context (" 
					<< std::dec << GetLastError()<< L")" << std::endl;

			::ResumeThread(hMain);
		}
		else
		{
			*pStream << std::endl<< L"*** Unable to suspend main interpreter thread (" << std::dec << GetLastError()<< L")" 
						<< std::endl;
		}
	}

	*pStream << std::endl<< L"***** End of crash report *****" << std::endl << std::endl;
	pStream->flush();
}


wostream* OpenLogStream(const wchar_t* logPath, const wchar_t* achImagePath, wofstream& fStream)
{
	if (logPath == NULL || !wcslen(logPath))
	{
		// Write the dump to the errors file
		wchar_t drive[_MAX_DRIVE];
		wchar_t dir[_MAX_DIR];
		wchar_t fname[_MAX_FNAME];
		_wsplitpath_s(achImagePath, drive, _MAX_DRIVE, dir, _MAX_DIR, fname, _MAX_FNAME, NULL, 0);
		_wmakepath(achLogPath, drive, dir, fname, L".ERRORS");
		logPath = achLogPath;
	}

	trace(L"Dolphin: Writing dump to '%.260s'\n", logPath);

	wostream* pStream = NULL;
	fStream.imbue(std::locale(std::locale::empty(), new std::codecvt_utf8_utf16<wchar_t>()));
	// Open the error log for appending
	fStream.open(logPath, ios::out | ios::app | ios::ate);
	if (fStream.fail())
	{
		trace(L"Dolphin: Unable to open crash dump log '%.260s', dump follows:\n\n", logPath);
	}
	else
	{
		pStream = &fStream;
	}

	return pStream;
}

void CrashDump(const LPEXCEPTION_POINTERS pExceptionInfo, const wchar_t* imagePath)
{
	size_t nStackDepth = DefaultStackDepth;
	size_t nWalkbackDepth = DefaultWalkbackDepth;
	wostream* pStream = NULL;
	wofstream fStream;
	CRegKey rkDump;
	if (imagePath == nullptr)
		imagePath = achImagePath;
	if (OpenDolphinKey(rkDump, L"CrashDump", KEY_READ)==ERROR_SUCCESS)
	{
		achLogPath[0] = 0;
		ULONG size = _MAX_PATH;
		rkDump.QueryStringValue(L"", achLogPath, &size);
		pStream = OpenLogStream(achLogPath, imagePath, fStream);

		DWORD dwValue;
		if (rkDump.QueryDWORDValue(L"StackDepth", dwValue) == ERROR_SUCCESS && dwValue != 0)
			nStackDepth = dwValue;

		if (rkDump.QueryDWORDValue(L"WalkbackDepth", dwValue) == ERROR_SUCCESS && dwValue != 0)
			nWalkbackDepth = dwValue;
	}
	else
		pStream = OpenLogStream(nullptr, imagePath, fStream);

	CrashDump(pExceptionInfo, pStream, nStackDepth, nWalkbackDepth);
}


void __cdecl DebugCrashDump(const wchar_t* szFormat, ...)
{
	wchar_t buf[1024];

	va_list args;
	va_start(args, szFormat);
	::StringCbVPrintfW(buf, sizeof(buf), szFormat, args);
	va_end(args);

	ULONG_PTR eargs[1];
	eargs[0] = reinterpret_cast<ULONG_PTR>(&buf);
	RaiseException(static_cast<DWORD>(VMExceptions::DumpStatus), 0, 1, eargs);
}

void __stdcall Dump2(const wchar_t* szMsg, wostream* pStream, int nStackDepth, int nWalkbackDepth)
{
	if (pStream == NULL)
		pStream = &TRACESTREAM;

	*pStream << std::endl;
	EmitHeaderLine(*pStream, L"Dolphin Virtual Machine Dump Report");

	// Dump the time and message
	{
		SYSTEMTIME stNow;
		GetLocalTime(&stNow);
		*pStream << std::endl << std::endl << stNow
			<< L": " << szMsg << std::endl << std::endl;
	}

	Interpreter::DumpContext(*pStream);
	*pStream << std::endl<< L"*----> Stack Back Trace <----*" << std::endl;
	Interpreter::StackTraceOn(*pStream, NULL, nWalkbackDepth);
	Interpreter::DumpStack(*pStream, nStackDepth);

	*pStream << std::endl;
	EmitHeaderLine(*pStream, L"End of dump");
	*pStream << std::endl;

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
