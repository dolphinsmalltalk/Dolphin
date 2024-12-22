#ifndef __VMDLL_H_
#define __VMDLL_H_

#include "DllModule.h"

class CDolphinVMModule : public CDolphinDllModuleT<CDolphinVMModule>
{
private:
	HRESULT RegisterAsEventSource() const;

public :

	DECLARE_LIBID(LIBID_DolphinVM)
	//DECLARE_REGISTRY_APPID_RESOURCEID(IDR_DOLPHINSMALLTALK, "{F797E72A-F7ED-4B65-9FD9-A850ACA48983}")

	HRESULT RegisterServer(BOOL bRegTypeLib = TRUE) throw();

	virtual HRESULT GetGITPtr(IGlobalInterfaceTable**) throw()
	{
		return E_NOTIMPL;
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

extern CDolphinVMModule _Module;

#endif //__VMDLL_H_
