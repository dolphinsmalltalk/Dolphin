/******************************************************************************

	File: InterprtPrim.Inl

	Description:

	Private inlines for the interpreter's primitive routine bodules

******************************************************************************/

#ifndef _IST_INTERPRT_H_
	#error You'll need to include interprt.h
#endif

#include "STProcess.h"	// In order to be able to set primitive failure code

#define primitiveSuccess() TRUE

inline BOOL Interpreter::primitiveFailure(int failureCode)
{
	m_registers.activeProcess()->SetPrimitiveFailureCode(failureCode);
	return FALSE;
}

inline BOOL Interpreter::primitiveFailureWith(int failureCode, Oop failureData)
{
	Process* proc = m_registers.activeProcess();
	proc->SetPrimitiveFailureCode(failureCode);
	proc->SetPrimitiveFailureData(failureData);
	return FALSE;
}

inline BOOL Interpreter::primitiveFailureWith(int failureCode, OTE* oteFailure)
{
	ASSERT(!ObjectMemoryIsIntegerObject(oteFailure));
	Process* proc = m_registers.activeProcess();
	proc->SetPrimitiveFailureCode(failureCode);
	proc->SetPrimitiveFailureData(oteFailure);
	return FALSE;
}

// Just to avoid any confusion with Oop overload, give this one a different name
inline BOOL Interpreter::primitiveFailureWithInt(int failureCode, SMALLINTEGER failureData)
{
	Process* proc = m_registers.activeProcess();
	proc->SetPrimitiveFailureCode(failureCode);
	proc->SetPrimitiveFailureData(failureData);
	return FALSE;
}


