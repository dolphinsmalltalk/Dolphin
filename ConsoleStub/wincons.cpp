#include "ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#ifndef _CONSOLE
	#error Intended for use only in console VMs
#endif

#include <process.h>
#include <stdlib.h>

#include "ObjMem.h"
#include "Interprt.h"

void __stdcall DolphinFatalExit(int exitCode, const char* msg)
{
	int result = fprintf(stderr, "%s\n", msg);
	FatalExit(exitCode);
}

int __stdcall DolphinMessage(UINT flags, const char* msg)
{
	fprintf(stderr, "%s\n", msg);
	return 0;
}

BOOL __fastcall Interpreter::primitiveHookWindowCreate()
{
	return FALSE;
}

#pragma code_seg(INIT_SEG)
HRESULT Interpreter::initializeImage()
{
	// Nothing to do
	return S_OK;
}

#pragma code_seg(TERM_SEG)
void Interpreter::GuiShutdown()
{
}

