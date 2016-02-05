/******************************************************************************

	File: Primitiv.cpp

	Description:

	Implementation of the Interpreter class' primitive methods

******************************************************************************/
#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include <process.h>		// for exit() prototype
#include <string.h>
#include <sys/timeb.h>
#include "ObjMem.h"
#include "Interprt.h"
#include "rc_vm.h"
#include "InterprtPrim.inl"

// Smalltalk classes
#include "STBehavior.h"
#include "STArray.h"
#include "STByteArray.h"
#include "STAssoc.h"

#ifdef PROFILING
	extern unsigned blocksInstantiated;
	extern unsigned	freeBlocks = 0;
	extern unsigned contextsSuspended;
#endif

///////////////////////////////////////////////////////////////////////////////
// Primitive Helper routines

///////////////////////////////////////////////////////////////////////////////
//	SmallInteger Primitives - See IntPrim.cpp (OR primasm.asm for IX86)
///////////////////////////////////////////////////////////////////////////////

BOOL __fastcall Interpreter::primitiveSmallIntegerPrintString()
{
	Oop integerPointer = stackTop();

#ifdef _WIN64
	char buffer[32];
	errno_t err = _i64toa_s(ObjectMemoryIntegerValueOf(integerPointer), buffer, sizeof(buffer), 10);
#else
	char buffer[16];
	errno_t err = _itoa_s(ObjectMemoryIntegerValueOf(integerPointer), buffer, sizeof(buffer), 10);
#endif
	if (err == 0)
	{
		replaceStackTopWithNew(String::New(buffer));
		return TRUE;
	}
	else
		return FALSE;
}

///////////////////////////////////////////////////////////////////////////////
//	Float Primitives - See FlotPrim.cpp
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//	String Primitives - See StrgPrim.cpp
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
//	External Call Primitives - See ExtCall.cpp
///////////////////////////////////////////////////////////////////////////////

#pragma code_seg(MEM_SEG)

// Does not use successFlag, and returns a clean stack because can only succeed if
// argument is a positive SmallInteger
BOOL __fastcall Interpreter::primitiveResize()
{
	Oop integerPointer = stackTop();
	SMALLINTEGER newSize;
	
	if (!ObjectMemoryIsIntegerObject(integerPointer) || 
		(newSize = ObjectMemoryIntegerValueOf(integerPointer)) < 0)
		return primitiveFailure(0);	// Size not a positive SmallInteger

	Oop oopReceiver = stackValue(1);
	if (ObjectMemoryIsIntegerObject(oopReceiver))
		return primitiveFailure(1);
	OTE* oteReceiver = reinterpret_cast<OTE*>(oopReceiver);
	if (oteReceiver->isImmutable())
		return primitiveFailure(1);

	BehaviorOTE* receiversClass = oteReceiver->m_oteClass;
	Behavior* behavior = receiversClass->m_location;
	if (behavior->isIndexable())
	{
		pop(1);		// Arg must be a SmallInteger to get here, so just adjust SP
		ObjectMemory::resize(oteReceiver, newSize);
		return primitiveSuccess();
	}
	else
		return primitiveFailure(1);
}

#pragma code_seg(PRIM_SEG)


#ifdef _DEBUG
	// Argument should be true/false value, but speed not critical, so use popAndNil
	BOOL __fastcall Interpreter::primitiveExecutionTrace()
	{
		Oop arg = popStack();
		#ifdef _DEBUG
			executionTrace = ObjectMemoryIntegerValueOf(arg);
		#endif
		return primitiveSuccess();
	}
#endif


#pragma code_seg(PROCESS_SEG)

// Remove a request from the last request queue, nil if none pending. Fails if argument is not an
// array of the correct length to receiver the popped Queue entry (currently 2 objects)
// Answers nil if the queue is empty, or the argument if an entry was successfully popped into it
BOOL __fastcall Interpreter::primitiveDeQBereavement()
{
	Oop argPointer = stackTop();
	if (ObjectMemoryIsIntegerObject(argPointer))
		return primitiveFailure(PrimitiveFailureBadValue);

	PointersOTE* oteArray = reinterpret_cast<PointersOTE*>(argPointer);
	VariantObject* array = oteArray->m_location;
	if (oteArray->m_oteClass != Pointers.ClassArray || 
		oteArray->pointersSize() != OopsPerBereavementQEntry)
		return primitiveFailure(PrimitiveFailureBadValue);

	// dequeueBereaved returns Pointers.True or Pointers.False
	OTE* answer = dequeueBereaved(array);
	stackValue(1) = reinterpret_cast<Oop>(answer);
	popStack();
	return primitiveSuccess();
}

///////////////////////////////////
// Clearing down the method cache is a very fast operation, so there is nothing
// to be gained at the moment from doing it more selectively (except that 
// method lookups must be recached, so every time a method is installed, the
// system starts from scratch again).
// A more selective approach would require clearing down all entries that match
// a certain selector for a specified class and all its subclasses, because of the 
// caching of inherited methods. Removing all entries for a specific method is
// not sufficient since this would not cater for the addition of methods when
// these override 
#pragma code_seg(PRIM_SEG)

void Interpreter::flushCaches()
{
#ifdef _DEBUG
	DumpMethodCacheStats();
#endif

	ZeroMemory(methodCache, sizeof(methodCache));

	flushAtCaches();
}

void Interpreter::flushAtCaches()
{
#ifdef _DEBUG
	//DumpAtCacheStats();
#endif
	ZeroMemory(AtCache, sizeof(AtCache));
	ZeroMemory(AtPutCache, sizeof(AtPutCache));
}

BOOL __fastcall Interpreter::primitiveFlushCache()
{
#ifdef _DEBUG
	DumpCacheStats();
#endif
	flushCaches();
	return TRUE;	// return success value so can be used directly as primitive
}

// Separate atPut primitive is needed to write to the stack because the active process
// stack is not reference counted.
BOOL __fastcall Interpreter::primitiveStackAtPut(CompiledMethod& , unsigned argCount)
{
	ASSERT(argCount == 2); argCount;
	
	Oop indexPointer = stackValue(1);
	if (!ObjectMemoryIsIntegerObject(indexPointer))
		return primitiveFailure(PrimitiveFailureNonInteger);

	SMALLINTEGER index = ObjectMemoryIntegerValueOf(indexPointer);
	if (index < 1)
		return primitiveFailure(PrimitiveFailureBoundsError);

	resizeActiveProcess();

	ProcessOTE* oteReceiver = reinterpret_cast<ProcessOTE*>(stackValue(2));
	Process* receiverProcess = static_cast<Process*>(oteReceiver->m_location);
	if (static_cast<MWORD>(index) > receiverProcess->stackSize(oteReceiver))
			return primitiveFailure(PrimitiveFailureBoundsError);

	Oop argPointer = stackTop();
	Oop oopExisting = receiverProcess->m_stack[index-1];

	// No ref. counting required writing to active process stack
	if (oteReceiver != m_registers.m_oteActiveProcess)
	{
		ObjectMemory::countUp(argPointer);
		ObjectMemory::countDown(oopExisting);
	}

	receiverProcess->m_stack[index-1] = argPointer;
	pop(2);
	stackTop() = argPointer;
	return TRUE;
}


// Don't care what effect on stack is!!
void __fastcall Interpreter::primitiveQuit(CompiledMethod&,unsigned)
{
	Oop argPointer = stackTop();
	exitSmalltalk(ObjectMemoryIntegerValueOf(argPointer));
}