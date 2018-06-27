/******************************************************************************

	File: StreamPrim.cpp

	Description:

	Implementation of the Interpreter class' Stream primitives

******************************************************************************/
#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

// Smalltalk classes
#include "STClassDesc.h"
#include "STStream.h"
#include "STArray.h"
#include "STByteArray.h"
#include "STString.h"
#include "STInteger.h"
#include "STCharacter.h"

// ICU macro U8_NEXT triggers runtime check #1, and 
#pragma runtime_checks( "c", off ) 

// This primitive handles PositionableStream>>next, but only for Arrays, Strings and ByteArrays
// Unary message, so does not modify stack pointer
Oop* __fastcall Interpreter::primitiveNext(Oop* const sp, unsigned)
{
	PosStreamOTE* streamPointer = reinterpret_cast<PosStreamOTE*>(*sp);		// Access receiver
	
	// Only works for subclasses of PositionableStream (or look alikes)
	//ASSERT(!ObjectMemoryIsIntegerObject(streamPointer) && ObjectMemory::isKindOf(streamPointer, Pointers.ClassPositionableStream));
	
	PositionableStream* readStream = streamPointer->m_location;
	
	// Ensure valid stream - unusually this validity check is included in the Blue Book spec
	// and appears to be implemented in most Smalltalks, so we implement here too.
	if (ObjectMemoryIsIntegerObject(readStream->m_index) && ObjectMemoryIsIntegerObject(readStream->m_readLimit))
	{

		SMALLINTEGER index = ObjectMemoryIntegerValueOf(readStream->m_index);
		SMALLINTEGER limit = ObjectMemoryIntegerValueOf(readStream->m_readLimit);

		if (index >= 0 && index < limit)
		{
			OTE* oteBuf = readStream->m_array;
			BehaviorOTE* bufClass = oteBuf->m_oteClass;

			if (oteBuf->isNullTerminated())
			{
				StringEncoding encoding = reinterpret_cast<const StringClass*>(bufClass->m_location)->Encoding;
				switch (encoding)
				{
				case StringEncoding::Ansi:
				{
					if (MWORD(index) < oteBuf->bytesSize())
					{
						auto ansiCodeUnit = static_cast<uint8_t>(reinterpret_cast<AnsiStringOTE*>(oteBuf)->m_location->m_characters[index]);
						PushCharacter(sp, static_cast<MWORD>(m_ansiToUnicodeCharMap[ansiCodeUnit]));
						// When incrementing the index we must allow for it overflowing a SmallInteger, even though
						// this is extremely unlikely in practice
						readStream->m_index = Integer::NewSigned32WithRef(index + 1);
						return sp;
					}
					return primitiveFailure(3);
				}

				case StringEncoding::Utf8:
				{
					MWORD size = oteBuf->bytesSize();
					if (MWORD(index) < size)
					{
						const Utf8String::CU* psz = reinterpret_cast<Utf8StringOTE*>(oteBuf)->m_location->m_characters;

						SMALLINTEGER codePoint;
						// The macro (from icucommon.h) advances the index as well as calculating the code point
						U8_NEXT(psz, index, static_cast<SMALLINTEGER>(size), codePoint);

						if (U_IS_UNICODE_CHAR(codePoint))
						{
							PushCharacter(sp, codePoint);
							readStream->m_index = Integer::NewSigned32WithRef(index);
							return sp;
						}

						return primitiveFailure(4);	// Malformed UTF-8, or at end of buffer over larger string, or at bad offset
					}

					// Out of bounds
					return primitiveFailure(3);
				}
				break;

				case StringEncoding::Utf16:
				{
					Utf16StringOTE* oteString = reinterpret_cast<Utf16StringOTE*>(oteBuf);

					MWORD size = oteString->bytesSize();
					if (MWORD(index) < size / sizeof(Utf16String::CU))
					{
						const Utf16String::CU* pwsz = oteString->m_location->m_characters;
						SMALLINTEGER codePoint;
						// The macro (from icucommon.h) advances the index as well as calculating the code point
						U16_NEXT(pwsz, index, size, codePoint);

						if (U_IS_UNICODE_CHAR(codePoint) && !U16_IS_SURROGATE(codePoint))
						{
							PushCharacter(sp, codePoint);
							readStream->m_index = Integer::NewSigned32WithRef(index);
							return sp;
						}

						return primitiveFailure(4);	// Malformed UTF-16, or reading starting at an invalid offset
					}

					return primitiveFailure(3);
				}
				break;

				case StringEncoding::Utf32:
				{
					Utf32StringOTE* oteString = reinterpret_cast<Utf32StringOTE*>(oteBuf);

					MWORD size = oteString->bytesSize();
					if (MWORD(index) < size / sizeof(Utf32String::CU))
					{
						Utf32String::CU codePoint = oteString->m_location->m_characters[index];

						if (U_IS_UNICODE_CHAR(codePoint))
						{
							PushCharacter(sp, codePoint);
							readStream->m_index = Integer::NewSigned32WithRef(index + 1);
							return sp;
						}

						return primitiveFailure(4);	// Invalid code point
					}

					return primitiveFailure(3);
				}
				break;

				default:
					return primitiveFailure(1);
				}
			}

			// We also support ByteArrays in our primitiveNext (unlike BB).
			else if (bufClass == Pointers.ClassByteArray)
			{
				ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(oteBuf);
				if (MWORD(index) < oteBytes->bytesSize())
				{
					*sp = ObjectMemoryIntegerObjectOf(oteBytes->m_location->m_elements[index]);
					readStream->m_index = Integer::NewSigned32WithRef(index + 1);
					return sp;
				}
				return primitiveFailure(3);
			}

			else if (bufClass == Pointers.ClassArray)
			{
				ArrayOTE* oteArray = reinterpret_cast<ArrayOTE*>(oteBuf);
				if (MWORD(index) < oteArray->pointersSize())
				{
					*sp = oteArray->m_location->m_elements[index];
					readStream->m_index = Integer::NewSigned32WithRef(index + 1);
					return sp;
				}
				return primitiveFailure(3);
			}

			return primitiveFailure(1);		// Collection cannot be handled by primitive, rely on Smalltalk code
		}

		return primitiveFailure(2);		// index not in range 0<index<limit
	}

	return primitiveFailure(0);	// Receiver fails invariant check
}
#pragma runtime_checks( "c", restore ) 

// This primitive handles WriteStream>>nextPut:, but only for Arrays, Strings & ByteArrays
// It is fairly long complex because of the new support for String encodings, for which there are quite a lot of cases.
Oop* __fastcall Interpreter::primitiveNextPut(Oop* const sp, unsigned)
{
	Oop* newSp = sp - 1;
	WriteStreamOTE* streamPointer = reinterpret_cast<WriteStreamOTE*>(*newSp);		// Access receiver under argument
	WriteStream* writeStream = streamPointer->m_location;
	
	// Ensure valid stream
	if (ObjectMemoryIsIntegerObject(writeStream->m_index) && ObjectMemoryIsIntegerObject(writeStream->m_writeLimit))
	{
		SMALLINTEGER index = ObjectMemoryIntegerValueOf(writeStream->m_index);
		SMALLINTEGER limit = ObjectMemoryIntegerValueOf(writeStream->m_writeLimit);

		// Within the bounds of the limit?
		if (index >= 0 && index < limit)
		{
			OTE* oteBuf = writeStream->m_array;
			Oop value = *(sp);

			if (oteBuf->isBytes())
			{
				if (oteBuf->isNullTerminated())
				{
					if (ObjectMemory::fetchClassOf(value) == Pointers.ClassCharacter)
					{
						Character* character = reinterpret_cast<CharOTE*>(value)->m_location;
						MWORD codeUnit = character->CodeUnit;

						switch (reinterpret_cast<StringClass*>(oteBuf->m_oteClass->m_location)->Encoding)
						{
						case StringEncoding::Ansi:
						{
							// Writing into an Ansi string - can only write one byte at a time
							if (index < oteBuf->bytesSizeForUpdate())
							{
								AnsiStringOTE * oteStringBuf = reinterpret_cast<AnsiStringOTE*>(oteBuf);
								char32_t codePoint = MAX_UCSCHAR + 1;

								switch (character->Encoding)
								{
								case StringEncoding::Ansi:
									oteStringBuf->m_location->m_characters[index] = codeUnit;
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;

								case StringEncoding::Utf8:
									if (__isascii(codeUnit))
									{
										codePoint = codeUnit;
									}
									// else not a valid UTF-8 code unit to store in an Ansi string
									break;

								case StringEncoding::Utf16:
									codePoint = codeUnit;
									break;

								case StringEncoding::Utf32:
									codePoint = codeUnit;
									break;

								default:
									break;
								}

								AnsiString::CU ch = 0;
								if (codePoint == 0 || (U_IS_BMP(codePoint) && (ch = m_unicodeToAnsiCharMap[codePoint]) != 0))
								{
									oteStringBuf->m_location->m_characters[index] = ch;
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}

								return primitiveFailure(4);	// Invalid code unit for Ansi string
							}
							else
								return primitiveFailure(2);		// Out of bounds of Ansi string
						}

						case StringEncoding::Utf8:
						{
							// Write into a Utf8String - could possibly write more than one byte, so have to check bounds for each Character encoding

							Utf8StringOTE* oteStringBuf = reinterpret_cast<Utf8StringOTE*>(oteBuf);
							MWORD codeUnit = character->CodeUnit;
							char32_t codePoint = MAX_UCSCHAR+1;

							switch (character->Encoding)
							{
							case StringEncoding::Ansi:
								// Ansi character - may require more than one byte to represent in UTF-8
								codePoint = m_ansiToUnicodeCharMap[codeUnit & 0xff];
								break;

							case StringEncoding::Utf8:
								// UTF-8 Character into UTF-8 string, write it directly as is (so will also work for surrogates)
								if (index < oteStringBuf->bytesSizeForUpdate())
								{
									oteStringBuf->m_location->m_characters[index] = static_cast<Utf8String::CU>(codeUnit);
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}

							case StringEncoding::Utf16:
								// UTF-16 Character: We can only write these to a UTF-8 string if they are not surrogates, but detect surrogates below
							case StringEncoding::Utf32:
								// Full Unicode code point - we can encode any of these in UTF-8, though it may require up to 4 bytes.
								codePoint = codeUnit;
								break;

							default:
								// Unrecognised character encoding
								break;
							}

							// Now we have a code point, we can encode it in UTF-8 (if not a surrogate)
							if (__isascii(codePoint))
							{
								// Single byte encoding

								if (index < oteStringBuf->bytesSizeForUpdate())
								{
									oteStringBuf->m_location->m_characters[index] = static_cast<Utf8String::CU>(codePoint);
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}

								return primitiveFailure(2);		// Out of bounds
							}
							else if (codePoint < 0x800)
							{
								// Two byte encoding

								if (index + 1 < limit && index + 1 < oteStringBuf->bytesSizeForUpdate())
								{
									Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
									pChars[index] = 0xC0 | static_cast<Utf8String::CU>(codePoint >> 6);
									pChars[index + 1] = 0x80 | static_cast<Utf8String::CU>(codePoint & 0x3f);
									writeStream->m_index = Integer::NewSigned32WithRef(index + 2);		// Increment the stream index
									*newSp = value;
									return newSp;
								}

								return primitiveFailure(2);		// Out of bounds
							}
							else if (U_IS_BMP(codePoint))
							{
								if (!U_IS_SURROGATE(codePoint))
								{
									// Three byte encoding
									if (index + 2 < limit && index + 2 < oteStringBuf->bytesSizeForUpdate())
									{
										Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
										pChars[index] = 0xe0 | static_cast<Utf8String::CU>(codePoint >> 12);
										pChars[index + 1] = 0x80 | static_cast<Utf8String::CU>((codePoint >> 6) & 0x3f);
										pChars[index + 2] = 0x80 | static_cast<Utf8String::CU>(codePoint & 0x3f);
										writeStream->m_index = Integer::NewSigned32WithRef(index + 3);		// Increment the stream index
										*newSp = value;
										return newSp;
									}

									return primitiveFailure(2);		// Out of bounds
								}
							}
							else if (codePoint <= MAX_UCSCHAR && !U_IS_UNICODE_NONCHAR(codePoint))
							{
								// Four byte encoding
								if (index + 3 < limit && index + 3 < oteStringBuf->bytesSizeForUpdate())
								{
									Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
									pChars[index] = 0xf0 | static_cast<Utf8String::CU>(codePoint >> 18);
									pChars[index + 1] = 0x80 | static_cast<Utf8String::CU>((codePoint >> 12) & 0x3f);
									pChars[index + 2] = 0x80 | static_cast<Utf8String::CU>((codePoint >> 6) & 0x3f);
									pChars[index + 3] = 0x80 | static_cast<Utf8String::CU>(codePoint & 0x3f);
									writeStream->m_index = Integer::NewSigned32WithRef(index + 4);		// Increment the stream index
									*newSp = value;
									return newSp;
								}

								return primitiveFailure(2);		// Out of bounds
							}

							return primitiveFailure(4);			// Invalid code point
						}

						case StringEncoding::Utf16:
						{
							// Writing into a UTF-16 string

							Utf16StringOTE* oteStringBuf = reinterpret_cast<Utf16StringOTE*>(oteBuf);
							char32_t codePoint = MAX_UCSCHAR + 1;

							switch (character->Encoding)
							{
							case StringEncoding::Ansi:
								// Ansi encoded char, can never require more than one UTF-16 code point
								codePoint = m_ansiToUnicodeCharMap[codeUnit];
								break;

							case StringEncoding::Utf8:
								// UTF-8 encoded char, can only write these if not surrogates
								if (__isascii(codeUnit))
								{
									codePoint = codeUnit;
								}
								break;

							case StringEncoding::Utf16:
								// UTF-16 into UTF-16, can just write it, whether a surrogate or not
								if (index < (oteStringBuf->bytesSizeForUpdate() / (int)sizeof(Utf16String::CU)))
								{
									oteStringBuf->m_location->m_characters[index] = static_cast<Utf16String::CU>(codeUnit);
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}

							case StringEncoding::Utf32:
								codePoint = codeUnit;
								break;

							default:
								// Unrecognised encoding
								break;
							}

							if (U_IS_UNICODE_CHAR(codePoint))
							{
								if (U_IS_BMP(codePoint))
								{
									// One 16-bit code unit

									if (index < (oteStringBuf->bytesSizeForUpdate() / (int)sizeof(Utf16String::CU)))
									{
										oteStringBuf->m_location->m_characters[index] = static_cast<Utf16String::CU>(codePoint);
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}

									return primitiveFailure(2);		// Out of bounds
								}
								else
								{
									// Two 16-bit code units

									if (index + 1 < limit && index + 1 < oteStringBuf->bytesSizeForUpdate() / (int)sizeof(Utf16String::CU))
									{
										codePoint -= 0x10000;
										Utf16String::CU* pChars = oteStringBuf->m_location->m_characters;
										pChars[index] = 0xd800 + static_cast<Utf16String::CU>((codePoint >> 10) & 0xffff);
										pChars[index + 1] = 0xdc00 + static_cast<Utf16String::CU>(codePoint & 0x3ff);
										writeStream->m_index = Integer::NewSigned32WithRef(index + 2);		// Increment the stream index
										*newSp = value;
										return newSp;
									}

									return primitiveFailure(2);		// Out of bounds
								}
							}
							return primitiveFailure(4);			// Invalid code point
						}

						case StringEncoding::Utf32:
							// Writing into a Utf32 string

							if (index < oteBuf->bytesSizeForUpdate() / (int)sizeof(Utf32String::CU))
							{
								Utf32StringOTE * oteStringBuf = reinterpret_cast<Utf32StringOTE*>(oteBuf);
								char32_t codePoint = MAX_UCSCHAR + 1;

								switch (character->Encoding)
								{
								case StringEncoding::Ansi:
									codePoint = m_ansiToUnicodeCharMap[codeUnit];
									break;

								case StringEncoding::Utf8:
									if (__isascii(codeUnit))
									{
										codePoint = codeUnit;
									}
									// else: UTF-8 surrogate, not a valid code unit for UTF-32
									break;

								case StringEncoding::Utf16:
									// UTF-16 surrogates detected below
								case StringEncoding::Utf32:
									codePoint = codeUnit;
									break;
								default:
									break;
								}

								if (U_IS_UNICODE_CHAR(codePoint))
								{
									oteStringBuf->m_location->m_characters[index] = codePoint;
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}
								return primitiveFailure(4);			// Invalid code point
							}
							return primitiveFailure(2);		// Out of bounds

						default:
							// Unrecogised string encoding of the buffer
							return primitiveFailure(1);
						}
					}

					// Not a character
					return primitiveFailure(4);
				}

				else if (oteBuf->m_oteClass == Pointers.ClassByteArray)
				{
					if (ObjectMemoryIsIntegerObject(value))
					{
						MWORD intValue = ObjectMemoryIntegerValueOf(value);
						if (intValue > 255)
						{
							ByteArrayOTE* oteByteArray = reinterpret_cast<ByteArrayOTE*>(oteBuf);

							if (index < limit && index < oteByteArray->bytesSizeForUpdate())
							{
								oteByteArray->m_location->m_elements[index] = static_cast<BYTE>(intValue);

								// Increment the stream index
								writeStream->m_index = Integer::NewSigned32WithRef(index + 1);
								// Return the argument
								*newSp = value;
								return newSp;
							}

							return primitiveFailure(2);	// Out of bounds
						}
					}

					return primitiveFailure(4);	// Attempt to put non-SmallInteger or out of range 0..255
				}
			}
			else if (oteBuf->m_oteClass == Pointers.ClassArray)
			{
				ArrayOTE* oteArray = reinterpret_cast<ArrayOTE*>(oteBuf);

				// In bounds of Array?
				if (index < limit && index < oteArray->pointersSizeForUpdate())
				{
					Array* buf = oteArray->m_location;
					// We must ref. count value here as we're storing into a heap object slot
					ObjectMemory::storePointerWithValue(buf->m_elements[index], value);

					// Increment the stream index
					writeStream->m_index = Integer::NewSigned32WithRef(index + 1);
					// Return the value
					*newSp = value;
					return newSp;
				}

				return primitiveFailure(2);	// Out of bounds
			}

			// Primitive response not supported for the streamed over collection
			return primitiveFailure(1);
		}

		// Out of bounds of limit
		return primitiveFailure(2);
	}

	// Invalid stream
	return primitiveFailure(0);
}

// Read basic elements from a stream. In the case of character streams, will read individual integer code units (unlike primitiveNext, which reads whole characters 
// potentially assembling them from more than one code unit)
Oop* __fastcall Interpreter::primitiveBasicNext(Oop* const sp, unsigned)
{
	PosStreamOTE* streamPointer = reinterpret_cast<PosStreamOTE*>(*sp);		// Access receiver

	PositionableStream* readStream = streamPointer->m_location;

	// Ensure valid stream - unusually this validity check is included in the Blue Book spec
	// and appears to be implemented in most Smalltalks, so we implement here too.
	if (ObjectMemoryIsIntegerObject(readStream->m_index) && ObjectMemoryIsIntegerObject(readStream->m_readLimit))
	{

		SMALLINTEGER index = ObjectMemoryIntegerValueOf(readStream->m_index);
		SMALLINTEGER limit = ObjectMemoryIntegerValueOf(readStream->m_readLimit);

		if (index >= 0 && index < limit)
		{
			OTE* oteBuf = readStream->m_array;
			BehaviorOTE* bufClass = oteBuf->m_oteClass;

			if (oteBuf->isBytes())
			{
				switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteBuf)))
				{
				case 1:
					if (MWORD(index) < oteBuf->bytesSize())
					{
						uint8_t value = reinterpret_cast<BytesOTE*>(oteBuf)->m_location->m_fields[index];
						*sp = integerObjectOf(value);
						readStream->m_index = Integer::NewSigned32WithRef(index + 1);
						return sp;
					}
					else
						// Out of bounds
						return primitiveFailure(3);

				case 2:
					if (MWORD(index) < (oteBuf->bytesSize() / 2))
					{
						uint16_t value = reinterpret_cast<WordsOTE*>(oteBuf)->m_location->m_fields[index];
						*sp = integerObjectOf(value);
						readStream->m_index = Integer::NewSigned32WithRef(index + 1);
						return sp;
					}
					else
						// Out of bounds
						return primitiveFailure(3);

				case 4:
					if (MWORD(index) < (oteBuf->bytesSize() / 4))
					{
						uint32_t value = reinterpret_cast<QuadsOTE*>(oteBuf)->m_location->m_fields[index];
						*sp = Integer::NewUnsigned32(value);
						ObjectMemory::AddToZct(*sp);
						readStream->m_index = Integer::NewSigned32WithRef(index + 1);
						return sp;
					}
					else
						// Out of bounds
						return primitiveFailure(3);

				default:
					return primitiveFailure(4);
				}
			}

			else if (bufClass == Pointers.ClassArray)
			{
				ArrayOTE* oteArray = reinterpret_cast<ArrayOTE*>(oteBuf);
				if (MWORD(index) < oteArray->pointersSize())
				{
					*sp = oteArray->m_location->m_elements[index];
					readStream->m_index = Integer::NewSigned32WithRef(index + 1);
					return sp;
				}
				return primitiveFailure(3);
			}

			return primitiveFailure(1);		// Collection cannot be handled by primitive, rely on Smalltalk code
		}

		return primitiveFailure(2);		// index not in range 0<index<limit
	}

	return primitiveFailure(0);	// Receiver fails invariant check
}

// Like primitiveNextPut, but always writes an integer element. For a ByteArray, this will be a byte. For a string, it will be a code unit.
Oop* __fastcall Interpreter::primitiveBasicNextPut(Oop* const sp, unsigned)
{
	MWORD value = *sp;
	if (ObjectMemoryIsIntegerObject(value))
	{
		value = ObjectMemoryIntegerValueOf(value);
		Oop* newSp = sp - 1;
		WriteStreamOTE* streamPointer = reinterpret_cast<WriteStreamOTE*>(*newSp);		// Access receiver under argument
		WriteStream* writeStream = streamPointer->m_location;

		// If the position or limits have overflowed SmallInteger range, then the primitive can't handle the request
		if (ObjectMemoryIsIntegerObject(writeStream->m_index) && ObjectMemoryIsIntegerObject(writeStream->m_writeLimit))
		{
			SMALLINTEGER index = ObjectMemoryIntegerValueOf(writeStream->m_index);
			SMALLINTEGER limit = ObjectMemoryIntegerValueOf(writeStream->m_writeLimit);
			OTE* oteBuf = writeStream->m_array;

			if (oteBuf->isBytes())
			{
				switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteBuf)))
				{
				case 1:
					if (value <= 0xFF)
					{
						if (index < limit && index < oteBuf->bytesSizeForUpdate())
						{
							reinterpret_cast<BytesOTE*>(oteBuf)->m_location->m_fields[index] = value;
							writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
							*newSp = value;
							return newSp;
						}
						return primitiveFailure(3);		// Out of bounds
					}
					return primitiveFailure(4);	// Arg too large

				case 2:
					if (value <= 0xffff)
					{
						if (index < limit && index < oteBuf->bytesSizeForUpdate() / 2)
						{
							reinterpret_cast<WordsOTE*>(oteBuf)->m_location->m_fields[index] = value;
							writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
							*newSp = value;
							return newSp;
						}
						return primitiveFailure(3);		// Out of bounds
					}
					return primitiveFailure(4);	// Arg too large

				case 4:
					if (index < limit && index < oteBuf->bytesSizeForUpdate() / 4)
					{
						reinterpret_cast<QuadsOTE*>(oteBuf)->m_location->m_fields[index] = value;
						writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
						*newSp = value;
						return newSp;
					}
					return primitiveFailure(3);		// Out of bounds

				default:
					// Unrecognised encoding, primitive response not available
					break;
				}
			}
			else if (oteBuf->m_oteClass == Pointers.ClassArray)
			{
				// In bounds of Array?
				if (index < limit && index < oteBuf->pointersSizeForUpdate())
				{
					Array* buf = reinterpret_cast<ArrayOTE*>(oteBuf)->m_location;
					// We must ref. count value here as we're storing into a heap object slot
					ObjectMemory::storePointerWithValue(buf->m_elements[index], value);

					// Increment the stream index
					writeStream->m_index = Integer::NewSigned32WithRef(index + 1);
					// Return the value
					*newSp = value;
					return newSp;
				}

				return primitiveFailure(3);	// Out of bounds
			}
			// else: Primitive response not supported for the streamed over collection
			return primitiveFailure(1);
		}

		// Invalid stream
		return primitiveFailure(0);
	}

	// Invalid argument
	return primitiveFailure(4);
}

// Non-standard, but has very beneficial effect on performance
Oop* __fastcall Interpreter::primitiveNextPutAll(Oop* const sp, unsigned)
{
	WriteStreamOTE* streamPointer = reinterpret_cast<WriteStreamOTE*>(*(sp-1));		// Access receiver under argument
	WriteStream* writeStream = streamPointer->m_location;
	
	// If the position or limits have overflowed SmallInteger range, then the primitive can't handle the request
	if (ObjectMemoryIsIntegerObject(writeStream->m_index) && ObjectMemoryIsIntegerObject(writeStream->m_writeLimit))
	{
		SMALLINTEGER index = ObjectMemoryIntegerValueOf(writeStream->m_index);
		SMALLINTEGER limit = ObjectMemoryIntegerValueOf(writeStream->m_writeLimit);

		if (index >= 0)
		{
			Oop value = *(sp);

			OTE* oteBuf = writeStream->m_array;
			BehaviorOTE* bufClass = oteBuf->m_oteClass;

			MWORD newIndex;

			// TODO: Support other string encodings

			if (bufClass == Pointers.ClassAnsiString)
			{
				BehaviorOTE* oteClass = ObjectMemory::fetchClassOf(value);
				if (oteClass != Pointers.ClassAnsiString && oteClass != Pointers.ClassSymbol)
					return primitiveFailure(4);	// Attempt to put non-string

				AnsiStringOTE* oteString = reinterpret_cast<AnsiStringOTE*>(value);
				AnsiString* str = oteString->m_location;

				MWORD valueSize = oteString->bytesSize();
				newIndex = MWORD(index) + valueSize;

				if (newIndex >= static_cast<MWORD>(limit))			// Beyond write limit
					return primitiveFailure(2);

				if (static_cast<int>(newIndex) >= oteBuf->bytesSizeForUpdate())
					return primitiveFailure(3);	// Attempt to write off end of buffer

				AnsiString* buf = static_cast<AnsiString*>(oteBuf->m_location);
				memcpy(buf->m_characters + index, str->m_characters, valueSize);
			}
			else if (bufClass == Pointers.ClassByteArray)
			{
				if (ObjectMemory::fetchClassOf(value) != bufClass)
					return primitiveFailure(4);	// Attempt to put non-ByteArray

				ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(value);
				ByteArray* bytes = oteBytes->m_location;
				MWORD valueSize = oteBytes->bytesSize();
				newIndex = MWORD(index) + valueSize;

				if (newIndex >= (MWORD)limit)			// Beyond write limit
					return primitiveFailure(2);

				if (static_cast<int>(newIndex) >= oteBuf->bytesSizeForUpdate())
					return primitiveFailure(3);	// Attempt to write off end of buffer

				ByteArray* buf = static_cast<ByteArray*>(oteBuf->m_location);
				memcpy(buf->m_elements + index, bytes->m_elements, valueSize);
			}
			else if (bufClass == Pointers.ClassArray)
			{
				if (ObjectMemory::fetchClassOf(value) != Pointers.ClassArray)
					return primitiveFailure(4);	// Attempt to put non-Array

				ArrayOTE* oteArray = reinterpret_cast<ArrayOTE*>(value);
				Array* array = oteArray->m_location;
				MWORD valueSize = oteArray->pointersSize();
				newIndex = MWORD(index) + valueSize;

				if (newIndex >= (MWORD)limit)			// Beyond write limit
					return primitiveFailure(2);

				if (static_cast<int>(newIndex) >= oteBuf->pointersSizeForUpdate())
					return primitiveFailure(3);	// Attempt to write off end of buffer

				Array* buf = static_cast<Array*>(oteBuf->m_location);

				for (MWORD i = 0; i < valueSize; i++)
				{
					ObjectMemory::storePointerWithValue(buf->m_elements[index + i], array->m_elements[i]);
				}
			}
			else
				return primitiveFailure(1);

			writeStream->m_index = Integer::NewUnsigned32WithRef(newIndex);		// Increment the stream index

			// As we no longer pop stack here, the receiver is still under the argument
			*(sp - 1) = value;

			return sp - 1;
		}

		return primitiveFailure(2);		// stream position negative
	}

	return primitiveFailure(0);	// Primitive response not possible for state of Stream
}

// The primitive handles PositionableStream>>atEnd, but only for arrays/strings
Oop* __fastcall Interpreter::primitiveAtEnd(Oop* const sp, unsigned)
{
	PosStreamOTE* streamPointer = reinterpret_cast<PosStreamOTE*>(*sp);		// Access receiver
	PositionableStream* readStream = streamPointer->m_location;

	// Ensure valid stream (see BBB p632)
	Oop index = readStream->m_index;
	Oop readLimit = readStream->m_readLimit;
	if (ObjectMemoryIsIntegerObject(index) && ObjectMemoryIsIntegerObject(readLimit))
	{
		OTE* oteBuf = readStream->m_array;
		BehaviorOTE* bufClass = readStream->m_array->m_oteClass;

		if (oteBuf->isNullTerminated() || bufClass == Pointers.ClassByteArray)
		{
			*sp = reinterpret_cast<Oop>(index >= readLimit || (MWORD(ObjectMemoryIntegerValueOf(index)) >= readStream->m_array->bytesSize())
				? Pointers.True : Pointers.False);
			return sp;
		}
		else if (bufClass == Pointers.ClassArray)
		{
			*sp = reinterpret_cast<Oop>(index >= readLimit || (MWORD(ObjectMemoryIntegerValueOf(index)) >= readStream->m_array->pointersSize())
				? Pointers.True : Pointers.False);
			return sp;
		}

		return primitiveFailure(1);		// Doesn't work for non-Strings/ByteArrays/Arrays, or if out of bounds
	}
	return primitiveFailure(0);
}


// This primitive handles PositionableStream>>nextSDWORD, but only for byte-arrays
// Unary message, so does not modify stack pointer
Oop* __fastcall Interpreter::primitiveNextSDWORD(Oop* const sp, unsigned)
{
	PosStreamOTE* streamPointer = reinterpret_cast<PosStreamOTE*>(*sp);		// Access receiver
	PositionableStream* readStream = streamPointer->m_location;

	// Ensure valid stream - unusually this validity check is included in the Blue Book spec
	// and appears to be implemented in most Smalltalks, so we implement here too.
	if (!ObjectMemoryIsIntegerObject(readStream->m_index) ||
		!ObjectMemoryIsIntegerObject(readStream->m_readLimit))
		return primitiveFailure(0);	// Receiver fails invariant check

	SMALLINTEGER index = ObjectMemoryIntegerValueOf(readStream->m_index);
	SMALLINTEGER limit = ObjectMemoryIntegerValueOf(readStream->m_readLimit);

	// Is the current index within the limits of the collection?
	// Remember that the index is 1 based (it's a Smalltalk index), and we're 0 based,
	// so we don't need to increment it until after we've got the next object
	if (index < 0 || index >= limit)
		return primitiveFailure(2);		// No, fail it

	OTE* oteBuf = readStream->m_array;
	BehaviorOTE* bufClass = oteBuf->m_oteClass;
	
	if (bufClass != Pointers.ClassByteArray)
		return primitiveFailure(1);		// Collection cannot be handled by primitive, rely on Smalltalk code

	ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(oteBuf);

	const int newIndex = index + sizeof(SDWORD);
	if (MWORD(newIndex) > oteBytes->bytesSize())
		return primitiveFailure(3);

	const Oop oopNewIndex = ObjectMemoryIntegerObjectOf(newIndex);
	if (int(oopNewIndex) < 0)
		return primitiveFailure(4);	// index overflowed SmallInteger range

	// When incrementing the index we must allow for it overflowing a SmallInteger, even though
	// this is extremely unlikely in practice
	readStream->m_index = oopNewIndex;

	// Receiver is overwritten
	ByteArray* byteArray = oteBytes->m_location;

	*sp = Integer::NewSigned32(*reinterpret_cast<SDWORD*>(byteArray->m_elements + index));
	ObjectMemory::AddToZct(*sp);
	return sp;
}

