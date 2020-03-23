#pragma once

template <typename Op> static Oop* __fastcall Interpreter::primitiveFloatTruncationOp(Oop* const sp, primargcount_t)
{
	FloatOTE* oteFloat = reinterpret_cast<FloatOTE*>(*sp);
	double fValue = Op()(oteFloat->m_location->m_fValue);

#ifdef _M_IX86
	if (fValue < MinSmallInteger || fValue > MaxSmallInteger)
	{
		// It may to have to be a LargeInteger...
		if (fValue > double(INT64_MIN) && fValue < double(INT64_MAX))
		{
			// ... representable in 64-bits
			int64_t liTrunc = static_cast<int64_t>(fValue);
			Oop truncated = Integer::NewSigned64(liTrunc);
			// The truncated value might actually be a SmallInteger, e.g. (SmallInteger maximum + 0.1) truncated
			*sp = truncated;
			ObjectMemory::AddOopToZct(truncated);
			return sp;
		}
		else
			// Non-finite receiver - can't be represented as an integer
			return primitiveFailure(_PrimitiveFailureCode::IntegerOverflow);
	}
	else
#else
	if (fValue > double(INT64_MIN) || fValue < double(INT64_MAX))
#endif
	{
		auto intVal = static_cast<SmallInteger>(fValue);
		*sp = ObjectMemoryIntegerObjectOf(intVal);
		return sp;
	}

	// Non-finite receiver - can't be represented as an SmallInteger
	return primitiveFailure(_PrimitiveFailureCode::IntegerOverflow);
}

struct Truncate { double operator() (const double& x) const { return x; } };
struct Floor { double operator() (const double& x) const { return floor(x); } };
struct Ceiling { double operator() (const double& x) const { return ceil(x); } };

template <typename Pred> static Oop* __fastcall Interpreter::primitiveFloatCompare(Oop* const sp, primargcount_t)
{
	Float* receiver = reinterpret_cast<FloatOTE*>(*(sp - 1))->m_location;
	// NaN's never compare <, <=, =, >= or > to anything, even another NaN
	if (!receiver->isNaN())
	{
		Oop oopArg = *sp;
		if (!ObjectMemoryIsIntegerObject(oopArg))
		{
			FloatOTE* oteArg = reinterpret_cast<FloatOTE*>(oopArg);
			Float* arg = oteArg->m_location;
			if (oteArg->m_oteClass == Pointers.ClassFloat)
			{
				if (!arg->isNaN())
				{
					*(sp - 1) = reinterpret_cast<Oop>(Pred()(receiver->m_fValue, arg->m_fValue) ? Pointers.True : Pointers.False);
					return sp - 1;
				}
			}
			else
			{
				// Unhandled arg type, fail into Smalltalk code
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
			}
		}
		else
		{
			*(sp - 1) = reinterpret_cast<Oop>(Pred()(receiver->m_fValue, ObjectMemoryIntegerValueOf(oopArg)) ? Pointers.True : Pointers.False);
			return sp - 1;
		}
	}

	*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
	return sp - 1;
}

///////////////////////////////////////////////////////////////////////////////
//	Float arithmetic primitives
// 
// These are carefully arranged for optimal code generation. In particular the
// Float object to hold the result is allocated before the FP calculation is
// the calculation, although only until the next GC. By allocating the Float upfront, 
// the C++ compiler is able to generated code that stores directly from the XMM0 
// register into the object. If the Float is allocated after the calculation, then the result value 
// will be stored down to a local on the stack, and then copied into the object later, slowing
// down the primitives quite a lot.
// The conditions are also arranged so that the conditional forward jumps are taken in the less
// common case, which reduces branch misprediction overhead.
// 
// primitiveFloatDivide
//
// As specified by ISO 10967, clause 6, a compliant implementation can support a number of 	alternate means for applications to detect FP errors :
//	a) Notification by recording in indicators (see clause 6.2.1).
//	b) Notification by alteration of control flow (see clause 6.2.2).
//	c) Notification by termination with message (see clause 6.2.3).
//
// Here we support (a) and (b) for division by zero, depending on the current FP exception mask. If zero-divide and invalid operation exceptions
// are unmasked, then an FP exception will be raised directly by the division operation below and will interrupt the Smalltalk code causing
// an alteration of control flow (option (b)). If exceptions are masked, then divide by zero will not be raised, and instead a continuation 
// value (∞ or -∞) will result. The FP status will correctly reflect division by zero in this case since the actual division operation is 
// still performed, which is always required since indicators must always be available, even for option (b) (i.e. only (a), or (a) and (b) 
// together, are compliant options.
//

template <typename Op> static Oop* __fastcall Interpreter::primitiveFloatBinaryOp(Oop* const sp, primargcount_t)
{
	Oop oopArg = *sp;
	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*(sp - 1));
	Float* receiver = oteReceiver->m_location;

	FloatOTE* oteResult;
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		FloatOTE* oteArg = reinterpret_cast<FloatOTE*>(oopArg);
		if (oteArg->m_oteClass == Pointers.ClassFloat)
		{
			oteResult = Float::New(Op()(receiver->m_fValue, oteArg->m_location->m_fValue));
			*(sp - 1) = reinterpret_cast<Oop>(oteResult);
			ObjectMemory::AddToZct((OTE*)oteResult);
			return sp - 1;
		}
		else
		{
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
		}
	}
	else
	{
		oteResult = Float::New(Op()(receiver->m_fValue, ObjectMemoryIntegerValueOf(oopArg)));
		*(sp - 1) = reinterpret_cast<Oop>(oteResult);
		ObjectMemory::AddToZct((OTE*)oteResult);
		return sp - 1;
	}
}

template <typename Op> static Oop* __fastcall Interpreter::primitiveFloatUnaryOp(Oop* const sp, primargcount_t)
{
	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*sp);
	Float* receiver = oteReceiver->m_location;

	FloatOTE* oteResult = Float::New(Op()(receiver->m_fValue));

	*sp = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct((OTE*)oteResult);
	return sp;
}

struct Atan2 { double operator() (const double& y, const double& x) const { return atan2(y, x); } };
struct Pow { double operator() (const double& x, const double& y) const { return pow(x, y); } };
struct Sin { double operator() (const double& x) const { return sin(x); } };
struct Cos { double operator() (const double& x) const { return cos(x); } };
struct Tan { double operator() (const double& x) const { return tan(x); } };
struct ArcSin { double operator() (const double& x) const { return asin(x); } };
struct ArcCos { double operator() (const double& x) const { return acos(x); } };
struct ArcTan { double operator() (const double& x) const { return atan(x); } };
struct Exp { double operator() (const double& x) const { return exp(x); } };
struct Log { double operator() (const double& x) const { return log(x); } };
struct Log10 { double operator() (const double& x) const { return log10(x); } };
struct Sqrt { double operator() (const double& x) const { return sqrt(x); } };
struct Abs { double operator() (const double& x) const { return fabs(x); } };
struct Negated { double operator() (const double& x) const { return _chgsign(x); } };

struct FractionPart 
{
	double operator() (const double& x) const 
	{ 
		double integerPart;  
		return modf(x, &integerPart); 
	} 
};
struct IntegerPart 
{ 
	double operator() (const double& x) const 
	{ 
		double integerPart;  modf(x, &integerPart); return integerPart; 
	} 
};
