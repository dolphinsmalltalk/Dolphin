/******************************************************************************

	File: Alloc.cpp

	Description:

	Object Memory management allocation/coping routines

******************************************************************************/

#include "Ist.h"

#pragma code_seg(MEM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "VirtualMemoryStats.h"

#ifdef DOWNLOADABLE
#include "downloadableresource.h"
#else
#include "rc_vm.h"
#endif

// Smalltalk classes
#include "STVirtualObject.h"
#include "STByteArray.h"

///////////////////////////////////////////////////////////////////////////////
// Oop allocation

inline OTE* __fastcall ObjectMemory::allocateOop(POBJECT pLocation)
{
	__assume(m_pFreePointerList != nullptr);

	// N.B. By not ref. counting class here, we make a useful saving of a redundant
	// ref. counting operation in primitiveNew and primitiveNewWithArg

	OTE* ote = m_pFreePointerList;

	m_pFreePointerList = NextFree(ote);

	ASSERT(ote->isFree());
#ifdef TRACKFREEOTEs
	--m_nFreeOTEs;
	assert(m_nFreeOTEs >= 0);
	//assert(m_nFreeOTEs == CountFreeOTEs());
#endif

	// Set OTE fields of the Oop
	ote->m_location = pLocation;

	// Maintain the last used garbage collector mark to speed up collections
	// Doing this will also reset the free bit and set the pointer bit
	// so byte allocations will need to reset it
	ote->m_flagsWord = *reinterpret_cast<uint8_t*>(&m_spaceOTEBits[static_cast<space_t>(Spaces::Normal)]);

	return ote;
}


///////////////////////////////////////////////////////////////////////////////
// Public object allocation routines

template <bool zero> POBJECT ObjectMemory::allocObject(size_t objectSize, OTE*& ote)
{
	POBJECT pObj = static_cast<POBJECT>(allocChunk<zero>(_ROUND2(objectSize, sizeof(Oop))));

	// allocateOop expects crit section to be used
	ote = allocateOop(pObj);
	ote->setSize(objectSize);
	ote->m_flags.m_space = static_cast<space_t>(Spaces::Normal);
	return pObj;
}


///////////////////////////////////////////////////////////////////////////////
// Object copying (mostly allocation)


PointersOTE* __fastcall ObjectMemory::shallowCopy(PointersOTE* ote)
{
	ASSERT(!ote->isBytes());

	// A pointer object is a bit more tricky to copy (but not much)
	VariantObject* obj = ote->m_location;
	BehaviorOTE* classPointer = ote->m_oteClass;

	PointersOTE* copyPointer;
	size_t size;

	if (ote->heapSpace() != Spaces::Virtual)
	{
		size = ote->pointersSize();
		copyPointer = newPointerObject(classPointer, size);
	}
	else
	{
		Interpreter::resizeActiveProcess();

		size = ote->pointersSize();

		VirtualObject* pVObj = reinterpret_cast<VirtualObject*>(obj);
		VirtualObjectHeader* pBase = pVObj->getHeader();
		size_t maxByteSize = pBase->getMaxAllocation();
		size_t currentTotalByteSize = pBase->getCurrentAllocation();

		VirtualOTE* virtualCopy = ObjectMemory::newVirtualObject(classPointer,
			currentTotalByteSize / sizeof(Oop),
			maxByteSize / sizeof(Oop));
		if (virtualCopy)
		{
			pVObj = virtualCopy->m_location;
			pBase = pVObj->getHeader();
			ASSERT(pBase->getMaxAllocation() == maxByteSize);
			ASSERT(pBase->getCurrentAllocation() == currentTotalByteSize);
			virtualCopy->setSize(ote->getSize());

			copyPointer = reinterpret_cast<PointersOTE*>(virtualCopy);
		}
		else
		{
			return nullptr;
		}
	}

	// Now copy over all the fields
	VariantObject* copy = copyPointer->m_location;
	ASSERT(copyPointer->pointersSize() == size);
	for (auto i = 0u; i<size; i++)
	{
		copy->m_fields[i] = obj->m_fields[i];
		countUp(obj->m_fields[i]);
	}
	return copyPointer;
}

Oop* PRIMCALL Interpreter::primitiveShallowCopy(Oop* const sp, primargcount_t)
{
	OTE* receiver = reinterpret_cast<OTE*>(*sp);
	ASSERT(!isIntegerObject(receiver));

	OTE* copy = receiver->m_flags.m_pointer
		? (OTE*)ObjectMemory::shallowCopy(reinterpret_cast<PointersOTE*>(receiver))
		: (OTE*)ObjectMemory::shallowCopy(reinterpret_cast<BytesOTE*>(receiver));
	*sp = (Oop)copy;
	ObjectMemory::AddToZct(copy);
	return sp;
}

///////////////////////////////////////////////////////////////////////////////
// Public object Instantiation (see also Objmem.h)
//
// These methods return Oops rather than OTE*'s because we want the type to be
// opaque to external users, and to be interchangeable with uinptr_ts.
//

Oop* PRIMCALL Interpreter::primitiveNewFromStack(Oop* const stackPointer, primargcount_t)
{
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*(stackPointer - 1));

	Oop oopArg = (*stackPointer);
	SmallInteger count;
	if (isIntegerObject(oopArg) && (count = ObjectMemoryIntegerValueOf(oopArg)) >= 0)
	{
		// Note that instantiateClassWithPointers counts up the class,
		PointersOTE* oteObj = ObjectMemory::newUninitializedPointerObject(oteClass, count);
		VariantObject* obj = oteObj->m_location;

		Oop* sp = stackPointer;
		sp = sp - count - 1;
		while (--count >= 0)
		{
			oopArg = *(sp + count);
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
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

Oop* PRIMCALL Interpreter::primitiveNewInitializedObject(Oop* sp, primargcount_t argCount)
{
	Oop oopReceiver = *(sp - argCount);
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(oopReceiver);
	InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;

	if ((instSpec.m_value & (InstanceSpecification::PointersMask | InstanceSpecification::NonInstantiableMask)) == InstanceSpecification::PointersMask)
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
				return primitiveFailure(_PrimitiveFailureCode::WrongNumberOfArgs);
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
		return primitiveFailure(instSpec.m_nonInstantiable ? _PrimitiveFailureCode::NonInstantiable : _PrimitiveFailureCode::ObjectTypeMismatch);
	}
}

Oop* PRIMCALL Interpreter::primitiveNew(Oop* const sp, primargcount_t)
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
		return primitiveFailure(instSpec.m_nonInstantiable ? _PrimitiveFailureCode::NonInstantiable : _PrimitiveFailureCode::ObjectTypeMismatch);
	}
}

Oop* PRIMCALL Interpreter::primitiveNewWithArg(Oop* const sp, primargcount_t argc)
{
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*(sp - argc));
	Oop oopArg = *(sp - argc + 1);
	// Unfortunately the compiler can't be persuaded to perform this using just the sar and conditional jumps on no-carry and signed;
	// it generates both the bit test and the shift.
	SmallInteger size;
	if (isIntegerObject(oopArg) && (size = ObjectMemoryIntegerValueOf(oopArg)) >= 0)
	{
		InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;
		SmallUinteger mask = size == 0 ? 0 : InstanceSpecification::IndexableMask;
		if ((instSpec.m_value & (InstanceSpecification::NonInstantiableMask | mask)) == mask)
		{
			if (instSpec.m_pointers)
			{
				// We allow an extra argument to specify the initial values
				if (argc == 1)
				{
					PointersOTE* newObj = ObjectMemory::newPointerObject(oteClass, size + instSpec.m_fixedFields);
					*(sp - 1) = reinterpret_cast<Oop>(newObj);
					ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObj));
					return sp - 1;
				}
				else
				{
					Oop oopValue = *(sp);
					const size_t fixed = instSpec.m_fixedFields;
					const size_t total = size + fixed;
					PointersOTE* newObj = ObjectMemory::newUninitializedPointerObject(oteClass, total);
					Oop* fields = newObj->m_location->m_fields;
					for (size_t i = fixed; i < total; i++)
					{
						fields[i] = oopValue;
					}
					if (!ObjectMemoryIsIntegerObject(oopValue))
					{
						OTE* oteValue = reinterpret_cast<OTE*>(oopValue);
						size_t totalCount = oteValue->m_count + size;
						oteValue->m_count = static_cast<count_t>(min(totalCount, OTE::MAXCOUNT));
					}
					*(sp - argc) = reinterpret_cast<Oop>(newObj);
					ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObj));
					return sp - argc;
				}
			}
			else
			{
				if (argc == 1)
				{
					BytesOTE* newObj = ObjectMemory::newByteObject<true, true>(oteClass, size);
					*(sp - 1) = reinterpret_cast<Oop>(newObj);
					ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObj));
					return sp - 1;
				}
				else
				{
					Oop oopValue = *(sp);
					SmallInteger value;
					if (ObjectMemoryIsIntegerObject(oopValue) && (value = ObjectMemoryIntegerValueOf(oopValue)) >= 0 && value <= 255)
					{
						BytesOTE* newObj = ObjectMemory::newByteObject<true, false>(oteClass, size);
						// Beware: FillMemory argument order is different to memset
						FillMemory(newObj->m_location, size, value);
						*(sp - argc) = reinterpret_cast<Oop>(newObj);
						ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObj));
						return sp - argc;
					}
					else
					{
						return primitiveFailure(_PrimitiveFailureCode::IntegerOutOfRange);
					}
				}
			}
		}
		else
		{
			// Not indexable, or non-instantiable
			return primitiveFailure(instSpec.m_nonInstantiable ? _PrimitiveFailureCode::NonInstantiable : _PrimitiveFailureCode::ObjectTypeMismatch);
		}
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Size must be positive SmallInteger
	}
}

PointersOTE* __fastcall ObjectMemory::newPointerObject(BehaviorOTE* classPointer)
{
	ASSERT(isBehavior(Oop(classPointer)));
	return newPointerObject(classPointer, classPointer->m_location->fixedFields());
}

PointersOTE* __fastcall ObjectMemory::newPointerObject(BehaviorOTE* classPointer, size_t oops)
{
	PointersOTE* ote = newUninitializedPointerObject(classPointer, oops);

	// Initialise the fields to nils
	const Oop nil = Oop(Pointers.Nil);		// Loop invariant (otherwise compiler reloads each time)
	VariantObject* pLocation = ote->m_location;
	const size_t loopEnd = oops;
	for (size_t i = 0; i<loopEnd; i++)
		pLocation->m_fields[i] = nil;

	ASSERT(ote->isPointers());

	return reinterpret_cast<PointersOTE*>(ote);
}

PointersOTE* __fastcall ObjectMemory::newUninitializedPointerObject(BehaviorOTE* classPointer, size_t oops)
{
	ASSERT(isBehavior((Oop)classPointer) && classPointer->isPointers());

	// Don't worry, compiler will not really use multiply instruction here
	size_t objectSize = SizeOfPointers(oops);
	OTE* ote;
	allocObject<false>(objectSize, ote);
	ASSERT(ote->heapSpace() == Spaces::Normal);

	// These are stored in the object itself
	ASSERT(ote->getSize() == objectSize);
	classPointer->countUp();
	ote->m_oteClass = classPointer;

	// DO NOT Initialise the fields to nils

	ASSERT(ote->isPointers());
	
	return reinterpret_cast<PointersOTE*>(ote);
}

template <bool MaybeZ, bool Initialized> BytesOTE* ObjectMemory::newByteObject(BehaviorOTE* classPointer, size_t elementCount)
{
	Behavior& byteClass = *classPointer->m_location;
	OTE* ote;

	if (!MaybeZ || !byteClass.m_instanceSpec.m_nullTerminated)
	{
		ASSERT(!classPointer->m_location->m_instanceSpec.m_nullTerminated);

		VariantByteObject* newBytes = static_cast<VariantByteObject*>(allocObject<Initialized>(elementCount + SizeOfPointers(0), ote));
		ASSERT(ote->heapSpace() == Spaces::Normal);
		ASSERT(ote->getSize() == elementCount + SizeOfPointers(0));

		if (Initialized)
		{
			classPointer->countUp();
		}

		ote->m_oteClass = classPointer;
		ote->beBytes();
	}
	else
	{
		ASSERT(classPointer->m_location->m_instanceSpec.m_nullTerminated);

		size_t objectSize;

		switch (reinterpret_cast<const StringClass&>(byteClass).Encoding)
		{
		case StringEncoding::Ansi:
		case StringEncoding::Utf8:
			objectSize = elementCount * sizeof(AnsiString::CU);
			break;
		case StringEncoding::Utf16:
			objectSize = elementCount * sizeof(Utf16String::CU);
			break;
		case StringEncoding::Utf32:
			objectSize = elementCount * sizeof(Utf32String::CU);
			break;
		default:
			__assume(false);
			break;
		}

		// TODO: Allocate the correct number of null term bytes based on the encoding
		objectSize += NULLTERMSIZE;

		VariantByteObject* newBytes = static_cast<VariantByteObject*>(allocObject<true>(objectSize + SizeOfPointers(0), ote));
		ASSERT(ote->heapSpace() == Spaces::Normal);

		ASSERT(ote->getSize() == objectSize + SizeOfPointers(0));

		if (Initialized)
		{
			classPointer->countUp();
		}
		else
		{
			// We still want to ensure the null terminator is set, even if not initializing the rest of the object
			*reinterpret_cast<NULLTERMTYPE*>(&newBytes->m_fields[objectSize - NULLTERMSIZE]) = 0;
		}

		ote->m_oteClass = classPointer;
		ote->beNullTerminated();
		HARDASSERT(ote->isBytes());
	}

	return reinterpret_cast<BytesOTE*>(ote);
}

// Explicit instantiations
template BytesOTE* ObjectMemory::newByteObject<false, false>(BehaviorOTE*, size_t);
template BytesOTE* ObjectMemory::newByteObject<false, true>(BehaviorOTE*, size_t);
template BytesOTE* ObjectMemory::newByteObject<true, false>(BehaviorOTE*, size_t);
template BytesOTE* ObjectMemory::newByteObject<true, true>(BehaviorOTE*, size_t);

Oop* PRIMCALL Interpreter::primitiveNewPinned(Oop* const sp, primargcount_t)
{
	BehaviorOTE* oteClass = reinterpret_cast<BehaviorOTE*>(*(sp - 1));
	Oop oopArg = (*sp);
	if (isIntegerObject(oopArg))
	{
		SmallInteger size = ObjectMemoryIntegerValueOf(oopArg);
		if (size >= 0)
		{
			InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;
			if (!(instSpec.m_pointers || instSpec.m_nonInstantiable))
			{
				BytesOTE* newObj = ObjectMemory::newByteObject<true, true>(oteClass, size);
				*(sp - 1) = reinterpret_cast<Oop>(newObj);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(newObj));
				return sp - 1;
			}
			else
			{
				// Not bytes, or non-instantiable
				return primitiveFailure(instSpec.m_nonInstantiable ? _PrimitiveFailureCode::NonInstantiable : _PrimitiveFailureCode::ObjectTypeMismatch);
			}
		}
	}

	return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Size must be positive SmallInteger
}

OTE* ObjectMemory::CopyElements(OTE* oteObj, size_t startingAt, size_t count)
{
	// Note that startingAt is expected to be a zero-based index
	ASSERT(startingAt >= 0);
	OTE* oteSlice;

	if (oteObj->isBytes())
	{
		BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(oteObj);
		size_t elementSizeShift = static_cast<size_t>(ObjectMemory::GetBytesElementSize(oteBytes));

		if (count == 0 || (((startingAt + count) << elementSizeShift) <= oteBytes->bytesSize()))
		{
			size_t objectSize = count << elementSizeShift;

			if (oteBytes->m_flags.m_weakOrZ)
			{
				// TODO: Allocate the correct number of null term bytes based on the encoding
				auto newBytes = static_cast<VariantByteObject*>(allocObject<false>(objectSize + NULLTERMSIZE, oteSlice));
				// When copying strings, the slices has the same string class
				(oteSlice->m_oteClass = oteBytes->m_oteClass)->countUp();
				CopyMemory(newBytes->m_fields, oteBytes->m_location->m_fields + (startingAt << elementSizeShift), objectSize);
				*reinterpret_cast<NULLTERMTYPE*>(&newBytes->m_fields[objectSize]) = 0;
				oteSlice->beNullTerminated();
				return oteSlice;
			}
			else
			{
				VariantByteObject* newBytes = static_cast<VariantByteObject*>(allocObject<false>(objectSize, oteSlice));
				// When copying bytes, the slice is always a ByteArray
				oteSlice->m_oteClass = Pointers.ClassByteArray;
				oteSlice->beBytes();
				CopyMemory(newBytes->m_fields, oteBytes->m_location->m_fields + (startingAt << elementSizeShift), objectSize);
				return oteSlice;
			}
		}
	}
	else
	{
		// Pointers
		PointersOTE* otePointers = reinterpret_cast<PointersOTE*>(oteObj);
		BehaviorOTE* oteClass = otePointers->m_oteClass;
		InstanceSpecification instSpec = oteClass->m_location->m_instanceSpec;
		if (instSpec.m_indexable)
		{
			startingAt += instSpec.m_fixedFields;

			if (count == 0 || (startingAt + count) <= otePointers->pointersSize())
			{
				size_t objectSize = SizeOfPointers(count);
				auto pSlice = static_cast<VariantObject*>(allocObject<false>(objectSize, oteSlice));
				// When copying pointers, the slice is always an Array
				oteSlice->m_oteClass = Pointers.ClassArray;
				VariantObject* pSrc = otePointers->m_location;
				for (size_t i = 0; i < count; i++)
				{
					countUp(pSlice->m_fields[i] = pSrc->m_fields[startingAt + i]);
				}
				return oteSlice;
			}
		}
	}

	return nullptr;
}

Oop* Interpreter::primitiveCopyFromTo(Oop* const sp, primargcount_t)
{
	Oop oopToArg = *sp;
	Oop oopFromArg = *(sp - 1);
	OTE* oteReceiver = reinterpret_cast<OTE*>(*(sp - 2));
	if (ObjectMemoryIsIntegerObject(oopToArg))
	{
		if (ObjectMemoryIsIntegerObject(oopFromArg))
		{
			SmallInteger from = ObjectMemoryIntegerValueOf(oopFromArg);
			SmallInteger to = ObjectMemoryIntegerValueOf(oopToArg);

			if (from > 0)
			{
				SmallInteger count = to - from + 1;
				if (count >= 0)
				{
					OTE* oteAnswer = ObjectMemory::CopyElements(oteReceiver, from - 1, count);
					if (oteAnswer != nullptr)
					{
						*(sp - 2) = (Oop)oteAnswer;
						ObjectMemory::AddToZct(oteAnswer);
						return sp - 2;
					}
				}
			}

			// Bounds error
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
		}
		else
		{
			// Non positive SmallInteger 'from'
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
		}
	}
	else
	{
		// Non positive SmallInteger 'to'
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
	}
}

BytesOTE* __fastcall ObjectMemory::shallowCopy(BytesOTE* ote)
{
	ASSERT(ote->isBytes());

	// Copying byte objects is simple and fast
	VariantByteObject& bytes = *ote->m_location;
	BehaviorOTE* classPointer = ote->m_oteClass;
	size_t objectSize = ote->sizeOf();

	OTE* copyPointer;
	// Allocate an uninitialized object ...
	VariantByteObject* pLocation = static_cast<VariantByteObject*>(allocObject<false>(objectSize, copyPointer));
	ASSERT(copyPointer->heapSpace() == Spaces::Normal);

	ASSERT(copyPointer->getSize() == objectSize);
	// This set does not want to copy over the immutability bit - i.e. even if the original was immutable, the 
	// copy will never be.
	copyPointer->setSize(ote->getSize());
	copyPointer->m_flagsWord = (copyPointer->m_flagsWord & ~OTEFlags::WeakMask) | (ote->m_flagsWord & OTEFlags::WeakMask);
	ASSERT(copyPointer->isBytes());
	copyPointer->m_oteClass = classPointer;
	classPointer->countUp();

	// Copy the entire object over the other one, including any null terminator and object header
	CopyMemory(pLocation, &bytes, objectSize);

	return reinterpret_cast<BytesOTE*>(copyPointer);
}


///////////////////////////////////////////////////////////////////////////////
// Virtual object space allocation

// Answer a new process with an initial stack size specified by the first argument, and a maximum
// stack size specified by the second argument.
Oop* PRIMCALL Interpreter::primitiveNewVirtual(Oop* const sp, primargcount_t)
{
	Oop maxArg = *sp;
	SmallInteger maxSize;
	if (ObjectMemoryIsIntegerObject(maxArg) && (maxSize = ObjectMemoryIntegerValueOf(maxArg)) >= 0)
	{
		Oop initArg = *(sp - 1);
		SmallInteger initialSize;
		if (ObjectMemoryIsIntegerObject(initArg) && (initialSize = ObjectMemoryIntegerValueOf(initArg)) >= 0)
		{
			BehaviorOTE* receiverClass = reinterpret_cast<BehaviorOTE*>(*(sp - 2));
			InstanceSpecification instSpec = receiverClass->m_location->m_instanceSpec;
			if (instSpec.m_indexable && !instSpec.m_nonInstantiable)
			{
				auto fixedFields = instSpec.m_fixedFields;
				VirtualOTE* newObject = ObjectMemory::newVirtualObject(receiverClass, initialSize + fixedFields, maxSize);
				if (newObject)
				{
					*(sp - 2) = reinterpret_cast<Oop>(newObject);
						// No point saving down SP before potential Zct reconcile as the init & max args must be SmallIntegers
						ObjectMemory::AddToZct((OTE*)newObject);
					return sp - 2;
				}
				else
				{
					return primitiveFailure(_PrimitiveFailureCode::NoMemory);	// OOM
				}
			}
			else
			{
				return primitiveFailure(instSpec.m_nonInstantiable ? _PrimitiveFailureCode::NonInstantiable : _PrimitiveFailureCode::ObjectTypeMismatch);	// Non-indexable or abstract class
			}
		}
		else
		{
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// initialSize is not a positive SmallInteger
		}
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);	// maxsize is not a positive SmallInteger
	}
}

/*
	Allocate a new virtual object from virtual space, which can grow up to maxBytes (including the
	virtual allocation overhead) but which has an initial size of initialBytes (NOT including the
	virtual allocation overhead). Should the allocation request fail, then a memory exception is 
	generated.
*/
Oop* __stdcall AllocateVirtualSpace(size_t maxBytes, size_t initialBytes)
{
	size_t reserveBytes = _ROUND2(maxBytes + dwPageSize, dwAllocationGranularity);
	ASSERT(reserveBytes % dwAllocationGranularity == 0);
	void* pReservation = ::VirtualAlloc(NULL, reserveBytes, MEM_RESERVE, PAGE_NOACCESS);
	if (pReservation)
	{

#ifdef _DEBUG
		// Let's see whether we got the rounding correct!
		MEMORY_BASIC_INFORMATION mbi;
		VERIFY(::VirtualQuery(pReservation, &mbi, sizeof(mbi)) == sizeof(mbi));
		ASSERT(mbi.AllocationBase == pReservation);
		ASSERT(mbi.BaseAddress == pReservation);
		ASSERT(mbi.AllocationProtect == PAGE_NOACCESS);
		//	ASSERT(mbi.Protect == PAGE_NOACCESS);
		ASSERT(mbi.RegionSize == reserveBytes);
		ASSERT(mbi.State == MEM_RESERVE);
		ASSERT(mbi.Type == MEM_PRIVATE);
#endif

		// We expect the initial byte size to be a integral number of pages, and it must also take account
		// of the virtual allocation overhead (currently 4 bytes)
		initialBytes = _ROUND2(initialBytes + sizeof(VirtualObjectHeader), dwPageSize);
		ASSERT(initialBytes % dwPageSize == 0);

		// Note that VirtualAlloc initializes the committed memory to zeroes.
		VirtualObjectHeader* pLocation = static_cast<VirtualObjectHeader*>(::VirtualAlloc(pReservation, initialBytes, MEM_COMMIT, PAGE_READWRITE));
		if (pLocation)
		{

#ifdef _DEBUG
			// Let's see whether we got the rounding correct!
			VERIFY(::VirtualQuery(pLocation, &mbi, sizeof(mbi)) == sizeof(mbi));
			ASSERT(mbi.AllocationBase == pLocation);
			ASSERT(mbi.BaseAddress == pLocation);
			ASSERT(mbi.AllocationProtect == PAGE_NOACCESS);
			ASSERT(mbi.Protect == PAGE_READWRITE);
			ASSERT(mbi.RegionSize == initialBytes);
			ASSERT(mbi.State == MEM_COMMIT);
			ASSERT(mbi.Type == MEM_PRIVATE);
#endif

			// Use first slot to hold the maximum size for the object
			pLocation->setMaxAllocation(maxBytes);
			return reinterpret_cast<Oop*>(pLocation + 1);
		}
	}

	::RaiseException(STATUS_NO_MEMORY, 0, 0, nullptr);
	return nullptr;
}

// N.B. Like the other instantiate methods in ObjectMemory, this method for instantiating
// objects in virtual space (used for allocating Processes, for example), does not adjust
// the ref. count of the class, because this is often unecessary, and does not adjust the
// sizes to allow for fixed fields - callers must do this
VirtualOTE* ObjectMemory::newVirtualObject(BehaviorOTE* classPointer, size_t initialSize, size_t maxSize)
{
	#ifdef _DEBUG
	{
		ASSERT(isBehavior(Oop(classPointer)));
		Behavior& behavior = *classPointer->m_location;
		ASSERT(behavior.isIndexable());
	}
	#endif

	// Trim the sizes to acceptable bounds
	if (initialSize <= dwOopsPerPage)
		initialSize = dwOopsPerPage;
	else
		initialSize = _ROUND2(initialSize, dwOopsPerPage);

	if (maxSize < initialSize)
		maxSize = initialSize;
	else
		maxSize = _ROUND2(maxSize, dwOopsPerPage);

	// We have to allow for the virtual allocation overhead. The allocation function will add in
	// space for this. The maximum size should include this, the initial size should not
	initialSize -= sizeof(VirtualObjectHeader)/sizeof(Oop);

	size_t byteSize = initialSize*sizeof(Oop);
	VariantObject* pLocation = reinterpret_cast<VariantObject*>(AllocateVirtualSpace(maxSize * sizeof(Oop), byteSize));
	if (pLocation)
	{
		// No need to alter ref. count of process class, as it is sticky

		// Fill space with nils for initial values
		const Oop nil = Oop(Pointers.Nil);
		const size_t loopEnd = initialSize;
		for (size_t i = 0; i < loopEnd; i++)
			pLocation->m_fields[i] = nil;

		OTE* ote = ObjectMemory::allocateOop(static_cast<POBJECT>(pLocation));
		ote->setSize(byteSize);
		ote->m_oteClass = classPointer;
		classPointer->countUp();
		ote->m_flags = m_spaceOTEBits[static_cast<space_t>(Spaces::Virtual)];
		ASSERT(ote->isPointers());

		return reinterpret_cast<VirtualOTE*>(ote);
	}

	return nullptr;
}

