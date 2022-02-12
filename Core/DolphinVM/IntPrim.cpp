#include "Ist.h"

#ifndef _DEBUG
#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"
#include "IntPrim.h"

Oop* PRIMCALL Interpreter::primitiveEqual(Oop* const sp, primargcount_t)
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

Oop* PRIMCALL Interpreter::primitiveHashMultiply(Oop* const sp, primargcount_t)
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

template <typename Cmp, bool Lt> static Oop* PRIMCALL Interpreter::primitiveIntegerCmp(Oop* const sp, primargcount_t)
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
			return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
	else
	{
		Oop receiver = *(sp - 1);
		// We can perform the comparisons without shifting away the SmallInteger bit since it always 1
		*(sp - 1) = reinterpret_cast<Oop>(Cmp()(static_cast<SmallInteger>(receiver), static_cast<SmallInteger>(arg)) ? Pointers.True : Pointers.False);
		return sp - 1;
	}
}

template Oop* PRIMCALL Interpreter::primitiveIntegerCmp<std::greater_equal<SmallInteger>, true>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIntegerCmp<std::less<SmallInteger>, false>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIntegerCmp<std::greater<SmallInteger>, true>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIntegerCmp<std::less_equal<SmallInteger>, false>(Oop* const, primargcount_t);

//////////////////////////////////////////////////////////////////////////////;
// SmallInteger Bit Manipulation Primitives

template <class Op> static Oop* PRIMCALL Interpreter::primitiveIntegerOp(Oop* const sp, primargcount_t)
{
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
		return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);

	Oop receiver = *(sp - 1);
	*(sp - 1) = Op()(receiver, arg);
	return sp - 1;
}

template Oop* PRIMCALL Interpreter::primitiveIntegerOp<std::bit_and<Oop>>(Oop* const sp, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIntegerOp<std::bit_or<Oop>>(Oop* const sp, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveIntegerOp<bit_xor>(Oop* const sp, primargcount_t);

Oop* PRIMCALL Interpreter::primitiveAnyMask(Oop* const sp, primargcount_t)
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
			SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
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
					for (size_t i = oteArg->getWordSize()-1; i > 0; i--)
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

Oop* PRIMCALL Interpreter::primitiveAllMask(Oop* const sp, primargcount_t)
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
			SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
			uint32_t argLow = oteArg->m_location->m_digits[0];
			*(sp - 1) = reinterpret_cast<Oop>(r < 0 && ((static_cast<uint32_t>(r) & argLow) == argLow) ? Pointers.True : Pointers.False);
			return sp - 1;
		}
		else
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Unhandled argument type
	}
}

Oop* PRIMCALL Interpreter::primitiveLowBit(Oop* const sp, primargcount_t)
{
	SmallInteger value = *(sp) ^ 1;
	unsigned long index;
	_BitScanForward(&index, value);
	*sp = ObjectMemoryIntegerObjectOf(index);
	return sp;
}

Oop* PRIMCALL Interpreter::primitiveHighBit(Oop* const sp, primargcount_t)
{
	Oop oopInteger = *sp;
	SmallInteger value = static_cast<SmallInteger>(oopInteger);
	if (value >= 0)
	{
		unsigned long index;
		_BitScanReverse(&index, value);
		*sp = ObjectMemoryIntegerObjectOf(index);
		return sp;
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::IntegerOutOfRange);		// Negative receiver
	}
}

#ifdef _M_IX86

__declspec(naked) Oop* PRIMCALL Interpreter::primitiveBitShift(Oop* const sp, primargcount_t)
{
	_asm
	{
		mov		eax, [esi - OOPSIZE]	// Access receiver at stack top
		mov		ecx, [esi]				// Load argument from stack
		mov		edx, eax				// Sign extend into edx from eax part 1
		sar		ecx, 1					// Access integer value
		jnc		invalidParameter1		// Not a SmallInteger, primitive failure
		js		rightShift				// If negative, perform right shift(simpler)

		// Perform a left shift(more tricky sadly because of overflow detection)

		sub		eax, 1					// Remove SmallInteger sign bit
		jz		zero					// If receiver is zero, then result always zero

		cmp		ecx, 30					// We can't shift more than 30 places this way, since receiver not zero
		jg		integerOverflow

		// To avoid using a loop, we use the double precision shift first
		// to detect potential overflow.
		// This overflow check works, but is slow(about 12 cycles)
		// since the majority of shifts are <= 16, perhaps should loop ?
		push 	ebx						// We must preserve EBX
		sar		edx, 31					// Sign extend part 2
		inc		ecx						// Need to check space for sign too
		mov		ebx, edx				// Save sign in ebx too
		shld	edx, eax, cl			// May overflow into edx
		dec		ecx
		xor		edx, ebx				// Overflowed ?
		pop		ebx
		jnz		integerOverflow			// Yes, LargeInteger needed

		sal		eax, cl					// No, perform the real shift

	zero:
		or		eax, 1					// Replace SmallInteger flag
		mov		[esi - OOPSIZE], eax	// Replace stack top integer
		lea		eax, [esi - OOPSIZE]
		ret

	invalidParameter1:
		mov		eax, 0xd00001df				// _PrimitiveFailureCode::InvalidParameter1
		ret

	integerOverflow:
		mov		eax, 0xd000012b				// _PrimitiveFailureCode::IntegerOverflow
		ret

	rightShift:

		neg		ecx							// Get shift as absolute value
		mov		edx, 31
		sub		esi, OOPSIZE				// Pop stack
		cmp		ecx, edx					// Will the shift remove all significant bits
		cmovg	ecx, edx		

		sar		eax, cl						// Perform the shift
		or		eax, 1						// Replace SmallInteger flag

		mov		[esi], eax					// Replace stack top integer
		mov		eax, esi
		ret
	}
}

#else
#error "primitiveBitShift not implemented for x64 yet"
#endif

//////////////////////////////////////////////////////////////////////////////;
// SmallInteger Arithmetic Primitives

Oop* PRIMCALL Interpreter::primitiveAdd(Oop* const sp, primargcount_t)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
			if (r != 0)
			{
				LargeIntegerOTE* oteResult = LargeInteger::Add(oteArg, r);
				// Normalize and return
				Oop oopResult = LargeInteger::NormalizeIntermediateResult(oteResult);
				*(sp - 1) = oopResult;
				ObjectMemory::AddOopToZct(oopResult);
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

		SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
		SmallInteger a = ObjectMemoryIntegerValueOf(arg);

		StoreSigned32()(sp - 1, r + a);
		return sp - 1;
	}
}

Oop* PRIMCALL Interpreter::primitiveSubtract(Oop* const sp, primargcount_t)
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
				SmallInteger a = ObjectMemoryIntegerValueOf(oopNegatedArg);
				SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
				SmallInteger result = a + r;

				if (ObjectMemoryIsIntegerValue(result))
				{
					*(sp - 1) = ObjectMemoryIntegerObjectOf(result);
					return sp - 1;
				}
				else
				{
					// Overflowed
					LargeIntegerOTE* oteResult = LargeInteger::liNewSigned32(result);
					*(sp - 1) = reinterpret_cast<Oop>(oteResult);
					ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteResult));
					return sp - 1;
				}
			}
			else
			{
				SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
				if (r != 0)
				{
					LargeIntegerOTE* oteNegatedArg = reinterpret_cast<LargeIntegerOTE*>(oopNegatedArg);
					LargeIntegerOTE* oteResult = LargeInteger::Add(oteNegatedArg, r);
					LargeInteger::DeallocateIntermediateResult(oteNegatedArg);
					// Normalize and return
					Oop oopResult = LargeInteger::NormalizeIntermediateResult(oteResult);
					*(sp - 1) = oopResult;
					ObjectMemory::AddOopToZct(oopResult);
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

		SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
		SmallInteger a = ObjectMemoryIntegerValueOf(arg);
		StoreSigned32()(sp - 1, r - a);
		return sp - 1;
	}
}

Oop* PRIMCALL Interpreter::primitiveMultiply(Oop* const sp, primargcount_t)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
			if (r != 0)
			{
				Oop oopResult = LargeInteger::Mul(oteArg, r);
				// Normalize and return
				*(sp - 1) = normalizeIntermediateResult(oopResult);
				ObjectMemory::AddOopToZct(oopResult);
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

		SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
		SmallInteger a = ObjectMemoryIntegerValueOf(arg);
		int64_t result = __emul(r, a);

		Oop oopResult = Integer::NewSigned64(result);
		*(sp - 1) = oopResult;
		ObjectMemory::AddOopToZct(oopResult);
		return sp - 1;
	}
}

Oop* PRIMCALL Interpreter::primitiveDivide(Oop* const sp, primargcount_t)
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

		SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
		SmallInteger a = ObjectMemoryIntegerValueOf(arg);
		// It seems that the VC++ compiler is finally (as of VS2017) able to recognise this sequence as requiring only a single division instruction, so this is better 
		// than calling a function written in inline assembler or the CRT DLL ldiv function.
		SmallInteger quot = r / a;
		SmallInteger rem = r % a;

		if (rem == 0)
		{
			StoreSigned32()(sp - 1, quot);
			return sp - 1;
		}
	}

	return primitiveFailure(_PrimitiveFailureCode::Unsuccessful);		// Does not divide exactly
}

#ifdef _M_IX86

// primitiveMod implements #\\ for SmallIntegers - it is a remainder with truncation towards negative infinity
// Normally performed in the byteasm.asm; should only get here if performed or for failure cases

__declspec(naked) Oop* PRIMCALL Interpreter::primitiveMod(Oop* const sp, primargcount_t)
{
	_asm
	{
		mov		eax, [esi - OOPSIZE]		// Access receiver at stack top
		mov		ecx, [esi]					// Load argument from stack
		sar		eax, 1						// Convert from SmallInteger
		sar		ecx, 1						// Extract integer value of arg
		jnc		invalidArg					// Arg not a SmallInteger
		cdq									// Sign extend into edx
		sub		esi, OOPSIZE

		idiv	ecx

		test	eax, eax					// test Quotient
		jg		skip						// If positive, skip adjust
		test	edx, edx					// test remainder
		jz		skip						// if exact skip adjust
		xor		ecx, edx					// test sign
		jns		skip						// non - negative, skip adjust
		xor		ecx, edx					// reverse previous XOR
		add		edx, ecx					// adjust remainder
	
	skip:
		add		edx, edx
		mov		eax, esi
		or		edx, 1
		mov		[esi], edx					// Replace stack top with remainder
		ret

	invalidArg:
		mov		eax, 0xd00001df				// _PrimitiveFailureCode::InvalidParameter1
		ret
	}
}
#else

// The C++ compiler generates pretty tight code for the C++ version below, so the assembler
// version above is not really needed any more, but may as well be kept for 32-bit.
Oop* PRIMCALL Interpreter::primitiveMod(Oop* const sp, primargcount_t)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;
	if (ObjectMemoryIsIntegerObject(arg))
	{
		SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
		SmallInteger a = ObjectMemoryIntegerValueOf(arg);
		// It seems that the VC++ compiler is finally (as of VS2017) able to recognise this sequence as requiring only a single division instruction, so this is better 
		// than calling a function written in inline assembler or the CRT DLL ldiv function.
		SmallInteger quot = r / a;
		SmallInteger rem = r % a;

		if (quot > 0 || rem == 0 || !((a ^ rem) < 0))
		{
			*(sp - 1) = ObjectMemoryIntegerObjectOf(rem);
			return sp - 1;
		}
		else
		{
			rem += a;
			*(sp - 1) = ObjectMemoryIntegerObjectOf(rem);
			return sp - 1;
		}

	}
	else
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);		// Unhandled argument type
}
#endif

// This primitive(associated with integer division selector //) does work when
// division is not exact (so this is the same as primitiveDivide, but without check
// for exact division). Note that in Smalltalk integer divide truncates towards
// negative infinity, not zero.
//
Oop* PRIMCALL Interpreter::primitiveDiv(Oop* const sp, primargcount_t)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;
	if (ObjectMemoryIsIntegerObject(arg))
	{
		SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
		SmallInteger a = ObjectMemoryIntegerValueOf(arg);
		// It seems that the VC++ compiler is finally (as of VS2017) able to recognise this sequence as requiring only a single division instruction
		SmallInteger quo = r / a;
		SmallInteger rem = r % a;

		if (quo > 0 || rem == 0 || !((a ^ rem) < 0))
		{
			StoreSigned32()(sp - 1, quo);
			return sp - 1;
		}
		else
		{
			StoreSigned32()(sp - 1, quo - 1);
			return sp - 1;
		}
	}
	else
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
			// Result must be either zero or -1, depending on signs of the operands
			*(sp - 1) = r == 0 || (r ^ oteArg->m_location->sign(oteArg)) >= 0
				? ZeroPointer
				: MinusOnePointer;
			return sp - 1;
		}
		else
		{
			// Handling floats here is complicated because we can easily generate a very large integer by dividing by a very small float,
			// so it is better to leave it to the Smalltalk code to handle this case along with any other argument type
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
		}
	}
}

Oop* PRIMCALL Interpreter::primitiveQuo(Oop* const sp, primargcount_t)
{
	Oop receiver = *(sp - 1);
	Oop arg = *sp;
	if (ObjectMemoryIsIntegerObject(arg))
	{
		SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
		SmallInteger a = ObjectMemoryIntegerValueOf(arg);

		StoreSigned32()(sp - 1, r / a);
		return sp - 1;
	}
	else
	{
		LargeIntegerOTE* oteArg = reinterpret_cast<LargeIntegerOTE*>(arg);
		if (oteArg->m_oteClass == Pointers.ClassLargeInteger)
		{
			// Aside from the one case of `SmallInteger minimum quo: SmallInteger maximum + 1` the result is always zero because
			// every other LargeInteger is larger in magnitude than every other SmallInteger.
			SmallInteger r = ObjectMemoryIntegerValueOf(receiver);
			*(sp - 1) = !(r == MinSmallInteger && oteArg->getWordSize() == 1 && oteArg->m_location->m_digits[0] == MaxSmallInteger+1)
							? ZeroPointer
							: MinusOnePointer;
			return sp - 1;
		}
		else
		{
			// Handling floats here is complicated because we can easily generate a very large integer by dividing by a very small float,
			// so it is better to leave it to the Smalltalk code to handle this case along with any other argument type
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
		}
	}
}


Oop* PRIMCALL Interpreter::primitiveSmallIntegerPrintString(Oop* const sp, primargcount_t)
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
		auto oteResult = AnsiString::New(buffer, strlen(buffer));
		*sp = reinterpret_cast<Oop>(oteResult);
		ObjectMemory::AddToZct((OTE*)oteResult);
		return sp;
	}
	else
		return primitiveFailure(_PrimitiveFailureCode::Failed);
}

Oop* PRIMCALL Interpreter::primitiveSmallIntegerAt(Oop* const sp, primargcount_t)
{
	Oop oopIndex = *sp;
	if (ObjectMemoryIsIntegerObject(oopIndex))
	{
		SmallInteger index = ObjectMemoryIntegerValueOf(oopIndex);

		SmallInteger value = abs(ObjectMemoryIntegerValueOf(*(sp - 1)));
		if (index > 0 && index <= 4)
		{
			uint8_t byte = (value >> (index - 1) * 8) & 0xff;
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

