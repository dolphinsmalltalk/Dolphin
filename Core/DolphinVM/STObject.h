/******************************************************************************

	File: STObject.h

	Description:

	VM representation of base Object class.

	As of 3.10 VM, class moved to OTE

******************************************************************************/
#pragma once

enum { ObjectFixedSize = 0 };
enum { ObjectHeaderSize = 0 };
enum { ObjectByteSize = ObjectHeaderSize*sizeof(MWORD) };

// Turn off warning about zero length arrays
#pragma warning ( disable : 4200)

namespace ST
{
	class Object
	{
	};

	// Not real Smalltalk classes
	class VariantByteObject : public Object
	{
	public:
		uint8_t m_fields[];
	};

	class VariantWordObject : public Object
	{
	public:
		uint16_t m_fields[];
	};

	class VariantQuadObject : public Object
	{
	public:
		uint32_t m_fields[];
	};

	class VariantCharObject : public Object
	{
	public:
		char m_characters[];
	};

	// Useful for accessing an object by index
	class VariantObject : public Object
	{
	public:
		Oop				m_fields[];
	};

	enum class StringEncoding
	{
		Ansi,
		Utf8,
		Utf16,
		Utf32
	};
}

typedef ST::Object* POBJECT;

#if defined (VM)
	#include "ote.h"
	typedef TOTE<ST::VariantByteObject> BytesOTE;
	typedef TOTE<ST::VariantWordObject> WordsOTE;
	typedef TOTE<ST::VariantQuadObject> QuadsOTE;
	typedef TOTE<ST::VariantObject> PointersOTE;
#endif
