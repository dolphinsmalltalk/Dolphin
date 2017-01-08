/******************************************************************************

	File: PointPrim.cpp

	Description:

	Implementation of the Interpreter class' Point primitive methods

	Eventually we'll jump to these directly as they don't take any parameters

******************************************************************************/
#include "Ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

// Smalltalk classes
#include "STBehavior.h"

Oop* __fastcall Interpreter::primitiveMakePoint(CompiledMethod&, unsigned argCount)
{
	Oop* sp = m_registers.m_stackPointer;
	Oop oopReceiver = *(sp-argCount);
	if (!ObjectMemory::isBehavior(oopReceiver))
		return primitiveFailure(0);
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(oopReceiver);
	Behavior* behavior = oteClass->m_location;

	if (behavior->isBytes())
		return primitiveFailure(1);

	size_t minSize = behavior->fixedFields();
	size_t i;
	if (behavior->isIndexable())
	{
		i = max(minSize, argCount);
	}
	else
	{
		if (argCount > minSize)
		{
			// Not indexable, and too many fields
			return primitiveFailure(2);
		}
		i = minSize;
	}

	// Note that instantiateClassWithPointers counts up the class,
	PointersOTE* oteObj = ObjectMemory::newUninitializedPointerObject(oteClass, i);
	VariantObject* obj = oteObj->m_location;

	// nil out any extra fields
	const Oop nil = reinterpret_cast<Oop>(Pointers.Nil);
	while (i > argCount)
	{
		obj->m_fields[--i] = nil;
	}

	while (i != 0)
	{
		i--;
		Oop oopArg = *sp--;
		ObjectMemory::countUp(oopArg);
		obj->m_fields[i] = oopArg;
	}

	// Save down SP in case ZCT is reconciled on adding result, allowing unref'd args to be reclaimed
	m_registers.m_stackPointer = sp;
	*sp = reinterpret_cast<Oop>(oteObj);
	ObjectMemory::AddToZct(oteObj);
	return sp;
}

