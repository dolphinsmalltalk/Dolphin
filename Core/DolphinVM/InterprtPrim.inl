/******************************************************************************

	File: InterprtPrim.Inl

	Description:

	Private inlines for the interpreter's primitive routine bodules

******************************************************************************/

#include "STProcess.h"	// In order to be able to set primitive failure code

inline void ST::Process::SetPrimitiveFailureCode(SMALLINTEGER code)
{
	m_primitiveFailureCode = integerObjectOf(code);
}

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

inline Oop* Interpreter::primitiveFailure(int failureCode)
{
	m_registers.m_pActiveProcess->m_primitiveFailureCode = integerObjectOf(failureCode);
	return NULL;
}

inline Oop* Interpreter::primitiveFailureWith(int failureCode, Oop failureData)
{
	Process* proc = actualActiveProcess();
	proc->m_primitiveFailureCode = integerObjectOf(failureCode);
	proc->SetPrimitiveFailureData(failureData);
	return NULL;
}

inline Oop* Interpreter::primitiveFailureWith(int failureCode, OTE* oteFailure)
{
	ASSERT(!ObjectMemoryIsIntegerObject(oteFailure));
	Process* proc = actualActiveProcess();
	proc->m_primitiveFailureCode = integerObjectOf(failureCode);
	proc->SetPrimitiveFailureData(oteFailure);
	return NULL;
}

// Just to avoid any confusion with Oop overload, give this one a different name
inline Oop* Interpreter::primitiveFailureWithInt(int failureCode, SMALLINTEGER failureData)
{
	Process* proc = actualActiveProcess();
	proc->m_primitiveFailureCode = integerObjectOf(failureCode);
	proc->SetPrimitiveFailureData(failureData);
	return NULL;
}

#ifdef _M_IX86
// ldiv is not an intrinsic, but a DLL import. Define our own - note the inverted args, which allow for a more efficient implementation
inline __declspec(naked) ldiv_t __fastcall quoRem(int /*deonimator*/, int /*numerator*/)
{
	_asm
	{
		mov		eax, edx		; Get numerator into eax for divide
		cdq						; Sign extend into edx
		idiv	ecx				; Sadly IDIV does not change the flags in a predictable way
		ret
	}
}
#else
inline ldiv_t quoRem(long denominator, long numerator)
{
	return ldiv(numerator, denominator);
}
#endif
