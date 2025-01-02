#include "pch.h"
#include "framework.h"
#include "resource.h"
#include "ActiveXHost.h"
#include "dllmain.h"
#include "xdlldata.h"

using namespace ATL;

//////////////////////////////////////////////////////////////////
// Global Variables:

CDolphinAXHostModule _Module;

/////////////////////////////////////////////////////////////////////////////

HMODULE __stdcall GetResLibHandle()
{
	// See MSJ May 1996
	MEMORY_BASIC_INFORMATION mbi;
	::VirtualQuery(GetResLibHandle, &mbi, sizeof(mbi));
	return HMODULE(mbi.AllocationBase);
}

#ifndef _DEBUG
#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

///////////////////////////////////////////////////////////////////////////////
// Registration helper functions

HRESULT RegisterProgID(LPCTSTR lpszCLSID, LPCTSTR lpszProgID, LPCTSTR lpszUserDesc)
{
	CRegKey keyProgID;

	LONG lRes = keyProgID.Create(HKEY_CLASSES_ROOT, lpszProgID, REG_NONE, REG_OPTION_NON_VOLATILE, KEY_SET_VALUE);
	if (lRes != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(lRes);

	lRes = keyProgID.SetStringValue(NULL, lpszUserDesc);
	if (lRes != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(lRes);

	lRes = keyProgID.SetKeyValue(_T("CLSID"), lpszCLSID);
	if (lRes != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(lRes);

	return S_OK;
}

HRESULT RegisterClassHelper(const CLSID& clsid, LPCTSTR lpszProgID, LPCTSTR lpszVerIndProgID, LPCTSTR szDesc, DWORD dwFlags)
{
	USES_CONVERSION;
	UNREFERENCED_PARAMETER(dwFlags);

	static const TCHAR szProgID[] = _T("ProgID");
	static const TCHAR szVIProgID[] = _T("VersionIndependentProgID");
	static const TCHAR szIPS32[] = _T("InprocServer32");
	static const TCHAR szThreadingModel[] = _T("ThreadingModel");
	static const TCHAR szApartment[] = _T("Apartment");

	TCHAR szModule[_MAX_PATH];

	// If the ModuleFileName's length is equal or greater than the 3rd parameter
	// (length of the buffer passed),GetModuleFileName fills the buffer (truncates
	// if neccessary), but doesn't null terminate it. It returns the same value as 
	// the 3rd parameter passed. So if the return value is the same as the 3rd param
	// then you have a non null terminated buffer (which may or may not be truncated)
	DWORD dwLen = GetModuleFileName(_AtlBaseModule.m_hInst, szModule, MAX_PATH);
	if (dwLen == 0)
		return AtlHresultFromLastError();
	else if (dwLen == MAX_PATH)
		return HRESULT_FROM_WIN32(ERROR_INSUFFICIENT_BUFFER);

	LPOLESTR lpOleStr;
	HRESULT hRes = StringFromCLSID(clsid, &lpOleStr);
	if (FAILED(hRes))
		return hRes;

	LPCTSTR szClsid = OLE2T(lpOleStr);
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

	lRes = key.Open(HKEY_CLASSES_ROOT, _T("CLSID"), KEY_READ | KEY_WRITE);
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

	lRes = key.SetKeyValue(szProgID, lpszProgID);
	if (lRes != ERROR_SUCCESS)
	{
		hRes = HRESULT_FROM_WIN32(lRes);
		goto end;
	}

	lRes = key.SetKeyValue(szVIProgID, lpszVerIndProgID);
	if (lRes != ERROR_SUCCESS)
	{
		hRes = HRESULT_FROM_WIN32(lRes);
		goto end;
	}

	// Can't be an EXE
	_ASSERTE(!((_AtlBaseModule.m_hInst == NULL) || (_AtlBaseModule.m_hInst == GetModuleHandle(NULL))));

	_ASSERTE(!(dwFlags & AUTPRXFLAG));
	lRes = key.SetKeyValue(szIPS32, szModule);
	if (lRes != ERROR_SUCCESS)
	{
		hRes = HRESULT_FROM_WIN32(lRes);
		goto end;
	}

	_ASSERTE(dwFlags & THREADFLAGS_APARTMENT);
	lRes = key.SetKeyValue(szIPS32, szApartment, szThreadingModel);
	if (lRes != ERROR_SUCCESS)
	{
		hRes = HRESULT_FROM_WIN32(lRes);
		goto end;
	}

end:
	CoTaskMemFree(lpOleStr);
	return hRes;
}

HRESULT UnregisterClassHelper(const CLSID& clsid, LPCTSTR lpszProgID, LPCTSTR lpszVerIndProgID)
{
	USES_CONVERSION;
	CRegKey key;
	HRESULT hr = S_OK;

	key.Attach(HKEY_CLASSES_ROOT);
	if (lpszProgID != NULL && lpszProgID[0] != '\0')
	{
		LONG lRet = key.RecurseDeleteKey(lpszProgID);
		if (lRet != ERROR_SUCCESS && lRet != ERROR_FILE_NOT_FOUND && lRet != ERROR_PATH_NOT_FOUND)
		{
			ATLTRACE(atlTraceCOM, 0, _T("Failed to Unregister ProgID : %s\n"), lpszProgID);
			hr = HRESULT_FROM_WIN32(lRet);
		}
	}

	if (lpszVerIndProgID != NULL && lpszVerIndProgID[0] != '\0')
	{
		LONG lRet = key.RecurseDeleteKey(lpszVerIndProgID);
		if (lRet != ERROR_SUCCESS && lRet != ERROR_FILE_NOT_FOUND && lRet != ERROR_PATH_NOT_FOUND)
		{
			ATLTRACE(atlTraceCOM, 0, _T("Failed to Unregister Version Independent ProgID : %s\n"), lpszVerIndProgID);
			if (SUCCEEDED(hr)) hr = HRESULT_FROM_WIN32(lRet);
		}
	}
	LPOLESTR lpOleStr;
	HRESULT hr2 = StringFromCLSID(clsid, &lpOleStr);
	if (SUCCEEDED(hr2))
	{
		LPTSTR lpsz = OLE2T(lpOleStr);
		::CoTaskMemFree(lpOleStr);
		if (lpsz == NULL)
			return E_OUTOFMEMORY;

		LONG lRet = key.Open(key, _T("CLSID"), KEY_READ | KEY_WRITE);
		if (lRet == ERROR_SUCCESS)
			lRet = key.RecurseDeleteKey(lpsz);
		if (lRet != ERROR_SUCCESS && lRet != ERROR_FILE_NOT_FOUND && lRet != ERROR_PATH_NOT_FOUND)
		{
			ATLTRACE(atlTraceCOM, 0, _T("Failed to delete CLSID : %s\n"), lpsz);
			if (SUCCEEDED(hr)) hr = HRESULT_FROM_WIN32(lRet);
		}
	}
	else
	{
		ATLTRACE(atlTraceCOM, 0, _T("Failed to delete CLSID : {%08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x}"),
			clsid.Data1,
			clsid.Data2,
			clsid.Data3,
			clsid.Data4[0],
			clsid.Data4[1],
			clsid.Data4[2],
			clsid.Data4[3],
			clsid.Data4[4],
			clsid.Data4[5],
			clsid.Data4[6],
			clsid.Data4[7]
		);
		if (SUCCEEDED(hr)) hr = hr2;
	}
	key.Detach();
	return hr;
}

HRESULT UpdateRegistryClass(const CLSID& clsid, LPCTSTR lpszProgID,
	LPCTSTR lpszVerIndProgID, UINT nDescID, DWORD dwFlags, BOOL bRegister)
{
	if (bRegister)
	{
		TCHAR szDesc[256];
		LoadString(_AtlBaseModule.m_hInst, nDescID, szDesc, 256);
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


