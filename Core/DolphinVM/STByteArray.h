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

class ByteArrayOTE : public TOTE<ST::ByteArray>
{
public:
	__forceinline ptrdiff_t sizeForUpdate() const { return static_cast<ptrdiff_t>(m_size); }
};

namespace ST
{
	class ByteArray : public ArrayedCollection
	{
	public:
		uint8_t m_elements[];

		static ByteArrayOTE* New(size_t size);
		static ByteArrayOTE* New(size_t size, const void* pBytes);
		static ByteArrayOTE* NewWithRef(size_t size, const void* pBytes);
	};

	inline ByteArrayOTE* ByteArray::New(size_t size)
	{
		return reinterpret_cast<ByteArrayOTE*>(ObjectMemory::newByteObject<false, true>(Pointers.ClassByteArray, size));
	}

	inline ByteArrayOTE* ByteArray::New(size_t size, const void* pBytes)
	{
		return reinterpret_cast<ByteArrayOTE*>(ObjectMemory::newByteObject(Pointers.ClassByteArray, size, pBytes));
	}

	inline ByteArrayOTE* ByteArray::NewWithRef(size_t size, const void* pBytes)
	{
		ByteArrayOTE* byteArray = New(size, pBytes);
		byteArray->m_count = 1;
		return byteArray;
	}
}
