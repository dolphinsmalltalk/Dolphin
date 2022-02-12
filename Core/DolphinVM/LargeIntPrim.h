#include "Interprt.h"
#pragma once

// Template for operations where the result is zero if the argument is SmallInteger zero
template <class Op, class OpSingle> static Oop* PRIMCALL Interpreter::primitiveLargeIntegerOpZ(Oop* const sp, primargcount_t argc)
{
	Oop oopArg = *sp;
	const LargeIntegerOTE* oteReceiver = reinterpret_cast<const LargeIntegerOTE*>(*(sp - 1));
	Oop result;

	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SmallInteger arg = ObjectMemoryIntegerValueOf(oopArg);
		if (arg != 0)
		{
			result = OpSingle()(oteReceiver, arg);
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
			result = Op()(oteReceiver, oteArg);
		}
		else
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}

	// Normalize and return
	result = normalizeIntermediateResult(result);
	*(sp - 1) =  result;
	ObjectMemory::AddOopToZct(result);

	return sp - 1;
}

//	Template for operations for which the result is the receiver if the operand is SmallInteger zero
template <class Op, class OpSingle> static Oop* PRIMCALL Interpreter::primitiveLargeIntegerOpR(Oop* const sp, primargcount_t)
{
	Oop oopArg = *sp;
	const LargeIntegerOTE* oteReceiver = reinterpret_cast<const LargeIntegerOTE*>(*(sp - 1));

	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SmallInteger arg = ObjectMemoryIntegerValueOf(oopArg);
		if (arg != 0)
		{
			auto result = OpSingle()(oteReceiver, arg);
			// Normalize and return
			Oop oopResult = LargeInteger::NormalizeIntermediateResult(result);
			*(sp - 1) = oopResult;
			ObjectMemory::AddOopToZct(oopResult);
			return sp - 1;
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
			auto result = Op()(oteReceiver, oteArg);
			// Normalize and return
			Oop oopResult = LargeInteger::NormalizeIntermediateResult(result);
			*(sp - 1) = oopResult;
			ObjectMemory::AddOopToZct(oopResult);
			return sp - 1;
		}
		else
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Compare template to generate relational ops (all the same layout)

//////////////////////////////////////////////////////////////////////////////
//	Compare two large integers, answering 
//	-ve for a < b, 0 for a = b, +ve for a > b

template <bool Lt, bool Eq> static bool liCmp(const LargeIntegerOTE* oteA, const LargeIntegerOTE* oteB)
{
	const LargeInteger* liA = oteA->m_location;
	const LargeInteger* liB = oteB->m_location;

	const auto aSign = liA->sign(oteA);
	const auto bSign = liB->sign(oteB);

	// Compiler will optimize this to one comparison, and two conditional jumps
	if (aSign < bSign)
		return Lt;
	if (aSign > bSign)
		return !Lt;

	// Same sign

	const auto ai = oteA->getWordSize();
	const auto bi = oteB->getWordSize();

	if (ai == bi)
	{
		ptrdiff_t i = ai - 1;
		// Same sign and size: Compare words (same sign, so comparison can be unsigned)
		do
		{
			const auto digitA = liA->m_digits[i];
			const auto digitB = liB->m_digits[i];
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
		return ((static_cast<ptrdiff_t>(ai) - static_cast<ptrdiff_t>(bi)) * aSign) < 0 ? Lt : !Lt;
	}
}

template <bool Lt, bool Eq> static Oop* PRIMCALL Interpreter::primitiveLargeIntegerCmp(Oop* const sp, primargcount_t)
{
	Oop argPointer = *sp;
	LargeIntegerOTE* oteReceiver = reinterpret_cast<LargeIntegerOTE*>(*(sp - 1));

	if (ObjectMemoryIsIntegerObject(argPointer))
	{
		// SmallInteger argument, which is lesser depends on sign of receiver only because,
		// since LargeIntegers are always normalized, any negative LargeInteger must be less
		// than any SmallInteger, and any positive LargeInteger must be greater than any SmallInteger
		// SmallIntegers can never be equal to normalized large integers
		const auto sign = oteReceiver->m_location->signDigit(oteReceiver);
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
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	/* Arg not an integer, fall back on Smalltalk code*/
	}
}

template <typename Op> static Oop* PRIMCALL Interpreter::primitiveLargeIntegerUnaryOp(Oop* const sp, primargcount_t)
{
	Oop oopResult = Op()(reinterpret_cast<LargeIntegerOTE*>(*sp));
	*sp = oopResult;
	ObjectMemory::AddOopToZct(oopResult);
	return sp;
}

namespace Li
{
	struct Mul
	{
		Oop operator()(const LargeIntegerOTE* oteOuter, const LargeIntegerOTE* oteInner) const
		{
			const LargeInteger* liOuter = oteOuter->m_location;
			size_t outerSize = oteOuter->getWordSize();
			const LargeInteger* liInner = oteInner->m_location;
			size_t innerSize = oteInner->getWordSize();

			// The algorithm is substantially faster if the outer loop is shorter
			return outerSize > innerSize ? LargeInteger::Mul(liInner, innerSize, liOuter, outerSize) :
				LargeInteger::Mul(liOuter, outerSize, liInner, innerSize);
		}
	};

	struct MulSingle
	{
		__forceinline Oop operator()(const LargeIntegerOTE* oteInner, SmallInteger outerDigit) const
		{
			return LargeInteger::Mul(oteInner, outerDigit);
		}
	};

	struct AddSingle
	{
		__forceinline LargeIntegerOTE* operator()(const LargeIntegerOTE* oteLI, const SmallInteger operand) const
		{
			return LargeInteger::Add(oteLI, operand);
		}
	};

	struct Add
	{
		__forceinline LargeIntegerOTE* operator()(const LargeIntegerOTE* oteOp1, const LargeIntegerOTE* oteOp2) const
		{
			return LargeInteger::Add(oteOp1, oteOp2);
		}
	};

	struct SubSingle
	{
		__forceinline LargeIntegerOTE* operator()(const LargeIntegerOTE* oteLI, SmallInteger operand) const
		{
			return LargeInteger::Sub(oteLI, operand);
		}
	};

	struct Sub
	{
		__forceinline LargeIntegerOTE* operator()(const LargeIntegerOTE* oteLI, const LargeIntegerOTE* oteOperand) const
		{
			return LargeInteger::Sub(oteLI, oteOperand);
		}
	};

	struct BitAnd
	{
		__forceinline Oop operator()(const LargeIntegerOTE* oteA, const LargeIntegerOTE* oteB) const
		{
			return LargeInteger::BitAnd(oteA, oteB);
		}
	};

	struct BitAndSingle
	{
		__forceinline Oop operator()(const LargeIntegerOTE* oteA, SmallInteger mask) const
		{
			return LargeInteger::BitAnd(oteA, mask);
		}
	};

	struct BitOr
	{
		__forceinline LargeIntegerOTE* operator() (const LargeIntegerOTE* oteA, const LargeIntegerOTE* oteB) const
		{
			return LargeInteger::BitOr(oteA, oteB);
		}
	};


	// Optimized version for common case of multi-precision receiver and single-precision
	// mask.
	struct BitOrSingle
	{
		__forceinline LargeIntegerOTE* operator()(const LargeIntegerOTE* oteA, SmallInteger mask) const
		{
			return LargeInteger::BitOr(oteA, mask);
		}
	};

	struct BitXor
	{
		__forceinline LargeIntegerOTE* operator()(const LargeIntegerOTE* oteA, const LargeIntegerOTE* oteB) const
		{
			return LargeInteger::BitXor(oteA, oteB);
		}
	};

	// Optimized version for common case of multi-precision receiver and single-precision
	// mask.
	struct BitXorSingle
	{
		__forceinline LargeIntegerOTE* operator()(const LargeIntegerOTE* oteA, SmallInteger mask) const
		{
			return LargeInteger::BitXor(oteA, mask);

		}
	};

	struct Negate
	{
		__forceinline Oop operator()(const LargeIntegerOTE* oteLi)
		{
			return LargeInteger::Negate(oteLi);
		}
	};

	struct Normalize
	{
		__forceinline Oop operator()(LargeIntegerOTE* oteLi)
		{
			return LargeInteger::Normalize(oteLi);
		}
	};
};
