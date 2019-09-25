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

HRESULT CDolphinVMModule::RegisterAsEventSource() const
{
	static TCHAR* szKeyStem = _T("SYSTEM\\CurrentControlSet\\Services\\EventLog\\Application\\");
	HRESULT hr;

	TCHAR szKey[512];
	_tcscpy(szKey, szKeyStem);
	_tcscat(szKey, _T("Dolphin"));

	CRegKey rkeyEvSrc;
	// Register as an event source with message table in this DLL
	LONG ret = rkeyEvSrc.Create(HKEY_LOCAL_MACHINE, szKey);
	if (ret == ERROR_SUCCESS)
	{
		TCHAR szModule[_MAX_PATH];
		::GetModuleFileName(_AtlBaseModule.GetModuleInstance(), szModule, _MAX_PATH);
		rkeyEvSrc.SetStringValue(_T("EventMessageFile"), szModule);
		rkeyEvSrc.SetDWORDValue(_T("TypesSupported"), 7);
		hr = S_OK;
	}
	else
		hr = AtlHresultFromWin32(ret);

	return hr;
}

HRESULT CDolphinVMModule::RegisterServer(BOOL bRegTypeLib) throw()
{
	HRESULT hr = CAtlModuleT<CDolphinVMModule>::RegisterServer(bRegTypeLib);

	if (SUCCEEDED(hr))
		hr = RegisterAsEventSource();

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
