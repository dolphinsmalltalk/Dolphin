//DevRes.cpp

#include <windows.h>

// Entry point. 
__declspec(dllexport) BOOL   WINAPI   DllMain(HANDLE hInst, 
                        ULONG ul_reason_for_call,
                        LPVOID lpReserved)
{
	return TRUE;
}
