/******************************************************************************

	File: STByteArray.h

	Description:

	VM representation of Smalltalk ByteArray class.

	N.B. The representation of this class must NOT be changed.

******************************************************************************/

#ifndef _IST_STBYTEARRAY_H_
#define _IST_STBYTEARRAY_H_

#include "STCollection.h"

// Turn off warning about zero length arrays
#pragma warning ( disable : 4200)

class ByteArray;
typedef TOTE<ByteArray> ByteArrayOTE;

class ByteArray : public ArrayedCollection
{
public:
	BYTE m_elements[];

	static ByteArrayOTE* New(unsigned size);
};

inline ByteArrayOTE* ByteArray::New(unsigned size)
{
	return reinterpret_cast<ByteArrayOTE*>(ObjectMemory::newByteObject(Pointers.ClassByteArray, size));
}

#endif	// EOF