#ifndef __COMPILERDLL_H_
#define __COMPILERDLL_H_

#include "ComModule.h"
#include "compiler.h"

class Compiler;

class CDolphinCompilerModule : public ComModuleT<Compiler>
{
private:

public :
};

extern CDolphinCompilerModule _Module;

#endif //__COMPILERDLL_H_
