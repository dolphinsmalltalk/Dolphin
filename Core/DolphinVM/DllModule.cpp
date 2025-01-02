#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "regkey.h"
#include "ComModule.h"

///////////////////////////////////////////////////////////////////////////////
// Entry points

extern "C" BOOL WINAPI DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
#ifdef _MERGE_PROXYSTUB
    if (!PrxDllMain(hInstance, dwReason, lpReserved))
        return FALSE;
#endif

	return _Module.DllMain(hInstance, dwReason);
}

__control_entrypoint(DllExport)
STDAPI DllCanUnloadNow(void)
{
#ifdef _MERGE_PROXYSTUB
    HRESULT hr = PrxDllCanUnloadNow();
    if (FAILED(hr))
        return hr;
	return hr == S_OK && _Module.CanUnloadNow() ? S_OK : S_FALSE;
#else
	return _Module.CanUnloadNow() ? S_OK : S_FALSE;
#endif
}

_Check_return_
STDAPI  DllGetClassObject(_In_ REFCLSID rclsid, _In_ REFIID riid, _Outptr_ LPVOID FAR* ppv)
{
#ifdef _MERGE_PROXYSTUB
    if (PrxDllGetClassObject(rclsid, riid, ppv) == S_OK)
        return S_OK;
#endif
    return _Module.GetClassObject(rclsid, riid, ppv);
}

// DllRegisterServer - Adds entries to the system registry
STDAPI DllRegisterServer(void)
{
	// If not running elevated, redirect registration from HKCR to HKCU\SOFTWARE\Classes
	RegKeyRedirect userClassesRoot = _Module.RedirectClassesRootIfNeeded();
	HRESULT hr;

#ifdef _MERGE_PROXYSTUB
    hr = PrxDllRegisterServer();
	if (FAILED(hr))
	{
		return hr;
	}
#endif

    // registers object, typelib and all interfaces in typelib
    hr = _Module.RegisterServer();

	return hr;
}


// DllUnregisterServer - Removes entries from the system registry
STDAPI DllUnregisterServer(void)
{
	RegKeyRedirect userClassesRoot = _Module.RedirectClassesRootIfNeeded();
	HRESULT hr;

#ifdef _MERGE_PROXYSTUB
	// First re-register proxy, in case the unregister needs to cross into ST
    hr = PrxDllRegisterServer();
	if FAILED(hr)
		return hr;
#endif

	hr = _Module.UnregisterServer();
#ifdef _MERGE_PROXYSTUB
    if (SUCCEEDED(hr))
	    hr = PrxDllUnregisterServer();
#endif

	return hr;
}
