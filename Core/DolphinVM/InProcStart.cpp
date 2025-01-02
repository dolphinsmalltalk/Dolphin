#include "ist.h"
#include <process.h>
#include "resource.h"
#include "startVM.h"
//#import "DolphinSmalltalk.tlb" no_namespace raw_interfaces_only
#include "DolphinSmalltalk_i.h"
//#include "VMExcept.h"

#ifndef TO_GO
#include "..\Launcher\ImageFileMapping.h"
#endif

/////////////////////////////////////////////////////////////////////

struct VMEntryArgs
{
	HINSTANCE hInstance;
	LPVOID imageData;
	size_t imageSize;
	LPCWSTR fileName;
	IStream* piMarshalledOuter;
	CLSCTX clsctx;
};

static VMEntryArgs argBlock;

// Disable warning about combination of SEH and destructors
#pragma warning(disable:4509)

int __stdcall StartVM(HMODULE hModule, 
			LPVOID imageData, size_t imageSize, LPCWSTR fileName, 
			IUnknown* punkOuter, CLSCTX clsctx)
{
	IDolphinStart* piDolphin = NULL;
	HRESULT hr = CreateVM(CLSCTX_INPROC_SERVER, NULL, NULL, __uuidof(IDolphinStart), reinterpret_cast<void**>(&piDolphin));
	if (FAILED(hr))
		return hr;
	
#ifndef TO_GO
	ImageFileMapping imageFile;

	if (imageData == NULL)
	{
		int ret = imageFile.Open(fileName);
		if (ret < 0)
			return HRESULT_FROM_WIN32(ERROR_NOT_FOUND);

		if (imageFile.GetType() != ImageFileMapping::ISTIMAGE)
			return E_FAIL;

		imageData = imageFile.GetRawData();
		imageSize = imageFile.GetRawSize();
	}

	// Perform a version check to verify that the embedded image matches the loaded VM
	ImageHeader* pHeader = &(reinterpret_cast<ISTImageHeader*>(imageData)->header);
	VS_FIXEDFILEINFO vi;
	hr = piDolphin->GetVersionInfo(&vi);
	if (FAILED(hr))
		return hr;
	if (pHeader->versionMS != vi.dwProductVersionMS)
		return ErrorVMVersionMismatch(pHeader, &vi);
#else
	// A ToGo image is bound with its VM, and must therefore be of the correct version
#endif

	hr = piDolphin->Initialise(hModule, fileName, imageData, imageSize, /*IsDevSys*/0);
	if (FAILED(hr))
		return hr;

	hr = piDolphin->Run(punkOuter);
	piDolphin->Release();

	return hr;
}
static HRESULT VMStart(VMEntryArgs* pArgs)
{
	IUnknown* punkOuter;
	if (pArgs->piMarshalledOuter)
	{
		HRESULT hr = ::CoGetInterfaceAndReleaseStream(pArgs->piMarshalledOuter, IID_IUnknown, reinterpret_cast<void**>(&punkOuter));
		if (FAILED(hr))
			return ReportError(IDP_FAILEDTOUNMARSHALOUTER);
	}
	else
		punkOuter = NULL;

	return StartVM(pArgs->hInstance, 
			pArgs->imageData, pArgs->imageSize, pArgs->fileName, 
			punkOuter, pArgs->clsctx);
}

// Dolphin thread main routine - only exits when SE_VMEXIT exception is thrown (in the normal case)
static UINT __stdcall DolphinMain(void* pArgs)
{
#ifdef _DEBUG
	trace(L"%#x: DolphinMain\n", GetCurrentThreadId());
#endif

	HRESULT hr = ::CoInitialize(NULL);
	if (SUCCEEDED(hr))
	{
		hr = VMStart(reinterpret_cast<VMEntryArgs*>(pArgs));
		::CoUninitialize();
	}
	return DecodeHRESULT(hr);
}

// Spawn off the main Dolphin thread and return its handle
// Note the caller must make sure that the two strings don't go out of scope
HRESULT __stdcall VMEntry(HINSTANCE hInstance, 
						 LPVOID imageData, size_t imageSize, LPCWSTR fileName, IUnknown* punkOuter, CLSCTX ctx,
						HANDLE& hThread)
{
	argBlock.hInstance = hInstance;
	argBlock.imageData = imageData;
	argBlock.imageSize = imageSize;
	argBlock.fileName = fileName;
	argBlock.clsctx = ctx;

	if (punkOuter)
	{
		HRESULT hr = ::CoMarshalInterThreadInterfaceInStream(IID_IUnknown, punkOuter, &argBlock.piMarshalledOuter);
		if (FAILED(hr))
			return ReportError(IDP_FAILEDTOMARSHALOUTER);
	}
	else 
		argBlock.piMarshalledOuter = NULL;

	unsigned int threadId;
	hThread = (HANDLE)_beginthreadex(NULL, 0, &DolphinMain, &argBlock, 0, &threadId);

	if (hThread == (HANDLE)-1)
		return ReportError(IDP_FAILTOSTARTTHREAD);
	
	return S_OK;
}
