/******************************************************************************

	File: STFloat.h

	Description:

	VM representation of Smalltalk Float class (N.B. double precision).

	N.B. The class here defined is well known to the VM, and must not
	be modified in the image. Note also that this class may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STMagnitude.h"

#pragma pack(push,4)

// Declare forward references
namespace ST { class Float; }
typedef TOTE<ST::Float> FloatOTE;


__forceinline bool isNaN(double d)
{
	return (*reinterpret_cast<uint64_t*>(&d) & 0x7FFFFFFFFFFFFFFF) > 0x7FF0000000000000;
}

__forceinline bool isFinite(double d)
{
	return (*reinterpret_cast<uint32_t*>(&d) & 0x7FF00000) == 0x7FF00000;
}


namespace ST
{
	// Float is a variable Byte subclass of Number, though it is always 8 bytes long
	class Float : public Number
	{
	public:
		double m_fValue;

		static FloatOTE* __stdcall New();
		static FloatOTE* __stdcall New(double fValue);

		__forceinline bool isNaN() const { return ::isNaN(m_fValue); }
	};
}

std::wostream& operator<<(std::wostream& st, const FloatOTE* oteFloat);

#pragma pack(pop)
