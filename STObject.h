/******************************************************************************

	File: STObject.h

	Description:

	VM representation of base Object class.

	As of 3.10 VM, class moved to OTE

******************************************************************************/

#ifndef _ST_STOBJECT_H
#define _ST_STOBJECT_H

enum { ObjectFixedSize = 0 };
enum { ObjectHeaderSize = 0 };
enum { ObjectByteSize = ObjectHeaderSize*sizeof(MWORD) };

typedef void* POBJECT;

// Turn off warning about zero length arrays
#pragma warning ( disable : 4200)

// Not real Smalltalk classes
class VariantByteObject //: public Object
{
public:
	BYTE m_fields[];
};

class VariantCharObject //: public Object
{
public:
	char m_characters[];
};

// Useful for accessing an object by index
class VariantObject //: public Object
{
public:
	Oop				m_fields[];
};

#if defined (VM)
	#include "ote.h"
	typedef TOTE<VariantByteObject> BytesOTE;
	typedef TOTE<VariantObject> PointersOTE;
#endif

#endif	// EOF
