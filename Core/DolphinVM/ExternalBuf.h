#include "Interprt.h"
#pragma once

///////////////////////////////////////////////////////////////////////////////
// Functors for instantiating primitive templates

struct StoreSmallInteger
{
	__forceinline constexpr void operator()(Oop* const sp, SMALLINTEGER value)
	{
		*sp = ObjectMemoryIntegerObjectOf(value);
	}
};

struct StoreUIntPtr
{
	__forceinline void operator()(Oop* const sp, uintptr_t ptr)
	{
		if (ObjectMemoryIsPositiveIntegerValue(ptr))
		{
			*sp = ObjectMemoryIntegerObjectOf(ptr);
		}
		else
		{
			LargeIntegerOTE* oteLi = LargeInteger::liNewUnsigned(ptr);
			*sp = reinterpret_cast<Oop>(oteLi);
			ObjectMemory::AddToZct((OTE*)oteLi);
		}
	}
};

struct StoreSigned32
{
	__forceinline void operator()(Oop* const sp, int32_t dwValue)
	{
		if (ObjectMemoryIsIntegerValue(dwValue))
		{
			*sp = ObjectMemoryIntegerObjectOf(dwValue);
		}
		else
		{
			LargeIntegerOTE* oteLi = LargeInteger::liNewSigned(dwValue);
			*sp = reinterpret_cast<Oop>(oteLi);
			ObjectMemory::AddToZct((OTE*)oteLi);
		}
	}
};

struct StoreIntPtr
{
	__forceinline void operator()(Oop* const sp, intptr_t ptr)
	{
		if (ObjectMemoryIsIntegerValue(ptr))
		{
			*sp = ObjectMemoryIntegerObjectOf(ptr);
		}
		else
		{
			LargeIntegerOTE* oteLi = LargeInteger::liNewSigned(ptr);
			*sp = reinterpret_cast<Oop>(oteLi);
			ObjectMemory::AddToZct((OTE*)oteLi);
		}
	}
};

struct StoreUnsigned64
{
	__forceinline void operator()(Oop* const sp, uint64_t dwValue)
	{
		Oop result = LargeInteger::NewUnsigned64(dwValue);
		*sp = result;
		ObjectMemory::AddToZct(result);
	}
};

struct StoreSigned64
{
	__forceinline void operator()(Oop* const sp, uint64_t dwValue)
	{
		Oop result = LargeInteger::NewSigned64(dwValue);
		*sp = result;
		ObjectMemory::AddToZct(result);
	}
};

///////////////////////////////////////////////////////////////////////////////
// Primitive templates

template <typename T, typename P> static Oop* __fastcall Interpreter::primitiveIndirectIntegerAtOffset(Oop* const sp, unsigned)
{
	Oop oopOffset = *sp;
	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		SMALLINTEGER offset = ObjectMemoryIntegerValueOf(oopOffset);

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

template <typename T, typename Store> Oop* __fastcall Interpreter::primitiveIntegerAtOffset(Oop* const sp, unsigned)
{
	Oop oopOffset = *sp;
	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		SMALLINTEGER offset = ObjectMemoryIntegerValueOf(oopOffset);

		BytesOTE* oteReceiver = reinterpret_cast<BytesOTE*>(*(sp - 1));
		const int size = oteReceiver->bytesSize();

		if (offset >= 0 && static_cast<int>(offset + sizeof(T)) <= size)
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
template <typename T, SMALLINTEGER MinVal, SMALLINTEGER MaxVal> Oop* __fastcall Interpreter::primitiveAtOffsetPutInteger(Oop* const sp, unsigned)
{
	BytesOTE* oteReceiver = reinterpret_cast<BytesOTE*>(*(sp - 2));
	Oop oopOffset = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		const int size = oteReceiver->bytesSizeForUpdate();
		SMALLINTEGER offset = ObjectMemoryIntegerValueOf(oopOffset);
		if (offset >= 0 && static_cast<int>(offset + sizeof(T)) <= size)
		{
			// Store into byte object
			Oop oopValue = *sp;
			T* pBuf = reinterpret_cast<T*>(oteReceiver->m_location->m_fields + offset);
			if (ObjectMemoryIsIntegerObject(oopValue))
			{
				SMALLINTEGER newValue = ObjectMemoryIntegerValueOf(oopValue);
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

template <typename T, SMALLINTEGER MinVal, SMALLINTEGER MaxVal> Oop* __fastcall Interpreter::primitiveIndirectAtOffsetPutInteger(Oop* const sp, unsigned)
{
	AddressOTE* oteReceiver = reinterpret_cast<AddressOTE*>(*(sp - 2));
	Oop oopOffset = *(sp - 1);

	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		const int size = oteReceiver->bytesSizeForUpdate();
		SMALLINTEGER offset = ObjectMemoryIntegerValueOf(oopOffset);
		// Store into byte object
		Oop oopValue = *sp;
		T* pBuf = reinterpret_cast<T*>(static_cast<uint8_t*>(oteReceiver->m_location->m_pointer) + offset);
		if (ObjectMemoryIsIntegerObject(oopValue))
		{
			SMALLINTEGER newValue = ObjectMemoryIntegerValueOf(oopValue);
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

template <typename T> Oop* __fastcall Interpreter::primitiveFloatAtOffsetPut(Oop* const sp, unsigned)
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

		SMALLUNSIGNED offset = ObjectMemoryIntegerValueOf(integerPointer);

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
			int size = oteBytes->bytesSizeForUpdate();
			if (static_cast<int>(offset) >= 0 && static_cast<int>(offset + sizeof(T)) <= size)
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

template <typename T> Oop* __fastcall Interpreter::primitiveFloatAtOffset(Oop* const sp, unsigned)
{
	Oop integerPointer = *sp;
	if (ObjectMemoryIsIntegerObject(integerPointer))
	{
		SMALLINTEGER offset = ObjectMemoryIntegerValueOf(integerPointer);
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
			if (offset >= 0 && offset + sizeof(T) <= oteBytes->bytesSize())
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

