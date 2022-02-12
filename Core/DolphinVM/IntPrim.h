#pragma once

template <class Op> static Oop* PRIMCALL Interpreter::primitiveIntegerOp(Oop* const sp, primargcount_t)
{
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
		return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);

	Oop receiver = *(sp - 1);
	*(sp - 1) = Op()(receiver, arg);
	return sp - 1;
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

struct bit_xor {
	constexpr Oop operator() (const Oop& receiver, const Oop& arg) const {
		return receiver ^ (arg - 1);
	}
};
