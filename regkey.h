/******************************************************************************

	File: RegKey.h

	Description:

	CRegKey class (borrowed from ATL)

******************************************************************************/
#ifndef _REGKEY_H_
#define _REGKEY_H_

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

/*inline bool __stdcall GetInstallationPath(char* buf, const char* filePart)
{
	buf[0] = 0;
	CRegKey rkInstall;
	bool bFound = false;
	if (OpenDolphinKey(rkInstall, "") == ERROR_SUCCESS)
	{
		DWORD dwSize = _MAX_DIR;
		if (rkInstall.QueryValue(buf, "", &dwSize) == ERROR_SUCCESS)
		{
			strcat(buf, "\\");
			bFound = true;
		}
	}

	strcat(buf, filePart);

	return bFound;
}
*/

#endif
