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

namespace ST { class Character; }
typedef TOTE<ST::Character> CharOTE;

namespace ST
{
	class Character : public Magnitude
	{
	public:
		Oop m_codePoint;		// Small integer value
		enum { CharacterValueIndex = Magnitude::FixedSize, FixedSize };

		static CharOTE* New(unsigned char value);
		static CharOTE* New(MWORD value);
	};

	// Characters are not reference counted - very important that param is unsigned in order to calculate offset of
	// character object in OTE correctly (otherwise chars > 127 will probably offset off the front of the OTE).
	inline CharOTE* Character::New(MWORD value)
	{
		CharOTE* character;
		if (value > 255)
		{
			character = reinterpret_cast<CharOTE*>(ObjectMemory::newPointerObject(Pointers.ClassCharacter));
			character->m_location->m_codePoint = ObjectMemoryIntegerObjectOf(value);
			character->beImmutable();
		}
		else
		{
			character = New(static_cast<unsigned char>(value));
		}
		return character;
	}

	// Characters are not reference counted - very important that param is unsigned in order to calculate offset of
	// character object in OTE correctly (otherwise chars > 127 will probably offset off the front of the OTE).
	inline CharOTE* Character::New(unsigned char value)
	{
		CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::PointerFromIndex(ObjectMemory::FirstCharacterIdx + value));
		ASSERT(character->m_location->m_codePoint == ObjectMemoryIntegerObjectOf(value));
		return character;
	}
}

ostream& operator<<(ostream& st, const CharOTE* oteCh);
