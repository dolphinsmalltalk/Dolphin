
#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "ist.h"

#include "rc_vm.h"
#include "DolphinSmalltalk_i.h"
#include "DolphinSmalltalk.h"
#include "Utf16StringBuf.h"

extern HINSTANCE hApplicationInstance;
static IDolphin* piVM=NULL;

IDolphin* GetVM()
{
	return piVM;
}

/////////////////////////////////////////////////////////////////////
// IDolphinSmalltalk
STDMETHODIMP CDolphinSmalltalk::Initialise(HINSTANCE hInstance, 
									  LPCSTR fileName, LPVOID imageData, UINT imageSize,
									DWORD dwFlags)
{
	if (fileName == nullptr)
		return Initialise(hInstance, (LPCWSTR)nullptr, imageData, imageSize, dwFlags);
	else
	{
		Utf16StringBuf buf(CP_ACP, fileName, strlen(fileName));
		return Initialise(hInstance, (LPCWSTR)buf, imageData, imageSize, dwFlags);
	}
}

STDMETHODIMP CDolphinSmalltalk::Initialise(HINSTANCE hInstance,
	LPCWSTR fileName, LPVOID imageData, UINT imageSize,
	DWORD dwFlags)
{
	HRESULT APIENTRY VMInit(LPCWSTR szImageName, LPVOID, size_t, DWORD);

	if (hInstance == NULL)
		return E_INVALIDARG;

	piVM = this;

	Lock();

	hApplicationInstance = hInstance;
	HRESULT hr = VMInit(fileName, imageData, imageSize, dwFlags);

	Unlock();

	return hr;
}
STDMETHODIMP CDolphinSmalltalk::Run(IUnknown* punkOuter)
{
	extern int APIENTRY VMRun(uintptr_t);

	piVM = this;
	
	Lock();

	HRESULT hr = VMRun(reinterpret_cast<uintptr_t>(punkOuter));

	Unlock();

	return hr;
}

STDMETHODIMP CDolphinSmalltalk::GetVersionInfo(LPVOID pvi)
{
	extern BOOL __stdcall GetVersionInfo(VS_FIXEDFILEINFO* lpInfoOut);
	return ::GetVersionInfo(static_cast<VS_FIXEDFILEINFO*>(pvi)) ? S_OK : E_FAIL;
}
