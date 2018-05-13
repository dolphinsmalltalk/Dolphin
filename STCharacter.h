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
#include "STString.h"

namespace ST { class Character; }
typedef TOTE<ST::Character> CharOTE;

namespace ST
{
	class Character : public Magnitude
	{
	public:
		Oop m_code;		// Small integer value.
		enum { CharacterValueIndex = Magnitude::FixedSize, FixedSize };

		static CharOTE* NewAnsi(unsigned char value);
		static CharOTE* NewUnicode(MWORD value);

		__declspec(property(get = getEncoding)) StringEncoding Encoding;
		StringEncoding getEncoding() const { return static_cast<StringEncoding>(m_code >> 25); }

		__declspec(property(get = getCodeUnit)) MWORD CodeUnit;
		MWORD getCodeUnit() const { return ObjectMemoryIntegerValueOf(m_code) & 0xffffff; }

		__declspec(property(get = getCodePoint)) uint32_t CodePoint;
		uint32_t getCodePoint() const;
	};
}

wostream& operator<<(wostream& st, const CharOTE* oteCh);
