#include "stdafx.h"
#include "resource.h"
#include <initguid.h>
#include "..\Compiler_i.h"
#include "..\Compiler_i.c"
#include "Compiler.h"
#include "CompilerDLL.h"

//////////////////////////////////////////////////////////////////
// Global Variables:

CDolphinCompilerModule _Module;

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
