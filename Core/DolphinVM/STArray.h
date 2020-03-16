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
	__forceinline ptrdiff_t sizeForUpdate() const { return static_cast<ptrdiff_t>(m_size) / static_cast<ptrdiff_t>(sizeof(Oop)); }
};

namespace ST
{
	class Array : public ArrayedCollection
	{
	public:
		Oop	m_elements[];			// Variable length array of data

		static ArrayOTE* New(size_t size);
		static ArrayOTE* NewUninitialized(size_t size);
	};
}

std::ostream& operator<<(std::ostream& st, const ArrayOTE* oteArray);
