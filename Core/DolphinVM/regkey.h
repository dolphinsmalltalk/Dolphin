/******************************************************************************

	File: RegKey.h

	Description:

******************************************************************************/
#pragma once

#define _ATL_ALL_WARNINGS
#include <atlbase.h>

extern const wchar_t* SZREGKEYBASE;

inline LONG OpenDolphinKey(CRegKey& rkey, LPCWSTR lpszKeyName, REGSAM samDesired=KEY_READ)
{
	std::wstring key = SZREGKEYBASE;
	if (*lpszKeyName)
	{
		key = key + L"\\" + lpszKeyName;
	}

	return rkey.Open(HKEY_LOCAL_MACHINE, key.c_str(), samDesired);	
}

