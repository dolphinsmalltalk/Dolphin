#pragma once

#ifndef VMDLL

#include "ImageHeader.h"
#if defined(TO_GO)
	#include "DolphinSmalltalk.h"
#else
	#include "DolphinSmalltalk_i.h"
#endif
#include "ImageFileResource.h"

HRESULT __stdcall VMEntry(HINSTANCE hInstance, 
					LPVOID imageData, UINT imageSize, LPCWSTR fileName, IUnknown* punkOuter, CLSCTX clsContext,
					HANDLE& hThread);
HRESULT __stdcall CreateVM(CLSCTX, const CLSID*, LPCWSTR, const IID&, void**);

// To start an application from an embedded image
HRESULT __stdcall RunEmbeddedImage(HMODULE hModule, int resId);

HRESULT __stdcall CheckVmVersion(IDolphinStart* piDolphin, ImageFileResource imageFile);

HRESULT __stdcall ErrorUnableToCreateVM(HRESULT hr);
HRESULT __stdcall ErrorVMNotRegistered(HRESULT hr, LPCWSTR);
HRESULT __stdcall ErrorVMVersionMismatch(ImageHeader* pHeader, VS_FIXEDFILEINFO* pvi);

#define DecodeHRESULT(hr) (HRESULT_FACILITY(hr) == FACILITY_ITF ? HRESULT_CODE(hr) - 2000 : HRESULT_CODE(hr));

#endif
