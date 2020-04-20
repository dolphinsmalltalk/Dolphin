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

Oop * __fastcall Interpreter::primitiveAddressOf(Oop * const sp, primargcount_t argCount)
{
	StoreUIntPtr()(sp, reinterpret_cast<uintptr_t>(reinterpret_cast<OTE*>(*sp)->m_location));
	return sp;
}

Oop * __fastcall Interpreter::primitiveBytesIsNull(Oop * const sp, primargcount_t argCount)
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

Oop * __fastcall Interpreter::primitiveStructureIsNull(Oop * const sp, primargcount_t argCount)
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

Oop * __fastcall Interpreter::primitiveUint32AtPut(Oop * const sp, primargcount_t argCount)
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

Oop * __fastcall Interpreter::primitiveIndirectUint32AtPut(Oop * const sp, primargcount_t argCount)
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

Oop * __fastcall Interpreter::primitiveInt32AtPut(Oop * const sp, primargcount_t)
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

Oop * __fastcall Interpreter::primitiveIndirectInt32AtPut(Oop * const sp, primargcount_t argCount)
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

