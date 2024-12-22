/*
============
Exports.cpp
============
Exports from the VM (mainly used by the image)
*/
							
#include "Ist.h"

#ifndef _DEBUG
	//#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "Interprt.h"

///////////////////////////////////////////////////////////////////////
//
// This little function allows us to make use of the powerful external
// call type conversion facilities!
//
__declspec(naked) uint32_t __stdcall AnswerDWORD(uint32_t /*arg*/)
{
	_asm
	{
		mov		eax, [esp+4]
		ret 4
	}
}

// Keep this as simple as possible, or the MS compiler gets horribly confused and either
// does too much work, or returns the structure in the WRONG way (which it does if we
// add a constructor by attempting to return as a >8 byte structure rather than in EAX/EDX)

__declspec(naked) uint64_t __stdcall AnswerQWORD(uint32_t /*dw1*/, uint32_t /*dw2*/)
{
	// In fact the compiler generates such crap code, we'll just do the job oursel
	_asm 
	{
		mov		eax, [esp+4]
		mov		edx, [esp+8]
		ret		8
	}
}

// In this case we get better code generation if we do use a constructor, and
// since this struct is >8 bytes long, the compiler only has one option about
// how to return it.
struct DQWORD
{
	uint32_t	m_dw1;
	uint32_t	m_dw2;
	uint32_t	m_dw3;
	uint32_t	m_dw4;

	DQWORD(uint32_t dw1, uint32_t dw2, uint32_t dw3, uint32_t dw4) :
		m_dw1(dw1), m_dw2(dw2), m_dw3(dw3), m_dw4(dw4) {}
};

DQWORD __stdcall AnswerDQWORD(uint32_t dw1, uint32_t dw2, uint32_t dw3, uint32_t dw4)
{
	return DQWORD(dw1, dw2, dw3, dw4);
}

///////////////////////////////////////////////////////////////////////////////
// As of VS2015 a number of CRT functions/variables that used to be exported 
// from the C-runtime DLL are now inlined in some way. Although in some cases 
// there are alternate exports for these, the names are convoluted and they are 
// not documented for public use. To avoid having a dependency in the image 
// that may break in future, we export these from the VM

// __argc and __argv are now macros that invoke an internal function
extern "C" int __cdecl argc()
{
	return __argc;
}

extern "C" wchar_t** __cdecl argv()
{
	return __wargv;
}

// _snprintf_s is inlined. We force a non-inline copy to export from the .def file
int (__cdecl * reifySnprintf)(char*, size_t, size_t, const char*,...) = &_snprintf_s;

// The old stdio _iob stuff is no longer supported in a compatible way. Rather than introduce
// an image side dependency on the undocumented _acrt_iob_func export, we add some simple
// exports to return each of the standard I/O streams

extern "C" FILE* __cdecl StdIn()
{
	return stdin;
}

extern "C" FILE* __cdecl StdOut()
{
	return stdout;
}

extern "C" FILE* __cdecl StdErr()
{
	return stderr;
}

// End of CRT exports
///////////////////////////////////////////////////////////////////////////////

#include "regkey.h"

static constexpr wchar_t szEventLogKeyBase[] = L"SYSTEM\\CurrentControlSet\\Services\\EventLog\\Application\\";

HRESULT RegisterEventLogMessageTable(LPCWSTR szSource)
{
	const wchar_t* szSrc = szSource;

	wchar_t szEventLogKey[256 + 1];
	szEventLogKey[256] = 0;
	wcscpy(szEventLogKey, szEventLogKeyBase);
	wcsncat_s(szEventLogKey, szSource, 256 - wcslen(szEventLogKeyBase));

	RegKey rkeyRegistered;
	LSTATUS status = rkeyRegistered.Open(HKEY_LOCAL_MACHINE, szEventLogKey, KEY_READ);
	if (status != ERROR_SUCCESS)
	{
		status = rkeyRegistered.Create(HKEY_LOCAL_MACHINE, szEventLogKey, REG_NONE, REG_OPTION_NON_VOLATILE,
			(KEY_READ | KEY_WRITE));
		if (status == ERROR_SUCCESS)
		{
			wchar_t vmFileName[MAX_PATH + 1];
			::GetModuleFileNameW(GetVMModule(), vmFileName, _countof(vmFileName) - 1);
			rkeyRegistered.SetStringValue(L"EventMessageFile", vmFileName);
			rkeyRegistered.SetDWORDValue(L"TypesSupported", (EVENTLOG_SUCCESS | EVENTLOG_ERROR_TYPE |
				EVENTLOG_WARNING_TYPE | EVENTLOG_INFORMATION_TYPE));
		}
	}

	return HRESULT_FROM_WIN32(status);
}

HRESULT UnregisterEventLogMessageTable(LPCWSTR szSource)
{
	RegKey rkeyRegistered;
	LSTATUS status = rkeyRegistered.Open(HKEY_LOCAL_MACHINE, szEventLogKeyBase, KEY_READ);
	if (status == ERROR_SUCCESS)
	{
		status = rkeyRegistered.RecurseDeleteKey(szSource);
	}
	return HRESULT_FROM_WIN32(status);
}


extern "C" HANDLE __stdcall RegisterAsEventSource(const wchar_t* szSource)
{
	const wchar_t* szSrc = FAILED(RegisterEventLogMessageTable(szSource)) ? L"Dolphin" : szSource;
	return RegisterEventSource(NULL, szSrc);
}
