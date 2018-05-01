#include "ist.h"

#ifdef _CONSOLE

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include <process.h>
#include <stdlib.h>

#include "ObjMem.h"
#include "Interprt.h"

void __stdcall DolphinFatalExit(int exitCode, const wchar_t* msg)
{
	int result = fwprintf(stderr, L"%s\n", msg);
	FatalExit(exitCode);
}

int __stdcall DolphinMessage(UINT flags, const wchar_t* msg)
{
	fwprintf(stderr, L"%s\n", msg);
	return 0;
}

Oop* __fastcall Interpreter::primitiveHookWindowCreate(Oop* const sp)
{
	return NULL;
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

#endif
