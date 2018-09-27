/******************************************************************************

	File: LargeIntPrim.cpp

	Description:

	Implementation of the Interpreter class' LargeInteger primitive methods.

	These differ from standard ST-80 in that Dolphin represents LargeIntegers
	in two's complement representation with a 4-byte (uint32_t) granularity, i.e
	LargeIntegers are 4, 8, 12, 16, etc bytes long.

	The use of x4 two's complement has certain implications:
	- External interfacing is easier, since the representation of Integers up
	to 64-bits long is the same as that expected by Win32 (i.e. a LARGE_INTEGER
	looks the same as the same valued LargeInteger).
	- Only a single class, LargeInteger, is required.
	- Certain ops. can be performed more quickly using 64-bit arithmetic with
	32-bit operands.
	- 4-byte 2's complement LargeIntegers cannot represent the same range of
	Integers as 4-byte sign-magnitude LargeIntegers, so some Integer values
	will be larger. However, such numbers are unusual.
	- Multi-precision arithmetic on 2's complement numbers is more tricky than
	sign-magnitude, if only because Knuth doesn't provide code!

	N.B. Some of the algorithms herein are not optimal, but compared to the
	Smalltalk implementations the speed difference is so remarkable, that I don't
	think we need worry about that for now.

******************************************************************************/
#include "Ist.h"

#pragma code_seg(LIPRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

// Smalltalk classes
#include "STInteger.h"

#ifdef _DEBUG
	#define MASK_DWORD(op) ((op) & 0xFFFFFFFF)	/* avoid error when converting to smaller type */
#else
	#define MASK_DWORD(op) (op)
#endif
// This cast sequence can allow the compiler to generate more efficient code (avoids the need for an arithmetic shift)
#define /*int32_t*/ HighSLimb(/*int64_t*/ op) (((LARGE_INTEGER*)&op)->HighPart)
#define /*uint32_t*/ HighULimb(/*int64_t*/ op) (((ULARGE_INTEGER*)&op)->HighPart)
#define /*uint32_t*/ LowLimb(/*int64_t*/ op) (static_cast<uint32_t>(MASK_DWORD(op)))

// Forward references
Oop __fastcall liNormalize(LargeIntegerOTE* oteLI);

// Answer the sign bit of the argument
inline static int signBitOf(int32_t signedInt)
{
	return signedInt >> 31;
}

inline static uint32_t highBit(uint32_t value)
{
	unsigned long index;
	return _BitScanReverse(&index, value) ? index + 1 : 0;
}

/******************************************************************************
*
* Primitive helper functions
*
* Mose of these can be exported for direct use too.
*
******************************************************************************/


//	Template for operations for which the result is the receiver if the operand is SmallInteger zero
template <class Op, class OpSingle> __forceinline static Oop* primitiveLargeIntegerOpR(Oop* const sp, const Op &op, const OpSingle& opSingle)
{
	Oop oopArg = *sp;
	const LargeIntegerOTE* oteReceiver = reinterpret_cast<const LargeIntegerOTE*>(*(sp - 1));
	Oop result;

	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SMALLINTEGER arg = ObjectMemoryIntegerValueOf(oopArg);
		if (arg != 0)
		{
			result = opSingle(oteReceiver, arg);
		}
		else
		{
			// Operand is zero, so result is receiver
			return sp - 1;
		}
	}
	else
	{
		const LargeIntegerOTE* oteArg = reinterpret_cast<const LargeIntegerOTE*>(oopArg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			result = op(oteReceiver, oteArg);
		}
		else
			return nullptr;
	}

	// Normalize and return
	result = normalizeIntermediateResult(result);
	*(sp - 1) = result;
	ObjectMemory::AddToZct(result);

	return sp - 1;
}

// Template for operations where the result is zero if the argument is SmallInteger zero
template <class Op, class OpSingle> __forceinline static Oop* primitiveLargeIntegerOpZ(Oop* const sp, const Op &op, const OpSingle& opSingle)
{
	Oop oopArg = *sp;
	const LargeIntegerOTE* oteReceiver = reinterpret_cast<const LargeIntegerOTE*>(*(sp - 1));
	Oop result;

	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SMALLINTEGER arg = ObjectMemoryIntegerValueOf(oopArg);
		if (arg != 0)
		{
			result = opSingle(oteReceiver, arg);
		}
		else
		{
			// Operand is zero, so result is zero
			*(sp - 1) = ZeroPointer;
			return sp - 1;
		}
	}
	else
	{
		const LargeIntegerOTE* oteArg = reinterpret_cast<const LargeIntegerOTE*>(oopArg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			result = op(oteReceiver, oteArg);
		}
		else
			return nullptr;
	}

	// Normalize and return
	result = normalizeIntermediateResult(result);
	*(sp - 1) = result;
	ObjectMemory::AddToZct(result);

	return sp - 1;
}

// Answer a new Integer instantiated from the 32-bit positive integer argument.
// The answer is not necessarily in the most reduced form possible (i.e. even if the 
// value would fit in a SmallInteger, this routine will still answer a LargeInteger).
LargeIntegerOTE* __fastcall LargeInteger::liNewSigned(int32_t value)
{
	LargeIntegerOTE* oteR = reinterpret_cast<LargeIntegerOTE*>(Interpreter::NewDWORD(value, Pointers.ClassLargeInteger));
	oteR->beImmutable();
	return oteR;
}

inline LargeIntegerOTE* LargeInteger::NewWithLimbs(MWORD limbs)
{
	return reinterpret_cast<LargeIntegerOTE*>(ObjectMemory::newByteObject<false, true>(Pointers.ClassLargeInteger, limbs*sizeof(uint32_t)));
}

// Answer a new Integer instantiated from the 32-bit positive integer argument.
// The answer is not necessarily in the most reduced form possible (i.e. even if the 
// value would fit in a SmallInteger, this routine will still answer a LargeInteger).
LargeIntegerOTE* __fastcall LargeInteger::liNewUnsigned(uint32_t value)
{
	LargeIntegerOTE* oteLarge;
	if (static_cast<int32_t>(value) < 0)
	{
		// Result would be negative if used only 32 bits, 
		// so need to use 64-bits to keep positive sign
		oteLarge = NewWithLimbs(2);
		LargeInteger* large = oteLarge->m_location;
		large->m_digits[0] = value;
	}
	else
		oteLarge = reinterpret_cast<LargeIntegerOTE*>(Interpreter::NewDWORD(value, Pointers.ClassLargeInteger));

	oteLarge->beImmutable();
	return oteLarge;
}

// Answer a new Integer instantiated from the 64-bit integer argument.
// The answer is in the most reduced form possible (i.e. it could even be a SmallInteger
Oop __stdcall Integer::NewUnsigned64(uint64_t ullValue)
{
	ULARGE_INTEGER* pValue = reinterpret_cast<ULARGE_INTEGER*>(&ullValue);
	const uint32_t highPart = pValue->HighPart;
	const uint32_t lowPart = pValue->LowPart;
	if (!highPart)
		// May fit in 32-bits
		return NewUnsigned32(lowPart);

	// Need up to 96 bits to represent full range of 64-bit positive numbers as 
	// 2's complement
	const unsigned nDigits = static_cast<int32_t>(highPart) < 0 ? 3 : 2;
	LargeIntegerOTE* oteLarge = LargeInteger::NewWithLimbs(nDigits);
	LargeInteger* large = oteLarge->m_location;
	large->m_digits[0] = lowPart;
	large->m_digits[1] = highPart;

	oteLarge->beImmutable();
	return reinterpret_cast<Oop>(oteLarge);
}

// Answer a new Integer instantiated from the 64-bit integer argument.
// The answer is in the most reduced form possible (i.e. it could even be a SmallInteger
Oop __stdcall Integer::NewSigned64(int64_t value)
{
	LARGE_INTEGER* pValue = reinterpret_cast<LARGE_INTEGER*>(&value);
	const int32_t highPart = pValue->HighPart;
	const uint32_t lowPart = pValue->LowPart;
	Oop oopAnswer;
	if (highPart == signBitOf(lowPart))
	{
		// Only 32-bits needed
		oopAnswer = NewSigned32(lowPart);
	}
	else
	{
		// Full 64-bits needed
		LargeIntegerOTE* oteLarge = LargeInteger::NewWithLimbs(2);
		LargeInteger* large = oteLarge->m_location;
		large->m_digits[0] = lowPart;
		large->m_digits[1] = highPart;
		oteLarge->beImmutable();

		oopAnswer = reinterpret_cast<Oop>(oteLarge);
	}

	return oopAnswer;
}

inline void deallocateIntermediateResult(LargeIntegerOTE* liOte)
{
	POTE ote = reinterpret_cast<POTE>(liOte);

	HARDASSERT(ote->m_count == 0);
	HARDASSERT(!ote->isFree());
	// If its in the Zct, then it must be on the stack.
	HARDASSERT(!ObjectMemory::IsInZct(ote));

	ObjectMemory::deallocateByteObject(ote);
}

inline void deallocateIntermediateResult(Oop oopResult)
{
	if (!ObjectMemoryIsIntegerObject(oopResult))
		deallocateIntermediateResult(reinterpret_cast<LargeIntegerOTE*>(oopResult));
}

///////////////////////////////////////////////////////////////////////////////
// Integer normalization
//
// Answer the receiver in its minimal representation. 
//
// This is achieved by removing all leading sign digits which are redundant,
// and shrinking to a SmallInteger is possible.
// It looks quite complicated, but it's not really. Most of the complexity
// comes from trying to do the least possible work (in particular not reallocating
// the object unless necessary).
//
Oop __fastcall liNormalize(LargeIntegerOTE* oteLI)
{
	LargeInteger* li = oteLI->m_location;

	MWORD size = oteLI->getWordSize();
	MWORD last = size - 1;
	int32_t highPart = static_cast<int32_t>(li->m_digits[last]);
	if (last)	// If more than one digit, attempt to remove any which are redundant
	{
		int32_t liSign = signBitOf(highPart);

		// See if high part is redundant, and remove leading sign words
		while (last > 0 && highPart == liSign)
		{
			last--;
			highPart = static_cast<int32_t>(li->m_digits[last]);
		}

		if (last == size-1)
		{
			oteLI->beImmutable();
			return Oop(oteLI);	// No redundant digits detected, return as is
		}

		if (signBitOf(highPart) != liSign)
		{
			// Wouldn't still have correct sign if we dropped the preceeding sign bits, so add them back
			last++;
			if (last == size-1)		// Did we anage to shrink it at all?
			{
				oteLI->beImmutable();
				return Oop(oteLI);	// No, no reduction possible, return as is
			}
			
			ASSERT(last);			// Well there must be at least 2 digits
		}

		// If here it means can drop some leading digits
		if (!last)
		{
			// Could be SmallInteger?
			if (ObjectMemoryIsIntegerValue(highPart))
				return ObjectMemoryIntegerObjectOf(highPart);	// Reduce to small integer
			// else drop through to remove redundant sign words - only 1 digit left
		}
		// else More than one digit required, so cannot possibly be SmallInteger

		ASSERT(last+1 < size);
		ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteLI), (last+1)*sizeof(uint32_t));
		// Drop through to return the shrunken object
	}
	else
	{
		// One one digit - try to reduce 32-bit LI to SmallInteger
		if (ObjectMemoryIsIntegerValue(highPart))
			return ObjectMemoryIntegerObjectOf(highPart);	// Reduce to SmallInteger
		// else drop through to return the object as is
	}

	oteLI->beImmutable();
	return Oop(oteLI);		// No reduction was possible, or we shrunk it
}

static Oop normalizeIntermediateResult(LargeIntegerOTE* oteLI)
{
	HARDASSERT(!ObjectMemory::IsInZct(reinterpret_cast<OTE*>(oteLI)));
	Oop oopNormalized = liNormalize(oteLI);
	if (reinterpret_cast<Oop>(oteLI) != oopNormalized)
		deallocateIntermediateResult(oteLI);
	return oopNormalized;
}

Oop __forceinline normalizeIntermediateResult(Oop integerPointer)
{
	Oop oopNormalized;
	if (ObjectMemoryIsIntegerObject(integerPointer))
		oopNormalized = integerPointer;
	else
		oopNormalized = normalizeIntermediateResult(reinterpret_cast<LargeIntegerOTE*>(integerPointer));
	return oopNormalized;
}

///////////////////////////////////////////////////////////////////////////////
// liLeftShift - LargeInteger Left Shift
//
//	Shift LargeInteger left by the specified number of bits

LargeIntegerOTE* __stdcall liLeftShift(LargeIntegerOTE* oteLI, unsigned shift)
{
	// Doesn't matter if shift is zero, and indeed liDivUnsigned will sometimes
	// call with a zero shift in expectation of an intermediate result with an
	// extra high digit with value 0.

	int bits = shift & 31;
	int words = shift >> 5;

	LargeInteger* li = oteLI->m_location;

	// Assume there'll be a carry out of the high digit (or that it won't
	// be the same sign if we don't add a digit). Could do this
	// in a more sophisticated way and avoid the shrink
	int size = oteLI->getWordSize();
	const int resultSize = size + words + 1;

	LargeIntegerOTE* oteResult = LargeInteger::NewWithLimbs(resultSize);
	LargeInteger* liResult = oteResult->m_location;

	int32_t carry = 0;		// Initial carry is 0
	for (int i=0;i<size-1;i++)
	{
		int64_t digit = li->m_digits[i];
		int64_t accum = (digit << bits) | carry;
		liResult->m_digits[i+words] = LowLimb(accum);
		carry = HighSLimb(accum);
	}
	// Last (signed) digit unrolled to avoid condition in loop
	int64_t digit = static_cast<int32_t>(li->m_digits[size-1]);
	int64_t accum = (digit << bits) | carry;
	ASSERT(size+words == resultSize-1);
	liResult->m_digits[resultSize-2] = LowLimb(accum);
	liResult->m_digits[resultSize-1] = HighSLimb(accum);

	return oteResult;
}

///////////////////////////////////////////////////////////////////////////////
// liRightShift - LargeInteger Right Shift
//
//	Shift LargeInteger right by the specified number of bits.
//	The algorithm is a fairly simple ripple carry of the shifted out bits down
//	from the high digit, with a displacement of any number of words. The only
//	slight complication is the need to right-shift the sign digit separately
//	in order to shift-in sign bits from the right, and special case handling for
//	shifts which are a multiple of 32 because shifting by 32 doesn't have the
//	expected result on Intel hardware
Oop __stdcall liRightShift(LargeIntegerOTE* oteLI, unsigned shift)
{
	HARDASSERT(shift != 0);	// Doesn't matter if shift is zero, but why call if it is?

	int bits = shift & 31;
	int words = shift >> 5;

	LargeInteger* li = oteLI->m_location;

	const int size = oteLI->getWordSize();
	ASSERT(size > 0);
	const int resultSize = size - words;
	if (resultSize <= 0)
		// All bits lost. As this is an arithmetic (signed) shift, answer the sign "bit"
		return ObjectMemoryIntegerObjectOf(signBitOf(static_cast<int32_t>(li->m_digits[size - 1])));

	LargeIntegerOTE* oteResult = LargeInteger::NewWithLimbs(resultSize);
	LargeInteger* liResult = oteResult->m_location;

	if (!bits)
	{
		// Perform shifting of integral numbers of words separately
		// because not only is this faster (just a memcpy), but it 
		// avoids problems with shifts of more than 31 bits on Intel 
		// hardware (which are performed modulo 32, i.e. << 32 actually 
		// results in << 0 and gives the wrong result - the operand and not 0).
		memcpy(liResult->m_digits, li->m_digits+words, resultSize*sizeof(uint32_t));
	}
	else
	{
		int carryShift = 32 - bits;
		ASSERT(carryShift >= 0);

		// Do top shift separately because it contains sign
		uint32_t digit = li->m_digits[size-1];
		// Perform an arithmetic shift (with sign carry-in) of the top digit
		liResult->m_digits[resultSize-1] = static_cast<int32_t>(digit) >> bits;
		// The carry will be at most 31 bits
		uint32_t carry;
		for (int i=resultSize-2;i>=0;i--)
		{
			carry = digit << carryShift;
			const int j = i+words;
			ASSERT(j >= 0 && j < size);
			digit = li->m_digits[j];
			liResult->m_digits[i] = (digit >> bits) | carry;
		}
	}

	return Oop(oteResult);
}

///////////////////////////////////////////////////////////////////////////////
// liNegatePriv - LargeInteger Negate (2's complement)
//
//	Negate the 2's complement LargeInteger argument
//	The answer will be normalized (hence the tricky fiddlings)
//	except that it will _not_ be converted to a SmallInteger (there is only a
//	single case where this occurs, for 16r40000000).
//  Note also that the answer will have a zero reference count.

static LargeIntegerOTE* __stdcall liNegatePriv(LargeIntegerOTE* oteLI)
{
	LargeInteger* li = oteLI->m_location;

	const MWORD size = oteLI->getWordSize();

	int32_t highDigit = static_cast<int32_t>(li->m_digits[size-1]);
	MWORD negatedSize = size;

	// Handle boundary conditions to avoid the need to allocate extra digits and/or
	// normalize the result. Because the range of positive/negative 2's complement
	// Integers differs by 1, we may have to "increase" or "reduce" the representation
	if (highDigit == -static_cast<int32_t>(0x80000000))
	{
		// Will (probably) need extra zero digit to represent as positive value
		negatedSize++;
	}
/*	
	This doesn't work for, e.g., 16r8000000000000001.

	else if (size > 1 && highDigit == 0)
	{
		if (li->m_digits[size-2] == 0x80000000)
			// Can remove extra zero digit for this when converted to large negative
			negatedSize = --size;
	}
*/
	LargeIntegerOTE* oteNegated = LargeInteger::NewWithLimbs(negatedSize);
	LargeInteger* liNegated = oteNegated->m_location;
	// TODO: Since we are only adding one, only one bit of carry is possible - would be much faster in assembler as simple 32-bit add with carry loop
	int32_t carry = 1;
	
	for (MWORD i=0;i<size;i++)
	{
		// Must cast at least one operand to 64-bits so that 64-bit (signed) addition performed
		int64_t accum = static_cast<int64_t>(~li->m_digits[i]) + carry;
		liNegated->m_digits[i] = LowLimb(accum);
		carry = HighSLimb(accum);
	}

	return oteNegated;
}

Oop __stdcall liNegate(LargeIntegerOTE* oteLI)
{
	LargeInteger* li = oteLI->m_location;
	const int size = oteLI->getWordSize();
	if (size == 1 && static_cast<int32_t>(li->m_digits[0]) == 0x40000000)
	{
		// Can reduce this large positive integer to negative SmallInteger (boundary case)
		return ObjectMemoryIntegerObjectOf(-0x40000000);
	}
	else
		return normalizeIntermediateResult(liNegatePriv(oteLI));
}

Oop __stdcall negateIntermediateResult(Oop oopInteger)
{
	if (ObjectMemoryIsIntegerObject(oopInteger))
	{
		SMALLINTEGER intValue = ObjectMemoryIntegerValueOf(oopInteger);
		return Integer::NewSigned32(-intValue);
	}
	else
	{
		LargeIntegerOTE* oteInteger = reinterpret_cast<LargeIntegerOTE*>(oopInteger);
		Oop oopNegated = liNegate(oteInteger);
		ASSERT(oopNegated != oopInteger);
		deallocateIntermediateResult(oteInteger);
		return oopNegated;
	}
}

/******************************************************************************
*
* Addition
*
******************************************************************************/

///////////////////////////////////////////////////////////////////////////////
// liAddSingle - LargeInteger Single-precision Add
//	Add a 32-bit Integer to a multi-limbed integer
//
Oop liAddSingle(const LargeIntegerOTE* oteLI, const SMALLINTEGER operand)
{
	ASSERT(operand != 0);

	const uint32_t* const digits = oteLI->m_location->m_digits;
	const MWORD numLimbs = oteLI->getWordSize();
	ASSERT(numLimbs > 0);

	LargeIntegerOTE* const oteSum = LargeInteger::NewWithLimbs(numLimbs);
	uint32_t* sumDigits = oteSum->m_location->m_digits;

	uint8_t carry = _addcarry_u32(0, digits[0], operand, sumDigits);
	const int32_t operandSign = operand >> 31;
	for (MWORD i = 1; i < numLimbs; i++)
	{
		carry = _addcarry_u32(carry, digits[i], operandSign, sumDigits + i);
	}

	// Calculate an extra sign-only digit to see if it is required
	int liSign = static_cast<int32_t>(digits[numLimbs - 1]) >> 31;
	int requiredSign;
	_addcarry_u32(carry, liSign, operandSign, reinterpret_cast<uint32_t*>(&requiredSign));

	// We may need to add a extra limb for the sign if the current top limb has the wrong sign
	int sumSign = static_cast<int32_t>(sumDigits[numLimbs - 1]) >> 31;
	if (sumSign != requiredSign)
	{
		// Add extra digit necessary to represent the sign
		sumDigits = reinterpret_cast<LargeInteger*>(ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteSum), (numLimbs + 1) << 2))->m_digits;
		sumDigits[numLimbs] = requiredSign;
	}

	return Oop(oteSum);
}

///////////////////////////////////////////////////////////////////////////////
// liAdd - LargeInteger multi-precision Add
//
//	Add a multi-precision Integer to another multi-precision integer.

Oop liAdd(const LargeIntegerOTE* oteOp1, const LargeIntegerOTE* oteOp2)
{
	MWORD size1 = oteOp1->getWordSize();
	MWORD size2 = oteOp2->getWordSize();

	const uint32_t *digits1;
	const uint32_t *digits2;

	if (size1 < size2)
	{
		// operand 2 is larger than operand 1, add op1 to op2
		std::swap(size1, size2);
		digits1 = oteOp2->m_location->m_digits;
		digits2 = oteOp1->m_location->m_digits;
	}
	else
	{
		digits1 = oteOp1->m_location->m_digits;
		digits2 = oteOp2->m_location->m_digits;
	}

	ASSERT(size1 >= size2);
	ASSERT(size1 > 0);

	LargeIntegerOTE* const oteSum = LargeInteger::NewWithLimbs(size1);
	uint32_t* sumDigits = oteSum->m_location->m_digits;

	uint8_t carry = _addcarry_u32(0, digits1[0], digits2[0], sumDigits);
	MWORD i;
	// add up the least significant limbs up to the most-significant limb of the addend (the receiver is at least as large)
	for (i = 1; i < size2; i++)
	{
		carry = _addcarry_u32(carry, digits1[i], digits2[i], sumDigits + i);
	}

	// Ripply carry up through remaining limbs of the longer LI
	int32_t sign2 = static_cast<int32_t>(digits2[size2 - 1]) >> 31;
	for (; i < size1; i++)
	{
		carry = _addcarry_u32(carry, digits1[i], sign2, sumDigits + i);
	}

	// Calculate an extra sign-only digit to see if it is required
	int sign1 = static_cast<int32_t>(digits1[size1 - 1]) >> 31;
	int requiredSign;
	_addcarry_u32(carry, sign1, sign2, reinterpret_cast<uint32_t*>(&requiredSign));

	// We may need to add a extra limb for the sign if the current top limb has the wrong sign
	int sumSign = static_cast<int32_t>(sumDigits[size1 - 1]) >> 31;
	if (sumSign != requiredSign)
	{
		// Add extra digit necessary to represent the sign
		sumDigits = reinterpret_cast<LargeInteger*>(ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteSum), (size1 + 1) << 2))->m_digits;
		sumDigits[size1] = requiredSign;
	}

	return Oop(oteSum);
}

Oop* __fastcall Interpreter::primitiveLargeIntegerAdd(Oop* const sp, unsigned)
{
	struct AddSmallInteger
	{
		Oop operator()(const LargeIntegerOTE* oteLI, const SMALLINTEGER operand) const
		{
			return liAddSingle(oteLI, operand);
		}
	};

	struct Add
	{
		Oop operator()(const LargeIntegerOTE* oteOp1, const LargeIntegerOTE* oteOp2) const
		{
			return liAdd(oteOp1, oteOp2);
		}
	};

	return primitiveLargeIntegerOpR(sp, Add(), AddSmallInteger());
}


///////////////////////////////////////////////////////////////////////////////
// liSubSingle - LargeInteger Single-precision Subtract
//	Subtract a single-precision (32-bit) Integer from a multi-precision integer
//	This is easy and fast (a ripple carry with special treatment for the sign digit)
//

Oop liSubSingle(const LargeIntegerOTE* oteLI, SMALLINTEGER operand)
{
	const uint32_t* const digits = oteLI->m_location->m_digits;
	const MWORD differenceSize = oteLI->getWordSize();

	LargeIntegerOTE* oteDifference = LargeInteger::NewWithLimbs(differenceSize);
	uint32_t* difference = oteDifference->m_location->m_digits;
	const MWORD last = differenceSize - 1;

	// The initial "borrow" is the argument
	int32_t carry = operand * -1;

	for (MWORD i = 0; i < last; i++)
	{
		// Must cast at least one operand to 64-bits so that 64-bit subtraction performed
		int64_t accum = static_cast<int64_t>(digits[i]) + carry;
		difference[i] = LowLimb(accum);
		carry = HighSLimb(accum);
	}

	// Last digit unrolled because we need to use signed arithmetic here
	// May not sign extend correctly without cast
	int64_t accum = static_cast<int64_t>(static_cast<int32_t>(digits[last])) + carry;
	difference[last] = LowLimb(accum);

	// Now drop through to handle the final borrow (in accum.HighPart) in common
	// code. This may involve growing the result if it cannot be represented as
	// a two's complement number in the current number of digits..
	if (accum < -static_cast<int64_t>(0x80000000) || accum >= 0x80000000)
	{
		// Not at 32-bit two's complement number, so there must be a remaining borrow...

		// Add extra digit necessary to represent the sign
		difference = reinterpret_cast<LargeInteger*>(ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteDifference), (differenceSize + 1) << 2))->m_digits;
		difference[differenceSize] = HighSLimb(accum);
	}

	// Made immutable by normalize
	return Oop(oteDifference);
}

Oop liSub(const LargeIntegerOTE* oteLI, const LargeIntegerOTE* oteOperand)
{
	const uint32_t* digits1 = oteLI->m_location->m_digits;
	const uint32_t* digits2 = oteOperand->m_location->m_digits;

	const MWORD size = oteLI->getWordSize();
	const MWORD operandSize = oteOperand->getWordSize();

	MWORD differenceSize;
	if (size > operandSize)
	{
		differenceSize = size;
	}
	else
	{
		differenceSize = operandSize;
	}

	LargeIntegerOTE* oteDifference = LargeInteger::NewWithLimbs(differenceSize);
	uint32_t* difference = oteDifference->m_location->m_digits;

	int32_t carry = 0;

	for (MWORD i = 0; i < differenceSize; i++)
	{
		TODO("Unroll this loop to avoid conditionals in loop")
			// Compiler unable to optimize size() calls out
			int64_t a = i < size ? (i == size - 1 ? static_cast<int64_t>(static_cast<int32_t>(digits1[i])) : digits1[i]) : 0;
		int64_t b = i < operandSize ? (i == operandSize - 1 ? static_cast<int64_t>(static_cast<int32_t>(digits2[i])) : digits2[i]) : 0;

		int64_t accum = a - b + carry;
		difference[i] = LowLimb(accum);
		carry = HighSLimb(accum);
	}

	int32_t signLimb = static_cast<int32_t>(difference[differenceSize - 1]);
	if ((carry < 0) != (signLimb < 0))
	{
		// Not at 32-bit two's complement number, so there must be a remaining borrow...

		// Add extra digit necessary to represent the sign
		difference = reinterpret_cast<LargeInteger*>(ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteDifference), (differenceSize + 1) << 2))->m_digits;
		difference[differenceSize] = carry;
	}

	// Made immutable by normalize
	return Oop(oteDifference);
}

Oop* __fastcall Interpreter::primitiveLargeIntegerSub(Oop* const sp, unsigned)
{
	struct SubSmallInteger
	{
		Oop operator()(const LargeIntegerOTE* oteLI, SMALLINTEGER operand) const
		{
			return liSubSingle(oteLI, operand);
		}
	};

	struct Sub
	{
		Oop operator()(const LargeIntegerOTE* oteLI, const LargeIntegerOTE* oteOperand) const
		{
			return liSub(oteLI, oteOperand);
		}
	};

	return primitiveLargeIntegerOpR(sp, Sub(), SubSmallInteger());
}

/******************************************************************************
*
* Multiplication
*
******************************************************************************/

///////////////////////////////////////////////////////////////////////////////
// liMulSingle - LargeInteger Single Precision Multiple
//
// Multiply a LargeInteger by a SmallInteger. Optimized for this most common case

Oop liMulSingle(const LargeIntegerOTE* oteInner, SMALLINTEGER outerDigit)
{
	ASSERT(outerDigit != 0);

	const uint32_t* inner = oteInner->m_location->m_digits;
	MWORD innerSize = oteInner->getWordSize();

	// Can optimize case where multiplying by zero
	ASSERT(innerSize > 0 || inner[0] != 0);

	const MWORD productSize = innerSize + 1;
	LargeIntegerOTE* oteProduct = LargeInteger::NewWithLimbs(productSize);
	uint32_t* product = oteProduct->m_location->m_digits;

	int32_t carry = 0;
	for (MWORD i = 0; i < innerSize - 1; i++)
	{
		// This operations requires a 64-bit multiply because positive 32-bit int 
		// might need 64-bit 2's complement bits to represent it
		int64_t innerDigit = inner[i];
		int64_t accum = innerDigit * outerDigit + carry;
		product[i] = LowLimb(accum);
		carry = HighSLimb(accum);
	}
	int64_t innerDigit = static_cast<int32_t>(inner[innerSize - 1]);
	// This operation can be done with a single 32-bit imul yielding 64-bit result
	int64_t accum = innerDigit * outerDigit + carry;
	product[innerSize - 1] = LowLimb(accum);
	product[innerSize] = HighSLimb(accum);

	return Oop(oteProduct);
}

///////////////////////////////////////////////////////////////////////////////
// liMul - Multiply one LargeInteger by another
//	Private - Answer the result of multiplying the receiver by the argument, anInteger
//

static Oop liMul(const LargeInteger* liOuter, const MWORD outerSize, const LargeInteger* liInner, const MWORD innerSize)
{
	// Can optimize case where multiplying by zero
	ASSERT(innerSize > 0 || liInner->m_digits[0] != 0);

	const MWORD productSize = innerSize + outerSize;
	LargeIntegerOTE* productPointer = LargeInteger::NewWithLimbs(productSize);
	LargeInteger* product = productPointer->m_location;
	uint8_t* prodBytes = reinterpret_cast<uint8_t*>(product->m_digits);

	const MWORD innerByteSize = innerSize << 2;
	const MWORD outerByteSize = outerSize << 2;
	const MWORD productByteSize = productSize << 2;
	ASSERT(outerByteSize > 3);
	ASSERT(innerByteSize > 3);

	const uint8_t* outerBytes = reinterpret_cast<const uint8_t*>(liOuter->m_digits);
	const uint8_t* innerBytes = reinterpret_cast<const uint8_t*>(liInner->m_digits);

	int32_t accum;
	MWORD k = 0;
	for (MWORD i = 0; i < outerByteSize; i++)
	{
		int32_t outerDigit = i == outerByteSize - 1 ? static_cast<int32_t>(static_cast<int8_t>(outerBytes[i])) : outerBytes[i];
		if (outerDigit)
		{
			k = i;
			int32_t carry = 0;
			for (MWORD j = 0; j < innerByteSize; j++)
			{
				int32_t innerDigit = j == innerByteSize - 1 ? static_cast<int32_t>(static_cast<int8_t>(innerBytes[j])) : innerBytes[j];
				ASSERT(k < productSize << 2);
				accum = innerDigit * outerDigit + prodBytes[k] + carry;
				prodBytes[k] = static_cast<uint8_t>(accum & 0xFF);
				carry = accum >> 8;
				k++;
			}

			// Now carry with sign-extend...(if the carry is negative, 
			// then will loop til end, otherwise just once
			while (carry && k < productByteSize)
			{
				accum = prodBytes[k] + carry;
				prodBytes[k] = static_cast<uint8_t>(accum & 0xFF);
				carry = accum >> 8;
				k++;
			}
		}
	}

	return Oop(productPointer);
}

Oop liMul(const LargeIntegerOTE* oteOuter, const LargeIntegerOTE* oteInner) 
{
	const LargeInteger* liOuter = oteOuter->m_location;
	MWORD outerSize = oteOuter->getWordSize();
	const LargeInteger* liInner = oteInner->m_location;
	MWORD innerSize = oteInner->getWordSize();

	// The algorithm is substantially faster if the outer loop is shorter
	return outerSize > innerSize ? liMul(liInner, innerSize, liOuter, outerSize) :
		liMul(liOuter, outerSize, liInner, innerSize);
}


Oop* __fastcall Interpreter::primitiveLargeIntegerMul(Oop* const sp, unsigned)
{
	///////////////////////////////////////////////////////////////////////////////
	// liMul - Multiply one LargeInteger by another
	//	Private - Answer the result of multiplying the receiver by the argument, anInteger
	//
	struct Mul
	{
		Oop operator()(const LargeIntegerOTE* oteOuter, const LargeIntegerOTE* oteInner) const
		{
			return liMul(oteOuter, oteInner);
		}
	};

	struct MulSmallInteger
	{
		Oop operator()(const LargeIntegerOTE* oteInner, SMALLINTEGER outerDigit) const
		{
			return liMulSingle(oteInner, outerDigit);
		}
	};

	return primitiveLargeIntegerOpZ(sp, Mul(), MulSmallInteger());
}


///////////////////////////////////////////////////////////////////////////////
// LargeInteger Division
//

// Single precision division helper routines
// N.B. Note the order of the arguments

#ifdef _M_IX86
	// VC++ is apparently not able to recognise that a single IDIV can calculate both
	// results (and ldiv is thus rather slow), we'll do the job on its behalf
	inline __declspec(naked) ldiv_t __fastcall quoRem(int /*deonimator*/, int /*numerator*/)
	{
		_asm 
		{
			mov		eax, edx					; Get numerator into eax for divide
			cdq									; Sign extend into edx
			idiv	ecx							; Sadly IDIV does not change the flag in a predictable way
			ret
		}
	}
#else
	inline ldiv_t quoRem(long denominator, long numerator)
	{
		return ldiv(numerator, denominator);
	}
#endif

// Perform Smalltalk division/modulus ops in one go, with truncation toward
// negative infinity rather than 0
#ifdef _M_IX86
	// VC++ is apparently not able to recognise that a single IDIV can calculate both
	// results, so we'll do the job on its behalf
	__declspec(naked) ldiv_t __fastcall divMod(int /*deonimator*/, int /*numerator*/)
	{
		_asm 
		{
			mov		eax, edx					; Get numerator into eax for divide
			cdq									; Sign extend into edx
			idiv	ecx							; Sadly IDIV does not change the flag in a predictable way
			test	eax, eax					; Quotient?
			jg		skipAdjust					; greater than zero
			test	edx, edx					; Remainder?
			jz		skipAdjust					; zero
			xor		ecx,edx						; denominator OR numerator signed
			jns		skipAdjust					; no, skip
			xor     ecx,edx						; reverse previous XOR
			dec		eax							; adjust negative quotient
			add     edx,ecx						; adjust remainder by denominator
		skipAdjust:
			ret
		}
	}
#else
	ldiv_t divMod(long denominator, long numerator)
	{
		ldiv_t results = quoRem(denominator, numerator);

		// If quotient negative, there is a remainder, and denominator OR numerator (not both) negative
		if (results.quot < 0 && results.rem && (denominator^results.rem)<0)
		{
			results.quot--;		// Adjust for truncation towards negative infinity
			results.rem += denominator;
		}

		return results;
	}
#endif

// As above, but answers div with truncation towards negative infinity, and remainder
// as if truncated towards zero
#if 0
#ifdef _M_IX86
	// VC++ is apparently not able to recognise that a single IDIV can calculate both
	// results, so we'll do the job on its behalf
	inline __declspec(naked) ldiv_t __fastcall divRem(int /*deonimator*/, int /*numerator*/)
	{
		_asm 
		{
			mov		eax, edx					; Get numerator into eax for divide
			cdq									; Sign extend into edx
			idiv	ecx							; Sadly IDIV does not change the flag in a predictable way
			test	eax, eax					; Quotient?
			jg		skipAdjust					; greater than zero
			test	edx, edx					; Remainder?
			jz		skipAdjust					; zero
			xor		ecx,edx						; denominator OR numerator signed
			jns		skipAdjust					; no, skip
			xor     ecx,edx						; reverse previous XOR
			dec		eax							; adjust negative quotient
		skipAdjust:
			ret
		}
	}
#else
	inline ldiv_t divRem(long denominator, long numerator)
	{
		// Hopefully compiler can optimize these into a single IDIV
		ldiv_t results = quoRem(denominator, numerator);

		// If quotient negative, there is a remainder, and denominator OR numerator (not both) negative
		if (results.quot < 0 && results.rem != 0 && (denominator^results.rem)<0)
		{
			results.quot--;		// Adjust for truncation towards negative infinity
		}

		return results;
	}
#endif
#endif

// Return structure for results of LargeInteger division subroutines
struct liDiv_t
{
	Oop quo;
    Oop rem;
};

///////////////////////////////////////////////////////////////////////////////
// liDivSingle - LargeInteger Single Precision Divide
//
//	Optimized algorithm for dividing a LargeInteger by a single-precision (i.e
//	32-bit) Integer.
//	Answer the quotient and remainder resulting from dividing the first LargeInteger argument
//	by the seond single precision integer argument

liDiv_t __stdcall liDivSingleUnsigned(LargeIntegerOTE* oteLI, SMALLUNSIGNED v)
{
	// v could be 1 greater than MaxSmallInteger as may be negated MinSmallInteger
	_ASSERTE(v <= 0x40000000);
	
	const MWORD qSize = oteLI->getWordSize();
	uint32_t* u = oteLI->m_location->m_digits;

	LargeIntegerOTE* oteQ = LargeInteger::NewWithLimbs(qSize);
	uint32_t* q = oteQ->m_location->m_digits;

	uint32_t rem = 0;
	for (int i=qSize-1;i>=0;i--)
	{
		uint64_t ui = u[i] + (static_cast<uint64_t>(rem) << 32);

		// 64-bit division is done using a rather slow CRT function, but
		// this is still much faster than doing it byte-by-byte because IDIV is
		// a very slow instruction anyway.
		// Its a shame the divide function doesn't also calculate the remainder!
		q[i] = static_cast<uint32_t>(ui / v);
		rem = static_cast<uint32_t>(ui % v);
	}

	liDiv_t quoAndRem;
	quoAndRem.quo = reinterpret_cast<Oop>(oteQ);
	_ASSERTE(ObjectMemoryIsIntegerValue(rem));
	quoAndRem.rem = ObjectMemoryIntegerObjectOf(rem);

	return quoAndRem;
}


liDiv_t __stdcall liDivSingle(LargeIntegerOTE* oteU, SMALLINTEGER v)
{
	// Remainder will be SmallInteger, quotient is (potentially) unnormalized LI
	liDiv_t quoAndRem;

	// Division by -1 can result in overflow, so just pass off to negate
	if (v == -1)
	{
		Oop oopQuo = liNegate(oteU);
		ASSERT(oopQuo != (Oop)oteU);
		quoAndRem.quo = oopQuo;
		quoAndRem.rem = ZeroPointer;
		return quoAndRem;
	}

	LargeInteger* liU = oteU->m_location;
	const MWORD qSize = oteU->getWordSize();

	if (qSize == 1)
	{
		// 32-bit / 32-bit, optimized case
		int32_t ui = liU->m_digits[0];
		ldiv_t qr = quoRem(v, ui);
		Oop oopQuo = LargeInteger::NewSigned32(qr.quot);
		quoAndRem.quo = oopQuo;
		_ASSERTE(ObjectMemoryIsIntegerValue(qr.rem));
		quoAndRem.rem = ObjectMemoryIntegerObjectOf(qr.rem);
	}
	else if (qSize == 2)
	{
		// 64-bit / 32-bit optimized case
		int64_t ui = *reinterpret_cast<int64_t*>(liU->m_digits);
		int64_t quo = ui/v;
		Oop oopQuo = LargeInteger::NewSigned64(quo);
		quoAndRem.quo = oopQuo;
		int32_t rem = static_cast<int32_t>(ui%v);
		_ASSERTE(ObjectMemoryIsIntegerValue(rem));
		quoAndRem.rem = ObjectMemoryIntegerObjectOf(rem);
	}
	else
	{
		// General case - numerator > 64-bits

		// I've given up on my feeble attempts to implement signed 2's complement
		// division, even by a single precision divisor, and in any case division by
		// a positive divisor is much more common and will run faster this way

		int32_t uHigh = liU->signDigit(oteU);

		// Note: Remainder will always have same sign as numerator

		if (uHigh < 0)
		{
			// Numerator is negative

			LargeIntegerOTE* absU = liNegatePriv(oteU);
			ASSERT(!absU->isFree());
			ASSERT(absU->m_count == 0);

			if (v < 0)
			{
				// numerator -ve, denominator -ve, quo +ve, rem -ve
				quoAndRem = liDivSingleUnsigned(absU, -v);

				// Quo OK, but must overwrite remainder with itself negated.
				// Remainder must always be SmallInteger because maximum remainder
				// is one less than absolute value of minimum SmallInteger, i.e. 
				// maximum SmallInteger.
				_ASSERTE(ObjectMemoryIsIntegerObject(quoAndRem.rem));
				SMALLINTEGER rem = ObjectMemoryIntegerValueOf(quoAndRem.rem);
				quoAndRem.rem = ObjectMemoryIntegerObjectOf(-rem);
			}
			else
			{
				// numerator -ve, denominator +ve, quo -ve, rem -ve

				quoAndRem = liDivSingleUnsigned(absU, v);

				quoAndRem.quo = negateIntermediateResult(quoAndRem.quo);

				Oop oopRem = quoAndRem.rem;
				_ASSERTE(ObjectMemoryIsIntegerObject(oopRem));

				SMALLINTEGER intValue = ObjectMemoryIntegerValueOf(oopRem);
				// As negative SmallInteger range is larger, negated must still be small
				intValue = -intValue;
				_ASSERTE(ObjectMemoryIsIntegerValue(intValue));
				quoAndRem.rem = ObjectMemoryIntegerObjectOf(intValue);
			}

			// We no longer need the absolute value of the numerator
			deallocateIntermediateResult(absU);
		}
		else
		{
			// Numerator is positive

			if (v < 0)
			{
				// numerator +ve, denominator -ve, quo -ve, rem +ve.
				quoAndRem = liDivSingleUnsigned(oteU, -v);
				quoAndRem.quo = negateIntermediateResult(quoAndRem.quo);
			}
			else
			{
				// numerator +ve, denominator +ve, quo +ve, rem +ve
				quoAndRem = liDivSingleUnsigned(oteU, v);
			}
		}
	}

/*		unsigned last = qSize-1;
		// Get the sign word
		int32_t ui = liU->m_digits[last];

		if (ui == 0)
		{
			// Special zero top digit used to mark positive number where top bit of preceeding
			// digit is set (would otherwise be negative)
			q->m_digits[last] = signBitOf(v);
			rem = 0;
		}
		else
		{
			// Does not work for 32-bit numerator
			ASSERT(qSize > 1);

  			ldiv_t divAndRem = divRem(v, ui);
			q->m_digits[last] = divAndRem.quot;
			rem = divAndRem.rem;
		}

		for (int i=last-1;i>=0;i--)
		{
			int64_t ui = liU->m_digits[i] + (static_cast<int64_t>(rem) << 32);
			//uint64_t ui = u->m_digits[i] + (static_cast<uint64_t>(rem) << 32);

			// 64-bit division is done using a rather slow CRT function, but
			// this is still much faster than doing it byte-by-byte because IDIV is
			// a very slow instruction anyway.
			// Its a shame the divide function doesn't also calculate the remainder!
			q->m_digits[i] = ui / v;
			rem = ui % v;
		}
	}

	liDiv_t quoAndRem;
	quoAndRem.quo = Oop(oteQ);
	// Remainder might be 32-bit, but no guarantee it will fit in a SmallInteger
	quoAndRem.rem = Integer::NewSigned32(rem);
*/
	return quoAndRem;
}		

ArrayOTE* __fastcall liNewArray2(Oop oop1, Oop oop2)
{
	ArrayOTE* oteResults = Array::NewUninitialized(2);
	Array* array = oteResults->m_location;
	array->m_elements[0] = oop1;
	array->m_elements[1] = oop2;
	ObjectMemory::countUp(oop1);
	ObjectMemory::countUp(oop2);
	return oteResults;
}

//#undef TRACE
//#define TRACE				::trace

liDiv_t __stdcall liDivUnsigned(LargeIntegerOTE* oteEwe, LargeIntegerOTE* oteVee)
{
	const uint64_t b = 0x100000000;
	const uint32_t WM1 = 0xFFFFFFFF;

	LargeInteger* liEwe = oteEwe->m_location;
	LargeInteger* liVee = oteVee->m_location;

#ifdef _DEBUG
	TRACESTREAM<< L"liDivUnsigned:\n	" << oteEwe << 
					"\nby	" << oteVee<< L"\n\n";
#endif

	int eweSize = oteEwe->getWordSize();

	// As this is an unsigned op., we don't need leading zero
	// digit to distinguish positives
	while (liEwe->m_digits[eweSize-1] == 0)
		eweSize--;
	int veeSize = oteVee->getWordSize();
	while (liVee->m_digits[veeSize-1] == 0)
		veeSize--;

	ASSERT(veeSize > 0);

	const int n = veeSize;
	const int m = eweSize - n + 1;

	TRACE(L"n=%d, eweSize= %d, m=%d\n", n, eweSize, m);

	if (m <= 0)
	{
		
		// v > u, so all remainder
		liDiv_t quoAndRem;
		quoAndRem.quo = ZeroPointer;
		quoAndRem.rem = Oop(oteEwe);
		return quoAndRem;
	}

	// Now we follow Knuth...(except that our digits are in reverse)

	/*
		Step D1: Normalize

		Calculate a suitable power of 2, d, such that after multiplying the divisor, v,
		by d, that the high digit of v, v1, is >= b/2, where b is the base (2^32 in this
		case). i.e. shift so that the MSb of the divisor is always set
	*/
	unsigned d = 32 - highBit(liVee->m_digits[n-1]);
	ASSERT(d < 32);	// Leading zeros skipped, so must be at least one bit set in the divisor

	// Note that this shift will introduce exactly one extra digit, regardless of whether
	// the d is 0, because this is a post-condition of liLeftShift().
	LargeIntegerOTE* oteU = liLeftShift(oteEwe, d);
	LargeInteger* liU = oteU->m_location;
	ASSERT(oteU->getWordSize() == oteEwe->getWordSize()+1);

	LargeIntegerOTE* oteV = liLeftShift(oteVee, d);
	LargeInteger* liV = oteV->m_location;
	ASSERT(oteV->getWordSize() == oteVee->getWordSize()+1);

#if 0 //def _DEBUG
	TRACESTREAM<< L"Shifted:\n	U=" << oteU << 
			"\n	V=" << oteV<< L"\n";
#endif

	// Allow one extra digit for sign as otherwise might get negative result
	// (could do more intelligently or at end?)
	LargeIntegerOTE* oteQuo = LargeInteger::NewWithLimbs(m+1);
	LargeInteger* liQuo = oteQuo->m_location;

	uint32_t v1 = liV->m_digits[n-1];
	// MUST have top bit set from normalization
	ASSERT(v1 >= 0x80000000);

#if 1
	// This version should work for single-precision divisor too
	uint32_t v2 = n > 1 ? liV->m_digits[n-2] : 0;
#else
	// divSize must be > 1 because we perform single-precision division separately
	ASSERT(n > 1);
	uint32_t v2 = liV->m_digits[n-2];
#endif

	TRACE(L"d=%d, v1=%X, v2=%X, entering loop 1...\n", d, v1, v2);

	for (int k=1;k<=m;k++)
	{
		const int j = eweSize + 1 - k;
		// Since m = uSize-n+1, and uSize and n are at least 1, j should be at least 1
		ASSERT(j >= 1 && j <= eweSize);

		/*
			Step D3: Calculate q^
		*/
		uint32_t uj = liU->m_digits[j];
		uint32_t uj1 = liU->m_digits[j-1];			// j must be >= 1
		uint64_t ujb = static_cast<uint64_t>(uj) * b;

		uint32_t qHat;
		if (uj == v1)
			qHat = WM1;
		else
		{
			// Because of the leading zero digit after the shift (even if zero bit positions)
			// the absolute maximum value of the ujb+uj1 is 0x7FFFFFFFFFFFFFFF, which can only occur
			// where the v1 is minimum (i.e. 0x80000000), and two consecutive words of u are
			// maximum (i.e. 16rFFFFFFFF). THEREFORE the maximum value of qHat which can result
			// from the calculation is indeed WM1
			ASSERT(((ujb + static_cast<uint64_t>(uj1)) / static_cast<uint64_t>(v1)) <= WM1);
			// Should be possible to divide 64-bit value by 32-bits very efficiently
			qHat = static_cast<uint32_t>((ujb + uj1) / v1);
		}

		// Now correct any trial value of q^ which is too large
		uint32_t uj2 = j < 2 ? 0 : liU->m_digits[j-2];

		uint64_t rHat = ujb + uj1 - (static_cast<uint64_t>(v1) * static_cast<uint64_t>(qHat));
		if (HighULimb(rHat) == 0)
		{
			ASSERT(rHat <= WM1);

			// Avoid compilers buggy shift behaviour, and slow multiply behavior (even for powers of 2) where
			// 64-bit numbers are concerned
			ULARGE_INTEGER rHatb;
			rHatb.LowPart = 0;

			// r^ = ujb + uj1 - v1.q^
			rHatb.HighPart = static_cast<uint32_t>(rHat);
			TRACE(L"	%d: j=%d, uj=%X, uj1=%X, ujb=%I64X, uj2=%X, trial q^=%X, r^=%X\n", k, j, uj, uj1, ujb, uj2, qHat, rHatb.HighPart);

			while ((static_cast<uint64_t>(v2)*qHat > (rHatb.QuadPart + uj2)))
			{
				qHat--;
				TRACE(L"	Adjusting trial q^ to %X, ",qHat);
				if (rHatb.HighPart + v1 < rHatb.HighPart)
				{
					// overflowed - If rHat is >= b, then v2.q^ will be < b.r^
					TRACE(L"\nWARNING: rHat overflow (%I64X)\n", static_cast<uint64_t>(rHatb.HighPart)+v1);
					break;
				}
				else
					rHatb.HighPart += v1;

				TRACE(L"rHat=%X\n",rHatb.HighPart);
			}
		}

		/*
			Step D4: Multiply and subtract

			Replace (uj,uj1, ...,ujn) with (uj,uj1...ujn) - ((v1,v2...vn)*q^)
		*/

		// Our digits are in reverse order to Knuth
		int l = j - n;
		TRACE(L"	Final qHat %X\n	Entering inner loop with l=%d\n", qHat, l);

		LARGE_INTEGER carry;
		carry.QuadPart = 0;

		// For each digit, including the extra one introduced by the shift...
		for (int i=0;i<=n;i++)
		{
			ASSERT(l >= 0 && l < int(oteU->getWordSize()));
			uint32_t uij = liU->m_digits[l];
			uint32_t vi = liV->m_digits[i];

			ULARGE_INTEGER qvi;
			// Avoid slow compiler 64-bit multiply (used even though args 32-bit) ...
			//qvi.QuadPart = static_cast<uint64_t>(vi)*qHat;
			// ...Unfortunately this macro is no better...
			//qvi.QuadPart = UInt32x32To64(vi, qHat);
			// ...so do it in assembler
			_asm
			{
				mov		eax, [qHat]
				mul		[vi]
				mov		[qvi.LowPart], eax
				mov		[qvi.HighPart], edx
			}

			// This expression can overflow and lose the sign of the carry
			// if performed with 64-bit 2's complement arithmetic, so we do 
			// it in assembler using 96 bit arithmetic.
			// N.B. This is not optimal, but I'm more interested
			// in getting this working at the moment!
			// accum.QuadPart = carry + static_cast<uint64_t>(uij) - qvi;
			uint32_t accum;
			_asm
			{
				// were going to use ecx for the bottom word, and eax:edx for the more significant words
				mov		ecx, [carry.LowPart]
				mov		eax, [carry.HighPart]
				cdq									// Sign extend into edx for 96 bit number

				add		ecx, [uij]
				adc		eax, 0						// Ripple any carry up
				adc		edx, 0

				sub		ecx, [qvi.LowPart]
				sbb		eax, [qvi.HighPart]
				sbb		edx, 0						// qvi is an unsigned 64-bit number, therefore top word of 96-bit rep is 0

				mov		[accum], ecx				// Now split up the 96-bit result into digit, and 64-bit carry
				mov		[carry.LowPart], eax
				mov		[carry.HighPart], edx
			}

			liU->m_digits[l] = accum;
			// Minimum value of accumumlator is:
			//	-16rFFFFFFFF + 0 - (16rFFFFFFF*16rFFFFFFF) = -16rFFFFFFFF00000000
			// which requires 96 bits to represent as a 2's complement number
			// (i.e. 16rFFFFFFFF00000000100000000), but only so that the sign is
			// correct. We have to allow for this when calculating the carry - 
			// if writing this in assembler we'd perform a conditional operation
			// on overflow, but unfortunately we can't easily do that in C,
			// so we must test.
			// The range of the carry is:
			//	(1-b)...+1
			// i.e. -16rFFFFFFFF..16r1, which is not trivially representable 
			// as 32-bit 2's complement!
			ASSERT(carry.QuadPart >= static_cast<int64_t>(1-b) && carry.QuadPart <= 1);
			TRACE(L"		i=%d,l=%d: uij=%X, vi=%X, result=%08X %08X %08X (carry %I64d), liU->m_digits[%d]=%X\n",
						i, l, uij, vi, carry.HighPart, carry.LowPart, accum, carry.QuadPart, l, liU->m_digits[l]);
			l++;
		}

		if (carry.QuadPart < 0)
		{
			/*
				Step D6: Add back
			*/
			TRACE(L"	Add back (carry %I64d)!\n", carry);
			
			qHat--;
			l = j - n;
			LARGE_INTEGER accum;
			accum.HighPart = 0;
			for (int i=0;i<=n;i++)
			{
				ASSERT(l >= 0 && l < int(oteU->getWordSize()));
				accum.QuadPart = static_cast<uint64_t>(accum.HighPart) + liU->m_digits[l] + liV->m_digits[i];
				liU->m_digits[l] = accum.LowPart;
				l++;
			}
		}
		else
		{
			// Carry must be 0 or 1 since v0 is 0
			ASSERT(carry.QuadPart < 2);
		}

		int qi = m - k;
		ASSERT(qi >= 0 && qi < m);
		liQuo->m_digits[qi] = qHat;
#ifdef _DEBUG
		TRACESTREAM<< L"\tliQuo->m_digits[" << std::dec << qi<< L"] = " 
			<< std::hex << qHat << std::endl;
		TRACESTREAM<< L"Remainder: " << oteU << std::endl << std::endl;
#endif
	}

	// Don't need shifted divisor any more
	deallocateIntermediateResult(oteV);

	// Reverse the normalizing shift...
	TODO("Zero high digits above?")
	Oop oopRem;
	if (d == 0)
		oopRem = reinterpret_cast<Oop>(oteU);
	else
	{
		oopRem = liRightShift(oteU, d);
		ASSERT(oopRem != (Oop)oteU);
		deallocateIntermediateResult(oteU);
	}

	// Should be normalized later
	//oteQuo->beImmutable();
	liDiv_t quoAndRem;
	quoAndRem.quo = Oop(oteQuo);
	quoAndRem.rem = oopRem;

	return quoAndRem;
}


///////////////////////////////////////////////////////////////////////////////
// liDiv - LargeInteger Multi-Precision Divide
//
// Answers an 8-byte structure containing quotient and remainder (may require normalization)
// Note that truncation is toward zero, not negative infinity

liDiv_t __stdcall liDiv(LargeIntegerOTE* oteU, LargeIntegerOTE* oteV)
{
	LargeInteger* liU = oteU->m_location;
	LargeInteger* liV = oteV->m_location;

	int32_t uHigh = liU->signDigit(oteU);
	int32_t vHigh = liV->signDigit(oteV);

	liDiv_t quoAndRem;

	// Remainder will always have same sign as numerator

	if (uHigh < 0)
	{
		// Numerator is negative

		LargeIntegerOTE* absU = liNegatePriv(oteU);
		ASSERT(!absU->isFree());
		ASSERT(absU->m_count == 0);

		if (vHigh < 0)
		{
			// numerator -ve, denominator -ve, quo +ve, rem -ve
			LargeIntegerOTE* absV = liNegatePriv(oteV);
			quoAndRem = liDivUnsigned(absU, absV);
			deallocateIntermediateResult(absV);
		}
		else
		{
			quoAndRem = liDivUnsigned(absU, oteV);

			// numerator -ve, denominator +ve, quo -ve, rem -ve
			quoAndRem.quo = negateIntermediateResult(quoAndRem.quo);
		}

		quoAndRem.rem = negateIntermediateResult(quoAndRem.rem);

		// We no longer need the absolute value of the numerator, however it might already have been
		// freed above if denominator was larger and the remainder was therefore that value
		if (!absU->isFree())
			deallocateIntermediateResult(absU);
	}
	else
	{
		// Numerator is positive

		if (vHigh < 0)
		{
			// numerator +ve, denominator -ve, quo -ve, rem +ve.
			LargeIntegerOTE* absV = liNegatePriv(oteV);
			quoAndRem = liDivUnsigned(oteU, absV);
			deallocateIntermediateResult(absV);

			quoAndRem.quo = negateIntermediateResult(quoAndRem.quo);
		}
		else
		{
			// numerator +ve, denominator +ve, quo +ve, rem +ve
			quoAndRem = liDivUnsigned(oteU, oteV);
		}
	}

	return quoAndRem;
}


/******************************************************************************
*
*	LargeInteger arithmetic primitives
*
******************************************************************************/

Oop* __fastcall Interpreter::primitiveLargeIntegerNormalize(Oop* const sp, unsigned)
{
	Oop oopNormalized = liNormalize(reinterpret_cast<LargeIntegerOTE*>(*sp));
	*sp = oopNormalized;
	ObjectMemory::AddToZct(oopNormalized);
	return sp;
}

///////////////////////////////////////////////////////////////////////////////
//  LargeInteger Bit Invert (complement)
//
//	Invert the bits of the 2's complement LargeInteger argument
//	The result may not be normalized!
//
Oop* __fastcall Interpreter::primitiveLargeIntegerBitInvert(Oop* const sp, unsigned)
{
	LargeIntegerOTE* oteLI = reinterpret_cast<LargeIntegerOTE*>(*sp);

	LargeInteger* li = oteLI->m_location;

	MWORD size = oteLI->getWordSize();
	MWORD invertedSize = size;

	LargeIntegerOTE* oteInverted = LargeInteger::NewWithLimbs(invertedSize);
	LargeInteger* liInverted = oteInverted->m_location;
	for (unsigned i = 0; i < size; i++)
		liInverted->m_digits[i] = ~li->m_digits[i];

	oteInverted->beImmutable();

	*sp = (Oop)oteInverted;
	ObjectMemory::AddToZct((OTE*)oteInverted);
	return sp;
}

Oop* __fastcall Interpreter::primitiveLargeIntegerNegate(Oop* const sp, unsigned)
{
	Oop oopNegated = liNegate(reinterpret_cast<LargeIntegerOTE*>(*sp));
	*sp = oopNegated;
	ObjectMemory::AddToZct(oopNegated);
	return sp;
}

TODO("Make this routine work - suffers overflow problems at present")
/*
// Private - Answer the result of multiplying the receiver by the argument, anInteger
static LargeIntegerOTE* liMul32(uint32_t *const outer, MWORD outerSize, uint32_t *const inner, MWORD innerSize)
{
	// The algorithm is substantially faster if the outer loop is shorter
	ASSERT(innerSize >= outerSize);

	// Can optimize case where multiplying by zero
	ASSERT(innerSize > 0 || inner[0] != 0);

	MWORD productSize = innerSize + outerSize;
	LargeIntegerOTE* productPointer = LargeInteger::NewWithLimbs(productSize);
	LargeInteger* product = productPointer->m_location;
	
	LARGE_INTEGER accum;
	MWORD k;
	for (MWORD i=0;i<outerSize;i++)
	{
		accum.QuadPart = 0;
		int64_t outerDigit = i==outerSize-1 ? static_cast<int64_t>(static_cast<int32_t>(outer[i])) : outer[i];
		if (outerDigit)
		{
			k = i;
			for (MWORD j=0;j<innerSize;j++)
			{
				int64_t innerDigit = j==innerSize-1 ? static_cast<int64_t>(static_cast<int32_t>(inner[j])) : inner[j];
				ASSERT(k < productSize);
				accum.QuadPart = innerDigit * outerDigit + product->m_digits[k] + accum.HighPart;
				product->m_digits[k] = accum.LowPart;
				k++;
			}
			if (accum.HighPart != 0)
			{
				product->m_digits[k] = accum.HighPart;
				k++;
			}
		}
	}

	// May need to sign extend into remaining digits
	// Could perhaps optimize this by normalizing at same time
	if ((static_cast<int32_t>(outer[outerSize-1]) < 0) !=
		(static_cast<int32_t>(inner[innerSize-1]) < 0))
	{
		// Result is negative
		for (MWORD i=k;i<productSize;i++)
			product->m_digits[i] = -1;
	}

	return productPointer;
}
*/

// N.B. Only produces a result if division is exact, otherwise fails
Oop* __fastcall Interpreter::primitiveLargeIntegerDivide(Oop* const sp, unsigned)
{
	Oop oopV = *sp;
	LargeIntegerOTE* oteU = reinterpret_cast<LargeIntegerOTE*>(*(sp - 1));
	liDiv_t quoAndRem;

	if (ObjectMemoryIsIntegerObject(oopV))
	{
		SMALLINTEGER v = ObjectMemoryIntegerValueOf(oopV);
		quoAndRem = liDivSingle(oteU, v);
	}
	else
	{
		LargeIntegerOTE* oteV = reinterpret_cast<LargeIntegerOTE*>(oopV);
		if (oteV->m_oteClass != Pointers.ClassLargeInteger)
			return primitiveFailure(PrimitiveFailureNonInteger);	// Divisor not an Integer

		quoAndRem = liDiv(oteU, oteV);
		// If divisor is greater than dividend, then the result is all
		// remainder. Of course the primitive cannot succeed in this case anyway
		if (quoAndRem.rem == reinterpret_cast<Oop>(oteU))
		{
			ASSERT(quoAndRem.quo == ZeroPointer);
			return NULL;
		}
	}

	Oop rem = normalizeIntermediateResult(quoAndRem.rem);
	if (rem == ZeroPointer)
	{
		// Divided exactly, so we can succeed by pushing the normalized quotient
		Oop result = normalizeIntermediateResult(quoAndRem.quo);
		*(sp - 1) = result;
		ObjectMemory::AddToZct(result);
		return sp - 1;
	}
	else
	{
		// Must fail because the division was inexact. Smalltalk backup code
		// will create a fraction
		deallocateIntermediateResult(rem);
		deallocateIntermediateResult(quoAndRem.quo);
		return NULL;
	}
}


Oop* __fastcall Interpreter::primitiveLargeIntegerMod(Oop* const sp, unsigned)
{
	return NULL;
}		

// This primitiveLargeInteger (associated with integer division selector //) does work when
// division is not exact (so this is the same as primitiveLargeIntegerDivide, but without check
// for exact division). Note that in Smalltalk integer divide truncates towards
// negative infinity, not zero
Oop* __fastcall Interpreter::primitiveLargeIntegerDiv(Oop* const sp, unsigned)
{
	return NULL;
}		

// Integer division with truncation towards zero
Oop* __fastcall Interpreter::primitiveLargeIntegerQuoAndRem(Oop* const sp, unsigned)
{
	Oop oopV = *sp;
	LargeIntegerOTE* oteU = reinterpret_cast<LargeIntegerOTE*>(*(sp-1));
	liDiv_t quoAndRem;

	if (ObjectMemoryIsIntegerObject(oopV))
	{
		SMALLINTEGER v = ObjectMemoryIntegerValueOf(oopV);
		quoAndRem = liDivSingle(oteU, v);
	}
	else
	{
		LargeIntegerOTE* oteV = reinterpret_cast<LargeIntegerOTE*>(oopV);
		if (oteV->m_oteClass	!= Pointers.ClassLargeInteger)
			return NULL;		// Divisor not an Integer

		quoAndRem = liDiv(oteU, oteV);
	}

	// Answer a two element array containing the normalized results (i.e.
	// the quotient and remainder in their minimal representation).
	Oop quo, rem;
	if (quoAndRem.rem != reinterpret_cast<Oop>(oteU))
	{
		quo = normalizeIntermediateResult(quoAndRem.quo);
		rem = normalizeIntermediateResult(quoAndRem.rem);
	}
	else
	{
		// Divisor larger than dividend, remainder is original dividend
		quo = ZeroPointer;
		rem = quoAndRem.rem;
	}		
		
	OTE* oteResult = reinterpret_cast<POTE>(liNewArray2(quo, rem));
	*(sp - 1) = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct(oteResult);
	return sp - 1;
}		

//////////////////////////////////////////////////////////////////////////////
//	Compare two large integers, answering 
//	-ve for a < b, 0 for a = b, +ve for a > b

template <bool Lt, bool Eq> static bool liCmp(const LargeIntegerOTE* oteA, const LargeIntegerOTE* oteB)
{
	const LargeInteger* liA = oteA->m_location;
	const LargeInteger* liB = oteB->m_location;

	const int aSign = liA->sign(oteA);
	const int bSign = liB->sign(oteB);

	// Compiler will optimize this to one comparison, and two conditional jumps
	if (aSign < bSign)
		return Lt;
	if (aSign > bSign)
		return !Lt;

	// Same sign

	const MWORD ai = oteA->getWordSize();
	const MWORD bi = oteB->getWordSize();

	if (ai == bi)
	{
		int i = ai - 1;
		// Same sign and size: Compare words (same sign, so comparison can be unsigned)
		do
		{
			const uint32_t digitA = liA->m_digits[i];
			const uint32_t digitB = liB->m_digits[i];
			// Again single comparison, two conditional jumps
			if (digitA < digitB)
				return Lt;
			if (digitA > digitB)
				return !Lt;
		} while (--i >= 0);

		// Equal - same sign, same size, all limbs same
		return Eq;
	}
	else
	{
		// Same sign, different lengths, can compare based on number of limbs
		return ((static_cast<int>(ai) - static_cast<int>(bi)) * aSign) < 0 ? Lt : !Lt;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Compare template to generate relational ops (all the same layout)

template <bool Lt, bool Eq> static __forceinline Oop* primitiveLargeIntegerCmp(Oop* const sp)
{
	Oop argPointer = *sp;
	LargeIntegerOTE* oteReceiver = reinterpret_cast<LargeIntegerOTE*>(*(sp - 1));

	if (ObjectMemoryIsIntegerObject(argPointer))
	{
		// SmallInteger argument, which is lesser depends on sign of receiver only because,
		// since LargeIntegers are always normalized, any negative LargeInteger must be less
		// than any SmallInteger, and any positive LargeInteger must be greater than any SmallInteger
		// SmallIntegers can never be equal to normalized large integers
		int sign = oteReceiver->m_location->signDigit(oteReceiver);
		*(sp - 1) = reinterpret_cast<Oop>((sign < 0 ? Lt : !Lt) ? Pointers.True : Pointers.False);
		return sp - 1;
	}
	else
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(argPointer);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			bool cmp = liCmp<Lt, Eq>(oteReceiver, oteArg);
			*(sp - 1) = reinterpret_cast<Oop>(cmp ? Pointers.True : Pointers.False);
			return sp - 1;
		}
		else
			return nullptr;	/* Arg not an integer, fall back on Smalltalk code*/
	}
}

///////////////////////////////////////////////////////////////////////////////
//	Relational operator primitives for LargeIntegers
//

Oop* __fastcall Interpreter::primitiveLargeIntegerLessOrEqual(Oop* const sp, unsigned)
{
	return primitiveLargeIntegerCmp<true, true>(sp);
}

Oop* __fastcall Interpreter::primitiveLargeIntegerLessThan(Oop* const sp, unsigned)
{
	return primitiveLargeIntegerCmp<true,false>(sp);
}

Oop* __fastcall Interpreter::primitiveLargeIntegerGreaterThan(Oop* const sp, unsigned)
{
	return primitiveLargeIntegerCmp<false,false>(sp);
}

Oop* __fastcall Interpreter::primitiveLargeIntegerGreaterOrEqual(Oop* const sp, unsigned)
{
	return primitiveLargeIntegerCmp<false,true>(sp);
}

Oop* __fastcall Interpreter::primitiveLargeIntegerEqual(Oop* const sp, unsigned)
{
	// We Implement this specially, because the generic comparison template does more work than necessary for equality comparison - this is about 20% faster
	Oop argPointer = *sp;

	if (ObjectMemoryIsIntegerObject(argPointer))
	{
		// SmallIntegers cannot be equal to a normalized large integers
		*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
		return sp - 1;
	}
	else
	{
		LargeIntegerOTE* oteReceiver = reinterpret_cast<LargeIntegerOTE*>(*(sp - 1));
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(argPointer);
		if (oteReceiver != oteArg)
		{
			if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
			{
				const MWORD receiverSize = oteReceiver->getSize();
				if (receiverSize != oteArg->getSize())
				{
					// Different sizes, cannot be equal if both normalized
					*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
					return sp - 1;
				}
				else
				{
					// If the same size, we can just memcmp the content. Has to be identical to be equal. 
					// This will account correctly for +/-ve

					const uint32_t* receiver = oteReceiver->m_location->m_digits;
					const uint32_t* arg = oteArg->m_location->m_digits;

					const int words = receiverSize / sizeof(uint32_t);
					for (int i = 0; i < words; i++)
					{
						if (receiver[i] != arg[i])
						{
							*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
							return sp - 1;
						}
					}

					*(sp - 1) = reinterpret_cast<Oop>(Pointers.True);
					return sp - 1;
				}
			}
		}
		else
		{
			// Identical
			*(sp - 1) = reinterpret_cast<Oop>(Pointers.True);
			return sp - 1;
		}
	}

	return nullptr;	/* Arg not an integer, fall back on Smalltalk code*/
}


///////////////////////////////////////////////////////////////////////////////
//	Bit manipulation primitives for LargeIntegers

///////////////////////////////////////////////////////////////////////////////
// LargeInteger #bitAnd:
//
//	This is really pretty easy (and fast) to do, because we are using two's complement
//	notation.
//

Oop liBitAnd(const LargeIntegerOTE* oteA, const LargeIntegerOTE* oteB)
{
	MWORD aSize = oteA->getWordSize();
	MWORD bSize = oteB->getWordSize();

	const uint32_t *digitsA, *digitsB;

	// The algorithm is simpler if we know A is always the longer
	if (aSize < bSize)
	{
		std::swap(aSize, bSize);
		digitsA = oteB->m_location->m_digits;
		digitsB = oteA->m_location->m_digits;
	}
	else
	{
		digitsA = oteA->m_location->m_digits;
		digitsB = oteB->m_location->m_digits;
	}
	__assume(aSize >= bSize);

	LargeIntegerOTE* oteR;
	uint32_t* digitsR;
	if (static_cast<int32_t>(digitsB[bSize - 1]) < 0)
	{
		// bitAnd with shorter negative number
		// The answer must have the correct sign
		oteR = LargeInteger::NewWithLimbs(aSize);
		digitsR = oteR->m_location->m_digits;
		for (unsigned i = bSize; i < aSize; i++)
			digitsR[i] = digitsA[i];
	}
	else
	{
		// bitAnd with shorter positive number
		// Easier in the sense that only the digits up to the B's length
		// need be considered, but we do need to be a bit careful to
		// ensure the result is positive

		oteR = LargeInteger::NewWithLimbs(bSize);
		digitsR = oteR->m_location->m_digits;
	}

	for (unsigned i = 0; i < bSize; i++)
		digitsR[i] = digitsA[i] & digitsB[i];

	// The result MUST have the correct sign, because if both negative then
	// sign bit will be set in both, and hence in the result. OR if 
	// A is positive, it didn't have it sign bit set, hence the result
	// cannot have its sign bit set. OR if B is positive then it cannot
	// have its sign bit set, and hence the result cannot either.
#ifdef _DEBUG
	{
		int aSignBit = signBitOf(static_cast<int32_t>(digitsA[aSize - 1]));
		int bSignBit = signBitOf(static_cast<int32_t>(digitsB[bSize - 1]));
		int rSignBit = signBitOf(static_cast<int32_t>(digitsR[oteR->getWordSize() - 1]));
		ASSERT((aSignBit & bSignBit) == rSignBit);
	}
#endif

	// Made immutable when normalized later
	return reinterpret_cast<Oop>(oteR);
}

// Optimized version for common case of multi-precision receiver and single-precision mask.

Oop liBitAndSingle(const LargeIntegerOTE* oteA, SMALLINTEGER mask)
{
	if (mask >= 0)
	{
		ASSERT(ObjectMemoryIsIntegerValue(mask));

		// bitAnd with positive SmallInteger
		// Only the low-limb need be considered and the result must be a positive SmallInteger

		SMALLINTEGER result = oteA->m_location->m_digits[0] & static_cast<uint32_t>(mask);
		ASSERT(ObjectMemoryIsIntegerValue(result));
		return ObjectMemoryIntegerObjectOf(result);
	}
	else
	{
		// bitAnd with negative SmallInteger
		// Copy across all words except the least significant
		const MWORD aSize = oteA->getWordSize();
		ASSERT(aSize >= 1);
		const uint32_t* digitsA = oteA->m_location->m_digits;

		LargeIntegerOTE* oteR = LargeInteger::NewWithLimbs(aSize);
		uint32_t *digitsR = oteR->m_location->m_digits;
		digitsR[0] = digitsA[0] & static_cast<uint32_t>(mask);
		for (unsigned i = 1; i < aSize; i++)
			digitsR[i] = digitsA[i];

		// The result MUST have the correct sign, because if both negative then
		// sign bit will be set in both, and hence in the result. OR if 
		// A is positive, it didn't have it sign bit set, hence the result
		// cannot have its sign bit set. OR if B is positive then it cannot
		// have its sign bit set, and hence the result cannot either.

#ifdef _DEBUG
		{
			int aSignBit = signBitOf(static_cast<int32_t>(digitsA[aSize - 1]));
			int bSignBit = signBitOf(static_cast<int32_t>(mask));
			int rSignBit = signBitOf(static_cast<int32_t>(digitsR[oteR->getWordSize() - 1]));
			ASSERT((aSignBit & bSignBit) == rSignBit);
		}
#endif

		// Made immutable when normalized later
		return reinterpret_cast<Oop>(oteR);
	}
}

Oop* __fastcall Interpreter::primitiveLargeIntegerBitAnd(Oop* const sp, unsigned)
{
	struct BitAnd
	{
		Oop operator()(const LargeIntegerOTE* oteA, const LargeIntegerOTE* oteB) const
		{
			return liBitAnd(oteA, oteB);
		}
	};

	// Optimized version for common case of multi-precision receiver and single-precision mask.
	struct BitAndSmallInteger
	{
		Oop operator()(const LargeIntegerOTE* oteA, SMALLINTEGER mask) const
		{
			return liBitAndSingle(oteA, mask);
		}
	};

	return primitiveLargeIntegerOpZ(sp, BitAnd(), BitAndSmallInteger());
}

///////////////////////////////////////////////////////////////////////////////
// LargeInteger #bitOr:
//
//	Again easy (and fast) to do, because we are using two's complement notation.
//
Oop liBitOr(const LargeIntegerOTE* oteA, const LargeIntegerOTE* oteB)
{
	MWORD aSize = oteA->getWordSize();
	MWORD bSize = oteB->getWordSize();

	const uint32_t *digitsA, *digitsB;

	// The algorithm is simpler if we know A is always the longer
	if (aSize < bSize)
	{
		std::swap(aSize, bSize);
		digitsA = oteB->m_location->m_digits;
		digitsB = oteA->m_location->m_digits;
	}
	else
	{
		digitsA = oteA->m_location->m_digits;
		digitsB = oteB->m_location->m_digits;
	}
	__assume(aSize >= bSize);

	LargeIntegerOTE* oteR = LargeInteger::NewWithLimbs(aSize);
	uint32_t* digitsR = oteR->m_location->m_digits;

	// Treatment of digits of A (always longer) above size of B
	// differs according to sign of B
	if (static_cast<int32_t>(digitsB[bSize - 1]) < 0)
	{
		// bitOr with shorter negative number
		// The answer must be negative
		// All the digits above the size of B will be -1
		// (anything bitOr'd with 2's complement -1 is -1).
		for (unsigned i = bSize; i < aSize; i++)
			digitsR[i] = static_cast<uint32_t>(-1);
	}
	else
	{
		// bitOr with shorter positive number
		// Just copy across the digits from A
		for (unsigned i = bSize; i < aSize; i++)
			digitsR[i] = digitsA[i];
	}

	for (unsigned i = 0; i < bSize; i++)
		digitsR[i] = digitsA[i] | digitsB[i];

	// Debug check the result has the correct sign
#ifdef _DEBUG
	{
		int aSignBit = signBitOf(static_cast<int32_t>(digitsA[aSize - 1]));
		int bSignBit = signBitOf(static_cast<int32_t>(digitsB[bSize - 1]));
		int rSignBit = signBitOf(static_cast<int32_t>(digitsR[oteR->getWordSize() - 1]));
		ASSERT((aSignBit | bSignBit) == rSignBit);
	}
#endif

	// Made immutable when normalized late
	//oteR->beImmutable();
	return Oop(oteR);
}


// Optimized version for common case of multi-precision receiver and single-precision
// mask.

Oop liBitOrSingle(const LargeIntegerOTE* oteA, SMALLINTEGER mask)
{
	const uint32_t* digitsA = oteA->m_location->m_digits;
	const MWORD aSize = oteA->getWordSize();
	ASSERT(aSize >= 1);

	LargeIntegerOTE* oteR = LargeInteger::NewWithLimbs(aSize);
	uint32_t* digitsR = oteR->m_location->m_digits;
	if (mask < 0)
	{
		// bitOr with single-precision negative number
		// All high digits must be -1 (anything bitOr'd
		// with -1 is -1).
		for (unsigned i = 1; i < aSize; i++)
			digitsR[i] = static_cast<uint32_t>(-1);
	}
	else
	{
		// bitOr with single-precision positive number
		// Copy across digits other than the first from A
		for (unsigned i = 1; i < aSize; i++)
			digitsR[i] = digitsA[i];
	}

	digitsR[0] = digitsA[0] | static_cast<uint32_t>(mask);

	// Debug check the result has the correct sign
#ifdef _DEBUG
	{
		int aSignBit = signBitOf(static_cast<int32_t>(digitsA[aSize - 1]));
		int bSignBit = signBitOf(static_cast<int32_t>(mask));
		int rSignBit = signBitOf(static_cast<int32_t>(digitsR[oteR->getWordSize() - 1]));
		ASSERT((aSignBit | bSignBit) == rSignBit);
	}
#endif

	// Made immutable when normalized late
	//oteR->beImmutable();
	return Oop(oteR);
}

Oop* __fastcall Interpreter::primitiveLargeIntegerBitOr(Oop* const sp, unsigned)
{
	struct BitOr
	{
		Oop operator() (const LargeIntegerOTE* oteA, const LargeIntegerOTE* oteB) const
		{
			return liBitOr(oteA, oteB);
		}
	};


	// Optimized version for common case of multi-precision receiver and single-precision
	// mask.
	struct BitOrSmallInteger
	{
		Oop operator()(const LargeIntegerOTE* oteA, SMALLINTEGER mask) const
		{
			return liBitOrSingle(oteA, mask);
		}
	};

	return primitiveLargeIntegerOpR(sp, BitOr(), BitOrSmallInteger());
}


///////////////////////////////////////////////////////////////////////////////
// LargeInteger #bitXor:
//

Oop liBitXor(const LargeIntegerOTE* oteA, const LargeIntegerOTE* oteB)
{
	MWORD aSize = oteA->getWordSize();
	MWORD bSize = oteB->getWordSize();

	const uint32_t* digitsA, *digitsB;

	// The algorithm is simpler if we know A is always the longer
	if (aSize < bSize)
	{
		std::swap(aSize, bSize);

		digitsA = oteB->m_location->m_digits;
		digitsB = oteA->m_location->m_digits;
	}
	else
	{
		digitsA = oteA->m_location->m_digits;
		digitsB = oteB->m_location->m_digits;
	}
	__assume(aSize >= bSize);

	LargeIntegerOTE* oteR = LargeInteger::NewWithLimbs(aSize);
	uint32_t* digitsR = oteR->m_location->m_digits;

	// Treatment of digits of A (always longer) above size of B
	// differs according to sign of B
	if (static_cast<int32_t>(digitsB[bSize - 1]) < 0)
	{
		// bitXor with shorter negative number
		for (unsigned i = bSize; i < aSize; i++)
			digitsR[i] = digitsA[i] ^ static_cast<uint32_t>(-1);
	}
	else
	{
		// bitXor with shorter positive number
		// Just copy across the digits from A
		for (unsigned i = bSize; i < aSize; i++)
			digitsR[i] = digitsA[i];
	}

	for (unsigned i = 0; i < bSize; i++)
		digitsR[i] = digitsA[i] ^ digitsB[i];

	// Debug check the result has the correct sign
#ifdef _DEBUG
	{
		int aSignBit = signBitOf(static_cast<int32_t>(digitsA[aSize - 1]));
		int bSignBit = signBitOf(static_cast<int32_t>(digitsB[bSize - 1]));
		int rSignBit = signBitOf(static_cast<int32_t>(digitsR[oteR->getWordSize() - 1]));
		ASSERT((aSignBit ^ bSignBit) == rSignBit);
	}
#endif

	// Made immutable when normalized later
	return Oop(oteR);
}

// Optimized version for common case of multi-precision receiver and single-precision
// mask.
Oop liBitXorSingle(const LargeIntegerOTE* oteA, SMALLINTEGER mask)
{
	const uint32_t* digitsA = oteA->m_location->m_digits;
	const MWORD aSize = oteA->getWordSize();
	ASSERT(aSize >= 1);

	LargeIntegerOTE* oteR = LargeInteger::NewWithLimbs(aSize);
	uint32_t* digitsR = oteR->m_location->m_digits;
	if (mask < 0)
	{
		// bitXor with single-precision negative number
		for (unsigned i = 1; i < aSize; i++)
			digitsR[i] = digitsA[i] ^ static_cast<uint32_t>(-1);
	}
	else
	{
		// bitXor with single-precision positive number
		// Copy across digits other than the first from A
		for (unsigned i = 1; i < aSize; i++)
			digitsR[i] = digitsA[i];
	}

	digitsR[0] = digitsA[0] ^ static_cast<uint32_t>(mask);

	// Debug check the result has the correct sign
#ifdef _DEBUG
	{
		int aSignBit = signBitOf(static_cast<int32_t>(digitsA[aSize - 1]));
		int bSignBit = signBitOf(static_cast<int32_t>(mask));
		int rSignBit = signBitOf(static_cast<int32_t>(digitsR[oteR->getWordSize() - 1]));
		ASSERT((aSignBit ^ bSignBit) == rSignBit);
	}
#endif

	// Made immutable when normalized later
	return Oop(oteR);
}


Oop* __fastcall Interpreter::primitiveLargeIntegerBitXor(Oop* const sp, unsigned)
{
	struct BitXor
	{
		Oop operator()(const LargeIntegerOTE* oteA, const LargeIntegerOTE* oteB) const
		{
			return liBitXor(oteA, oteB);
		}
	};

	// Optimized version for common case of multi-precision receiver and single-precision
	// mask.
	struct BitXorSmallInteger
	{
		Oop operator()(const LargeIntegerOTE* oteA, SMALLINTEGER mask) const
		{
			return liBitXorSingle(oteA, mask);

		}
	};

	return primitiveLargeIntegerOpR(sp, BitXor(), BitXorSmallInteger());
}

///////////////////////////////////////////////////////////////////////////////
//	Bit shifting 

Oop* __fastcall Interpreter::primitiveLargeIntegerBitShift(Oop* const sp, unsigned)
{
	Oop argPointer = *sp;
	if (ObjectMemoryIsIntegerObject(argPointer))
	{
		SMALLINTEGER shift = ObjectMemoryIntegerValueOf(argPointer);
		LargeIntegerOTE* oteReceiver = reinterpret_cast<LargeIntegerOTE*>(*(sp-1));

		if (shift < 0)
		{
			// Right shift
			// Note that liRightShift() may answer SmallInteger.
			Oop oopShifted = liRightShift(oteReceiver, -shift);
			Oop result = normalizeIntermediateResult(oopShifted);
			*(sp-1) = result;
			ObjectMemory::AddToZct(result);
		}
		else
		{
			if (shift > 0)
			{
				// Left shift - can't possibly answer SmallInteger
				LargeIntegerOTE* oteShifted = liLeftShift(oteReceiver, shift);
				Oop result = normalizeIntermediateResult(oteShifted);
				*(sp-1) = result;
				ObjectMemory::AddToZct(result);
			}
			// else, shift == 0, drop through to answer receiver
		}
		//CHECKREFERENCES
		return sp - 1;
	}
	else
	{
		// shift MUST be a SmallInteger
		OTE* oteArg = reinterpret_cast<OTE*>(argPointer);
		return primitiveFailureWith(PrimitiveFailureNonInteger, oteArg);
	}
}

Oop* __fastcall Interpreter::primitiveLargeIntegerAsFloat(Oop* const sp, unsigned)
{
	LargeIntegerOTE* oteReceiver = reinterpret_cast<LargeIntegerOTE*>(*sp);
	LargeInteger* liReceiver = oteReceiver->m_location;
	const MWORD size = oteReceiver->getWordSize();
	if (size <= 2)
	{
		FloatOTE* oteResult = Float::New();
		oteResult->m_location->m_fValue = size <= 1
			? static_cast<double>(*reinterpret_cast<int32_t*>(liReceiver->m_digits)) 
			: static_cast<double>(*reinterpret_cast<int64_t*>(liReceiver->m_digits));
		*sp = reinterpret_cast<Oop>(oteResult);
		ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteResult));
		return sp;
	}
	else
		return primitiveFailure(1);
}

#ifdef _DEBUG
// Useful exports for testing...
ArrayOTE* __stdcall liDivSingleExport(LargeIntegerOTE* oteU, SMALLINTEGER v)
{
	liDiv_t quoAndRem = liDivSingle(oteU, v);
	return liNewArray2(quoAndRem.quo, quoAndRem.rem);
}

ArrayOTE* __stdcall liDivUnsignedExport(LargeIntegerOTE* oteU, LargeIntegerOTE* oteV)
{
	liDiv_t quoAndRem = liDivUnsigned(oteU, oteV);
	return liNewArray2(quoAndRem.quo, quoAndRem.rem);
}

ArrayOTE* __stdcall liDivExport(LargeIntegerOTE* oteU, LargeIntegerOTE* oteV)
{
	liDiv_t quoAndRem = liDiv(oteU, oteV);
	return liNewArray2(quoAndRem.quo, quoAndRem.rem);
}
	
#endif


Oop* __fastcall Interpreter::primitiveQWORDAt(Oop* const sp, unsigned)
{
	BytesOTE* oteReceiver = reinterpret_cast<BytesOTE*>(*(sp - 1));
	const Oop oopOffset = *sp;
	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		SMALLUNSIGNED offset = ObjectMemoryIntegerValueOf(oopOffset);
		if (static_cast<SMALLINTEGER>(offset) >= 0 && offset + sizeof(uint64_t) <= oteReceiver->bytesSize())
		{
			VariantByteObject* pBytes = oteReceiver->m_location;
			Oop result = Integer::NewUnsigned64(*reinterpret_cast<uint64_t*>(pBytes->m_fields + offset));

			*(sp - 1) = result;
			ObjectMemory::AddToZct(result);
			return sp - 1;
		}
		else
			return primitiveFailure(PrimitiveFailureBoundsError);
	}

	return primitiveFailure(PrimitiveFailureNonInteger);
}

Oop* __fastcall Interpreter::primitiveSQWORDAt(Oop* const sp, unsigned)
{
	BytesOTE* oteReceiver = reinterpret_cast<BytesOTE*>(*(sp-1));
	const Oop oopOffset = *sp;
	if (ObjectMemoryIsIntegerObject(oopOffset))
	{
		SMALLUNSIGNED offset = ObjectMemoryIntegerValueOf(oopOffset);
		if (static_cast<SMALLINTEGER>(offset) >= 0 && offset + sizeof(int64_t) <= oteReceiver->bytesSize())
		{
			VariantByteObject* pBytes = oteReceiver->m_location;
			Oop result = Integer::NewSigned64(*reinterpret_cast<int64_t*>(pBytes->m_fields + offset));

			*(sp-1) = result;
			ObjectMemory::AddToZct(result);
			return sp-1;
		}
		else
			return primitiveFailure(PrimitiveFailureBoundsError);
	}

	return primitiveFailure(PrimitiveFailureNonInteger);
}
