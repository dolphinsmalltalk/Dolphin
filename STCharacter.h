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
	};

	inline CharOTE* Character::NewUnicode(uint32_t value)
	{
		CharOTE* character;

		if (value < 0x80)
		{
			character = NewAnsi(static_cast<unsigned char>(value));
		}
		else
		{
			character = reinterpret_cast<CharOTE*>(ObjectMemory::newPointerObject(Pointers.ClassCharacter));
			MWORD code = (static_cast<MWORD>(StringEncoding::Utf32) << 24) | value;
			character->m_location->m_code = ObjectMemoryIntegerObjectOf(code);
			character->beImmutable();
		}

		return character;
	}

	// Characters are not reference counted - very important that param is unsigned in order to calculate offset of
	// character object in OTE correctly (otherwise chars > 127 will probably offset off the front of the OTE).
	inline CharOTE* Character::NewAnsi(unsigned char value)
	{
		CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::PointerFromIndex(ObjectMemory::FirstCharacterIdx + value));
		ASSERT(ObjectMemoryIntegerValueOf(character->m_location->m_code) == ((static_cast<MWORD>(StringEncoding::Ansi) << 24) | value));
		return character;
	}
}

wostream& operator<<(wostream& st, const CharOTE* oteCh);
