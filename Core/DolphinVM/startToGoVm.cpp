// startVM.cpp

#include "ist.h"

#ifdef TO_GO

#include "startVM.h"
#include "DolphinSmalltalk.h"
#include "VMExcept.h"

/////////////////////////////////////////////////////////////////////////////
// Globals

CComModule _Module;

/////////////////////////////////////////////////////////////////////

#pragma code_seg(INIT_SEG)

HRESULT __stdcall CreateVM(CLSCTX, const CLSID*, LPCWSTR, const IID& iid, void** ppiDolphin)
{
	HRESULT hr;

	CComObject<CDolphinSmalltalk>* pDolphin;
	hr = CComObject<CDolphinSmalltalk>::CreateInstance(&pDolphin);
	if (FAILED(hr))
		return ErrorUnableToCreateVM(hr);

	return pDolphin->QueryInterface(iid, ppiDolphin);
}

HRESULT __stdcall CheckVmVersion(IDolphinStart* piDolphin, ImageFileResource imageFile)
{
	return S_OK;
}

extern HMODULE GetModuleContaining(LPCVOID pFunc);

HINSTANCE GetApplicationInstance()
{
	return GetModuleContaining(GetApplicationInstance);
}

#endif
