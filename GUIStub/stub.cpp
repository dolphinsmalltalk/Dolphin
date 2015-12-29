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
	return GetModuleHandle(NULL);
}

static LPSTR GetErrorText(HRESULT hr)
{
	// Answer some suitable text for the last system error
	LPSTR buf;
	::FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
		0, hr, 0, LPSTR(&buf), 0, 0);
	return buf;
}

HRESULT __stdcall ErrorUnableToCreateVM(HRESULT hr)
{
	LPSTR buf = GetErrorText(hr);
	HRESULT ret = ReportError(IDP_CREATEVMFAILED, hr, buf);
	::LocalFree(buf);
	return ret;
}

int APIENTRY 
WinMain(HINSTANCE hModule, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	::CoInitialize(NULL);
 	HRESULT hr = RunEmbeddedImage(hModule, IDR_IMAGE);
	::CoUninitialize();
	return DecodeHRESULT(hr);
}
