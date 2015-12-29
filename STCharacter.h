/******************************************************************************

	File: STCharacter.h

	Description:

	VM representation of Smalltalk Character class.

	N.B. The class here defined is well known to the VM, and must not
	be modified in the image. Note also that this class may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/

#ifndef _IST_STCHARACTER_H_
#define _IST_STCHARACTER_H_

#include "STMagnitude.h"

class Character;
typedef TOTE<Character> CharOTE;
ostream& operator<<(ostream& st, const CharOTE* oteCh);

class Character : public Magnitude
{
public:
	Oop m_asciiValue;		// Small integer value
	enum { CharacterValueIndex=Magnitude::FixedSize, FixedSize };

	static CharOTE* New(unsigned char value);
};

// Characters are not reference counted - very important that param is unsigned in order to calculate offset of
// character object in OTE correctly (otherwise chars > 127 will probably offset off the front of the OTE).
inline CharOTE* Character::New(unsigned char value)
{
	// Characters will later become immediate
	CharOTE* character = reinterpret_cast<CharOTE*>(ObjectMemory::PointerFromIndex(ObjectMemory::FirstCharacterIdx+value));
	//ASSERT(fetchClassOf(character) == Pointers.ClassCharacter);
	return character;
}

#endif	// EOF