// VMDLL.cpp : Implementation of DLL Exports, etc.

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "ist.h"
#include <initguid.h>
#include "DolphinSmalltalk.h"
#include "VMDll.h"
#include "dlldatax.h"
#include "regkey.h"

#pragma code_seg(ATL_SEG)

#include "DolphinSmalltalk_i.c"

#ifndef VMDLL
#error "This file is part of the VM DLL"
#endif

/////////////////////////////////////////////////////////////////////////////
// Globals

CDolphinVMModule _Module;

/////////////////////////////////////////////////////////////////////////////
// Registration helper

extern HRESULT RegisterEventLogMessageTable(LPCWSTR szSource);

static constexpr wchar_t EventLogKeyName[] = L"Dolphin";

HRESULT CDolphinVMModule::RegisterServer(BOOL bRegTypeLib) throw()
{
	HRESULT hr = __super::RegisterServer(bRegTypeLib);

	if (SUCCEEDED(hr) && IsRunningElevated())
		hr = RegisterEventLogMessageTable(EventLogKeyName);

	return hr;
}

extern HRESULT UnregisterEventLogMessageTable(LPCWSTR szSource);

HRESULT CDolphinVMModule::UnregisterServer(BOOL bRegTypeLib) throw()
{
	HRESULT hr = __super::RegisterServer(bRegTypeLib);

	if (SUCCEEDED(hr) && IsRunningElevated())
		hr = UnregisterEventLogMessageTable(EventLogKeyName);

	return hr;
}

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
