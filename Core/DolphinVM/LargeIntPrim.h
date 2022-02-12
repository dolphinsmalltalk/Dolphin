#include "Interprt.h"
#pragma once

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
