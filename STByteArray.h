/******************************************************************************

	File: STByteArray.h

	Description:

	VM representation of Smalltalk ByteArray class.

	N.B. The representation of this class must NOT be changed.

******************************************************************************/
#pragma once

#include "STCollection.h"

// Turn off warning about zero length arrays
#pragma warning ( disable : 4200)

// Declare forward references
namespace ST { class ByteArray; }
typedef TOTE<ST::ByteArray> ByteArrayOTE;

namespace ST
{
	class ByteArray : public ArrayedCollection
	{
	public:
		uint8_t m_elements[];

		static ByteArrayOTE* New(MWORD size);
		static ByteArrayOTE* New(MWORD size, const void* pBytes);
		static ByteArrayOTE* NewWithRef(MWORD size, const void* pBytes);
	};

	inline ByteArrayOTE* ByteArray::New(MWORD size)
	{
		return reinterpret_cast<ByteArrayOTE*>(ObjectMemory::newByteObject<false, true>(Pointers.ClassByteArray, size));
	}

	inline ByteArrayOTE* ByteArray::New(MWORD size, const void* pBytes)
	{
		return reinterpret_cast<ByteArrayOTE*>(ObjectMemory::newByteObject(Pointers.ClassByteArray, size, pBytes));
	}

	inline ByteArrayOTE* ByteArray::NewWithRef(MWORD size, const void* pBytes)
	{
		ByteArrayOTE* byteArray = New(size, pBytes);
		byteArray->m_count = 1;
		return byteArray;
	}
}
