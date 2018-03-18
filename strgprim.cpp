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

#include "Utf16StringBuf.h"

WCHAR Interpreter::m_ansiToUnicodeCharMap[256];
CHAR Interpreter::m_unicodeToAnsiCharMap[65536];

#pragma comment(lib, "icuuc.lib")

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

			// TODO: Support other encodings

			ByteStringOTE* receiverPointer = reinterpret_cast<ByteStringOTE*>(*(sp - 3));

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
					// If not a byte char, can't possibly be in a byte string (treat as not found, rather than primitive failure)
					if (charObj->Encoding == StringEncoding::Ansi)
					{
						const ByteString::CU charValue = static_cast<ByteString::CU>(charObj->CodeUnit);

						ByteString* chars = receiverPointer->m_location;

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

Oop* __fastcall Interpreter::primitiveStringAt(Oop* const sp, const unsigned argCount)
{
	Oop* newSp = sp - argCount;
	SMALLINTEGER oopIndex = *(newSp + 1);
	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		int index = ObjectMemoryIntegerValueOf(oopIndex);
		ByteStringOTE* oteReceiver = reinterpret_cast<ByteStringOTE*>(*newSp);
		switch (String::GetEncoding(oteReceiver))
		{
		case StringEncoding::Utf8:
		{
			if (index > 0 && (MWORD)index <= oteReceiver->bytesSize())
			{
				Utf8String::CU codeUnit = reinterpret_cast<Utf8String*>(oteReceiver->m_location)->m_characters[index - 1];
				// Will push an ANSI encoded Character if we can, else a Utf8 surrogate
				if (U8_IS_SINGLE(codeUnit))
				{
					CharOTE* oteResult = ST::Character::NewAnsi(static_cast<ByteString::CU>(codeUnit));
					*newSp = reinterpret_cast<Oop>(oteResult);
				}
				else
				{
					// Otherwise return a UTF-8 surrogate Character
					ASSERT(U8_IS_LEAD(codeUnit) || U8_IS_TRAIL(codeUnit));
					CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::newPointerObject(Pointers.ClassCharacter));
					MWORD code = (static_cast<MWORD>(StringEncoding::Utf8) << 24) | codeUnit;
					character->m_location->m_code = ObjectMemoryIntegerObjectOf(code);
					character->beImmutable();
					*newSp = reinterpret_cast<Oop>(character);
					ObjectMemory::AddToZct((OTE*)character);
				}
				return newSp;
			}
		}

		case StringEncoding::Utf16:
		{
			if (index > 0 && static_cast<MWORD>(index) <= (oteReceiver->bytesSize() / sizeof(Utf16String::CU)))
			{
				Utf16String::CU codeUnit = reinterpret_cast<Utf16String*>(oteReceiver->m_location)->m_characters[index - 1];
				// If not a surrogate, may have an ANSI character that can represent the code point
				if (!U_IS_SURROGATE(codeUnit))
				{
					ByteString::CU ansiCodeUnit = m_unicodeToAnsiCharMap[codeUnit];
					if (ansiCodeUnit != 0)
					{
						CharOTE* oteResult = ST::Character::NewAnsi(ansiCodeUnit);
						*newSp = reinterpret_cast<Oop>(oteResult);
						return sp;
					}
				}

				// Otherwise return a UTF-16 Character (may be a surrogate)
				CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::newPointerObject(Pointers.ClassCharacter));
				MWORD code = (static_cast<MWORD>(StringEncoding::Utf16) << 24) | codeUnit;
				character->m_location->m_code = ObjectMemoryIntegerObjectOf(code);
				character->beImmutable();
				*newSp = reinterpret_cast<Oop>(character);
				ObjectMemory::AddToZct((OTE*)character);

				return newSp;
			}
		}

		case StringEncoding::Utf32:
		{
			if (index > 0 && static_cast<MWORD>(index) <= (oteReceiver->bytesSize() / sizeof(Utf32String::CU)))
			{
				Utf32String::CU codePoint = reinterpret_cast<Utf32String*>(oteReceiver->m_location)->m_characters[index - 1];

				// Push one of the fixed ANSI Characters if possible
				if (U_IS_BMP(codePoint))
				{
					ByteString::CU ansiCodeUnit = m_unicodeToAnsiCharMap[codePoint];
					if (ansiCodeUnit != 0)
					{
						CharOTE* oteResult = ST::Character::NewAnsi(static_cast<ByteString::CU>(ansiCodeUnit));
						*newSp = reinterpret_cast<Oop>(oteResult);
						return sp;
					}
				}

				// Otherwise return a full UTF-32 Character
				CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::newPointerObject(Pointers.ClassCharacter));
				MWORD code = (static_cast<MWORD>(StringEncoding::Utf16) << 24) | codePoint;
				character->m_location->m_code = ObjectMemoryIntegerObjectOf(code);
				character->beImmutable();
				*newSp = reinterpret_cast<Oop>(character);
				ObjectMemory::AddToZct((OTE*)character);
				return newSp;
			}
		}

		default:
		case StringEncoding::Ansi:
		{
			if (index > 0 && static_cast<MWORD>(index) <= oteReceiver->bytesSize())
			{
				ByteString::CU codeUnit = oteReceiver->m_location->m_characters[index - 1];
				*newSp = reinterpret_cast<Oop>(Character::NewAnsi(codeUnit));
				return newSp;
			}
		}
		}

		// Index out of range
		return primitiveFailure(1);
	}

	// Index argument not a SmallInteger
	return primitiveFailure(0);
}

Oop* __fastcall Interpreter::primitiveStringAtPut(Oop* sp)
{
	// TODO: Support other encodings (maybe as new primitives)

	ByteStringOTE* __restrict oteReceiver = reinterpret_cast<ByteStringOTE*>(*(sp - 2));
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
				MWORD code = ObjectMemoryIntegerValueOf(reinterpret_cast<const CharOTE*>(oopValue)->m_location->m_code);
				StringEncoding encoding = static_cast<StringEncoding>(code >> 24);
				MWORD codeUnit = code & 0xffffff;
				switch (encoding)
				{
				case StringEncoding::Ansi:
					psz[index - 1] = static_cast<ByteString::CU>(codeUnit);
					*(sp - 2) = *sp;
					return sp - 2;

				case StringEncoding::Utf8:
					if (codeUnit < 0x80)
					{
						psz[index - 1] = static_cast<ByteString::CU>(codeUnit);
						*(sp - 2) = *sp;
						return sp - 2;
					}
					// else it is a surrogate code unit that cannot be handled here
					break;

				case StringEncoding::Utf16:
					if (codeUnit < 0x80)
					{
						psz[index - 1] = static_cast<ByteString::CU>(codeUnit);
						*(sp - 2) = *sp;
						return sp - 2;
					}
					else if (U_IS_BMP(codeUnit))
					{
						ByteString::CU ansi = m_unicodeToAnsiCharMap[codeUnit];
						if (ansi != 0)
						{
							ASSERT(codeUnit > 0 && !U_IS_SURROGATE(codeUnit));
							psz[index - 1] = ansi;
							*(sp - 2) = *sp;
							return sp - 2;
						}
					}
					break;

				case StringEncoding::Utf32:
					if (codeUnit < 0x80)
					{
						psz[index - 1] = static_cast<ByteString::CU>(codeUnit);
						*(sp - 2) = *sp;
						return sp - 2;
					}
					else if (U_IS_BMP(codeUnit))
					{
						ByteString::CU ansi = m_unicodeToAnsiCharMap[codeUnit];
						if (ansi != 0)
						{
							psz[index - 1] = ansi;
							*(sp - 2) = *sp;
							return sp - 2;
						}
					}
				}
			}

			// Value is not a valid code point for the current ansi code page
			return primitiveFailure(2);
		}

		// Index out of range or immutable string
		return primitiveFailure(1);
	}

	// Index argument not a SmallInteger
	return primitiveFailure(0);
}

void Interpreter::PushCharacter(Oop* const sp, MWORD codePoint)
{
	ASSERT(U_IS_UNICODE_CHAR(codePoint));

	// Try to use one of the fixed set of ANSI chars if we can
	if (codePoint < 0x80)
	{
		CharOTE* oteResult = ST::Character::NewAnsi(static_cast<ByteString::CU>(codePoint));
		*sp = reinterpret_cast<Oop>(oteResult);
		return;
	}
	else if (U_IS_BMP(codePoint))
	{
		CHAR ansi = m_unicodeToAnsiCharMap[codePoint];
		if (ansi != 0)
		{
			CharOTE* oteResult = ST::Character::NewAnsi(ansi);
			*sp = reinterpret_cast<Oop>(oteResult);
			return;
		}
	}

	// Otherwise represent as new Character with a Utf32 encoding (i.e. as the Unicode code point)
	CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::newPointerObject(Pointers.ClassCharacter));
	MWORD code = (static_cast<MWORD>(StringEncoding::Utf32) << 24) | codePoint;
	character->m_location->m_code = ObjectMemoryIntegerObjectOf(code);
	character->beImmutable();
	*sp = reinterpret_cast<Oop>(character);
	ObjectMemory::AddToZct((OTE*)character);
}


Oop* __fastcall Interpreter::primitiveNewCharacter(Oop* const sp)
{
	Oop* newSp = sp - 1;
	Oop oopArg = *newSp;
	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SMALLINTEGER codePoint = ObjectMemoryIntegerValueOf(oopArg);

		if (U_IS_UNICODE_CHAR(codePoint))
		{
			PushCharacter(newSp, codePoint);
		}

		// Not a valid code point
		return primitiveFailure(1);
	}

	// Not a SmallInteger
	return primitiveFailure(0);
}

#define ENCODINGPAIR(e1, e2) (static_cast<int>(e1) <<2 | static_cast<int>(e2))

template <typename T, class OpA, class OpW, bool Utf8OpA = false> static T AnyStringCompare(const OTE* oteReceiver, const OTE* oteArg)
{
	switch (ENCODINGPAIR(ST::String::GetEncoding(oteReceiver), ST::String::GetEncoding(oteArg)))
	{
	case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Ansi):
		return OpA()(reinterpret_cast<const ByteStringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize(), 
			reinterpret_cast<const ByteStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());

	case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf8):
	{
		Utf16StringBuf<ByteString::CodePage, ByteString::CU> receiverW(reinterpret_cast<const ByteStringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
		Utf16StringBuf<Utf8String::CodePage, Utf8String::CU> argW(reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
		return OpW()(receiverW, receiverW.Count, argW, argW.Count);
	}

	case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
	{
		Utf16StringBuf<ByteString::CodePage, ByteString::CU> receiverW(reinterpret_cast<const ByteStringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
		return OpW()(receiverW, receiverW.Count, 
			reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize()/sizeof(WCHAR));
	}

	case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
	{
		Utf16StringBuf<Utf8String::CodePage, Utf8String::CU> receiverW(reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
		Utf16StringBuf<ByteString::CodePage, ByteString::CU> argW(reinterpret_cast<const ByteStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
		return OpW()(receiverW, receiverW.Count, argW, argW.Count);
	}

	case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
	{
		if (Utf8OpA)
		{
			return OpA()(
				reinterpret_cast<LPCSTR>(reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters), 
				oteReceiver->getSize(), 
				reinterpret_cast<LPCSTR>(reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters),
				oteArg->getSize());
		}
		else
		{
			Utf16StringBuf<Utf8String::CodePage, Utf8String::CU> receiverW(reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
			Utf16StringBuf<Utf8String::CodePage, Utf8String::CU> argW(reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
			return OpW()(receiverW, receiverW.Count, argW, argW.Count);
		}
	}

	case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
	{
		Utf16StringBuf<Utf8String::CodePage, Utf8String::CU> receiverW(reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
		return OpW()(receiverW, receiverW.Count, 
			reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize()/sizeof(WCHAR));
	}

	case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
	{
		Utf16StringBuf<ByteString::CodePage, ByteString::CU> argW(reinterpret_cast<const ByteStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
		return OpW()(reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters, 
			oteReceiver->getSize()/sizeof(WCHAR), argW, argW.Count);
	}

	case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
	{
		Utf16StringBuf<Utf8String::CodePage, Utf8String::CU> argW(reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
		return OpW()(reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize()/sizeof(WCHAR), argW, argW.Count);
	}

	case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
	{
		return OpW()(
			reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize()/sizeof(WCHAR),
			reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize()/sizeof(WCHAR));
	}
	default:
		return OpA()(reinterpret_cast<const ByteStringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize(),
			reinterpret_cast<const ByteStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
	}
}

template <class OpA, class OpW> static Oop* primitiveStringComparisonOp(Oop* const sp)//, const OpA& opA, const OpW& opW)
{
	Oop oopArg = *sp;
	const OTE* oteReceiver = reinterpret_cast<const OTE*>(*(sp - 1));
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		const OTE* oteArg = reinterpret_cast<const OTE*>(oopArg);
		if (oteArg != oteReceiver)
		{
			if (oteArg->isNullTerminated())
			{
				// Could double-dispatch this rather than handling all this in one
				// primitive, or at least define one primitive for each string class, but it would mean
				// adding quite a lot of methods, so this keeps the ST side cleaner by hiding the switch in the VM.
				// This should also be faster as the intermediate conversions can usually be performed on the stack
				// and so do not require any allocations.
				int cmp = AnyStringCompare<int, OpA, OpW>(oteReceiver, oteArg);
				*(sp - 1) = integerObjectOf(cmp);
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
	struct CmpIA 
	{
		int operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const 
		{ 
			return ::CompareStringA(LOCALE_USER_DEFAULT, NORM_IGNORECASE|LOCALE_USE_CP_ACP, psz1, cch1, psz2, cch2) - 2;
		} 
	};
	struct CmpIW 
	{
		int operator() (LPCWSTR psz1, size_t cch1, LPCWSTR psz2, size_t cch2) const
		{
			return ::CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE, psz1, cch1, psz2, cch2) - 2;
		}
	};

	return primitiveStringComparisonOp<CmpIA,CmpIW>(sp);
}

Oop* __fastcall Interpreter::primitiveStringCmp(Oop* sp)
{
	struct CmpA 
	{ 
		int operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const 
		{ 
			// lstrcmpA will stop at the first embedded null, and although our strings have a null
			// terminator, they can also contain embedded nulls, and whole string should be compared.
			// lstrcmpA is just a wrapper around CompareStringA. It passes the same values for locale and flags.
			return CompareStringA(LOCALE_USER_DEFAULT, LOCALE_USE_CP_ACP, psz1, cch1, psz2, cch2) - 2;
		} 
	};
	struct CmpW 
	{ 
		int operator() (LPCWSTR psz1, size_t cch1, LPCWSTR psz2, size_t cch2) const 
		{ 
			// lstrcmpW is just a wrapper around CompareStringA. It passes the same values for locale and flags.
			return CompareStringW(LOCALE_USER_DEFAULT, 0, psz1, cch1, psz2, cch2) - 2;
		} 
	};

	return primitiveStringComparisonOp<CmpA,CmpW>(sp);
}

Oop* __fastcall Interpreter::primitiveStringCmpOrdinal(Oop* sp)
{
	struct CmpOrdinalA
	{
		int operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const
		{
			int cmp = memcmp(psz1, psz2, min(cch1, cch2));
			return cmp == 0 && cch1 != cch2
				? cch1 < cch2 ? -1 : 1
				: cmp;
		}
	};
	struct CmpOrdinalW
	{
		int operator() (LPCWSTR psz1, size_t cch1, LPCWSTR psz2, size_t cch2) const
		{
			return CompareStringOrdinal(psz1, cch1, psz2, cch2, FALSE) - 2;
		}
	};

	return primitiveStringComparisonOp<CmpOrdinalA, CmpOrdinalW>(sp);
}

Oop* __fastcall Interpreter::primitiveStringEqual(Oop* sp)
{
	struct EqualA
	{
		bool operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const
		{
			return cch1 == cch2 && memcmp(psz1, psz2, cch1) == 0;
		}
	};
	struct EqualW
	{
		bool operator() (LPCWSTR psz1, size_t cch1, LPCWSTR psz2, size_t cch2) const
		{
			return cch1 == cch2 && CompareStringOrdinal(psz1, cch1, psz2, cch2, FALSE) == CSTR_EQUAL;
		}
	};

	Oop oopArg = *sp;
	const OTE* oteReceiver = reinterpret_cast<const OTE*>(*(sp - 1));
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		const OTE* oteArg = reinterpret_cast<const OTE*>(oopArg);
		if (oteArg != oteReceiver)
		{
			// In Dolphin Strings have historically never been = to any Symbols, regardless of whether they have the same characters
			// Perhaps this behaviour should be changed for consistency with some other Smalltalk implementations
			if (oteArg->isNullTerminated() && oteArg->m_oteClass != Pointers.ClassSymbol)
			{
				// Could double-dispatch this rather than handling all this in one
				// primitive, or at least define one primitive for each string class, but it would mean
				// adding quite a lot of methods, so this keeps the ST side cleaner by hiding the switch in the VM.
				// This should also be faster as the intermediate conversions can usually be performed on the stack
				// and so do not require any allocations.
				bool equal = AnyStringCompare<bool, EqualA, EqualW, true>(oteReceiver, oteArg);
				*(sp - 1) =// oteArg->m_oteClass == Pointers.ClassSymbol ? (equal ? ZeroPointer : OnePointer) :
								reinterpret_cast<Oop>(equal ? Pointers.True : Pointers.False);
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
			// Identical, therefore equal
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
	const OTE* receiver = reinterpret_cast<const OTE*>(*sp);
	switch (ST::String::GetEncoding(receiver))
	{
	case StringEncoding::Ansi:
	{
		Utf16StringOTE* answer = Utf16String::New<CP_ACP>(
			reinterpret_cast<const ByteStringOTE*>(receiver)->m_location->m_characters, receiver->getSize());
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf8:
	{
		Utf16StringOTE* answer = Utf16String::New<CP_UTF8>(
			reinterpret_cast<const Utf8StringOTE*>(receiver)->m_location->m_characters, receiver->getSize());
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf16:
	{
		return sp;
	}
	case StringEncoding::Utf32:
		// TODO: Implement conversion for UTF-32
	default:
		// Unrecognised encoding - fail the primitive.
		return nullptr;
	}
}

Utf16StringOTE* __fastcall ST::Utf16String::New(OTE* oteString)
{
	ASSERT(oteString->isNullTerminated());

	switch (ST::String::GetEncoding(oteString))
	{
	case StringEncoding::Utf8:
		return Utf16String::New<CP_UTF8>(reinterpret_cast<const Utf8StringOTE*>(oteString)->m_location->m_characters, oteString->getSize());
	case StringEncoding::Utf16:
		ASSERT(FALSE);
		return reinterpret_cast<Utf16StringOTE*>(oteString);
	case StringEncoding::Utf32:
		// TODO: Implement conversion for UTF-32
		return nullptr;
	case StringEncoding::Ansi:
	default:
		return Utf16String::New<CP_ACP>(reinterpret_cast<const ByteStringOTE*>(oteString)->m_location->m_characters, oteString->getSize());
	}
}

Utf16StringOTE * ST::Utf16String::New(size_t cwch)
{
	return reinterpret_cast<Utf16StringOTE*>(ObjectMemory::newUninitializedNullTermObject(Pointers.ClassUtf16String, cwch * sizeof(WCHAR)));
}

Oop * Interpreter::primitiveStringAsUtf8String(Oop * const sp)
{
	const OTE* receiver = reinterpret_cast<const OTE*>(*sp);
	BehaviorOTE* oteClass = receiver->m_oteClass;
	switch (ST::String::GetEncoding(receiver))
	{
	case StringEncoding::Ansi:
	{
		// Assume some kind of Ansi string
		Utf8StringOTE* answer = Utf8String::NewFromAnsi(
			reinterpret_cast<const ByteStringOTE*>(receiver)->m_location->m_characters, receiver->getSize());
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}

	case StringEncoding::Utf8:
		return sp;

	case StringEncoding::Utf16:
	{
		Utf8StringOTE* answer = Utf8String::New(
			reinterpret_cast<const Utf16StringOTE*>(receiver)->m_location->m_characters, receiver->getSize()/sizeof(WCHAR));
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf32:
		// TODO: Implement conversion for UTF-32
	default:
		// Unrecognised encoding - fail the primitive
		return nullptr;
	}
}

Oop* __fastcall Interpreter::primitiveStringAsByteString(Oop* const sp)
{
	const OTE* receiver = reinterpret_cast<const OTE*>(*sp);
	BehaviorOTE* oteClass = receiver->m_oteClass;
	switch (ST::String::GetEncoding(receiver))
	{
	case StringEncoding::Ansi:
	{
		ByteStringOTE* answer = ByteString::New(
			reinterpret_cast<const ByteStringOTE*>(receiver)->m_location->m_characters, receiver->getSize());
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf8:
	{
		ByteStringOTE* answer = ByteString::NewFromUtf8(
			reinterpret_cast<const Utf8StringOTE*>(receiver)->m_location->m_characters, receiver->getSize());
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf16:
	{
		ByteStringOTE* answer = ByteString::New(
			reinterpret_cast<const Utf16StringOTE*>(receiver)->m_location->m_characters, receiver->getSize() / sizeof(WCHAR));
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf32:
		// TODO: Implement conversion for UTF-32
	default:
		// Unrecognised encoding - fail the primitive
		return nullptr;
	}
}

Utf16StringOTE* Utf16String::New(LPCWSTR value)
{
	size_t cwch = wcslen(value);
	Utf16StringOTE* stringPointer = New(cwch);
	Utf16String* __restrict string = stringPointer->m_location;
	memcpy(string->m_characters, value, (cwch + 1) * sizeof(WCHAR));
	return stringPointer;
}

Utf16StringOTE* __fastcall Utf16String::New(const WCHAR* value, size_t cwch)
{
	Utf16StringOTE* stringPointer = New(cwch);
	Utf16String* string = stringPointer->m_location;
	string->m_characters[cwch] = L'\0';
	memcpy(string->m_characters, value, cwch*sizeof(WCHAR));
	return stringPointer;
}

//Utf16StringOTE * ST::Utf16String::New(LPCSTR sz, UINT cp)
//{
//	int len = ::MultiByteToWideChar(cp, 0, sz, -1, nullptr, 0);
//	// Length includes null terminator since input is null terminated
//	Utf16StringOTE* stringPointer = New(len - 1);
//	Utf16String* __restrict string = stringPointer->m_location;
//	int nCopied = ::MultiByteToWideChar(cp, 0, sz, -1, string->m_characters, len);
//	UNREFERENCED_PARAMETER(nCopied);
//	ASSERT(nCopied == len);
//	return stringPointer;
//}

template <UINT CP, class T> Utf16StringOTE * ST::Utf16String::New(const T* psz, size_t cch)
{
	// A UTF16 encoded string can never require more code units than a byte encoding (though it will usually require more bytes)
	int cwch = ::MultiByteToWideChar(CP, 0, reinterpret_cast<LPCCH>(psz), cch, nullptr, 0);
	Utf16StringOTE* stringPointer = New(cwch);
	LPWSTR pwsz = stringPointer->m_location->m_characters;
	int cwch2 = ::MultiByteToWideChar(CP, 0, reinterpret_cast<LPCCH>(psz), cch, pwsz, cwch);
	pwsz[cwch] = L'\0';
	return stringPointer;
}

Utf8StringOTE* ST::Utf8String::NewFromAnsi(const char* pChars, size_t len)
{
	// There is no Windows API for direct conversion from ANSI<->UTF8, so we need to convert to UTF16 first
	Utf16StringBuf<ByteString::CodePage, ByteString::CU> utf16(pChars, len);
	return Utf8String::New(utf16, utf16.Count);
}

ByteStringOTE* ST::ByteString::NewFromUtf8(const Utf8String::CU* pChars, size_t len)
{
	Utf16StringBuf<Utf8String::CodePage, Utf8String::CU> utf16(pChars, len);
	return ByteString::New(utf16, utf16.Count);
}

Oop* Interpreter::primitiveStringConcatenate(Oop* const sp)
{
	Oop oopArg = *sp;
	const OTE* oteReceiver = reinterpret_cast<const OTE*>(*(sp - 1));
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		const OTE* oteArg = reinterpret_cast<const OTE*>(oopArg);
		if (oteArg->isNullTerminated())
		{
			// Should probably double-dispatch this rather than handling all this in one
			// primitive, or at least define one primitive for each string class
			switch (ENCODINGPAIR(ST::String::GetEncoding(oteReceiver), ST::String::GetEncoding(oteArg)))
			{
			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Ansi):
			{
				MWORD cbPrefix = oteReceiver->getSize();
				MWORD cbSuffix = oteArg->getSize();
				auto oteAnswer = ByteString::New(cbPrefix + cbSuffix);
				LPSTR psz = reinterpret_cast<ByteStringOTE*>(oteAnswer)->m_location->m_characters;
				memcpy(psz, reinterpret_cast<const ByteStringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				memcpy(psz + cbPrefix, reinterpret_cast<const ByteStringOTE*>(oteArg)->m_location->m_characters, cbSuffix + sizeof(char));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
			{
				MWORD cbPrefix = oteReceiver->getSize();
				MWORD cbSuffix = oteArg->getSize();
				auto oteAnswer = Utf8String::New(cbPrefix + cbSuffix);
				auto psz = oteAnswer->m_location->m_characters;
				memcpy(psz, reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				memcpy(psz + cbPrefix, reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters, cbSuffix + sizeof(char));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf8):
			{
				// Ansi, UTF-8 => UTF-8; but we have to translate to translate via UTF16
				Utf16StringBuf<ByteString::CodePage, ByteString::CU> utf16(reinterpret_cast<const ByteStringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
				size_t cbPrefix = utf16.ToUtf8();
				MWORD cbSuffix = oteArg->getSize();
				auto oteAnswer = Utf8String::New(cbPrefix + cbSuffix);
				auto psz = oteAnswer->m_location->m_characters;
				utf16.ToUtf8(psz, cbPrefix);
				memcpy(psz + cbPrefix, reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters, cbSuffix + sizeof(char));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
			{
				// Ansi, UTF-16 => UTF-16
				LPCSTR pszReceiver = reinterpret_cast<const ByteStringOTE*>(oteReceiver)->m_location->m_characters;
				MWORD cchReceiver = oteReceiver->getSize();
				int cwchPrefix = ::MultiByteToWideChar(CP_ACP, 0, pszReceiver, cchReceiver, nullptr, 0);
				MWORD cbSuffix = oteArg->getSize();
				MWORD cwchSuffix = cbSuffix / sizeof(WCHAR);
				auto oteAnswer = Utf16String::New(cwchPrefix + cwchSuffix);
				LPWSTR pwszAnswer = oteAnswer->m_location->m_characters;
				::MultiByteToWideChar(CP_ACP, 0, pszReceiver, cchReceiver, pwszAnswer, cwchPrefix);
				memcpy(pwszAnswer + cwchPrefix, reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, cbSuffix + sizeof(WCHAR));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
			{
				// UTF-8, Ansi => UTF-8; but we have to translate to translate via UTF16
				// TODO: Implement a direct ANSI to UTF-8 translation

				Utf16StringBuf<ByteString::CodePage, ByteString::CU> utf16(reinterpret_cast<const ByteStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
				size_t cbSuffix = utf16.ToUtf8();
				MWORD cbPrefix = oteReceiver->getSize();
				MWORD cbAnswer = cbPrefix + cbSuffix;
				auto oteAnswer = Utf8String::New(cbAnswer);
				auto psz = oteAnswer->m_location->m_characters;
				memcpy(psz, reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				utf16.ToUtf8(psz + cbPrefix, cbSuffix);
				psz[cbAnswer] = '\0';
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
			{
				// Since both encodings can represent any string, we return a result that is the same class as the receiver, i.e.
				// UTF-8, Utf16 => UTF-8
				const WCHAR* pArgChars = reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters;
				MWORD cwchSuffix = oteArg->getSize() / sizeof(WCHAR);
				int cbSuffix = ::WideCharToMultiByte(CP_UTF8, 0, pArgChars, cwchSuffix, nullptr, 0, nullptr, nullptr);
				ASSERT(cbSuffix >= 0);
				MWORD cbPrefix = oteReceiver->getSize();
				auto oteAnswer = Utf8String::New(cbPrefix + cbSuffix);
				auto psz = oteAnswer->m_location->m_characters;
				memcpy(psz, reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				::WideCharToMultiByte(CP_UTF8, 0, pArgChars, cwchSuffix + 1, reinterpret_cast<LPSTR>(psz + cbPrefix), cbSuffix + 1, nullptr, nullptr);
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
			{
				// Ansi, UTF-16 => UTF-16
				LPCSTR pszArg = reinterpret_cast<const ByteStringOTE*>(oteArg)->m_location->m_characters;
				MWORD cchArg = oteArg->getSize();
				int cwchSuffix = ::MultiByteToWideChar(CP_ACP, 0, pszArg, cchArg, nullptr, 0);
				ASSERT(cwchSuffix >= 0);
				MWORD cbPrefix = oteReceiver->getSize();
				MWORD cwchPrefix = cbPrefix / sizeof(WCHAR);
				auto oteAnswer = Utf16String::New(cwchPrefix + cwchSuffix);
				LPWSTR pwsz = oteAnswer->m_location->m_characters;
				memcpy(pwsz, reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				::MultiByteToWideChar(CP_ACP, 0, pszArg, cchArg + 1, pwsz + cwchPrefix, cwchSuffix + 1);
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
			{
				// Since both encodings can represent any string, we return a result that is the same class as the receiver, i.e.
				// UTF-16, Utf8 => UTF-16
				auto pszArg = reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters;
				MWORD cbArg = oteArg->getSize();
				int cwchSuffix = ::MultiByteToWideChar(CP_UTF8, 0, reinterpret_cast<LPCCH>(pszArg), cbArg, nullptr, 0);
				int cbPrefix = oteReceiver->getSize();
				int cwchPrefix = cbPrefix / sizeof(WCHAR);
				auto oteAnswer = Utf16String::New(cwchPrefix + cwchSuffix);
				LPWSTR pwszAnswer = oteAnswer->m_location->m_characters;
				LPCWSTR pwszReceiver = reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters;
				memcpy(pwszAnswer, pwszReceiver, cbPrefix);
				::MultiByteToWideChar(CP_UTF8, 0, reinterpret_cast<LPCCH>(pszArg), cbArg + 1, pwszAnswer + cwchPrefix, cwchSuffix + 1);
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
			{
				// UTF-16, UTF-16 => UTF-16
				MWORD cbPrefix = oteReceiver->getSize();
				MWORD cbSuffix = oteArg->getSize();
				auto oteAnswer = ObjectMemory::newUninitializedNullTermObject(oteReceiver->m_oteClass, cbPrefix + cbSuffix);
				BYTE* pbAnswer = oteAnswer->m_location->m_fields;
				memcpy(pbAnswer, reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				memcpy(pbAnswer+cbPrefix, reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, cbSuffix + sizeof(WCHAR));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;
			default:
				// Unrecognised encoding pair - fail the primitive
				return primitiveFailure(2);
			}

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
		// Arg is a SmallInteger
		return Interpreter::primitiveFailure(0);
	}
}
