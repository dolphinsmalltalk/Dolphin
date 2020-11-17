/******************************************************************************

	File: Primitiv.cpp

	Description:

	Implementation of the Interpreter class' primitive methods

******************************************************************************/
#include "Ist.h"
#pragma code_seg(PRIM_SEG)

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
	extern size_t blocksInstantiated;
	extern size_t	freeBlocks = 0;
	extern size_t contextsSuspended;
#endif

///////////////////////////////////////////////////////////////////////////////
// Primitive Helper routines

Oop* __fastcall Interpreter::unusedPrimitive(Oop* const, primargcount_t)
{
	// Note that the failure code is not set.
#ifdef _DEBUG
	auto primitiveIndex = m_registers.m_oopNewMethod->m_location->m_header.primitiveIndex;
	TRACESTREAM << L"Unused primitive " << primitiveIndex << " in " << m_registers.m_oopNewMethod << std::endl;
#endif

	return primitiveFailure(_PrimitiveFailureCode::NotImplemented);
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

Oop* __fastcall Interpreter::primitiveBasicIdentityHash(Oop* const sp, primargcount_t)
{
	OTE* ote = (OTE*)*sp;
	*sp = ObjectMemoryIntegerObjectOf(ote->identityHash());
	return sp;
}

Oop* __fastcall Interpreter::primitiveIdentityHash(Oop* const sp, primargcount_t)
{
	OTE* ote = (OTE*)*sp;
	*sp = ObjectMemoryIntegerObjectOf(ote->identityHash() << 14);
	return sp;
}

Oop* __fastcall Interpreter::primitiveClass(Oop* const sp, primargcount_t)
{
	Oop receiver = *sp;
	*sp = reinterpret_cast<Oop>(!ObjectMemoryIsIntegerObject(receiver) 
			? reinterpret_cast<OTE*>(receiver)->m_oteClass : Pointers.ClassSmallInteger);
	return sp;
}

Oop* __fastcall Interpreter::primitiveIdentical(Oop* const sp, primargcount_t)
{
	Oop receiver = *(sp-1);
	Oop arg = *sp;
	*(sp - 1) = reinterpret_cast<Oop>(arg == receiver ? Pointers.True : Pointers.False);
	return sp - 1;
}

// This primitive is unusual(like primitiveClass) in that it cannot fail
// Essentially same code as shortSpecialSendBasicSize
Oop* __fastcall Interpreter::primitiveSize(Oop* const sp, primargcount_t)
{
	// The primitive assumes it is never called for SmallIntegers.
	OTE* oteReceiver = reinterpret_cast<OTE*>(*sp);
	size_t bytesSize = oteReceiver->getSize();
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
		size_t shift = static_cast<size_t>(ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteReceiver)));
		*sp = integerObjectOf(bytesSize >> shift);

		return sp;
	}
}


// Primitive to speed up #isKindOf: (so we don't have to implement too many #isXXXXX methods, 
// which are nasty, requiring a change to Object for each).
Oop* __fastcall Interpreter::primitiveIsKindOf(Oop* const sp, primargcount_t)
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
Oop* __fastcall Interpreter::primitiveResize(Oop* const sp, primargcount_t)
{
	Oop integerPointer = *sp;
	
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Size not a positive SmallInteger

	SmallInteger newSize = ObjectMemoryIntegerValueOf(integerPointer);
	if (newSize < 0)
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);

	Oop oopReceiver = *(sp - 1);
	if (ObjectMemoryIsIntegerObject(oopReceiver))
		return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);
	OTE* oteReceiver = reinterpret_cast<OTE*>(oopReceiver);

	if (oteReceiver->isPointers())
	{
		Behavior* behavior = oteReceiver->m_oteClass->m_location;
		if (!behavior->isIndexable())
			return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);

		size_t newPointerSize = static_cast<size_t>(newSize) + behavior->fixedFields();

		ptrdiff_t currentPointerSize = oteReceiver->pointersSizeForUpdate();
		if (currentPointerSize == (ptrdiff_t)newPointerSize)
		{
			// No change, succeed
			return sp - 1;
		}

		if (currentPointerSize < 0)
		{
			// Immutable
			return primitiveFailure(_PrimitiveFailureCode::AccessViolation);
		}
			
		// Changing size of mutable pointer object
		bool bCountDownRemoved = reinterpret_cast<OTE*>(Interpreter::actualActiveProcessPointer()) != oteReceiver;
		VariantObject* pNew = ObjectMemory::resize(reinterpret_cast<PointersOTE*>(oteReceiver),
			newPointerSize,
			bCountDownRemoved);
		if (pNew == nullptr)
		{
			return primitiveFailure(_PrimitiveFailureCode::NoMemory);
		}
	}
	else
	{
		ptrdiff_t currentByteSize = oteReceiver->bytesSizeForUpdate();
		if (currentByteSize == static_cast<ptrdiff_t>(newSize))
		{
			// No change, succeed
			return sp - 1;
		}
		
		if (currentByteSize < 0)
		{
			// Immutable
			return primitiveFailure(_PrimitiveFailureCode::AccessViolation);
		}

		// Changing size of mutable byte object
		VariantByteObject* pNew = ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteReceiver), newSize);
		if (pNew == nullptr && newSize != 0)
		{
			return primitiveFailure(_PrimitiveFailureCode::NoMemory);
		}
	}

	return sp - 1;
}

Oop* __fastcall Interpreter::primitiveChangeBehavior(Oop* const sp, primargcount_t)
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
				SmallUinteger diff = receiverClass->m_instanceSpec.m_value ^ argClass->m_instanceSpec.m_value;
				if ((diff & ~InstanceSpecification::IndirectMask) == 0)
				{

					oteReceiver->m_oteClass = oteClassArg;
					// We must reduce the count on the class, since it has been overwritten in the object, and count up the new class
					oteClassArg->countUp();
					oteReceiverClass->countDown();

					return sp - 1;
				}
				// Shapes differ in significant ways
				return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);
			}
			else
			{
				// The receiver is a SmallInteger, and can be mutated to a variable byte object
				// which we have to allocate

				// Do instances of the new class contain pointers, if so fail
				if (!argClass->m_instanceSpec.m_pointers)
				{
					BytesOTE* oteBytes = ObjectMemory::newByteObject<false, false>(oteClassArg, sizeof(SmallUinteger));
					oteClassArg->countUp();
					*reinterpret_cast<SmallUinteger*>(oteBytes->m_location->m_fields) = ObjectMemoryIntegerValueOf(receiver);

					// We've created a new object, so must replace the receiver at stack top
					*(sp - 1) = reinterpret_cast<Oop>(oteBytes);
					ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteBytes));
					return sp - 1;
				}
				// Can't change class of SmallInteger to a pointer object class
				return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);
			}
		}
		// Arg is not a class
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
	// Arg is a SmallInteger (not a class)
	return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

Oop* __fastcall Interpreter::primitiveExtraInstanceSpec(Oop* const sp, primargcount_t)
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
Oop* __fastcall Interpreter::primitiveSetSpecialBehavior(Oop* const sp, primargcount_t)
{
	Oop oopMask = *sp;
	if (ObjectMemoryIsIntegerObject(oopMask))
	{
		SmallInteger mask = ObjectMemoryIntegerValueOf(oopMask);
		Oop oopReceiver = *(sp - 1);
		if (!ObjectMemoryIsIntegerObject(oopReceiver))
		{
			static const uint8_t criticalPointerObjectFlags = static_cast<uint8_t>(OTEFlags::PointerMask | OTEFlags::MarkMask | OTEFlags::FreeMask | OTEFlags::SpaceMask);
			static const uint8_t criticalByteObjectFlags = static_cast<uint8_t>(OTEFlags::PointerMask | OTEFlags::MarkMask | OTEFlags::FreeMask | OTEFlags::SpaceMask | OTEFlags::WeakOrZMask);

			OTE* oteReceiver = reinterpret_cast<OTE*>(oopReceiver);

			// Ensure the masks cannot affect the critical bits of the flags
			// the AND mask, must have the pointer, mark, and free bits set, to keep these bits
			// the OR mask, must have those bits reset so as not to add them
			uint8_t criticalFlags = oteReceiver->m_flags.m_pointer ? criticalPointerObjectFlags : criticalByteObjectFlags;
			uint8_t andMask = (mask >> 8) | criticalFlags;
			uint8_t orMask = mask & static_cast<uint8_t>(~criticalFlags);

			uint8_t oldFlags = oteReceiver->m_ubFlags;
			oteReceiver->m_ubFlags = (oldFlags & andMask) | orMask;

			ASSERT(oteReceiver->isNullTerminated() == oteReceiver->m_oteClass->m_location->m_instanceSpec.m_nullTerminated);

			*(sp - 1) = ObjectMemoryIntegerObjectOf(oldFlags);
			return sp - 1;
		}
		else
		{
			// SmallIntegers can't have special behavior
			return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);
		}
	}
	else
	{
		// Mask is not a SmallInteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

#pragma code_seg(PROCESS_SEG)

// Remove a request from the last request queue, nil if none pending. Fails if argument is not an
// array of the correct length to receiver the popped Queue entry (currently 2 objects)
// Answers nil if the queue is empty, or the argument if an entry was successfully popped into it
Oop* __fastcall Interpreter::primitiveDeQBereavement(Oop* const sp, primargcount_t)
{
	Oop argPointer = *sp;
	if (ObjectMemoryIsIntegerObject(argPointer))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);

	PointersOTE* oteArray = reinterpret_cast<PointersOTE*>(argPointer);
	VariantObject* array = oteArray->m_location;
	if (oteArray->m_oteClass != Pointers.ClassArray || 
		oteArray->pointersSize() != OopsPerBereavementQEntry)
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);

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

Oop* __fastcall Interpreter::primitiveFlushCache(Oop* const sp, primargcount_t)
{
#ifdef _DEBUG
	DumpCacheStats();
#endif
	flushCaches();
	return sp;
}

// Separate atPut primitive is needed to write to the stack because the active process
// stack is not reference counted.
Oop* __fastcall Interpreter::primitiveStackAtPut(Oop* const sp, primargcount_t)
{
	Oop indexPointer = *(sp-1);
	if (!ObjectMemoryIsIntegerObject(indexPointer))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);

	SmallInteger index = ObjectMemoryIntegerValueOf(indexPointer);
	if (index < 1)
		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

	resizeActiveProcess();

	ProcessOTE* oteReceiver = reinterpret_cast<ProcessOTE*>(*(sp-2));
	Process* receiverProcess = static_cast<Process*>(oteReceiver->m_location);
	if (static_cast<size_t>(index) > receiverProcess->stackSize(oteReceiver))
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

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

Oop* __fastcall Interpreter::primitiveIndexOfSP(Oop* const sp, primargcount_t)
{
	ProcessOTE* oteReceiver = reinterpret_cast<ProcessOTE*>(*(sp - 1));
	Oop oopArg = *sp;
	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		Oop address = oopArg - offsetof(Process, m_stack) - reinterpret_cast<uintptr_t>(oteReceiver->m_location);
		Oop index = (address >> 1) + 3;
		*(sp - 1) = index;
		return sp - 1;
	}
	else
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

// Don't care what effect on stack is!!
[[noreturn]] void __fastcall Interpreter::primitiveQuit(Oop* const sp, primargcount_t)
{
	Oop argPointer = *sp;
	exitSmalltalk(ObjectMemoryIntegerValueOf(argPointer));
}

Oop* __fastcall Interpreter::primitiveReplacePointers(Oop* const sp, primargcount_t)
{
	Oop integerPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter4);	// startAt is not an integer
	SmallInteger startAt = ObjectMemoryIntegerValueOf(integerPointer);

	integerPointer = *(sp-1);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter3);	// stop is not an integer
	SmallInteger stop = ObjectMemoryIntegerValueOf(integerPointer);

	integerPointer = *(sp-2);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);	// start is not an integer
	SmallInteger start = ObjectMemoryIntegerValueOf(integerPointer);

	PointersOTE* argPointer = reinterpret_cast<PointersOTE*>(*(sp-3));
	if (ObjectMemoryIsIntegerObject(argPointer) || !argPointer->isPointers())
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Argument MUST be pointer object

	if (stop >= start)
	{
		if (startAt < 1 || start < 1)
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out-of-bounds

		// Empty move if stop before start, is considered valid regardless (strange but true)
		// this is the convention adopted by most implementations.

		// We can test that we're not going to write off the end of the argument
		auto length = argPointer->pointersSizeForUpdate();

		auto toOffset = argPointer->m_oteClass->m_location->fixedFields();
		
		// Adjust to zero-based indices into variable fields of target
		stop = stop - 1 + toOffset;
		start = start - 1 + toOffset;

		if (stop >= length)
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Bounds error (or object is immutable so size < 0)

		VariantObject* arg = reinterpret_cast<PointersOTE*>(argPointer)->m_location;
		Oop* pTo = arg->m_fields;

		PointersOTE* receiverPointer = reinterpret_cast<PointersOTE*>(*(sp-4));

		size_t fromSize = receiverPointer->pointersSize();
		auto fromOffset = receiverPointer->m_oteClass->m_location->fixedFields();
		// Adjust to zero based index into variable fields of source
		startAt = startAt - 1 + fromOffset;

		auto stopAt = startAt + stop - start;
		if (stopAt >= static_cast<ptrdiff_t>(fromSize))
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

		// Only works for pointer objects
		ASSERT(receiverPointer->isPointers());
		VariantObject* receiverObject = receiverPointer->m_location;

		Oop* pFrom = receiverObject->m_fields;

		// Overlapping upwards move? 
		if (argPointer == receiverPointer && startAt < start)
		{
			// Need to do backwards
			for (auto i = stop - start; i >= 0; i--)
			{
				ObjectMemory::storePointerWithValue(pTo[start + i], pFrom[startAt + i]);
			}
		}
		else
		{
			// Do forwards
			for (auto i = 0; i <= stop - start; i++)
			{
				ObjectMemory::storePointerWithValue(pTo[start + i], pFrom[startAt + i]);
			}
		}
	}

	// Answers the argument by moving it down over the receiver
	*(sp-4) = reinterpret_cast<Oop>(argPointer);
	return sp-4;
}

Oop* __fastcall Interpreter::primitiveBasicAt(Oop* const sp, const primargcount_t argCount)
{
	Oop* newSp = sp - argCount;
	OTE* oteReceiver = reinterpret_cast<OTE*>(*newSp);
	Oop oopIndex = *(newSp + 1);

	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		SmallInteger index = ObjectMemoryIntegerValueOf(oopIndex) - 1;
		if (oteReceiver->m_flags.m_pointer)
		{
			size_t size = oteReceiver->pointersSize();
			const auto fixedFields = oteReceiver->m_oteClass->m_location->fixedFields();
			VariantObject* pointerObj = reinterpret_cast<PointersOTE*>(oteReceiver)->m_location;

			if (index >= 0 && static_cast<size_t>(index) + fixedFields < size)
			{
				Oop field = pointerObj->m_fields[index + fixedFields];
				*newSp = field;
				return newSp;
			}
			else
			{
				// Out of bounds
				return primitiveFailure(oteReceiver->m_oteClass->m_location->isIndexable() ? _PrimitiveFailureCode::OutOfBounds : _PrimitiveFailureCode::ObjectTypeMismatch);
			}
		}
		else
		{
			switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteReceiver)))
			{
			case ByteElementSize::Bytes:
				if (static_cast<size_t>(index) < oteReceiver->bytesSize())
				{
					uint8_t value = reinterpret_cast<BytesOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;
				
			case ByteElementSize::Words:
				if (static_cast<size_t>(index) < (oteReceiver->bytesSize() / 2))
				{
					uint16_t value = reinterpret_cast<WordsOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;

			case ByteElementSize::Quads:
				if (static_cast<size_t>(index) < (oteReceiver->bytesSize() / 4))
				{
					uint32_t value = reinterpret_cast<QuadsOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;

			default:
				__assume(false);
				return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
			}

			// Out of bounds
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
		}
	}
	else
	{
		// Index not a smallinteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

Oop* __fastcall Interpreter::primitiveBasicAtPut(Oop* const sp, primargcount_t)
{
	Oop* const newSp = sp - 2;
	OTE* oteReceiver = reinterpret_cast<OTE*>(*newSp);
	Oop oopIndex = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		SmallInteger index = ObjectMemoryIntegerValueOf(oopIndex) - 1;
		if (index >= 0)
		{
			if (oteReceiver->m_flags.m_pointer)
			{
				// Store into pointer object

				const auto size = oteReceiver->pointersSizeForUpdate();
				const auto fixedFields = oteReceiver->m_oteClass->m_location->fixedFields();
				VariantObject* pointerObj = reinterpret_cast<PointersOTE*>(oteReceiver)->m_location;

				if (index + fixedFields < size)
				{
					Oop newValue = *sp;
					ObjectMemory::countUp(newValue);
					Oop oldValue = pointerObj->m_fields[index + fixedFields];
					pointerObj->m_fields[index + fixedFields] = newValue;
					ObjectMemory::countDown(oldValue);
					*newSp = newValue;
					return newSp;
				}
				else
				{
					// Out of bounds, not indexable, or immutable
					return primitiveFailure(size < 0 
						? _PrimitiveFailureCode::AccessViolation
						: oteReceiver->m_oteClass->m_location->isIndexable()
							? _PrimitiveFailureCode::OutOfBounds
							: _PrimitiveFailureCode::ObjectTypeMismatch);
				}
			}
			else
			{
				// Store into byte object

				Oop oopValue = *sp;
				if (ObjectMemoryIsIntegerObject(oopValue))
				{
					const SmallUinteger newValue = ObjectMemoryIntegerValueOf(oopValue);
					const auto size = oteReceiver->bytesSizeForUpdate();

					switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteReceiver)))
					{
					case ByteElementSize::Bytes:
						if (newValue <= UINT8_MAX)
						{
							if (index < size)
							{
								reinterpret_cast<BytesOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<uint8_t>(newValue);
								*newSp = oopValue;
								return newSp;
							}
							else
							{
								return primitiveFailure(size < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
							}
						}
						else
							return primitiveFailure(_PrimitiveFailureCode::IntegerOutOfRange);

					case ByteElementSize::Words:
						if (newValue <= UINT16_MAX)
						{
							if (index < (size / 2))
							{
								reinterpret_cast<WordsOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<uint16_t>(newValue);
								*newSp = oopValue;
								return newSp;
							}
							else
							{
								return primitiveFailure(size < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
							}
						}
						else
							return primitiveFailure(_PrimitiveFailureCode::IntegerOutOfRange);

					case ByteElementSize::Quads:
						if (index < (size / 4))
						{
							reinterpret_cast<QuadsOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<uint32_t>(newValue);
							*newSp = oopValue;
							return newSp;
						}
						else
						{
							return primitiveFailure(size < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
						}

					default:
						__assume(false);
						// Invalid encoding length
						return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
					}
				}
				// Not a SmallInteger value to store
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
			}
		}
		// Index is not a positive SmallInteger
		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
	}
	// Index not a smallinteger
	return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}


Oop* __fastcall Interpreter::primitiveInstVarAt(Oop* const sp, primargcount_t)
{
	Oop* const newSp = sp - 1;
	Oop oopIndex = *sp;
	OTE* oteReceiver = reinterpret_cast<OTE*>(*newSp);
	
	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		SmallInteger index = ObjectMemoryIntegerValueOf(oopIndex) - 1;
		if (oteReceiver->m_flags.m_pointer)
		{
			size_t size = oteReceiver->pointersSize();
			VariantObject* pointerObj = reinterpret_cast<PointersOTE*>(oteReceiver)->m_location;

			if (static_cast<size_t>(index) < size)
			{
				Oop field = pointerObj->m_fields[index];
				*newSp = field;
				return newSp;
			}
			// Out of bounds
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
		}
		else
		{
			switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteReceiver)))
			{
			case ByteElementSize::Bytes:
				if (static_cast<size_t>(index) < oteReceiver->bytesSize())
				{
					uint8_t value = reinterpret_cast<BytesOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;

			case ByteElementSize::Words:
				if (static_cast<size_t>(index) < (oteReceiver->bytesSize() / 2))
				{
					uint16_t value = reinterpret_cast<WordsOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;

			case ByteElementSize::Quads:
				if (static_cast<size_t>(index) < (oteReceiver->bytesSize() / 4))
				{
					uint32_t value = reinterpret_cast<QuadsOTE*>(oteReceiver)->m_location->m_fields[index];
					*newSp = ObjectMemoryIntegerObjectOf(value);
					return newSp;
				}
				break;

			default:
				__assume(false);
				return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
			}

			// Out of bounds
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
		}
	}
	// Index not a smallinteger
	return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

Oop* __fastcall Interpreter::primitiveInstVarAtPut(Oop* const sp, primargcount_t)
{
	Oop* const newSp = sp - 2;
	OTE* oteReceiver = reinterpret_cast<OTE*>(*newSp);
	Oop oopIndex = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		SmallInteger index = ObjectMemoryIntegerValueOf(oopIndex) - 1;
		if (index >= 0)
		{
			if (oteReceiver->m_flags.m_pointer)
			{
				// Store into pointer object

				ptrdiff_t size = oteReceiver->pointersSizeForUpdate();
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
				else
				{
					// Out of bounds or immutable
					return primitiveFailure(size < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
				}
			}
			else
			{
				// Store into byte object

				Oop oopValue = *sp;
				if (ObjectMemoryIsIntegerObject(oopValue))
				{
					const SmallUinteger newValue = ObjectMemoryIntegerValueOf(oopValue);
					const ptrdiff_t size = oteReceiver->bytesSizeForUpdate();

					switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteReceiver)))
					{
					case ByteElementSize::Bytes:
						if (newValue <= UINT8_MAX)
						{
							if (index < size)
							{
								reinterpret_cast<BytesOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<uint8_t>(newValue);
								*newSp = oopValue;
								return newSp;
							}
							else
							{
								// Out of bounds or immutable
								return primitiveFailure(size < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
							}
						}
						return primitiveFailure(_PrimitiveFailureCode::IntegerOutOfRange);

					case ByteElementSize::Words:
						if (newValue <= UINT16_MAX)
						{
							if (index < (size / 2))
							{
								reinterpret_cast<WordsOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<uint16_t>(newValue);
								*newSp = oopValue;
								return newSp;
							}
							else
							{
								// Out of bounds or immutable
								return primitiveFailure(size < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
							}
						}
						return primitiveFailure(_PrimitiveFailureCode::IntegerOutOfRange);

					case ByteElementSize::Quads:
						if (index < (size / 4))
						{
							reinterpret_cast<QuadsOTE*>(oteReceiver)->m_location->m_fields[index] = static_cast<uint32_t>(newValue);
							*newSp = oopValue;
							return newSp;
						}
						else
						{
							// Out of bounds or immutable
							return primitiveFailure(size < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
						}

					default:
						__assume(false);
						return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
					}
				}
				// Not a SmallInteger
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
			}
		}
		// Negative index
		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
	}

	// Index not a smallinteger
	return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

Oop* __fastcall Interpreter::primitiveGetImmutable(Oop* const sp, primargcount_t)
{
	Oop receiver = *sp;
	*sp = reinterpret_cast<Oop>(ObjectMemoryIsIntegerObject(receiver) || reinterpret_cast<OTE*>(receiver)->isImmutable() ? Pointers.True : Pointers.False);
	return sp;
}

Oop* __fastcall Interpreter::primitiveSetImmutable(Oop* const sp, primargcount_t)
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
			return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);
	}
}

Oop* __fastcall Interpreter::primitiveDeQForFinalize(Oop* const sp, primargcount_t)
{
	// Dequeue an entry from the finalization queue, and answer it.Answers nil if the queue is empty
	OTE* ote = dequeueForFinalization();
	*sp = reinterpret_cast<Oop>(ote);
	ote->countDown();
	return sp;
}

Oop* __fastcall Interpreter::primitiveBecome(Oop* const sp, primargcount_t)
{
	Oop	arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		OTE* oteArg = reinterpret_cast<OTE*>(arg);
		if (!ObjectMemory::isPermanent(oteArg))
		{
			Oop receiver = *(sp - 1);
			if (!ObjectMemoryIsIntegerObject(receiver))
			{
				OTE* oteReceiver = reinterpret_cast<OTE*>(receiver);
				if (!ObjectMemory::isPermanent(oteReceiver))
				{
					// THIS MUST BE CHANGED IF OTE LAYOUT CHANGED.
					// Note that we swap the location pointer(obviously), the class pointer(as we
					// aren't swapping the class), and flags. All belong with the object.
					// We don't swap the identity hash or count, as these belong with the pointer (identity)

					// Exchange body pointers
					std::swap(oteReceiver->m_location, oteArg->m_location);
					// Exchange class pointers
					std::swap(oteReceiver->m_oteClass, oteArg->m_oteClass);
					// Exchange object sizes(I think it is right to swap immutability bit over too ? )
					std::swap(oteReceiver->m_size, oteArg->m_size);
					// Exchange first 8 bits of flags(exclude identityHash and ref.count)
					std::swap(oteReceiver->m_ubFlags, oteArg->m_ubFlags);

					return sp - 1;
				}
			}
			// Invalid receiver
			return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);
		}
	}

	// Invalid arg
	return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}
