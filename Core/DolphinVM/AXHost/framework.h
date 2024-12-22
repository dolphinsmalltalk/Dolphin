#pragma once

#ifndef STRICT
#define STRICT
#endif

#include "targetver.h"

#include <stdint.h>

#define UMDF_USING_NTSTATUS
#include <ntstatus.h>

#define _ATL_APARTMENT_THREADED

#define _ATL_NO_AUTOMATIC_NAMESPACE

#define _ATL_CSTRING_EXPLICIT_CONSTRUCTORS	// some CString constructors will be explicit

#define ATL_NO_ASSERT_ON_DESTROY_NONEXISTENT_WINDOW

#include "resource.h"
#include <atlbase.h>
#include <atlcom.h>
#include <atlctl.h>
#include <atltrace.h>

HMODULE __stdcall GetResLibHandle();