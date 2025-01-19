// startVM.cpp

#include "ist.h"

#ifdef TO_GO

#include "startVM.h"
#include "DolphinSmalltalk.h"
#include "VMExcept.h"
#include "COMModule.h"

/////////////////////////////////////////////////////////////////////

#pragma code_seg(INIT_SEG)

HRESULT __stdcall CreateVM(CLSCTX, const CLSID*, LPCWSTR, const IID& iid, void** ppiDolphin)
{
	DolphinSmalltalk* pDolphin = new DolphinSmalltalk();
	if (!pDolphin) {
		return E_OUTOFMEMORY;
	}

	return pDolphin->QueryInterface(iid, ppiDolphin);
}

HRESULT __stdcall CheckVmVersion(IDolphinStart* piDolphin, ImageFileResource imageFile)
{
	return S_OK;
}

HINSTANCE GetApplicationInstance()
{
	return Module::GetHModuleContaining(GetApplicationInstance);
}

#endif
