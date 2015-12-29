//DevRes.cpp

#include <windows.h>

// Entry point. 
BOOL   WINAPI   DllMain(HANDLE hInst, 
                        ULONG ul_reason_for_call,
                        LPVOID lpReserved)
{
	::DisableThreadLibraryCalls(static_cast<HMODULE>(hInst));
	return TRUE;
}
