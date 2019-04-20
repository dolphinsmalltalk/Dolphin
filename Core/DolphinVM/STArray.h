/******************************************************************************

	File: STArray.h

	Description:

	VM representation of Smalltalk Array class.

	N.B. The representation of this class must NOT be changed.

******************************************************************************/
#pragma once

#include "STCollection.h"

// Turn off warning about zero length arrays
#pragma warning ( disable : 4200)

namespace ST { class Array; }

class ArrayOTE : public TOTE<ST::Array>
{
public:
	__forceinline int sizeForUpdate() const { return static_cast<int>(m_size) / static_cast<int>(sizeof(MWORD)); }
};

namespace ST
{
	class Array : public ArrayedCollection
	{
	public:
		Oop	m_elements[];			// Variable length array of data

		static ArrayOTE* New(unsigned size);
		static ArrayOTE* NewUninitialized(unsigned size);
	};
}

std::ostream& operator<<(std::ostream& st, const ArrayOTE* oteArray);
