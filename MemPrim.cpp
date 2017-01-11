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

Oop* __fastcall Interpreter::primitiveAllReferences(CompiledMethod&, unsigned argumentCount)
{
	// Make sure we don't include refs above TOS as these are invalid - also don't include the ref to the receiver on the stack
	Oop* sp = m_registers.m_stackPointer;
	bool includeWeakRefs;
	switch (argumentCount)
	{
	case 0:
		includeWeakRefs = true;
		break;
	case 1:
		includeWeakRefs = *sp-- == reinterpret_cast<Oop>(Pointers.True);
		break;
	default:
		// 0 or 1 args expected
		return primitiveFailure(0);
	}

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
