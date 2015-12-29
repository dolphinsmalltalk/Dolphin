#ifndef __DLLMODULE_H_
#define __DLLMODULE_H_

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
	//HRESULT RegisterServer(BOOL bRegTypeLib = TRUE) throw();

	HRESULT UpdateRegistryClass(const CLSID& clsid, LPCTSTR lpszProgID,
			LPCTSTR lpszVerIndProgID, UINT nDescID, DWORD dwFlags, BOOL bRegister)
	{
		return ::UpdateRegistryClass(clsid, lpszProgID, lpszVerIndProgID, nDescID, dwFlags, bRegister);
	}
};

#endif //__DLLMODULE_H_
