/******************************************************************************

	File: Environ.h

	Description:

	Portable environment definitions for Dolphin Smalltalk

******************************************************************************/
#pragma once

#define TODO(s)

// TODO: This actuall seems to have no effect in VS2017, and maybe earlier. The result is slow indirect calls when using /MD as we do for the VM.
#pragma intrinsic(memcpy,memset,strlen)

#ifdef WIN32
	#pragma warning(push, 3)

	#ifndef STRICT
	#define STRICT
	#endif

	// Modify the following defines if you have to target a platform prior to the ones specified below.
	// Refer to MSDN for the latest info on corresponding values for different platforms.
	#ifndef WINVER				// Allow use of features specific to Windows 10 and later. This does not mean the VM will only run on Windows 10.
	#define WINVER 0x0A00
	#endif

	#ifndef _WIN32_WINNT		
	#define _WIN32_WINNT WINVER
	#endif						

	#ifndef _WIN32_WINDOWS
	#define _WIN32_WINDOWS WINVER
	#endif

	#ifndef _WIN32_IE
	#define _WIN32_IE 0x0500	// Target IE 5.0 or later.
	#endif

	// Define some things for ATL, in case there is any in this project

	#define _ATL_CSTRING_EXPLICIT_CONSTRUCTORS	// some CString constructors will be explicit

	// turns off ATL's hiding of some common and often safely ignored warning messages
	#define _ATL_ALL_WARNINGS

	//#pragma warning ( disable : 4244 4514 4201 )
	// 4705 statement has no effect

	#include <windows.h>
	#include <winver.h>
	#include <mmsystem.h>
	#include <ntstatus.h>

	#undef LoadImage

	#pragma warning(pop)

	#ifndef VM
		// Compiler part of .exe versions, so null out the imports of the DolphinIF functions
		#define _DOLPHINIMPORT extern
	#endif

	#include "TraceStream.h"

	extern tracestream thinDump;
	#define TRACESTREAM thinDump

	#ifdef _DEBUG
		#define _CRTDBG_MAP_ALLOC
		#ifndef DEBUG_ONLY
			#define DEBUG_ONLY
		#endif
		#undef TRACE
		#define TRACE				::trace
		#ifndef VERIFY
			#define VERIFY				_ASSERTE
		#endif	
	#else
		#include <crtdbg.h>
		#define DEBUG_ONLY(f)      ((void)0)
		inline void __cdecl DolphinTrace(LPCTSTR, ...)  {}
		#define TRACE				1 ? ((void)0) : ::trace
		#define VERIFY
	#endif
		
	#include <crtdbg.h>

	#ifdef DEBUG
		#define ASSUME		_ASSERTE
	#else
		// VC6 optimization
		#define ASSUME(e)    (__assume(e))
	#endif

	#ifndef ASSERT_VALID
		#define ASSERT_VALID(pOb)  ((void)0)
	#endif

	#ifdef _M_IX86
		#define	DEBUGBREAK()			{ _asm int 3 }
	#else
		#define DEBUGBREAK()			DebugBreak()
	#endif

	#ifdef DEBUG
		#ifndef ASSERT
			#define ASSERT		_ASSERTE
		#endif
	#else
		// VC6 optimization
		#undef ASSERT
		#define ASSERT    __assume
	#endif

	#ifdef _DEBUG
		#define HARDASSERT(e)		{ if (!(e)) { DEBUGBREAK(); } }
	#else
		#define	HARDASSERT(e)		((void)0)
	#endif

	#undef assert
	#define assert(e)		{ if (!(e)) { DEBUGBREAK(); } }

	constexpr size_t dwPageSize = 0x1000;						// 4Kb
	constexpr size_t dwAllocationGranularity = 0x10000;			// 64Kb

#else
	#error "Not implemented for other platforms yet"
#endif

#pragma warning (disable : 4201)
