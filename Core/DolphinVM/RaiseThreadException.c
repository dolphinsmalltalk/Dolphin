/******************************************************************************

	File: RaiseThreadException.c

	Description:

	Handy routine for raising an exception in another thread by queueing
	an APC (will only get executed when the thread enters an alertable state
	such as when calls WaitForSingleObjectEx())

******************************************************************************/
#define _WIN32_WINNT 0x0400
#include <wtypes.h>
#include <stdlib.h>
#include <malloc.h>
#include <winbase.h>
#include "RaiseThreadException.h"
#include "heap.h"

#pragma warning(disable:4200)

typedef struct _ThreadExceptionInfoBlock
{
    DWORD dwExceptionCode;
    DWORD dwExceptionFlags;
    DWORD nNumberOfArguments;
    CONST ULONG_PTR lpArguments[];
} ThreadExceptionInfoBlock;

static void __stdcall APCFunc(ULONG_PTR param)
{
	ThreadExceptionInfoBlock* pBlock = (ThreadExceptionInfoBlock*)param;
	DWORD dwExceptionCode = pBlock->dwExceptionCode;
	DWORD dwExceptionFlags = pBlock->dwExceptionFlags;
	DWORD nNumberOfArguments = pBlock->nNumberOfArguments;
	DWORD argsSize = nNumberOfArguments*sizeof(ULONG_PTR);
	ULONG_PTR* lpArguments = (ULONG_PTR*)alloca(argsSize);
	memcpy(lpArguments, pBlock->lpArguments, argsSize);
	free(pBlock);
	RaiseException(dwExceptionCode, dwExceptionFlags, nNumberOfArguments, lpArguments);
}

// Raise an exception in the specified thread, at the next opportunity
void __stdcall RaiseThreadException(
	HANDLE hThread,
    DWORD dwExceptionCode,
    DWORD dwExceptionFlags,
    DWORD nNumberOfArguments,
    CONST ULONG_PTR *lpArguments)
{
	DWORD argsSize = nNumberOfArguments*sizeof(DWORD);
	ThreadExceptionInfoBlock* pBlock = (ThreadExceptionInfoBlock*)malloc(sizeof(ThreadExceptionInfoBlock)+argsSize);
	pBlock->dwExceptionCode = dwExceptionCode;
	pBlock->dwExceptionFlags = dwExceptionFlags;
	pBlock->nNumberOfArguments = nNumberOfArguments;
	memcpy((void*)pBlock->lpArguments, lpArguments, argsSize);
	QueueUserAPC(APCFunc, hThread, (ULONG_PTR)pBlock);
}