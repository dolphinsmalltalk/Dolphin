/******************************************************************************

	File: InterlockedOps.h

	Description:

	InterlockedCompareExchange is not implemented on Win95, so provide our own 
	version

******************************************************************************/
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

__declspec(naked) __inline LONG __fastcall OAInterlockedDecrement(LPLONG lpAddend)
{
	UNREFERENCED_PARAMETER(lpAddend);
	_asm
	{
		mov         eax, -1
		lock xadd   dword ptr [ecx],eax 
		dec         eax  
		ret
	}
}

#undef InterlockedDecrement
#define InterlockedDecrement OAInterlockedDecrement

PVOID __stdcall OAInterlockedCompareExchange(PVOID *Destination, PVOID Exchange, PVOID Comperand);
#undef InterlockedCompareExchange
#define InterlockedCompareExchange OAInterlockedCompareExchange

// By using __fastcall convention we can save significantly on the instruction count since there are only two
// arguments. Note also that 
// Note that compiler will not inline this function if __declspec(naked) is used, and will optimize
// it incorrectly when inlined without
LONG __fastcall OAInterlockedExchange(LPLONG Target, LONG Value);
#undef InterlockedExchange
#define InterlockedExchange OAInterlockedExchange

__forceinline PVOID __stdcall OAInterlockedExchangePointer(PVOID Target, PVOID Value)
{
	return (PVOID)(OAInterlockedExchange((LPLONG)(Target), (LONG)(Value)));
}

#undef InterlockedExchangePointer
#define InterlockedExchangePointer OAInterlockedExchangePointer

#ifdef __cplusplus
}
#endif

