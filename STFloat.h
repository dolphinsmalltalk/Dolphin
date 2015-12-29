/******************************************************************************

	File: STFloat.h

	Description:

	VM representation of Smalltalk Float class (N.B. double precision).

	N.B. The class here defined is well known to the VM, and must not
	be modified in the image. Note also that this class may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/

#ifndef _IST_STFLOAT_H_
#define _IST_STFLOAT_H_

#include "STMagnitude.h"

#pragma pack(push,4)

class Float;
typedef TOTE<Float> FloatOTE;
ostream& operator<<(ostream& st, const FloatOTE* oteFloat);

// Float is a variable Byte subclass of Number, though it is always 8 bytes long
class Float : public Number
{
public:
	double m_fValue;

	static FloatOTE* __stdcall New();
	static FloatOTE* __stdcall New(double fValue);
};

#pragma pack(pop)

#endif