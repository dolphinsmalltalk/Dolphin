/******************************************************************************

	File: STCharacter.h

	Description:

	VM representation of Smalltalk Character class.

	N.B. The class here defined is well known to the VM, and must not
	be modified in the image. Note also that this class may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STMagnitude.h"
#include "ote.h"

namespace ST { class Character; }
typedef TOTE<ST::Character> CharOTE;

namespace ST
{
	class Character : public Magnitude
	{
	public:
		SmallInteger m_code;		// Small integer value.
		static constexpr size_t CharacterValueIndex = Magnitude::FixedSize;
		static constexpr size_t FixedSize = CharacterValueIndex + 1;
		static constexpr SmallInteger EncodingMask = 0x3F000000;
		static constexpr SmallInteger Utf16Mask = 0x2000000;
		static constexpr SmallInteger Utf8Mask = 0x1000000;

		static CharOTE* NewAnsi(unsigned char value);
		static CharOTE* NewUtf8(char8_t value);
		static CharOTE* NewUtf32(char32_t value);
		static CharOTE* NewUtf16(char16_t value);

		__declspec(property(get = getEncoding)) StringEncoding Encoding;
		StringEncoding getEncoding() const { return static_cast<StringEncoding>((m_code >> 25) & 0x3); }

		__declspec(property(get = getCodeUnit)) char32_t CodeUnit;
		char32_t getCodeUnit() const { return ObjectMemoryIntegerValueOf(m_code) & 0xffffff; }

		__declspec(property(get = getCodePoint)) char32_t CodePoint;
		char32_t getCodePoint() const;

		__declspec(property(get = getIsUtf8Surrogate)) boolean IsUtf8Surrogate;
		boolean getIsUtf8Surrogate() const
		{
			return (ObjectMemoryIntegerValueOf(m_code) & (EncodingMask | 0x80)) == (Utf8Mask | 0x80);
		}

		__declspec(property(get = getIsUtf16Surrogate)) boolean IsUtf16Surrogate;
		boolean getIsUtf16Surrogate() const
		{
			return (ObjectMemoryIntegerValueOf(m_code) & (EncodingMask | 0xF800)) == (Utf16Mask | 0xD800);
		}

		__declspec(property(get = getIsUtfSurrogate)) boolean IsUtfSurrogate;
		boolean getIsUtfSurrogate() const
		{
			return IsUtf8Surrogate | IsUtf16Surrogate;
		}
	};
}

std::wostream& operator<<(std::wostream& st, const CharOTE* oteCh);
