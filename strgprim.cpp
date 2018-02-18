/******************************************************************************

	File: StrgPrim.cpp

	Description:

	Implementation of the Interpreter class' String (variable
	byte object) primitive methods

******************************************************************************/
#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include <string.h>
#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

// Smalltalk classes
#include "STBehavior.h"
#include "STExternal.h"		// For ExternalAddress
#include "STByteArray.h"
#include "STCharacter.h"

///////////////////////////////////////////////////////////////////////////////
//	String Primitives

void Interpreter::memmove(BYTE* dst, const BYTE* src, size_t count)
{
    if (dst <= src || dst >= src + count) 
		memcpy(dst, src, count);
    else 
	{
        /*
         * Overlapping Buffers
         * copy from higher addresses to lower addresses
         */
        dst = dst + count - 1;
        src = src + count - 1;

        while (count) 
		{
            *dst = *src;
            dst--;
            src--;
			count--;
        }
    }
}

//	This is a double dispatched primitive which knows that the argument is a byte object (though
//	we still check this to avoid GPFs), and the receiver is guaranteed to be a byte object. e.g.
//
//		aByteObject replaceBytesOf: anOtherByteObject from: start to: stop startingAt: startAt
//
Oop* __fastcall Interpreter::primitiveReplaceBytes(Oop* const sp)
{
	Oop integerPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(0);	// startAt is not an integer
	SMALLINTEGER startAt = ObjectMemoryIntegerValueOf(integerPointer);

	integerPointer = *(sp - 1);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(1);	// stop is not an integer
	SMALLINTEGER stop = ObjectMemoryIntegerValueOf(integerPointer);

	integerPointer = *(sp - 2);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(2);	// start is not an integer
	SMALLINTEGER start = ObjectMemoryIntegerValueOf(integerPointer);

	OTE* argPointer = reinterpret_cast<OTE*>(*(sp - 3));
	if (ObjectMemoryIsIntegerObject(argPointer) || !argPointer->isBytes())
		return primitiveFailure(3);	// Argument MUST be a byte object

	// Empty move if stop before start, is considered valid regardless (strange but true)
	// this is the convention adopted by most implementations.
	if (stop >= start)
	{
		if (startAt < 1 || start < 1)
			return primitiveFailure(4);		// Out-of-bounds

		// We still permit the argument to be an address to cut down on the number of primitives
		// and double dispatch methods we must implement (2 rather than 4)
		BYTE* pTo;

		Behavior* behavior = argPointer->m_oteClass->m_location;
		if (behavior->isIndirect())
		{
			AddressOTE* oteBytes = reinterpret_cast<AddressOTE*>(argPointer);
			// We don't know how big the object is the argument points at, so cannot check length
			// against stop point
			pTo = static_cast<BYTE*>(oteBytes->m_location->m_pointer);
		}
		else
		{
			// We can test that we're not going to write off the end of the argument
			int length = argPointer->bytesSizeForUpdate();

			// We can only be in here if stop>=start, so => stop-start >= 0
			// therefore if startAt >= 1 then => stopAt >= 1, for similar
			// reasons (since stopAt >= startAt) we don't need to test 
			// that startAt <= length
			if (stop > length)
				return primitiveFailure(4);		// Bounds error (or object is immutable so size < 0)

			VariantByteObject* argBytes = reinterpret_cast<BytesOTE*>(argPointer)->m_location;
			pTo = argBytes->m_fields;
		}

		BytesOTE* receiverPointer = reinterpret_cast<BytesOTE*>(*(sp - 4));

		// Now validate that the interval specified for copying from the receiver
		// is within the bounds of the receiver (we've already tested startAt)
		{
			int length = receiverPointer->bytesSize();
			// We can only be in here if stop>=start, so if start>=1, then => stop >= 1
			// furthermore if stop <= length then => start <= length
			int stopAt = startAt+stop-start;
			if (stopAt > length)
				return primitiveFailure(4);
		}

		// Only works for byte objects
		ASSERT(receiverPointer->isBytes());
		VariantByteObject* receiverBytes = receiverPointer->m_location;

		BYTE* pFrom = receiverBytes->m_fields;

		memmove(pTo+start-1, pFrom+startAt-1, stop-start+1);
	}

	// Answers the argument by moving it down over the receiver
	*(sp - 4) = reinterpret_cast<Oop>(argPointer);
	return sp - 4;
}


//	This is a double dispatched primitive which knows that the argument is a byte object (though
//	we still check this to avoid GPFs), and the receiver is guaranteed to be an address object. e.g.
//
//		anExternalAddress replaceBytesOf: anOtherByteObject from: start to: stop startingAt: startAt
//
Oop* __fastcall Interpreter::primitiveIndirectReplaceBytes(Oop* const sp)
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

	OTE* argPointer = reinterpret_cast<OTE*>(*(sp-3));
	if (ObjectMemoryIsIntegerObject(argPointer) || !argPointer->isBytes())
		return primitiveFailure(3);	// Argument MUST be a byte object

	// Empty move if stop before start, is considered valid regardless (strange but true)
	if (stop >= start)
	{
		if (start < 1 || startAt < 1)
			return primitiveFailure(4);		// out-of-bounds

		AddressOTE* receiverPointer = reinterpret_cast<AddressOTE*>(*(sp-4));
		// Only works for byte objects
		ASSERT(receiverPointer->isBytes());
		ExternalAddress* receiverBytes = receiverPointer->m_location;
		#ifdef _DEBUG
		{
			Behavior* behavior = receiverPointer->m_oteClass->m_location;
			ASSERT(behavior->isIndirect());
		}
		#endif

		// Because the receiver is an address, we do not know the size of the object
		// it points at, and so cannot perform any bounds checks - BEWARE
		BYTE* pFrom = static_cast<BYTE*>(receiverBytes->m_pointer);

		// We still permit the argument to be an address to cut down on the double dispatching
		// required.
		BYTE* pTo;
		Behavior* behavior = argPointer->m_oteClass->m_location;
		if (behavior->isIndirect())
		{
			AddressOTE* oteBytes = reinterpret_cast<AddressOTE*>(argPointer);
			// Cannot check length 
			pTo = static_cast<BYTE*>(oteBytes->m_location->m_pointer);
		}
		else
		{
			// Can check that not writing off the end of the argument
			int length = argPointer->bytesSize();
			// We can only be in here if stop>=start, so => stop-start >= 0
			// therefore if startAt >= 1 then => stopAt >= 1, for similar
			// reasons (since stopAt >= startAt) we don't need to test 
			// that startAt <= length
			if (stop > length)
				return primitiveFailure(4);		// Bounds error

			VariantByteObject* argBytes = reinterpret_cast<BytesOTE*>(argPointer)->m_location;
			pTo = argBytes->m_fields;
		}

		memmove(pTo+start-1, pFrom+startAt-1, stop-start+1);
	}
	// Answers the argument by moving it down over the receiver
	*(sp-4) = reinterpret_cast<Oop>(argPointer);
	return sp-4;
}

// Locate the next occurrence of the given character in the receiver between the specified indices.
Oop* __fastcall Interpreter::primitiveStringNextIndexOfFromTo(Oop* const sp)
{
	Oop integerPointer = *sp;
	if (ObjectMemoryIsIntegerObject(integerPointer))
	{
		const SMALLINTEGER to = ObjectMemoryIntegerValueOf(integerPointer);

		integerPointer = *(sp - 1);
		if (ObjectMemoryIsIntegerObject(integerPointer))
		{
			SMALLINTEGER from = ObjectMemoryIntegerValueOf(integerPointer);

			Oop valuePointer = *(sp - 2);

			StringOTE* receiverPointer = reinterpret_cast<StringOTE*>(*(sp - 3));

			Oop answer = ZeroPointer;
			// If not a character, or the search interval is empty, we treat as not found
			if ((ObjectMemory::fetchClassOf(valuePointer) == Pointers.ClassCharacter) && to >= from)
			{
				ASSERT(!receiverPointer->isPointers());

				// Search a byte object

				const SMALLINTEGER length = receiverPointer->bytesSize();
				// We can only be in here if to>=from, so if to>=1, then => from >= 1
				// furthermore if to <= length then => from <= length
				if (from >= 1 && to <= length)
				{
					// Search is in bounds, lets do it
					CharOTE* oteChar = reinterpret_cast<CharOTE*>(valuePointer);
					Character* charObj = oteChar->m_location;
					MWORD codePoint = ObjectMemoryIntegerValueOf(charObj->m_codePoint);
					// If not a byte char, can't possibly be in a byte string (treat as not found, rather than primitive failure)
					if (codePoint <= 255)
					{
						const char charValue = static_cast<char>(codePoint);

						String* chars = receiverPointer->m_location;

						from--;
						while (from < to)
						{
							if (chars->m_characters[from++] == charValue)
							{
								answer = ObjectMemoryIntegerObjectOf(from);
								break;
							}
						}
					}
				}
				else
				{
					// To/from out of bounds
					return primitiveFailure(2);
				}
			}

			*(sp - 3) = answer;
			return sp - 3;
		}
		else
		{
			return primitiveFailure(1);				// from not an integer
		}
	}
	else
	{
		return primitiveFailure(0);				// to not an integer
	}
}

Oop* __fastcall Interpreter::primitiveStringAt(Oop* sp)
{
	int index = *sp;
	if (ObjectMemoryIsIntegerObject(index))
	{
		index = ObjectMemoryIntegerValueOf(index);
		const StringOTE* oteReceiver = reinterpret_cast<const StringOTE*>(*(sp - 1));
		if (index > 0 && (MWORD)index <= (oteReceiver->m_size & OTE::SizeMask))
		{
			const char* const psz = oteReceiver->m_location->m_characters;
			CharOTE* oteResult = ST::Character::New(static_cast<unsigned char>(psz[index - 1]));
			*(sp - 1) = reinterpret_cast<Oop>(oteResult);
			return sp - 1;
		}
		else
		{
			// Index out of range
			return primitiveFailure(1);
		}
	}

	// Index argument not a SmallInteger
	return primitiveFailure(0);
}

Oop* __fastcall Interpreter::primitiveStringAtPut(Oop* sp)
{
	StringOTE* __restrict oteReceiver = reinterpret_cast<StringOTE*>(*(sp - 2));
	int index = *(sp - 1);
	char* const __restrict psz = oteReceiver->m_location->m_characters;
	if (ObjectMemoryIsIntegerObject(index))
	{
		index = ObjectMemoryIntegerValueOf(index);
		int receiverSize = oteReceiver->m_size;
		// Note that we don't mask off the immutability bit, so if receiver immutable, size will be < 0, and the condition will be false
		if (index > 0 && index <= receiverSize)
		{
			const Oop oopValue = *sp;
			if (!ObjectMemoryIsIntegerObject(oopValue) && reinterpret_cast<const OTE*>(oopValue)->m_oteClass == Pointers.ClassCharacter)
			{
				MWORD codePoint = ObjectMemoryIntegerValueOf(reinterpret_cast<const CharOTE*>(oopValue)->m_location->m_codePoint);
				if (codePoint <= 255)
				{
					psz[index - 1] = codePoint;
					*(sp - 2) = *sp;
					return sp - 2;
				}
			}

			// Value is not a byte character
			return primitiveFailure(2);
		}
		else
		{
			// Index out of range or immutable
			return primitiveFailure(1);
		}
	}
	else
	{
		// Index argument not a SmallInteger
		return primitiveFailure(0);
	}
}

template <class Op> __forceinline static Oop* primitiveStringComparisonOp(Oop* const sp, Op& op)
{
	Oop oopArg = *sp;
	StringOTE* oteReceiver = reinterpret_cast<StringOTE*>(*(sp - 1));
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		StringOTE* oteArg = reinterpret_cast<StringOTE*>(oopArg);
		char* szReceiver = oteReceiver->m_location->m_characters;
		char* szArg = oteArg->m_location->m_characters;
		if (oteArg != oteReceiver)
		{
			if (oteArg->isNullTerminated())
			{
				int result = op(szReceiver, szArg);
				*(sp - 1) = ObjectMemoryIntegerObjectOf(result);
				return sp - 1;
			}
			else
			{
				// Arg not a null terminated byte object
				return Interpreter::primitiveFailure(1);
			}
		}
		else
		{
			// Identical
			*(sp - 1) = ZeroPointer;
			return sp - 1;
		}
	}
	else
	{
		// Arg is a SmallInteger
		return Interpreter::primitiveFailure(0);
	}
}

Oop* __fastcall Interpreter::primitiveStringCollate(Oop* sp)
{
	struct op {
		int operator() (const char*a, const char* b) const { return lstrcmpi(a, b); }
	};

	return primitiveStringComparisonOp(sp, op());
}

Oop* __fastcall Interpreter::primitiveStringCmp(Oop* sp)
{
	struct op {
		int operator() (const char*a, const char* b) const { return lstrcmp(a, b); }
	};

	return primitiveStringComparisonOp(sp, op());
}

Oop* Interpreter::primitiveBytesEqual(Oop* const sp)
{
	Oop oopArg = *sp;
	BytesOTE* oteReceiver = reinterpret_cast<BytesOTE*>(*(sp - 1));
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		BytesOTE* oteArg = reinterpret_cast<BytesOTE*>(oopArg);
		if (oteArg != oteReceiver)
		{
			if (oteArg->m_oteClass == oteReceiver->m_oteClass)
			{
				ASSERT(oteArg->isBytes());
				MWORD argSize = oteArg->bytesSize();
				Oop answer = reinterpret_cast<Oop>(Pointers.False);
				if (argSize == oteReceiver->bytesSize())
				{
					BYTE* pbReceiver = oteReceiver->m_location->m_fields;
					BYTE* pbArg = oteArg->m_location->m_fields;
					if (memcmp(pbReceiver, pbArg, argSize) == 0)
						answer = reinterpret_cast<Oop>(Pointers.True);
				}

				*(sp - 1) = answer;
				return sp - 1;
			}
			else
			{
				// Arg not same type
				return Interpreter::primitiveFailure(1);
			}
		}
		else
		{
			// Identical
			*(sp - 1) = reinterpret_cast<Oop>(Pointers.True);
			return sp - 1;
		}
	}
	else
	{
		// Arg is a SmallInteger
		return Interpreter::primitiveFailure(0);
	}
}

inline MWORD __fastcall hashBytes(const BYTE* bytes, MWORD size)
{
	MWORD hash = 0;
	while(size > 0)
	{
		hash = (hash << 4) + *bytes;
		MWORD topNibble = hash & 0xf0000000;
		if (topNibble)
		{
			hash = (hash & 0x0fffffff) ^ (topNibble >> 24);
		}
		bytes++;
		size--;
	}
	return hash;
}

extern "C" MWORD __cdecl HashBytes(const BYTE* bytes, MWORD size)
{
	return bytes != nullptr ? hashBytes(bytes, size) : 0;
}

Oop* __fastcall Interpreter::primitiveHashBytes(Oop* const sp)
{
	BytesOTE* receiver = reinterpret_cast<BytesOTE*>(*sp);
	MWORD hash = hashBytes(receiver->m_location->m_fields, receiver->bytesSize());
	*sp = ObjectMemoryIntegerObjectOf(hash);
	return sp;
}

Oop* __fastcall Interpreter::primitiveStringAsUtf16String(Oop* const sp)
{
	StringOTE* receiver = reinterpret_cast<StringOTE*>(*sp);
	Utf16StringOTE* answer = Utf16String::New(receiver);
	if ((Oop)answer != (Oop)receiver)
	{
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
	}
	return sp;
}

Utf16StringOTE* __fastcall ST::Utf16String::New(StringOTE* oteString)
{
	ASSERT(oteString->isNullTerminated());

	if (oteString->m_oteClass == Pointers.ClassUtf8String)
	{
		return Utf16String::New<CP_UTF8>(oteString->m_location->m_characters, oteString->getSize());
	}
	else if (oteString->m_oteClass != Pointers.ClassUtf16String)
	{
		// Assume some kind of ANSI string
		return Utf16String::New<CP_ACP>(oteString->m_location->m_characters, oteString->getSize());
	}

	return reinterpret_cast<Utf16StringOTE*>(oteString);
}

Oop * Interpreter::primitiveStringAsUtf8String(Oop * const sp)
{
	OTE* receiver = reinterpret_cast<OTE*>(*sp);
	BehaviorOTE* oteClass = receiver->m_oteClass;
	if (oteClass == Pointers.ClassUtf16String)
	{
		Utf8StringOTE* answer = Utf8String::New(reinterpret_cast<Utf16StringOTE*>(receiver)->m_location->m_characters);
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
	}
	else if (oteClass != Pointers.ClassUtf8String)
	{
		// Assume some kind of Ansi string
		Utf8StringOTE* answer = Utf8String::NewFromAnsi(reinterpret_cast<StringOTE*>(receiver)->m_location->m_characters, receiver->getSize());
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
	}

	return sp;
}

Oop* __fastcall Interpreter::primitiveStringAsAnsiString(Oop* const sp)
{
	OTE* receiver = reinterpret_cast<OTE*>(*sp);
	BehaviorOTE* oteClass = receiver->m_oteClass;
	if (oteClass == Pointers.ClassUtf8String)
	{
		StringOTE* answer = String::NewFromUtf8(reinterpret_cast<Utf8StringOTE*>(receiver)->m_location->m_characters, receiver->getSize());
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
	}
	else if (oteClass == Pointers.ClassUtf16String)
	{
		StringOTE* answer = String::New(reinterpret_cast<Utf16StringOTE*>(receiver)->m_location->m_characters, receiver->getSize()/sizeof(WCHAR));
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
	}

	return sp;
}

Utf16StringOTE* Utf16String::New(LPCWSTR value)
{
	const unsigned byteLen = wcslen(value) * sizeof(WCHAR);
	Utf16StringOTE* stringPointer = reinterpret_cast<Utf16StringOTE*>(ObjectMemory::newUninitializedNullTermObject(Pointers.ClassUtf16String, byteLen));
	Utf16String* __restrict string = stringPointer->m_location;
	memcpy(string->m_characters, value, byteLen + 2);
	return stringPointer;
}

Utf16StringOTE* __fastcall Utf16String::New(const WCHAR* value, size_t len)
{
	const unsigned byteLen = len * sizeof(WCHAR);
	Utf16StringOTE* stringPointer = reinterpret_cast<Utf16StringOTE*>(ObjectMemory::newUninitializedNullTermObject(Pointers.ClassUtf16String, byteLen));
	Utf16String* string = stringPointer->m_location;
	string->m_characters[len] = L'\0';
	memcpy(string->m_characters, value, byteLen);
	return stringPointer;
}

//Utf16StringOTE * ST::Utf16String::New(LPCSTR sz, UINT cp)
//{
//	int len = ::MultiByteToWideChar(cp, 0, sz, -1, nullptr, 0);
//	// Length includes null terminator since input is null terminated
//	Utf16StringOTE* stringPointer = reinterpret_cast<Utf16StringOTE*>(ObjectMemory::newUninitializedNullTermObject(Pointers.ClassUtf16String, (len - 1) * sizeof(WCHAR)));
//	Utf16String* __restrict string = stringPointer->m_location;
//	int nCopied = ::MultiByteToWideChar(cp, 0, sz, -1, string->m_characters, len);
//	UNREFERENCED_PARAMETER(nCopied);
//	ASSERT(nCopied == len);
//	return stringPointer;
//}

template <UINT CP> Utf16StringOTE * ST::Utf16String::New(const char* pChars, size_t len)
{
	// A UTF16 encoded string can never require more code units than a byte encoding (though it will usually require more bytes)
	Utf16StringOTE* stringPointer = reinterpret_cast<Utf16StringOTE*>(ObjectMemory::newUninitializedNullTermObject(Pointers.ClassUtf16String, len * sizeof(WCHAR)));
	int actualLen = ::MultiByteToWideChar(CP, 0, pChars, len, stringPointer->m_location->m_characters, len);
	if (actualLen != len)
	{
		ObjectMemory::basicResize<sizeof(WCHAR)>((OTE*)stringPointer, actualLen * sizeof(WCHAR));
	}
	stringPointer->m_location->m_characters[actualLen] = L'\0';
	return stringPointer;
}

Utf8StringOTE* ST::Utf8String::NewFromAnsi(const char* pChars, size_t len)
{
	// There is no Windows API for direct conversion from ANSI<->UTF8, so we need to convert to UTF16 first
	Utf16StringOTE* utf16 = Utf16String::New<CP_ACP>(pChars, len);
	Utf8StringOTE* result = Utf8String::New(utf16->m_location->m_characters, utf16->getSize() / sizeof(WCHAR));
	// Discard the temp Utf16String object
	ObjectMemory::deallocateByteObject((OTE*)utf16);
	return result;
}

StringOTE* ST::String::NewFromUtf8(const char* pChars, size_t ansiLen)
{
	Utf16StringOTE* utf16 = Utf16String::New<CP_UTF8>(pChars, ansiLen);
	StringOTE* result = String::New(utf16->m_location->m_characters, utf16->getSize() / sizeof(WCHAR));
	ObjectMemory::deallocateByteObject((OTE*)utf16);
	return result;
}