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

#include "Utf16StringBuf.h"

// ICU macro U8_NEXT triggers runtime check #1, and 
#pragma runtime_checks( "c", off ) 

// This primitive handles PositionableStream>>next, but only for Arrays, Strings and ByteArrays
// Unary message, so does not modify stack pointer
Oop* PRIMCALL Interpreter::primitiveNext(Oop* const sp, primargcount_t)
{
	PosStreamOTE* streamPointer = reinterpret_cast<PosStreamOTE*>(*sp);		// Access receiver
	
	// Only works for subclasses of PositionableStream (or look alikes)
	//ASSERT(!ObjectMemoryIsIntegerObject(streamPointer) && ObjectMemory::isKindOf(streamPointer, Pointers.ClassPositionableStream));
	
	PositionableStream* readStream = streamPointer->m_location;
	
	// Ensure valid stream - unusually this validity check is included in the Blue Book spec
	// and appears to be implemented in most Smalltalks, so we implement here too.
	if (ObjectMemoryIsIntegerObject(readStream->m_index) && ObjectMemoryIsIntegerObject(readStream->m_readLimit))
	{

		SmallInteger index = ObjectMemoryIntegerValueOf(readStream->m_index);
		SmallInteger limit = ObjectMemoryIntegerValueOf(readStream->m_readLimit);

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
					if (static_cast<size_t>(index) < oteBuf->bytesSize())
					{
						auto ansiCodeUnit = static_cast<char8_t>(reinterpret_cast<AnsiStringOTE*>(oteBuf)->m_location->m_characters[index]);
						PushCharacter(sp, static_cast<char32_t>(m_ansiToUnicodeCharMap[ansiCodeUnit]));
						// When incrementing the index we must allow for it overflowing a SmallInteger, even though
						// this is extremely unlikely in practice
						readStream->m_index = Integer::NewSigned32WithRef(index + 1);
						return sp;
					}
					return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
				}

				case StringEncoding::Utf8:
				{
					size_t size = oteBuf->bytesSize();
					if (static_cast<size_t>(index) < size)
					{
						const Utf8String::CU* psz = reinterpret_cast<Utf8StringOTE*>(oteBuf)->m_location->m_characters;

						SmallInteger codePoint;
						// The macro (from icucommon.h) advances the index as well as calculating the code point
						U8_NEXT(psz, index, static_cast<SmallInteger>(size), codePoint);

						if (U_IS_UNICODE_CHAR(codePoint))
						{
							PushCharacter(sp, codePoint);
							readStream->m_index = Integer::NewSigned32WithRef(index);
							return sp;
						}

						return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);	// Malformed UTF-8, or at end of buffer over larger string, or at bad offset
					}

					// Out of bounds
					return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
				}
				break;

				case StringEncoding::Utf16:
				{
					Utf16StringOTE* oteString = reinterpret_cast<Utf16StringOTE*>(oteBuf);

					size_t size = oteString->bytesSize();
					if (static_cast<size_t>(index) < size / sizeof(Utf16String::CU))
					{
						const Utf16String::CU* pwsz = oteString->m_location->m_characters;
						SmallInteger codePoint;
						// The macro (from icucommon.h) advances the index as well as calculating the code point
						U16_NEXT(pwsz, index, size, codePoint);

						if (U_IS_UNICODE_CHAR(codePoint) && !U16_IS_SURROGATE(codePoint))
						{
							PushCharacter(sp, codePoint);
							readStream->m_index = Integer::NewSigned32WithRef(index);
							return sp;
						}

						return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);	// Malformed UTF-16, or reading starting at an invalid offset
					}

					return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
				}
				break;

				case StringEncoding::Utf32:
				{
					Utf32StringOTE* oteString = reinterpret_cast<Utf32StringOTE*>(oteBuf);

					size_t size = oteString->bytesSize();
					if (static_cast<size_t>(index) < size / sizeof(Utf32String::CU))
					{
						Utf32String::CU codePoint = oteString->m_location->m_characters[index];

						if (U_IS_UNICODE_CHAR(codePoint))
						{
							PushCharacter(sp, codePoint);
							readStream->m_index = Integer::NewSigned32WithRef(index + 1);
							return sp;
						}

						return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);	// Invalid code point
					}

					return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
				}
				break;

				default:
					__assume(false);
					return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
				}
			}

			// We also support ByteArrays in our primitiveNext (unlike BB).
			else if (bufClass == Pointers.ClassByteArray)
			{
				ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(oteBuf);
				if (static_cast<size_t>(index) < oteBytes->bytesSize())
				{
					*sp = ObjectMemoryIntegerObjectOf(oteBytes->m_location->m_elements[index]);
					readStream->m_index = Integer::NewSigned32WithRef(index + 1);
					return sp;
				}
				return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
			}

			else if (bufClass == Pointers.ClassArray)
			{
				ArrayOTE* oteArray = reinterpret_cast<ArrayOTE*>(oteBuf);
				if (static_cast<size_t>(index) < oteArray->pointersSize())
				{
					*sp = oteArray->m_location->m_elements[index];
					readStream->m_index = Integer::NewSigned32WithRef(index + 1);
					return sp;
				}
				return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
			}

			return primitiveFailure(_PrimitiveFailureCode::NotSupported);		// Collection cannot be handled by primitive, rely on Smalltalk code
		}

		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// index not in range 0<index<limit
	}

	return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);	// Receiver fails invariant check
}
#pragma runtime_checks( "c", restore ) 

// This primitive handles WriteStream>>nextPut:, but only for Arrays, Strings & ByteArrays
// It is fairly long complex because of the new support for String encodings, for which there are quite a lot of cases.
Oop* PRIMCALL Interpreter::primitiveNextPut(Oop* const sp, primargcount_t)
{
	Oop* newSp = sp - 1;
	WriteStreamOTE* streamPointer = reinterpret_cast<WriteStreamOTE*>(*newSp);		// Access receiver under argument
	WriteStream* writeStream = streamPointer->m_location;
	
	// Ensure valid stream
	if (ObjectMemoryIsIntegerObject(writeStream->m_index) && ObjectMemoryIsIntegerObject(writeStream->m_writeLimit))
	{
		SmallInteger index = ObjectMemoryIntegerValueOf(writeStream->m_index);
		SmallInteger limit = ObjectMemoryIntegerValueOf(writeStream->m_writeLimit);

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
						auto codeUnit = character->CodeUnit;

						switch (reinterpret_cast<StringClass*>(oteBuf->m_oteClass->m_location)->Encoding)
						{
						case StringEncoding::Ansi:
						{
							AnsiStringOTE * oteStringBuf = reinterpret_cast<AnsiStringOTE*>(oteBuf);

							// Writing into an Ansi string - can only write one byte at a time
							if (index < oteStringBuf->sizeForUpdate())
							{
								char32_t codePoint = MAX_UCSCHAR + 1;

								switch (character->Encoding)
								{
								case StringEncoding::Ansi:
									oteStringBuf->m_location->m_characters[index] = codeUnit & 0xff;
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
									_assume(false);
									return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);
								}

								AnsiString::CU ch = 0;
								if (codePoint == 0 || (U_IS_BMP(codePoint) && (ch = m_unicodeToAnsiCharMap[codePoint]) != 0))
								{
									oteStringBuf->m_location->m_characters[index] = ch;
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}

								return primitiveFailure(_PrimitiveFailureCode::UnmappableCharacter);	// Invalid code unit for Ansi string
							}
							else
								return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds of Ansi string
						}

						case StringEncoding::Utf8:
						{
							// Write into a Utf8String - could possibly write more than one byte, so have to check bounds for each Character encoding

							Utf8StringOTE* oteStringBuf = reinterpret_cast<Utf8StringOTE*>(oteBuf);
							auto codeUnit = character->CodeUnit;
							char32_t codePoint = MAX_UCSCHAR+1;

							switch (character->Encoding)
							{
							case StringEncoding::Ansi:
								// Ansi character - may require more than one byte to represent in UTF-8
								codePoint = m_ansiToUnicodeCharMap[codeUnit & 0xff];
								break;

							case StringEncoding::Utf8:
								// UTF-8 Character into UTF-8 string, write it directly as is (so will also work for surrogates)
								if (index < oteStringBuf->sizeForUpdate())
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
								__assume(false);
								return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);
							}

							// Now we have a code point, we can encode it in UTF-8 (if not a surrogate)
							if (__isascii(codePoint))
							{
								// Single byte encoding

								if (index < oteStringBuf->sizeForUpdate())
								{
									oteStringBuf->m_location->m_characters[index] = static_cast<Utf8String::CU>(codePoint);
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}

								return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds
							}
							else if (codePoint < 0x800)
							{
								// Two byte encoding

								if (index + 1 < limit && index + 1 < oteStringBuf->sizeForUpdate())
								{
									Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
									pChars[index] = 0xC0 | static_cast<Utf8String::CU>(codePoint >> 6);
									pChars[index + 1] = 0x80 | static_cast<Utf8String::CU>(codePoint & 0x3f);
									writeStream->m_index = Integer::NewSigned32WithRef(index + 2);		// Increment the stream index
									*newSp = value;
									return newSp;
								}

								return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds
							}
							else if (U_IS_BMP(codePoint))
							{
								if (!U_IS_SURROGATE(codePoint))
								{
									// Three byte encoding
									if (index + 2 < limit && index + 2 < oteStringBuf->sizeForUpdate())
									{
										Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
										pChars[index] = 0xe0 | static_cast<Utf8String::CU>(codePoint >> 12);
										pChars[index + 1] = 0x80 | static_cast<Utf8String::CU>((codePoint >> 6) & 0x3f);
										pChars[index + 2] = 0x80 | static_cast<Utf8String::CU>(codePoint & 0x3f);
										writeStream->m_index = Integer::NewSigned32WithRef(index + 3);		// Increment the stream index
										*newSp = value;
										return newSp;
									}

									return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds
								}
							}
							else if (codePoint <= MAX_UCSCHAR && !U_IS_UNICODE_NONCHAR(codePoint))
							{
								// Four byte encoding
								if (index + 3 < limit && index + 3 < oteStringBuf->sizeForUpdate())
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

								return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds
							}

							return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);			// Invalid code point
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
								else
								{
									return primitiveFailure(_PrimitiveFailureCode::UnmappableCharacter);
								}

							case StringEncoding::Utf16:
								// UTF-16 into UTF-16, can just write it, whether a surrogate or not
								if (index < oteStringBuf->sizeForUpdate())
								{
									oteStringBuf->m_location->m_characters[index] = static_cast<Utf16String::CU>(codeUnit);
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}
								else
								{
									return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds
								}

							case StringEncoding::Utf32:
								codePoint = codeUnit;
								break;

							default:
								// Unrecognised encoding
								__assume(false);
								return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);
							}

							if (U_IS_UNICODE_CHAR(codePoint))
							{
								if (U_IS_BMP(codePoint))
								{
									// One 16-bit code unit

									if (index < oteStringBuf->sizeForUpdate())
									{
										oteStringBuf->m_location->m_characters[index] = static_cast<Utf16String::CU>(codePoint);
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}
									else
									{
										return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds
									}
								}
								else
								{
									// Two 16-bit code units

									if (index + 1 < limit && index + 1 < oteStringBuf->sizeForUpdate())
									{
										codePoint -= 0x10000;
										Utf16String::CU* pChars = oteStringBuf->m_location->m_characters;
										pChars[index] = 0xd800 + static_cast<Utf16String::CU>((codePoint >> 10) & 0xffff);
										pChars[index + 1] = 0xdc00 + static_cast<Utf16String::CU>(codePoint & 0x3ff);
										writeStream->m_index = Integer::NewSigned32WithRef(index + 2);		// Increment the stream index
										*newSp = value;
										return newSp;
									}
									else
									{
										return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds
									}
								}
							}
							else
							{
								return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);			// Invalid code point
							}
						}

						case StringEncoding::Utf32:
						{
							// Writing into a Utf32 string
							Utf32StringOTE * oteStringBuf = reinterpret_cast<Utf32StringOTE*>(oteBuf);

							if (index < oteStringBuf->sizeForUpdate())
							{
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
									else
									{
										// else: UTF-8 surrogate, not a valid code unit for UTF-32
										return primitiveFailure(_PrimitiveFailureCode::UnmappableCharacter);
									}
									break;

								case StringEncoding::Utf16:
									// UTF-16 surrogates detected below
								case StringEncoding::Utf32:
									codePoint = codeUnit;
									break;
								default:
									__assume(false);
									return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);
								}

								if (U_IS_UNICODE_CHAR(codePoint))
								{
									oteStringBuf->m_location->m_characters[index] = codePoint;
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}
								else
								{
									return primitiveFailure(_PrimitiveFailureCode::IllegalCharacter);			// Invalid code point
								}
							}
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds
						}
						default:
							// Unrecogised string encoding of the buffer
							__assume(false);
							return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
						}
					}

					// Not a character
					return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
				}

				else if (oteBuf->m_oteClass == Pointers.ClassByteArray)
				{
					if (ObjectMemoryIsIntegerObject(value))
					{
						SmallUinteger intValue = ObjectMemoryIntegerValueOf(value);
						if (intValue <= 255)
						{
							ByteArrayOTE* oteByteArray = reinterpret_cast<ByteArrayOTE*>(oteBuf);

							if (index < limit && index < oteByteArray->sizeForUpdate())
							{
								oteByteArray->m_location->m_elements[index] = static_cast<uint8_t>(intValue);

								// Increment the stream index
								writeStream->m_index = Integer::NewSigned32WithRef(index + 1);
								// Return the argument
								*newSp = value;
								return newSp;
							}

							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Out of bounds
						}
					}

					return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Attempt to put non-SmallInteger or out of range 0..255
				}
			}
			else if (oteBuf->m_oteClass == Pointers.ClassArray)
			{
				ArrayOTE* oteArray = reinterpret_cast<ArrayOTE*>(oteBuf);

				// In bounds of Array?
				if (index < limit && index < oteArray->sizeForUpdate())
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

				return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Out of bounds
			}

			// Primitive response not supported for the streamed over collection
			return primitiveFailure(_PrimitiveFailureCode::NotSupported);
		}

		// Out of bounds of limit
		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
	}

	// Invalid stream
	return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
}

// Read basic elements from a stream. In the case of character streams, will read individual integer code units (unlike primitiveNext, which reads whole characters 
// potentially assembling them from more than one code unit)
Oop* PRIMCALL Interpreter::primitiveBasicNext(Oop* const sp, primargcount_t)
{
	PosStreamOTE* streamPointer = reinterpret_cast<PosStreamOTE*>(*sp);		// Access receiver

	PositionableStream* readStream = streamPointer->m_location;

	// Ensure valid stream - unusually this validity check is included in the Blue Book spec
	// and appears to be implemented in most Smalltalks, so we implement here too.
	if (ObjectMemoryIsIntegerObject(readStream->m_index) && ObjectMemoryIsIntegerObject(readStream->m_readLimit))
	{

		SmallInteger index = ObjectMemoryIntegerValueOf(readStream->m_index);
		SmallInteger limit = ObjectMemoryIntegerValueOf(readStream->m_readLimit);

		if (index >= 0 && index < limit)
		{
			OTE* oteBuf = readStream->m_array;
			BehaviorOTE* bufClass = oteBuf->m_oteClass;

			if (oteBuf->isBytes())
			{
				switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteBuf)))
				{
				case ByteElementSize::Bytes:
					if (static_cast<size_t>(index) < oteBuf->bytesSize())
					{
						uint8_t value = reinterpret_cast<BytesOTE*>(oteBuf)->m_location->m_fields[index];
						*sp = integerObjectOf(value);
						readStream->m_index = Integer::NewSigned32WithRef(index + 1);
						return sp;
					}
					else
						// Out of bounds
						return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

				case ByteElementSize::Words:
					if (static_cast<size_t>(index) < (oteBuf->bytesSize() / 2))
					{
						uint16_t value = reinterpret_cast<WordsOTE*>(oteBuf)->m_location->m_fields[index];
						*sp = integerObjectOf(value);
						readStream->m_index = Integer::NewSigned32WithRef(index + 1);
						return sp;
					}
					else
						// Out of bounds
						return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

				case ByteElementSize::Quads:
					if (static_cast<size_t>(index) < (oteBuf->bytesSize() / 4))
					{
						uint32_t value = reinterpret_cast<QuadsOTE*>(oteBuf)->m_location->m_fields[index];
						StoreUnsigned32()(sp, value);
						readStream->m_index = Integer::NewSigned32WithRef(index + 1);
						return sp;
					}
					else
						// Out of bounds
						return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

				default:
					__assume(false);
					return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
				}
			}

			else if (bufClass == Pointers.ClassArray)
			{
				ArrayOTE* oteArray = reinterpret_cast<ArrayOTE*>(oteBuf);
				if (static_cast<size_t>(index) < oteArray->pointersSize())
				{
					*sp = oteArray->m_location->m_elements[index];
					readStream->m_index = Integer::NewSigned32WithRef(index + 1);
					return sp;
				}
				return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
			}

			return primitiveFailure(_PrimitiveFailureCode::NotSupported);		// Collection cannot be handled by primitive, rely on Smalltalk code
		}

		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// index not in range 0<index<limit
	}

	return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);	// Receiver fails invariant check
}

// Like primitiveNextPut, but always writes an integer element. For a ByteArray, this will be a byte. For a string, it will be a code unit.
Oop* PRIMCALL Interpreter::primitiveBasicNextPut(Oop* const sp, primargcount_t)
{
	uintptr_t value = *sp;
	if (ObjectMemoryIsIntegerObject(value))
	{
		Oop* newSp = sp - 1;
		WriteStreamOTE* streamPointer = reinterpret_cast<WriteStreamOTE*>(*newSp);		// Access receiver under argument
		WriteStream* writeStream = streamPointer->m_location;

		// If the position or limits have overflowed SmallInteger range, then the primitive can't handle the request
		if (ObjectMemoryIsIntegerObject(writeStream->m_index) && ObjectMemoryIsIntegerObject(writeStream->m_writeLimit))
		{
			SmallInteger index = ObjectMemoryIntegerValueOf(writeStream->m_index);
			SmallInteger limit = ObjectMemoryIntegerValueOf(writeStream->m_writeLimit);
			OTE* oteBuf = writeStream->m_array;

			if (oteBuf->isBytes())
			{
				value = ObjectMemoryIntegerValueOf(value);

				switch (ObjectMemory::GetBytesElementSize(reinterpret_cast<BytesOTE*>(oteBuf)))
				{
				case ByteElementSize::Bytes:
					if (value <= 0xFF)
					{
						if (index < limit && index < oteBuf->bytesSizeForUpdate())
						{
							reinterpret_cast<BytesOTE*>(oteBuf)->m_location->m_fields[index] = value;
							writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
							*newSp = value;
							return newSp;
						}
						return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds
					}
					return primitiveFailure(_PrimitiveFailureCode::IntegerOutOfRange);	// Arg too large

				case ByteElementSize::Words:
					if (value <= 0xffff)
					{
						if (index < limit && index < oteBuf->bytesSizeForUpdate() / 2)
						{
							reinterpret_cast<WordsOTE*>(oteBuf)->m_location->m_fields[index] = value;
							writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
							*newSp = value;
							return newSp;
						}
						return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds
					}
					return primitiveFailure(_PrimitiveFailureCode::IntegerOutOfRange);	// Arg too large

				case ByteElementSize::Quads:
					if (index < limit && index < oteBuf->bytesSizeForUpdate() / 4)
					{
						reinterpret_cast<QuadsOTE*>(oteBuf)->m_location->m_fields[index] = value;
						writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
						*newSp = value;
						return newSp;
					}
					return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// Out of bounds

				default:
					// Unrecognised encoding, primitive response not available
					__assume(false);
					return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
				}
			}
			else if (oteBuf->m_oteClass == Pointers.ClassArray)
			{
				auto oteArray = reinterpret_cast<ArrayOTE*>(oteBuf);
				// In bounds of Array?
				if (index < limit && index < oteArray->sizeForUpdate())
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

				return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Out of bounds
			}
			// else: Primitive response not supported for the streamed over collection
			return primitiveFailure(_PrimitiveFailureCode::NotSupported);
		}

		// Invalid stream
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
	}

	// Invalid argument
	return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

// Non-standard, but has very beneficial effect on performance
Oop* PRIMCALL Interpreter::primitiveNextPutAll(Oop* const sp, primargcount_t)
{
	auto streamPointer = reinterpret_cast<WriteStreamOTE*>(*(sp-1));		// Access receiver under argument
	auto writeStream = streamPointer->m_location;
	
	// If the position or limits have overflowed SmallInteger range, then the primitive can't handle the request
	if (ObjectMemoryIsIntegerObject(writeStream->m_index) && ObjectMemoryIsIntegerObject(writeStream->m_writeLimit))
	{
		SmallInteger index = ObjectMemoryIntegerValueOf(writeStream->m_index);
		SmallInteger limit = ObjectMemoryIntegerValueOf(writeStream->m_writeLimit);

		if (index >= 0)
		{
			Oop value = *(sp);
			if (ObjectMemoryIsIntegerObject(value))
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
			auto oteValue = reinterpret_cast<OTE*>(value);

			auto oteBuf = writeStream->m_array;
			auto bufClass = oteBuf->m_oteClass;

			size_t newIndex;

			if (oteBuf->isBytes())
			{
				if (oteBuf->isNullTerminated())
				{
					if (!oteValue->isNullTerminated())
						return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
					auto oteStringArg= reinterpret_cast<StringOTE*>(oteValue);

					switch (ENCODINGPAIR(oteBuf->m_oteClass->m_location->m_instanceSpec.m_encoding, oteStringArg->m_oteClass->m_location->m_instanceSpec.m_encoding))
					{
					case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Ansi):
					{
						auto oteStringBuf = reinterpret_cast<AnsiStringOTE*>(oteBuf);
						auto oteAnsiString = reinterpret_cast<AnsiStringOTE*>(value);
						auto str = oteAnsiString->m_location;

						size_t valueSize = oteAnsiString->bytesSize();
						newIndex = static_cast<size_t>(index) + valueSize;

						if (newIndex > static_cast<size_t>(limit))			// Beyond write limit
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

						if (static_cast<ptrdiff_t>(newIndex) > oteStringBuf->sizeForUpdate())
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Attempt to write off end of buffer

						memcpy(oteStringBuf->m_location->m_characters + index, str->m_characters, valueSize);
					}
					break;

					case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
					{
						auto oteStringBuf = reinterpret_cast<Utf8StringOTE*>(oteBuf);
						auto oteUtf8String = reinterpret_cast<Utf8StringOTE*>(oteStringArg);
						auto str = oteUtf8String->m_location;

						size_t valueSize = oteUtf8String->bytesSize();
						newIndex = static_cast<size_t>(index) + valueSize;

						if (newIndex > static_cast<size_t>(limit))			// Beyond write limit
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

						if (static_cast<ptrdiff_t>(newIndex) > oteStringBuf->sizeForUpdate())
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Attempt to write off end of buffer

						memcpy(oteStringBuf->m_location->m_characters + index, str->m_characters, valueSize);
					}
					break;

					case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf8):
					case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
					case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf32):
					{
						// Fail it because the UTF arg may not be representable in ANSI. 
						// The Smalltalk backup code can decided what to do.
						return primitiveFailure(_PrimitiveFailureCode::UnmappableCharacter);
					}
					break;

					case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
					{
						// UTF-8, Ansi => Can write after translation, but we have to go indirectly via UTF16
						// TODO: Implement a direct ANSI to UTF-8 translation
						auto oteStringBuf = reinterpret_cast<Utf8StringOTE*>(oteBuf);
						Utf16StringBuf utf16(m_ansiCodePage, reinterpret_cast<const AnsiStringOTE*>(oteStringArg)->m_location->m_characters, oteStringArg->getSize());
						size_t valueSize = utf16.ToUtf8();

						newIndex = static_cast<size_t>(index) + valueSize;

						if (newIndex > static_cast<size_t>(limit))			// Beyond write limit
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

						if (static_cast<ptrdiff_t>(newIndex) > oteStringBuf->sizeForUpdate())
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Attempt to write off end of buffer

						utf16.ToUtf8(oteStringBuf->m_location->m_characters + index, valueSize);
					}
					break;

					case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
					{
						// Since both encodings can represent any string, we return a result that is the same class as the receiver, i.e.
						// UTF-8, Utf16 => UTF-8
						auto oteStringBuf = reinterpret_cast<Utf8StringOTE*>(oteBuf);
						const Utf16String::CU* pArgChars = reinterpret_cast<const Utf16StringOTE*>(oteStringArg)->m_location->m_characters;
						size_t cwchArg = oteStringArg->getSize() / sizeof(Utf16String::CU);
						int cbArg = ::WideCharToMultiByte(CP_UTF8, 0, (LPCWCH)pArgChars, cwchArg, nullptr, 0, nullptr, nullptr);
						ASSERT(cbArg >= 0);
						size_t valueSize = cbArg;

						newIndex = static_cast<size_t>(index) + valueSize;

						if (newIndex > static_cast<size_t>(limit))			// Beyond write limit
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

						if (static_cast<ptrdiff_t>(newIndex) > oteStringBuf->sizeForUpdate())
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Attempt to write off end of buffer (or immutable)

						auto pchDest = oteStringBuf->m_location->m_characters;
						::WideCharToMultiByte(CP_UTF8, 0, (LPCWCH)pArgChars, cwchArg, reinterpret_cast<LPSTR>(pchDest + index), cbArg, nullptr, nullptr);
					}
					break;

					case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
					{
						auto oteStringBuf = reinterpret_cast<Utf16StringOTE*>(oteBuf);
						auto pszArg = reinterpret_cast<const AnsiStringOTE*>(oteStringArg)->m_location->m_characters;
						size_t cchArg = oteStringArg->getSize();
						int cwchArg = ::MultiByteToWideChar(m_ansiCodePage, 0, pszArg, cchArg, nullptr, 0);
						ASSERT(cwchArg >= 0);
						size_t valueSize = cwchArg;
						newIndex = static_cast<size_t>(index) + valueSize;

						if (newIndex > static_cast<size_t>(limit))			// Beyond write limit
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

						if (static_cast<ptrdiff_t>(newIndex) > oteStringBuf->sizeForUpdate())
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Attempt to write off end of buffer (or immutable)

						auto pwsz = oteStringBuf->m_location->m_characters;
						::MultiByteToWideChar(m_ansiCodePage, 0, pszArg, cchArg, (LPWSTR)pwsz + index, cwchArg);
					}
					break;

					case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
					{
						auto oteStringBuf = reinterpret_cast<Utf16StringOTE*>(oteBuf);
						auto pszArg = reinterpret_cast<const Utf8StringOTE*>(oteStringArg)->m_location->m_characters;
						size_t cchArg = oteStringArg->getSize();
						int cwchArg = ::MultiByteToWideChar(CP_UTF8, 0, (LPCCH)pszArg, cchArg, nullptr, 0);
						ASSERT(cwchArg >= 0);
						size_t valueSize = cwchArg;
						newIndex = static_cast<size_t>(index) + valueSize;

						if (newIndex > static_cast<size_t>(limit))			// Beyond write limit
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

						if (static_cast<ptrdiff_t>(newIndex) > oteStringBuf->sizeForUpdate())
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Attempt to write off end of buffer (or immutable)

						auto pwsz = oteStringBuf->m_location->m_characters;
						::MultiByteToWideChar(CP_UTF8, 0, (LPCCH)pszArg, cchArg, reinterpret_cast<LPWSTR>(pwsz + index), cwchArg);
					}
					break;

					case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
					{
						auto oteStringBuf = reinterpret_cast<Utf16StringOTE*>(oteBuf);
						auto oteUtf16String = reinterpret_cast<Utf16StringOTE*>(oteStringArg);
						auto str = oteUtf16String->m_location;

						size_t valueSize = oteUtf16String->bytesSize()/sizeof(Utf16String::CU);
						newIndex = static_cast<size_t>(index) + valueSize;

						if (newIndex > static_cast<size_t>(limit))			// Beyond write limit
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

						if (static_cast<ptrdiff_t>(newIndex) > oteStringBuf->sizeForUpdate())
							return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Attempt to write off end of buffer (or immutable)

						auto pwsz = oteStringBuf->m_location->m_characters;
						memcpy(pwsz + index, str->m_characters, valueSize*sizeof(Utf16String::CU));
					}
					break;

					case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf32):
					case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf32):
					case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf32):
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
				else if (bufClass == Pointers.ClassByteArray)
				{
					auto oteBytesBuf = reinterpret_cast<ByteArrayOTE*>(oteBuf);

					if (ObjectMemory::fetchClassOf(value) != bufClass)
						return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Attempt to put non-ByteArray

					auto oteBytes = reinterpret_cast<ByteArrayOTE*>(value);
					auto bytes = oteBytes->m_location;
					size_t valueSize = oteBytes->bytesSize();
					newIndex = static_cast<size_t>(index) + valueSize;

					if (newIndex > static_cast<size_t>(limit))			// Beyond write limit
						return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

					if (static_cast<ptrdiff_t>(newIndex) > oteBytesBuf->sizeForUpdate())
						return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Attempt to write off end of buffer (or immutable)

					auto pb = oteBytesBuf->m_location->m_elements;
					memcpy(pb + index, bytes->m_elements, valueSize);
				}
				else
					return primitiveFailure(_PrimitiveFailureCode::NotSupported);
			}
			else if (bufClass == Pointers.ClassArray)
			{
				auto oteArrayBuf = reinterpret_cast<ArrayOTE*>(oteBuf);

				if (ObjectMemory::fetchClassOf(value) != Pointers.ClassArray)
					return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Attempt to put non-Array

				auto oteArray = reinterpret_cast<ArrayOTE*>(value);
				auto array = oteArray->m_location;
				size_t valueSize = oteArray->pointersSize();
				newIndex = static_cast<size_t>(index) + valueSize;

				if (newIndex > static_cast<size_t>(limit))			// Beyond write limit
					return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

				if (static_cast<ptrdiff_t>(newIndex) > oteArrayBuf->sizeForUpdate())
					return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Attempt to write off end of buffer (or immutable)

				auto pTarget = oteArrayBuf->m_location->m_elements;

				for (auto i = 0u; i < valueSize; i++)
				{
					ObjectMemory::storePointerWithValue(pTarget[index + i], array->m_elements[i]);
				}
			}
			else
				return primitiveFailure(_PrimitiveFailureCode::NotSupported);

			writeStream->m_index = Integer::NewUnsigned32WithRef(newIndex);		// Increment the stream index

			// As we no longer pop stack here, the receiver is still under the argument
			*(sp - 1) = value;

			return sp - 1;
		}

		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// stream position negative
	}

	return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);	// Primitive response not possible for state of Stream
}

// The primitive handles PositionableStream>>atEnd, but only for arrays/strings
Oop* PRIMCALL Interpreter::primitiveAtEnd(Oop* const sp, primargcount_t)
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
			*sp = reinterpret_cast<Oop>(index >= readLimit || (static_cast<size_t>(ObjectMemoryIntegerValueOf(index)) >= readStream->m_array->bytesSize())
				? Pointers.True : Pointers.False);
			return sp;
		}
		else if (bufClass == Pointers.ClassArray)
		{
			*sp = reinterpret_cast<Oop>(index >= readLimit || (static_cast<size_t>(ObjectMemoryIntegerValueOf(index)) >= readStream->m_array->pointersSize())
				? Pointers.True : Pointers.False);
			return sp;
		}

		return primitiveFailure(_PrimitiveFailureCode::NotSupported);		// Doesn't work for non-Strings/ByteArrays/Arrays, or if out of bounds
	}
	return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
}


// This primitive handles PositionableStream>>nextSDWORD, but only for byte-arrays
// Unary message, so does not modify stack pointer
Oop* PRIMCALL Interpreter::primitiveNextInt32(Oop* const sp, primargcount_t)
{
	PosStreamOTE* streamPointer = reinterpret_cast<PosStreamOTE*>(*sp);		// Access receiver
	PositionableStream* readStream = streamPointer->m_location;

	// Ensure valid stream - unusually this validity check is included in the Blue Book spec
	// and appears to be implemented in most Smalltalks, so we implement here too.
	if (!ObjectMemoryIsIntegerObject(readStream->m_index) ||
		!ObjectMemoryIsIntegerObject(readStream->m_readLimit))
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);	// Receiver fails invariant check

	SmallInteger index = ObjectMemoryIntegerValueOf(readStream->m_index);
	SmallInteger limit = ObjectMemoryIntegerValueOf(readStream->m_readLimit);

	// Is the current index within the limits of the collection?
	// Remember that the index is 1 based (it's a Smalltalk index), and we're 0 based,
	// so we don't need to increment it until after we've got the next object
	if (index < 0 || index >= limit)
		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);		// No, fail it

	OTE* oteBuf = readStream->m_array;
	BehaviorOTE* bufClass = oteBuf->m_oteClass;
	
	if (bufClass != Pointers.ClassByteArray)
		return primitiveFailure(_PrimitiveFailureCode::NotSupported);		// Collection cannot be handled by primitive, rely on Smalltalk code

	ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(oteBuf);

	const auto newIndex = index + sizeof(int32_t);
	if (static_cast<size_t>(newIndex) > oteBytes->bytesSize())
		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

	const Oop oopNewIndex = ObjectMemoryIntegerObjectOf(newIndex);
	if (static_cast<SmallInteger>(oopNewIndex) < 0)
		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// index overflowed SmallInteger range

	// When incrementing the index we must allow for it overflowing a SmallInteger, even though
	// this is extremely unlikely in practice
	readStream->m_index = oopNewIndex;

	// Receiver is overwritten
	ByteArray* byteArray = oteBytes->m_location;

	*sp = Integer::NewSigned32(*reinterpret_cast<int32_t*>(byteArray->m_elements + index));
	ObjectMemory::AddOopToZct(*sp);
	return sp;
}

