#pragma once

#include <ComClassFactory.h>
#include <optional>
#include <regkey.h>

class Module
{
public:
	Module()
	{
		Instance = this;
	}

	bool CanUnloadNow() const
	{
		return m_nLocks == 0;
	}

	unsigned int Lock()
	{
		return InterlockedIncrement(&m_nLocks);
	}

	unsigned int Unlock()
	{
		return InterlockedDecrement(&m_nLocks);
	}

	unsigned int GetLockCount() const
	{
		return m_nLocks;
	}

	BOOL DllMain(HINSTANCE hInstance, DWORD dwReason);

	static HMODULE GetHModule();
	static HMODULE GetHModuleContaining(LPCVOID pFunc);

public:
	bool IsRunningElevated() const;


protected:
	virtual BOOL OnProcessAttach(HINSTANCE hInst)	{ return TRUE; }
	virtual BOOL OnProcessDetach(HINSTANCE hInst)	{ return TRUE; }
	virtual BOOL OnThreadAttach(HINSTANCE hInst)	{ return TRUE; }
	virtual BOOL OnThreadDetach(HINSTANCE hInst)	{ return TRUE; }

private:
	unsigned int m_nLocks = 0;
	mutable std::optional<bool> m_isElevated;

public:
	static Module* Instance;
};

__declspec(selectany) Module* Module::Instance;
constexpr WCHAR UserClassesRoot[] = L"SOFTWARE\\Classes";

class ComModule : public Module
{
public:
	RegKeyRedirect RedirectClassesRootIfNeeded() const;
	HRESULT RegisterProgID(LPCWSTR lpszCLSID, LPCWSTR lpszProgID, LPCWSTR lpszUserDesc);
	HRESULT RegisterCoClass(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID, LPCWSTR szDesc, DWORD dwFlags);
	HRESULT UnregisterCoClass(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID);
	HRESULT UpdateRegistryClass(const CLSID& clsid, LPCWSTR lpszProgID, LPCWSTR lpszVerIndProgID, UINT nDescID, DWORD dwFlags, BOOL bRegister);
	HRESULT RegisterTypeLibrary();
	HRESULT UnregisterTypeLibrary();
};

HRESULT RegisterEventLogMessageTable(LPCWSTR szSource);
HRESULT UnregisterEventLogMessageTable(LPCWSTR szSource);

#define THREADFLAGS_APARTMENT 0x1

template<typename T> class ComModuleT : public ComModule
{
public:
	ComModuleT() = default;

	HRESULT RegisterServer()
	{
		HRESULT hr;
		if constexpr (T::RegistrationDetails::ProgId) {
			HRESULT hr = RegisterCoClass(__uuidof(T), T::RegistrationDetails::ProgId, T::RegistrationDetails::VersionIndependentProgId, L"", THREADFLAGS_APARTMENT);
			if (FAILED(hr))
				return hr;
		}

		hr = RegisterTypeLibrary();

		if constexpr (T::RegistrationDetails::EventLogKey) {
			if (IsRunningElevated())
				hr = RegisterEventLogMessageTable(T::RegistrationDetails::EventLogKey);
		}
		return hr;
	}

	HRESULT UnregisterServer()
	{
		HRESULT hr;
		if constexpr (T::RegistrationDetails::ProgId) {
			hr = UnregisterCoClass(__uuidof(T), T::RegistrationDetails::ProgId, T::RegistrationDetails::VersionIndependentProgId);
			if (FAILED(hr))
				return hr;
		}

		hr = UnregisterTypeLibrary();

		if constexpr (T::RegistrationDetails::EventLogKey) {
			if (IsRunningElevated())
				hr = UnregisterEventLogMessageTable(T::RegistrationDetails::EventLogKey);
		}
		return hr;
	}

	HRESULT GetClassObject(REFCLSID rclsid, REFIID riid, void** ppv)
	{
		if (rclsid != __uuidof(T))
			return CLASS_E_CLASSNOTAVAILABLE;
		auto pFactory = new ComClassFactory<T>();
		HRESULT hr = pFactory->QueryInterface(riid, ppv);
		if (FAILED(hr))
			delete pFactory;
		return hr;
	}

	static ComModuleT<T>* GetInstance()
	{
		return reinterpret_cast<ComModuleT<T>*>(Instance);
	}
};
