#include "Ist.h"

#ifndef _DEBUG
#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

template <class Cmp, bool Lt> __forceinline Oop* primitiveIntegerCmp(Oop* const sp, const Cmp& cmp)
{
	// Normally it is better to jump on the failure case as the static prediction is that forward
	// jumps are not taken, but these primitives are normally only invoked when the special bytecode 
	// has triggered the fallback method (unless performed), which suggests the arg will not be a 
	// SmallInteger, so the 99% case is that the primitive should fail
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			// Whether a SmallIntegers is greater than a LargeInteger depends on the sign of the LI
			// - All normalized negative LIs are less than all SmallIntegers
			// - All normalized positive LIs are greater than all SmallIntegers
			// So if sign bit of LI is not set, receiver is < arg
			*(sp - 1) = reinterpret_cast<Oop>((oteArg->m_location->signBit(oteArg) ? Lt : !Lt) ? Pointers.True : Pointers.False);
			return sp - 1;
		}
		else
			return nullptr;
	}
	else
	{
		Oop receiver = *(sp - 1);
		// We can perform the comparisons without shifting away the SmallInteger bit since it always 1
		*(sp - 1) = reinterpret_cast<Oop>(cmp(static_cast<SMALLINTEGER>(receiver), static_cast<SMALLINTEGER>(arg)) ? Pointers.True : Pointers.False);
		return sp - 1;
	}
}

Oop* __fastcall Interpreter::primitiveLessThan(Oop* const sp, unsigned)
{
	return primitiveIntegerCmp<std::less<SMALLINTEGER>, false>(sp, std::less<SMALLINTEGER>());
}

Oop* __fastcall Interpreter::primitiveLessOrEqual(Oop* const sp, unsigned)
{
	return primitiveIntegerCmp<std::less_equal<SMALLINTEGER>, false>(sp, std::less_equal<SMALLINTEGER>());
}

Oop* __fastcall Interpreter::primitiveGreaterThan(Oop* const sp, unsigned)
{
	return primitiveIntegerCmp<std::greater<SMALLINTEGER>, true>(sp, std::greater<SMALLINTEGER>());
}

Oop* __fastcall Interpreter::primitiveGreaterOrEqual(Oop* const sp, unsigned)
{
	return primitiveIntegerCmp<std::greater_equal<SMALLINTEGER>, true>(sp, std::greater_equal<SMALLINTEGER>());
}

Oop* __fastcall Interpreter::primitiveEqual(Oop* const sp, unsigned)
{
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		OTE* oteArg = reinterpret_cast<OTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			// LargeIntegers and Integers are never equal
			*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
			return sp - 1;
		}
		else
			return nullptr;
	}
	else
	{
		Oop receiver = *(sp - 1);
		// We can perform the comparisons without shifting away the SmallInteger bit since it always 1
		*(sp - 1) = reinterpret_cast<Oop>(receiver == arg ? Pointers.True : Pointers.False);
		return sp - 1;
	}
}

//////////////////////////////////////////////////////////////////////////////;
// SmallInteger Bit Manipulation Primitives

template <class P> __forceinline static Oop* primitiveIntegerOp(Oop* const sp, const P &op)
{
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
		return nullptr;

	Oop receiver = *(sp - 1);
	*(sp - 1) = op(receiver, arg);
	return sp - 1;
}

Oop* __fastcall Interpreter::primitiveBitAnd(Oop* const sp, unsigned)
{
	return primitiveIntegerOp(sp, std::bit_and<Oop>());
}

Oop* __fastcall Interpreter::primitiveBitOr(Oop* const sp, unsigned)
{
	return primitiveIntegerOp(sp, std::bit_or<Oop>());
}

Oop* __fastcall Interpreter::primitiveBitXor(Oop* const sp, unsigned)
{
	struct bit_xor {
		Oop operator() (const Oop& receiver, const Oop& arg) const {
			return receiver ^ (arg - 1);
		}
	};

	return primitiveIntegerOp(sp, bit_xor());
}

Oop* __fastcall Interpreter::primitiveAnyMask(Oop* const sp, unsigned)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;
	if (ObjectMemoryIsIntegerObject(arg))
	{
		// We can perform the comparisons without shifting away the SmallInteger bit since it always 1
		*(sp - 1) = reinterpret_cast<Oop>((receiver & arg) != ZeroPointer ? Pointers.True : Pointers.False);
		return sp - 1;
	}
	else
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			// If receiver -ve allMask could be true, depending on comparison with bottom limb
			// If receiver +ve, can never be true
			SMALLINTEGER r = ObjectMemoryIntegerValueOf(receiver);
			uint32_t* digits = oteArg->m_location->m_digits;
			if ((r & digits[0]) != 0)
			{
				// One or more bits are set in the first limb of the LI and in the SmallInteger
				*(sp - 1) = reinterpret_cast<Oop>(Pointers.True);
				return sp - 1;
			}
			else
			{
				if (r < 0)
				{
					for (MWORD i = oteArg->getWordSize()-1; i > 0; i--)
					{
						if (digits[i] != 0)
						{
							*(sp - 1) = reinterpret_cast<Oop>(Pointers.True);
							return sp - 1;
						}
					}
				}

				*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
				return sp - 1;
			}
		}
		else
			return nullptr;
	}
}

Oop* __fastcall Interpreter::primitiveAllMask(Oop* const sp, unsigned)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;
	if (ObjectMemoryIsIntegerObject(arg))
	{
		// We can perform the comparisons without shifting away the SmallInteger bit since it always 1
		*(sp - 1) = reinterpret_cast<Oop>((receiver & arg) == arg ? Pointers.True : Pointers.False);
		return sp - 1;
	}
	else
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			// If receiver -ve allMask could be true, depending on comparison with bottom limb
			// If receiver +ve, can never be true
			SMALLINTEGER r = ObjectMemoryIntegerValueOf(receiver);
			uint32_t argLow = oteArg->m_location->m_digits[0];
			*(sp - 1) = reinterpret_cast<Oop>(r < 0 && ((static_cast<uint32_t>(r) & argLow) == argLow) ? Pointers.True : Pointers.False);
			return sp - 1;
		}
		else
			return nullptr;
	}
}

Oop* __fastcall Interpreter::primitiveAdd(Oop* const sp, unsigned)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			LargeIntegerOTE* oteResult = LargeInteger::Add(oteArg, ObjectMemoryIntegerValueOf(receiver));
			// Normalize and return
			Oop oopResult = LargeInteger::NormalizeIntermediateResult(oteResult);
			*(sp - 1) = oopResult;
			ObjectMemory::AddToZct(oopResult);

			return sp - 1;
		}
		else
			return nullptr;
	}
	else
	{
		// We can do this more efficiently in assembler because we can access the overflow flag safely and efficiently
		// However this doesn't matter much because this code path is only ever used when #perform'ing SmallInteger>>+
		// Usually SmallInteger addition is performed inline in the bytecode interpreter

		SMALLINTEGER r = ObjectMemoryIntegerValueOf(receiver);
		SMALLINTEGER a = ObjectMemoryIntegerValueOf(arg);
		SMALLINTEGER result = r + a;

		if (ObjectMemoryIsIntegerValue(result))
		{
			*(sp - 1) = ObjectMemoryIntegerObjectOf(result);
			return sp - 1;
		}
		else
		{
			// Overflowed
			LargeIntegerOTE* oteResult = LargeInteger::liNewSigned(result);
			*(sp - 1) = reinterpret_cast<Oop>(oteResult);
			ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteResult));
			return sp - 1;
		}
	}
}

Oop* __fastcall Interpreter::primitiveMultiply(Oop* const sp, unsigned)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			Oop oopResult = LargeInteger::Mul(oteArg, ObjectMemoryIntegerValueOf(receiver));
			// Normalize and return
			*(sp - 1) = normalizeIntermediateResult(oopResult);
			ObjectMemory::AddToZct(oopResult);

			return sp - 1;
		}
		else
			return nullptr;
	}
	else
	{
		// We can do this more efficiently in assembler because we can access the overflow flag safely and efficiently
		// However this doesn't matter much because this code path is only ever used when #perform'ing SmallInteger>>*
		// Usually SmallInteger multiplication is performed inline in the bytecode interpreter

		SMALLINTEGER r = ObjectMemoryIntegerValueOf(receiver);
		SMALLINTEGER a = ObjectMemoryIntegerValueOf(arg);
		int64_t result = __emul(r, a);

		Oop oopResult = Integer::NewSigned64(result);
		*(sp - 1) = oopResult;
		ObjectMemory::AddToZct(oopResult);
		return sp - 1;
	}
}