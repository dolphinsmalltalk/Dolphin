#pragma once

#include <ComClassFactory.h>

class ComModuleBase
{
public:
	ComModuleBase()
	{
		Instance = this;
	}

	HRESULT DllCanUnloadNow(void)
	{
		return m_refs = 0 ? S_OK : S_FALSE;
	}

	unsigned int Lock()
	{
		return InterlockedIncrement(&m_refs);
	}

	unsigned int Unlock()
	{
		return InterlockedDecrement(&m_refs);
	}

public:
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

protected:
	//static HRESULT RegisterProgID(LPCWSTR lpszCLSID, LPCWSTR lpszProgID, LPCWSTR lpszUserDesc);
	//static HRESULT RegisterClassHelper(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID, LPCWSTR szDesc, DWORD dwFlags);
	//static HRESULT UnregisterClassHelper(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID);

private:
	unsigned int m_refs = 0;

public:
	static ComModuleBase* Instance;
};

extern HRESULT RegisterProgID(LPCWSTR lpszCLSID, LPCWSTR lpszProgID, LPCWSTR lpszUserDesc);
extern HRESULT RegisterClassHelper(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID, LPCWSTR szDesc, DWORD dwFlags);
extern HRESULT UnregisterClassHelper(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID);

#define THREADFLAGS_APARTMENT 0x1

template<typename T> class ComModule : public ComModuleBase
{
public:
	ComModule() = default;

	BOOL DllMain(HINSTANCE hInstance, DWORD dwReason)
	{
		return TRUE;
	}

	HRESULT DllRegisterServer()
	{
		return RegisterClassHelper(__uuidof(T), T::ProgId, T::VersionIndependentProgId, L"", THREADFLAGS_APARTMENT);
	}

	HRESULT DllUnregisterServer()
	{
		return UnregisterClassHelper(__uuidof(T), T::ProgId, T::VersionIndependentProgId);
	}

	HRESULT DllGetClassObject(REFCLSID rclsid, REFIID riid, void** ppv)
	{
		if (rclsid != __uuidof(T))
			return CLASS_E_CLASSNOTAVAILABLE;
		auto pFactory = new ComClassFactory<T>();
		HRESULT hr = pFactory->QueryInterface(riid, ppv);
		if (FAILED(hr))
			delete pFactory;
		return hr;
	}

	static ComModule<T>* GetInstance()
	{
		return reinterpret_cast<ComModule<T>*>(Instance);
	}
};
