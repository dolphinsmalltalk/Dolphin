#include "pch.h"
#include "framework.h"
#include "resource.h"
#include "ActiveXHost.h"
#include "dllmain.h"
#include "xdlldata.h"

//////////////////////////////////////////////////////////////////
// Global Variables:

CDolphinAXHostModule _Module;

/////////////////////////////////////////////////////////////////////////////

HMODULE __stdcall GetResLibHandle()
{
	// See MSJ May 1996
	MEMORY_BASIC_INFORMATION mbi;
	::VirtualQuery(GetResLibHandle, &mbi, sizeof(mbi));
	return HMODULE(mbi.AllocationBase);
}

// Common DLL Entry Point and registration implementation

#include "..\DllModule.cpp"

