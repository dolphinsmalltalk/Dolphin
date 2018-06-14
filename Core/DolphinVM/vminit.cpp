#include "ist.h"

#ifndef _DEBUG
#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

#include "environ.h"
#include "rc_vm.h"
#include "interprt.h"

wchar_t achImagePath[_MAX_PATH];	// Loaded image path

#pragma code_seg(INIT_SEG)

HRESULT InitApplication()
{
#if defined(VMDLL) && !defined(_DEBUG)
	::DisableThreadLibraryCalls(GetVMModule());
#endif
	return S_OK;
}

static HRESULT DolphinInit(LPCWSTR szFileName, LPVOID imageData, UINT imageSize, bool isDevSys)
{
	// Find the fileName of the image to load by the VM
	wcsncpy_s(achImagePath, szFileName, _MAX_PATH);
	return Interpreter::initialize(achImagePath, imageData, imageSize, isDevSys);
}

HRESULT APIENTRY VMInit(LPCWSTR szImageName,
	LPVOID imageData, UINT imageSize,
	DWORD flags)
{
	extern void DolphinInitInstance();

	// Perform instance initialization:
	HRESULT hr = InitApplication();
	if (FAILED(hr))
		return hr;

	DolphinInitInstance();

	return DolphinInit(szImageName, imageData, imageSize, flags & 1);
}
