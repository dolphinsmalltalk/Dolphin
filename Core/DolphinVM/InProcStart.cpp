#include "ist.h"
#include <process.h>
#include <comdef.h>
#include "resource.h"
#include "startVM.h"
//#import "DolphinSmalltalk.tlb" no_namespace raw_interfaces_only
#include "DolphinSmalltalk_i.h"
#include "ActivationContext.h"

#ifndef TO_GO
#include "..\Launcher\ImageFileMapping.h"
#include "InProcStart.h"
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

_COM_SMARTPTR_TYPEDEF(IDolphinStart, __uuidof(IDolphinStart));

static HRESULT LoadImage(IDolphinStartPtr& piDolphin, HMODULE hModule, LPCWSTR fileName, LPVOID imageData, size_t imageSize)
{
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
	HRESULT hr = piDolphin->GetVersionInfo(&vi);
	if (FAILED(hr))
		return hr;
	if (pHeader->versionMS != vi.dwProductVersionMS)
		return ErrorVMVersionMismatch(pHeader, &vi);
#else
	// A ToGo image is bound with its VM, and must therefore be of the correct version
	ASSERT(imageData != nullptr);
#endif

	return piDolphin->Initialise(hModule, fileName, imageData, imageSize, /*IsDevSys*/0);
}

// Disable warning about combination of SEH and destructors
#pragma warning(disable:4509)

static HRESULT VMStart(VMEntryArgs* pArgs)
{
	IUnknownPtr punkOuter;
	if (pArgs->piMarshalledOuter)
	{
		HRESULT hr = ::CoGetInterfaceAndReleaseStream(pArgs->piMarshalledOuter, IID_IUnknown, reinterpret_cast<void**>(&punkOuter));
		if (FAILED(hr))
			return ReportError(IDP_FAILEDTOUNMARSHALOUTER);
	}

	IDolphinStartPtr piDolphin;
	HRESULT hr = CreateVM(pArgs->clsctx, nullptr, nullptr, __uuidof(IDolphinStart), reinterpret_cast<void**>(&piDolphin));
	if (FAILED(hr))
		return hr;

	hr = LoadImage(piDolphin, pArgs->hInstance, pArgs->fileName, pArgs->imageData, pArgs->imageSize);
	if (FAILED(hr))
		return hr;

	return piDolphin->Run(punkOuter);
}

// Dolphin thread main routine - only exits when SE_VMEXIT exception is thrown (in the normal case)
static UINT __stdcall DolphinMain(void* pArgs)
{
#ifdef _DEBUG
	trace(L"%#x: DolphinMain\n", GetCurrentThreadId());
#endif

	VMEntryArgs* vmArgs = reinterpret_cast<VMEntryArgs*>(pArgs);

	// In order to get visual styles and up to date common controls and dialogs (including
	// the Task Dialog we use for message boxes), we need an activation context that is 
	// manifested to specify common controls v6, otherwise a lot of Dolphin API will not
	// work well.
	ActivationContext actCtx;
	actCtx.ModuleHandle = vmArgs->hInstance;
	actCtx.ResourceName = ISOLATIONAWARE_MANIFEST_RESOURCE_ID;
	// This is not ideal as it may result in leaking activation context, although empirically 
	// it doesn't seem to.The alternative is to activate context temporarily on every COM 
	// call-in, although it needs some though as to how best to achieve that, since we only 
	// need to do that on COM calls marshalled into the apartment when hosted in-proc.
	actCtx.IsProcessDefault = true;
	ActivationContextScope activateContext(actCtx);

	HRESULT hr = ::CoInitialize(NULL);
	if (SUCCEEDED(hr))
	{
		hr = VMStart(vmArgs);
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
	static VMEntryArgs argBlock;
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
