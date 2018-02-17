// startVM.cpp

#include "ist.h"

#if defined(USE_VM_DLL)

#include <process.h>
#include <io.h>
#include "startVM.h"
#include "DolphinSmalltalk_i.h"
#include "VMExcept.h"


/////////////////////////////////////////////////////////////////////////////
// Globals

/////////////////////////////////////////////////////////////////////

typedef HRESULT (STDAPICALLTYPE *GETCLASSOBJPROC)(REFCLSID rclsid, REFIID riid, LPVOID* ppv);

static HRESULT LoadAndCreateVM(const CLSID* pVMCLSID, LPCSTR pszVM, const IID& iid, void** ppiDolphin)
{
	*ppiDolphin = NULL;

	// Try and register it
	HINSTANCE hLib = ::LoadLibrary(pszVM);
	HRESULT hr = HRESULT_FROM_WIN32(ERROR_NOT_FOUND);
	if (hLib)
	{
		//::trace("Loaded Dolphin VM: %s\n", pszVM);

		// It loaded, now try invoking the class factory entry point
		GETCLASSOBJPROC pfnFactory = (GETCLASSOBJPROC)::GetProcAddress(HMODULE(hLib), "DllGetClassObject");
		if (pfnFactory)
		{
			// Found the entry point, try retrieving the factory
			IClassFactory* piVMFactory;
			HRESULT hr = (*pfnFactory)(pVMCLSID?*pVMCLSID:__uuidof(DolphinSmalltalk), IID_IClassFactory, (void**)&piVMFactory);

			if (SUCCEEDED(hr))
			{
				// Now try creating the VM object directly
				hr = piVMFactory->CreateInstance(NULL, iid, ppiDolphin);
				piVMFactory->Release();
				if (SUCCEEDED(hr))
					return hr;
			}

			hr = ErrorUnableToCreateVM(hr);
		}
	}

	return hr;
}

/////////////////////////////////////////////////////////////////////

HRESULT __stdcall CreateVM(DWORD dwClsContext, const CLSID* pVMCLSID, LPCSTR pszVM, const IID& iid, void** ppiDolphin)
{
	HRESULT hr;

	LPCSTR szVMPath = pszVM?pszVM:"DolphinVM7.DLL";

	// First attempt to load from current directory
	{
		char szLocalVM[_MAX_PATH+1];
		{
			char szExe[_MAX_PATH+1];
			::GetModuleFileName(GetModuleHandle(NULL), szExe, _MAX_PATH);

			char drive[_MAX_DRIVE];
			char dir[_MAX_DIR];
			_splitpath_s(szExe, drive, _MAX_DRIVE, dir, _MAX_DIR, NULL, 0, NULL, 0);
			_makepath_s(szLocalVM, _MAX_PATH, drive, dir, szVMPath, NULL);
		}

		if (_access(szLocalVM, 0) == 0)
		{
			hr = LoadAndCreateVM(pVMCLSID, szLocalVM, iid, ppiDolphin);
			if (SUCCEEDED(hr))
				return S_OK;
		}
	}

	hr = ::CoCreateInstance(pVMCLSID?*pVMCLSID:__uuidof(DolphinSmalltalk), NULL, dwClsContext, 
							iid, ppiDolphin);
	if (SUCCEEDED(hr))
		return hr;

	if (hr == REGDB_E_CLASSNOTREG)
	{
		hr = LoadAndCreateVM(pVMCLSID, szVMPath, iid, ppiDolphin);
		if (FAILED(hr))
			hr = ErrorVMNotRegistered(REGDB_E_CLASSNOTREG, szVMPath);
	}

	return hr;
}

#endif