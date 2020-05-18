#include "Ist.h"
#pragma code_seg(INTERP_SEG)

#include "ObjMem.h"
#include "Interprt.h"

#include "rc_vm.h"
#include "InterprtProc.inl"
#include "VMExcept.h"

#include "STBehavior.h"
#include "STMessage.h"

#ifndef NO_DNU

__declspec(noinline) Interpreter::MethodCacheEntry* __fastcall Interpreter::messageNotUnderstood(BehaviorOTE* classPointer, const argcount_t argCount)
{
	#if defined(_DEBUG)
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM << classPointer << L" does not understand " << m_oopMessageSelector << std::endl << std::ends;
	}
	#endif

	// Check for recursive not understood error
	if (m_oopMessageSelector == Pointers.DoesNotUnderstandSelector)
		RaiseFatalError(IDP_RECURSIVEDNU, 2, reinterpret_cast<uintptr_t>(classPointer), reinterpret_cast<uintptr_t>(m_oopMessageSelector->m_location));

	createActualMessage(argCount);
	m_oopMessageSelector = Pointers.DoesNotUnderstandSelector;
	// Recursively invoke to find #doesNotUnderstand: in class
	return findNewMethodInClass(classPointer, 1);
}

#endif