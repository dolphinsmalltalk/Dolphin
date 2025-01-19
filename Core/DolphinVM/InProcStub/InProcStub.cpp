// InProcStub.cpp : Implementation of DLL Exports.


// Note: Proxy/Stub Information
//      To build a separate proxy/stub DLL, 
//      run nmake -f InProcStubps.mk in the project directory.

#include "ist.h"
#include "resource.h"
#include "..\rc_stub.h"
#include <initguid.h>
#include "InProcStub.h"
#include "dlldatax.h"
#include "InProcModule.h"
#include "InProcPlugHole.h"
#include "InProcStub_i.c"
#include "ImageFileResource.h"
#include "regkey.h"

#ifndef TO_GO
#include "..\Launcher\ImageFileMapping.h"
#include "startvm.h"
#endif

IPDolphinModule _Module;

static DolphinIPPlugHole* s_pPlugHole = NULL;

#ifdef TO_GO
// In TO_GO mode the Dolphin VM object will be holding a lock, but we don't want this to prevent
// the module being unloaded.
#define INTERNALLOCKCOUNT 1
#else
#define INTERNALLOCKCOUNT 0
#endif

HMODULE __stdcall GetResLibHandle()
{
	return Module::GetHModule();
}

HRESULT __stdcall ErrorUnableToCreateVM(HRESULT hr)
{
	std::wstring buf = GetErrorText(hr);
	HRESULT ret = ReportError(IDP_CREATEVMFAILED, hr, buf.c_str());
	return ret;
}

static bool GetPlugHoleInProcServerPSKey(RegKey& psKey)
{
	constexpr WCHAR szPlugHoleInProcServer[] = L"CLSID\\{7DAC28A4-28F3-4CC9-8BF1-C17FB4CAC8BD}\\InProcServer32";
	return psKey.Open(HKEY_CLASSES_ROOT, szPlugHoleInProcServer, KEY_READ) == ERROR_SUCCESS;
}

static bool IsPlugHolePSFactoryRegistered()
{
	RegKey psKey;
	return GetPlugHoleInProcServerPSKey(psKey);
}

HRESULT RegisterPSFactory()
{
#ifdef TO_GO

	// TO_GO in-proc stub has marshalling code embedded, which we can register directly
	RegKeyRedirect userClassesRoot = _Module.RedirectClassesRootIfNeeded();
	return PrxDllRegisterServer();

#else
typedef HRESULT(STDAPICALLTYPE* DLLREGISTERPROC)(void);

// The non-ToGo stub relies on the normal VM to provide marshalling code, so if it is not registered then we
// must try and register it.
	HMODULE hVm;
	wchar_t szLocalVM[_MAX_PATH + 1];
	if (GetVmLocalPath(VmFilename, szLocalVM, _MAX_PATH)) {
		hVm = LoadLibrary(szLocalVM);
	}
	else {
		hVm = LoadLibrary(VmFilename);
	}

	HRESULT hr = REGDB_E_IIDNOTREG;
	if (hVm) {
		DLLREGISTERPROC pfnRegister = (DLLREGISTERPROC)::GetProcAddress(HMODULE(hVm), "DllRegisterServer");
		if (pfnRegister) {
			hr = (*pfnRegister)();
		}
		FreeLibrary(hVm);
	}
	return hr;
#endif
}

HRESULT UnregisterPSFactory()
{
#ifdef TO_GO
	RegKeyRedirect userClassesRoot = _Module.RedirectClassesRootIfNeeded();
	return PrxDllUnregisterServer();
#else
	// Don't unregister the VM PS, even if we registered it
	return S_FALSE;
#endif
}


// In order to load up a Dolphin image, we have to start a thread for it to run in.
// We then communicate with it through COM interfaces that will need to marshal calls
// between threads. This then requires that the proxy stub code be registered
// for these interfaces so that inter-thread marshalling is possible. Although the
// marshalling code may already be registered by the Dolphin VM, in a greenfield
// situation this may not be the case and then will will need to register a local copy
// of the marshalling code before attempting to start the image
static HRESULT RegisterPSFactoryIfNeeded()
{
	return IsPlugHolePSFactoryRegistered() 
		? S_FALSE 
		: RegisterPSFactory();
}

#ifdef TO_GO

static HRESULT UnregisterPSFactoryIfNeeded()
{
	RegKey psKey;
	if (!GetPlugHoleInProcServerPSKey(psKey)) {
		return S_FALSE;
	}

	HMODULE hModule = GetResLibHandle();
	WCHAR szThisDll[_MAX_PATH + 1];
	// Get the plugin DLL name and split off the directory component
	::GetModuleFileName(hModule, szThisDll, _countof(szThisDll));

	WCHAR szPSFactory[_MAX_PATH + 1] = { 0 };
	ULONG nChars = _countof(szPSFactory);
	if (psKey.QueryStringValue(nullptr, szPSFactory, nChars) != ERROR_SUCCESS) {
		return S_FALSE;
	}

	// If this DLL is registered as the PS factory, then unregister it
	if (_wcsicmp(szThisDll, szPSFactory) == 0) {
		return UnregisterPSFactory();
	}

	return S_FALSE;
}

#else

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

BOOL IPDolphinModule::OnProcessAttach(HINSTANCE hInst)
{
	TRACE(L"%#x: OnProcessAttach: Module lock count %d\n", GetCurrentThreadId(), _Module.GetLockCount());

	HMODULE hModule = GetResLibHandle();
	static WCHAR szImagePath[_MAX_PATH + 1];
	// Get the plugin DLL name and split off the directory component
	::GetModuleFileName(hModule, szImagePath, _countof(szImagePath));
	
	ImageFileResource imageFile;
	int ret = imageFile.Open(hModule, 100);

	// Create the PlugHole instance, but as yet we may not know what image to fire up
	s_pPlugHole = new DolphinIPPlugHole();
	s_pPlugHole->AddRef();

	if (ret >= 0)
	s_pPlugHole->SetImageInfo(szImagePath, imageFile.GetRawData(), imageFile.GetRawSize());

	return TRUE;
}

BOOL IPDolphinModule::OnProcessDetach(HINSTANCE hInst)
{
	_ASSERTE(s_pPlugHole != NULL);

	s_pPlugHole->Release();
	s_pPlugHole = NULL;

	TRACE(L"%#x: OnProcessDetach: Module lock count %d\n", GetCurrentThreadId(), _Module.GetLockCount());
	return TRUE;
}

BOOL IPDolphinModule::OnThreadAttach(HINSTANCE hInst)
{
	TRACE(L"%#x: Thread attached to in-proc stub\n", GetCurrentThreadId());
	return TRUE;
}

BOOL IPDolphinModule::OnThreadDetach(HINSTANCE hInst)
{
	TRACE(L"%#x: Thread detached from in-proc stub\n", GetCurrentThreadId());
	if (s_pPlugHole)
		s_pPlugHole->ThreadDetach();
	return TRUE;
}

/////////////////////////////////////////////////////////////////////////////
// Used to determine whether the DLL can be unloaded by OLE

HRESULT IPDolphinModule::CanUnloadNow()
{
	HRESULT hr;
	unsigned int moduleLocks = _Module.GetLockCount();
    if (moduleLocks <= INTERNALLOCKCOUNT)
	{
		// Add a reference to prevent another thread calling this function from
		// preceeding past the previous test (or the next if racing)
		CAutoLock lockModule(*this);

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
    return _Module.DllMain(hInstance, dwReason);
}

__control_entrypoint(DllExport)
STDAPI DllCanUnloadNow(void)
{
	HRESULT hr;

	hr = _Module.CanUnloadNow();

#ifdef _MERGE_PROXYSTUB
    if (hr == S_OK)
		hr = PrxDllCanUnloadNow();
#endif

	return hr;
}

/////////////////////////////////////////////////////////////////////////////
// Returns a class factory to create an object of the requested type

_Check_return_
STDAPI  DllGetClassObject(_In_ REFCLSID rclsid, _In_ REFIID riid, _Outptr_ LPVOID FAR* ppv)
{
#ifdef TO_GO
    if (PrxDllGetClassObject(rclsid, riid, ppv) == S_OK)
        return S_OK;
#endif

	HRESULT hr = RegisterPSFactoryIfNeeded();
	if (FAILED(hr))
		return hr;

	CAutoLock lockModule(_Module);

    hr = _Module.GetClassObject(rclsid, riid, ppv);
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
	HRESULT hr = RegisterPSFactoryIfNeeded();
	if (FAILED(hr))
		return hr;

	CAutoLock lockModule(_Module);

	_ASSERTE(s_pPlugHole != NULL);
	hr = s_pPlugHole->RegisterServer();
	s_pPlugHole->Shutdown();

	return hr;
}

/////////////////////////////////////////////////////////////////////////////
// DllUnregisterServer - Removes entries from the system registry

STDAPI DllUnregisterServer(void)
{
	HRESULT hr = RegisterPSFactoryIfNeeded();
	if (FAILED(hr))
		return hr;

	CAutoLock lockModule(_Module);

	_ASSERTE(s_pPlugHole != NULL);
	hr = s_pPlugHole->UnregisterServer();
	s_pPlugHole->Shutdown();

#ifdef TO_GO
	UnregisterPSFactoryIfNeeded();
#endif

	return hr;
}
