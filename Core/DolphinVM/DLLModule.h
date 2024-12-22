#pragma once

#define _ATL_ALL_WARNINGS
#include <atlbase.h>
#include <atlcom.h>

/////////////////////////////////////////////////////////////////////////////
// CDolphinModule

extern HRESULT UpdateRegistryClass(const CLSID& clsid, LPCTSTR lpszProgID,
			LPCTSTR lpszVerIndProgID, UINT nDescID, DWORD dwFlags, BOOL bRegister);

template <class T>
class ATL_NO_VTABLE CDolphinDllModuleT : public CAtlDllModuleT<T>
{
public :
	HRESULT UpdateRegistryClass(const CLSID& clsid, LPCTSTR lpszProgID,
			LPCTSTR lpszVerIndProgID, UINT nDescID, DWORD dwFlags, BOOL bRegister)
	{
		return ::UpdateRegistryClass(clsid, lpszProgID, lpszVerIndProgID, nDescID, dwFlags, bRegister);
	}

	
	bool IsRunningElevated() const
	{
		HANDLE token = NULL;
		DWORD size;
		if (!::OpenProcessToken(::GetCurrentProcess(), TOKEN_QUERY, &token))
			return false;

		TOKEN_ELEVATION elevation = { 0 };
		::GetTokenInformation(token, TokenElevation, &elevation, sizeof(elevation), &size);
		::CloseHandle(token);
		return elevation.TokenIsElevated;
	}
};
