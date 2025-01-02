#include "ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "regkey.h"
#include <string>
#include "ComModule.h"

using namespace std;

static constexpr WCHAR RegCLSID[] = L"CLSID";

extern HMODULE GetVMModule();

#define AUTPRXFLAG 0x4

HMODULE Module::GetHModule()
{
	return GetHModuleContaining(GetHModule);
}

HMODULE Module::GetHModuleContaining(LPCVOID pFunc)
{
	// See MSJ May 1996
	MEMORY_BASIC_INFORMATION mbi;
	::VirtualQuery(pFunc, &mbi, sizeof(mbi));
	return HMODULE(mbi.AllocationBase);
}

bool Module::IsRunningElevated() const
{
	if (!m_isElevated.has_value())
	{
		HANDLE token = NULL;
		DWORD size;
		if (!OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &token))
			return false;

		TOKEN_ELEVATION elevation = { 0 };
		GetTokenInformation(token, TokenElevation, &elevation, sizeof(elevation), &size);
		CloseHandle(token);
		m_isElevated = elevation.TokenIsElevated;
	}
	return m_isElevated.value();
}

BOOL Module::DllMain(HINSTANCE hInstance, DWORD dwReason)
{
	BOOL bSuccess = TRUE;

	switch (dwReason)
	{
	case DLL_PROCESS_ATTACH:
		bSuccess = OnProcessAttach(hInstance);
		break;

	case DLL_PROCESS_DETACH:
		bSuccess = OnProcessDetach(hInstance);
		break;

	case DLL_THREAD_ATTACH:
		bSuccess = OnThreadAttach(hInstance);
		break;

	case DLL_THREAD_DETACH:
		bSuccess = OnThreadDetach(hInstance);
		break;
	}

	return bSuccess;
}

///////////////////////////////////////////////////////////////////////////////
// Registration helper functions

RegKeyRedirect ComModule::RedirectClassesRootIfNeeded() const
{
	RegKeyRedirect userClassesRoot;
	if (!IsRunningElevated())
	{
		userClassesRoot.Redirect(HKEY_CLASSES_ROOT, HKEY_CURRENT_USER, UserClassesRoot);
	}
	return userClassesRoot;

}

HRESULT ComModule::RegisterProgID(LPCWSTR lpszCLSID, LPCWSTR lpszProgID, LPCWSTR lpszUserDesc)
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

HRESULT ComModule::RegisterCoClass(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID, LPCWSTR szDesc, DWORD dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);

	WCHAR szInProcServer[_MAX_PATH];

	// If the ModuleFileName's length is equal or greater than the 3rd parameter
	// (length of the buffer passed),GetModuleFileName fills the buffer (truncates
	// if neccessary), but doesn't null terminate it. It returns the same value as 
	// the 3rd parameter passed. So if the return value is the same as the 3rd param
	// then you have a non null terminated buffer (which may or may not be truncated)
	DWORD dwLen = ::GetModuleFileNameW(Module::GetHModule(), szInProcServer, MAX_PATH);
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
	_ASSERTE(Module::GetHModule() != GetModuleHandle(NULL));

	_ASSERTE(!(dwFlags & AUTPRXFLAG));
	status = key.SetKeyValue(L"InprocServer32", szInProcServer);
	if (status != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(status);

	_ASSERTE(dwFlags & THREADFLAGS_APARTMENT);
	status = key.SetKeyValue(L"InprocServer32", L"Apartment", L"ThreadingModel");
	if (status != ERROR_SUCCESS)
		return HRESULT_FROM_WIN32(status);

	return S_OK;
}

HRESULT ComModule::UnregisterCoClass(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID)
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

HRESULT ComModule::UpdateRegistryClass(const CLSID& clsid, LPCWSTR lpszProgID,
	LPCWSTR lpszVerIndProgID, UINT nDescID, DWORD dwFlags, BOOL bRegister)
{
	if (bRegister)
	{
		WCHAR szDesc[256];
		LoadStringW(GetHModule(), nDescID, szDesc, 256);
		return RegisterCoClass(clsid, lpszProgID, lpszVerIndProgID, szDesc, dwFlags);
	}
	return UnregisterCoClass(clsid, lpszProgID, lpszVerIndProgID);
}

HRESULT ComModule::RegisterTypeLibrary()
{
	HMODULE hModule = GetHModule();
	WCHAR szFile[_MAX_PATH + 1];
	if (!GetModuleFileName(hModule, szFile, _countof(szFile)))
	{
		DWORD dwErr = ::GetLastError();
		return HRESULT_FROM_WIN32(dwErr);
	}
	ITypeLibPtr piTypeLib;
	HRESULT hr = LoadTypeLib(szFile, &piTypeLib);
	if (FAILED(hr))
		return S_FALSE;	// Assume no typelib resource in the module, so nothing to register

	hr = IsRunningElevated()
			? RegisterTypeLib(piTypeLib, szFile, nullptr)
			: RegisterTypeLibForUser(piTypeLib, szFile, nullptr);

	return hr;
}

HRESULT ComModule::UnregisterTypeLibrary()
{
	HMODULE hModule = GetHModule();
	WCHAR szFile[_MAX_PATH + 1];
	if (!GetModuleFileName(hModule, szFile, _countof(szFile)))
	{
		DWORD dwErr = ::GetLastError();
		return HRESULT_FROM_WIN32(dwErr);
	}
	ITypeLibPtr piTypeLib;
	HRESULT hr = LoadTypeLib(szFile, &piTypeLib);
	if (FAILED(hr))
		return S_FALSE;

	TLIBATTR* pTla;
	hr = piTypeLib->GetLibAttr(&pTla);
	if (FAILED(hr))
		return hr;

	hr = IsRunningElevated()
		? UnRegisterTypeLib(pTla->guid, pTla->wMajorVerNum, pTla->wMinorVerNum, pTla->lcid, pTla->syskind)
		: UnRegisterTypeLibForUser(pTla->guid, pTla->wMajorVerNum, pTla->wMinorVerNum, pTla->lcid, pTla->syskind);

	return hr;
}
