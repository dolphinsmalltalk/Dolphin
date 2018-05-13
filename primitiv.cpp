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

Oop* __fastcall Interpreter::primitiveSmallIntegerPrintString(Oop* const sp, unsigned)
{
	Oop integerPointer = *sp;

#ifdef _WIN64
	char buffer[32];
	errno_t err = _i64toa_s(ObjectMemoryIntegerValueOf(integerPointer), buffer, sizeof(buffer), 10);
#else
	char buffer[16];
	errno_t err = _itoa_s(ObjectMemoryIntegerValueOf(integerPointer), buffer, sizeof(buffer), 10);
#endif
	if (err == 0)
	{
		auto oteResult = AnsiString::New(buffer);
		*sp = reinterpret_cast<Oop>(oteResult);
		ObjectMemory::AddToZct((OTE*)oteResult);
		return sp;
	}
	else
		return primitiveFailure(0);
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

Oop* __fastcall Interpreter::primitiveBasicIdentityHash(Oop* const sp, unsigned)
{
	OTE* ote = (OTE*)*sp;
	*sp = ObjectMemoryIntegerObjectOf(ote->identityHash());
	return sp;
}

Oop* __fastcall Interpreter::primitiveIdentityHash(Oop* const sp, unsigned)
{
	OTE* ote = (OTE*)*sp;
	*sp = ObjectMemoryIntegerObjectOf(ote->identityHash() << 14);
	return sp;
}

Oop* __fastcall Interpreter::primitiveClass(Oop* const sp, unsigned)
{
	Oop receiver = *sp;
	*sp = reinterpret_cast<Oop>(!ObjectMemoryIsIntegerObject(receiver) 
			? reinterpret_cast<OTE*>(receiver)->m_oteClass : Pointers.ClassSmallInteger);
	return sp;
}

Oop* __fastcall Interpreter::primitiveIdentical(Oop* const sp, unsigned)
{
	Oop receiver = *(sp-1);
	Oop arg = *sp;
	*(sp - 1) = reinterpret_cast<Oop>(arg == receiver ? Pointers.True : Pointers.False);
	return sp - 1;
}


size_t ObjectMemory::GetBytesElementSize(BytesOTE* ote)
{
	ASSERT(ote->isBytes());

	// TODO: Should be using revised InstanceSpec here, not string encoding
	if (ote->m_flags.m_weakOrZ)
	{
		switch (reinterpret_cast<const StringClass*>(ote->m_oteClass->m_location)->Encoding)
		{
		case StringEncoding::Utf16:
			return sizeof(uint16_t);
		case StringEncoding::Utf32:
			return sizeof(uint32_t);
		}
	}
	return sizeof(uint8_t);
}

// This primitive is unusual(like primitiveClass) in that it cannot fail
// Essentially same code as shortSpecialSendBasicSize
Oop* __fastcall Interpreter::primitiveSize(Oop* const sp, unsigned)
{
	// The primitive assumes it is never called for SmallIntegers.
	OTE* oteReceiver = reinterpret_cast<OTE*>(*sp);
	MWORD bytesSize = oteReceiver->getSize();
	if (oteReceiver->m_flags.m_pointer)
	{
		InstanceSpecification instSpec = oteReceiver->m_oteClass->m_location->m_instanceSpec;
		// The compiler generates poor code here if we access the InstanceSpecification::m_fixedFields bit field directly
		// so we do the bit manipulations directly to guide the compiler into generating more efficient asm.
		// This does mean we are using internal knowledge here that the fixedFields bitfield is left-shifted 1, and that
		// SmallIntegers are also left-shifted 1 with the bottom bit set
		Oop value = ((bytesSize >> 1) - (instSpec.m_value & InstanceSpecification::FixedFieldsMask)) | 1;
		*sp = value;
		return sp;
	}
	else
	{
		switch(ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteReceiver)))
		{
		case 1:
			*sp = integerObjectOf(bytesSize);
			break;
		case 2:
			*sp = integerObjectOf(bytesSize >> 1);
			break;
		case 4:
			*sp = integerObjectOf(bytesSize >> 2);
			break;
		default:
			_assume(false);
		}

		return sp;
	}
}


// Primitive to speed up #isKindOf: (so we don't have to implement too many #isXXXXX methods, 
// which are nasty, requiring a change to Object for each).
Oop* __fastcall Interpreter::primitiveIsKindOf(Oop* const sp, unsigned)
{
	Oop arg = *sp;
	// Nothing can be a kind of SmallInteger instance
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		BehaviorOTE* oteArg = reinterpret_cast<BehaviorOTE*>(arg);
		Oop receiver = *(sp - 1);
		BehaviorOTE* oteClass = !ObjectMemoryIsIntegerObject(receiver)
			? reinterpret_cast<OTE*>(receiver)->m_oteClass
			: Pointers.ClassSmallInteger;
		while (oteClass != oteArg)
		{
			if (reinterpret_cast<OTE*>(oteClass) == Pointers.Nil)
			{
				*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
				return sp - 1;
			}
			oteClass = oteClass->m_location->m_superclass;
		};

		*(sp - 1) = reinterpret_cast<Oop>(Pointers.True);
		return sp - 1;
	}

	*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
	return sp - 1;
}

// Does not use successFlag, and returns a clean stack because can only succeed if
// argument is a positive SmallInteger
Oop* __fastcall Interpreter::primitiveResize(Oop* const sp, unsigned)
{
	Oop integerPointer = *sp;
	SMALLINTEGER newSize;
	
	if (!ObjectMemoryIsIntegerObject(integerPointer) || 
		(newSize = ObjectMemoryIntegerValueOf(integerPointer)) < 0)
		return primitiveFailure(0);	// Size not a positive SmallInteger

	Oop oopReceiver = *(sp - 1);
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
			return sp - 1;
		}

		if (currentPointerSize < 0)
		{
			// Immutable
			return primitiveFailure(2);
		}
			
		// Changing size of mutable pointer object
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
			return sp - 1;
		}
		
		if (currentByteSize < 0)
		{
			// Immutable
			return primitiveFailure(2);
		}

		// Changing size of mutable byte object
		VariantByteObject* pNew = ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteReceiver), newSize);
		ASSERT(pNew != NULL || newSize == 0);
	}

	return sp - 1;
}

Oop* __fastcall Interpreter::primitiveChangeBehavior(Oop* const sp, unsigned)
{
	// Receiver becomes an instance of the class specified as the argument - neither
	// receiver or arg may be SmallIntegers, and the shape of the receivers current class
	// must be identical to its new class.

	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		BehaviorOTE* oteClassArg = reinterpret_cast<BehaviorOTE*>(arg);

		// We must determine if the argument is a Class - get the head strap out and
		// then remember :
		//	A class' class is an instance of Metaclass (e.g. if we send #class to
		//	to Object, then we get the Metaclass instance 'Object class') THEREFORE
		// The class of the class of a Class is Metaclass!
		// Because of our use of an Object table, we've got 5 indirections here!

		BehaviorOTE* oteClassOfClassArg = oteClassArg->m_oteClass;
		Behavior* argClass = oteClassArg->m_location;

		BehaviorOTE* oteMeta = oteClassOfClassArg->m_oteClass;
		if (oteMeta == Pointers.ClassMetaclass)
		{
			// We have established that the argument is indeed a Class object, now lets examine the receiver

			Oop receiver = *(sp - 1);
			if (!ObjectMemoryIsIntegerObject(receiver))
			{
				// The receiver is a non - immediate object
				OTE* oteReceiver = reinterpret_cast<OTE*>(receiver);

				BehaviorOTE* oteReceiverClass = oteReceiver->m_oteClass;
				Behavior* receiverClass = oteReceiverClass->m_location;

				// We must check class shapes the same, so compare instance spec. of receivers class with that of new class by xor'ing together
				// and then checking if any of the important shape bits are different
				DWORD diff = receiverClass->m_instanceSpec.m_value ^ argClass->m_instanceSpec.m_value;
				if ((diff & ~InstanceSpecification::IndirectMask) == 0)
				{

					oteReceiver->m_oteClass = oteClassArg;
					// We must reduce the count on the class, since it has been overwritten in the object, and count up the new class
					oteClassArg->countUp();
					oteReceiverClass->countDown();

					return sp - 1;
				}
				// Shapes differ in significant ways
				return primitiveFailure(2);
			}
			else
			{
				// The receiver is a SmallInteger, and can be mutated to a variable byte object
				// which we have to allocate

				// Do instances of the new class contain pointers, if so fail
				if (!argClass->m_instanceSpec.m_pointers)
				{
					BytesOTE* oteBytes = ObjectMemory::newByteObject<false, false>(oteClassArg, sizeof(MWORD));
					oteClassArg->countUp();
					*reinterpret_cast<MWORD*>(oteBytes->m_location->m_fields) = ObjectMemoryIntegerValueOf(receiver);

					// We've created a new object, so must replace the receiver at stack top
					*(sp - 1) = reinterpret_cast<Oop>(oteBytes);
					ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteBytes));
					return sp - 1;
				}
				// Can't change class of SmallInteger to a pointer object class
				return primitiveFailure(2);
			}
		}
		// Arg is not a class
		return primitiveFailure(1);
	}
	// Arg is a SmallInteger (not a class)
	return primitiveFailure(0);
}

Oop* __fastcall Interpreter::primitiveExtraInstanceSpec(Oop* const sp, unsigned)
{
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*sp);
	*sp = (oteClass->m_location->m_instanceSpec.m_value >> 15) | 1;
	return sp;
}

// Set the special behavior bits of an object according to the mask
// Takes a SmallInteger argument, of which only the low order word is significant.
// The high order byte of the low order word specifies the AND mask, used to mask out bits,
// The low order byte of the low order word specifies the OR mask, used to mask in bits.
// The current value of the special behavior bits is then answered.
// The primitive ensures that the current values of bits which may affect the stability of the
// system cannot be modified.
// To query the current value of the special bits, pass in 16rFF00.
Oop* __fastcall Interpreter::primitiveSetSpecialBehavior(Oop* const sp, unsigned)
{
	Oop oopMask = *sp;
	if (ObjectMemoryIsIntegerObject(oopMask))
	{
		SMALLINTEGER mask = ObjectMemoryIntegerValueOf(oopMask);
		Oop oopReceiver = *(sp - 1);
		if (!ObjectMemoryIsIntegerObject(oopReceiver))
		{
			static const BYTE criticalPointerObjectFlags = static_cast<BYTE>(OTEFlags::PointerMask | OTEFlags::MarkMask | OTEFlags::FreeMask | OTEFlags::SpaceMask);
			static const BYTE criticalByteObjectFlags = static_cast<BYTE>(OTEFlags::PointerMask | OTEFlags::MarkMask | OTEFlags::FreeMask | OTEFlags::SpaceMask | OTEFlags::WeakOrZMask);

			OTE* oteReceiver = reinterpret_cast<OTE*>(oopReceiver);

			// Ensure the masks cannot affect the critical bits of the flags
			// the AND mask, must have the pointer, mark, and free bits set, to keep these bits
			// the OR mask, must have those bits reset so as not to add them
			BYTE criticalFlags = oteReceiver->m_flags.m_pointer ? criticalPointerObjectFlags : criticalByteObjectFlags;
			BYTE andMask = (mask >> 8) | criticalFlags;
			BYTE orMask = mask & static_cast<BYTE>(~criticalFlags);

			BYTE oldFlags = oteReceiver->m_ubFlags;
			oteReceiver->m_ubFlags = (oldFlags & andMask) | orMask;

			ASSERT(oteReceiver->isNullTerminated() == oteReceiver->m_oteClass->m_location->m_instanceSpec.m_nullTerminated);

			*(sp - 1) = ObjectMemoryIntegerObjectOf(oldFlags);
			return sp - 1;
		}
		else
		{
			// SmallIntegers can't have special behavior
			return primitiveFailure(1);
		}
	}
	else
	{
		// Mask is not a SmallInteger
		return primitiveFailure(0);
	}
}

#pragma code_seg(PROCESS_SEG)

// Remove a request from the last request queue, nil if none pending. Fails if argument is not an
// array of the correct length to receiver the popped Queue entry (currently 2 objects)
// Answers nil if the queue is empty, or the argument if an entry was successfully popped into it
Oop* __fastcall Interpreter::primitiveDeQBereavement(Oop* const sp, unsigned)
{
	Oop argPointer = *sp;
	if (ObjectMemoryIsIntegerObject(argPointer))
		return primitiveFailure(PrimitiveFailureBadValue);

	PointersOTE* oteArray = reinterpret_cast<PointersOTE*>(argPointer);
	VariantObject* array = oteArray->m_location;
	if (oteArray->m_oteClass != Pointers.ClassArray || 
		oteArray->pointersSize() != OopsPerBereavementQEntry)
		return primitiveFailure(PrimitiveFailureBadValue);

	// dequeueBereaved returns Pointers.True or Pointers.False
	OTE* answer = dequeueBereaved(array);
	*(sp-1) = reinterpret_cast<Oop>(answer);
	return sp-1;
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
}

Oop* __fastcall Interpreter::primitiveFlushCache(Oop* const sp, unsigned)
{
#ifdef _DEBUG
	DumpCacheStats();
#endif
	flushCaches();
	return sp;
}

// Separate atPut primitive is needed to write to the stack because the active process
// stack is not reference counted.
Oop* __fastcall Interpreter::primitiveStackAtPut(Oop* const sp, unsigned)
{
	Oop indexPointer = *(sp-1);
	if (!ObjectMemoryIsIntegerObject(indexPointer))
		return primitiveFailure(PrimitiveFailureNonInteger);

	SMALLINTEGER index = ObjectMemoryIntegerValueOf(indexPointer);
	if (index < 1)
		return primitiveFailure(PrimitiveFailureBoundsError);

	resizeActiveProcess();

	ProcessOTE* oteReceiver = reinterpret_cast<ProcessOTE*>(*(sp-2));
	Process* receiverProcess = static_cast<Process*>(oteReceiver->m_location);
	if (static_cast<MWORD>(index) > receiverProcess->stackSize(oteReceiver))
			return primitiveFailure(PrimitiveFailureBoundsError);

	Oop argPointer = *sp;
	Oop oopExisting = receiverProcess->m_stack[index-1];

	// No ref. counting required writing to active process stack
	if (oteReceiver != m_registers.m_oteActiveProcess)
	{
		ObjectMemory::countUp(argPointer);
		ObjectMemory::countDown(oopExisting);
	}

	receiverProcess->m_stack[index-1] = argPointer;
	*(sp-2) = argPointer;
	return sp-2;
}


// Don't care what effect on stack is!!
[[noreturn]] void __fastcall Interpreter::primitiveQuit(Oop* const sp, unsigned)
{
	Oop argPointer = *sp;
	exitSmalltalk(ObjectMemoryIntegerValueOf(argPointer));
}

Oop* __fastcall Interpreter::primitiveReplacePointers(Oop* const sp, unsigned)
{
	Oop integerPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(0);	// startAt is not an integer
	SMALLINTEGER startAt = ObjectMemoryIntegerValueOf(integerPointer);

	integerPointer = *(sp-1);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(1);	// stop is not an integer
	SMALLINTEGER stop = ObjectMemoryIntegerValueOf(integerPointer);

	integerPointer = *(sp-2);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(2);	// start is not an integer
	SMALLINTEGER start = ObjectMemoryIntegerValueOf(integerPointer);

	PointersOTE* argPointer = reinterpret_cast<PointersOTE*>(*(sp-3));
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

		PointersOTE* receiverPointer = reinterpret_cast<PointersOTE*>(*(sp-4));

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
	*(sp-4) = reinterpret_cast<Oop>(argPointer);
	return sp-4;
}

Oop* __fastcall Interpreter::primitiveBasicAt(Oop* const sp, const unsigned argCount)
{
	Oop* newSp = sp - argCount;
	OTE* oteReceiver = reinterpret_cast<OTE*>(*newSp);
	Oop oopIndex = *(newSp + 1);

	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		SMALLINTEGER index = ObjectMemoryIntegerValueOf(oopIndex) - 1;
		if (oteReceiver->m_flags.m_pointer)
		{
			MWORD size = oteReceiver->pointersSize();
			MWORD fixedFields = oteReceiver->m_oteClass->m_location->fixedFields();
			VariantObject* pointerObj = reinterpret_cast<PointersOTE*>(oteReceiver)->m_location;

			if (index >= 0 && (index + fixedFields) < size)
			{
				Oop field = pointerObj->m_fields[index + fixedFields];
				*newSp = field;
				return newSp;
			}
			else
			{
				// Out of bounds
				return primitiveFailure(1);
			}
		}
		else
		{
			switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteReceiver)))
			{
			case 1:
				if (static_cast<MWORD>(index) < oteReceiver->bytesSize())
				{
					BYTE value = reinterpret_cast<BytesOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;
				
			case 2:
				if (static_cast<MWORD>(index) < (oteReceiver->bytesSize() / 2))
				{
					uint16_t value = reinterpret_cast<WordsOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;

			case 4:
				if (static_cast<MWORD>(index) < (oteReceiver->bytesSize() / 4))
				{
					uint32_t value = reinterpret_cast<QuadsOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;

			default:
				__assume(false);
					break;
			}

			// Out of bounds
			return primitiveFailure(1);
		}
	}
	else
	{
		// Index not a smallinteger
		return primitiveFailure(0);
	}
}

Oop* __fastcall Interpreter::primitiveBasicAtPut(Oop* const sp, unsigned)
{
	Oop* const newSp = sp - 2;
	OTE* oteReceiver = reinterpret_cast<OTE*>(*newSp);
	Oop oopIndex = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		SMALLINTEGER index = ObjectMemoryIntegerValueOf(oopIndex) - 1;
		if (index >= 0)
		{
			if (oteReceiver->m_flags.m_pointer)
			{
				// Store into pointer object

				int size = oteReceiver->pointersSizeForUpdate();
				int fixedFields = static_cast<int>(oteReceiver->m_oteClass->m_location->fixedFields());
				VariantObject* pointerObj = reinterpret_cast<PointersOTE*>(oteReceiver)->m_location;

				if (index >= 0 && (index + fixedFields) < size)
				{
					Oop newValue = *sp;
					ObjectMemory::countUp(newValue);
					Oop oldValue = pointerObj->m_fields[index + fixedFields];
					pointerObj->m_fields[index + fixedFields] = newValue;
					ObjectMemory::countDown(oldValue);
					*newSp = newValue;
					return newSp;
				}
				// Out of bounds
				return primitiveFailure(1);
			}
			else
			{
				// Store into byte object

				Oop oopValue = *sp;
				if (ObjectMemoryIsIntegerObject(oopValue))
				{
					const MWORD newValue = ObjectMemoryIntegerValueOf(oopValue);
					const int size = oteReceiver->bytesSizeForUpdate();

					switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteReceiver)))
					{
					case 1:
						if (newValue <= 0xFF)
						{
							if (index < size)
							{
								reinterpret_cast<BytesOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<BYTE>(newValue);
								*newSp = oopValue;
								return newSp;
							}
							return primitiveFailure(1);
						}
						return primitiveFailure(2);

					case 2:
						if (newValue <= 0xFFFF)
						{
							if (index < (size / 2))
							{
								reinterpret_cast<WordsOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<uint16_t>(newValue);
								*newSp = oopValue;
								return newSp;
							}
							return primitiveFailure(1);
						}
						return primitiveFailure(2);

					case 4:
						if (index < (size / 4))
						{
							reinterpret_cast<QuadsOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<uint32_t>(newValue);
							*newSp = oopValue;
							return newSp;
						}
						return primitiveFailure(1);

					default:
						__assume(false);
					}
				}
				// Not a SmallInteger
				return primitiveFailure(2);
			}
		}
		// Index is not a positive SmallInteger
		return primitiveFailure(1);
	}
	// Index not a smallinteger
	return primitiveFailure(0);
}


Oop* __fastcall Interpreter::primitiveInstVarAt(Oop* const sp, unsigned)
{
	Oop* const newSp = sp - 1;
	Oop oopIndex = *sp;
	OTE* oteReceiver = reinterpret_cast<OTE*>(*newSp);
	
	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		SMALLINTEGER index = ObjectMemoryIntegerValueOf(oopIndex) - 1;
		if (oteReceiver->m_flags.m_pointer)
		{
			MWORD size = oteReceiver->pointersSize();
			VariantObject* pointerObj = reinterpret_cast<PointersOTE*>(oteReceiver)->m_location;

			if (static_cast<MWORD>(index) < size)
			{
				Oop field = pointerObj->m_fields[index];
				*newSp = field;
				return newSp;
			}
			// Out of bounds
			return primitiveFailure(1);
		}
		else
		{
			switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteReceiver)))
			{
			case 1:
				if (static_cast<MWORD>(index) < oteReceiver->bytesSize())
				{
					BYTE value = reinterpret_cast<BytesOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;

			case 2:
				if (static_cast<MWORD>(index) < (oteReceiver->bytesSize() / 2))
				{
					uint16_t value = reinterpret_cast<WordsOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;

			case 4:
				if (static_cast<MWORD>(index) < (oteReceiver->bytesSize() / 4))
				{
					uint32_t value = reinterpret_cast<QuadsOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;

			default:
				__assume(false);
				break;
			}

			// Out of bounds
			return primitiveFailure(1);
		}
	}
	// Index not a smallinteger
	return primitiveFailure(0);
}

Oop* __fastcall Interpreter::primitiveInstVarAtPut(Oop* const sp, unsigned)
{
	Oop* const newSp = sp - 2;
	OTE* oteReceiver = reinterpret_cast<OTE*>(*newSp);
	Oop oopIndex = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		SMALLINTEGER index = ObjectMemoryIntegerValueOf(oopIndex) - 1;
		if (index >= 0)
		{
			if (oteReceiver->m_flags.m_pointer)
			{
				// Store into pointer object

				int size = oteReceiver->pointersSizeForUpdate();
				VariantObject* pointerObj = reinterpret_cast<PointersOTE*>(oteReceiver)->m_location;

				if (index < size)
				{
					Oop newValue = *sp;
					ObjectMemory::countUp(newValue);
					Oop oldValue = pointerObj->m_fields[index];
					pointerObj->m_fields[index] = newValue;
					ObjectMemory::countDown(oldValue);
					*newSp = newValue;
					return newSp;
				}

				// Out of bounds
				return primitiveFailure(1);
			}
			else
			{
				// Store into byte object

				Oop oopValue = *sp;
				if (ObjectMemoryIsIntegerObject(oopValue))
				{
					const MWORD newValue = ObjectMemoryIntegerValueOf(oopValue);
					const int size = oteReceiver->bytesSizeForUpdate();

					switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteReceiver)))
					{
					case 1:
						if (newValue <= 0xFF)
						{
							if (index < size)
							{
								reinterpret_cast<BytesOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<BYTE>(newValue);
								*newSp = oopValue;
								return newSp;
							}
							return primitiveFailure(1);
						}
						return primitiveFailure(2);

					case 2:
						if (newValue <= 0xFFFF)
						{
							if (index < (size / 2))
							{
								reinterpret_cast<WordsOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<uint16_t>(newValue);
								*newSp = oopValue;
								return newSp;
							}
							return primitiveFailure(1);
						}
						return primitiveFailure(2);

					case 4:
						if (index < (size / 4))
						{
							reinterpret_cast<QuadsOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<uint32_t>(newValue);
							*newSp = oopValue;
							return newSp;
						}
						return primitiveFailure(1);

					default:
						__assume(false);
					}
				}
				// Not a SmallInteger
				return primitiveFailure(2);
			}
		}
		// Negative index
		return primitiveFailure(1);
	}

	// Index not a smallinteger
	return primitiveFailure(0);
}

Oop* __fastcall Interpreter::primitiveGetImmutable(Oop* const sp, unsigned)
{
	Oop receiver = *sp;
	*sp = reinterpret_cast<Oop>(ObjectMemoryIsIntegerObject(receiver) || reinterpret_cast<OTE*>(receiver)->isImmutable() ? Pointers.True : Pointers.False);
	return sp;
}

Oop* __fastcall Interpreter::primitiveSetImmutable(Oop* const sp, unsigned)
{
	if (*sp == reinterpret_cast<Oop>(Pointers.True))
	{
		Oop receiver = *(sp - 1);

		if (!ObjectMemoryIsIntegerObject(receiver))
		{
			reinterpret_cast<OTE*>(receiver)->beImmutable();
		}
		return sp - 1;
	}
	else
	{
		Oop receiver = *(sp - 1);

		// Marking object as mutable - cannot do this for SmallIntegers as these are always immutable
		if (!ObjectMemoryIsIntegerObject(receiver))
		{
			reinterpret_cast<OTE*>(receiver)->beMutable();
			return sp - 1;
		}
		else
			return primitiveFailure(0);
	}
}
