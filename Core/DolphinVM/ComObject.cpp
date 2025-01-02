#include "ist.h"
#include "ComObject.h"
#include "ComModule.h"

void ComObjectBase::LockModule()
{
	Module::Instance->Lock();
}

void ComObjectBase::UnlockModule()
{
	Module::Instance->Unlock();
}
