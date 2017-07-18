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
__declspec(naked) DWORD __stdcall AnswerDWORD(DWORD /*arg*/)
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
struct QWORD
{
	DWORD m_dw1;
	DWORD m_dw2;
};

/*struct QWORD2 : public QWORD
{
	QWORD2(DWORD dw1, DWORD dw2) { m_dw1 = dw1; m_dw2 = dw2; }
};
*/


__declspec(naked) QWORD __stdcall AnswerQWORD(DWORD /*dw1*/, DWORD /*dw2*/)
{
	// In fact the compiler generates such crap code, we'll just do the job oursel
	_asm 
	{
		mov		eax, [esp+4]
		mov		edx, [esp+8]
		ret		8
	}

/*	QWORD answer;
	answer.m_dw1 = dw1;
	answer.m_dw2 = dw2;
	return answer;
*/
//	return QWORD2(dw1, dw2);
}

// In this case we get better code generation if we do use a constructor, and
// since this struct is >8 bytes long, the compiler only has one option about
// how to return it.
struct DQWORD
{
	DWORD	m_dw1;
	DWORD	m_dw2;
	DWORD	m_dw3;
	DWORD	m_dw4;

	DQWORD(DWORD dw1, DWORD dw2, DWORD dw3, DWORD dw4) :
		m_dw1(dw1), m_dw2(dw2), m_dw3(dw3), m_dw4(dw4) {}
};

DQWORD __stdcall AnswerDQWORD(DWORD dw1, DWORD dw2, DWORD dw3, DWORD dw4)
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

extern "C" char** __cdecl argv()
{
	return __argv;
}

// Temporary until Dolphin code updated to use _snprintf_s
void* reify_snprintf = &_snprintf;

// _snprintf_s is inlined. We force a non-inline copy to export from the .def file
int (__cdecl * reify_snprintf_s)(char*, size_t, size_t, const char*,...) = &_snprintf_s;

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

///////////////////////////////////////////////////////////////////////////////
// Version Helper functions

#include <VersionHelpers.h>

void* reifyIsWindowsVersionOrGreater = &IsWindowsVersionOrGreater;
// Don't bother with the XP functions as we don't support Windows versions prior to Vista any more
void* reifyIsWindowsXPOrGreater = &IsWindowsXPOrGreater;
void* reifyIsWindowsXPSP1OrGreater = &IsWindowsXPSP1OrGreater;
void* reifyIsWindowsXPSP2OrGreater = &IsWindowsXPSP2OrGreater;
void* reifyIsWindowsXPSP3OrGreater = &IsWindowsXPSP3OrGreater;
void* reifyIsWindowsVistaOrGreater = &IsWindowsVistaOrGreater;
void* reifyIsWindowsVistaSP1OrGreater = &IsWindowsVistaSP1OrGreater;
void* reifyIsWindowsVistaSP2OrGreater = &IsWindowsVistaSP2OrGreater;
void* reifyIsWindows7OrGreater = &IsWindows7OrGreater;
void* reifyIsWindows7SP1OrGreater = &IsWindows7SP1OrGreater;
void* reifyIsWindows8OrGreater = &IsWindows8OrGreater;
void* reifyIsWindows8Point1OrGreater = &IsWindows8Point1OrGreater;
void* reifyIsWindowsThresholdOrGreater = &IsWindowsThresholdOrGreater;
void* reifyIsWindows10OrGreater = &IsWindows10OrGreater;
void* reifyIsWindowsServer= &IsWindowsServer;

// End of Version Helpers
///////////////////////////////////////////////////////////////////////////////

#include <atlbase.h>

extern "C" HANDLE __stdcall RegisterAsEventSource(const char* szSource)
{
	const char* szSrc = szSource;
	static const char* szEventLogKeyBase = "SYSTEM\\CurrentControlSet\\Services\\EventLog\\Application\\";
	
	char szEventLogKey[256+1];
	szEventLogKey[256] = 0;
	strcpy(szEventLogKey, szEventLogKeyBase);
	strncat_s(szEventLogKey, szSource, 256-strlen(szEventLogKeyBase));

	CRegKey rkeyRegistered;
	if (rkeyRegistered.Open(HKEY_LOCAL_MACHINE, szEventLogKey, KEY_READ) != ERROR_SUCCESS)
	{
		if (rkeyRegistered.Create(HKEY_LOCAL_MACHINE, szEventLogKey, REG_NONE, REG_OPTION_NON_VOLATILE,
									(KEY_READ|KEY_WRITE)) == ERROR_SUCCESS)
		{
			char vmFileName[MAX_PATH+1];
			::GetModuleFileName(_AtlBaseModule.GetModuleInstance(), vmFileName, sizeof(vmFileName) - 1);
			rkeyRegistered.SetStringValue("EventMessageFile", vmFileName);
			rkeyRegistered.SetDWORDValue("TypesSupported", (EVENTLOG_SUCCESS|EVENTLOG_ERROR_TYPE|
												EVENTLOG_WARNING_TYPE|EVENTLOG_INFORMATION_TYPE));
		}
		else
			szSrc = "Dolphin";
	}


	return RegisterEventSource(NULL, szSrc);
}
