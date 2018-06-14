#include "stdafx.h"
#include "resource.h"
#include <initguid.h>
#include "..\Compiler_i.h"
#include "..\Compiler_i.c"
#include "Compiler.h"

//////////////////////////////////////////////////////////////////
// Global Variables:

CDolphinCompilerModule _Module;

/////////////////////////////////////////////////////////////////////////////

HMODULE __stdcall GetResLibHandle()
{
	return _AtlBaseModule.m_hInst;
}

/////////////////////////////////////////////////////////////////////////////
// Common DLL Entry Point and registration implementation

#include "..\DllModule.cpp"

