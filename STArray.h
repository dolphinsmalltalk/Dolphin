/******************************************************************************

	File: STArray.h

	Description:

	VM representation of Smalltalk Array class.

	N.B. The representation of this class must NOT be changed.

******************************************************************************/

#ifndef _IST_STARRAY_H_
#define _IST_STARRAY_H_

#include "STCollection.h"

// Turn off warning about zero length arrays
#pragma warning ( disable : 4200)

class Array;
typedef TOTE<Array> ArrayOTE;
ostream& operator<<(ostream& st, const ArrayOTE* oteArray);

class Array : public ArrayedCollection
{
public:
	Oop	m_elements[];			// Variable length array of data

	static ArrayOTE* New(unsigned size);
	static ArrayOTE* NewUninitialized(unsigned size);
};

inline ArrayOTE* Array::New(unsigned size)
{
	return reinterpret_cast<ArrayOTE*>(ObjectMemory::newPointerObject(Pointers.ClassArray, size));
}

inline ArrayOTE* Array::NewUninitialized(unsigned size)
{
	return reinterpret_cast<ArrayOTE*>(ObjectMemory::newUninitializedPointerObject(Pointers.ClassArray, size));
}
#endif	// EOF