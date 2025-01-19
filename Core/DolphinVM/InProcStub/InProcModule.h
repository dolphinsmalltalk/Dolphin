#include "ComModule.h"
#include "InProcPlugHole.h"
#include "ActivationContext.h"

class IPDolphinModule : public ComModuleT<DolphinIPPlugHole>
{
public:
	IPDolphinModule() : m_actCtx(GetHModule())
	{
	}

protected:
	virtual BOOL OnProcessAttach(HINSTANCE hInst);
	virtual BOOL OnProcessDetach(HINSTANCE hInst);
	virtual BOOL OnThreadAttach(HINSTANCE hInst);
	virtual BOOL OnThreadDetach(HINSTANCE hInst);

public:
	HRESULT CanUnloadNow();

	ActivationContextScope Activate()
	{
		return ActivationContextScope(m_actCtx);
	}

private:
	::ActivationContext m_actCtx;
};

extern IPDolphinModule _Module;

#include "..\CritSect.h"

