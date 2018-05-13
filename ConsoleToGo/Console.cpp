// Console.cpp : Defines the entry point for the console application.
//

// The <stub>.exe has an image appended to it. When it is executed it
// calls the vm.dll with an offset into itself to load from.

// Note that you can not save an image back into this <stub>.exe while
// it is running 

#include "ist.h"
#include "startVM.h"
#include "..\rc_stub.h"
#include "resource.h"
#include "DolphinSmalltalk.h"

#define PROFILE_RUNTIME

/////////////////////////////////////////////////////////////////////

HMODULE __stdcall GetResLibHandle()
{
	return GetModuleHandle(NULL);
}


static LPCWSTR GetErrorText(HRESULT hr)
{
	// Answer some suitable text for the last system error
	LPWSTR buf;
	::FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
		0, hr, 0, LPWSTR(&buf), 0, 0);
	return buf;
}

void __stdcall FatalError(HRESULT hr)
{
	LPCWSTR errorMessage = GetErrorText(hr);
	fputws(errorMessage, stderr);
	LocalFree((HLOCAL)errorMessage);
}

HRESULT __stdcall ErrorUnableToCreateVM(HRESULT hr)
{
	FatalError(ERROR_INVALID_DLL);
	return hr;
}

int __cdecl wmain(int argc, wchar_t* argv[])
{
	// The VM is created through COM, or if TO GO may still be needed to load compiler
	::CoInitialize(NULL);
 	HRESULT hr = RunEmbeddedImage(GetResLibHandle(), IDR_IMAGE);
	::CoUninitialize();

	return DecodeHRESULT(hr);
}
