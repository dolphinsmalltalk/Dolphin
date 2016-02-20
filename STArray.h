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
typedef TOTE<ST::Array> ArrayOTE;

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

ostream& operator<<(ostream& st, const ArrayOTE* oteArray);
