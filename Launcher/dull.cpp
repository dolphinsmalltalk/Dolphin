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

HRESULT __stdcall ErrorUnableToCreateVM(HRESULT hr)
{
	LPSTR buf = GetErrorText(hr);
	HRESULT ret = ReportError(IDP_CREATEVMFAILED, hr, buf);
	::LocalFree(buf);
	return ret;
}

static const char* FindImageNameArg()
{
	LPCSTR szImage = "Dolphin.img7";
	static char achImageName[_MAX_PATH];

	for (int i=1;i<__argc;i++)
	{
		char ch = *__argv[i];
		if (ch != '/' && ch != '-')
		{
			szImage = __argv[i];
			break;
		}
	}

	char* filePart;
	::GetFullPathName(szImage, _MAX_PATH, achImageName, &filePart);
	return achImageName;
}

static HRESULT StartOldImage(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPCSTR lpCmdLine, int nCmdShow, 
						 const char* szImageName, WORD versionMajor)
{
	const CLSID* pVMCLSID = NULL;
	LPCSTR pszVM = NULL;

	switch(versionMajor)
	{
	case 3:		// Dolphin 3.06
		pVMCLSID = &__uuidof(DolphinSmalltalk3);
		pszVM = "DolphinVM003.DLL";
		break;

	case 4:		// Dolphin 4.01
		pVMCLSID = &__uuidof(DolphinSmalltalk4);
		pszVM = "DolphinVM004.DLL";
		break;

	case 5:		// Dolphin 5.1
		pVMCLSID = &__uuidof(DolphinSmalltalk51);
		pszVM = "DolphinVM005.DLL";
		break;

	case 6:		// Dolphin 6
		pszVM = "DolphinVM006.DLL";
		pVMCLSID = &__uuidof(DolphinSmalltalk62);
		break;

	case 7:		// Dolphin 7 (or unknown)
		pszVM = "DolphinVM7.DLL";
		pVMCLSID = &__uuidof(DolphinSmalltalk);
		break;

	default:
		return ReportError(IDP_UNRECOGNISEDIMAGEVERSION, szImageName, (int)versionMajor);
	}

	IDolphinStart3* piDolphin;
	HRESULT hr = CreateVM(CLSCTX_INPROC_SERVER, pVMCLSID, pszVM, __uuidof(IDolphinStart3), reinterpret_cast<void**>(&piDolphin));

	if (SUCCEEDED(hr))
	{
		// Note that this does now return
		hr = piDolphin->Start(hInstance, hPrevInstance, lpCmdLine, nCmdShow, 
						0, szImageName, NULL);
		piDolphin->Release();
	}

	return hr;
}

static HRESULT __stdcall StartDevSys(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPCSTR lpCmdLine, int nCmdShow)
{
	const char* szImageName = FindImageNameArg();

	ImageFileMapping imageFile;
	int ret = imageFile.Open(szImageName);
	if (ret < 0)
		return ReportError(IDP_OPENIMAGEFAILURE, szImageName);

	if (imageFile.GetType() != ImageFileMapping::ISTIMAGE)
		return ReportError(IDP_INVALIDIMAGETYPE, szImageName, reinterpret_cast<char*>(imageFile.GetData()));

	ImageHeader* pHeader = imageFile.GetHeader();
	WORD versionMajor = LOWORD(pHeader->versionMS);
	if (versionMajor < 6)
	{
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

	hr = piDolphin->Initialise(hInstance, szImageName, imageFile.GetRawData(), imageFile.GetRawSize(), /*IsDevSys*/1);
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
WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	::CoInitialize(NULL);
 	int nRet = StartDevSys(hInstance, hPrevInstance, lpCmdLine, nCmdShow);
	::CoUninitialize();
	return nRet;
}

HMODULE __stdcall GetResLibHandle()
{
	return GetModuleHandle(NULL);
}

///////////////////////////////////////////////////////////////////////
