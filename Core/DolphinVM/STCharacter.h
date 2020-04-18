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

		static CharOTE* NewAnsi(unsigned char value);
		static CharOTE* NewUnicode(char32_t value);

		__declspec(property(get = getEncoding)) StringEncoding Encoding;
		StringEncoding getEncoding() const { return static_cast<StringEncoding>((m_code >> 25) & 0x3); }

		__declspec(property(get = getCodeUnit)) char32_t CodeUnit;
		char32_t getCodeUnit() const { return ObjectMemoryIntegerValueOf(m_code) & 0xffffff; }

		__declspec(property(get = getCodePoint)) char32_t CodePoint;
		char32_t getCodePoint() const;
	};
}

std::wostream& operator<<(std::wostream& st, const CharOTE* oteCh);
