#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

///////////////////////////////////////////////////////////////////////////////
// Registration helper functions

HRESULT RegisterProgID(LPCWSTR lpszCLSID, LPCWSTR lpszProgID, LPCWSTR lpszUserDesc)
{
	CRegKey keyProgID;

	LONG lRes = keyProgID.Create(HKEY_CLASSES_ROOT, lpszProgID, REG_NONE, REG_OPTION_NON_VOLATILE, KEY_SET_VALUE);
	if (lRes != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(lRes);

	lRes = keyProgID.SetStringValue(NULL, lpszUserDesc);
	if (lRes != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(lRes);

	lRes = keyProgID.SetKeyValue(L"CLSID", lpszCLSID);
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

	LPWSTR szClsid;
	HRESULT hRes = StringFromCLSID(clsid, &szClsid);
	if (FAILED(hRes))
		return hRes;

	CRegKey key;
	LONG lRes = 0;

	hRes = RegisterProgID(szClsid, lpszProgID, szDesc);
	if (FAILED(hRes))
	{
		goto end;
	}

	hRes = RegisterProgID(szClsid, lpszVerIndProgID, szDesc);
	if (FAILED(hRes))
	{
		goto end;
	}

	lRes = key.Open(HKEY_CLASSES_ROOT, L"CLSID", KEY_READ | KEY_WRITE);
	if (lRes != ERROR_SUCCESS)
	{
		hRes = HRESULT_FROM_WIN32(lRes);
		goto end;
	}

	lRes = key.Create(key, szClsid, REG_NONE, REG_OPTION_NON_VOLATILE, KEY_READ | KEY_WRITE);
	if (lRes != ERROR_SUCCESS)
	{
		hRes = HRESULT_FROM_WIN32(lRes);
		goto end;
	}

	lRes = key.SetStringValue(NULL, szDesc);
	if (lRes != ERROR_SUCCESS)
	{
		hRes = HRESULT_FROM_WIN32(lRes);
		goto end;
	}

	lRes = key.SetKeyValue(L"ProgID", lpszProgID);
	if (lRes != ERROR_SUCCESS)
	{
		hRes = HRESULT_FROM_WIN32(lRes);
		goto end;
	}

	lRes = key.SetKeyValue(L"VersionIndependentProgID", lpszVerIndProgID);
	if (lRes != ERROR_SUCCESS)
	{
		hRes = HRESULT_FROM_WIN32(lRes);
		goto end;
	}

	// Can't be an EXE
	_ASSERTE(GetResLibHandle() != GetModuleHandle(NULL));

	_ASSERTE(!(dwFlags & AUTPRXFLAG));
	lRes = key.SetKeyValue(L"InprocServer32", szModule);
	if (lRes != ERROR_SUCCESS)
	{
		hRes = HRESULT_FROM_WIN32(lRes);
		goto end;
	}

	_ASSERTE(dwFlags & THREADFLAGS_APARTMENT);
	lRes = key.SetKeyValue(L"InprocServer32", L"Apartment", L"ThreadingModel");
	if (lRes != ERROR_SUCCESS)
	{
		hRes = HRESULT_FROM_WIN32(lRes);
		goto end;
	}

end:
	CoTaskMemFree(szClsid);
	return hRes;
}

HRESULT UnregisterClassHelper(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID)
{
	CRegKey key;
	HRESULT hr = S_OK;

	key.Attach(HKEY_CLASSES_ROOT);
	if (lpszProgID != NULL && lpszProgID[0] != '\0')
	{
		LONG lRet = key.RecurseDeleteKey(lpszProgID);
		if (lRet != ERROR_SUCCESS && lRet != ERROR_FILE_NOT_FOUND && lRet != ERROR_PATH_NOT_FOUND)
		{
			hr = HRESULT_FROM_WIN32(lRet);
		}
	}

	if (lpszVerIndProgID != NULL && lpszVerIndProgID[0] != '\0')
	{
		LONG lRet = key.RecurseDeleteKey(lpszVerIndProgID);
		if (lRet != ERROR_SUCCESS && lRet != ERROR_FILE_NOT_FOUND && lRet != ERROR_PATH_NOT_FOUND)
		{
			if (SUCCEEDED(hr)) hr = HRESULT_FROM_WIN32(lRet);
		}
	}
	LPWSTR lpsz = nullptr;
	HRESULT hr2 = StringFromCLSID(clsid, &lpsz);
	if (SUCCEEDED(hr2))
	{
		LONG lRet = key.Open(key, L"CLSID", KEY_READ | KEY_WRITE);
		if (lRet == ERROR_SUCCESS)
			lRet = key.RecurseDeleteKey(lpsz);
		if (lRet != ERROR_SUCCESS && lRet != ERROR_FILE_NOT_FOUND && lRet != ERROR_PATH_NOT_FOUND)
		{
			if (SUCCEEDED(hr)) hr = HRESULT_FROM_WIN32(lRet);
		}
	}
	else
	{
		if (SUCCEEDED(hr)) hr = hr2;
	}
	if (lpsz)
	{
		::CoTaskMemFree(lpsz);
	}
	key.Detach();
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

// DllRegisterServer - Adds entries to the system registry
STDAPI DllRegisterServer(void)
{
	HRESULT hr;
#ifdef _MERGE_PROXYSTUB
    hr = PrxDllRegisterServer();
	if (FAILED(hr))
        return hr;
#endif
    // registers object, typelib and all interfaces in typelib
    hr = _Module.DllRegisterServer();

	return hr;
}


// DllUnregisterServer - Removes entries from the system registry
STDAPI DllUnregisterServer(void)
{
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
