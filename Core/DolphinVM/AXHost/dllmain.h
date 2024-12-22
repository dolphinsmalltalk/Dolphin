#pragma once

#include "..\DllModule.h"

class CDolphinAXHostModule : public CDolphinDllModuleT<CDolphinAXHostModule, true>
{
public:
	DECLARE_LIBID(LIBID_ActiveXHost)
};

extern CDolphinAXHostModule _Module;