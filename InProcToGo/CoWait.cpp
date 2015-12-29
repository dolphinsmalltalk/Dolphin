#include "stdafx.h"
#include "cowait.h"

// Redefine because not in the old VC++ headers
/*typedef enum tagCOWAIT_FLAGS
{
  COWAIT_WAITALL = 1,
  COWAIT_ALERTABLE = 2
}COWAIT_FLAGS;
*/

typedef HRESULT (STDAPICALLTYPE* CoWaitFp)(IN DWORD dwFlags,
						IN DWORD dwTimeout,
                        IN ULONG cHandles,
                        IN LPHANDLE pHandles,
                        OUT LPDWORD  lpdwindex);

static HRESULT STDAPICALLTYPE _MyCoWaitForMultipleHandles(IN DWORD dwFlags,
                                    IN DWORD dwTimeout,
                                    IN ULONG cHandles,
                                    IN LPHANDLE pHandles,
                                    OUT LPDWORD  lpdwIndex)
{
	DWORD dwRet;
	while ((dwRet = ::MsgWaitForMultipleObjects(
		cHandles, pHandles, (dwFlags & /*COWAIT_WAITALL*/1),
		dwTimeout, QS_ALLINPUT))
			== WAIT_OBJECT_0 + cHandles)
	{
		MSG msg;
		while (PeekMessage(&msg, 0, 0, 0, PM_NOREMOVE))
		{
			if (GetMessage(&msg, 0, 0, 0) <= 0)
				return NULL;

			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}

	if (dwRet == WAIT_TIMEOUT || dwRet == WAIT_ABANDONED)
	{
		*lpdwIndex = -1;
		return RPC_S_CALLPENDING;
	}
	else
	{
		*lpdwIndex = dwRet - WAIT_OBJECT_0;
		return S_OK;
	}
}

CoWaitFp GetCoWait()
{
	static CoWaitFp pFn = NULL;

	if (pFn == NULL)
	{
		HMODULE hLib = ::LoadLibrary("OLE32");
		pFn = reinterpret_cast<CoWaitFp>(::GetProcAddress(hLib, "CoWaitForMultipleHandles"));
		::FreeLibrary(hLib);
		if (!pFn)
		{
			pFn = _MyCoWaitForMultipleHandles;
		}
	}

	return pFn;
}

HRESULT MyCoWaitForMultipleHandles(IN DWORD dwFlags,
                                    IN DWORD dwTimeout,
                                    IN ULONG cHandles,
                                    IN LPHANDLE pHandles,
                                    OUT LPDWORD  lpdwIndex)
{
	CoWaitFp pWaitFn = GetCoWait();
	return pWaitFn(dwFlags, dwTimeout, cHandles, pHandles, lpdwIndex);
}
