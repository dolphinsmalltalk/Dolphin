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
#define _HAS_ITERATOR_DEBUGGING 0

// Enable templated overloads for secure version of old-style CRT functions that manipulate buffers but take no size arguments
#define _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES 1
#define _CRT_SECURE_CPP_OVERLOAD_SECURE_NAMES 1 

#define _ATL_APARTMENT_THREADED

#define _ATL_ALL_WARNINGS
#include <atlbase.h>
#include <atlcom.h>

#include "..\DolphinSmalltalk_i.h"

#include <limits.h>
#include <malloc.h>
#include <stdlib.h>
#include <stdarg.h>
#include <locale.h>
#include <Strsafe.h>
#include <icu.h>

#define TODO(s)

#ifdef _DEBUG
	#define _CRTDBG_MAP_ALLOC
	#define DEBUG_ONLY
	#define TRACE				::DolphinTrace
	#define VERIFY				_ASSERTE
	#define INLINE				inline
#else
	#include <crtdbg.h>
	#define DEBUG_ONLY(f)      ((void)0)
	#define TRACE				1 ? ((void)0) : ::DolphinTrace
	#define VERIFY
	#define INLINE				__forceinline
#endif

#include <vector>
#include <iostream>
#include <iomanip>
