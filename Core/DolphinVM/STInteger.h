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
		static Oop __fastcall NewSigned32(int32_t value);
		static Oop __fastcall NewSigned32WithRef(int32_t value);
		static Oop __fastcall NewUnsigned32(uint32_t value);
		static Oop __fastcall NewUnsigned32WithRef(uint32_t value);
		static Oop __stdcall NewSigned64(int64_t value);
		static Oop __stdcall NewUnsigned64(uint64_t value);
		static Oop __fastcall NewIntPtr(INT_PTR value);
		static Oop __fastcall NewUIntPtr(UINT_PTR value);
	};

	// Large integer is a variable byte subclass of Integer (it contains
	// a byte array which represents the value of the integer)
	class LargeInteger : public Integer
	{
	public:
		uint32_t m_digits[];		// Variable length array of 32-bit digits

		int32_t	signDigit(const LargeIntegerOTE* oteLI)	const { return static_cast<int32_t>(m_digits[oteLI->getWordSize() - 1]); }
		int32_t	sign(const LargeIntegerOTE* oteLI) const { return 1 | (signDigit(oteLI) >> 31); }
		int32_t	signBit(const LargeIntegerOTE* oteLI) const { return signDigit(oteLI) >> 31; }

		static LargeIntegerOTE* NewWithLimbs(MWORD limbs);

		// Answer a signed 32 or 64-bit LargeInteger from the unsigned 32-bit argument
		static LargeIntegerOTE* __fastcall liNewUnsigned(uint32_t value);
		// Answer a 32-bit LargeInteger from the signed 32-bit argument
		static LargeIntegerOTE* __fastcall liNewSigned(int32_t value);
	};


	// Answer a Large or SmallInteger, whichever is the smallest representation
	// for the specified signed value
	inline Oop __fastcall Integer::NewSigned32(int32_t value)
	{
		if (ObjectMemoryIsIntegerValue(value))
			return ObjectMemoryIntegerObjectOf(value);
		else
			return Oop(LargeInteger::liNewSigned(value));
	}

	// Answer a Large or SmallInteger, whichever is the smallest representation
	// for the specified signed value. If large then the new object already has
	// a ref. count of 1.
	inline Oop __fastcall Integer::NewSigned32WithRef(int32_t value)
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
	inline Oop __fastcall Integer::NewUnsigned32(uint32_t value)
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
	inline Oop __fastcall Integer::NewUnsigned32WithRef(uint32_t value)
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
		return NewUnsigned32(static_cast<uint32_t>(value));
#endif
	}

	// Answer a Large or SmallInteger, whichever is the smallest representation
	// for the specified signed value
	inline Oop __fastcall Integer::NewIntPtr(INT_PTR value)
	{
#ifdef _WIN64
		return NewSigned64(value);
#else
		return NewSigned32(static_cast<int32_t>(value));
#endif
	}
}

std::wostream& operator<<(std::wostream& stream, const LargeIntegerOTE*);

