/******************************************************************************

	File: RegKey.h

	Description:

******************************************************************************/
#pragma once

#define _ATL_ALL_WARNINGS
#include <atlbase.h>

extern const char* SZREGKEYBASE;

inline LONG OpenDolphinKey(CRegKey& rkey, LPCTSTR lpszKeyName, REGSAM samDesired=KEY_READ)
{
	TCHAR szKey[512];
	_tcscpy(szKey, SZREGKEYBASE);
	if (*lpszKeyName)
	{
		_tcscat(szKey, _T("\\"));
		_tcscat(szKey, lpszKeyName);
	}

	return rkey.Open(HKEY_LOCAL_MACHINE, szKey, samDesired);	
}

