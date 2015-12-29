/******************************************************************************

	File: InterlockedOps.c

	Description:

	These are duplicates of the NT interlocked operations, implemented because:
	1) Win95 does not implement some of them at all
	2) Win95 implements some of them differently (and less usefully)
	3) Local copies avoid the indirection through the DLL import jump, and therefore
	offer improved performance

******************************************************************************/
#pragma warning(push,3)
#include <wtypes.h>
#include "InterlockedOps.h"

// Disable warning about no return value (cos there is one)
#pragma warning (disable : 4035)

// Not implemented under Win95 (sigh).
// This is the exact NT implementation, which is really just a wrapper around an assembler instruction
__declspec(naked) PVOID __stdcall OAInterlockedCompareExchange(PVOID *Destination, PVOID Exchange, PVOID Comperand)
{
	UNREFERENCED_PARAMETER(Destination); 
	UNREFERENCED_PARAMETER(Exchange); 
	UNREFERENCED_PARAMETER(Comperand);

	_asm
	{
		mov		ecx, DWORD PTR [esp+4]
		mov		edx, DWORD PTR [esp+8]
		mov		eax, DWORD PTR [esp+12]
		lock cmpxchg DWORD PTR [ecx],edx
		ret		12
	}
}

// By using __fastcall convention we can save significantly on the instruction count since there are only two
// arguments
__declspec(naked) LONG __fastcall OAInterlockedExchange(LPLONG Target, LONG Value)
{
	UNREFERENCED_PARAMETER(Target);
	UNREFERENCED_PARAMETER(Value);

	_asm
	{
		mov		eax,dword ptr [ecx]
	label:
		lock cmpxchg dword ptr [ecx],edx
		jne         label					// Swap it back?
		ret
	}
}
