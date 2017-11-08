/******************************************************************************

	File: MemPrim.cpp

	Description:

	Implementation of the Interpreter class' primitive methods for instantiating
	new objects

******************************************************************************/
#include "Ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#pragma code_seg(MEM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

// Smalltalk classes
#include "STBehavior.h"

///////////////////////////////////////////////////////////////////////////////
//	Storage Management Primitives

Oop* __fastcall Interpreter::primitiveNew(Oop* const sp)
{
	// This form of C code results in something very close to the hand-coded assembler original for primitiveNew

	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*sp);
	InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;
	if (!(instSpec.m_indexable || instSpec.m_nonInstantiable))
	{
		PointersOTE* newObj = ObjectMemory::newPointerObject(oteClass, instSpec.m_fixedFields);
		*sp = reinterpret_cast<Oop>(newObj);
		ObjectMemory::AddToZct((OTE*)newObj);
		return sp;
	}
	else
	{
		return primitiveFailure(instSpec.m_nonInstantiable ? 1 : 0);
	}
}

Oop* __fastcall Interpreter::primitiveNewWithArg(Oop* const sp)
{
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*(sp - 1));
	Oop oopArg = (*sp);
	// Unfortunately the compiler can't be persuaded to perform this using just the sar and conditional jumps on no-carry and signed;
	// it generates both the bit test and the shift.
	SMALLINTEGER size;
	if (isIntegerObject(oopArg) && (size = ObjectMemoryIntegerValueOf(oopArg)) >= 0)
	{
		InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;
		if ((instSpec.m_value & (InstanceSpecification::IndexableMask | InstanceSpecification::NonInstantiableMask)) == InstanceSpecification::IndexableMask)
		{
			if (instSpec.m_pointers)
			{
				PointersOTE* newObj = ObjectMemory::newPointerObject(oteClass, size + instSpec.m_fixedFields);
				*(sp - 1) = reinterpret_cast<Oop>(newObj);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObj));
				return sp - 1;
			}
			else
			{
				BytesOTE* newObj = ObjectMemory::newByteObject(oteClass, size);
				*(sp - 1) = reinterpret_cast<Oop>(newObj);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObj));
				return sp - 1;
			}
		}
		else
		{
			// Not indexable, or non-instantiable
			return primitiveFailure(instSpec.m_nonInstantiable ? 1 : 2);
		}
	}
	else
	{
		return primitiveFailure(0);	// Size must be positive SmallInteger
	}
}

Oop* __fastcall Interpreter::primitiveNewPinned(Oop* const sp)
{
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*(sp - 1));
	Oop oopArg = (*sp);
	SMALLINTEGER size;
	if (isIntegerObject(oopArg) && (size = ObjectMemoryIntegerValueOf(oopArg)) >= 0)
	{
		InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;
		if (!(instSpec.m_pointers || instSpec.m_nonInstantiable))
		{
			BytesOTE* newObj = ObjectMemory::newByteObject(oteClass, size);
			*(sp - 1) = reinterpret_cast<Oop>(newObj);
			ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObj));
			return sp - 1;
		}
		else
		{
			// Not indexable, or non-instantiable
			return primitiveFailure(instSpec.m_nonInstantiable ? 1 : 2);
		}
	}
	else
	{
		return primitiveFailure(0);	// Size must be positive SmallInteger
	}
}

Oop* __fastcall Interpreter::primitiveNewInitializedObject(Oop* sp, unsigned argCount)
{
	Oop oopReceiver = *(sp - argCount);
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(oopReceiver);
	InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;

	if ((instSpec.m_value & (InstanceSpecification::PointersMask| InstanceSpecification::NonInstantiableMask)) == InstanceSpecification::PointersMask)
	{
		size_t minSize = instSpec.m_fixedFields;
		size_t i;
		if (instSpec.m_indexable)
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
		ObjectMemory::AddToZct((OTE*)oteObj);
		return sp;
	}
	else
	{
		return primitiveFailure(instSpec.m_nonInstantiable ? 1 : 0);
	}
}


Oop* __fastcall Interpreter::primitiveNewFromStack(Oop* sp)
{
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*(sp - 1));

	Oop oopArg = (*sp);
	SMALLINTEGER count;
	if (isIntegerObject(oopArg) && (count = ObjectMemoryIntegerValueOf(oopArg)) >= 0)
	{
		// Note that instantiateClassWithPointers counts up the class,
		PointersOTE* oteObj = ObjectMemory::newUninitializedPointerObject(oteClass, count);
		VariantObject* obj = oteObj->m_location;

		sp = sp - count - 1;
		while (--count >= 0)
		{
			Oop oopArg = *(sp + count);
			ObjectMemory::countUp(oopArg);
			obj->m_fields[count] = oopArg;
		}

		// Save down SP in case ZCT is reconciled on adding result
		m_registers.m_stackPointer = sp;
		*sp = reinterpret_cast<Oop>(oteObj);
		ObjectMemory::AddToZct((OTE*)oteObj);
		return sp;
	}
	else
	{
		return primitiveFailure(0);
	}
}

// Answer a new process with an initial stack size specified by the first argument, and a maximum
// stack size specified by the second argument.
Oop* __fastcall Interpreter::primitiveNewVirtual(Oop* const sp)
{
	Oop maxArg = *sp;
	SMALLINTEGER maxSize;
	if (ObjectMemoryIsIntegerObject(maxArg) && (maxSize = ObjectMemoryIntegerValueOf(maxArg)) >= 0)
	{
		Oop initArg = *(sp - 1);
		SMALLINTEGER initialSize;
		if (ObjectMemoryIsIntegerObject(initArg) && (initialSize = ObjectMemoryIntegerValueOf(initArg)) >= 0)
		{
			BehaviorOTE* receiverClass = reinterpret_cast<BehaviorOTE*>(*(sp - 2));
			InstanceSpecification instSpec = receiverClass->m_location->m_instanceSpec;
			if (instSpec.m_indexable && !instSpec.m_nonInstantiable)
			{
				unsigned fixedFields = instSpec.m_fixedFields;
				VirtualOTE* newObject = ObjectMemory::newVirtualObject(receiverClass, initialSize + fixedFields, maxSize + fixedFields);
				*(sp - 2) = reinterpret_cast<Oop>(newObject);
				// No point saving down SP before potential Zct reconcile as the init & max args must be SmallIntegers
				ObjectMemory::AddToZct((OTE*)newObject);
				return sp - 2;
			}
			else
			{
				return primitiveFailure(instSpec.m_nonInstantiable ? 3 : 2);	// Non-indexable or abstract class
			}
		}
		else
		{
			return primitiveFailure(1);	// initialSize arg not a SmallInteger
		}
	}
	else
	{
		return primitiveFailure(0);	// maxsize arg not a SmallInteger
	}
}

Oop* __fastcall Interpreter::primitiveAllReferences(Oop* const sp)
{
	// Make sure we don't include refs above TOS as these are invalid - also don't include the ref to the receiver on the stack
	bool includeWeakRefs = *sp == reinterpret_cast<Oop>(Pointers.True);

	// Resize the active process to exclude the receiver and arg (if any) to the primitive
	ST::Process* pActiveProcess = m_registers.m_pActiveProcess;
	MWORD words = sp - 1 - reinterpret_cast<const Oop*>(pActiveProcess);
	m_registers.m_oteActiveProcess->setSize(words * sizeof(MWORD));

	Oop receiver = *(sp - 1);
	ArrayOTE* refs = ObjectMemory::referencesTo(receiver, includeWeakRefs);

	*(sp - 1) = reinterpret_cast<Oop>(refs);
	ObjectMemory::AddToZct((OTE*)refs);
	return sp - 1;
}
