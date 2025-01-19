#include "ist.h"

#if defined(VMDLL) || defined(INPROC)
#error "startApp is only for use in executable stubs"
#endif

#include "startVM.h"
#include "VMModule.h"

VMModule _Module;

HRESULT __stdcall RunEmbeddedImage(HMODULE hModule, int resId)
{
	ImageFileResource imageFile;
	int ret = imageFile.Open(hModule, resId);
	if (ret < 0)
		return E_FAIL;

	IDolphinStart* piDolphin = NULL;
	HRESULT hr = CreateVM(CLSCTX_INPROC_SERVER, NULL, NULL, __uuidof(IDolphinStart), reinterpret_cast<void**>(&piDolphin));
	if (FAILED(hr))
		return hr;
	
	hr = CheckVmVersion(piDolphin, imageFile);
	if (FAILED(hr))
		return hr;

	// retrieve the file name of this process, ie this .exe
	wchar_t fileName[MAX_PATH] = L"";
	::GetModuleFileName(hModule, fileName, _countof(fileName));

	hr = piDolphin->Initialise(hModule, fileName, imageFile.GetRawData(), imageFile.GetRawSize(), VMINITFLAGS);
	if (FAILED(hr))
		return hr;

	imageFile.Close();

	hr = piDolphin->Run(NULL);
	piDolphin->Release();

	return hr;
}