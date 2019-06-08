/******************************************************************************

	File: InterprtPrim.Inl

	Description:

	Private inlines for the interpreter's primitive routine bodules

******************************************************************************/

#include "STProcess.h"	// In order to be able to set primitive failure code

inline void ST::Process::SetPrimitiveFailureData(Oop failureData)
{
	ObjectMemory::countDown(m_primitiveFailureData);
	ObjectMemory::countUp(failureData);
	m_primitiveFailureData = failureData;
}

inline void ST::Process::SetPrimitiveFailureData(OTE* failureData)
{
	ObjectMemory::countDown(m_primitiveFailureData);
	failureData->countUp();
	m_primitiveFailureData = reinterpret_cast<Oop>(failureData);
}

inline void ST::Process::SetPrimitiveFailureData(SMALLINTEGER failureData)
{
	ObjectMemory::countDown(m_primitiveFailureData);
	m_primitiveFailureData = integerObjectOf(failureData);
}

__forceinline Oop* Interpreter::primitiveFailure(_PrimitiveFailureCode failureCode)
{
	return reinterpret_cast<Oop*>(ObjectMemoryIntegerObjectOf(static_cast<int>(failureCode)));
}

inline Oop* Interpreter::primitiveFailureWith(_PrimitiveFailureCode failureCode, Oop failureData)
{
	Process* proc = actualActiveProcess();
	proc->SetPrimitiveFailureData(failureData);
	return primitiveFailure(failureCode);
}

inline Oop* Interpreter::primitiveFailureWith(_PrimitiveFailureCode failureCode, OTE* oteFailure)
{
	ASSERT(!ObjectMemoryIsIntegerObject(oteFailure));
	Process* proc = actualActiveProcess();
	proc->SetPrimitiveFailureData(oteFailure);
	return primitiveFailure(failureCode);
}

// Just to avoid any confusion with Oop overload, give this one a different name
inline Oop* Interpreter::primitiveFailureWithInt(_PrimitiveFailureCode failureCode, SMALLINTEGER failureData)
{
	Process* proc = actualActiveProcess();
	proc->SetPrimitiveFailureData(failureData);
	return primitiveFailure(failureCode);
}
