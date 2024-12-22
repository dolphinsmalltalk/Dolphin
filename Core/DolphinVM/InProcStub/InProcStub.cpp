// InProcStub.cpp : Implementation of DLL Exports.


// Note: Proxy/Stub Information
//      To build a separate proxy/stub DLL, 
//      run nmake -f InProcStubps.mk in the project directory.

#include "stdafx.h"
#include "ist.h"
#include "resource.h"
#include "..\rc_stub.h"
#include <initguid.h>
#include "InProcStub.h"
#include "dlldatax.h"

#include "InProcStub_i.c"
#include "InProcPlugHole.h"
#include "ImageFileResource.h"
#ifndef TO_GO
#include "..\Launcher\ImageFileMapping.h"
#endif

#if defined(_MERGE_PROXYSTUB) && !defined(TO_GO)
#error "No proxy/stub marshalling code here, as included in the Dolphin VM"
#endif

class CIPDolphinModule : public CAtlDllModuleT< CIPDolphinModule >
{
protected:
	BOOL OnProcessAttach();
	void OnProcessDetach();

public:
	BOOL WINAPI DllMain(DWORD dwReason, LPVOID /* lpReserved */) throw();
	HRESULT DllCanUnloadNow();

public :
	DECLARE_LIBID(LIBID_DolphinIP)
	//DECLARE_REGISTRY_APPID_RESOURCEID(IDR_DOLPHINSMALLTALK, "{F797E72A-F7ED-4B65-9FD9-A850ACA48983}")
};

CIPDolphinModule _Module;

static wchar_t achModulePath[_MAX_PATH+1];
static CInProcPlugHole* s_pPlugHole = NULL;

#include "..\CritSect.h"
typedef CAutoLock<CIPDolphinModule> ModuleRef;

#ifdef TO_GO
// In TO_GO mode the Dolphin VM object will be holding a lock, but we don't want this to prevent
// the module being unloaded.
#define INTERNALLOCKCOUNT 1
#else
#define INTERNALLOCKCOUNT 0
#endif

HMODULE __stdcall GetResLibHandle()
{
	return _AtlBaseModule.GetResourceInstance();
}

HRESULT __stdcall ErrorUnableToCreateVM(HRESULT hr)
{
	std::wstring buf = GetErrorText(hr);
	HRESULT ret = ReportError(IDP_CREATEVMFAILED, hr, buf.c_str());
	return ret;
}

#ifndef TO_GO
HRESULT __stdcall ErrorVMNotRegistered(HRESULT hr, LPCWSTR)
{
	return ReportWin32Error(IDP_VMNOTREGISTERED, hr);
}

HRESULT __stdcall ErrorVMVersionMismatch(ImageHeader* pHeader, VS_FIXEDFILEINFO* pvi)
{
	return ReportError(IDS_APPNAME, IDP_VERSIONMISMATCH, 
		HIWORD(pHeader->versionMS), LOWORD(pHeader->versionMS), HIWORD(pHeader->versionLS), LOWORD(pHeader->versionLS),
		HIWORD(pvi->dwProductVersionMS), LOWORD(pvi->dwProductVersionMS), HIWORD(pvi->dwProductVersionLS), LOWORD(pvi->dwProductVersionLS));
}
#endif

BOOL CIPDolphinModule::OnProcessAttach()
{
	TRACE(L"%#x: OnProcessAttach: Module lock count %d\n", GetCurrentThreadId(), _Module.GetLockCount());

	// Get the plugin DLL name and split off the directory component
	::GetModuleFileName(_AtlBaseModule.GetModuleInstance(), achModulePath, sizeof(achModulePath));
	
	LPCWSTR szImagePath = achModulePath;

	HMODULE hModule = _AtlBaseModule.GetModuleInstance();

	ImageFileResource imageFile;
	int ret = imageFile.Open(hModule, 100);

	// Create the PlugHole instance, but as yet we may not know what image to fire up
	CComObject<CInProcPlugHole>* pPlugHole;
	HRESULT hr = CComObject<CInProcPlugHole>::CreateInstance(&pPlugHole);
	if (FAILED(hr))
		return FALSE;

	s_pPlugHole = pPlugHole;
	s_pPlugHole->AddRef();

	if (ret >= 0)
	s_pPlugHole->SetImageInfo(szImagePath, imageFile.GetRawData(), imageFile.GetRawSize());

	return TRUE;
}

void CIPDolphinModule::OnProcessDetach()
{
	_ASSERTE(s_pPlugHole != NULL);

	s_pPlugHole->Release();
	s_pPlugHole = NULL;

	TRACE(L"%#x: OnProcessDetach: Module lock count %d\n", GetCurrentThreadId(), _Module.GetLockCount());
}

/////////////////////////////////////////////////////////////////////////////
// DLL Entry Point

BOOL WINAPI CIPDolphinModule::DllMain(DWORD dwReason, LPVOID /* lpReserved */) throw()
{
	BOOL bSuccess = TRUE;

    switch(dwReason)
	{
	case DLL_PROCESS_ATTACH:
		if (CAtlBaseModule::m_bInitFailed)
		{
			ATLASSERT(0);
			bSuccess = FALSE;
		}
		else
			bSuccess = OnProcessAttach();
		break;

    case DLL_PROCESS_DETACH:
		OnProcessDetach();
		// Prevent false memory leak reporting. ~CAtlWinModule may be too late.
		_AtlWinModule.Term();		
		break;

	case DLL_THREAD_ATTACH:
		TRACE(L"%#x: Thread attached to in-proc stub\n", GetCurrentThreadId());
		break;

	case DLL_THREAD_DETACH:
		TRACE(L"%#x: Thread detached from in-proc stub\n", GetCurrentThreadId());
		if (s_pPlugHole)
			s_pPlugHole->ThreadDetach();
		break;
	}
	
    return bSuccess;
}

/////////////////////////////////////////////////////////////////////////////
// Used to determine whether the DLL can be unloaded by OLE

HRESULT CIPDolphinModule::DllCanUnloadNow()
{
	HRESULT hr;
	LONG moduleLocks = _Module.GetLockCount();
    if (moduleLocks <= INTERNALLOCKCOUNT)
	{
		// Add a reference to prevent another thread calling this function from
		// preceeding past the previous test (or the next if racing)
		ModuleRef lockModule(*this);

		if (GetLockCount() > (moduleLocks+1))
			hr = S_FALSE;
		else if (s_pPlugHole != NULL)
		{
			hr = s_pPlugHole->CanUnloadNow();
			if (hr == S_OK)
			{
				s_pPlugHole->Shutdown();
			}
			else if (FAILED(hr))
			{
				// Failure is not expected, perhaps disconnected, allow to be unloaded
				hr = S_OK;
			}
		}
		else
			hr = S_OK;
	}
	else 
		hr = S_FALSE;

	return hr;
}

// DLL Entry Point
extern "C" BOOL WINAPI DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
#ifdef _MERGE_PROXYSTUB
    if (!PrxDllMain(hInstance, dwReason, lpReserved))
        return FALSE;
#endif
	hInstance;
    return _Module.DllMain(dwReason, lpReserved);
}

STDAPI DllCanUnloadNow(void)
{
	HRESULT hr;

	hr = _Module.DllCanUnloadNow();

#ifdef _MERGE_PROXYSTUB
    if (hr == S_OK)
		hr = PrxDllCanUnloadNow();
#endif

	return hr;
}

/////////////////////////////////////////////////////////////////////////////
// Returns a class factory to create an object of the requested type

STDAPI DllGetClassObject(REFCLSID rclsid, REFIID riid, LPVOID* ppv)
{
#ifdef _MERGE_PROXYSTUB
    if (PrxDllGetClassObject(rclsid, riid, ppv) == S_OK)
        return S_OK;
#endif

	ModuleRef lockModule(_Module);

    HRESULT hr = _Module.GetClassObject(rclsid, riid, ppv);
	if (FAILED(hr))
	{
		_ASSERTE(s_pPlugHole != NULL);
		hr = s_pPlugHole->GetClassObject(rclsid, riid, ppv);
	}

	return hr;
}

/////////////////////////////////////////////////////////////////////////////
// DllRegisterServer - Adds entries to the system registry

STDAPI DllRegisterServer(void)
{
	//ASSERT(FALSE);

#ifdef _MERGE_PROXYSTUB
    HRESULT hRes = PrxDllRegisterServer();
    if (FAILED(hRes))
        return hRes;
#endif

	ModuleRef lockModule(_Module);

 	// Note that we register the typelib separately since if this stub is being used as a
	// proxy, it may not have a typelib bound into it
    HRESULT hr = _Module.RegisterServer(FALSE);
	if (SUCCEEDED(hr))
	{
		CComBSTR bstrPath;
		CComPtr<ITypeLib> pTypeLib;
		hr = AtlLoadTypeLib(_AtlComModule.m_hInstTypeLib, 0, &bstrPath, &pTypeLib);
		if (SUCCEEDED(hr))
		{
			OLECHAR szDir[_MAX_PATH];
			ocscpy_s(szDir, _MAX_PATH, bstrPath);
			szDir[AtlGetDirLen(szDir)] = 0;
			hr = ::RegisterTypeLib(pTypeLib, bstrPath, szDir);
		}
		else
		{
			// No typelib bound
			trace(L"Warning: Module does not contain a type library (%#x)\n", hr);
			hr = S_OK;
		}

		if (SUCCEEDED(hr))
		{
			_ASSERTE(s_pPlugHole != NULL);
			hr = s_pPlugHole->RegisterServer();
			s_pPlugHole->Shutdown();
		}
		else
		{
			trace(L"RegisterTypeLib failed: %#x\n", hr);
			hr = SELFREG_E_TYPELIB;
		}
	}

	return hr;
}

/////////////////////////////////////////////////////////////////////////////
// DllUnregisterServer - Removes entries from the system registry

STDAPI DllUnregisterServer(void)
{
#ifdef _MERGE_PROXYSTUB
	// Seems odd, but before attempting to unregister through the image, we have
	// to be sure that we have marshalling code that will allow us to call into 
	// that image, therefore we take the precaution of registering the proxy/stub
	// interfaces first.
    HRESULT hRes = PrxDllRegisterServer();
    if (FAILED(hRes))
        return hRes;
#endif

	ModuleRef lockModule(_Module);

	HRESULT hr = _Module.UnregisterServer(TRUE);
	HRESULT hr2;
	{
		_ASSERTE(s_pPlugHole != NULL);
		hr2 = s_pPlugHole->UnregisterServer();
		s_pPlugHole->Shutdown();
	}

#ifdef _MERGE_PROXYSTUB
    PrxDllUnregisterServer();
#endif

	return SUCCEEDED(hr) ? hr2 : hr;
}


HRESULT CInProcPlugHole::FinalConstruct()
{
	// This is an internal object, and we don't want it to prevent the DLL being unloaded.
	// There is a circular reference from the plug hole to the image peer, and we want the
	// image side to tell us whether the image should be kept up (except for some cases
	// where we protect the code with a Lock()/Unlock() pair for safety).
	TRACE(L"%#x: CInProcPlugHole::FinalConstruct() Removing my module lock\n", GetCurrentThreadId());

	_Module.Unlock();
	return S_OK;
}

void CInProcPlugHole::FinalRelease()
{
	TRACE(L"%#x: CInProcPlugHole::FinalRelease() Replacing my module lock\n", GetCurrentThreadId());

	// Add back in the module lock to balance FinalConstruct
	_Module.Lock();
}

