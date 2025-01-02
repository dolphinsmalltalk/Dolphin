//stub.cpp

// The <stub>.exe has an image appended to it. When it is executed it
// calls the vm.dll with an offset into itself to load from.

// Note that you can not save an image back into this <stub>.exe while
// it is running 

#include "ist.h"
#include "startVM.h"
#include "..\rc_stub.h"

/////////////////////////////////////////////////////////////////////

HMODULE __stdcall GetResLibHandle()
{
	// Returns the handle of the process .exe, which will be the Dolphin GUI app .exe
	return GetModuleHandle(NULL);
}

static LPWSTR GetErrorText(HRESULT hr)
{
	// Answer some suitable text for the last system error
	LPWSTR buf;
	::FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
		0, hr, 0, LPWSTR(&buf), 0, 0);
	return buf;
}

HRESULT __stdcall ErrorUnableToCreateVM(HRESULT hr)
{
	LPCWSTR buf = GetErrorText(hr);
	HRESULT ret = ReportError(IDP_CREATEVMFAILED, hr, buf);
	::LocalFree((HLOCAL)buf);
	return ret;
}

int APIENTRY 
wWinMain(HINSTANCE hModule, HINSTANCE hPrevInstance, LPWSTR lpCmdLine, int nCmdShow)
{
	HRESULT hr = ::CoInitialize(NULL);
	if (SUCCEEDED(hr)) {
		hr = RunEmbeddedImage(hModule, IDR_IMAGE);
		::CoUninitialize();
	}
	return DecodeHRESULT(hr);
}
