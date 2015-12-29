/******************************************************************************

	File: RaiseThreadException.h

	Description:

	Handy routine for raising an exception in another thread by queueing
	an APC (will only get executed when the thread enters an alertable state
	such as when calls WaitForSingleObjectEx())

******************************************************************************/
#pragma once

#ifdef __cplusplus
extern "C" 
{
#endif

void __stdcall RaiseThreadException(
	HANDLE hThread,
    DWORD dwExceptionCode,
    DWORD dwExceptionFlags,
    DWORD nNumberOfArguments,
    CONST DWORD *lpArguments);

#ifdef __cplusplus
}
#endif
