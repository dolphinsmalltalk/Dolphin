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

BOOL __fastcall Interpreter::primitiveMakePoint(CompiledMethod&, unsigned argCount)
{
		Oop oopReceiver = stackValue(argCount);
		if (!ObjectMemory::isBehavior(oopReceiver))
			return primitiveFailure(0);
		BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(oopReceiver);
		Behavior* behavior = oteClass->m_location;
		
		if (behavior->isBytes())
			return primitiveFailure(1);
		
		MWORD oops = argCount;
		if (behavior->isIndexable())
		{
			oops += behavior->fixedFields();
		}
		else
		{
			if (behavior->fixedFields() != oops)
				return primitiveFailure(2);

		}

		// Note that instantiateClassWithPointers counts up the class,
		PointersOTE* oteObj = ObjectMemory::newPointerObject(oteClass, oops);
		VariantObject* obj = oteObj->m_location;
		for (int i=oops-1;i>=0;i--)
		{
			Oop oopArg = popStack();
			ObjectMemory::countUp(oopArg);
			obj->m_fields[i] = oopArg;
		}
		replaceStackTopWithNew(oteObj);

	return TRUE;
}

