
#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "ist.h"

#include "rc_vm.h"
#include "DolphinSmalltalk_i.h"
#include "DolphinSmalltalk.h"

extern HINSTANCE hApplicationInstance;
static IDolphin* piVM=NULL;

IDolphin* GetVM()
{
#ifdef _AFX
	if (!piVM)
	{
		CComObject<CDolphinSmalltalk>* pDolphin;
		HRESULT hr = CComObject<CDolphinSmalltalk>::CreateInstance(&pDolphin);
		piVM = pDolphin;
	}
#endif
	return piVM;
}

/////////////////////////////////////////////////////////////////////
// IDolphinSmalltalk
STDMETHODIMP CDolphinSmalltalk::Initialise(HINSTANCE hInstance, 
									  LPCSTR fileName, LPVOID imageData, UINT imageSize,
									DWORD dwFlags)
{
#ifdef _AFX
	return E_NOTIMPL;
#else
	HRESULT APIENTRY VMInit(LPCSTR szImageName, LPVOID, UINT, DWORD);

	if (hInstance == NULL || imageData == NULL || imageSize == 0)
		return E_INVALIDARG;

	piVM = this;
	
	Lock();

	hApplicationInstance = hInstance;
	HRESULT hr = VMInit(fileName, imageData, imageSize, dwFlags);

	Unlock();

	return hr;
#endif
}

STDMETHODIMP CDolphinSmalltalk::Run(IUnknown* punkOuter)
{
#ifdef _AFX
	return E_NOTIMPL;
#else
	extern int APIENTRY VMRun(DWORD);

	piVM = this;
	
	Lock();

	HRESULT hr = VMRun(reinterpret_cast<DWORD>(punkOuter));

	Unlock();

	return hr;
#endif
}

STDMETHODIMP CDolphinSmalltalk::GetVersionInfo(LPVOID pvi)
{
	extern BOOL __stdcall GetVersionInfo(VS_FIXEDFILEINFO* lpInfoOut);
	return ::GetVersionInfo(static_cast<VS_FIXEDFILEINFO*>(pvi));
}
