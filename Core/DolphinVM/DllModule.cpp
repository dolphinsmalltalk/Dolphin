#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "regkey.h"
#include <string>

using namespace std;

static constexpr WCHAR UserClassesRoot[] = L"SOFTWARE\\Classes";
static constexpr WCHAR RegCLSID[] = L"CLSID";

///////////////////////////////////////////////////////////////////////////////
// Registration helper functions

HRESULT RegisterProgID(LPCWSTR lpszCLSID, LPCWSTR lpszProgID, LPCWSTR lpszUserDesc)
{
	RegKey keyProgID;

	LSTATUS lRes = keyProgID.Create(HKEY_CLASSES_ROOT, lpszProgID, REG_NONE, REG_OPTION_NON_VOLATILE, KEY_SET_VALUE);
	if (lRes != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(lRes);

	lRes = keyProgID.SetStringValue(NULL, lpszUserDesc);
	if (lRes != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(lRes);

	lRes = keyProgID.SetKeyValue(RegCLSID, lpszCLSID);
	if (lRes != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(lRes);

	return S_OK;
}

HRESULT RegisterClassHelper(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID, LPCWSTR szDesc, DWORD dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);

	WCHAR szModule[_MAX_PATH];

	// If the ModuleFileName's length is equal or greater than the 3rd parameter
	// (length of the buffer passed),GetModuleFileName fills the buffer (truncates
	// if neccessary), but doesn't null terminate it. It returns the same value as 
	// the 3rd parameter passed. So if the return value is the same as the 3rd param
	// then you have a non null terminated buffer (which may or may not be truncated)
	DWORD dwLen = GetModuleFileNameW(GetResLibHandle(), szModule, MAX_PATH);
	if (dwLen == 0)
		return HRESULT_FROM_WIN32(::GetLastError());
	else if (dwLen == MAX_PATH)
		return HRESULT_FROM_WIN32(ERROR_INSUFFICIENT_BUFFER);

	LPOLESTR szClsid;
	HRESULT hr = StringFromCLSID(clsid, &szClsid);
	if (FAILED(hr))
		return hr;
	CoTaskMemString clsidMem(szClsid);

	hr = RegisterProgID(szClsid, lpszProgID, szDesc);
	if (FAILED(hr)) return hr;

	hr = RegisterProgID(szClsid, lpszVerIndProgID, szDesc);
	if (FAILED(hr)) return hr;

	RegKey clsidKey;
	LSTATUS status = clsidKey.Open(HKEY_CLASSES_ROOT, RegCLSID, KEY_READ | KEY_WRITE);
	if (status != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(status);

	RegKey key;
	status = key.Create(clsidKey, szClsid, REG_NONE, REG_OPTION_NON_VOLATILE, KEY_READ | KEY_WRITE);
	if (status != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(status);

	status = key.SetStringValue(NULL, szDesc);
	if (status != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(status);

	status = key.SetKeyValue(L"ProgID", lpszProgID);
	if (status != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(status);

	status = key.SetKeyValue(L"VersionIndependentProgID", lpszVerIndProgID);
	if (status != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(status);

	// Can't be an EXE
	_ASSERTE(GetResLibHandle() != GetModuleHandle(NULL));

	_ASSERTE(!(dwFlags & AUTPRXFLAG));
	status = key.SetKeyValue(L"InprocServer32", szModule);
	if (status != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(status);

	_ASSERTE(dwFlags & THREADFLAGS_APARTMENT);
	status = key.SetKeyValue(L"InprocServer32", L"Apartment", L"ThreadingModel");
	if (status != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(status);

	return S_OK;
}

HRESULT UnregisterClassHelper(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID)
{
	RegKey hkcr(HKEY_CLASSES_ROOT);
	HRESULT hr = S_OK;

	if (lpszProgID != NULL && lpszProgID[0] != L'\0')
	{
		LONG lRet = hkcr.RecurseDeleteKey(lpszProgID);
		if (lRet != ERROR_SUCCESS && lRet != ERROR_FILE_NOT_FOUND && lRet != ERROR_PATH_NOT_FOUND)
		{
			hr = HRESULT_FROM_WIN32(lRet);
		}
	}

	if (lpszVerIndProgID != NULL && lpszVerIndProgID[0] != L'\0')
	{
		LONG lRet = hkcr.RecurseDeleteKey(lpszVerIndProgID);
		if (lRet != ERROR_SUCCESS && lRet != ERROR_FILE_NOT_FOUND && lRet != ERROR_PATH_NOT_FOUND)
		{
			if (SUCCEEDED(hr)) hr = HRESULT_FROM_WIN32(lRet);
		}
	}
	
	LPWSTR lpsz = nullptr;
	HRESULT hr2 = StringFromCLSID(clsid, &lpsz);

	if (SUCCEEDED(hr2))
	{
		CoTaskMemString clsidMem(lpsz);

		RegKey clsidKey;
		LONG lRet = clsidKey.Open(hkcr, RegCLSID , KEY_READ | KEY_WRITE);
		if (lRet == ERROR_SUCCESS)
			lRet = clsidKey.RecurseDeleteKey(lpsz);
		if (lRet != ERROR_SUCCESS && lRet != ERROR_FILE_NOT_FOUND && lRet != ERROR_PATH_NOT_FOUND)
		{
			if (SUCCEEDED(hr)) hr = HRESULT_FROM_WIN32(lRet);
		}
	}
	else
	{
		if (SUCCEEDED(hr)) hr = hr2;
	}

	return hr;
}

HRESULT UpdateRegistryClass(const CLSID& clsid, LPCWSTR lpszProgID,
	LPCWSTR lpszVerIndProgID, UINT nDescID, DWORD dwFlags, BOOL bRegister)
{
	if (bRegister)
	{
		WCHAR szDesc[256];
		LoadStringW(GetResLibHandle(), nDescID, szDesc, 256);
		return RegisterClassHelper(clsid, lpszProgID, lpszVerIndProgID, szDesc, dwFlags);
	}
	return UnregisterClassHelper(clsid, lpszProgID, lpszVerIndProgID);
}

///////////////////////////////////////////////////////////////////////////////
// Entry points

extern "C" BOOL WINAPI DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
#ifdef _MERGE_PROXYSTUB
    if (!PrxDllMain(hInstance, dwReason, lpReserved))
        return FALSE;
#endif
	hInstance;
    return _Module.DllMain(dwReason, lpReserved); 
}

__control_entrypoint(DllExport)
STDAPI DllCanUnloadNow(void)
{
	HRESULT hr;

#ifdef _MERGE_PROXYSTUB
    hr = PrxDllCanUnloadNow();
    if (FAILED(hr))
        return hr;
#endif

    hr = _Module.DllCanUnloadNow();

	#ifdef _DEBUG
	{
		if (hr == S_OK)
			OutputDebugString(_T("DllCanUnloadNow affirmative\n"));
		else
			OutputDebugString(_T("DllCanUnloadNow negative\n"));
	}
	#endif

	return hr;
}

_Check_return_
STDAPI  DllGetClassObject(_In_ REFCLSID rclsid, _In_ REFIID riid, _Outptr_ LPVOID FAR* ppv)
{
#ifdef _MERGE_PROXYSTUB
    if (PrxDllGetClassObject(rclsid, riid, ppv) == S_OK)
        return S_OK;
#endif
    return _Module.DllGetClassObject(rclsid, riid, ppv);
}

bool IsRunningElevated() 
{ 
	HANDLE token = NULL; 
	DWORD size; 
	if (!OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &token))
		return false;

	TOKEN_ELEVATION elevation = { 0 };
	GetTokenInformation(token, TokenElevation, &elevation, sizeof(elevation), &size);
	CloseHandle(token); 
	return elevation.TokenIsElevated; 
}

// DllRegisterServer - Adds entries to the system registry
STDAPI DllRegisterServer(void)
{
	// If not running elevated, redirect registration from HKCR to HKCU\SOFTWARE\Classes
	RegKeyRedirect userClassesRoot;
	if (!_Module.IsRunningElevated())
	{
		// We need this so that the typelib registration works
		ATL::AtlSetPerUserRegistration(true);

		LSTATUS status = userClassesRoot.Redirect(HKEY_CLASSES_ROOT, HKEY_CURRENT_USER, UserClassesRoot);
		if (status != ERROR_SUCCESS)
			return HRESULT_FROM_WIN32(status);
	}

	HRESULT hr;
#ifdef _MERGE_PROXYSTUB
    hr = PrxDllRegisterServer();
	if (FAILED(hr))
	{
		return hr;
	}
#endif

    // registers object, typelib and all interfaces in typelib
    hr = _Module.DllRegisterServer();

	return hr;
}


// DllUnregisterServer - Removes entries from the system registry
STDAPI DllUnregisterServer(void)
{
	RegKeyRedirect userClassesRoot;
	if (!_Module.IsRunningElevated())
	{
		ATL::AtlSetPerUserRegistration(true);
		LSTATUS status = userClassesRoot.Redirect(HKEY_CLASSES_ROOT, HKEY_CURRENT_USER, UserClassesRoot);
		if (status != ERROR_SUCCESS)
			return HRESULT_FROM_WIN32(status);
	}

	HRESULT hr;

#ifdef _MERGE_PROXYSTUB
	// First re-register proxy, in case the unregister needs to cross into ST
    hr = PrxDllRegisterServer();
	if FAILED(hr)
		return hr;
#endif

	hr = _Module.DllUnregisterServer();
#ifdef _MERGE_PROXYSTUB
    if (SUCCEEDED(hr))
	    hr = PrxDllUnregisterServer();
#endif

	return hr;
}
