// VMDLL.cpp : Implementation of DLL Exports, etc.

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "ist.h"
#ifndef _NTDEF_
	typedef _Return_type_success_(return >= 0) int32_t NTSTATUS;
	#define _NTDEF_
#endif
#include <initguid.h>
#include "DolphinSmalltalk.h"
#include "VMModule.h"
#include "dlldatax.h"
#include "regkey.h"

//#pragma code_seg(ATL_SEG)

#include "DolphinSmalltalk_i.c"

#ifndef VMDLL
#error "This file is part of the VM DLL"
#endif

/////////////////////////////////////////////////////////////////////////////
// Globals

VMModule _Module;

///////////////////////////////////////////////////////////////////////////////
// Common entry points

#include "DllModule.cpp"

///////////////////////////////////////////////////////////////////////////////
// Other common functions

HMODULE __stdcall GetResLibHandle()
{
	extern HMODULE GetVMModule();
	return GetVMModule();
}

#pragma code_seg(INIT_SEG)

HINSTANCE GetApplicationInstance()
{
	extern HINSTANCE hApplicationInstance;
	return hApplicationInstance;
}
