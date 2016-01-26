/******************************************************************************

	File: LargeIntPrim.cpp

	Description:

	Implementation of the Interpreter class' LargeInteger primitive methods.

	These differ from standard ST-80 in that Dolphin represents LargeIntegers
	in two's complement representation with a 4-byte (DWORD) granularity, i.e
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
	#define MASK_DWORD(op) ((op) & 0xFFFF)	/* avoid error when converting to smaller type */
#else
	#define MASK_DWORD
#endif
// This cast sequence can allow the compiler to generate more efficient code (avoids the need for an arithmetic shift)
#define /*LONG*/ HighSLimb(/*LONGLONG*/ op) (((LARGE_INTEGER*)&op)->HighPart)
#define /*LONG*/ HighULimb(/*LONGLONG*/ op) (((ULARGE_INTEGER*)&op)->HighPart)
#define /*DWORD*/ LowLimb(/*LONGLONG*/ op) (static_cast<DWORD>(MASK_DWORD(op)))

// Forward references
Oop __stdcall liNormalize(LargeIntegerOTE* oteLI);

// Answer the sign bit of the argument
inline static int signBitOf(SDWORD signedInt)
{
	return signedInt < 0 ? -1 : 0;
}

__declspec(naked) unsigned __fastcall highBit(DWORD )
{
	_asm {
		bsr	eax, ecx		// Get high bit index into eax, zero flag set if no bits
		jz	noBitsSet
		inc	eax
		ret
	noBitsSet:
		xor eax, eax
		ret
	}
}

/******************************************************************************
*
* Primitive helper functions
*
* Mose of these can be exported for direct use too.
*
******************************************************************************/

// Answer a new Integer instantiated from the 32-bit positive integer argument.
// The answer is not necessarily in the most reduced form possible (i.e. even if the 
// value would fit in a SmallInteger, this routine will still answer a LargeInteger).
LargeIntegerOTE* __fastcall LargeInteger::liNewSigned(SDWORD value)
{
	LargeIntegerOTE* oteR = reinterpret_cast<LargeIntegerOTE*>(Interpreter::NewDWORD(value, Pointers.ClassLargeInteger));
	oteR->beImmutable();
	return oteR;
}

inline LargeIntegerOTE* LargeInteger::NewWithLimbs(MWORD limbs)
{
	return reinterpret_cast<LargeIntegerOTE*>(ObjectMemory::newByteObject(Pointers.ClassLargeInteger, limbs*sizeof(DWORD)));
}

// Answer a new Integer instantiated from the 32-bit positive integer argument.
// The answer is not necessarily in the most reduced form possible (i.e. even if the 
// value would fit in a SmallInteger, this routine will still answer a LargeInteger).
LargeIntegerOTE* __fastcall LargeInteger::liNewUnsigned(DWORD value)
{
	LargeIntegerOTE* oteLarge;
	if (SDWORD(value) < 0)
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
Oop __stdcall Integer::NewUnsigned64(ULONGLONG ullValue)
{
	ULARGE_INTEGER* pValue = reinterpret_cast<ULARGE_INTEGER*>(&ullValue);
	const DWORD highPart = pValue->HighPart;
	const DWORD lowPart = pValue->LowPart;
	if (!highPart)
		// May fit in 32-bits
		return NewUnsigned32(lowPart);

	// Need up to 96 bits to represent full range of 64-bit positive numbers as 
	// 2's complement
	const unsigned nDigits = SDWORD(highPart) < 0 ? 3 : 2;
	LargeIntegerOTE* oteLarge = LargeInteger::NewWithLimbs(nDigits);
	LargeInteger* large = oteLarge->m_location;
	large->m_digits[0] = lowPart;
	large->m_digits[1] = highPart;

	oteLarge->beImmutable();
	return reinterpret_cast<Oop>(oteLarge);
}

// Answer a new Integer instantiated from the 64-bit integer argument.
// The answer is in the most reduced form possible (i.e. it could even be a SmallInteger
Oop __stdcall Integer::NewSigned64(LONGLONG value)
{
	LARGE_INTEGER* pValue = reinterpret_cast<LARGE_INTEGER*>(&value);
	const SDWORD highPart = pValue->HighPart;
	const DWORD lowPart = pValue->LowPart;
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

	HARDASSERT(ote->m_flags.m_count == 0);
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
Oop __stdcall liNormalize(LargeIntegerOTE* oteLI)
{
	LargeInteger* li = oteLI->m_location;

	MWORD size = oteLI->getWordSize();
	MWORD last = size - 1;
	SDWORD highPart = li->signDigit(oteLI);
	if (last)	// If more than one digit, attempt to remove any which are redundant
	{
		SDWORD liSign = li->signBit(oteLI);

		// See if high part is redundant, and remove leading sign words
		while (last > 0 && highPart == liSign)
		{
			last--;
			highPart = SDWORD(li->m_digits[last]);
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
		ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteLI), (last+1)*sizeof(DWORD));
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

Oop __stdcall normalizeIntermediateResult(Oop integerPointer)
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

	SDWORD carry = 0;		// Initial carry is 0
	for (int i=0;i<size-1;i++)
	{
		LONGLONG digit = li->m_digits[i];
		LONGLONG accum = (digit << bits) | carry;
		liResult->m_digits[i+words] = LowLimb(accum);
		carry = HighSLimb(accum);
	}
	// Last (signed) digit unrolled to avoid condition in loop
	LONGLONG digit = static_cast<SDWORD>(li->m_digits[size-1]);
	LONGLONG accum = (digit << bits) | carry;
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
		return ObjectMemoryIntegerObjectOf(li->signBit(oteLI));

	LargeIntegerOTE* oteResult = LargeInteger::NewWithLimbs(resultSize);
	LargeInteger* liResult = oteResult->m_location;

	if (!bits)
	{
		// Perform shifting of integral numbers of words separately
		// because not only is this faster (just a memcpy), but it 
		// avoids problems with shifts of more than 31 bits on Intel 
		// hardware (which are performed modulo 32, i.e. << 32 actually 
		// results in << 0 and gives the wrong result - the operand and not 0).
		memcpy(liResult->m_digits, li->m_digits+words, resultSize*sizeof(DWORD));
	}
	else
	{
		int carryShift = 32 - bits;
		ASSERT(carryShift >= 0);

		// Do top shift separately because it contains sign
		DWORD digit = li->m_digits[size-1];
		// Perform an arithmetic shift (with sign carry-in) of the top digit
		liResult->m_digits[resultSize-1] = SDWORD(digit) >> bits;
		// The carry will be at most 31 bits
		DWORD carry;
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

	SDWORD highDigit = SDWORD(li->m_digits[size-1]);
	MWORD negatedSize = size;

	// Handle boundary conditions to avoid the need to allocate extra digits and/or
	// normalize the result. Because the range of positive/negative 2's complement
	// Integers differs by 1, we may have to "increase" or "reduce" the representation
	if (highDigit == -SDWORD(0x80000000))
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
	SDWORD carry = 1;
	
	for (MWORD i=0;i<size;i++)
	{
		// Must cast at least one operand to 64-bits so that 64-bit (signed) addition performed
		LONGLONG accum = LONGLONG(~li->m_digits[i]) + carry;
		liNegated->m_digits[i] = LowLimb(accum);
		carry = HighSLimb(accum);
	}

	return oteNegated;
}

Oop __stdcall liNegate(LargeIntegerOTE* oteLI)
{
	LargeInteger* li = oteLI->m_location;
	const int size = oteLI->getWordSize();
	if (size == 1 && SDWORD(li->m_digits[0]) == 0x40000000)
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
//	Add a single-precision (32-bit) Integer to a multi-precision integer
//	This is easy and fast (a ripple carry with special treatment for the sign digit)
Oop __stdcall liAddSingle(LargeIntegerOTE* oteLI, SMALLINTEGER operand)
{
	ASSERT(operand != 0);
	__assume(operand != 0);

	LargeInteger* li = oteLI->m_location;
	const MWORD limbs = oteLI->getWordSize();

	LargeIntegerOTE* oteSum = LargeInteger::NewWithLimbs(limbs);
	LargeInteger* liSum = oteSum->m_location;
	const MWORD last = limbs - 1;

	SDWORD addend = operand;
	for (MWORD i=0;i<last;i++)
	{
		// Must cast at least one operand to 64-bits so that 64-bit addition performed
		LONGLONG accum = static_cast<LONGLONG>(li->m_digits[i]) + addend;
		liSum->m_digits[i] = LowLimb(accum);
		addend = HighSLimb(accum);
	}

	// Last digit unrolled because we need to use signed arithmetic here
	LONGLONG accum = static_cast<LONGLONG>(static_cast<SDWORD>(li->m_digits[last])) + addend;
	liSum->m_digits[last] = LowLimb(accum);

	// If sign of 32-bit representation is not same as 64-bit, then need another sign limb
	const bool negative = accum < 0;
	if (negative != static_cast<SDWORD>(accum) < 0)
	{
		// Add extra digit necessary to represent the sign
		LargeInteger* pSum = reinterpret_cast<LargeInteger*>(ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteSum), (limbs+1)<<2));
		pSum ->m_digits[limbs] = negative * -1;
	}

	// Made immutable by normalize
	//	oteSum->beImmutable();
	return Oop(oteSum);
}

///////////////////////////////////////////////////////////////////////////////
// liAdd - LargeInteger multi-precision Add
//
//	Add a multi-precision Integer to another multi-precision integer.

Oop __stdcall liAdd(LargeIntegerOTE* oteOp1, LargeIntegerOTE* oteOp2)
{
	MWORD size1 = oteOp1->getWordSize();
	MWORD size2 = oteOp2->getWordSize();
	
	if (size1 < size2)
	{
		// operand 2 is larger than operand 1, add op1 to op2

		swap(oteOp1, oteOp2);
		swap(size1, size2);
	}

	LargeInteger *liOp1 = oteOp1->m_location;
	LargeInteger *liOp2 = oteOp2->m_location;

	__assume(size1 >= size2);

	if (size2 == 1) return liAddSingle(oteOp1, static_cast<SDWORD>(liOp2->m_digits[0]));

	LargeIntegerOTE* oteSum = LargeInteger::NewWithLimbs(size1);
	LargeInteger* liSum = oteSum->m_location;

	SDWORD carry = 0;

	MWORD i = 0;
	// add up the least significant limbs up to, but not including, the most-significant limb of the addend (the receiver is at least as large)
	for (;i<size2-1;i++)
	{
		LONGLONG accum = static_cast<LONGLONG>(liOp1->m_digits[i]) + liOp2->m_digits[i] + carry;
		liSum->m_digits[i] = LowLimb(accum);
		carry = HighSLimb(accum);
	}

	if (size1 > size2)
	{
		// Now the most significant limb of the (smaller) addend is considered - we need to ensure to sign extend it
		LONGLONG accum = static_cast<LONGLONG>(liOp1->m_digits[i]) + static_cast<SDWORD>(liOp2->m_digits[i]) + carry;
		liSum->m_digits[i++] = LowLimb(accum);
		carry = HighSLimb(accum);

		// Ripple any remaining carry through remaining less significant limbs
		for (;i<size1-1;i++)
		{
			LONGLONG accum = static_cast<LONGLONG>(liOp1->m_digits[i]) + carry;
			liSum->m_digits[i] = LowLimb(accum);
			carry = HighSLimb(accum);
		}

		ASSERT(i == size1-1);
		// Add in most significant limb of receiver (+ any carry) - again we must sign extend it
		accum = static_cast<LONGLONG>(static_cast<SDWORD>(liOp1->m_digits[i])) + carry;
		liSum->m_digits[i] = LowLimb(accum);
		carry = HighSLimb(accum);
	}
	else
	{
		ASSERT(i == size1-1);
		LONGLONG accum = static_cast<LONGLONG>(static_cast<SDWORD>(liOp1->m_digits[i])) + static_cast<SDWORD>(liOp2->m_digits[i]) + carry;
		liSum->m_digits[i] = LowLimb(accum);
		carry = HighSLimb(accum);
	}

	// If sign of 32-bit representation is not same as 64-bit, then need another sign limb
	// This case should be relatively rare, so we add it later rather than make initially and resize down
	if ((carry < 0) != (static_cast<SDWORD>(liSum->m_digits[i]) < 0))
	{
		// Add extra digit necessary to represent the sign
		LargeInteger* pSum = reinterpret_cast<LargeInteger*>(ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteSum), (size1+1)<<2));
		ASSERT(carry == 0 || carry == -1);
		pSum ->m_digits[size1] = carry;
	}

	// Made immutable by normalize
	//	oteSum->beImmutable();
	return Oop(oteSum);
}

///////////////////////////////////////////////////////////////////////////////
// liSubSingle - LargeInteger Single-precision Subtract
//	Subtract a single-precision (32-bit) Integer from a multi-precision integer
//	This is easy and fast (a ripple carry with special treatment for the sign digit)

Oop __stdcall liSubSingle(LargeIntegerOTE* oteLI, SMALLINTEGER operand)
{
	LargeInteger* li = oteLI->m_location;
	const MWORD differenceSize = oteLI->getWordSize();

	LargeIntegerOTE* oteDifference = LargeInteger::NewWithLimbs(differenceSize);
	LargeInteger* liDifference = oteDifference->m_location;
	const MWORD last = differenceSize - 1;

	// The initial "borrow" is the argument
	SDWORD carry = operand * -1;

	for (MWORD i=0;i<last;i++)
	{
		// Must cast at least one operand to 64-bits so that 64-bit subtraction performed
		LONGLONG accum = LONGLONG(li->m_digits[i]) + carry;
		liDifference->m_digits[i] = LowLimb(accum);
		carry = HighSLimb(accum);
	}

	// Last digit unrolled because we need to use signed arithmetic here
	// May not sign extend correctly without cast
	LONGLONG accum = LONGLONG(li->signDigit(oteLI)) + carry;
	liDifference->m_digits[last] = LowLimb(accum);

	// Now drop through to handle the final borrow (in accum.HighPart) in common
	// code. This may involve growing the result if it cannot be represented as
	// a two's complement number in the current number of digits..
	if (accum < -(LONGLONG)0x80000000 || accum >= 0x80000000)
	{
		// Not at 32-bit two's complement number, so there must be a remaining borrow...

		// Add extra digit necessary to represent the sign
		LargeInteger* pDifference = reinterpret_cast<LargeInteger*>(ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteDifference), (differenceSize+1)<<2));
		pDifference->m_digits[differenceSize] = HighSLimb(accum);
	}

	// Made immutable by normalize
	//oteDifference->beImmutable();
	return Oop(oteDifference);
}

Oop __stdcall liSub(LargeIntegerOTE* oteLI, LargeIntegerOTE* oteOperand)
{
	LargeInteger* li = oteLI->m_location;
	LargeInteger* liOperand = oteOperand->m_location;

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
	LargeInteger* liDifference = oteDifference->m_location;

	SDWORD carry = 0;

	for (MWORD i=0;i<differenceSize;i++)
	{
		TODO("Unroll this loop to avoid conditionals in loop")
		// Compiler unable to optimize size() calls out
		//LONGLONG a = receiver.digitAt(i);
		LONGLONG a = i<size ? (i==size-1 ? LONGLONG(SDWORD(li->m_digits[i])) : li->m_digits[i]) : 0;
		
		//LONGLONG b = larg.digitAt(i);
		LONGLONG b = i<operandSize ? (i==operandSize-1 ? LONGLONG(SDWORD(liOperand->m_digits[i])) : liOperand->m_digits[i]) : 0;

		LONGLONG accum = a - b + carry;
		liDifference->m_digits[i] = LowLimb(accum);
		carry = HighSLimb(accum);
	}

	SDWORD signLimb = static_cast<SDWORD>(liDifference->m_digits[differenceSize-1]);
	if ((carry < 0) !=  (signLimb < 0))
	{
		// Not at 32-bit two's complement number, so there must be a remaining borrow...

		// Add extra digit necessary to represent the sign
		LargeInteger* pDifference = reinterpret_cast<LargeInteger*>(ObjectMemory::resize(reinterpret_cast<BytesOTE*>(oteDifference), (differenceSize+1)<<2));
		pDifference->m_digits[differenceSize] = carry;
	}

	// Made immutable by normalize
	//oteDifference->beImmutable();
	return Oop(oteDifference);
}


/******************************************************************************
*
* Multiplication
*
******************************************************************************/

///////////////////////////////////////////////////////////////////////////////
// liMul - Multiply one LargeInteger by another
//	Private - Answer the result of multiplying the receiver by the argument, anInteger

Oop __stdcall liMul(const LargeInteger* liOuter, const MWORD outerSize, const LargeInteger* liInner, const MWORD innerSize)
{
	// Can optimize case where multiplying by zero
	ASSERT(innerSize > 0 || liInner->m_digits[0] != 0);

	const MWORD productSize = innerSize + outerSize;
	LargeIntegerOTE* productPointer = LargeInteger::NewWithLimbs(productSize);
	LargeInteger* product = productPointer->m_location;
	BYTE* prodBytes = reinterpret_cast<BYTE*>(product->m_digits);
	
	const MWORD innerByteSize = innerSize << 2;
	const MWORD outerByteSize = outerSize << 2;
	const MWORD productByteSize = productSize << 2;
	ASSERT(outerByteSize > 3);
	ASSERT(innerByteSize > 3);

	const BYTE* outerBytes = reinterpret_cast<const BYTE*>(liOuter->m_digits);
	const BYTE* innerBytes = reinterpret_cast<const BYTE*>(liInner->m_digits);

	SDWORD accum;
	MWORD k=0;
	for (MWORD i=0;i<outerByteSize;i++)
	{
		SDWORD outerDigit = i==outerByteSize-1 ? SDWORD(SBYTE(outerBytes[i])) : outerBytes[i];
		if (outerDigit)
		{
			k = i;
			SDWORD carry = 0;
			for (MWORD j=0;j<innerByteSize;j++)
			{
				SDWORD innerDigit = j==innerByteSize-1 ? SDWORD(SBYTE(innerBytes[j])) : innerBytes[j];
				ASSERT(k < productSize<<2);
				accum = innerDigit * outerDigit + prodBytes[k] + carry;
				prodBytes[k] = static_cast<BYTE>(accum & 0xFF);
				carry = accum >> 8;
				k++;
			}

			// Now carry with sign-extend...(if the carry is negative, 
			// then will loop til end, otherwise just once
			while(carry && k < productByteSize)
			{
				accum = prodBytes[k] + carry;
				prodBytes[k] = static_cast<BYTE>(accum & 0xFF);
				carry = accum >> 8;
				k++;
			}
		}
	}

	return Oop(productPointer);
}

Oop __stdcall liMul(LargeIntegerOTE* oteOuter, LargeIntegerOTE* oteInner)
{
	LargeInteger* liOuter = oteOuter->m_location;
	MWORD outerSize = oteOuter->getWordSize();
	LargeInteger* liInner = oteInner->m_location;
	MWORD innerSize = oteInner->getWordSize();

	// The algorithm is substantially faster if the outer loop is shorter
	return outerSize > innerSize ? liMul(liInner, innerSize, liOuter, outerSize) : 
									liMul(liOuter, outerSize, liInner, innerSize);
}		

///////////////////////////////////////////////////////////////////////////////
// liMulSingle - LargeInteger Single Precision Multiple
//
// Multiply a LargeInteger by a SmallInteger. Optimized for this most common case

Oop __stdcall liMulSingle(LargeIntegerOTE* oteInner, SMALLINTEGER outerDigit)
{
	ASSERT(outerDigit != 0);

	LargeInteger* liInner = oteInner->m_location;
	MWORD innerSize = oteInner->getWordSize();

	// Can optimize case where multiplying by zero
	ASSERT(innerSize > 0 || liInner->m_digits[0] != 0);

	const MWORD productSize = innerSize + 1;
	LargeIntegerOTE* oteProduct = LargeInteger::NewWithLimbs(productSize);
	LargeInteger* product = oteProduct->m_location;
	
	SDWORD carry = 0;
	for (MWORD i=0;i<innerSize-1;i++)
	{
		// This operations requires a 64-bit multiply because positive 32-bit int 
		// might need 64-bit 2's complement bits to represent it
		LONGLONG innerDigit = liInner->m_digits[i];
		LONGLONG accum = innerDigit * outerDigit + carry;
		product->m_digits[i] = LowLimb(accum);
		carry = HighSLimb(accum);
	}
	LONGLONG innerDigit = SDWORD(liInner->m_digits[innerSize-1]);
	// This operation can be done with a single 32-bit imul yielding 64-bit result
	LONGLONG accum = innerDigit * outerDigit + carry;
	product->m_digits[innerSize-1] = LowLimb(accum);
	product->m_digits[innerSize] = HighSLimb(accum);

	return Oop(oteProduct);
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
	LargeInteger* liU = oteLI->m_location;

	LargeIntegerOTE* oteQ = LargeInteger::NewWithLimbs(qSize);
	LargeInteger* q = oteQ->m_location;

	DWORD rem = 0;
	for (int i=qSize-1;i>=0;i--)
	{
		DWORDLONG ui = liU->m_digits[i] + (DWORDLONG(rem) << 32);

		// 64-bit division is done using a rather slow CRT function, but
		// this is still much faster than doing it byte-by-byte because IDIV is
		// a very slow instruction anyway.
		// Its a shame the divide function doesn't also calculate the remainder!
		q->m_digits[i] = static_cast<DWORD>(ui / v);
		rem = static_cast<DWORD>(ui % v);
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
		SDWORD ui = liU->m_digits[0];
		ldiv_t qr = quoRem(v, ui);
		Oop oopQuo = LargeInteger::NewSigned32(qr.quot);
		quoAndRem.quo = oopQuo;
		_ASSERTE(ObjectMemoryIsIntegerValue(qr.rem));
		quoAndRem.rem = ObjectMemoryIntegerObjectOf(qr.rem);
	}
	else if (qSize == 2)
	{
		// 64-bit / 32-bit optimized case
		LONGLONG ui = *reinterpret_cast<LONGLONG*>(liU->m_digits);
		LONGLONG quo = ui/v;
		Oop oopQuo = LargeInteger::NewSigned64(quo);
		quoAndRem.quo = oopQuo;
		SDWORD rem = static_cast<SDWORD>(ui%v);
		_ASSERTE(ObjectMemoryIsIntegerValue(rem));
		quoAndRem.rem = ObjectMemoryIntegerObjectOf(rem);
	}
	else
	{
		// General case - numerator > 64-bits

		// I've given up on my feeble attempts to implement signed 2's complement
		// division, even by a single precision divisor, and in any case division by
		// a positive divisor is much more common and will run faster this way

		SDWORD uHigh = liU->signDigit(oteU);

		// Note: Remainder will always have same sign as numerator

		if (uHigh < 0)
		{
			// Numerator is negative

			LargeIntegerOTE* absU = liNegatePriv(oteU);
			ASSERT(!absU->isFree());
			ASSERT(absU->m_flags.m_count == 0);

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
		SDWORD ui = liU->m_digits[last];

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
			LONGLONG ui = liU->m_digits[i] + (LONGLONG(rem) << 32);
			//DWORDLONG ui = u->m_digits[i] + (DWORDLONG(rem) << 32);

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

/*

inline __declspec(naked) DWORDLONG __fastcall liMul32x32(DWORD , DWORD )
{
	_asm
	{
		mov	eax, ecx
		mul	edx
		ret
	}
}
*/

//#undef TRACE
//#define TRACE				::trace

liDiv_t __stdcall liDivUnsigned(LargeIntegerOTE* oteEwe, LargeIntegerOTE* oteVee)
{
	const DWORDLONG b = 0x100000000;
	const DWORD WM1 = 0xFFFFFFFF;

	LargeInteger* liEwe = oteEwe->m_location;
	LargeInteger* liVee = oteVee->m_location;

#ifdef _DEBUG
	TRACESTREAM << "liDivUnsigned:\n	" << oteEwe << 
					"\nby	" << oteVee << "\n\n";
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

	TRACE("n=%d, eweSize= %d, m=%d\n", n, eweSize, m);

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
	TRACESTREAM << "Shifted:\n	U=" << oteU << 
			"\n	V=" << oteV << "\n";
#endif

	// Allow one extra digit for sign as otherwise might get negative result
	// (could do more intelligently or at end?)
	LargeIntegerOTE* oteQuo = LargeInteger::NewWithLimbs(m+1);
	LargeInteger* liQuo = oteQuo->m_location;

	DWORD v1 = liV->m_digits[n-1];
	// MUST have top bit set from normalization
	ASSERT(v1 >= 0x80000000);

#if 1
	// This version should work for single-precision divisor too
	DWORD v2 = n > 1 ? liV->m_digits[n-2] : 0;
#else
	// divSize must be > 1 because we perform single-precision division separately
	ASSERT(n > 1);
	DWORD v2 = liV->m_digits[n-2];
#endif

	TRACE("d=%d, v1=%X, v2=%X, entering loop 1...\n", d, v1, v2);

	for (int k=1;k<=m;k++)
	{
		const int j = eweSize + 1 - k;
		// Since m = uSize-n+1, and uSize and n are at least 1, j should be at least 1
		ASSERT(j >= 1 && j <= eweSize);

		/*
			Step D3: Calculate q^
		*/
		DWORD uj = liU->m_digits[j];
		DWORD uj1 = liU->m_digits[j-1];			// j must be >= 1
		DWORDLONG ujb = (DWORDLONG)uj * b;

		DWORD qHat;
		if (uj == v1)
			qHat = WM1;
		else
		{
			// Because of the leading zero digit after the shift (even if zero bit positions)
			// the absolute maximum value of the ujb+uj1 is 0x7FFFFFFFFFFFFFFF, which can only occur
			// where the v1 is minimum (i.e. 0x80000000), and two consecutive words of u are
			// maximum (i.e. 16rFFFFFFFF). THEREFORE the maximum value of qHat which can result
			// from the calculation is indeed WM1
			ASSERT(((ujb + (DWORDLONG)uj1) / (DWORDLONG)v1) <= WM1);
			// Should be possible to divide 64-bit value by 32-bits very efficiently
			qHat = static_cast<DWORD>((ujb + uj1) / v1);
		}

		// Now correct any trial value of q^ which is too large
		DWORD uj2 = j < 2 ? 0 : liU->m_digits[j-2];

		DWORDLONG rHat = ujb + uj1 - ((DWORDLONG)v1*(DWORDLONG)qHat);
		if (HighULimb(rHat) == 0)
		{
			ASSERT(rHat <= WM1);

			// Avoid compilers buggy shift behaviour, and slow multiply behavior (even for powers of 2) where
			// 64-bit numbers are concerned
			ULARGE_INTEGER rHatb;
			rHatb.LowPart = 0;

			// r^ = ujb + uj1 - v1.q^
			rHatb.HighPart = static_cast<DWORD>(rHat);
			TRACE("	%d: j=%d, uj=%X, uj1=%X, ujb=%I64X, uj2=%X, trial q^=%X, r^=%X\n", k, j, uj, uj1, ujb, uj2, qHat, rHatb.HighPart);

			while ((DWORDLONG(v2)*qHat > (rHatb.QuadPart + uj2)))
			{
				qHat--;
				TRACE("	Adjusting trial q^ to %X, ",qHat);
				if (rHatb.HighPart + v1 < rHatb.HighPart)
				{
					// overflowed - If rHat is >= b, then v2.q^ will be < b.r^
					TRACE("\nWARNING: rHat overflow (%I64X)\n", DWORDLONG(rHatb.HighPart)+v1);
					break;
				}
				else
					rHatb.HighPart += v1;

				TRACE("rHat=%X\n",rHatb.HighPart);
			}
		}

		/*
			Step D4: Multiply and subtract

			Replace (uj,uj1, ...,ujn) with (uj,uj1...ujn) - ((v1,v2...vn)*q^)
		*/

		// Our digits are in reverse order to Knuth
		int l = j - n;
		TRACE("	Final qHat %X\n	Entering inner loop with l=%d\n", qHat, l);

		LARGE_INTEGER carry;
		carry.QuadPart = 0;

		// For each digit, including the extra one introduced by the shift...
		for (int i=0;i<=n;i++)
		{
			ASSERT(l >= 0 && l < int(oteU->getWordSize()));
			DWORD uij = liU->m_digits[l];
			DWORD vi = liV->m_digits[i];

			ULARGE_INTEGER qvi;
			// Avoid slow compiler 64-bit multiply (used even though args 32-bit) ...
			//qvi.QuadPart = DWORDLONG(vi)*qHat;
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
			// accum.QuadPart = carry + DWORDLONG(uij) - qvi;
			DWORD accum;
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
			ASSERT(carry.QuadPart >= LONGLONG(1-b) && carry.QuadPart <= 1);
			TRACE("		i=%d,l=%d: uij=%X, vi=%X, result=%08X %08X %08X (carry %I64d), liU->m_digits[%d]=%X\n",
						i, l, uij, vi, carry.HighPart, carry.LowPart, accum, carry.QuadPart, l, liU->m_digits[l]);
			l++;
		}

		if (carry.QuadPart < 0)
		{
			/*
				Step D6: Add back
			*/
			TRACE("	Add back (carry %I64d)!\n", carry);
			
			qHat--;
			l = j - n;
			LARGE_INTEGER accum;
			accum.HighPart = 0;
			for (int i=0;i<=n;i++)
			{
				ASSERT(l >= 0 && l < int(oteU->getWordSize()));
				accum.QuadPart = DWORDLONG(accum.HighPart) + liU->m_digits[l] + liV->m_digits[i];
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
		TRACESTREAM << "\tliQuo->m_digits[" << dec << qi << "] = " 
			<< hex << qHat << endl;
		TRACESTREAM << "Remainder: " << oteU << endl << endl;
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

	SDWORD uHigh = liU->signDigit(oteU);
	SDWORD vHigh = liV->signDigit(oteV);

	liDiv_t quoAndRem;

	// Remainder will always have same sign as numerator

	if (uHigh < 0)
	{
		// Numerator is negative

		LargeIntegerOTE* absU = liNegatePriv(oteU);
		ASSERT(!absU->isFree());
		ASSERT(absU->m_flags.m_count == 0);

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

///////////////////////////////////////////////////////////////////////////////
// liBitInvert - LargeInteger Bit Invert (complement)
//
//	Invert the bits of the 2's complement LargeInteger argument
//	The answer may not be normalized!

LargeIntegerOTE* __stdcall liBitInvert(LargeIntegerOTE* oteLI)
{
	LargeInteger* li = oteLI->m_location;

	MWORD size = oteLI->getWordSize();
//	MWORD last = size - 1;
//	SDWORD highDigit = SDWORD(li->m_digits[last]);
	MWORD invertedSize = size;
	//if (highDigit == -SDWORD(2147483648))
		// Will need extra zero digit to represent as positive value
	//	invertedSize++;
		
	LargeIntegerOTE* oteInverted = LargeInteger::NewWithLimbs(invertedSize);
	LargeInteger* liInverted = oteInverted->m_location;
	for (unsigned i=0;i<size;i++)
		liInverted->m_digits[i] = ~li->m_digits[i];

	// Result not normalised later, so must make immutable here
	oteInverted->beImmutable();
	return oteInverted;
}


///////////////////////////////////////////////////////////////////////////////
// liBitAnd - LargeInteger #bitAnd:
//
//	Answer the result of a bitwise And between two large integers.
//	The result may require normalization
//
//	This is really pretty easy (and fast) to do, because we are using two's complement
//	notation.

Oop __stdcall liBitAnd(LargeIntegerOTE* oteA, LargeIntegerOTE* oteB)
{
	LargeInteger* liA = oteA->m_location;
	const MWORD aSize = oteA->getWordSize();
	LargeInteger* liB = oteB->m_location;
	const MWORD bSize = oteB->getWordSize();

	// The algorithm is simpler if we know A is always the longer
	if (aSize < bSize)
		return liBitAnd(oteB, oteA);

	LargeIntegerOTE* oteR;
	if (SDWORD(liB->m_digits[bSize-1]) < 0)
	{
		// bitAnd with shorter negative number
		// The answer must have the correct sign
		oteR = LargeInteger::NewWithLimbs(aSize);
		LargeInteger* liR = oteR->m_location;
		for (unsigned i=bSize;i<aSize;i++)
			liR->m_digits[i] = liA->m_digits[i];
	}
	else
	{
		// bitAnd with shorter positive number
		// Easier in the sense that only the digits up to the B's length
		// need be considered, but we do need to be a bit careful to
		// ensure the result is positive

		oteR = LargeInteger::NewWithLimbs(bSize);
	}

	LargeInteger* liR = oteR->m_location;
	for (unsigned i=0;i<bSize;i++)
		liR->m_digits[i] = liA->m_digits[i] & liB->m_digits[i];

	// The result MUST have the correct sign, because if both negative then
	// sign bit will be set in both, and hence in the result. OR if 
	// A is positive, it didn't have it sign bit set, hence the result
	// cannot have its sign bit set. OR if B is positive then it cannot
	// have its sign bit set, and hence the result cannot either.
	#ifdef _DEBUG
	{
		int aSignBit = liA->signBit(oteA);
		int bSignBit = liB->signBit(oteB);
		int rSignBit = liR->signBit(oteR);
		ASSERT((aSignBit & bSignBit) == rSignBit);
	}
	#endif

	// Made immutable when normalized late
	//oteR->beImmutable();
	return reinterpret_cast<Oop>(oteR);
}

// Optimized version for common case of multi-precision receiver and single-precision
// mask.
Oop __stdcall liBitAndSingle(LargeIntegerOTE* oteA, SMALLINTEGER mask)
{
	LargeInteger* liA = oteA->m_location;
	const MWORD aSize = oteA->getWordSize();
	ASSERT(aSize >= 1);


	LargeIntegerOTE* oteR;
	if (mask < 0)
	{
		// bitAnd with single-precision negative number
		// Copy across all words except the least significant
		oteR = LargeInteger::NewWithLimbs(aSize);
		LargeInteger* liR = oteR->m_location;
		for (unsigned i=1;i<aSize;i++)
			liR->m_digits[i] = liA->m_digits[i];
	}
	else
	{
		// bitAnd with single-precision positive number
		// Easier in the sense that only a single digits 
		// need be considered. The result must be positive.

		oteR = LargeInteger::NewWithLimbs(1);
	}

	LargeInteger* liR = oteR->m_location;
	liR->m_digits[0] = liA->m_digits[0] & DWORD(mask);

	// The result MUST have the correct sign, because if both negative then
	// sign bit will be set in both, and hence in the result. OR if 
	// A is positive, it didn't have it sign bit set, hence the result
	// cannot have its sign bit set. OR if B is positive then it cannot
	// have its sign bit set, and hence the result cannot either.

	#ifdef _DEBUG
	{
		int aSignBit = liA->signBit(oteA);
		int bSignBit = signBitOf(mask);
		int rSignBit = liR->signBit(oteR);
		ASSERT((aSignBit & bSignBit) == rSignBit);
	}
	#endif

	// Made immutable when normalized late
	//oteR->beImmutable();
	return reinterpret_cast<Oop>(oteR);
}


///////////////////////////////////////////////////////////////////////////////
// liBitOr - LargeInteger #bitOr:
//
//	Answer the result of a bitwise OR between two large integers.
//	The result may require normalization
//
//	This is really pretty easy (and fast) to do, because we are using two's complement
//	notation.

Oop __stdcall liBitOr(LargeIntegerOTE* oteA, LargeIntegerOTE* oteB)
{
	const MWORD aSize = oteA->getWordSize();
	const MWORD bSize = oteB->getWordSize();

	// The algorithm is simpler if we know A is always the longer
	if (aSize < bSize)
		return liBitOr(oteB, oteA);

	LargeInteger* liA = oteA->m_location;
	LargeInteger* liB = oteB->m_location;

	LargeIntegerOTE* oteR = LargeInteger::NewWithLimbs(aSize);
	LargeInteger* liR = oteR->m_location;

	// Treatment of digits of A (always longer) above size of B
	// differs according to sign of B
	if (SDWORD(liB->m_digits[bSize-1]) < 0)
	{
		// bitOr with shorter negative number
		// The answer must be negative
		// All the digits above the size of B will be -1
		// (anything bitOr'd with 2's complement -1 is -1).
		for (unsigned i=bSize;i<aSize;i++)
			liR->m_digits[i] = DWORD(-1);
	}
	else
	{
		// bitOr with shorter positive number
		// Just copy across the digits from A
		for (unsigned i=bSize;i<aSize;i++)
			liR->m_digits[i] = liA->m_digits[i];
	}

	for (unsigned i=0;i<bSize;i++)
		liR->m_digits[i] = liA->m_digits[i] | liB->m_digits[i];

	// Debug check the result has the correct sign
	#ifdef _DEBUG
	{
		int aSignBit = liA->signBit(oteA);
		int bSignBit = liB->signBit(oteB);
		int rSignBit = liR->signBit(oteR);
		ASSERT((aSignBit | bSignBit) == rSignBit);
	}
	#endif

	// Made immutable when normalized late
	//oteR->beImmutable();
	return Oop(oteR);
}

// Optimized version for common case of multi-precision receiver and single-precision
// mask.
Oop __stdcall liBitOrSingle(LargeIntegerOTE* oteA, SMALLINTEGER mask)
{
	LargeInteger* liA = oteA->m_location;
	const MWORD aSize = oteA->getWordSize();
	ASSERT(aSize >= 1);

	LargeIntegerOTE* oteR = LargeInteger::NewWithLimbs(aSize);
	LargeInteger* liR = oteR->m_location;
	if (mask < 0)
	{
		// bitOr with single-precision negative number
		// All high digits must be -1 (anything bitOr'd
		// with -1 is -1).
		for (unsigned i=1;i<aSize;i++)
			liR->m_digits[i] = DWORD(-1);
	}
	else
	{
		// bitOr with single-precision positive number
		// Copy across digits other than the first from A
		for (unsigned i=1;i<aSize;i++)
			liR->m_digits[i] = liA->m_digits[i];
	}

	liR->m_digits[0] = liA->m_digits[0] | DWORD(mask);

	// Debug check the result has the correct sign
	#ifdef _DEBUG
	{
		int aSignBit = liA->signBit(oteA);
		int bSignBit = signBitOf(mask);
		int rSignBit = liR->signBit(oteR);
		ASSERT((aSignBit | bSignBit) == rSignBit);
	}
	#endif

	// Made immutable when normalized late
	//oteR->beImmutable();
	return Oop(oteR);
}


///////////////////////////////////////////////////////////////////////////////
// liBitXor - LargeInteger #bitXor:
//
//	Answer the result of a bitwise XOR between two large integers.
//	The result may require normalization
//
//	This is really pretty easy (and fast) to do, because we are using two's complement
//	notation.

Oop __stdcall liBitXor(LargeIntegerOTE* oteA, LargeIntegerOTE* oteB)
{
	const MWORD aSize = oteA->getWordSize();
	const MWORD bSize = oteB->getWordSize();

	// The algorithm is simpler if we know A is always the longer
	if (aSize < bSize)
		return liBitXor(oteB, oteA);

	LargeInteger* liA = oteA->m_location;
	LargeInteger* liB = oteB->m_location;

	LargeIntegerOTE* oteR = LargeInteger::NewWithLimbs(aSize);
	LargeInteger* liR = oteR->m_location;

	// Treatment of digits of A (always longer) above size of B
	// differs according to sign of B
	if (SDWORD(liB->m_digits[bSize-1]) < 0)
	{
		// bitXor with shorter negative number
		for (unsigned i=bSize;i<aSize;i++)
			liR->m_digits[i] = liA->m_digits[i] ^ DWORD(-1);
	}
	else
	{
		// bitXor with shorter positive number
		// Just copy across the digits from A
		for (unsigned i=bSize;i<aSize;i++)
			liR->m_digits[i] = liA->m_digits[i];
	}

	for (unsigned i=0;i<bSize;i++)
		liR->m_digits[i] = liA->m_digits[i] ^ liB->m_digits[i];

	// Debug check the result has the correct sign
	#ifdef _DEBUG
	{
		int aSignBit = liA->signBit(oteA);
		int bSignBit = liB->signBit(oteB);
		int rSignBit = liR->signBit(oteR);
		ASSERT((aSignBit ^ bSignBit) == rSignBit);
	}
	#endif

	// Made immutable when normalized late
	//oteR->beImmutable();
	return Oop(oteR);
}

// Optimized version for common case of multi-precision receiver and single-precision
// mask.
Oop __stdcall liBitXorSingle(LargeIntegerOTE* oteA, SMALLINTEGER mask)
{
	LargeInteger* liA = oteA->m_location;
	const MWORD aSize = oteA->getWordSize();
	ASSERT(aSize >= 1);

	LargeIntegerOTE* oteR = LargeInteger::NewWithLimbs(aSize);
	LargeInteger* liR = oteR->m_location;
	if (mask < 0)
	{
		// bitXor with single-precision negative number
		for (unsigned i=1;i<aSize;i++)
			liR->m_digits[i] = liA->m_digits[i] ^ DWORD(-1);
	}
	else
	{
		// bitXor with single-precision positive number
		// Copy across digits other than the first from A
		for (unsigned i=1;i<aSize;i++)
			liR->m_digits[i] = liA->m_digits[i];
	}

	liR->m_digits[0] = liA->m_digits[0] ^ DWORD(mask);

	// Debug check the result has the correct sign
	#ifdef _DEBUG
	{
		int aSignBit = liA->signBit(oteA);
		int bSignBit = signBitOf(mask);
		int rSignBit = liR->signBit(oteR);
		ASSERT((aSignBit ^ bSignBit) == rSignBit);
	}
	#endif

	// Made immutable when normalized late
	//oteR->beImmutable();
	return Oop(oteR);
}


///////////////////////////////////////////////////////////////////////////////
//	Compare two large integers, answering 
//	-ve for a < b, 0 for a = b, +ve for a > b

__int64 __stdcall liCmp(LargeIntegerOTE* oteA, LargeIntegerOTE* oteB)
{
	LargeInteger* liA = oteA->m_location;
	LargeInteger* liB = oteB->m_location;

	const int aSign = liA->sign(oteA);
	const int bSign = liB->sign(oteB);

	__int64 cmp;

	if (aSign != bSign)
		cmp = aSign - bSign;
	else
	{
		// Same sign
		const MWORD aSize = oteA->getWordSize();
		const MWORD bSize = oteB->getWordSize();
		if (aSize == bSize)
		{
			cmp = 0;
			// Same size, need to compare words
			for (int i=aSize-1;i>=0;i--)
			{
				const DWORD digA = liA->m_digits[i];
				const DWORD digB = liB->m_digits[i];
				cmp = __int64(digA) - digB;
				if (cmp)
					break;
			}
		}
		else
		{
			// Different sizes, can compare based on length
			cmp = (int(aSize) - int(bSize)) * aSign;
		}
	}

	return cmp;
}


/******************************************************************************
*
*	LargeInteger arithmetic primitives
*
******************************************************************************/

#ifndef _M_IX86
	BOOL __fastcall Interpreter::primitiveLargeIntegerNormalize()
	{
		Oop* sp = m_registers.m_stackPointer;
		*sp = liNormalize(reinterpret_cast<LargeIntegerOTE*>(*sp));
		return TRUE;
	}

	BOOL __fastcall Interpreter::primitiveLargeIntegerAdd()
	{
		Oop oopOperand = stackTop();
		
		LargeIntegerOTE* oteReceiver = reinterpret_cast<LargeIntegerOTE*>(stackValue(1));
		LargeIntegerOTE* oteSum;

		if (ObjectMemoryIsIntegerObject(oopOperand))
		{
			popStack();
			
			const SMALLINTEGER operand = ObjectMemoryIntegerValueOf(oopOperand);
			oteSum = liAddSingle(oteReceiver, operand);
		}
		else
		{
			LargeIntegerOTE* oteOperand = reinterpret_cast<LargeIntegerOTE*>(oopOperand);
			if (oteOperand->m_oteClass != Pointers.ClassLargeInteger)
				return FALSE;		// Argument not an integer

			oteSum = liAdd(oteReceiver, oteOperand);

			popObjectAndNil();
		}

		// May need to reduce if, say, added negative to positive
		return replaceStackTopWithNew(normalizeIntermediateResult(oteSum));
	}

	// NOTE: This is a direct copy of the Add routine with the addition ops 
	// changed to subtraction ops. It therefore inherits the inefficient loop
	// of the add routine (which needs to be unwound to consider the common part
	// up to the sign digit of the shorter of the two numbers, then the sign of
	// the shorter of the two numbers, then the rest of the larger of the two numbers
	// and finally the sign of the larger of the two numbers. An additional
	// complication arises where the numbers are the same size to handle the pair
	// of sign digits. At the moment I don't consider it worth making these optimisations
	// because the speed-up is so enormous, and even without it, I still think this will
	// be quicker than competing Smalltalks because of the use of signed 32-bit arithmetic
	// instead of unsigned 8-bit arithmetic.

	BOOL __fastcall Interpreter::primitiveLargeIntegerSub()
	{
		Oop oopOperand = stackTop();
		
		LargeIntegerOTE* oteReceiver = reinterpret_cast<LargeIntegerOTE*>(stackValue(1));
		LargeIntegerOTE* oteDifference;

		if (ObjectMemoryIsIntegerObject(oopOperand))
		{
			popStack();
			const SMALLINTEGER operand = ObjectMemoryIntegerValueOf(oopOperand);
			oteDifference = liSubSingle(oteReceiver, operand);
		}
		else
		{
			LargeIntegerOTE* oteOperand = reinterpret_cast<LargeIntegerOTE*>(oopOperand);
			if (oteOperand->m_oteClass != Pointers.ClassLargeInteger)
				return FALSE;		// Argument not an integer

			oteDifference = liSub(oteReceiver, oteOperand);
			popObjectAndNil();
		}

		return replaceStackTopWithNew(normalizeIntermediateResult(oteDifference));
	}

	BOOL __fastcall Interpreter::primitiveLargeIntegerMul()
	{
		Oop oopMultiplier = stackTop();
		LargeIntegerOTE* oteMultiplicand = reinterpret_cast<LargeIntegerOTE*>(stackValue(1));
		Oop oopProduct;

		if (ObjectMemoryIsIntegerObject(oopMultiplier))
		{
			const SMALLINTEGER multiplier = ObjectMemoryIntegerValueOf(oopMultiplier);
			popStack();
			oopProduct = multiplier == 0 ? SMALLINTZERO : liMulSingle(oteMultiplicand, multiplier);
		}
		else
		{
			LargeIntegerOTE* oteMultiplier = reinterpret_cast<LargeIntegerOTE*>(oopMultiplier);
			if (oteMultiplier->m_oteClass != Pointers.ClassLargeInteger)
				return FALSE;		// Argument not an integer
			
			oopProduct = Oop(liMul(oteMultiplicand, oteMultiplier));
			popObjectAndNil();	// Pop the argument
		}

		replaceStackTopWithNew(normalizeIntermediateResult(oopProduct));
	}
#endif


TODO("Make this routine work - suffers overflow problems at present")
/*
// Private - Answer the result of multiplying the receiver by the argument, anInteger
static LargeIntegerOTE* liMul32(DWORD *const outer, MWORD outerSize, DWORD *const inner, MWORD innerSize)
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
		LONGLONG outerDigit = i==outerSize-1 ? LONGLONG(SDWORD(outer[i])) : outer[i];
		if (outerDigit)
		{
			k = i;
			for (MWORD j=0;j<innerSize;j++)
			{
				LONGLONG innerDigit = j==innerSize-1 ? LONGLONG(SDWORD(inner[j])) : inner[j];
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
	if ((SDWORD(outer[outerSize-1]) < 0) !=
		(SDWORD(inner[innerSize-1]) < 0))
	{
		// Result is negative
		for (MWORD i=k;i<productSize;i++)
			product->m_digits[i] = -1;
	}

	return productPointer;
}
*/

// N.B. Only produces a result if division is exact
BOOL __fastcall Interpreter::primitiveLargeIntegerDivide()
{
	Oop oopV = stackTop();
	LargeIntegerOTE* oteU = reinterpret_cast<LargeIntegerOTE*>(stackValue(1));
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
			return FALSE;
		}
	}

	BOOL bRet;
	Oop rem = normalizeIntermediateResult(quoAndRem.rem);
	if (rem == ZeroPointer)
	{
		// Divided exactly, so we can succeed by pushing the normalized quotient
		popStack();
		replaceStackTopWithNew(normalizeIntermediateResult(quoAndRem.quo));
		bRet = TRUE;
	}
	else
	{
		// Must fail because the division was inexact. Smalltalk backup code
		// will create a fraction
		deallocateIntermediateResult(rem);
		deallocateIntermediateResult(quoAndRem.quo);
		bRet = FALSE;
	}

	//CHECKREFERENCES
	return bRet;
}


BOOL __fastcall Interpreter::primitiveLargeIntegerMod()
{
	return FALSE;
}		

// This primitiveLargeInteger (associated with integer division selector //) does work when
// division is not exact (so this is the same as primitiveLargeIntegerDivide, but without check
// for exact division). Note that in Smalltalk integer divide truncates towards
// negative infinity, not zero
BOOL __fastcall Interpreter::primitiveLargeIntegerDiv()
{
	return FALSE;
}		

// Integer division with truncation towards zero
BOOL __fastcall Interpreter::primitiveLargeIntegerQuoAndRem()
{
	Oop oopV = stackTop();
	LargeIntegerOTE* oteU = reinterpret_cast<LargeIntegerOTE*>(stackValue(1));
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
			return FALSE;		// Divisor not an Integer

		quoAndRem = liDiv(oteU, oteV);
	}

	popStack();

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
		
	replaceStackTopWithNew(reinterpret_cast<POTE>(liNewArray2(quo, rem)));
	//CHECKREFERENCES
	return TRUE;
}		


///////////////////////////////////////////////////////////////////////////////
// Compare macro to generate relational ops (all the same layout)

#define LICOMPARE(X) \
	Oop* sp = m_registers.m_stackPointer;\
	Oop argPointer = *sp;\
	LargeIntegerOTE* oteReceiver = reinterpret_cast<LargeIntegerOTE*>(*(sp-1));\
\
	if (ObjectMemoryIsIntegerObject(argPointer))\
	{\
		/* SmallInteger argument, which is lesser depends on sign of receiver*/\
		/* and arg only since LargeIntegers are always normalized*/\
		LargeInteger* receiver = oteReceiver->m_location;\
		int cmp = receiver->sign(oteReceiver);\
		*(sp-1) = reinterpret_cast<Oop>(cmp X 0 ? Pointers.True : Pointers.False);\
	}\
	else\
	{\
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(argPointer);\
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)\
		{\
			__int64 cmp = liCmp(oteReceiver, oteArg);\
			*(sp-1) = reinterpret_cast<Oop>(cmp X 0 ? Pointers.True : Pointers.False);\
		}\
		else\
			return FALSE;	/* Arg not an integer, fall back on Smalltalk code*/\
	}\
	return sizeof(Oop);	// Pop one Oop


///////////////////////////////////////////////////////////////////////////////
//	Relational operator primitives for LargeIntegers
//
//	Note that these don't pop the stack, but return the number of bytes to pop

BOOL __fastcall Interpreter::primitiveLargeIntegerLessThan()
{
	LICOMPARE(<)
}

BOOL __fastcall Interpreter::primitiveLargeIntegerGreaterThan()
{
	LICOMPARE(>)
}

BOOL __fastcall Interpreter::primitiveLargeIntegerLessOrEqual()
{
	LICOMPARE(<=)
}

BOOL __fastcall Interpreter::primitiveLargeIntegerGreaterOrEqual()
{
	LICOMPARE(>=)
}

BOOL __fastcall Interpreter::primitiveLargeIntegerEqual()
{
	// We Implement this specially, because the generic comparison macro does more work than necessary
	Oop* sp = m_registers.m_stackPointer;
	Oop argPointer = *sp;

	if (ObjectMemoryIsIntegerObject(argPointer))
	{
		// SmallInteger cannot be equal to a normalized large integer
		*(sp-1) = reinterpret_cast<Oop>(Pointers.False);
	}
	else
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(argPointer);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			LargeIntegerOTE* oteReceiver = reinterpret_cast<LargeIntegerOTE*>(*(sp-1));
			__int64 cmp = liCmp(oteReceiver, oteArg);
			*(sp-1) = reinterpret_cast<Oop>(cmp == 0 ? Pointers.True : Pointers.False);
		}
		else
			return FALSE;	/* Arg not an integer, fall back on Smalltalk code*/
	}
	
	return sizeof(Oop);	// Pop one Oop
}



///////////////////////////////////////////////////////////////////////////////
//	Bit manipulation primitives for LargeIntegers


#ifndef _M_IX86
	BOOL __fastcall Interpreter::primitiveLargeIntegerBitAnd()
	{
		return FALSE;
	}

	BOOL __fastcall Interpreter::primitiveLargeIntegerBitOr()
	{
		return FALSE;
	}

	BOOL __fastcall Interpreter::primitiveLargeIntegerBitXor()
	{
		return FALSE;
	}
#endif

///////////////////////////////////////////////////////////////////////////////
//	Bit shifting 

BOOL __fastcall Interpreter::primitiveLargeIntegerBitShift()
{
	Oop argPointer = stackTop();
	if (ObjectMemoryIsIntegerObject(argPointer))
	{
		SMALLINTEGER shift = ObjectMemoryIntegerValueOf(argPointer);
		popStack();
		LargeIntegerOTE* oteReceiver = reinterpret_cast<LargeIntegerOTE*>(stackTop());

		if (shift < 0)
		{
			// Right shift
			// Note that liRightShift() may answer SmallInteger.
			Oop oopShifted = liRightShift(oteReceiver, -shift);
			replaceStackTopWithNew(normalizeIntermediateResult(oopShifted));
		}
		else
		{
			if (shift > 0)
			{
				// Left shift - can't possibly answer SmallInteger
				LargeIntegerOTE* oteShifted = liLeftShift(oteReceiver, shift);
				replaceStackTopWithNew(normalizeIntermediateResult(oteShifted));
			}
			// else, shift == 0, drop through to answer receiver
		}
		//CHECKREFERENCES
		return TRUE;
	}
	else
	{
		// shift MUST be a SmallInteger
		OTE* oteArg = reinterpret_cast<OTE*>(argPointer);
		return primitiveFailureWith(PrimitiveFailureNonInteger, oteArg);
	}
}

BOOL __fastcall Interpreter::primitiveLargeIntegerAsFloat()
{
	LargeIntegerOTE** sp = (LargeIntegerOTE**)m_registers.m_stackPointer;
	LargeIntegerOTE* oteReceiver = *(sp);
	LargeInteger* liReceiver = oteReceiver->m_location;
	const MWORD size = oteReceiver->getWordSize();
	if (size <= 2)
	{
		double fValue;
		if (size <= 1)
			fValue = *reinterpret_cast<SDWORD*>(liReceiver->m_digits);
		else
			fValue = static_cast<double>(*reinterpret_cast<__int64*>(liReceiver->m_digits));

		FloatOTE* oteNew = Float::New(fValue);
		return replaceStackTopWithNew(reinterpret_cast<POTE>(oteNew));
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