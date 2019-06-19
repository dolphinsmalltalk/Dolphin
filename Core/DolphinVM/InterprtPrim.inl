/******************************************************************************

	File: InterprtPrim.Inl

	Description:

	Private inlines for the interpreter's primitive routine bodules

******************************************************************************/

#include "STProcess.h"	// In order to be able to set primitive failure code

__forceinline Oop* Interpreter::primitiveFailure(_PrimitiveFailureCode failureCode)
{
	ASSERT(ObjectMemoryIsIntegerObject(failureCode));
	return reinterpret_cast<Oop*>(failureCode);
}
