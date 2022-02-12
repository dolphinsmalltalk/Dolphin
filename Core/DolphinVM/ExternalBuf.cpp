#include "Ist.h"

#ifndef _DEBUG
//#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

#include "Interprt.h"
#include "ObjMem.h"
#include "rc_vm.h"
#include "InterprtPrim.inl"
#include "InterprtProc.inl"
#include "STByteArray.h"
#include "Interprt.h"
#include "ExternalBuf.h"

Oop* PRIMCALL Interpreter::primitiveAddressOf(Oop * const sp, primargcount_t argCount)
{
	StoreUIntPtr()(sp, reinterpret_cast<uintptr_t>(reinterpret_cast<OTE*>(*sp)->m_location));
	return sp;
}

Oop* PRIMCALL Interpreter::primitiveBytesIsNull(Oop * const sp, primargcount_t argCount)
{
	AddressOTE* oteBytes = reinterpret_cast<AddressOTE*>(*sp);
	size_t size = oteBytes->bytesSize();
	if (size == sizeof(uintptr_t))
	{
		*sp = reinterpret_cast<Oop>(oteBytes->m_location->m_pointer == nullptr ? Pointers.True : Pointers.False);
		return sp;
	}
	else
		return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);
}

Oop* PRIMCALL Interpreter::primitiveStructureIsNull(Oop * const sp, primargcount_t argCount)
{
	StructureOTE* oteStruct = reinterpret_cast<StructureOTE*>(*sp);

	BytesOTE* oteContents = oteStruct->m_location->m_contents;
	if (!ObjectMemoryIsIntegerObject(oteContents))
	{
		if (oteContents->isBytes())
		{
			// Expecting a ByteArray of ExternalAddress, but we don't check this
			BehaviorOTE* oteContentsClass = oteContents->m_oteClass;

			if (oteContentsClass->m_location->isIndirect())
			{
				*sp = reinterpret_cast<Oop>(reinterpret_cast<AddressOTE*>(oteContents)->m_location->m_pointer == nullptr ? Pointers.True : Pointers.False);
				return sp;
			}
			else
			{
				// Not an indirection object, can't be null
				*sp = reinterpret_cast<Oop>(Pointers.False);
				return sp;
			}
		}
		else
		{
			// Could be nil
			if (isNil(oteContents))
			{
				*sp = reinterpret_cast<Oop>(Pointers.True);
				return sp;
			}
			else
			{
				// Some other pointer object, which is not valid
				return primitiveFailure(_PrimitiveFailureCode::ObjectTypeMismatch);
			}
		}
	}
	else
	{
		// Old assembler primitive allowed first inst var to be a SmallInteger and returned true if zero
		*sp = reinterpret_cast<Oop>(reinterpret_cast<Oop>(oteContents) == ZeroPointer ? Pointers.True : Pointers.False);
		return sp;
	}
}

Oop* PRIMCALL Interpreter::primitiveUint32AtPut(Oop * const sp, primargcount_t argCount)
{
	BytesOTE* oteReceiver = reinterpret_cast<BytesOTE*>(*(sp - 2));
	Oop oopOffset = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		const ptrdiff_t size = oteReceiver->bytesSizeForUpdate();
		SmallInteger offset = ObjectMemoryIntegerValueOf(oopOffset);
		if (offset >= 0 && static_cast<ptrdiff_t>(offset + sizeof(uint32_t)) <= size)
		{
			// Store into byte object
			Oop oopValue = *sp;
			uint32_t* pBuf = reinterpret_cast<uint32_t*>(oteReceiver->m_location->m_fields + offset);
			if (ObjectMemoryIsIntegerObject(oopValue))
			{
				const uint32_t newValue = ObjectMemoryIntegerValueOf(oopValue);
				*pBuf = newValue;
				*(sp - 2) = oopValue;
				return sp - 2;
			}
			else
			{
				// Not a SmallInteger value to store - can still store some 4/8 byte objects though

				QuadsOTE* oteValue = reinterpret_cast<QuadsOTE*>(oopValue);
				uint32_t* valueFields = oteValue->m_location->m_fields;
				if (oteValue->isBytes())
				{
					size_t argSize = oteValue->bytesSize();

					// The primitive has traditionally been lenient and accepts any 4 byte object, or any 8 byte object
					// where the top 32-bits are zero. This is to allow positive argeIntegers in the interval [0x7FFFFFFF, 0xFFFFFFFF]
					// to be passed as the argument
					if (argSize == sizeof(uint32_t) || (argSize == sizeof(uint64_t) && valueFields[1] == 0))
					{
						*pBuf = valueFields[0];
						*(sp - 2) = oopValue;
						return sp - 2;
					}
				}

				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
			}
		}
		else
		{
			// Index is not within bounds
			return primitiveFailure(size < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
		}
	}
	else
	{
		// Index not a smallinteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

Oop* PRIMCALL Interpreter::primitiveIndirectUint32AtPut(Oop * const sp, primargcount_t argCount)
{
	AddressOTE* oteReceiver = reinterpret_cast<AddressOTE*>(*(sp - 2));
	Oop oopOffset = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		// When storing into a buffer through a pointer, any offset is allowed. Note that this is unsafe, just like manipulating memory
		// through pointers in C/C++.

		SmallInteger offset = ObjectMemoryIntegerValueOf(oopOffset);
		// Store into byte object
		Oop oopValue = *sp;
		uint32_t* pBuf = reinterpret_cast<uint32_t*>(static_cast<uint8_t*>(oteReceiver->m_location->m_pointer) + offset);
		if (ObjectMemoryIsIntegerObject(oopValue))
		{
			const uint32_t newValue = ObjectMemoryIntegerValueOf(oopValue);
			*pBuf = newValue;
			*(sp - 2) = oopValue;
			return sp - 2;
		}
		else
		{
			// Not a SmallInteger value to store - can still store some 4/8 byte objects though

			QuadsOTE* oteValue = reinterpret_cast<QuadsOTE*>(oopValue);
			uint32_t* valueFields = oteValue->m_location->m_fields;
			if (oteValue->isBytes())
			{
				size_t argSize = oteValue->bytesSize();

				// The primitive has traditionally been lenient and accepts any 4 byte object, or any 8 byte object
				// where the top 32-bits are zero. This is to allow positive argeIntegers in the interval [0x7FFFFFFF, 0xFFFFFFFF]
				// to be passed as the argument
				if (argSize == sizeof(uint32_t) || (argSize == sizeof(uint64_t) && valueFields[1] == 0))
				{
					*pBuf = valueFields[0];
					*(sp - 2) = oopValue;
					return sp - 2;
				}
			}

			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
		}
	}
	else
	{
		// Index not a smallinteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

Oop* PRIMCALL Interpreter::primitiveInt32AtPut(Oop * const sp, primargcount_t)
{
	BytesOTE* oteReceiver = reinterpret_cast<BytesOTE*>(*(sp - 2));
	Oop oopOffset = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		const ptrdiff_t size = oteReceiver->bytesSizeForUpdate();
		SmallInteger offset = ObjectMemoryIntegerValueOf(oopOffset);
		if (offset >= 0 && static_cast<ptrdiff_t>(offset + sizeof(int32_t)) <= size)
		{
			// Store into byte object
			Oop oopValue = *sp;
			int32_t* pBuf = reinterpret_cast<int32_t*>(oteReceiver->m_location->m_fields + offset);
			if (ObjectMemoryIsIntegerObject(oopValue))
			{
				const int32_t newValue = ObjectMemoryIntegerValueOf(oopValue);
				*pBuf = newValue;
				*(sp - 2) = oopValue;
				return sp - 2;
			}
			else
			{
				// Not a SmallInteger value to store - can still store 4-byte objects though

				QuadsOTE* oteValue = reinterpret_cast<QuadsOTE*>(oopValue);
				int32_t* pValue = reinterpret_cast<int32_t*>(oteValue->m_location->m_fields);
				if (oteValue->isBytes())
				{
					size_t argSize = oteValue->bytesSize();

					// The primitive has traditionally been lenient and accepts any 4 byte object 
					if (argSize == sizeof(int32_t))
					{
						*pBuf = *pValue;
						*(sp - 2) = oopValue;
						return sp - 2;
					}
				}

				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
			}
		}
		else
		{
			// Index is not within bounds
			return primitiveFailure(size < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
		}
	}
	else
	{
		// Index not a smallinteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

Oop* PRIMCALL Interpreter::primitiveIndirectInt32AtPut(Oop * const sp, primargcount_t argCount)
{
	AddressOTE* oteReceiver = reinterpret_cast<AddressOTE*>(*(sp - 2));
	Oop oopOffset = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		// When storing into a buffer through a pointer, any offset is allowed. Note that this is unsafe, just like manipulating memory
		// through pointers in C/C++.

		SmallInteger offset = ObjectMemoryIntegerValueOf(oopOffset);
		// Store into byte object
		Oop oopValue = *sp;
		int32_t* pBuf = reinterpret_cast<int32_t*>(static_cast<uint8_t*>(oteReceiver->m_location->m_pointer) + offset);
		if (ObjectMemoryIsIntegerObject(oopValue))
		{
			const int32_t newValue = ObjectMemoryIntegerValueOf(oopValue);
			*pBuf = newValue;
			*(sp - 2) = oopValue;
			return sp - 2;
		}
		else
		{
			// Not a SmallInteger value to store - can still store 4-byte objects though

			QuadsOTE* oteValue = reinterpret_cast<QuadsOTE*>(oopValue);
			int32_t* pValue = reinterpret_cast<int32_t*>(oteValue->m_location->m_fields);
			if (oteValue->isBytes())
			{
				size_t argSize = oteValue->bytesSize();

				// The primitive has traditionally been lenient and accepts any 4 byte object 
				if (argSize == sizeof(int32_t))
				{
					*pBuf = *pValue;
					*(sp - 2) = oopValue;
					return sp - 2;
				}
			}

			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
		}
	}
	else
	{
		// Index not a smallinteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Primitive templates

template <typename T, typename P> static Oop* PRIMCALL Interpreter::primitiveIndirectIntegerAtOffset(Oop* const sp, primargcount_t)
{
	Oop oopOffset = *sp;
	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		SmallInteger offset = ObjectMemoryIntegerValueOf(oopOffset);

		AddressOTE* oteReceiver = reinterpret_cast<AddressOTE*>(*(sp - 1));
		uint8_t* pBytes = static_cast<uint8_t*>(oteReceiver->m_location->m_pointer);

		T value = *reinterpret_cast<T*>(pBytes + offset);
		P()(sp - 1, value);
		return sp - 1;
	}
	else
	{
		// Index not a smallinteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

template <typename T, typename Store> Oop* PRIMCALL Interpreter::primitiveIntegerAtOffset(Oop* const sp, primargcount_t)
{
	Oop oopOffset = *sp;
	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		SmallInteger offset = ObjectMemoryIntegerValueOf(oopOffset);

		BytesOTE* oteReceiver = reinterpret_cast<BytesOTE*>(*(sp - 1));
		const size_t size = oteReceiver->bytesSize();

		if (offset >= 0 && static_cast<size_t>(offset) + sizeof(T) <= size)
		{
			T value = *reinterpret_cast<T*>(oteReceiver->m_location->m_fields + offset);
			Store()(sp - 1, value);
			return sp - 1;
		}
		else
		{
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

template <typename T, SmallInteger MinVal, SmallInteger MaxVal> Oop* PRIMCALL Interpreter::primitiveAtOffsetPutInteger(Oop* const sp, primargcount_t)
{
	BytesOTE* oteReceiver = reinterpret_cast<BytesOTE*>(*(sp - 2));
	Oop oopOffset = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		const ptrdiff_t size = oteReceiver->bytesSizeForUpdate();
		SmallInteger offset = ObjectMemoryIntegerValueOf(oopOffset);
		if (offset >= 0 && offset + static_cast<ptrdiff_t>(sizeof(T)) <= size)
		{
			// Store into byte object
			Oop oopValue = *sp;
			T* pBuf = reinterpret_cast<T*>(oteReceiver->m_location->m_fields + offset);
			if (ObjectMemoryIsIntegerObject(oopValue))
			{
				SmallInteger newValue = ObjectMemoryIntegerValueOf(oopValue);
				if (newValue >= MinVal && newValue <= MaxVal)
				{
					*pBuf = newValue;
					*(sp - 2) = oopValue;
					return sp - 2;
				}
				else
				{
					return primitiveFailure(_PrimitiveFailureCode::IntegerOutOfRange);
				}
			}
			else
			{
				// Value is not a SmallInteger
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
			}
		}
		else
		{
			// Index is not within bounds
			return primitiveFailure(size < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
		}
	}
	else
	{
		// Index not a smallinteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

template <typename T, SmallInteger MinVal, SmallInteger MaxVal> Oop* PRIMCALL Interpreter::primitiveIndirectAtOffsetPutInteger(Oop* const sp, primargcount_t)
{
	AddressOTE* oteReceiver = reinterpret_cast<AddressOTE*>(*(sp - 2));
	Oop oopOffset = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		const ptrdiff_t size = oteReceiver->bytesSizeForUpdate();
		SmallInteger offset = ObjectMemoryIntegerValueOf(oopOffset);
		// Store into byte object
		Oop oopValue = *sp;
		T* pBuf = reinterpret_cast<T*>(static_cast<uint8_t*>(oteReceiver->m_location->m_pointer) + offset);
		if (ObjectMemoryIsIntegerObject(oopValue))
		{
			SmallInteger newValue = ObjectMemoryIntegerValueOf(oopValue);
			if (newValue >= MinVal && newValue <= MaxVal)
			{
				*pBuf = newValue;
				*(sp - 2) = oopValue;
				return sp - 2;
			}
			else
			{
				return primitiveFailure(_PrimitiveFailureCode::IntegerOutOfRange);
			}
		}
		else
		{
			// Value is not a SmallInteger
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
		}
	}
	else
	{
		// Index not a smallinteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

template Oop* PRIMCALL Interpreter::primitiveIntegerAtOffset<uint32_t, StoreUnsigned32>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIntegerAtOffset<int32_t, StoreSigned32>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIntegerAtOffset<uint16_t, StoreSmallInteger>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveAtOffsetPutInteger<uint16_t, 0x0, 0xffff>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIntegerAtOffset<int16_t, StoreSmallInteger>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveAtOffsetPutInteger<uint16_t, -0x8000, 0x7fff>(Oop* const, primargcount_t);

template Oop* PRIMCALL Interpreter::primitiveIntegerAtOffset<uintptr_t, StoreUIntPtr>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIntegerAtOffset<intptr_t, StoreIntPtr>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIndirectIntegerAtOffset<uintptr_t, StoreUIntPtr>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIndirectIntegerAtOffset<intptr_t, StoreIntPtr>(Oop* const, primargcount_t);

template Oop* PRIMCALL Interpreter::primitiveIndirectIntegerAtOffset<uint8_t, StoreSmallInteger>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIndirectAtOffsetPutInteger<uint8_t, 0, 255>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIndirectIntegerAtOffset<uint32_t, StoreUnsigned32>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIndirectIntegerAtOffset<int32_t, StoreSigned32>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIndirectIntegerAtOffset<uint16_t, StoreSmallInteger>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIndirectAtOffsetPutInteger<uint16_t, 0, 0xffff>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIndirectIntegerAtOffset<int16_t, StoreSmallInteger>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIndirectAtOffsetPutInteger<int16_t, -0x8000, 0x7fff>(Oop* const, primargcount_t);

template Oop* PRIMCALL Interpreter::primitiveIntegerAtOffset<uint64_t, StoreUnsigned64>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIntegerAtOffset<int64_t, StoreSigned64>(Oop* const, primargcount_t);

///////////////////////////////////////////////////////////////////////////////
// Primitives for external buffer manipulation of floats/doubles
//
// The receivers of these primitives must be byte objects, else they will fail
// Note also that they work off the byte offset (zero based), rather than being
// 1 based like the Smalltalk #at:/#at:put: primitives.
//
// Remember, Smalltalk floats are double precision
// Single and Double precision versions of the accessor primitives are exactly
// the same, except that a different cast is used
//
// Unlike some other accessor primitives, these also work for indirection objects
// (e.g. ExternalAddress).
//

template <typename T> Oop* PRIMCALL Interpreter::primitiveFloatAtOffsetPut(Oop* const sp, primargcount_t)
{
	Oop integerPointer = *(sp - 1);
	if (ObjectMemoryIsIntegerObject(integerPointer))
	{
		double fValue;
		Oop valuePointer = *sp;
		if (ObjectMemoryIsIntegerObject(valuePointer))
		{
			fValue = ObjectMemoryIntegerValueOf(valuePointer);
		}
		else
		{
			if (ObjectMemory::fetchClassOf(valuePointer) != Pointers.ClassFloat)
			{
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
			}
			FloatOTE* oteValue = reinterpret_cast<FloatOTE*>(valuePointer);
			fValue = oteValue->m_location->m_fValue;
		}

		SmallInteger offset = ObjectMemoryIntegerValueOf(integerPointer);

		OTE* receiver = reinterpret_cast<OTE*>(*(sp - 2));
		ASSERT(!ObjectMemoryIsIntegerObject(receiver));
		ASSERT(receiver->isBytes());

		// All entry conditions passed, proceed to copy floating point value into buffer

		Behavior* behavior = receiver->m_oteClass->m_location;
		if (behavior->isIndirect())
		{
			T* pBuf = reinterpret_cast<T*>(static_cast<uint8_t*>(reinterpret_cast<AddressOTE*>(receiver)->m_location->m_pointer) + offset);
			*pBuf = static_cast<T>(fValue);
			*(sp - 2) = valuePointer;
			return sp - 2;
		}
		else
		{
			BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(receiver);

			// We can check that the offset is in bounds
			ptrdiff_t size = oteBytes->bytesSizeForUpdate();
			if (offset >= 0 && offset + static_cast<ptrdiff_t>(sizeof(T)) <= size)
			{
				T* pBuf = reinterpret_cast<T*>(oteBytes->m_location->m_fields + offset);
				*pBuf = static_cast<T>(fValue);
				*(sp - 2) = valuePointer;
				return sp - 2;
			}
			else
			{
				return primitiveFailure(size < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
			}
		}
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Offset not a SmallInteger
	}
}

template <typename T> Oop* PRIMCALL Interpreter::primitiveFloatAtOffset(Oop* const sp, primargcount_t)
{
	Oop integerPointer = *sp;
	if (ObjectMemoryIsIntegerObject(integerPointer))
	{
		SmallInteger offset = ObjectMemoryIntegerValueOf(integerPointer);
		OTE* receiver = reinterpret_cast<OTE*>(*(sp - 1));

		ASSERT(!ObjectMemoryIsIntegerObject(receiver));
		ASSERT(receiver->isBytes());

		T* pValue;
		Behavior* behavior = receiver->m_oteClass->m_location;
		if (behavior->isIndirect())
		{
			pValue = reinterpret_cast<T*>(static_cast<uint8_t*>(static_cast<ExternalAddress*>(receiver->m_location)->m_pointer) + offset);
		}
		else
		{
			BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(receiver);

			// We can check that the offset is in bounds
			if (offset >= 0 && static_cast<size_t>(offset) + sizeof(T) <= oteBytes->bytesSize())
			{
				pValue = reinterpret_cast<T*>(oteBytes->m_location->m_fields + offset);
			}
			else
			{
				return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Out of bounds
			}
		}

		FloatOTE* oteResult = Float::New(*pValue);
		*(sp - 1) = reinterpret_cast<Oop>(oteResult);
		ObjectMemory::AddToZct((OTE*)oteResult);
		return sp - 1;
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Index not an integer
	}
}

template Oop* PRIMCALL Interpreter::primitiveFloatAtOffset<double>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatAtOffsetPut<double>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatAtOffset<float>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatAtOffsetPut<float>(Oop* const, primargcount_t);
