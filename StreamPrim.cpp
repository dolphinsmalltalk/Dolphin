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

// This primitive handles PositionableStream>>next, but only for Arrays, Strings and ByteArrays
// Unary message, so does not modify stack pointer
Oop* __fastcall Interpreter::primitiveNext(Oop* const sp)
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
				case StringEncoding::Utf8:
				{
					Utf8StringOTE* oteString = reinterpret_cast<Utf8StringOTE*>(oteBuf);
					MWORD size = oteString->bytesSize();
					if (MWORD(index) < size)
					{
						const Utf8String::CU* psz = oteString->m_location->m_characters;

						SMALLINTEGER codePoint;
						U8_NEXT(psz, index, static_cast<SMALLINTEGER>(size), codePoint);

						if (codePoint >= 0)
						{
							PushCharacter(sp, codePoint);
							// When incrementing the index we must allow for it overflowing a SmallInteger, even though
							// this is extremely unlikely in practice
							readStream->m_index = Integer::NewSigned32WithRef(index);
							return sp;									// Succeed
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
					if (MWORD(index) < size)
					{
						WCHAR* pwsz = oteString->m_location->m_characters;
						SMALLINTEGER codePoint;
						U16_NEXT(pwsz, index, size, codePoint);

						if (!U16_IS_SURROGATE(codePoint))
						{
							PushCharacter(sp, codePoint);
							readStream->m_index = Integer::NewSigned32WithRef(index);
							return sp;									// Succeed
						}

						return primitiveFailure(4);	// Malformed UTF-16, or reading starting at an invalid offset
					}

					return primitiveFailure(3);
				}
				break;

				case StringEncoding::Ansi:
				default:
				{
					ByteStringOTE* oteString = reinterpret_cast<ByteStringOTE*>(oteBuf);

					// Check in bounds (and that index not negative)
					if (index < limit && MWORD(index) < oteString->bytesSize())
					{
						ByteString* buf = oteString->m_location;
						unsigned char ansiCodeUnit = static_cast<unsigned char>(buf->m_characters[index]);
						PushCharacter(sp, static_cast<MWORD>(m_ansiToUnicodeCharMap[ansiCodeUnit]));
						readStream->m_index = Integer::NewSigned32WithRef(index + 1);
						return sp;
					}
					return primitiveFailure(3);
				}
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

Oop* __fastcall Interpreter::primitiveNextByte(Oop* const sp)
{
	PosStreamOTE* streamPointer = reinterpret_cast<PosStreamOTE*>(*sp);		// Access receiver

	PositionableStream* readStream = streamPointer->m_location;

	// Ensure valid stream - unusually this validity check is included in the Blue Book spec
	// and appears to be implemented in most Smalltalks, so we implement here too.
	if (ObjectMemoryIsIntegerObject(readStream->m_index) && ObjectMemoryIsIntegerObject(readStream->m_readLimit) && readStream->m_array->isBytes())
	{
		SMALLINTEGER index = ObjectMemoryIntegerValueOf(readStream->m_index);
		SMALLINTEGER limit = ObjectMemoryIntegerValueOf(readStream->m_readLimit);

		ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(readStream->m_array);

		if (index >= 0 && index < limit && MWORD(index) < oteBytes->bytesSize())
		{
			*sp = ObjectMemoryIntegerObjectOf(oteBytes->m_location->m_elements[index]);
			readStream->m_index = Integer::NewSigned32WithRef(index + 1);
			return sp;
		}

		return primitiveFailure(1);		// index not in range
	}

	return primitiveFailure(0);	// Receiver not valid for this primitive
}

// This primitive handles WriteStream>>nextPut:, but only for Arrays, Strings & ByteArrays
// It appears relatively complex because of the new support for String encodings, but it isn't really
Oop* __fastcall Interpreter::primitiveNextPut(Oop* const sp)
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
		if (index >= 0)
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
							ByteStringOTE * oteStringBuf = reinterpret_cast<ByteStringOTE*>(oteBuf);
							switch (character->Encoding)
							{
							case StringEncoding::Ansi:
								if (index < limit && index < oteStringBuf->bytesSizeForUpdate())
								{
									oteStringBuf->m_location->m_characters[index] = codeUnit;
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}

								return primitiveFailure(3);		// Out of bounds

							case StringEncoding::Utf8:
								if (__isascii(codeUnit))
								{
									if (index < limit && index < oteStringBuf->bytesSizeForUpdate())
									{
										oteStringBuf->m_location->m_characters[index] = codeUnit;
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}
									else
										return primitiveFailure(3);		// Out of bounds
								}
								// else not a valid UTF-8 code unit to store in an Ansi string
								break;

							case StringEncoding::Utf16:
								if (!U_IS_SURROGATE(codeUnit) && (codeUnit == 0 || (codeUnit = m_unicodeToAnsiCharMap[codeUnit]) != 0))
								{
									if (index < limit && index < oteStringBuf->bytesSizeForUpdate())
									{
										oteStringBuf->m_location->m_characters[index] = codeUnit;
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}
									else
										return primitiveFailure(3);		// Out of bounds
								}
								// else not a valid code unit to store in an Ansi string
								break;

							case StringEncoding::Utf32:
								if (codeUnit == 0 || (U_IS_BMP(codeUnit) && (codeUnit = m_unicodeToAnsiCharMap[codeUnit]) != 0))
								{
									if (index < limit && index < oteStringBuf->bytesSizeForUpdate())
									{
										oteStringBuf->m_location->m_characters[index] = codeUnit;
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}
									else
										return primitiveFailure(3);		// Out of bounds
								}
								break;
							}
							break;
						}

						case StringEncoding::Utf8:
						{
							Utf8StringOTE* oteStringBuf = reinterpret_cast<Utf8StringOTE*>(oteBuf);
							MWORD codeUnit = character->CodeUnit;

							switch (character->Encoding)
							{
							case StringEncoding::Ansi:
								// Ansi character - may require more than one byte to represent in UTF-8

								if (__isascii(codeUnit))
								{
									// Single byte encoding

									if (index < limit && index < oteStringBuf->bytesSizeForUpdate())
									{
										oteStringBuf->m_location->m_characters[index] = codeUnit;
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}

									return primitiveFailure(3);		// Out of bounds
								}
								else
								{
									MWORD codePoint = m_ansiToUnicodeCharMap[codeUnit];

									if (codePoint < 0x800)
									{
										// Two byte encoding

										if (index + 1 < limit && index + 1 < oteStringBuf->bytesSizeForUpdate())
										{
											Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
											pChars[index] = 0xC0 | (codePoint >> 6);
											pChars[index + 1] = 0x80 | (codePoint & 0x3f);
											writeStream->m_index = Integer::NewSigned32WithRef(index + 2);		// Increment the stream index
											*newSp = value;
											return newSp;
										}

										return primitiveFailure(3);		// Out of bounds
									}
									else if (codePoint < 0xffff)
									{
										// Three byte encoding
										if (index + 2 < limit && index + 2 < oteStringBuf->bytesSizeForUpdate())
										{
											Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
											pChars[index] = 0xe0 | (codePoint >> 12);
											pChars[index + 1] = 0x80 | ((codePoint >> 6) & 0x3f);
											pChars[index + 2] = 0x80 | (codePoint & 0x3f);
											writeStream->m_index = Integer::NewSigned32WithRef(index + 3);		// Increment the stream index
											*newSp = value;
											return newSp;
										}

										return primitiveFailure(3);		// Out of bounds
									}
									// Four byte encodings are not possible
								}
								break;

							case StringEncoding::Utf8:
								// UTF-8 Character, write it directly as is (so will also work for surrogates)

								if (index < limit && index < oteStringBuf->bytesSizeForUpdate())
								{
									oteStringBuf->m_location->m_characters[index] = codeUnit;
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}
								break;

							case StringEncoding::Utf16:
								// UTF-16 Character: We can only write these to a UTF-8 buffer if they are not surrogates

								if (!U_IS_SURROGATE(codeUnit))
								{
									if (__isascii(codeUnit))
									{
										// Single byte encoding

										if (index < limit && index < oteStringBuf->bytesSizeForUpdate())
										{
											oteStringBuf->m_location->m_characters[index] = codeUnit;
											writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
											*newSp = value;
											return newSp;
										}

										return primitiveFailure(3);		// Out of bounds
									}
									else if (codeUnit < 0x800)
									{
										// Two byte encoding

										if (index + 1 < limit && index + 1 < oteStringBuf->bytesSizeForUpdate())
										{
											Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
											pChars[index] = 0xC0 | (codeUnit >> 6);
											pChars[index + 1] = 0x80 | (codeUnit & 0x3f);
											writeStream->m_index = Integer::NewSigned32WithRef(index + 2);		// Increment the stream index
											*newSp = value;
											return newSp;
										}

										return primitiveFailure(3);		// Out of bounds
									}
									else if (codeUnit < 0xffff)
									{
										// Three byte encoding
										if (index + 2 < limit && index + 2 < oteStringBuf->bytesSizeForUpdate())
										{
											Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
											pChars[index] = 0xe0 | (codeUnit >> 12);
											pChars[index + 1] = 0x80 | ((codeUnit >> 6) & 0x3f);
											pChars[index + 2] = 0x80 | (codeUnit & 0x3f);
											writeStream->m_index = Integer::NewSigned32WithRef(index + 3);		// Increment the stream index
											*newSp = value;
											return newSp;
										}

										return primitiveFailure(3);		// Out of bounds
									}
									// Four byte encodings are not possible from one UTF-16 code unit
								}
								// else: UTF-16 surrogate, not a valid code unit for UTF-8
								break;

							case StringEncoding::Utf32:
								// Full Unicode code point - we can encode any of these in UTF-8, though it may require up to 4 bytes.

								if (__isascii(codeUnit))
								{
									// Single byte encoding

									if (index < limit && index < oteStringBuf->bytesSizeForUpdate())
									{
										oteStringBuf->m_location->m_characters[index] = codeUnit;
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}

									return primitiveFailure(3);		// Out of bounds
								}
								else if (codeUnit < 0x800)
								{
									// Two byte encoding

									if (index + 1 < limit && index + 1 < oteStringBuf->bytesSizeForUpdate())
									{
										Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
										pChars[index] = 0xC0 | (codeUnit >> 6);
										pChars[index + 1] = 0x80 | (codeUnit & 0x3f);
										writeStream->m_index = Integer::NewSigned32WithRef(index + 2);		// Increment the stream index
										*newSp = value;
										return newSp;
									}

									return primitiveFailure(3);		// Out of bounds
								}
								else if (codeUnit < 0xffff)
								{
									// Three byte encoding
									if (index + 2 < limit && index + 2 < oteStringBuf->bytesSizeForUpdate())
									{
										Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
										pChars[index] = 0xe0 | (codeUnit >> 12);
										pChars[index + 1] = 0x80 | ((codeUnit >> 6) & 0x3f);
										pChars[index + 2] = 0x80 | (codeUnit & 0x3f);
										writeStream->m_index = Integer::NewSigned32WithRef(index + 3);		// Increment the stream index
										*newSp = value;
										return newSp;
									}

									return primitiveFailure(3);		// Out of bounds
								}
								else if (codeUnit <= MAX_UCSCHAR)
								{
									// Four byte encoding
									if (index + 3 < limit && index + 3 < oteStringBuf->bytesSizeForUpdate())
									{
										Utf8String::CU* pChars = oteStringBuf->m_location->m_characters;
										pChars[index] = 0xf0 | (codeUnit >> 18);
										pChars[index + 1] = 0x80 | ((codeUnit >> 12) & 0x3f);
										pChars[index + 2] = 0x80 | ((codeUnit >> 6) & 0x3f);
										pChars[index + 3] = 0x80 | (codeUnit & 0x3f);
										writeStream->m_index = Integer::NewSigned32WithRef(index + 4);		// Increment the stream index
										*newSp = value;
										return newSp;
									}

									return primitiveFailure(3);		// Out of bounds
								}
								break;

							default:
								break;
							}

							return primitiveFailure(4);			// Invalid code point
						}

						case StringEncoding::Utf16:
						{
							Utf16StringOTE* oteStringBuf = reinterpret_cast<Utf16StringOTE*>(oteBuf);

							switch (character->Encoding)
							{
							case StringEncoding::Ansi:
								// Ansi encoded char, can never require more than one UTF-16 code point
								if (index < limit && (index * 2) < oteStringBuf->bytesSizeForUpdate())
								{
									oteStringBuf->m_location->m_characters[index] = m_ansiToUnicodeCharMap[codeUnit];
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}
								else
									return primitiveFailure(2);		// Out of bounds
								break;

							case StringEncoding::Utf8:
								// UTF-8 encoded char, can only write these if not surrogates

								if (index < limit && index < (oteStringBuf->bytesSizeForUpdate() / (int)sizeof(Utf16String::CU)))
								{
									if (__isascii(codeUnit))
									{
										oteStringBuf->m_location->m_characters[index] = codeUnit;
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}
									// else: UTF-8 surrogate, not a valid code unit for UTF-16
								}
								else
									return primitiveFailure(2);		// Out of bounds
								break;

							case StringEncoding::Utf16:
								if (index < limit && index < (oteStringBuf->bytesSizeForUpdate() / (int)sizeof(Utf16String::CU)))
								{
									oteStringBuf->m_location->m_characters[index] = codeUnit;
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;
								}
								else
									return primitiveFailure(2);		// Out of bounds
								break;

							case StringEncoding::Utf32:
								if (U_IS_BMP(codeUnit))
								{
									// One 16-bit code unit

									if (index < limit && index < (oteStringBuf->bytesSizeForUpdate() / (int)sizeof(Utf16String::CU)))
									{
										oteStringBuf->m_location->m_characters[index] = codeUnit;
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}

									return primitiveFailure(2);		// Out of bounds
								}
								else if (codeUnit <= MAX_UCSCHAR)
								{
									// Two 16-bit code units

									if (index + 1 < limit && index + 1 < oteStringBuf->bytesSizeForUpdate() / (int)sizeof(Utf16String::CU))
									{
										codeUnit -= 0x10000;
										Utf16String::CU* pChars = oteStringBuf->m_location->m_characters;
										pChars[index] = 0xd800 + (codeUnit >> 10);
										pChars[index + 1] = 0xdc00 + (codeUnit & 0x3ff);
										writeStream->m_index = Integer::NewSigned32WithRef(index + 2);		// Increment the stream index
										*newSp = value;
										return newSp;
									}

									return primitiveFailure(3);		// Out of bounds
								}
							default:
								break;
							}

							return primitiveFailure(4);			// Invalid code point
						}

						case StringEncoding::Utf32:
							if (index < limit && index < oteBuf->bytesSizeForUpdate() / (int)sizeof(Utf32String::CU))
							{
								Utf32StringOTE * oteStringBuf = reinterpret_cast<Utf32StringOTE*>(oteBuf);
								switch (character->Encoding)
								{
								case StringEncoding::Ansi:
									oteStringBuf->m_location->m_characters[index] = m_ansiToUnicodeCharMap[codeUnit];
									writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
									*newSp = value;
									return newSp;

								case StringEncoding::Utf8:
									if (__isascii(codeUnit))
									{
										oteStringBuf->m_location->m_characters[index] = codeUnit;
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}
									// else: UTF-8 surrogate, not a valid code unit for UTF-32
									break;

								case StringEncoding::Utf16:
									if (!U_IS_SURROGATE(codeUnit))
									{
										oteStringBuf->m_location->m_characters[index] = codeUnit;
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}
									// else: UTF-16 surrogate, not a valid code unit for UTF-32
									break;

								case StringEncoding::Utf32:
									if (codeUnit <= MAX_UCSCHAR)
									{
										oteStringBuf->m_location->m_characters[index] = codeUnit;
										writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
										*newSp = value;
										return newSp;
									}
									break;

								default:
									break;
								}

								return primitiveFailure(4);			// Invalid code point
							}
							return primitiveFailure(2);		// Out of bounds

						default:
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

							return primitiveFailure(3);	// Out of bounds
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

				return primitiveFailure(3);	// Out of bounds
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

// Like primitiveNextPut, but always writes a single byte, and to any byte object
Oop* __fastcall Interpreter::primitiveBasicNextPut(Oop* const sp)
{
	MWORD value;
	if (ObjectMemoryIsIntegerObject(*sp) && (value = ObjectMemoryIntegerValueOf(*sp)) <= 0xff)
	{
		Oop* newSp = sp - 1;
		WriteStreamOTE* streamPointer = reinterpret_cast<WriteStreamOTE*>(*newSp);		// Access receiver under argument
		WriteStream* writeStream = streamPointer->m_location;

		// Ensure valid stream && collection
		if (ObjectMemoryIsIntegerObject(writeStream->m_index) && ObjectMemoryIsIntegerObject(writeStream->m_writeLimit))
		{
			SMALLINTEGER index = ObjectMemoryIntegerValueOf(writeStream->m_index);
			SMALLINTEGER limit = ObjectMemoryIntegerValueOf(writeStream->m_writeLimit);
			OTE* oteArray = writeStream->m_array;

			if (oteArray->isBytes())
			{
				if (oteArray->isNullTerminated())
				{
					switch (reinterpret_cast<StringClass*>(oteArray->m_oteClass->m_location)->Encoding)
					{
					case StringEncoding::Ansi:
					case StringEncoding::Utf8:
						if (index < limit && index < oteArray->bytesSizeForUpdate() / (int)sizeof(ByteString::CU))
						{
							reinterpret_cast<ByteStringOTE*>(oteArray)->m_location->m_characters[index] = value;
							writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
							*newSp = value;
							return newSp;
						}
						return primitiveFailure(3);		// Out of bounds

					case StringEncoding::Utf16:
						if (index < limit && index < oteArray->bytesSizeForUpdate() / (int)sizeof(Utf16String::CU))
						{
							reinterpret_cast<Utf16StringOTE*>(oteArray)->m_location->m_characters[index] = value;
							writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index
							*newSp = value;
							return newSp;
						}
						return primitiveFailure(3);		// Out of bounds

					case StringEncoding::Utf32:
						if (index < limit && index < oteArray->bytesSizeForUpdate() / (int)sizeof(Utf32String::CU))
						{
							reinterpret_cast<Utf16StringOTE*>(oteArray)->m_location->m_characters[index] = value;
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
				else if (oteArray->m_oteClass == Pointers.ClassByteArray)
				{
					if (index >= 0 && index < limit)
					{
						if (index < oteArray->bytesSizeForUpdate())
						{
							reinterpret_cast<BytesOTE*>(oteArray)->m_location->m_fields[index] = static_cast<BYTE>(value);
							writeStream->m_index = Integer::NewSigned32WithRef(index + 1);
							*newSp = value;
							return newSp;
						}
						return primitiveFailure(3);
					}
					return primitiveFailure(2);	// Out of bounds
				}
				else if (oteArray->m_oteClass == Pointers.ClassArray)
				{
					// In bounds of Array?
					if (index < limit && index < oteArray->pointersSizeForUpdate())
					{
						Array* buf = reinterpret_cast<ArrayOTE*>(oteArray)->m_location;
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
	}
	// Invalid argument
	return primitiveFailure(4);
}

// Non-standard, but has very beneficial effect on performance
Oop* __fastcall Interpreter::primitiveNextPutAll(Oop* const sp)
{
	WriteStreamOTE* streamPointer = reinterpret_cast<WriteStreamOTE*>(*(sp-1));		// Access receiver under argument
	WriteStream* writeStream = streamPointer->m_location;
	
	// Ensure valid stream - checks from Blue Book
	if (!ObjectMemoryIsIntegerObject(writeStream->m_index) ||
		!ObjectMemoryIsIntegerObject(writeStream->m_writeLimit))
		return primitiveFailure(0);	// Fails invariant check

	SMALLINTEGER index = ObjectMemoryIntegerValueOf(writeStream->m_index);
	SMALLINTEGER limit = ObjectMemoryIntegerValueOf(writeStream->m_writeLimit);

	if (index < 0)
		return primitiveFailure(2);

	Oop value = *(sp);
	
	OTE* oteBuf = writeStream->m_array;
	BehaviorOTE* bufClass = oteBuf->m_oteClass;

	MWORD newIndex;

	// TODO: Support other string encodings

	if (bufClass == Pointers.ClassByteString)
	{
		BehaviorOTE* oteClass = ObjectMemory::fetchClassOf(value);
		if (oteClass != Pointers.ClassByteString && oteClass != Pointers.ClassSymbol)
			return primitiveFailure(4);	// Attempt to put non-string

		ByteStringOTE* oteString = reinterpret_cast<ByteStringOTE*>(value);
		ByteString* str = oteString->m_location;
		
		MWORD valueSize = oteString->bytesSize();
		newIndex = MWORD(index)+valueSize;

		if (newIndex >= static_cast<MWORD>(limit))			// Beyond write limit
			return primitiveFailure(2);

		if (static_cast<int>(newIndex) >= oteBuf->bytesSizeForUpdate())
			return primitiveFailure(3);	// Attempt to write off end of buffer

		ByteString* buf = static_cast<ByteString*>(oteBuf->m_location);
		memcpy(buf->m_characters+index, str->m_characters, valueSize);
	}
	else if (bufClass == Pointers.ClassByteArray)
	{
		if (ObjectMemory::fetchClassOf(value) != bufClass)
			return primitiveFailure(4);	// Attempt to put non-ByteArray

		ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(value);
		ByteArray* bytes = oteBytes->m_location;
		MWORD valueSize = oteBytes->bytesSize();
		newIndex = MWORD(index)+valueSize;

		if (newIndex >= (MWORD)limit)			// Beyond write limit
			return primitiveFailure(2);

		if (static_cast<int>(newIndex) >= oteBuf->bytesSizeForUpdate())
			return primitiveFailure(3);	// Attempt to write off end of buffer

		ByteArray* buf = static_cast<ByteArray*>(oteBuf->m_location);
		memcpy(buf->m_elements+index, bytes->m_elements, valueSize);
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
	*(sp-1) = value;

	return sp - 1;
}

// The primitive handles PositionableStream>>atEnd, but only for arrays/strings
Oop* __fastcall Interpreter::primitiveAtEnd(Oop* const sp)
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
Oop* __fastcall Interpreter::primitiveNextSDWORD(Oop* const sp)
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

	Oop result = Integer::NewSigned32(*reinterpret_cast<SDWORD*>(byteArray->m_elements + index));
	*sp = result;
	ObjectMemory::AddToZct(result);
	return sp;
}

