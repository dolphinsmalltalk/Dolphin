/******************************************************************************

	File: AxHost.h

	Description:

	Dolphin Smalltalk Active-X Control Host header file

******************************************************************************/
#pragma once

#define _ATL_ALL_WARNINGS
#include <atlbase.h>

// Disable "conditional expression is constant coming from ATL header files
#pragma warning(push)
#pragma warning(disable:4127)
#define _ATLWIN_IMPL
// disable "\mshtml.h(37492): warning BK4504: file contains too many references; ignoring further references from this source"
#pragma component(browser, off, references)
#include <atlwin.h>
#pragma component(browser, on, references)
#pragma warning(pop)

#undef ATLAPI
#define ATLAPI extern "C" HRESULT __stdcall
#undef ATLAPI_
#define ATLAPI_(x) extern "C" x __stdcall
#undef ATLINLINE
#define ATLINLINE
#include <atliface.h>

#if _MSC_VER < 1300
	#define _ATLHOST_IMPL
#endif

#include "atlhost.h"

#include "ActiveXHost.h"
#include "ActiveXHost_i.c"

#pragma code_seg()

