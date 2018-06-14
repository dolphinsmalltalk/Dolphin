// startVM.cpp

#include "ist.h"
#include <process.h>
#include <io.h>
#include "startVM.h"
#include "rc_stub.h"
#include "DolphinSmalltalk_i.h"

#if defined(TO_GO)
#error "Not for use in ToGo build"
#endif

/////////////////////////////////////////////////////////////////////////////
// Globals

/////////////////////////////////////////////////////////////////////

HRESULT __stdcall CheckVmVersion(IDolphinStart* piDolphin, ImageFileResource imageFile)
{
	// Perform a version check to verify that the embedded image matches the loaded VM
	ImageHeader* pHeader = imageFile.GetHeader();
	VS_FIXEDFILEINFO vi;
	HRESULT hr = piDolphin->GetVersionInfo(&vi);
	if (FAILED(hr))
		return hr;
	if (pHeader->versionMS != vi.dwProductVersionMS)
		return ErrorVMVersionMismatch(pHeader, &vi);

	return S_OK;
}
