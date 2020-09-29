/******************************************************************************

	File: StrgPrim.cpp

	Description:

	Implementation of the Interpreter class' String (variable
	byte object) primitive methods

******************************************************************************/
#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

// Smalltalk classes
#include "STBehavior.h"
#include "STExternal.h"		// For ExternalAddress
#include "STByteArray.h"
#include "STCharacter.h"

#include "StrgPrim.h"

codepage_t Interpreter::m_ansiCodePage;
WCHAR Interpreter::m_unicodeReplacementChar;
char Interpreter::m_ansiReplacementChar;
WCHAR Interpreter::m_ansiToUnicodeCharMap[256];
CHAR Interpreter::m_unicodeToAnsiCharMap[65536];

#pragma comment(lib, "icuuc.lib")

CharOTE* Character::NewUnicode(char32_t value)
{
	if (__isascii(value))
	{
		return NewAnsi(static_cast<unsigned char>(value));
	}
	else if (U_IS_BMP(value))
	{
		CHAR ansiCodeUnit = Interpreter::m_unicodeToAnsiCharMap[value];
		if (ansiCodeUnit != 0)
		{
			return NewAnsi(static_cast<unsigned char>(ansiCodeUnit));
		}
	}

	CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::newPointerObject(Pointers.ClassCharacter));
	SmallInteger code = (static_cast<char32_t>(StringEncoding::Utf32) << 24) | (value & 0xffffff);
	character->m_location->m_code = ObjectMemoryIntegerObjectOf(code);
	character->beImmutable();

	return character;
}

// Characters are not reference counted - very important that param is unsigned in order to calculate offset of
// character object in OTE correctly (otherwise chars > 127 will probably offset off the front of the OTE).
CharOTE* Character::NewAnsi(unsigned char value)
{
	CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::PointerFromIndex(ObjectMemory::FirstCharacterIdx + value));
	ASSERT(ObjectMemoryIntegerValueOf(character->m_location->m_code) == ((static_cast<SmallInteger>(StringEncoding::Ansi) << 24) | value));
	return character;
}

char32_t Character::getCodePoint() const
{
	// For UTF surrogates, this won't actually be a valid code point

	return Encoding == StringEncoding::Ansi
		? Interpreter::m_ansiToUnicodeCharMap[CodeUnit & 0xff]
		: CodeUnit;
}

///////////////////////////////////////////////////////////////////////////////
//	String Primitives

void Interpreter::memmove(uint8_t* dst, const uint8_t* src, size_t count)
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
Oop* __fastcall Interpreter::primitiveReplaceBytes(Oop* const sp, primargcount_t)
{
	Oop integerPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter4);	// startAt is not an integer
	SmallInteger startAt = ObjectMemoryIntegerValueOf(integerPointer);

	integerPointer = *(sp - 1);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter3);	// stop is not an integer
	SmallInteger stop = ObjectMemoryIntegerValueOf(integerPointer);

	integerPointer = *(sp - 2);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);	// start is not an integer
	SmallInteger start = ObjectMemoryIntegerValueOf(integerPointer);

	OTE* argPointer = reinterpret_cast<OTE*>(*(sp - 3));
	if (ObjectMemoryIsIntegerObject(argPointer) || !argPointer->isBytes())
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Argument MUST be a byte object

	// Empty move if stop before start, is considered valid regardless (strange but true)
	// this is the convention adopted by most implementations.
	if (stop >= start)
	{
		if (startAt < 1 || start < 1)
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out-of-bounds

		// We still permit the argument to be an address to cut down on the number of primitives
		// and double dispatch methods we must implement (2 rather than 4)
		uint8_t* pTo;

		Behavior* behavior = argPointer->m_oteClass->m_location;
		if (behavior->isIndirect())
		{
			AddressOTE* oteBytes = reinterpret_cast<AddressOTE*>(argPointer);
			// We don't know how big the object is the argument points at, so cannot check length
			// against stop point
			pTo = static_cast<uint8_t*>(oteBytes->m_location->m_pointer);
		}
		else
		{
			// We can test that we're not going to write off the end of the argument
			auto length = argPointer->bytesSizeForUpdate();

			// We can only be in here if stop>=start, so => stop-start >= 0
			// therefore if startAt >= 1 then => stopAt >= 1, for similar
			// reasons (since stopAt >= startAt) we don't need to test 
			// that startAt <= length
			if (stop > length)
				return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Bounds error (or object is immutable so size < 0)

			VariantByteObject* argBytes = reinterpret_cast<BytesOTE*>(argPointer)->m_location;
			pTo = argBytes->m_fields;
		}

		BytesOTE* receiverPointer = reinterpret_cast<BytesOTE*>(*(sp - 4));

		// Now validate that the interval specified for copying from the receiver
		// is within the bounds of the receiver (we've already tested startAt)
		{
			ptrdiff_t length = receiverPointer->bytesSize();
			// We can only be in here if stop>=start, so if start>=1, then => stop >= 1
			// furthermore if stop <= length then => start <= length
			ptrdiff_t stopAt = startAt+stop-start;
			if (stopAt > length)
				return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
		}

		// Only works for byte objects
		ASSERT(receiverPointer->isBytes());
		VariantByteObject* receiverBytes = receiverPointer->m_location;

		uint8_t* pFrom = receiverBytes->m_fields;

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
Oop* __fastcall Interpreter::primitiveIndirectReplaceBytes(Oop* const sp, primargcount_t)
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

	OTE* argPointer = reinterpret_cast<OTE*>(*(sp-3));
	if (ObjectMemoryIsIntegerObject(argPointer) || !argPointer->isBytes())
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Argument MUST be a byte object

	// Empty move if stop before start, is considered valid regardless (strange but true)
	if (stop >= start)
	{
		if (start < 1 || startAt < 1)
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// out-of-bounds

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
		uint8_t* pFrom = static_cast<uint8_t*>(receiverBytes->m_pointer);

		// We still permit the argument to be an address to cut down on the double dispatching
		// required.
		uint8_t* pTo;
		Behavior* behavior = argPointer->m_oteClass->m_location;
		if (behavior->isIndirect())
		{
			AddressOTE* oteBytes = reinterpret_cast<AddressOTE*>(argPointer);
			// Cannot check length 
			pTo = static_cast<uint8_t*>(oteBytes->m_location->m_pointer);
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
				return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Bounds error

			VariantByteObject* argBytes = reinterpret_cast<BytesOTE*>(argPointer)->m_location;
			pTo = argBytes->m_fields;
		}

		memmove(pTo+start-1, pFrom+startAt-1, stop-start+1);
	}
	// Answers the argument by moving it down over the receiver
	*(sp-4) = reinterpret_cast<Oop>(argPointer);
	return sp-4;
}

// ICU is known to fire the RTCC smaller type assignment check, e.g. from U8_NEXT. It is a false positive.
#pragma runtime_checks("c", off)

// Locate the next occurrence of the given character in the receiver between the specified indices.
Oop* __fastcall Interpreter::primitiveStringNextIndexOfFromTo(Oop* const sp, primargcount_t)
{
	Oop integerPointer = *sp;
	if (ObjectMemoryIsIntegerObject(integerPointer))
	{
		const SmallInteger to = ObjectMemoryIntegerValueOf(integerPointer);

		integerPointer = *(sp - 1);
		if (ObjectMemoryIsIntegerObject(integerPointer))
		{
			const SmallInteger from = ObjectMemoryIntegerValueOf(integerPointer);

			Oop valuePointer = *(sp - 2);

			Oop answer = ZeroPointer;
			// If not a character, or the search interval is empty, we treat as not found
			if ((ObjectMemory::fetchClassOf(valuePointer) == Pointers.ClassCharacter))
			{
				CharOTE* oteChar = reinterpret_cast<CharOTE*>(valuePointer);
				Character* charObj = oteChar->m_location;
				if (to >= from)
				{
					StringOTE* oteReceiver = reinterpret_cast<StringOTE*>(*(sp - 3));
					ASSERT(!oteReceiver->isPointers());

					switch (oteReceiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
					{
					case StringEncoding::Ansi:
					{
						AnsiStringOTE* oteAnsi = reinterpret_cast<AnsiStringOTE*>(oteReceiver);
						const auto length = oteAnsi->sizeForRead();
						// We can only be in here if to>=from, so if to>=1, then => from >= 1
						// furthermore if to <= length then => from <= length
						if (from >= 1 && static_cast<size_t>(to) <= length)
						{
							// Search is in bounds, lets do it
							Oop answer = ZeroPointer;
							// If not a byte char, can't possibly be in a byte string (treat as not found, rather than primitive failure)
							if (charObj->Encoding == StringEncoding::Ansi)
							{
								const AnsiString::CU charValue = static_cast<AnsiString::CU>(charObj->CodeUnit);

								AnsiString* chars = oteAnsi->m_location;

								auto i = from - 1;
								while (i < to)
								{
									if (chars->m_characters[i++] == charValue)
									{
										*(sp - 3) = ObjectMemoryIntegerObjectOf(i);
										return sp - 3;
									}
								}
							}

							// Not found, drop through and return zero
						}
						else
						{
							// To/from out of bounds
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
						}
					}
					break;

					case StringEncoding::Utf8:
					{
						auto oteUtf = reinterpret_cast<Utf8StringOTE*>(oteReceiver);
						const auto length = oteUtf->sizeForRead();
						// We can only be in here if to>=from, so if to>=1, then => from >= 1
						// furthermore if to <= length then => from <= length
						// It is OK for from to point to a trail surrogate
						if (from >= 1 && static_cast<size_t>(to) <= length)
						{
							// Search is in bounds, lets do it

							if (__isascii(charObj->CodeUnit) || charObj->IsUtf8Surrogate)
							{
								// Can perform a fast byte search

								char8_t codeUnit = charObj->CodeUnit & 0xFF;
								auto s = oteUtf->m_location->m_characters;
								auto i = from - 1;
								while (i < to)
								{
									if (s[i++] == codeUnit)
									{
										*(sp - 3) = ObjectMemoryIntegerObjectOf(i);
										return sp - 3;
									}
								}
							}
							else if (!charObj->IsUtf16Surrogate)
							{
								// Slower search for a non-byte character

								const auto codePoint = charObj->CodePoint;
								const auto s = oteUtf->m_location->m_characters;
								auto i = from - 1;
								while (i < to)
								{
									char32_t c;
									auto next = i;
									
									U8_NEXT(s, next, to, c)

									if (c == codePoint)
									{
										*(sp - 3) = ObjectMemoryIntegerObjectOf(i + 1);
										return sp - 3;
									}
									i = next;
								}
							}

							// Not found or a UTF-16 surrogate. Drop through and return zero
						}
						else
						{
							// To/from out of bounds
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
						}
					}
					break;

					case StringEncoding::Utf16:
					{
						auto oteUtf = reinterpret_cast<Utf16StringOTE*>(oteReceiver);
						const auto length = oteUtf->sizeForRead();
						// We can only be in here if to>=from, so if to>=1, then => from >= 1
						// furthermore if to <= length then => from <= length
						// It is OK for from to point to a trail surrogate
						if (from >= 1 && static_cast<size_t>(to) <= length)
						{
							// Search is in bounds, lets do it

							if (!charObj->IsUtfSurrogate)
							{
								auto codePoint = charObj->CodePoint;
								auto s = oteUtf->m_location->m_characters;
								auto i = from - 1;
								while (i < to)
								{
									char32_t c;
									size_t next = i;
									U16_NEXT_UNSAFE(s, next, c)
									if (c == codePoint)
									{
										*(sp - 3) = ObjectMemoryIntegerObjectOf(i + 1);
										return sp - 3;
									}
									i = next;
								}

								// Not found. Drop through and return zero
							}
							else
							{
								if (charObj->IsUtf16Surrogate)
								{
									char16_t codeUnit = charObj->CodeUnit & 0xFFFF;
									auto s = oteUtf->m_location->m_characters;
									auto i = from - 1;
									while (i < to)
									{
										if (s[i++] == codeUnit)
										{
											*(sp - 3) = ObjectMemoryIntegerObjectOf(i);
											return sp - 3;
										}
									}
								}
								else
								{
									// A UTF-16 string can contain a UTF-16 surrogate, but not a UTF-8 surrogate
								}

								// Not found. Drop through and return zero
							}
						}
						else
						{
							// To/from out of bounds
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
						}
					}
					break;

					case StringEncoding::Utf32:
					{
						auto oteUtf = reinterpret_cast<Utf32StringOTE*>(oteReceiver);
						const auto length = oteUtf->sizeForRead();
						// We can only be in here if to>=from, so if to>=1, then => from >= 1
						// furthermore if to <= length then => from <= length
						if (from >= 1 && static_cast<size_t>(to) <= length)
						{
							// Search is in bounds, lets do it
							auto codePoint = charObj->CodePoint;
							auto s = oteUtf->m_location->m_characters;
							auto i = from - 1;
							while (i < to)
							{
								if (s[i++] == codePoint)
								{
									*(sp - 3) = ObjectMemoryIntegerObjectOf(i);
									return sp - 3;
								}
							}

							// Not found, drop through and return 0
						}
						else
						{
							// To/from out of bounds
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
						}
					}
					break;

					default:
						// Unrecognised encoding
						__assume(false);
						return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
					}
				}
			}

			// Not a Character, or a surrogate Character of different encoding, or empty search interval
			*(sp - 3) = ZeroPointer;
			return sp - 3;
		}
		else
		{
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);				// from not an integer
		}
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter3);				// to not an integer
	}
}
#pragma runtime_checks("c", restore)


Oop* __fastcall Interpreter::primitiveStringAt(Oop* const sp, const primargcount_t argCount)
{
	Oop* newSp = sp - argCount;
	SmallInteger oopIndex = *(newSp + 1);
	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		SmallInteger index = ObjectMemoryIntegerValueOf(oopIndex) - 1;
		AnsiStringOTE* oteReceiver = reinterpret_cast<AnsiStringOTE*>(*newSp);
		switch (oteReceiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
		{
		case StringEncoding::Ansi:
			if (static_cast<size_t>(index) < oteReceiver->bytesSize())
			{
				AnsiString::CU codeUnit = oteReceiver->m_location->m_characters[index];
				*newSp = reinterpret_cast<Oop>(Character::NewAnsi(codeUnit));
				return newSp;
			}
			break;

		case StringEncoding::Utf8:
		{
			if (static_cast<size_t>(index) < oteReceiver->bytesSize())
			{
				Utf8String::CU codeUnit = reinterpret_cast<Utf8String*>(oteReceiver->m_location)->m_characters[index];

				// Will push an ANSI encoded Character if we can, else a Utf8 surrogate. 
				// We also "fallback" to interpret the content as ANSI if the character is non-ASCII but not a valid UTF-8 surrogate
				if (U8_IS_SINGLE(codeUnit))
				{
					CharOTE* oteResult = ST::Character::NewAnsi(static_cast<AnsiString::CU>(codeUnit));
					*newSp = reinterpret_cast<Oop>(oteResult);
				}
				else
				{
					// Otherwise return a UTF-8 surrogate Character
					CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::newPointerObject(Pointers.ClassCharacter));
					SmallInteger code = (static_cast<SmallInteger>(StringEncoding::Utf8) << 24) | codeUnit;
					character->m_location->m_code = ObjectMemoryIntegerObjectOf(code);
					character->beImmutable();
					*newSp = reinterpret_cast<Oop>(character);
					ObjectMemory::AddToZct((OTE*)character);
				}
				return newSp;
			}
			break;
		}

		case StringEncoding::Utf16:
		{
			if (static_cast<size_t>(index) < (oteReceiver->bytesSize() / sizeof(Utf16String::CU)))
			{
				Utf16String::CU codeUnit = reinterpret_cast<Utf16String*>(oteReceiver->m_location)->m_characters[index];
				SmallInteger code;

				// If not a surrogate, may have an ANSI character that can represent the code point
				if (!U_IS_SURROGATE(codeUnit))
				{
					AnsiString::CU ansiCodeUnit = 0;
					if (codeUnit == 0 || (ansiCodeUnit = m_unicodeToAnsiCharMap[codeUnit]) != 0)
					{
						CharOTE* oteResult = ST::Character::NewAnsi(static_cast<unsigned char>(ansiCodeUnit));
						*newSp = reinterpret_cast<Oop>(oteResult);
						return newSp;
					}

					// Non-ansi, non-surrogate, so return a full UTF-32 Character
					code = (static_cast<SmallInteger>(StringEncoding::Utf32) << 24) | codeUnit;
				}
				else
				{
					// Return a UTF-16 Character for surrogates so it is possible to detect surrogates in the image
					code = (static_cast<SmallInteger>(StringEncoding::Utf16) << 24) | codeUnit;
				}

				CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::newPointerObject(Pointers.ClassCharacter));
				character->m_location->m_code = ObjectMemoryIntegerObjectOf(code);
				character->beImmutable();
				*newSp = reinterpret_cast<Oop>(character);
				ObjectMemory::AddToZct((OTE*)character);

				return newSp;
			}
			break;
		}

		case StringEncoding::Utf32:
		{
			if (static_cast<size_t>(index) < (oteReceiver->bytesSize() / sizeof(Utf32String::CU)))
			{
				Utf32String::CU codePoint = reinterpret_cast<Utf32String*>(oteReceiver->m_location)->m_characters[index];

				// Push one of the fixed ANSI Characters if possible
				if (U_IS_BMP(codePoint))
				{
					AnsiString::CU ansiCodeUnit = 0;
					if (codePoint == 0 || (ansiCodeUnit = m_unicodeToAnsiCharMap[codePoint]) != 0)
					{
						CharOTE* oteResult = ST::Character::NewAnsi(static_cast<AnsiString::CU>(ansiCodeUnit));
						*newSp = reinterpret_cast<Oop>(oteResult);
						return newSp;
					}
				}

				// Otherwise return a full UTF-32 Character
				CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::newPointerObject(Pointers.ClassCharacter));
				SmallInteger code = (static_cast<SmallInteger>(StringEncoding::Utf32) << 24) | codePoint;
				character->m_location->m_code = ObjectMemoryIntegerObjectOf(code);
				character->beImmutable();
				*newSp = reinterpret_cast<Oop>(character);
				ObjectMemory::AddToZct((OTE*)character);
				return newSp;
			}
			break;
		}

		default:
			// Unrecognised encoding
			__assume(false);
			return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
		}

		// Index out of range
		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
	}

	// Index argument not a SmallInteger
	return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

Oop* __fastcall Interpreter::primitiveStringAtPut(Oop* const sp, primargcount_t)
{
	Oop* const newSp = sp - 2;
	OTE* __restrict oteReceiver = reinterpret_cast<OTE*>(*newSp);
	int index = *(sp - 1);
	if (ObjectMemoryIsIntegerObject(index))
	{
		index = ObjectMemoryIntegerValueOf(index) - 1;
		int receiverSize = oteReceiver->bytesSizeForUpdate();
		// Note that we don't mask off the immutability bit, so if receiver immutable, size will be < 0, and the condition will be false
		if (index >= 0)
		{
			const Oop oopValue = *sp;
			if (!ObjectMemoryIsIntegerObject(oopValue) && reinterpret_cast<const OTE*>(oopValue)->m_oteClass == Pointers.ClassCharacter)
			{
				SmallInteger code = ObjectMemoryIntegerValueOf(reinterpret_cast<const CharOTE*>(oopValue)->m_location->m_code);
				char32_t codeUnit = code & 0x1fffff;

				switch (oteReceiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
				{
				case StringEncoding::Ansi:
					if (index < receiverSize)
					{
						AnsiString::CU* const __restrict psz = reinterpret_cast<AnsiStringOTE*>(oteReceiver)->m_location->m_characters;

						// Ascii characters are the same in all encodings
						if (__isascii(codeUnit))
						{
							psz[index] = static_cast<AnsiString::CU>(codeUnit);
							*newSp = oopValue;
							return newSp;
						}
						else
						{
							switch (static_cast<StringEncoding>(code >> 24))
							{
							case StringEncoding::Ansi: // Ansi char into Ansi string
								psz[index] = static_cast<AnsiString::CU>(codeUnit);
								*newSp = oopValue;
								return newSp;

							case StringEncoding::Utf8: 
								// UTF-8 surrogate char into Ansi string - cannot be handled here
								break;

							case StringEncoding::Utf16: // UTF-16 char into Ansi string - almost certainly invalid, since we should only have UTF-16 encoded chars for surrogates
							case StringEncoding::Utf32: // UTF-32 char into Ansi string - probably invalid, since we should only have UTF-32 encoded chars for non-ANSI code points
								if (U_IS_BMP(codeUnit))
								{
									AnsiString::CU ansi = m_unicodeToAnsiCharMap[codeUnit];
									if (ansi != 0)
									{
										ASSERT(codeUnit > 0 && !U_IS_SURROGATE(codeUnit));
										psz[index] = ansi;
										*newSp = oopValue;
										return newSp;
									}
									else if (codeUnit == m_unicodeReplacementChar)
									{
										psz[index] = m_ansiReplacementChar;
										*newSp = oopValue;
										return newSp;
									}
								}

								// Value is not a valid code point for an ANSI string
								break;

							default:
								// Unrecognised character encoding
								__assume(false);
								return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);
							}

							return primitiveFailure(_PrimitiveFailureCode::UnmappableCharacter);
						}
					}
					break;

				case StringEncoding::Utf8:
					if (index < receiverSize / static_cast<ptrdiff_t>(sizeof(Utf8String::CU)))
					{
						Utf8String::CU* psz = reinterpret_cast<Utf8StringOTE*>(oteReceiver)->m_location->m_characters;

						if (__isascii(codeUnit) || static_cast<StringEncoding>(code >> 24) == StringEncoding::Utf8)
						{
							psz[index] = static_cast<Utf8String::CU>(codeUnit);
							*newSp = oopValue;
							return newSp;
						}
						// else the non-ascii/non-UTF8 char will require multiple bytes and can't be at:put:
						return primitiveFailure(_PrimitiveFailureCode::UnmappableCharacter);
					}
					break;

				case StringEncoding::Utf16:
					if (index < receiverSize / static_cast<ptrdiff_t>(sizeof(Utf16String::CU)))
					{
						Utf16String::CU* psz = reinterpret_cast<Utf16StringOTE*>(oteReceiver)->m_location->m_characters;

						if (__isascii(codeUnit))
						{
							psz[index] = static_cast<Utf16String::CU>(codeUnit);
							*newSp = oopValue;
							return newSp;
						}
						else
						{
							switch (static_cast<StringEncoding>(code >> 24))
							{
							case StringEncoding::Ansi:
								// Non-ascii Ansi char into Utf16 string. Will always go.
								psz[index] = m_ansiToUnicodeCharMap[codeUnit & 0xFF];
								*newSp = oopValue;
								return newSp;

							case StringEncoding::Utf8:
								// Surrogate UTF-8 char into Utf16 string - invalid, since we can't translate surrogates
								break;

							case StringEncoding::Utf16:
								// UTF-16 char into Utf16 string - always goes
								psz[index] = static_cast<Utf16String::CU>(codeUnit);
								*newSp = oopValue;
								return newSp;

							case StringEncoding::Utf32:
								// UTF-32 char into Utf16 string - will usually go
								if (U_IS_BMP(codeUnit))
								{
									psz[index] = static_cast<Utf16String::CU>(codeUnit);
									*newSp = oopValue;
									return newSp;
								}
								// else outside the range of a single UTF-16 code unit (e.g. symbols)
								break;

							default:
								// Unrecognised character encoding
								__assume(false);
								return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);
							}

							// Can't store the char in a UTF-16 encoded string
							return primitiveFailure(_PrimitiveFailureCode::UnmappableCharacter);
						}
					}
					break;

				case StringEncoding::Utf32:
					if (index < receiverSize / static_cast<ptrdiff_t>(sizeof(Utf32String::CU)))
					{
						Utf32String::CU* const __restrict psz = reinterpret_cast<Utf32StringOTE*>(oteReceiver)->m_location->m_characters;

						if (__isascii(codeUnit))
						{
							psz[index] = static_cast<Utf32String::CU>(codeUnit);
							*newSp = oopValue;
							return newSp;
						}
						else
						{
							switch (static_cast<StringEncoding>(code >> 24))
							{
							case StringEncoding::Ansi:
								// Non-ascii Ansi char into Utf16 string. Will always go.
								psz[index] = m_ansiToUnicodeCharMap[codeUnit & 0xff];
								*newSp = oopValue;
								return newSp;

							case StringEncoding::Utf8:
							case StringEncoding::Utf16:
								// Surrogate UTF-8/16 char into Utf32 string - invalid, since we can't translate surrogates in isolation
								return primitiveFailure(_PrimitiveFailureCode::UnmappableCharacter);

							case StringEncoding::Utf32:
								// UTF-32 char into Utf16 string - will always go unless the character is invalid
								if (U_IS_UNICODE_CHAR(codeUnit))
								{
									psz[index] = static_cast<Utf32String::CU>(codeUnit);
									*newSp = oopValue;
									return newSp;
								}
								break;

							default:
								// Unrecognised character encoding
								__assume(false);
								break;
							}

							// Can't store the char in a UTF-32 encoded string
							return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);
						}
					}
					break;

				default:
					__assume(false);
					// Unrecognised receiver string encoding
					return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
				}
			}
			else
			{
				// Value is not a Character
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
			}

			// Index out of range or immutable string
			return primitiveFailure(receiverSize < 0 ? _PrimitiveFailureCode::AccessViolation : _PrimitiveFailureCode::OutOfBounds);
		}
		else
		{
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Index is not strictly positive
		}
	}
	else
	{
		// Index argument not a SmallInteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

void Interpreter::PushCharacter(Oop* const sp, char32_t codePoint)
{
	ASSERT(U_IS_UNICODE_CHAR(codePoint));

	// Try to use one of the fixed set of ANSI chars if we can
	if (__isascii(codePoint))
	{
		CharOTE* oteResult = ST::Character::NewAnsi(static_cast<AnsiString::CU>(codePoint));
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
	SmallInteger code = (static_cast<SmallInteger>(StringEncoding::Utf32) << 24) | codePoint;
	character->m_location->m_code = ObjectMemoryIntegerObjectOf(code);
	character->beImmutable();
	*sp = reinterpret_cast<Oop>(character);
	ObjectMemory::AddToZct((OTE*)character);
}


Oop* __fastcall Interpreter::primitiveNewCharacter(Oop* const sp, primargcount_t)
{
	Oop* newSp = sp - 1;
	Oop oopArg = *newSp;
	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SmallInteger codePoint = ObjectMemoryIntegerValueOf(oopArg);

		if (U_IS_UNICODE_CHAR(codePoint))
		{
			PushCharacter(newSp, codePoint);
		}

		// Not a valid code point
		return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);
	}

	// Not a SmallInteger
	return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

// primitiveStringEqual does not use the comparison template because the result is a Boolean, not an Integer
// 
Oop* __fastcall Interpreter::primitiveStringEqual(Oop* sp, primargcount_t argc)
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
		bool operator() (const Utf16String::CU* psz1, size_t cch1, const Utf16String::CU* psz2, size_t cch2) const
		{
			return cch1 == cch2 && CompareStringOrdinal((LPCWCH)psz1, cch1, (LPCWCH)psz2, cch2, FALSE) == CSTR_EQUAL;
		}
	};

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
				bool equal = AnyStringCompare<bool, EqualA, EqualW, true>(oteReceiver, oteArg);
				*(sp - 1) =	reinterpret_cast<Oop>(equal ? Pointers.True : Pointers.False);
				return sp - 1;
			}
			else
			{
				// Arg not a null terminated byte object
				return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
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
		return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

Oop* Interpreter::primitiveBytesEqual(Oop* const sp, primargcount_t)
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
				size_t argSize = oteArg->bytesSize();
				Oop answer = reinterpret_cast<Oop>(Pointers.False);
				if (argSize == oteReceiver->bytesSize())
				{
					uint8_t* pbReceiver = oteReceiver->m_location->m_fields;
					uint8_t* pbArg = oteArg->m_location->m_fields;
					if (memcmp(pbReceiver, pbArg, argSize) == 0)
						answer = reinterpret_cast<Oop>(Pointers.True);
				}

				*(sp - 1) = answer;
				return sp - 1;
			}
			else
			{
				// Arg not same type
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
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
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

template <class T> uint32_t __fastcall hashBytes(const T* bytes, size_t len)
{
	const T* stop = bytes + len;
	uint32_t hash = 2166136261U;

	while (bytes < stop) 
	{
		hash = (hash ^ static_cast<uint32_t>(*bytes++)) * 16777619;
	}

	// Xor-fold down to 30 bits so it will always fit in a SmallInteger. 
	// Folding gives slightly better results than just truncating
	return (hash >> 30) ^ (hash & 0x3FFFFFFF);
}

Oop* __fastcall Interpreter::primitiveHashBytes(Oop* const sp, primargcount_t)
{
	BytesOTE* receiver = reinterpret_cast<BytesOTE*>(*sp);

	if (receiver->isNullTerminated())
	{
		switch (receiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
		{
		case StringEncoding::Ansi:
		{
			// Assume some kind of Ansi string
			Utf8StringOTE * utf8 = Utf8String::NewFromAnsi(
				reinterpret_cast<const AnsiStringOTE*>(receiver)->m_location->m_characters, receiver->bytesSize());
			SmallInteger hash = hashBytes(utf8->m_location->m_characters, utf8->bytesSize());
			*sp = ObjectMemoryIntegerObjectOf(hash);
			ObjectMemory::deallocateByteObject(reinterpret_cast<OTE*>(utf8));
			return sp;
		}

		case StringEncoding::Utf8:
		{
			SmallInteger hash = hashBytes(reinterpret_cast<Utf8StringOTE*>(receiver)->m_location->m_characters, receiver->bytesSize());
			*sp = ObjectMemoryIntegerObjectOf(hash);
			return sp;
		}

		case StringEncoding::Utf16:
		{
			Utf8StringOTE* utf8 = Utf8String::New(
				reinterpret_cast<const Utf16StringOTE*>(receiver)->m_location->m_characters, receiver->getSize() / sizeof(Utf16String::CU));
			SmallInteger hash = hashBytes(utf8->m_location->m_characters, utf8->bytesSize());
			*sp = ObjectMemoryIntegerObjectOf(hash);
			ObjectMemory::deallocateByteObject(reinterpret_cast<OTE*>(utf8));
			return sp;
		}
		case StringEncoding::Utf32:
			return primitiveFailure(_PrimitiveFailureCode::NotImplemented);

		default:
			__assume(false);
			return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
		}
	}
	else
	{
		SmallInteger hash = hashBytes(receiver->m_location->m_fields, receiver->bytesSize());
		*sp = ObjectMemoryIntegerObjectOf(hash);
		return sp;
	}
}

extern "C" SmallInteger __cdecl HashBytes(const uint8_t* bytes, size_t size)
{
	return bytes != nullptr ? hashBytes(bytes, size) : 0;
}

Oop* __fastcall Interpreter::primitiveBeginsWith(Oop* const sp, primargcount_t)
{
	Oop oopArg = *sp;
	const Utf8StringOTE* oteReceiver = reinterpret_cast<const Utf8StringOTE*>(*(sp - 1));
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		const OTE* oteArg = reinterpret_cast<const OTE*>(oopArg);
		if (oteArg->isNullTerminated())
		{
			switch (ENCODINGPAIR(oteReceiver->m_oteClass->m_location->m_instanceSpec.m_encoding, oteArg->m_oteClass->m_location->m_instanceSpec.m_encoding))
			{
			// Equivalent encodings, can compare bytes as is
			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Ansi):
			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf32):
			{
				size_t cbReceiver = oteReceiver->getSize();
				size_t cbArg = oteArg->getSize();
				OTE* oteAnswer = (cbArg <= cbReceiver &&
					memcmp(oteReceiver->m_location->m_characters,
							reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters,
							cbArg) == 0) ? Pointers.True : Pointers.False;
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				return sp - 1;
			}
			break;

			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf8):
			{
				// Ansi, UTF-8 => Convert receiver to UTF-8 via UTF16
				Utf16StringBuf utf16(m_ansiCodePage, (LPCCH)oteReceiver->m_location->m_characters, oteReceiver->getSize());
				size_t cbReceiver = utf16.ToUtf8();
				size_t cbArg = oteArg->getSize();
				if (cbArg <= cbReceiver)
				{
					char8_t* utf8 = (char8_t*)_malloca(cbReceiver);
					utf16.ToUtf8(utf8, cbReceiver);
					OTE* oteAnswer = memcmp(utf8,
											reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters,
											cbArg) == 0 ? Pointers.True : Pointers.False;
					*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
					_freea(utf8);
					return sp - 1;
				}
				else
				{
					*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
					return sp - 1;
				}
			}
			break;

			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
			{
				// Ansi, UTF-16: Convert receiver to UTF-16
				Utf16StringBuf utf16(m_ansiCodePage, (LPCCH)oteReceiver->m_location->m_characters, oteReceiver->getSize());
				size_t cbArg = oteArg->getSize();
				size_t cbReceiver = utf16.Count << 1;
				OTE* oteAnswer = (cbArg <= cbReceiver &&
					memcmp((const char16_t*)utf16,
							reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters,
							cbArg) == 0) ? Pointers.True : Pointers.False;
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				return sp - 1;
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
			{
				// UTF-8, Ansi: translate arg to UTF-8 via UTF16
				size_t cbReceiver = oteReceiver->getSize();
				Utf16StringBuf utf16(m_ansiCodePage, reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
				size_t cbArg = utf16.ToUtf8();
				if (cbArg <= cbReceiver)
				{
					char8_t* utf8 = (char8_t*)_malloca(cbArg);
					utf16.ToUtf8(utf8, cbArg);
					OTE* oteAnswer = memcmp(oteReceiver->m_location->m_characters, utf8, cbArg) == 0 ? Pointers.True : Pointers.False;
					*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
					_freea(utf8);
					return sp - 1;
				}
				else
				{
					*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
					return sp - 1;
				}
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
			{
				// UTF-8, UTF-16: Convert receiver to UTF-16

				Utf16StringBuf utf16(CP_UTF8, (LPCCH)oteReceiver->m_location->m_characters, oteReceiver->getSize());
				size_t cbArg = oteArg->getSize();
				size_t cbReceiver = utf16.Count << 1;
				OTE* oteAnswer = (cbArg <= cbReceiver &&
					memcmp((const char16_t*)utf16,
						reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters,
						cbArg) == 0) ? Pointers.True : Pointers.False;
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				return sp - 1;
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
			{
				// UTF-16, Ansi: Convert arg to UTF-16
				size_t cbReceiver = oteReceiver->getSize();
				Utf16StringBuf utf16(m_ansiCodePage, reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
				size_t cbArg = utf16.Count << 1;
				OTE* oteAnswer = (cbArg <= cbReceiver &&
					memcmp(oteReceiver->m_location->m_characters,
						(const char16_t*)utf16,
						cbArg) == 0) ? Pointers.True : Pointers.False;
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				return sp - 1;
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
			{
				// UTF-16, UTF-8: Convert arg to UTF-16
				size_t cbReceiver = oteReceiver->getSize();
				Utf16StringBuf utf16(CP_UTF8, (LPCCH)reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
				size_t cbArg = utf16.Count << 1;
				OTE* oteAnswer = (cbArg <= cbReceiver &&
					memcmp(oteReceiver->m_location->m_characters,
						(const char16_t*)utf16,
						cbArg) == 0) ? Pointers.True : Pointers.False;
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				return sp - 1;
			}
			break;

			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf32):
			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf32):
			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf32):
			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Ansi):
			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf8):
			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf16):
				return primitiveFailure(_PrimitiveFailureCode::NotImplemented);

			default:
				// Unrecognised encoding pair - fail the primitive
				return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
			}

			return sp - 1;
		}
		else
		{
			// Arg not a null terminated byte object
			return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
		}
	}
	else
	{
		// Arg is a SmallInteger
		return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

Oop* __fastcall Interpreter::primitiveStringAsUtf16String(Oop* const sp, primargcount_t)
{
	const OTE* receiver = reinterpret_cast<const OTE*>(*sp);
	switch (receiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
	{
	case StringEncoding::Ansi:
	{
		Utf16StringOTE* answer = Utf16String::New<CP_ACP>(
			reinterpret_cast<const AnsiStringOTE*>(receiver)->m_location->m_characters, receiver->getSize());
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
		return primitiveFailure(_PrimitiveFailureCode::NotImplemented);

	default:
		// Unrecognised encoding
		__assume(false);
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
	}
}

Utf16StringOTE * ST::Utf16String::New(size_t cwch)
{
	return reinterpret_cast<Utf16StringOTE*>(ObjectMemory::newUninitializedNullTermObject<Utf16String>(cwch * sizeof(Utf16String::CU)));
}

Oop * Interpreter::primitiveStringAsUtf8String(Oop * const sp, primargcount_t)
{
	const OTE* receiver = reinterpret_cast<const OTE*>(*sp);
	BehaviorOTE* oteClass = receiver->m_oteClass;
	switch (receiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
	{
	case StringEncoding::Ansi:
	{
		// Assume some kind of Ansi string
		Utf8StringOTE* answer = Utf8String::NewFromAnsi(
			reinterpret_cast<const AnsiStringOTE*>(receiver)->m_location->m_characters, receiver->getSize());
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}

	case StringEncoding::Utf8:
		return sp;

	case StringEncoding::Utf16:
	{
		Utf8StringOTE* answer = Utf8String::New(
			reinterpret_cast<const Utf16StringOTE*>(receiver)->m_location->m_characters, receiver->getSize()/sizeof(Utf16String::CU));
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf32:
		// TODO: Implement conversion for UTF-32
		return primitiveFailure(_PrimitiveFailureCode::NotImplemented);

	default:
		// Unrecognised encoding - fail the primitive
		__assume(false);
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
	}
}

Oop* __fastcall Interpreter::primitiveStringAsByteString(Oop* const sp, primargcount_t)
{
	const OTE* receiver = reinterpret_cast<const OTE*>(*sp);
	BehaviorOTE* oteClass = receiver->m_oteClass;
	switch (receiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
	{
	case StringEncoding::Ansi:
	{
		AnsiStringOTE* answer = AnsiString::New(
			reinterpret_cast<const AnsiStringOTE*>(receiver)->m_location->m_characters, receiver->getSize());
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf8:
	{
		AnsiStringOTE* answer = AnsiString::NewFromUtf8(
			reinterpret_cast<const Utf8StringOTE*>(receiver)->m_location->m_characters, receiver->getSize());
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf16:
	{
		AnsiStringOTE* answer = AnsiString::New(
			reinterpret_cast<const Utf16StringOTE*>(receiver)->m_location->m_characters, receiver->getSize() / sizeof(Utf16String::CU));
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf32:
		// TODO: Implement conversion for UTF-32
		return primitiveFailure(_PrimitiveFailureCode::NotImplemented);

	default:
		// Unrecognised encoding - fail the primitive
		__assume(false);
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
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
	const UINT cp = CP == CP_ACP ? Interpreter::m_ansiCodePage : CP;
	int cwch = ::MultiByteToWideChar(cp, 0, reinterpret_cast<LPCCH>(psz), cch, nullptr, 0);
	Utf16StringOTE* stringPointer = New(cwch);
	Utf16String::CU* pwsz = stringPointer->m_location->m_characters;
	int cwch2 = ::MultiByteToWideChar(cp, 0, reinterpret_cast<LPCCH>(psz), cch, (LPWSTR)pwsz, cwch);
	pwsz[cwch] = L'\0';
	return stringPointer;
}

Utf8StringOTE* ST::Utf8String::NewFromAnsi(const char* pChars, size_t len)
{
	// There is no Windows API for direct conversion from ANSI<->UTF8, so we need to convert to UTF16 first
	Utf16StringBuf utf16(Interpreter::m_ansiCodePage, pChars, len);
	return Utf8String::New(utf16, utf16.Count);
}

AnsiStringOTE* ST::AnsiString::NewFromUtf8(const Utf8String::CU* pChars, size_t len)
{
	Utf16StringBuf utf16(CP_UTF8, (LPCCH)pChars, len);
	return AnsiString::New(utf16, utf16.Count);
}

Oop* Interpreter::primitiveStringConcatenate(Oop* const sp, primargcount_t)
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
			switch (ENCODINGPAIR(oteReceiver->m_oteClass->m_location->m_instanceSpec.m_encoding, oteArg->m_oteClass->m_location->m_instanceSpec.m_encoding))
			{
			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Ansi):
			{
				size_t cbPrefix = oteReceiver->getSize();
				size_t cbSuffix = oteArg->getSize();
				auto oteAnswer = AnsiString::New(cbPrefix + cbSuffix);
				LPSTR psz = reinterpret_cast<AnsiStringOTE*>(oteAnswer)->m_location->m_characters;
				memcpy(psz, reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				memcpy(psz + cbPrefix, reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters, cbSuffix + sizeof(char));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
			{
				size_t cbPrefix = oteReceiver->getSize();
				size_t cbSuffix = oteArg->getSize();
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
				Utf16StringBuf utf16(m_ansiCodePage, reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
				size_t cbPrefix = utf16.ToUtf8();
				size_t cbSuffix = oteArg->getSize();
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
				LPCSTR pszReceiver = reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->m_location->m_characters;
				size_t cchReceiver = oteReceiver->getSize();
				int cwchPrefix = ::MultiByteToWideChar(m_ansiCodePage, 0, pszReceiver, cchReceiver, nullptr, 0);
				size_t cbSuffix = oteArg->getSize();
				size_t cwchSuffix = cbSuffix / sizeof(Utf16String::CU);
				auto oteAnswer = Utf16String::New(cwchPrefix + cwchSuffix);
				Utf16String::CU* pwszAnswer = oteAnswer->m_location->m_characters;
				::MultiByteToWideChar(m_ansiCodePage, 0, pszReceiver, cchReceiver, (LPWSTR)pwszAnswer, cwchPrefix);
				memcpy(pwszAnswer + cwchPrefix, reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, cbSuffix + sizeof(Utf16String::CU));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
			{
				// UTF-8, Ansi => UTF-8; but we have to translate to translate via UTF16
				// TODO: Implement a direct ANSI to UTF-8 translation

				Utf16StringBuf utf16(m_ansiCodePage, reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
				size_t cbSuffix = utf16.ToUtf8();
				size_t cbPrefix = oteReceiver->getSize();
				size_t cbAnswer = cbPrefix + cbSuffix;
				auto oteAnswer = Utf8String::New(cbAnswer);
				Utf8String::CU* psz = oteAnswer->m_location->m_characters;
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
				const Utf16String::CU* pArgChars = reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters;
				size_t cwchSuffix = oteArg->getSize() / sizeof(Utf16String::CU);
				int cbSuffix = ::WideCharToMultiByte(CP_UTF8, 0, (LPCWCH)pArgChars, cwchSuffix, nullptr, 0, nullptr, nullptr);
				ASSERT(cbSuffix >= 0);
				size_t cbPrefix = oteReceiver->getSize();
				auto oteAnswer = Utf8String::New(cbPrefix + cbSuffix);
				Utf8String::CU* psz = oteAnswer->m_location->m_characters;
				memcpy(psz, reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				::WideCharToMultiByte(CP_UTF8, 0, (LPCWCH)pArgChars, cwchSuffix + 1, reinterpret_cast<LPSTR>(psz + cbPrefix), cbSuffix + 1, nullptr, nullptr);
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
			{
				// Ansi, UTF-16 => UTF-16
				LPCSTR pszArg = reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters;
				size_t cchArg = oteArg->getSize();
				int cwchSuffix = ::MultiByteToWideChar(m_ansiCodePage, 0, pszArg, cchArg, nullptr, 0);
				ASSERT(cwchSuffix >= 0);
				size_t cbPrefix = oteReceiver->getSize();
				size_t cwchPrefix = cbPrefix / sizeof(Utf16String::CU);
				auto oteAnswer = Utf16String::New(cwchPrefix + cwchSuffix);
				Utf16String::CU* pwsz = oteAnswer->m_location->m_characters;
				memcpy(pwsz, reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				::MultiByteToWideChar(m_ansiCodePage, 0, pszArg, cchArg + 1, (LPWSTR)pwsz + cwchPrefix, cwchSuffix + 1);
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
			{
				// Since both encodings can represent any string, we return a result that is the same class as the receiver, i.e.
				// UTF-16, Utf8 => UTF-16
				auto pszArg = reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters;
				size_t cbArg = oteArg->getSize();
				int cwchSuffix = ::MultiByteToWideChar(CP_UTF8, 0, reinterpret_cast<LPCCH>(pszArg), cbArg, nullptr, 0);
				size_t cbPrefix = oteReceiver->getSize();
				size_t cwchPrefix = cbPrefix / sizeof(Utf16String::CU);
				auto oteAnswer = Utf16String::New(cwchPrefix + cwchSuffix);
				Utf16String::CU* pwszAnswer = oteAnswer->m_location->m_characters;
				const Utf16String::CU* pwszReceiver = reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters;
				memcpy(pwszAnswer, pwszReceiver, cbPrefix);
				::MultiByteToWideChar(CP_UTF8, 0, reinterpret_cast<LPCCH>(pszArg), cbArg + 1, (LPWSTR)pwszAnswer + cwchPrefix, cwchSuffix + 1);
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
			{
				// UTF-16, UTF-16 => UTF-16
				size_t cbPrefix = oteReceiver->getSize();
				size_t cbSuffix = oteArg->getSize();
				Utf16StringOTE* oteAnswer = reinterpret_cast<Utf16StringOTE*>(ObjectMemory::newUninitializedNullTermObject<Utf16String>(cbPrefix + cbSuffix));
				auto pbAnswer = reinterpret_cast<uint8_t*>(oteAnswer->m_location->m_characters);
				memcpy(pbAnswer, reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				memcpy(pbAnswer+cbPrefix, reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, cbSuffix + sizeof(Utf16String::CU));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf32):
			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf32):
			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf32):
			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf32):
			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Ansi):
			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf8):
			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf16):
				return primitiveFailure(_PrimitiveFailureCode::NotImplemented);

			default:
				// Unrecognised encoding pair - fail the primitive
				return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
			}

			return sp - 1;
		}
		else
		{
			// Arg not a null terminated byte object
			return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
		}
	}
	else
	{
		// Arg is a SmallInteger
		return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

Oop* __fastcall Interpreter::primitiveStringAsUtf32String(Oop* const sp, primargcount_t)
{
	const OTE* receiver = reinterpret_cast<const OTE*>(*sp);
	switch (receiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
	{
	case StringEncoding::Ansi:
	case StringEncoding::Utf8:
	case StringEncoding::Utf16:
		// TODO: Implement conversions to UTF-32 strings
		return primitiveFailure(_PrimitiveFailureCode::NotImplemented);

	case StringEncoding::Utf32:
		return sp;

	default:
		// Unrecognised encoding - fail the primitive.
		__assume(false);
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
	}
}
