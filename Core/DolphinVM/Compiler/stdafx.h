#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef STRICT
	#define STRICT
#endif

#if _MSC_VER < 1300
#pragma comment(linker, "/OPT:NOWIN98")
#endif

#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0A000004
#endif

// Turn off iterator debugging as it makes the compiler very slow on large methods in debug builds
//#define _HAS_ITERATOR_DEBUGGING 0

// Enable templated overloads for secure version of old-style CRT functions that manipulate buffers but take no size arguments
#define _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES 1
#define _CRT_SECURE_CPP_OVERLOAD_SECURE_NAMES 1 

#define UMDF_USING_NTSTATUS
#include <ntstatus.h>

#include <limits.h>
#include <stdarg.h>
#include <locale.h>
#include <Strsafe.h>
#include <stdlib.h>
#include "heap.h"

#include "..\DolphinSmalltalk_i.h"

#include <icu.h>

#define TODO(s)

#ifdef _DEBUG
	//#define _CRTDBG_MAP_ALLOC
	#include <crtdbg.h>
	#define DEBUG_ONLY
	#define TRACE				::DolphinTrace
	#define VERIFY				_ASSERTE
	#define INLINE				inline
	#define ASSERT				_ASSERTE
#else
	#include <crtdbg.h>
	#define DEBUG_ONLY(f)      ((void)0)
	#define TRACE				1 ? ((void)0) : ::DolphinTrace
	#define VERIFY
	#define INLINE				__forceinline
	#define ASSERT(e)			(__assume(e))
#endif

#include <vector>
#include <iostream>
#include <iomanip>
#include <string>

using namespace std;
