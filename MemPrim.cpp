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
BOOL __fastcall Interpreter::primitiveNewVirtual()
{
	Oop argPointer = stackTop();
	if (!ObjectMemoryIsIntegerObject(argPointer))
		return primitiveFailure(0);	// Arg not a SmallInteger
	MWORD maxSize = ObjectMemoryIntegerValueOf(argPointer);
	argPointer = stackValue(1);
	if (!ObjectMemoryIsIntegerObject(argPointer))
		return primitiveFailure(1);	// Arg not a SmallInteger
	MWORD initialSize = ObjectMemoryIntegerValueOf(argPointer);

	BehaviorOTE* receiverClass = reinterpret_cast<BehaviorOTE*>(stackValue(2));
	Behavior* behavior = receiverClass->m_location;
	if (!behavior->isIndexable())
		return primitiveFailure(2);
	
	// We'll not fail now, args are correct types
	pop(2);

	unsigned fixedFields = behavior->fixedFields();
	VirtualOTE* newObject = ObjectMemory::newVirtualObject(receiverClass, initialSize+fixedFields, maxSize+fixedFields);
	return replaceStackTopWithNew(newObject);
}

