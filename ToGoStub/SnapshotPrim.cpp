/******************************************************************************

	File: SnapshotPrim.cpp

	Description:

	Implementation of the Interpreter class' snapshot/quit primitive methods

******************************************************************************/
#include "Ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#if !defined(TO_GO)
	#error For use only in To Go VMs
#endif

#include "ObjMem.h"
#include "Interprt.h"

#pragma auto_inline(off)

Oop* __fastcall Interpreter::primitiveSnapshot(CompiledMethod& , unsigned argCount)
{
	return NULL;
}
