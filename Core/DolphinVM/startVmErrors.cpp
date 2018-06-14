// startVM.cpp

#include "ist.h"
#include <process.h>
#include <io.h>
#include "startVM.h"
#include "VMExcept.h"
#include "rc_stub.h"

#if defined(TO_GO)
#error "Not for use in ToGo build"
#endif

/////////////////////////////////////////////////////////////////////

HRESULT __stdcall ErrorVMNotRegistered(HRESULT hr, LPCWSTR szFileName)
{
	return ReportWin32Error(IDP_VMNOTREGISTERED, hr, szFileName);
}

HRESULT __stdcall ErrorVMVersionMismatch(ImageHeader* pHeader, VS_FIXEDFILEINFO* pvi)
{
	return ReportError(IDS_APPNAME, IDP_VERSIONMISMATCH, 
		HIWORD(pHeader->versionMS), LOWORD(pHeader->versionMS), HIWORD(pHeader->versionLS), LOWORD(pHeader->versionLS),
		HIWORD(pvi->dwProductVersionMS), LOWORD(pvi->dwProductVersionMS), HIWORD(pvi->dwProductVersionLS), LOWORD(pvi->dwProductVersionLS));
}