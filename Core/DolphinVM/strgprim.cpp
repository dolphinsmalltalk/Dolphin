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
#include "STString.h"

#include "StrgPrim.h"

codepage_t Interpreter::m_ansiApiCodePage;
codepage_t Interpreter::m_ansiCodePage;
char Interpreter::m_ansiReplacementChar;
WCHAR Interpreter::m_ansiToUnicodeCharMap[256];
unsigned char Interpreter::m_unicodeToAnsiCharMap[65536];
unsigned char Interpreter::m_unicodeToBestFitAnsiCharMap[65536];

#pragma comment(lib, "icuuc.lib")

static constexpr uint32_t Fnv1aHashSeed = 2166136261U;

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

//	This is a double dispatched primitive which knows that the argument is a byte object (though
//	we still check this to avoid GPFs), and the receiver is guaranteed to be a byte object. e.g.
//
//		aByteObject replaceBytesOf: anOtherByteObject from: start to: stop startingAt: startAt
//
Oop* PRIMCALL Interpreter::primitiveReplaceBytes(Oop* const sp, primargcount_t)
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
			ptrdiff_t length = argPointer->bytesSizeForUpdate();

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
Oop* PRIMCALL Interpreter::primitiveIndirectReplaceBytes(Oop* const sp, primargcount_t)
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
Oop* PRIMCALL Interpreter::primitiveStringNextIndexOfFromTo(Oop* const sp, primargcount_t)
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
						AnsiStringOTE* oteAnsiRcvr = reinterpret_cast<AnsiStringOTE*>(oteReceiver);
						const auto length = oteAnsiRcvr->Count;
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

								AnsiString* chars = oteAnsiRcvr->m_location;

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
						const auto length = oteUtf->Count;
						// We can only be in here if to>=from, so if to>=1, then => from >= 1
						// furthermore if to <= length then => from <= length
						// It is OK for from to point to a trail surrogate
						if (from >= 1 && static_cast<size_t>(to) <= length)
						{
							// Search is in bounds, lets do it

							if (charObj->CodeUnit <= 0x7f || charObj->IsUtf8Surrogate)
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
									
									U8_NEXT(s, next, to, c);

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
						const size_t length = oteUtf->Count;
						// We can only be in here if to>=from, so if to>=1, then => from >= 1
						// furthermore if to <= length then => from <= length
						// It is OK for from to point to a trail surrogate
						if (from >= 1 && static_cast<size_t>(to) <= length)
						{
							// Search is in bounds, lets do it

							if (!charObj->IsUtfSurrogate)
							{
								char32_t codePoint = charObj->CodePoint;
								auto s = oteUtf->m_location->m_characters;
								auto offset = from - 1;
								char16_t* match = u_memchr32(s + offset, codePoint, to - offset);
								if (match != nullptr)
								{
									auto i = match - s;
									*(sp - 3) = ObjectMemoryIntegerObjectOf(i + 1);
									return sp - 3;
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
						const auto length = oteUtf->Count;
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

// Characters are not reference counted - very important that param is unsigned in order to calculate offset of
// character object in OTE correctly (otherwise chars > 127 will probably offset off the front of the OTE).
CharOTE* Character::NewUninitialized()
{
	return reinterpret_cast<CharOTE*>(ObjectMemory::newFixedPointerObject<Character::FixedSize>(Pointers.ClassCharacter));
}

Oop* PRIMCALL Interpreter::primitiveStringAt(Oop* const sp, const primargcount_t argCount)
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
					CharOTE* oteResult = Character::NewAnsi(static_cast<AnsiString::CU>(codeUnit));
					*newSp = reinterpret_cast<Oop>(oteResult);
				}
				else
				{
					// Otherwise return a UTF-8 surrogate Character
					CharOTE* character = Character::NewUninitialized();
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
						CharOTE* oteResult = Character::NewAnsi(static_cast<unsigned char>(ansiCodeUnit));
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

				CharOTE* character = Character::NewUninitialized();;
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
				StoreCharacterToStack(newSp, codePoint);
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

Oop* PRIMCALL Interpreter::primitiveStringAtPut(Oop* const sp, primargcount_t)
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
						AnsiString::CU* const __restrict pwszAnswer = reinterpret_cast<AnsiStringOTE*>(oteReceiver)->m_location->m_characters;

						// Ascii characters are the same in all encodings
						if (codeUnit <= 0x7f)
						{
							pwszAnswer[index] = static_cast<AnsiString::CU>(codeUnit);
							*newSp = oopValue;
							return newSp;
						}
						else
						{
							switch (static_cast<StringEncoding>(code >> 24))
							{
							case StringEncoding::Ansi: // Ansi char into Ansi string
								pwszAnswer[index] = static_cast<AnsiString::CU>(codeUnit);
								*newSp = oopValue;
								return newSp;

							case StringEncoding::Utf8: 
								// UTF-8 surrogate char into Ansi string - cannot be handled here
								break;

							case StringEncoding::Utf16: // UTF-16 char into Ansi string - almost certainly invalid, since we should only have UTF-16 encoded chars for surrogates
							case StringEncoding::Utf32: // UTF-32 char into Ansi string - probably invalid, since we should only have UTF-32 encoded chars for non-ANSI code points
								if (U_IS_BMP(codeUnit))
								{
									AnsiString::CU ansi = m_unicodeToBestFitAnsiCharMap[codeUnit];
									if (ansi != 0)
									{
										ASSERT(codeUnit > 0 && !U_IS_SURROGATE(codeUnit));
										pwszAnswer[index] = ansi;
										*newSp = oopValue;
										return newSp;
									}
									else if (codeUnit == UnicodeReplacementChar)
									{
										pwszAnswer[index] = m_ansiReplacementChar;
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
						Utf8String::CU* pwszAnswer = reinterpret_cast<Utf8StringOTE*>(oteReceiver)->m_location->m_characters;

						if (codeUnit <= 0x7f || static_cast<StringEncoding>(code >> 24) == StringEncoding::Utf8)
						{
							pwszAnswer[index] = static_cast<Utf8String::CU>(codeUnit);
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
						Utf16String::CU* pwszAnswer = reinterpret_cast<Utf16StringOTE*>(oteReceiver)->m_location->m_characters;

						if (codeUnit <= 0x7f)
						{
							pwszAnswer[index] = static_cast<Utf16String::CU>(codeUnit);
							*newSp = oopValue;
							return newSp;
						}
						else
						{
							switch (static_cast<StringEncoding>(code >> 24))
							{
							case StringEncoding::Ansi:
								// Non-ascii Ansi char into Utf16 string. Will always go.
								pwszAnswer[index] = m_ansiToUnicodeCharMap[codeUnit & 0xFF];
								*newSp = oopValue;
								return newSp;

							case StringEncoding::Utf8:
								// Surrogate UTF-8 char into Utf16 string - invalid, since we can't translate surrogates
								break;

							case StringEncoding::Utf16:
								// UTF-16 char into Utf16 string - always goes
								pwszAnswer[index] = static_cast<Utf16String::CU>(codeUnit);
								*newSp = oopValue;
								return newSp;

							case StringEncoding::Utf32:
								// UTF-32 char into Utf16 string - will usually go
								if (U_IS_BMP(codeUnit))
								{
									pwszAnswer[index] = static_cast<Utf16String::CU>(codeUnit);
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
						Utf32String::CU* const __restrict pwszAnswer = reinterpret_cast<Utf32StringOTE*>(oteReceiver)->m_location->m_characters;

						if (codeUnit <= 0x7f)
						{
							pwszAnswer[index] = static_cast<Utf32String::CU>(codeUnit);
							*newSp = oopValue;
							return newSp;
						}
						else
						{
							switch (static_cast<StringEncoding>(code >> 24))
							{
							case StringEncoding::Ansi:
								// Non-ascii Ansi char into Utf16 string. Will always go.
								pwszAnswer[index] = m_ansiToUnicodeCharMap[codeUnit & 0xff];
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
									pwszAnswer[index] = static_cast<Utf32String::CU>(codeUnit);
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

void Interpreter::StoreCharacterToStack(Oop* const sp, char32_t codePoint)
{
	ASSERT(U_IS_UNICODE_CHAR(codePoint));

	// Try to use one of the fixed set of ANSI chars if we can
	if (codePoint <= 0x7f)
	{
		CharOTE* oteResult = ST::Character::NewAnsi(static_cast<AnsiString::CU>(codePoint));
		*sp = reinterpret_cast<Oop>(oteResult);
		return;
	}
	else if (U_IS_BMP(codePoint))
	{
		auto ansi = m_unicodeToAnsiCharMap[codePoint];
		if (ansi != 0)
		{
			CharOTE* oteResult = ST::Character::NewAnsi(ansi);
			*sp = reinterpret_cast<Oop>(oteResult);
			return;
		}
	}

	// Otherwise represent as new Character with a Utf32 encoding (i.e. as the Unicode code point)
	CharOTE* character = Character::NewUninitialized();;
	SmallInteger code = (static_cast<SmallInteger>(StringEncoding::Utf32) << 24) | codePoint;
	character->m_location->m_code = ObjectMemoryIntegerObjectOf(code);
	character->beImmutable();
	*sp = reinterpret_cast<Oop>(character);
	ObjectMemory::AddToZct((OTE*)character);
}


Oop* PRIMCALL Interpreter::primitiveNewCharacter(Oop* const sp, primargcount_t)
{
	Oop* newSp = sp - 1;
	Oop oopArg = *newSp;
	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SmallInteger codePoint = ObjectMemoryIntegerValueOf(oopArg);

		if (U_IS_UNICODE_CHAR(codePoint))
		{
			StoreCharacterToStack(newSp, codePoint);
		}

		// Not a valid code point
		return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);
	}

	// Not a SmallInteger
	return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

Oop* Interpreter::primitiveCharacterEquals(Oop* const sp, primargcount_t)
{
	Oop oopArg = *sp;
	CharOTE* oteReceiver = reinterpret_cast<CharOTE*>(*(sp - 1));
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		CharOTE* oteArg = reinterpret_cast<CharOTE*>(oopArg);
		*(sp - 1) = (oteArg == oteReceiver || ((oteArg->m_oteClass == oteReceiver->m_oteClass) && 
												oteArg->m_location->m_code == oteReceiver->m_location->m_code))
						? reinterpret_cast<Oop>(Pointers.True)
						: reinterpret_cast<Oop>(Pointers.False);
		return sp - 1;
	}
	else
	{
		*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
		return sp - 1;
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

__forceinline uint32_t foldHash(uint32_t hash)
{
	// Xor-fold down to 30 bits so it will always fit in a SmallInteger. 
	// Folding gives slightly better results than just truncating
	return (hash >> 30) ^ (hash & 0x3FFFFFFF);
}

__forceinline uint32_t hashCombine(uint32_t hash, uint8_t byte)
{
	return (hash ^ static_cast<uint32_t>(byte)) * 16777619;
}

struct NextAnsi
{
	__forceinline char32_t operator() (const AnsiString::CU* pch, size_t& i) const
	{
		unsigned char ch = static_cast<unsigned char>(pch[i++]);
		return ch <= 0x7f ? ch : Interpreter::m_ansiToUnicodeCharMap[ch];
	}
};

// icu macros may trigger assign smaller runtime check in debug build
#pragma runtime_checks( "c", off)
struct NextUtf8
{
	__forceinline char32_t operator() (const Utf8String::CU* pch, size_t& i) const
	{
		char32_t ch;
		U8_NEXT_UNSAFE(pch, i, ch);
		return ch;
	}
};

struct NextUtf16
{
	__forceinline char32_t operator() (const Utf16String::CU* pch, size_t& i) const
	{
		char32_t ch;
		U16_NEXT_UNSAFE(pch, i, ch);
		return ch;
	}
};
#pragma runtime_checks( "c", restore)

template <class T> struct NextChar
{
	__forceinline char32_t operator() (const T* pch, size_t& i) const
	{
		return pch[i++];
	}
};

template <class CH, class Next=NextChar<CH>> uint32_t hashString(const CH* pch, size_t byteSize)
{
	size_t cch = byteSize / sizeof(CH);
	uint32_t hash = Fnv1aHashSeed;
	size_t i = 0;

	while (i < cch)
	{
		char32_t ch = Next()(pch, i);
		if (ch <= 0x7f)
		{
			hash = hashCombine(hash, static_cast<uint8_t>(ch));
		}
		else
		{
			// For non-ascii characters translate the code point to its UTF-8 byte sequence, and combine that sequence into the hash
			if (ch <= 0x7ff)
			{
				hash = hashCombine(hash, static_cast<uint8_t>((ch >> 6) | 0xc0));
			}
			else
			{
				if (ch <= 0xffff)
				{
					hash = hashCombine(hash, static_cast<uint8_t>((ch >> 12) | 0xe0));
				}
				else
				{
					hash = hashCombine(hash, static_cast<uint8_t>((ch >> 18) | 0xf0));
					hash = hashCombine(hash, static_cast<uint8_t>(((ch >> 12) & 0x3f) | 0x80));
				}
				hash = hashCombine(hash, static_cast<uint8_t>(((ch >> 6) & 0x3f) | 0x80));
			}
			hash = hashCombine(hash, static_cast<uint8_t>((ch & 0x3f) | 0x80));
		}
	}

	return foldHash(hash);
}

template <class T, class Next=NextChar<T>> struct NextFolded
{
	__forceinline char32_t operator() (const T* pch, size_t& i) const
	{
		char32_t ch = Next()(pch, i);
		return ch >= 'A' && ch <= 'Z' ? (ch-'A' + 'a') : u_foldCase(ch, U_FOLD_CASE_DEFAULT);
	}
};

inline uint32_t __fastcall hashBytes(const uint8_t* bytes, size_t len)
{
	const uint8_t* stop = bytes + len;
	uint32_t hash = Fnv1aHashSeed;

	while (bytes < stop)
	{
		hash = hashCombine(hash, *bytes++);
	}

	return foldHash(hash);
}

Oop* PRIMCALL Interpreter::primitiveHashBytes(Oop* const sp, primargcount_t)
{
	BytesOTE* receiver = reinterpret_cast<BytesOTE*>(*sp);

	if (receiver->isNullTerminated())
	{
		// Strings are always hashed as if UTF-8 encoded in order that equal strings in different encodings
		// have the same hash.

		switch (receiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
		{
		case StringEncoding::Ansi:
		{
			auto ansiString = reinterpret_cast<ST::AnsiString*>(receiver->m_location);
			SmallInteger hash = hashString<AnsiString::CU, NextAnsi>(ansiString->m_characters, receiver->bytesSize());
			*sp = ObjectMemoryIntegerObjectOf(hash);
			return sp;
		}

		case StringEncoding::Utf8:
		{
			auto utf8 = reinterpret_cast<ST::Utf8String*>(receiver->m_location);
			SmallInteger hash = hashBytes(reinterpret_cast<const uint8_t*>(utf8->m_characters), receiver->bytesSize());
			*sp = ObjectMemoryIntegerObjectOf(hash);
			return sp;
		}

		case StringEncoding::Utf16:
		{
			auto utf16 = reinterpret_cast<ST::Utf16String*>(receiver->m_location);
			SmallInteger hash = hashString<Utf16String::CU, NextUtf16>(utf16->m_characters, receiver->bytesSize());
			*sp = ObjectMemoryIntegerObjectOf(hash);
			return sp;
		}

		case StringEncoding::Utf32:
		{
			auto utf32 = reinterpret_cast<ST::Utf32String*>(receiver->m_location);
			SmallInteger hash = hashString<char32_t>(utf32->m_characters, receiver->bytesSize());
			*sp = ObjectMemoryIntegerObjectOf(hash);
			return sp;
		}

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

Oop* PRIMCALL Interpreter::primitiveOrdinalHashIgnoreCase(Oop* const sp, primargcount_t)
{
	BytesOTE* receiver = reinterpret_cast<BytesOTE*>(*sp);

	switch (receiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
	{
	case StringEncoding::Ansi:
	{
		auto ansiString = reinterpret_cast<ST::AnsiString*>(receiver->m_location);
		SmallInteger hash = hashString<AnsiString::CU, NextFolded<AnsiString::CU, NextAnsi>>(ansiString->m_characters, receiver->bytesSize());
		*sp = ObjectMemoryIntegerObjectOf(hash);
		return sp;
	}

	case StringEncoding::Utf8:
	{
		auto utf8 = reinterpret_cast<ST::Utf8String*>(receiver->m_location);
		SmallInteger hash = hashString<Utf8String::CU, NextFolded<Utf8String::CU, NextUtf8>>(utf8->m_characters, receiver->bytesSize());
		*sp = ObjectMemoryIntegerObjectOf(hash);
		return sp;
	}

	case StringEncoding::Utf16:
	{
		auto utf16 = reinterpret_cast<ST::Utf16String*>(receiver->m_location);
		SmallInteger hash = hashString<Utf16String::CU, NextFolded<Utf16String::CU, NextUtf16>>(utf16->m_characters, receiver->bytesSize());
		*sp = ObjectMemoryIntegerObjectOf(hash);
		return sp;
	}

	case StringEncoding::Utf32:
	{
		auto utf32 = reinterpret_cast<ST::Utf32String*>(receiver->m_location);
		SmallInteger hash = hashString<char32_t, NextFolded<char32_t>>(utf32->m_characters, receiver->bytesSize());
		*sp = ObjectMemoryIntegerObjectOf(hash);
		return sp;
	}

	default:
		__assume(false);
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Primitive templates

Oop* PRIMCALL Interpreter::primitiveStringCompareOrdinal(Oop* const sp, primargcount_t)
{
	Oop oopComparand = *(sp - 1);
	const OTE* oteReceiver = reinterpret_cast<const OTE*>(*(sp - 2));
	if (!ObjectMemoryIsIntegerObject(oopComparand))
	{
		const OTE* oteComparand = reinterpret_cast<const OTE*>(oopComparand);
		if (oteComparand != oteReceiver)
		{
			if (oteComparand->isNullTerminated())
			{
				bool ignoreCase = reinterpret_cast<POTE>(*sp) == Pointers.True;

				switch (ENCODINGPAIR(oteReceiver->m_oteClass->m_location->m_instanceSpec.m_encoding, oteComparand->m_oteClass->m_location->m_instanceSpec.m_encoding))
				{
				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Ansi):
				{
					// This is the one case where we can use an Ansi comparison. It can't (generally) be used for CP_UTF8.
					auto oteAnsiRcvr = reinterpret_cast<const AnsiStringOTE*>(oteReceiver);
					auto oteAnsiArg = reinterpret_cast<const AnsiStringOTE*>(oteComparand);
					int cmp = ignoreCase ?
						CmpOrdinalIA()(oteAnsiRcvr->m_location->m_characters, oteAnsiRcvr->Count, oteAnsiArg->m_location->m_characters, oteAnsiArg->Count)
						: CmpOrdinalA()(oteAnsiRcvr->m_location->m_characters, oteAnsiRcvr->Count, oteAnsiArg->m_location->m_characters, oteAnsiArg->Count);
					*(sp - 2) = integerObjectOf(cmp);
					return sp - 2;
				}

				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf8):
				{
					Utf16StringBuf receiverW(reinterpret_cast<const AnsiStringOTE*>(oteReceiver));
					Utf16StringBuf argW(reinterpret_cast<const Utf8StringOTE*>(oteComparand));
					int cmp = ignoreCase ?
						CmpOrdinalIW()(receiverW, receiverW.Count, argW, argW.Count)
						: CmpOrdinalW()(receiverW, receiverW.Count, argW, argW.Count);
					*(sp - 2) = integerObjectOf(cmp);
					return sp - 2;				}

				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
				{
					Utf16StringBuf receiverW(reinterpret_cast<const AnsiStringOTE*>(oteReceiver));
					auto oteUtf16Arg = reinterpret_cast<const Utf16StringOTE*>(oteComparand);
					int cmp = ignoreCase ?
						CmpOrdinalIW()(receiverW, receiverW.Count, oteUtf16Arg->m_location->m_characters, oteUtf16Arg->Count)
						: CmpOrdinalW()(receiverW, receiverW.Count, oteUtf16Arg->m_location->m_characters, oteUtf16Arg->Count);
					*(sp - 2) = integerObjectOf(cmp);
					return sp - 2;
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
				{
					Utf16StringBuf receiverW(reinterpret_cast<const Utf8StringOTE*>(oteReceiver));
					Utf16StringBuf argW(reinterpret_cast<const AnsiStringOTE*>(oteComparand));
					int cmp = ignoreCase ?
						CmpOrdinalIW()(receiverW, receiverW.Count, argW, argW.Count)
						: CmpOrdinalW()(receiverW, receiverW.Count, argW, argW.Count);
					*(sp - 2) = integerObjectOf(cmp);
					return sp - 2;
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
				{
					auto oteUtf8Rcvr = reinterpret_cast<const Utf8StringOTE*>(oteReceiver);
					auto oteUtf8Arg = reinterpret_cast<const Utf8StringOTE*>(oteComparand);
					if (ignoreCase)
					{
						Utf16StringBuf receiverW(oteUtf8Rcvr);
						Utf16StringBuf argW(oteUtf8Arg);
						int cmp = CmpOrdinalIW()(receiverW, receiverW.Count, argW, argW.Count);
						*(sp - 2) = integerObjectOf(cmp);
						return sp - 2;
					}
					else
					{
						int cmp = CmpOrdinalA()(
								reinterpret_cast<LPCSTR>(oteUtf8Rcvr->m_location->m_characters), oteUtf8Rcvr->Count,
								reinterpret_cast<LPCSTR>(oteUtf8Arg->m_location->m_characters), oteUtf8Arg->Count);
						*(sp - 2) = integerObjectOf(cmp);
						return sp - 2;
					}
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
				{
					Utf16StringBuf receiverW(reinterpret_cast<const Utf8StringOTE*>(oteReceiver));
					auto oteUtf16Arg = reinterpret_cast<const Utf16StringOTE*>(oteComparand);
					int cmp = ignoreCase ?
						CmpOrdinalIW()(receiverW, receiverW.Count, oteUtf16Arg->m_location->m_characters, oteUtf16Arg->Count)
						: CmpOrdinalW()(receiverW, receiverW.Count, oteUtf16Arg->m_location->m_characters, oteUtf16Arg->Count);
					*(sp - 2) = integerObjectOf(cmp);
					return sp - 2;
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
				{
					auto oteUtf16Rcvr = reinterpret_cast<const Utf16StringOTE*>(oteReceiver);
					Utf16StringBuf argW(reinterpret_cast<const AnsiStringOTE*>(oteComparand));
					int cmp = ignoreCase ?
						CmpOrdinalIW()(oteUtf16Rcvr->m_location->m_characters, oteUtf16Rcvr->Count, argW, argW.Count)
						: CmpOrdinalW()(oteUtf16Rcvr->m_location->m_characters, oteUtf16Rcvr->Count, argW, argW.Count);
					*(sp - 2) = integerObjectOf(cmp);
					return sp - 2;
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
				{
					auto oteUtf16Rcvr = reinterpret_cast<const Utf16StringOTE*>(oteReceiver);
					auto oteUtf8Arg = reinterpret_cast<const Utf8StringOTE*>(oteComparand);
					if (ignoreCase)
					{
						Utf16StringBuf argW(oteUtf8Arg);
						int cmp = CmpOrdinalIW()(oteUtf16Rcvr->m_location->m_characters, oteUtf16Rcvr->Count, argW, argW.Count);
						*(sp - 2) = integerObjectOf(cmp);
						return sp - 2;
					}
					else
					{
						Utf8StringBuf rcvr8(oteUtf16Rcvr);
						int cmp = CmpOrdinalA()(
							reinterpret_cast<LPCSTR>(static_cast<const char8_t*>(rcvr8)), rcvr8.Count,
							reinterpret_cast<LPCSTR>(oteUtf8Arg->m_location->m_characters), oteUtf8Arg->Count);
						*(sp - 2) = integerObjectOf(cmp);
						return sp - 2;
					}
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
				{
					auto oteUtf16Rcvr = reinterpret_cast<const Utf16StringOTE*>(oteReceiver);
					auto oteUtf16Arg = reinterpret_cast<const Utf16StringOTE*>(oteComparand);
					int cmp = ignoreCase ? 
						CmpOrdinalIW()(oteUtf16Rcvr->m_location->m_characters, oteUtf16Rcvr->Count, oteUtf16Arg->m_location->m_characters, oteUtf16Arg->Count)
						: CmpOrdinalW()(oteUtf16Rcvr->m_location->m_characters, oteUtf16Rcvr->Count, oteUtf16Arg->m_location->m_characters, oteUtf16Arg->Count);
					*(sp - 2) = integerObjectOf(cmp);
					return sp - 2;
				}

				// Utf32 isn't supported currently
				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Ansi):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf8):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf16):
					return Interpreter::primitiveFailure(_PrimitiveFailureCode::NotImplemented);
				default:
					__assume(false);
					return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
				}
			}
			else
			{
				// Arg not a null terminated byte object
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
			}
		}
		else
		{
			// Identical
			*(sp - 2) = ZeroPointer;
			return sp - 2;
		}
	}
	else
	{
		// Arg is a SmallInteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

template <class OpA, class OpW> static Oop* PRIMCALL Interpreter::primitiveStringComparison(Oop* const sp, primargcount_t)
{
	Oop oopArg = *sp;
	const OTE* oteReceiver = reinterpret_cast<const OTE*>(*(sp - 1));
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		const OTE* oteComparand = reinterpret_cast<const OTE*>(oopArg);
		if (oteComparand != oteReceiver)
		{
			if (oteComparand->isNullTerminated())
			{
				// Could double-dispatch this rather than handling all this in one
				// primitive, or at least define one primitive for each string class, but it would mean
				// adding quite a lot of methods, so this keeps the ST side cleaner by hiding the switch in the VM.
				// This should also be faster as the intermediate conversions can usually be performed on the stack
				// and so do not require any allocations.
				switch (ENCODINGPAIR(oteReceiver->m_oteClass->m_location->m_instanceSpec.m_encoding, oteComparand->m_oteClass->m_location->m_instanceSpec.m_encoding))
				{
				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Ansi):
				{
					// This is the one case where we can use an Ansi comparison. It can't (generally) be used for UTF-8.
					auto oteAnsiRcvr = reinterpret_cast<const AnsiStringOTE*>(oteReceiver);
					auto oteAnsiArg = reinterpret_cast<const AnsiStringOTE*>(oteComparand);
					int cmp = OpA()(oteAnsiRcvr->m_location->m_characters, oteAnsiRcvr->Count, oteAnsiArg->m_location->m_characters, oteAnsiArg->Count);
					*(sp - 1) = integerObjectOf(cmp);
					return sp - 1;
				}

				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf8):
				{
					Utf16StringBuf receiverW(reinterpret_cast<const AnsiStringOTE*>(oteReceiver));
					Utf16StringBuf argW(reinterpret_cast<const Utf8StringOTE*>(oteComparand));
					int cmp = OpW()(receiverW, receiverW.Count, argW, argW.Count);
					*(sp - 1) = integerObjectOf(cmp);
					return sp - 1;				}

				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
				{
					Utf16StringBuf receiverW(reinterpret_cast<const AnsiStringOTE*>(oteReceiver));
					auto oteUtf16Arg = reinterpret_cast<const Utf16StringOTE*>(oteComparand);
					int cmp = OpW()(receiverW, receiverW.Count, oteUtf16Arg->m_location->m_characters, oteUtf16Arg->Count);
					*(sp - 1) = integerObjectOf(cmp);
					return sp - 1;
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
				{
					Utf16StringBuf receiverW(reinterpret_cast<const Utf8StringOTE*>(oteReceiver));
					Utf16StringBuf argW(reinterpret_cast<const AnsiStringOTE*>(oteComparand));
					int cmp = OpW()(receiverW, receiverW.Count, argW, argW.Count);
					*(sp - 1) = integerObjectOf(cmp);
					return sp - 1;
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
				{
					auto oteUtf8Rcvr = reinterpret_cast<const Utf8StringOTE*>(oteReceiver);
					auto oteUtf8Arg = reinterpret_cast<const Utf8StringOTE*>(oteComparand);
					Utf16StringBuf receiverW(oteUtf8Rcvr);
					Utf16StringBuf argW(oteUtf8Arg);
					int cmp = OpW()(receiverW, receiverW.Count, argW, argW.Count);
					*(sp - 1) = integerObjectOf(cmp);
					return sp - 1;
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
				{
					Utf16StringBuf receiverW(reinterpret_cast<const Utf8StringOTE*>(oteReceiver));
					auto oteUtf16Arg = reinterpret_cast<const Utf16StringOTE*>(oteComparand);
					int cmp = OpW()(receiverW, receiverW.Count, oteUtf16Arg->m_location->m_characters, oteUtf16Arg->Count);
					*(sp - 1) = integerObjectOf(cmp);
					return sp - 1;
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
				{
					auto oteUtf16Rcvr = reinterpret_cast<const Utf16StringOTE*>(oteReceiver);
					Utf16StringBuf argW(reinterpret_cast<const AnsiStringOTE*>(oteComparand));
					int cmp = OpW()(oteUtf16Rcvr->m_location->m_characters, oteUtf16Rcvr->Count, argW, argW.Count);
					*(sp - 1) = integerObjectOf(cmp);
					return sp - 1;
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
				{
					auto oteUtf16Rcvr = reinterpret_cast<const Utf16StringOTE*>(oteReceiver);
					auto oteUtf8Arg = reinterpret_cast<const Utf8StringOTE*>(oteComparand);
					Utf16StringBuf argW(oteUtf8Arg);
					int cmp = OpW()(oteUtf16Rcvr->m_location->m_characters, oteUtf16Rcvr->Count, argW, argW.Count);
					*(sp - 1) = integerObjectOf(cmp);
					return sp - 1;
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
				{
					auto oteUtf16Rcvr = reinterpret_cast<const Utf16StringOTE*>(oteReceiver);
					auto oteUtf16Arg = reinterpret_cast<const Utf16StringOTE*>(oteComparand);
					int cmp = OpW()(oteUtf16Rcvr->m_location->m_characters, oteUtf16Rcvr->Count, oteUtf16Arg->m_location->m_characters, oteUtf16Arg->Count);
					*(sp - 1) = integerObjectOf(cmp);
					return sp - 1;
				}

				// Utf32 isn't supported currently
				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Ansi):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf8):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf16):
					return Interpreter::primitiveFailure(_PrimitiveFailureCode::NotImplemented);
				default:
					__assume(false);
					return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
				}
			}
			else
			{
				// Arg not a null terminated byte object
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
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
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

template Oop* Interpreter::primitiveStringComparison<CmpA, CmpW>(Oop* const, primargcount_t);
template Oop* Interpreter::primitiveStringComparison<CmpIA, CmpIW>(Oop* const, primargcount_t);

inline bool Utf8StringOTE::operator<=(const AnsiStringOTE* __restrict oteComperand) const
{
	Utf16StringBuf receiverW(this);
	Utf16StringBuf argW(oteComperand);
	return CmpIW()(receiverW, receiverW.Count, argW, argW.Count) <= 0;
}

inline bool Utf8StringOTE::operator<=(const Utf8StringOTE* __restrict oteComperand) const
{
	Utf16StringBuf receiverW(this);
	Utf16StringBuf argW(oteComperand);
	return CmpIW()(receiverW, receiverW.Count, argW, argW.Count) <= 0;
}

inline bool Utf8StringOTE::operator<=(const Utf16StringOTE* __restrict oteComperand) const
{
	Utf16StringBuf receiverW(this);
	return CmpIW()(receiverW, receiverW.Count, oteComperand->m_location->m_characters, oteComperand->Count) <= 0;
}

inline bool Utf16StringOTE::operator<=(const Utf16StringOTE* __restrict oteComperand) const
{
	return CmpIW()(m_location->m_characters, Count, oteComperand->m_location->m_characters, oteComperand->Count) <= 0;
}

inline bool Utf16StringOTE::operator<=(const AnsiStringOTE* __restrict oteComperand) const
{
	Utf16StringBuf argW(oteComperand);
	return CmpIW()(m_location->m_characters, Count, argW, argW.Count) <= 0;
}

inline bool Utf16StringOTE::operator<=(const Utf8StringOTE* __restrict oteComperand) const
{
	Utf16StringBuf argW(oteComperand);
	return CmpIW()(m_location->m_characters, Count, argW, argW.Count) <= 0;
}

inline bool AnsiStringOTE::operator<=(const AnsiStringOTE* __restrict oteComperand) const
{
	return CmpIA()(m_location->m_characters, Count, oteComperand->m_location->m_characters, oteComperand->Count) <= 0;
}

inline bool AnsiStringOTE::operator<=(const Utf8StringOTE* __restrict oteComperand) const
{
	Utf16StringBuf receiverW(this);
	Utf16StringBuf argW(oteComperand);
	return CmpIW()(receiverW, receiverW.Count, argW, argW.Count) <= 0;
}

inline bool AnsiStringOTE::operator<=(const Utf16StringOTE* __restrict oteComperand) const
{
	Utf16StringBuf receiverW(this);
	return CmpIW()(receiverW, receiverW.Count, oteComperand->m_location->m_characters, oteComperand->Count) <= 0;
}

Oop* PRIMCALL Interpreter::primitiveStringLessOrEqual(Oop* sp, primargcount_t)
{
	Oop oopArg = *sp;
	const OTE** __restrict tos = (const OTE**)(sp - 1);
	const OTE* oteReceiver = *tos;
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		const OTE* oteArg = reinterpret_cast<const OTE*>(oopArg);
		if (oteArg != oteReceiver)
		{
			if (oteArg->isNullTerminated())
			{
				switch (ENCODINGPAIR(oteReceiver->m_oteClass->m_location->m_instanceSpec.m_encoding, oteArg->m_oteClass->m_location->m_instanceSpec.m_encoding))
				{
				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Ansi):
				{
					*tos = *reinterpret_cast<const AnsiStringOTE*>(oteReceiver) <= reinterpret_cast<const AnsiStringOTE*>(oteArg)
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
				{
					*tos = *reinterpret_cast<const Utf8StringOTE*>(oteReceiver) <= reinterpret_cast<const Utf8StringOTE*>(oteArg)
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
				{
					*tos = *reinterpret_cast<const Utf8StringOTE*>(oteReceiver) <= reinterpret_cast<const AnsiStringOTE*>(oteArg)
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf8):
				{
					*tos = *reinterpret_cast<const AnsiStringOTE*>(oteReceiver) <= reinterpret_cast<const Utf8StringOTE*>(oteArg)
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
				{
					*tos = *reinterpret_cast<const Utf16StringOTE*>(oteReceiver) <= reinterpret_cast<const AnsiStringOTE*>(oteArg)
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
				{
					*tos = *reinterpret_cast<const AnsiStringOTE*>(oteReceiver) <= reinterpret_cast<const Utf16StringOTE*>(oteArg)
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
				{
					*tos = *reinterpret_cast<const Utf8StringOTE*>(oteReceiver) <= reinterpret_cast<const Utf16StringOTE*>(oteArg)
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
				{
					*tos = *reinterpret_cast<const Utf16StringOTE*>(oteReceiver) <= reinterpret_cast<const Utf8StringOTE*>(oteArg)
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
				{
					*tos = *reinterpret_cast<const Utf16StringOTE*>(oteReceiver) <= reinterpret_cast<const Utf16StringOTE*>(oteArg)
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				// Utf32 isn't supported currently
				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Ansi):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf8):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf16):
					return Interpreter::primitiveFailure(_PrimitiveFailureCode::NotImplemented);
				default:
					__assume(false);
					return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
				}
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

Oop* PRIMCALL Interpreter::primitiveStringOrdinalEqual(Oop* const sp, primargcount_t argc)
{
	Oop oopArg = *sp;
	const OTE** __restrict tos = (const OTE**)(sp - 1);
	const OTE* oteReceiver = *tos;
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		const OTE* oteArg = reinterpret_cast<const OTE*>(oopArg);
		if (oteArg != oteReceiver)
		{
			if (oteArg->isNullTerminated())
			{
				switch (ENCODINGPAIR(oteReceiver->m_oteClass->m_location->m_instanceSpec.m_encoding, oteArg->m_oteClass->m_location->m_instanceSpec.m_encoding))
				{
				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Ansi):
				{
					*tos = reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->OrdinalEquals(reinterpret_cast<const AnsiStringOTE*>(oteArg))
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
				{
					*tos = reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->OrdinalEquals(reinterpret_cast<const Utf8StringOTE*>(oteArg)) 
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
				{
					*tos = reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->OrdinalEquals(reinterpret_cast<const AnsiStringOTE*>(oteArg))  
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf8):
				{
					*tos = reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->OrdinalEquals(reinterpret_cast<const Utf8StringOTE*>(oteArg))
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
				{
					*tos = reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->OrdinalEquals(reinterpret_cast<const AnsiStringOTE*>(oteArg))  
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
				{
					*tos = reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->OrdinalEquals(reinterpret_cast<const Utf16StringOTE*>(oteArg))  
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
				{
					*tos = reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->OrdinalEquals(reinterpret_cast<const Utf16StringOTE*>(oteArg)) 
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
				{
					*tos = reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->OrdinalEquals(reinterpret_cast<const Utf8StringOTE*>(oteArg)) 
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
				{
					*tos = reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->OrdinalEquals(reinterpret_cast<const Utf16StringOTE*>(oteArg)) 
						? Pointers.True : Pointers.False;
					return (Oop*)tos;
				}

				// Utf32 isn't supported currently
				case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf32):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Ansi):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf8):
				case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf16):
					return Interpreter::primitiveFailure(_PrimitiveFailureCode::NotImplemented);
				default:
					__assume(false);
				}
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
			*tos = Pointers.True;
			return (Oop*)tos;
		}
	}
	else
	{
		// Arg is a SmallInteger
		return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

bool Utf8StringOTE::OrdinalEquals(const Utf8StringOTE* __restrict oteUtf8) const
{
	size_t cch1 = Count;
	size_t cch2 = oteUtf8->Count;
	return cch1 == cch2 && memcmp(m_location->m_characters, oteUtf8->m_location->m_characters, cch2) == 0;
}

bool AnsiStringOTE::OrdinalEquals(const AnsiStringOTE* __restrict oteComperand) const
{
	size_t cch1 = Count;
	size_t cch2 = oteComperand->Count;
	return cch1 == cch2 && memcmp(m_location->m_characters, oteComperand->m_location->m_characters, cch2) == 0;
}

bool AnsiStringOTE::OrdinalEquals(const Utf8StringOTE* __restrict oteComperand) const
{
	return oteComperand->OrdinalEquals(this);
}

bool AnsiStringOTE::OrdinalEquals(const Utf16StringOTE* __restrict oteComperand) const
{
	return oteComperand->OrdinalEquals(this);
}

bool Utf16StringOTE::OrdinalEquals(const Utf16StringOTE* __restrict oteUtf16) const
{
	return CmpOrdinalW()(m_location->m_characters, Count, oteUtf16->m_location->m_characters, oteUtf16->Count) == 0;
}


Oop* PRIMCALL Interpreter::primitiveBeginsWith(Oop* const sp, primargcount_t)
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
				Utf8StringBuf utf8Receiver(reinterpret_cast<const AnsiStringOTE*>(oteReceiver));
				size_t cch8Arg = oteArg->getSize();
				OTE* oteAnswer = cch8Arg <= utf8Receiver.Count && memcmp((const char8_t*)utf8Receiver,
										reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters,
										cch8Arg) == 0 ? Pointers.True : Pointers.False;
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				return sp - 1;
			}
			break;

			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
			{
				// Ansi, UTF-16: Convert receiver to UTF-16
				Utf16StringBuf utf16Receiver(reinterpret_cast<const AnsiStringOTE*>(oteReceiver));
				size_t cbArg = oteArg->getSize();
				size_t cbReceiver = utf16Receiver.Count << 1;
				OTE* oteAnswer = (cbArg <= cbReceiver &&
					memcmp((const char16_t*)utf16Receiver,
							reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters,
							cbArg) == 0) ? Pointers.True : Pointers.False;
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				return sp - 1;
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
			{
				// UTF-8, Ansi: translate arg to UTF-8
				Utf8StringBuf utf8Arg(reinterpret_cast<const AnsiStringOTE*>(oteArg));
				size_t cch8Arg = utf8Arg.Count;
				OTE* oteAnswer = cch8Arg <= oteReceiver->getSize() &&
						memcmp(oteReceiver->m_location->m_characters, (const char8_t*)utf8Arg, cch8Arg) == 0 ? Pointers.True : Pointers.False;
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				return sp - 1;
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
			{
				// UTF-8, UTF-16: Convert receiver to UTF-16

				Utf16StringBuf utf16(oteReceiver);
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
				Utf16StringBuf utf16(reinterpret_cast<const AnsiStringOTE*>(oteArg));
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
				Utf16StringBuf utf16(reinterpret_cast<const Utf8StringOTE*>(oteArg));
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
				__assume(false);
				return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
			}
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

Oop* PRIMCALL Interpreter::primitiveStringConcatenate(Oop* const sp, primargcount_t)
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
				size_t cchPrefix = oteReceiver->getSize();
				size_t cchSuffix = oteArg->getSize();
				AnsiStringOTE* oteAnswer = AnsiString::New(cchPrefix + cchSuffix);
				auto psz = oteAnswer->m_location->m_characters;
				memcpy(psz, reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->m_location->m_characters, cchPrefix);
				memcpy(psz + cchPrefix, reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters, cchSuffix + sizeof(AnsiString::CU));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
			{
				size_t cch8Prefix = oteReceiver->getSize();
				size_t cch8Suffix = oteArg->getSize();
				Utf8StringOTE* oteAnswer = Utf8String::New(cch8Prefix + cch8Suffix);
				auto psz = oteAnswer->m_location->m_characters;
				memcpy(psz, reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, cch8Prefix);
				memcpy(psz + cch8Prefix, reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters, cch8Suffix + sizeof(Utf8String::CU));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf8):
			{
				// Ansi, UTF-8 => UTF-8
				auto pszPrefix = reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->m_location->m_characters;
				size_t cchPrefix = oteReceiver->getSize();
				size_t cch8Prefix = Utf8StringBuf::LengthOfAnsi(pszPrefix, cchPrefix);
				size_t cch8Suffix = oteArg->getSize();
				Utf8StringOTE* oteAnswer = Utf8String::New(cch8Prefix + cch8Suffix);
				auto pszAnswer = oteAnswer->m_location->m_characters;
				Utf8StringBuf::ConvertAnsi_unsafe(pszPrefix, cchPrefix, pszAnswer, cch8Prefix);
				// Append suffix including null terminator
				memcpy(pszAnswer + cch8Prefix, reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters, cch8Suffix + sizeof(Utf8String::CU));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
			{
				// Ansi, UTF-16 => UTF-16
				auto pszPrefix = reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->m_location->m_characters;
				size_t cchPrefix = oteReceiver->getSize();
				size_t cwchPrefix = Utf16StringBuf::LengthOfAnsi(pszPrefix, cchPrefix);
				size_t cbSuffix = oteArg->getSize();
				size_t cwchSuffix = cbSuffix / sizeof(Utf16String::CU);
				Utf16StringOTE* oteAnswer = Utf16String::New(cwchPrefix + cwchSuffix);
				auto pwszAnswer = oteAnswer->m_location->m_characters;
				Utf16StringBuf::ConvertAnsi_unsafe(pszPrefix, cchPrefix, pwszAnswer);
				memcpy(pwszAnswer + cwchPrefix, reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, cbSuffix + sizeof(Utf16String::CU));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
			{
				// UTF-8, Ansi => UTF-8
				auto pszSuffix = reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters;
				size_t cchSuffix = oteArg->getSize();
				size_t cch8Suffix = Utf8StringBuf::LengthOfAnsi(pszSuffix, cchSuffix);
				size_t cch8Prefix = oteReceiver->getSize();
				Utf8StringOTE* oteAnswer = Utf8String::New(cch8Prefix + cch8Suffix);
				auto psz8Answer = oteAnswer->m_location->m_characters;
				memcpy(psz8Answer, reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, cch8Prefix);
				char8_t* pEnd = Utf8StringBuf::ConvertAnsi_unsafe(pszSuffix, cchSuffix, psz8Answer + cch8Prefix, cch8Suffix);
				ASSERT(pEnd == (psz8Answer + cch8Prefix + cch8Suffix));
				*pEnd = '\0';
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
			{
				// Since both encodings can represent any string, we return a result that is the same class as the receiver, i.e.
				// UTF-8, Utf16 => UTF-8
				auto pwszSuffix = reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters;
				size_t cwchSuffix = oteArg->getSize() / sizeof(Utf16String::CU);
				size_t cch8Suffix = Utf8StringBuf::LengthOfUtf16(pwszSuffix, cwchSuffix);
				size_t cch8Prefix = oteReceiver->getSize();
				size_t cch8Answer = cch8Prefix + cch8Suffix;
				Utf8StringOTE* oteAnswer = Utf8String::New(cch8Answer);
				auto psz8Answer = oteAnswer->m_location->m_characters;
				memcpy(psz8Answer, reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, cch8Prefix);
				char8_t* pEnd = Utf8StringBuf::ConvertUtf16_unsafe(pwszSuffix, cwchSuffix, psz8Answer + cch8Prefix, cch8Suffix);
				ASSERT(pEnd == (psz8Answer + cch8Prefix + cch8Suffix));
				*pEnd = '\0';
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
			{
				// Ansi, UTF-16 => UTF-16
				auto pszSuffix = reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters;
				size_t cchSuffix = oteArg->getSize();
				size_t cwchSuffix = Utf16StringBuf::LengthOfAnsi(pszSuffix, cchSuffix);
				ASSERT(cwchSuffix >= 0);
				size_t cbPrefix = oteReceiver->getSize();
				size_t cwchPrefix = cbPrefix / sizeof(Utf16String::CU);
				Utf16StringOTE* oteAnswer = Utf16String::New(cwchPrefix + cwchSuffix);
				auto pwszAnswer = oteAnswer->m_location->m_characters;
				memcpy(pwszAnswer, reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				char16_t* pEnd = Utf16StringBuf::ConvertAnsi_unsafe(pszSuffix, cchSuffix, pwszAnswer + cwchPrefix);
				ASSERT(pEnd == (pwszAnswer + cwchPrefix + cwchSuffix));
				*pEnd = L'\0';
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
			{
				// Since both encodings can represent any string, we return a result that is the same class as the receiver, i.e.
				// UTF-16, Utf8 => UTF-16
				auto psz8Suffix = reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters;
				size_t cch8Suffix = oteArg->getSize();
				size_t cwchSuffix = Utf16StringBuf::LengthOfUtf8(psz8Suffix, cch8Suffix);
				size_t cbPrefix = oteReceiver->getSize();
				size_t cwchPrefix = cbPrefix / sizeof(Utf16String::CU);
				Utf16StringOTE* oteAnswer = Utf16String::New(cwchPrefix + cwchSuffix);
				auto pwszAnswer = oteAnswer->m_location->m_characters;
				auto pwszReceiver = reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters;
				memcpy(pwszAnswer, pwszReceiver, cbPrefix);
				char16_t* pEnd = Utf16StringBuf::ConvertUtf8_unsafe(psz8Suffix, cch8Suffix, pwszAnswer + cwchPrefix);
				ASSERT(pEnd == (pwszAnswer + cwchPrefix + cwchSuffix));
				*pEnd = L'\0';
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
			{
				// UTF-16, UTF-16 => UTF-16
				size_t cbPrefix = oteReceiver->getSize();
				size_t cbSuffix = oteArg->getSize();
				auto oteAnswer = reinterpret_cast<Utf16StringOTE*>(ObjectMemory::newUninitializedNullTermObject<Utf16String>(cbPrefix + cbSuffix));
				auto pbAnswer = reinterpret_cast<uint8_t*>(oteAnswer->m_location->m_characters);
				memcpy(pbAnswer, reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
				memcpy(pbAnswer+cbPrefix, reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, cbSuffix + sizeof(Utf16String::CU));
				*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			}
			break;

			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf32):
			//{
			//	// UTF-32, UTF-32 => UTF-32
			//	size_t cbPrefix = oteReceiver->getSize();
			//	size_t cbSuffix = oteArg->getSize();
			//	Utf32StringOTE* oteAnswer = reinterpret_cast<Utf32StringOTE*>(ObjectMemory::newUninitializedNullTermObject<Utf32String>(cbPrefix + cbSuffix));
			//	auto pbAnswer = reinterpret_cast<uint8_t*>(oteAnswer->m_location->m_characters);
			//	memcpy(pbAnswer, reinterpret_cast<const Utf32StringOTE*>(oteReceiver)->m_location->m_characters, cbPrefix);
			//	memcpy(pbAnswer + cbPrefix, reinterpret_cast<const Utf32StringOTE*>(oteArg)->m_location->m_characters, cbSuffix + sizeof(Utf32String::CU));
			//	*(sp - 1) = reinterpret_cast<Oop>(oteAnswer);
			//	ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteAnswer));
			//}
			//break;

			case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf32):
			case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf32):
			case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf32):
			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Ansi):
			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf8):
			case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf16):
				// UTF-32 support is largely unimplemented.
				return primitiveFailure(_PrimitiveFailureCode::NotImplemented);

			default:
				// Unrecognised encoding pair - fail the primitive
				__assume(false);
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


