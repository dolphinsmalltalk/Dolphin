// Dull.cpp - Main routine for development system launcher
//
// Dolphin.exe is executed with either a .img file as an argument or
// else the default .img file is used

#include "ist.h"
#include "startVM.h"
#include "DolphinSmalltalk_i.h"
#include "resource.h"
#include "..\rc_stub.h"
#include "ImageFileMapping.h"

#if _MSC_FULL_VER >= 140040130
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='x86' publicKeyToken='6595b64144ccf1df'\"")
#endif

/////////////////////////////////////////////////////////////////////

// Currently this behaves in the same was as the default _matherr function.
int __cdecl _matherr(_Inout_ struct _exception *except)
{
	UNREFERENCED_PARAMETER(except);
	return 0;
}

HRESULT __stdcall ErrorUnableToCreateVM(HRESULT hr)
{
	return ReportWin32Error(IDP_CREATEVMFAILED, hr);
}

static const wchar_t* FindImageNameArg()
{
	LPCWSTR szImage = L"DPRO.img8";
	static wchar_t achImageName[_MAX_PATH];

	for (auto i=1;i<__argc;i++)
	{
		const wchar_t* arg = __wargv[i];
		wchar_t ch = *arg;
		if (ch != L'/' && ch != L'-')
		{
			szImage = __wargv[i];
			break;
		}
	}

	wchar_t* filePart;
	::GetFullPathNameW(szImage, _MAX_PATH, achImageName, &filePart);
	return achImageName;
}

static HRESULT StartOldImage(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPCWSTR lpCmdLine, int nCmdShow, 
						 const wchar_t* szImageName, uint16_t versionMajor)
{
	const CLSID* pVMCLSID = NULL;
	LPCWSTR pszVM = NULL;

	switch(versionMajor)
	{
	case 3:		// Dolphin 3.06
	case 4:		// Dolphin 4.01
	case 5:		// Dolphin 5.1
	case 6:		// Dolphin 6
		// The older images VMs can no longer be launcher by 7.0 and later launcher
		return ReportError(IDP_UNSUPPORTEDIMAGEVERSION, szImageName, (int)versionMajor);

	case 7:		// Dolphin 7
		pszVM = L"DolphinVM7.DLL";
		pVMCLSID = &__uuidof(DolphinSmalltalk71);
		break;

	case 8:		// Dolphin 8
		pszVM = L"DolphinVM8.DLL";
		pVMCLSID = &__uuidof(DolphinSmalltalk);
		break;

	default:
		return ReportError(IDP_UNRECOGNISEDIMAGEVERSION, szImageName, (int)versionMajor);
	}

	IDolphinStart3* piDolphin;
	HRESULT hr = CreateVM(CLSCTX_INPROC_SERVER, pVMCLSID, pszVM, __uuidof(IDolphinStart3), reinterpret_cast<void**>(&piDolphin));

	if (SUCCEEDED(hr))
	{
		int cbCmdLine = wcslen(lpCmdLine) + 1;
		char* cmdLine = (char*)malloc(cbCmdLine);
		::WideCharToMultiByte(CP_ACP, 0, lpCmdLine, -1, cmdLine, cbCmdLine, nullptr, nullptr);
		int cbImageName = wcslen(szImageName) + 1;
		char* imageName = (char*)malloc(cbImageName);
		::WideCharToMultiByte(CP_ACP, 0, lpCmdLine, -1, imageName, cbImageName, nullptr, nullptr);

		// Note that this does now return
		hr = piDolphin->Start(hInstance, hPrevInstance, cmdLine, nCmdShow, 0, imageName, NULL);
		piDolphin->Release();
		free(cmdLine);
		free(imageName);
	}

	return hr;
}

static HRESULT __stdcall StartDevSys(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPCWSTR lpCmdLine, int nCmdShow)
{
	const wchar_t* szImageName = FindImageNameArg();

	ImageFileMapping imageFile;
	int ret = imageFile.Open(szImageName);
	if (ret < 0)
		return ReportError(IDP_OPENIMAGEFAILURE, szImageName);

	if (imageFile.GetType() != ImageFileMapping::ISTIMAGE)
		return ReportError(IDP_INVALIDIMAGETYPE, szImageName, reinterpret_cast<char*>(imageFile.GetData()));

	ImageHeader* pHeader = imageFile.GetHeader();
	if (pHeader->versionMH >= 1990)
	{
		uint16_t versionMajor = LOWORD(pHeader->versionMS);
		imageFile.Close();
		return StartOldImage(hInstance, hPrevInstance, lpCmdLine, nCmdShow,
				szImageName, versionMajor);
	}

	IDolphinStart* piDolphin = NULL;
	HRESULT hr = CreateVM(CLSCTX_INPROC_SERVER, NULL, NULL, __uuidof(IDolphinStart), reinterpret_cast<void**>(&piDolphin));
	if FAILED(hr)
		return hr;

	// Perform a more detailed version check against the actual VM loaded
	VS_FIXEDFILEINFO vi;
	hr = piDolphin->GetVersionInfo(&vi);
	if (pHeader->versionMS != vi.dwProductVersionMS)
	{
		// version mismatch; this image file is probably invalid
		int resp = DolphinMessageBox(IDP_VERSIONMISMATCH, MB_YESNO|MB_ICONWARNING,
			HIWORD(pHeader->versionMS), LOWORD(pHeader->versionMS), HIWORD(pHeader->versionLS), LOWORD(pHeader->versionLS),
			HIWORD(vi.dwProductVersionMS), LOWORD(vi.dwProductVersionMS), HIWORD(vi.dwProductVersionLS), LOWORD(vi.dwProductVersionLS),
			szImageName);
		if (resp != IDYES)
			return MAKE_HRESULT(SEVERITY_ERROR, FACILITY_ITF, IDP_VERSIONMISMATCH);
	}

	hr = piDolphin->Initialise(hInstance, szImageName, imageFile.GetRawData(), imageFile.GetRawSize(), VMINITFLAGS);
	if (FAILED(hr))
		return hr;

	// Once loaded, the image file is no longer needed and can be unmapped and closed.
	imageFile.Close();

	hr = piDolphin->Run(NULL);
	piDolphin->Release();

	return hr;
}

/////////////////////////////////////////////////////////////////////
int APIENTRY 
wWinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance, _In_ LPWSTR lpCmdLine, _In_ int nShowCmd)
{
	HRESULT hr = ::CoInitialize(NULL);
	if (FAILED(hr))
		return hr;

 	int nRet = StartDevSys(hInstance, hPrevInstance, lpCmdLine, nShowCmd);
	::CoUninitialize();
	return nRet;
}

HMODULE __stdcall GetResLibHandle()
{
	return GetModuleHandle(NULL);
}

///////////////////////////////////////////////////////////////////////
