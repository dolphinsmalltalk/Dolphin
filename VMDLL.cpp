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

HRESULT CDolphinVMModule::RegisterServer(BOOL bRegTypeLib)
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

HWND __stdcall DisplayDesktopMessage(LPCSTR szMessage)
{
	HDC dc = GetWindowDC(GetDesktopWindow());
	HFONT font = CreateFont(-16, 0, 0,
			0, FW_BOLD, FALSE, FALSE, FALSE, ANSI_CHARSET,
			OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH, 
			"Arial");
	int x = GetDeviceCaps(dc, HORZRES) / 2;
	int y = GetDeviceCaps(dc, VERTRES) / 2;
	font = (HFONT)SelectObject(dc, font);
	SetBkColor(dc, 0xFF0000);
	SetTextColor(dc, 0xFFFFFF);
	SetTextAlign(dc, (TA_CENTER|TA_BASELINE));
	TextOut(dc, x, y, szMessage, strlen(szMessage));
	font = (HFONT)SelectObject(dc, font);
	DeleteObject(font);
	ReleaseDC(GetDesktopWindow(), dc);

	return NULL;
}

void __stdcall RemoveDesktopMessage(HWND)
{
	InvalidateRect(NULL, NULL, TRUE);
}


#pragma code_seg(INIT_SEG)

HINSTANCE GetApplicationInstance()
{
	extern HINSTANCE hApplicationInstance;
	return hApplicationInstance;
}
