/******************************************************************************

	File: Ist.h

	Description:

	Dolphin Smalltalk precompiled header file

******************************************************************************/
#pragma once

// Prevent executable bloat caused by aligning all sections on 4k boundaries.
// Note that this doesn't actually prevent the exe/dll loading on Win9X, but
// theoretically makes it slightly slower to load. Frankly this is not likely
// to be noticeable in practice, certainly not for the very small stub files.
// This means that instead of being bloated to 32Kb, the stubs are a more
// reasonable 13Kb. For VC.Net this needs to be set as a linker option on the
// project, as the #pragma comment is not ignored.
#if _MSC_VER < 1300
#pragma comment(linker, "/OPT:NOWIN98")
#endif

#if defined(VMDLL) && defined(TO_GO)
	#error("Project config is incompatible (TO_GO and VM are mutually exclusive)")
#endif

#if defined(VMDLL) || defined(TO_GO)
	#define VM 1
#endif

#if defined(VMDLL)
	#define CANSAVEIMAGE 1
#endif

// Enable templated overloads for secure version of old-style CRT functions that manipulate buffers but take no size arguments

#undef _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES
#define _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES 1
#undef _CRT_SECURE_CPP_OVERLOAD_SECURE_NAMES
#define _CRT_SECURE_CPP_OVERLOAD_SECURE_NAMES 1 

// Prevent redefinition of QWORD type in <windns.h>
#define _WINDNS_INCLUDED_

// Prevent warning of redefinition of WIN32_LEAN_AND_MEAN in atldef.h
#define ATL_NO_LEAN_AND_MEAN

#define UMDF_USING_NTSTATUS

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/timeb.h>
#include <float.h>
#include <io.h>
#include <fcntl.h>
#include <string.h>
#include <stddef.h>
#include <stdlib.h>

#pragma warning(disable:4711)	// Function selected for automatic inline expansion
#pragma warning(disable:4786)	// Browser identifier truncated to 255 characters

#pragma warning(push,3)
// Disable warning about exception handling (we compile with exception handling disabled)
#pragma warning (disable:4530)
#include <ppl.h>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>
#include <streambuf>
#include <unordered_map>
#include <vector>
#pragma warning(pop)
#include <functional>

typedef _Return_type_success_(return >= 0) int32_t NTSTATUS;
#define NTSTATUS_DEFINED
#define _NTDEF_

#include "Environ.h"

// The basic word size of the machine
typedef intptr_t 	SmallInteger;	// Optimized SmallInteger; same size as machine word. Known to be representable as a Smalltalk SmallInteger (i.e. 31-bits 2's complement)
typedef uintptr_t	SmallUinteger;	// Unsigned optimized SmallInteger; same size as machine word
typedef uintptr_t	Oop;

class ObjectMemory;
class Interpreter;

/*
 * Macros to round numbers (borrowed from CRT)
 *
 * _ROUND2 = rounds a number up to a power of 2
 * _ROUND = rounds a number up to any other numer
 *
 * n = number to be rounded
 * pow2 = must be a power of two value
 * r = any number
 */

#define _ROUND2(n,pow2) \
        ( ( (n) + (pow2) - 1) & ~((pow2) - 1) )

#define _ROUND(n,r) \
        ( ( ((n)/(r)) + (((n)%(r))?1:0) ) * (r))

HMODULE __stdcall GetResLibHandle();
HINSTANCE GetApplicationInstance();
void DolphinExitInstance();
HMODULE GetModuleContaining(LPCVOID);

#include "CritSect.h"
extern CMonitor traceMonitor;

#define TRACELOCK()	CAutoLock<tracestream> lock(TRACESTREAM)

std::wstring __stdcall GetErrorText(DWORD win32ErrorCode);
std::wstring __stdcall GetLastErrorText();
LPCWSTR GetResourceString(HMODULE hMod, int resId, int& length);
int __cdecl DolphinMessageBox(int idPrompt, UINT flags, ...);
void __cdecl trace(const wchar_t* szFormat, ...);
void __cdecl trace(int nPrompt, ...);
void __cdecl DebugCrashDump(const wchar_t* szFormat, ...);
void __cdecl DebugDump(const wchar_t* szFormat, ...);
void CrashDump(const LPEXCEPTION_POINTERS pExInfo, const wchar_t* achImagePath);
HRESULT __cdecl ReportError(int nPrompt, ...);
HRESULT __cdecl ReportWin32Error(int nPrompt, DWORD errorCode, LPCWSTR arg = NULL);
__declspec(noreturn) void __cdecl RaiseFatalError(int nCode, int nArgs, ...);
__declspec(noreturn) void __stdcall FatalException(const EXCEPTION_RECORD& exRec);
__declspec(noreturn) void __stdcall FatalSystemException(const LPEXCEPTION_POINTERS exInfo);
__declspec(noreturn) void __stdcall FatalError(int exitCode, ...);
__declspec(noreturn) void __stdcall DolphinFatalExit(int exitCode, const wchar_t* msg);
__declspec(noreturn) void __stdcall DolphinExit(int nExitCode);
extern wchar_t achLogPath[_MAX_PATH + 1];
extern wchar_t achImagePath[_MAX_PATH + 1];
HMODULE GetVMModule();
BOOL __stdcall GetVersionInfo(VS_FIXEDFILEINFO* lpInfoOut);
HMODULE GetModuleContaining(LPCVOID pFunc);

#include <unknwn.h>
#include "segdefs.h"

#ifdef _CONSOLE
#define _ATL_NO_COM_SUPPORT
#endif

#pragma warning(push,3)
#include <icu.h>
#include <intrin.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <limits.h>
#include <fpieee.h>
#include <stdarg.h>
#include <setjmp.h>
#include <float.h>
#include <process.h>
#include <wtypes.h>
#include <winbase.h>
#include <winreg.h>
#include <winerror.h>
#include <CommCtrl.h>
#include <Strsafe.h>
#include <VersionHelpers.h>
#include <comdef.h>
#include <oaidl.h>
#include <ntstatus.h>
#pragma warning(pop)

#if defined(_DEBUG)
#include <crtdbg.h>
#endif

// determine number of elements in an array (not bytes)
#ifndef _countof
#define _countof(array) (sizeof(array)/sizeof(array[0]))
#endif

#ifdef _M_X64
#define OOPSIZE 8
#define PORT64(s) #error(s)
#else
#define OOPSIZE 4
#define PORT64(s)
#endif
