/******************************************************************************

	File: STInteger.h

	Description:

	VM representation of Smalltalk Integer classes.

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STMagnitude.h"

// Declare forward references
namespace ST { class LargeInteger; }
typedef TOTE<LargeInteger> LargeIntegerOTE;

namespace ST
{
	class Integer : public Number
	{

	public:
		// Various constructors
		static Oop __fastcall NewSigned32(SDWORD value);
		static Oop __fastcall NewSigned32WithRef(SDWORD value);
		static Oop __fastcall NewUnsigned32(DWORD value);
		static Oop __fastcall NewUnsigned32WithRef(DWORD value);
		static Oop __stdcall NewSigned64(LONGLONG value);
		static Oop __stdcall NewUnsigned64(ULONGLONG value);
		static Oop __fastcall NewIntPtr(INT_PTR value);
		static Oop __fastcall NewUIntPtr(UINT_PTR value);
	};

	// Large integer is a variable byte subclass of Integer (it contains
	// a byte array which represents the value of the integer)
	class LargeInteger : public Integer
	{
	public:
		DWORD m_digits[];		// Variable length array of 32-bit digits

		//MWORD	size(LargeIntegerOTE* oteLI) const		{ return oteLI->getWordSize(); /*return PointerSize(); */}
		SDWORD	signDigit(LargeIntegerOTE* oteLI)	const { return m_digits[oteLI->getWordSize() - 1]; }
		int		sign(LargeIntegerOTE* oteLI) const { return signDigit(oteLI) < 0 ? -1 : 1; }
		int		signBit(LargeIntegerOTE* oteLI) const { return signDigit(oteLI) < 0 ? -1 : 0; }

		LONGLONG limbAt(LargeIntegerOTE* oteLI, MWORD i) const;

		static LargeIntegerOTE* NewWithLimbs(MWORD limbs);

		// Answer a signed 32 or 64-bit LargeInteger from the unsigned 32-bit argument
		static LargeIntegerOTE* __fastcall liNewUnsigned(DWORD value);
		// Answer a 32-bit LargeInteger from the signed 32-bit argument
		static LargeIntegerOTE* __fastcall liNewSigned(SDWORD value);

		// Answer machine word sized signed and unsigned ints, 32 or 64 bits depending on OS
		static LargeIntegerOTE* __fastcall liNewUnsigned(UINT_PTR value);
		static LargeIntegerOTE* __fastcall liNewSigned(INT_PTR value);
	};


	// Answer a Large or SmallInteger, whichever is the smallest representation
	// for the specified signed value
	inline Oop __fastcall Integer::NewSigned32(SDWORD value)
	{
		if (ObjectMemoryIsIntegerValue(value))
			return ObjectMemoryIntegerObjectOf(value);
		else
			return Oop(LargeInteger::liNewSigned(value));
	}

	// Answer a Large or SmallInteger, whichever is the smallest representation
	// for the specified signed value. If large then the new object already has
	// a ref. count of 1.
	inline Oop __fastcall Integer::NewSigned32WithRef(SDWORD value)
	{
		if (ObjectMemoryIsIntegerValue(value))
			return ObjectMemoryIntegerObjectOf(value);
		else
		{
			LargeIntegerOTE* oteNew = LargeInteger::liNewSigned(value);
			oteNew->m_count = 1;
			return reinterpret_cast<Oop>(oteNew);
		}
	}

	// Answer a Large or SmallInteger, whichever is the smallest representation
	// for the specified unsigned value
	inline Oop __fastcall Integer::NewUnsigned32(DWORD value)
	{
		if (ObjectMemoryIsPositiveIntegerValue(value))
			return ObjectMemoryIntegerObjectOf(value);
		else
			// N.B. Answer may have 64-bits!
			return reinterpret_cast<Oop>(LargeInteger::liNewUnsigned(value));
	}

	// Answer a Large or SmallInteger, whichever is the smallest representation
	// for the specified unsigned value. If a LargeInteger then the new object
	// already has a ref. count of 1
	inline Oop __fastcall Integer::NewUnsigned32WithRef(DWORD value)
	{
		if (ObjectMemoryIsPositiveIntegerValue(value))
			return ObjectMemoryIntegerObjectOf(value);
		else
		{
			// N.B. Answer may have 64-bits!
			LargeIntegerOTE* oteNew = LargeInteger::liNewUnsigned(value);
			oteNew->m_count = 1;
			return reinterpret_cast<Oop>(oteNew);
		}
	}

	// Answer a Large or SmallInteger, whichever is the smallest representation
	// for the specified unsigned value
	inline Oop __fastcall Integer::NewUIntPtr(UINT_PTR value)
	{
#ifdef _WIN64
		return NewUnsigned64(value);
#else
		return NewUnsigned32((DWORD)value);
#endif
	}

	// Answer a Large or SmallInteger, whichever is the smallest representation
	// for the specified signed value
	inline Oop __fastcall Integer::NewIntPtr(INT_PTR value)
	{
#ifdef _WIN64
		return NewSigned64(value);
#else
		return NewSigned32((SDWORD)value);
#endif
	}
}

ostream& operator<<(ostream& stream, const LargeIntegerOTE*);

