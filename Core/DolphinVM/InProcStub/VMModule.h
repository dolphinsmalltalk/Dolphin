#include "ComModule.h"
#include "InProcPlugHole.h"

class VMModule : public ComModuleT<DolphinIPPlugHole>
{
private:

protected:
	virtual BOOL OnProcessAttach(HINSTANCE hInst);
	virtual BOOL OnProcessDetach(HINSTANCE hInst);
	virtual BOOL OnThreadAttach(HINSTANCE hInst);
	virtual BOOL OnThreadDetach(HINSTANCE hInst);

public:
	HRESULT CanUnloadNow();
};

extern VMModule _Module;

#include "..\CritSect.h"

