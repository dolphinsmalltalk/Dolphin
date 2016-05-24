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

	if (oteReceiver->isPointers())
	{
		Behavior* behavior = oteReceiver->m_oteClass->m_location;
		if (!behavior->isIndexable())
			return primitiveFailure(1);

		MWORD newPointerSize = newSize + behavior->fixedFields();

		int currentPointerSize = oteReceiver->pointersSizeForUpdate();
		if (currentPointerSize == (int)newPointerSize)
		{
			// No change, succeed
			pop(1);
			return primitiveSuccess();
		}

		if (currentPointerSize < 0)
		{
			// Immutable
			return primitiveFailure(2);
		}
			
		// Changing size of mutable pointer object
		pop(1);
		bool bCountDownRemoved = reinterpret_cast<OTE*>(Interpreter::actualActiveProcessPointer()) != oteReceiver;
		VariantObject* pNew = ObjectMemory::resize(reinterpret_cast<PointersOTE*>(oteReceiver),
			newPointerSize,
			bCountDownRemoved);
		ASSERT(pNew != NULL);
	}
	else
	{
		int currentByteSize = oteReceiver->bytesSizeForUpdate();
		if (currentByteSize == (int)newSize)
		{
			// No change, succeed
			pop(1);
			return primitiveSuccess();
		}
		
		if (currentByteSize < 0)
		{
			// Immutable
			return primitiveFailure(2);
		}

		// Changing size of mutable byte object
		pop(1);
		VariantByteObject* pNew = ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteReceiver), newSize);
		ASSERT(pNew != NULL || newSize == 0);
	}

	// Object size has changed, invalidating any AtCache entry
	purgeObjectFromCaches(oteReceiver);

	return primitiveSuccess();
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

BOOL __fastcall Interpreter::primitiveReplacePointers()
{
	Oop integerPointer = stackTop();
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(0);	// startAt is not an integer
	SMALLINTEGER startAt = ObjectMemoryIntegerValueOf(integerPointer);

	integerPointer = stackValue(1);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(1);	// stop is not an integer
	SMALLINTEGER stop = ObjectMemoryIntegerValueOf(integerPointer);

	integerPointer = stackValue(2);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(2);	// start is not an integer
	SMALLINTEGER start = ObjectMemoryIntegerValueOf(integerPointer);

	PointersOTE* argPointer = reinterpret_cast<PointersOTE*>(stackValue(3));
	if (ObjectMemoryIsIntegerObject(argPointer) || !argPointer->isPointers())
		return primitiveFailure(3);	// Argument MUST be pointer object

	if (stop >= start)
	{
		if (startAt < 1 || start < 1)
			return primitiveFailure(4);		// Out-of-bounds

		// Empty move if stop before start, is considered valid regardless (strange but true)
		// this is the convention adopted by most implementations.

		// We can test that we're not going to write off the end of the argument
		int length = argPointer->pointersSizeForUpdate();

		unsigned toOffset = argPointer->m_oteClass->m_location->fixedFields();
		
		// Adjust to zero-based indices into variable fields of target
		stop = stop - 1 + toOffset;
		start = start - 1 + toOffset;

		if (stop >= length)
			return primitiveFailure(4);		// Bounds error (or object is immutable so size < 0)

		VariantObject* arg = reinterpret_cast<PointersOTE*>(argPointer)->m_location;
		Oop* pTo = arg->m_fields;

		PointersOTE* receiverPointer = reinterpret_cast<PointersOTE*>(stackValue(4));

		int fromSize = receiverPointer->pointersSize();
		unsigned fromOffset = receiverPointer->m_oteClass->m_location->fixedFields();
		// Adjust to zero based index into variable fields of source
		startAt = startAt - 1 + fromOffset;

		int stopAt = startAt + stop - start;
		if (stopAt >= fromSize)
			return primitiveFailure(4);

		// Only works for pointer objects
		ASSERT(receiverPointer->isPointers());
		VariantObject* receiverObject = receiverPointer->m_location;

		Oop* pFrom = receiverObject->m_fields;

		// Overlapping upwards move? 
		if (argPointer == receiverPointer && startAt < start)
		{
			// Need to do backwards
			for (int i = stop - start; i >= 0; i--)
			{
				ObjectMemory::storePointerWithValue(pTo[start + i], pFrom[startAt + i]);
			}
		}
		else
		{
			// Do forwards
			for (int i = 0; i <= stop - start; i++)
			{
				ObjectMemory::storePointerWithValue(pTo[start + i], pFrom[startAt + i]);
			}
		}
	}

	// Answers the argument by moving it down over the receiver
	stackValue(4) = reinterpret_cast<Oop>(argPointer);
	pop(4);
	return TRUE;
}

