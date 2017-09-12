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

Oop* __fastcall Interpreter::primitiveNewInitializedObject(void*, unsigned argCount)
{
	Oop* sp = m_registers.m_stackPointer;
	Oop oopReceiver = *(sp - argCount);
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
	ObjectMemory::AddToZct((OTE*)oteObj);
	return sp;
}


Oop* __fastcall Interpreter::primitiveNewFromStack()
{
	Oop* sp = m_registers.m_stackPointer;

	Oop oopReceiver = *(sp - 1);
	if (!ObjectMemory::isBehavior(oopReceiver))
		return primitiveFailure(0);
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(oopReceiver);
	Behavior* behavior = oteClass->m_location;

	if (behavior->isBytes())
		return primitiveFailure(1);

	Oop oopCount = *sp;
	if (!ObjectMemoryIsIntegerObject(oopCount))
		return primitiveFailure(3);
	int count = ObjectMemoryIntegerValueOf(oopCount);
	if (count < 0)
		return primitiveFailure(4);

	int minSize = behavior->fixedFields();
	int i;
	if (behavior->isIndexable())
	{
		i = max(minSize, count);
	}
	else
	{
		if (count > minSize)
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
	while (i > count)
	{
		obj->m_fields[--i] = nil;
	}

	sp = sp - count - 1;

	while (--i >= 0)
	{
		Oop oopArg = *(sp+i);
		ObjectMemory::countUp(oopArg);
		obj->m_fields[i] = oopArg;
	}

	// Save down SP in case ZCT is reconciled on adding result, allowing unref'd args to be reclaimed
	m_registers.m_stackPointer = sp;
	*sp = reinterpret_cast<Oop>(oteObj);
	ObjectMemory::AddToZct((OTE*)oteObj);
	return sp;
}

// Answer a new process with an initial stack size specified by the first argument, and a maximum
// stack size specified by the second argument.
Oop* __fastcall Interpreter::primitiveNewVirtual()
{
	Oop* sp = m_registers.m_stackPointer;
	Oop maxArg = *sp--;
	if (!ObjectMemoryIsIntegerObject(maxArg))
		return primitiveFailure(0);	// Arg not a SmallInteger
	MWORD maxSize = ObjectMemoryIntegerValueOf(maxArg);
	Oop initArg = *sp--;
	if (!ObjectMemoryIsIntegerObject(initArg))
		return primitiveFailure(1);	// Arg not a SmallInteger
	MWORD initialSize = ObjectMemoryIntegerValueOf(initArg);

	BehaviorOTE* receiverClass = reinterpret_cast<BehaviorOTE*>(*sp);
	Behavior* behavior = receiverClass->m_location;
	if (!behavior->isIndexable())
		return primitiveFailure(2);
	
	unsigned fixedFields = behavior->fixedFields();
	VirtualOTE* newObject = ObjectMemory::newVirtualObject(receiverClass, initialSize+fixedFields, maxSize+fixedFields);
	*sp = reinterpret_cast<Oop>(newObject);
	// No point saving down SP before potential Zct reconcile as the init & max args must be SmallIntegers
	ObjectMemory::AddToZct((OTE*)newObject);
	return sp;
}

Oop* __fastcall Interpreter::primitiveAllReferences()
{
	// Make sure we don't include refs above TOS as these are invalid - also don't include the ref to the receiver on the stack
	Oop* sp = m_registers.m_stackPointer;
	bool includeWeakRefs = *sp-- == reinterpret_cast<Oop>(Pointers.True);

	// Resize the active process to exclude the receiver and arg (if any) to the primitive
	ST::Process* pActiveProcess = m_registers.m_pActiveProcess;
	MWORD words = sp - reinterpret_cast<const Oop*>(pActiveProcess);
	m_registers.m_oteActiveProcess->setSize(words * sizeof(MWORD));

	Oop receiver = *sp;
	ArrayOTE* refs = ObjectMemory::referencesTo(receiver, includeWeakRefs);

	*sp = reinterpret_cast<Oop>(refs);
	ObjectMemory::AddToZct((OTE*)refs);
	return sp;
}
