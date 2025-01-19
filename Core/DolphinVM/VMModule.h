#ifndef __VMDLL_H_
#define __VMDLL_H_

#include "ComModule.h"
#include "DolphinSmalltalk.h"
#include "ActivationContext.h"

class VMModule : public ComModuleT<DolphinSmalltalk>
{
#if defined(VMDLL)
public:
	VMModule() : m_actCtx(GetHModule())
	{
	}

	ActivationContextScope Activate()
	{
		return ActivationContextScope(m_actCtx);
	}

private:
	::ActivationContext m_actCtx;
#endif

};

extern VMModule _Module;

#endif //__VMDLL_H_
