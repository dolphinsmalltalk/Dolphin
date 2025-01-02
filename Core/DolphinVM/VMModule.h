#ifndef __VMDLL_H_
#define __VMDLL_H_

#include "ComModule.h"
#include "DolphinSmalltalk.h"

class VMModule : public ComModuleT<DolphinSmalltalk>
{
private:

public:
};

extern VMModule _Module;

#endif //__VMDLL_H_
