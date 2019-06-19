#include "Ist.h"

#ifndef _DEBUG
#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

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
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
	else
	{
		Oop receiver = *(sp - 1);
		// We can perform the comparisons without shifting away the SmallInteger bit since it always 1
		*(sp - 1) = reinterpret_cast<Oop>(receiver == arg ? Pointers.True : Pointers.False);
		return sp - 1;
	}
}

Oop* __fastcall Interpreter::primitiveHashMultiply(Oop* const sp, unsigned)
{
	Oop arg = *sp;
	if (ObjectMemoryIsIntegerObject(arg))
	{
		uint32_t seed = static_cast<uint32_t>(ObjectMemoryIntegerValueOf(arg));
		uint32_t hash = (seed * 48271) & MaxSmallInteger;
		*sp = ObjectMemoryIntegerObjectOf(hash);
		return sp;
	}
	else
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(arg);
		uint32_t seed = oteArg->m_location->m_digits[0];
		uint32_t hash = (seed * 48271) & MaxSmallInteger;
		*sp = ObjectMemoryIntegerObjectOf(hash);
		return sp;
	}
}

//////////////////////////////////////////////////////////////////////////////;
// SmallInteger Bit Manipulation Primitives

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
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);		// Unhandled argument type
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
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Unhandled argument type
	}
}

Oop* __fastcall Interpreter::primitiveLowBit(Oop* const sp, unsigned)
{
	SMALLINTEGER value = *(sp) ^ 1;
	unsigned long index;
	_BitScanForward(&index, value);
	*sp = ObjectMemoryIntegerObjectOf(index);
	return sp;
}

Oop* __fastcall Interpreter::primitiveHighBit(Oop* const sp, unsigned)
{
	Oop oopInteger = *sp;
	SMALLINTEGER value = static_cast<SMALLINTEGER>(oopInteger);
	if (value >= 0)
	{
		unsigned long index;
		_BitScanReverse(&index, value);
		*sp = ObjectMemoryIntegerObjectOf(index);
		return sp;
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::NotSupported);		// Negative receiver
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
			SMALLINTEGER r = ObjectMemoryIntegerValueOf(receiver);
			if (r != 0)
			{
				LargeIntegerOTE* oteResult = LargeInteger::Add(oteArg, r);
				// Normalize and return
				Oop oopResult = LargeInteger::NormalizeIntermediateResult(oteResult);
				*(sp - 1) = oopResult;
				ObjectMemory::AddToZct(oopResult);
				return sp - 1;
			}
			else
			{
				*(sp - 1) = reinterpret_cast<Oop>(oteArg);
				return sp - 1;
			}
		}
		else if (oteArg->m_oteClass == Pointers.ClassFloat)
		{
			double floatA = reinterpret_cast<FloatOTE*>(oteArg)->m_location->m_fValue;
			double floatR = ObjectMemoryIntegerValueOf(receiver);
			FloatOTE* oteResult = Float::New(floatR + floatA);
			*(sp - 1) = reinterpret_cast<Oop>(oteResult);
			ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteResult));
			return sp - 1;
		}
		else
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Unhandled argument type
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

Oop* __fastcall Interpreter::primitiveSubtract(Oop* const sp, unsigned)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		OTE* oteArg = reinterpret_cast<OTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			Oop oopNegatedArg = LargeInteger::Negate(reinterpret_cast<LargeIntegerOTE*>(oteArg));
			if (ObjectMemoryIsIntegerObject(oopNegatedArg))
			{
				SMALLINTEGER a = ObjectMemoryIntegerValueOf(oopNegatedArg);
				SMALLINTEGER r = ObjectMemoryIntegerValueOf(receiver);
				SMALLINTEGER result = a + r;

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
			else
			{
				SMALLINTEGER r = ObjectMemoryIntegerValueOf(receiver);
				if (r != 0)
				{
					LargeIntegerOTE* oteNegatedArg = reinterpret_cast<LargeIntegerOTE*>(oopNegatedArg);
					LargeIntegerOTE* oteResult = LargeInteger::Add(oteNegatedArg, r);
					LargeInteger::DeallocateIntermediateResult(oteNegatedArg);
					// Normalize and return
					Oop oopResult = LargeInteger::NormalizeIntermediateResult(oteResult);
					*(sp - 1) = oopResult;
					ObjectMemory::AddToZct(oopResult);
					return sp - 1;
				}
				else
				{	
					// Receiver is zero, so result is arg negated - we know this is an LI
					*(sp - 1) = oopNegatedArg;
					ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oopNegatedArg));
					return sp - 1;
				}
			}
		}
		else if (oteArg->m_oteClass == Pointers.ClassFloat)
		{
			double floatA = reinterpret_cast<FloatOTE*>(oteArg)->m_location->m_fValue;
			double floatR = ObjectMemoryIntegerValueOf(receiver);
			FloatOTE* oteResult = Float::New(floatR - floatA);
			*(sp - 1) = reinterpret_cast<Oop>(oteResult);
			ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteResult));
			return sp - 1;
		}
		else
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Unhandled argument type
	}
	else
	{
		// We can do this more efficiently in assembler because we can access the overflow flag safely and efficiently
		// However this doesn't matter much because this code path is only ever used when #perform'ing SmallInteger>>+
		// Usually SmallInteger addition is performed inline in the bytecode interpreter

		SMALLINTEGER r = ObjectMemoryIntegerValueOf(receiver);
		SMALLINTEGER a = ObjectMemoryIntegerValueOf(arg);
		SMALLINTEGER result = r - a;

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
			SMALLINTEGER r = ObjectMemoryIntegerValueOf(receiver);
			if (r != 0)
			{
				Oop oopResult = LargeInteger::Mul(oteArg, r);
				// Normalize and return
				*(sp - 1) = normalizeIntermediateResult(oopResult);
				ObjectMemory::AddToZct(oopResult);
				return sp - 1;
			}
			else
			{
				*(sp - 1) = ZeroPointer;
				return sp - 1;
			}
		}
		else if (oteArg->m_oteClass == Pointers.ClassFloat)
		{
			double floatA = reinterpret_cast<FloatOTE*>(oteArg)->m_location->m_fValue;
			double floatR = ObjectMemoryIntegerValueOf(receiver);
			FloatOTE* oteResult = Float::New(floatR * floatA);
			*(sp - 1) = reinterpret_cast<Oop>(oteResult);
			ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteResult));
			return sp - 1;
		}
		else
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
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

Oop* __fastcall Interpreter::primitiveDivide(Oop* const sp, unsigned)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			// Dividing a SmallInteger by a large on. The primitive can only succeed in a couple of boundary cases
			// 1. The receiver is zero. Zero divided by anything is zero.
			// 2. The receiver is the largest negative SmallInteger, and the argument is its absolute value, result is -1
			if (receiver == ZeroPointer)
			{
				*(sp - 1) = ZeroPointer;
				return sp - 1;
			}
			else if (receiver == ObjectMemoryIntegerObjectOf(MinSmallInteger) && oteArg->getWordSize() == 1 && oteArg->m_location->m_digits[0] == (MinSmallInteger*-1))
			{
				*(sp - 1) = MinusOnePointer;
				return sp - 1;
			}
			// else any other large integer divisor must result in a fractional value
		}
		else if (oteArg->m_oteClass == Pointers.ClassFloat)
		{
			double floatA = reinterpret_cast<FloatOTE*>(oteArg)->m_location->m_fValue;
			// To avoid generating a second ZeroDivide exception if the first is resumed, we detect and fail on division-by-zero here
			if (floatA != 0)
			{
				double floatR = ObjectMemoryIntegerValueOf(receiver);
				FloatOTE* oteResult = Float::New(floatR / floatA);
				*(sp - 1) = reinterpret_cast<Oop>(oteResult);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteResult));
				return sp - 1;
			}
			else
				return primitiveFailure(_PrimitiveFailureCode::FloatDivideByZero);		// FP divide by zero
		}
		else
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);		// Unhandled argument type
	}
	else
	{
		// We can do this more efficiently in assembler because we can access the overflow flag safely and efficiently
		// However this doesn't matter to much because this code path is used when #perform'ing SmallInteger>>/, or 
		// when attempted division was inexact

		SMALLINTEGER r = ObjectMemoryIntegerValueOf(receiver);
		SMALLINTEGER a = ObjectMemoryIntegerValueOf(arg);
		// It seems that the VC++ compiler is finally (as of VS2017) able to recognise this sequence as requiring only a single division instruction, so this is better 
		// than calling a function written in inline assembler or the CRT DLL ldiv function.
		SMALLINTEGER quot = r / a;
		SMALLINTEGER rem = r % a;

		if (rem == 0)
		{
			if (ObjectMemoryIsIntegerValue(quot))
			{
				*(sp - 1) = ObjectMemoryIntegerObjectOf(quot);
				return sp - 1;
			}
			else
			{
				LargeIntegerOTE* oteResult = LargeInteger::liNewSigned(quot);
				*(sp - 1) = reinterpret_cast<Oop>(oteResult);
				ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteResult));
				return sp - 1;
			}
		}
	}

	return primitiveFailure(_PrimitiveFailureCode::Unsuccessful);		// Does not divide exactly
}

Oop* __fastcall Interpreter::primitiveSmallIntegerPrintString(Oop* const sp, unsigned)
{
	Oop integerPointer = *sp;

#ifdef _WIN64
	char buffer[32];
	errno_t err = _i64toa_s(ObjectMemoryIntegerValueOf(integerPointer), buffer, sizeof(buffer), 10);
#else
	char buffer[16];
	errno_t err = _itoa_s(ObjectMemoryIntegerValueOf(integerPointer), buffer, sizeof(buffer), 10);
#endif
	if (err == 0)
	{
		auto oteResult = AnsiString::New(buffer);
		*sp = reinterpret_cast<Oop>(oteResult);
		ObjectMemory::AddToZct((OTE*)oteResult);
		return sp;
	}
	else
		return primitiveFailure(_PrimitiveFailureCode::Failed);
}

Oop* __fastcall Interpreter::primitiveSmallIntegerAt(Oop* const sp, unsigned)
{
	Oop oopIndex = *sp;
	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		SMALLINTEGER index = ObjectMemoryIntegerValueOf(oopIndex);

		SMALLINTEGER value = abs(ObjectMemoryIntegerValueOf(*(sp - 1)));
		if (index > 0 && index <= 4)
		{
			uint8_t byte = value >> (index - 1) * 8;
			*(sp - 1) = ObjectMemoryIntegerObjectOf(byte);
			return sp - 1;
		}
		else
		{
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
		}
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}