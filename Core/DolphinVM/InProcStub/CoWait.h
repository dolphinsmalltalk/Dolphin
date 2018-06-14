// CoWait.h : Declaration of MyCoWaitForMultipleHandles
#ifndef _COWAIT_H_
#define _COWAIT_H_

HRESULT MyCoWaitForMultipleHandles(IN DWORD dwFlags,
                                    IN DWORD dwTimeout,
                                    IN ULONG cHandles,
                                    IN LPHANDLE pHandles,
                                    OUT LPDWORD  lpdwIndex);

#endif