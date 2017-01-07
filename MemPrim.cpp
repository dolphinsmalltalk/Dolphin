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

// Answer a new process with an initial stack size specified by the first argument, and a maximum
// stack size specified by the second argument.
Oop* __fastcall Interpreter::primitiveNewVirtual()
{
	Oop* const sp = m_registers.m_stackPointer;
	Oop argPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(argPointer))
		return primitiveFailure(0);	// Arg not a SmallInteger
	MWORD maxSize = ObjectMemoryIntegerValueOf(argPointer);
	argPointer = *(sp-1);
	if (!ObjectMemoryIsIntegerObject(argPointer))
		return primitiveFailure(1);	// Arg not a SmallInteger
	MWORD initialSize = ObjectMemoryIntegerValueOf(argPointer);

	BehaviorOTE* receiverClass = reinterpret_cast<BehaviorOTE*>(*(sp-2));
	Behavior* behavior = receiverClass->m_location;
	if (!behavior->isIndexable())
		return primitiveFailure(2);
	
	unsigned fixedFields = behavior->fixedFields();
	VirtualOTE* newObject = ObjectMemory::newVirtualObject(receiverClass, initialSize+fixedFields, maxSize+fixedFields);
	*(sp - 2) = reinterpret_cast<Oop>(newObject);
	ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObject));
	return sp-2;
}

Oop* __fastcall Interpreter::primitiveAllReferences(CompiledMethod&, unsigned argumentCount)
{
	// Make sure we don't include refs above TOS as these are invalid - also don't include the ref to the receiver on the stack
	Oop* sp;
	bool includeWeakRefs;
	Oop receiver;
	switch (argumentCount)
	{
	case 0:
		includeWeakRefs = true;
		receiver = stackTop();
		sp = m_registers.m_stackPointer - 1;
		break;
	case 1:
		includeWeakRefs = stackTop() == reinterpret_cast<Oop>(Pointers.True);
		receiver = stackValue(1);
		sp = m_registers.m_stackPointer - 2;
		break;
	default:
		// 0 or 1 args expected
		return primitiveFailure(0);
	}

	// Resize the active process to exclude the receiver and arg (if any) to the primitive
	ST::Process* pActiveProcess = m_registers.m_pActiveProcess;
	MWORD words = sp - reinterpret_cast<const Oop*>(pActiveProcess) + 1;
	m_registers.m_oteActiveProcess->setSize(words * sizeof(MWORD));

	ArrayOTE* refs = ObjectMemory::referencesTo(receiver, includeWeakRefs);

	*(sp+1) = reinterpret_cast<Oop>(refs);
	ObjectMemory::AddToZct(reinterpret_cast<OTE*>(refs));
	return sp+1;
}
