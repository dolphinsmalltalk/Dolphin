/******************************************************************************

	File: FlotPrim.cpp

	Description:

	Implementation of the Interpreter class' Float Point
	primitive methods. These mostly rely directly on C runtime
	library routines. Should performance become an issue we could
	consider assembly implementations

******************************************************************************/
#include "Ist.h"

#pragma code_seg(FPPRIM_SEG)

// Since we are generally flushing back to Smalltalk objects in memory between FP operations, we don't need /Fp:precise
#pragma float_control(precise, off)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

// Smalltalk classes
#include "STFloat.h"
#include "STBehavior.h"		// For checking indirections
#include "STExternal.h"
#include "STInteger.h"

#include "FloatPrim.h"

///////////////////////////////////////////////////////////////////////////////
// Primitive Helper routines

inline FloatOTE* __stdcall Float::New()
{
	ASSERT(sizeof(Float) == sizeof(double) + ObjectHeaderSize);

	FloatOTE* newFloatPointer = reinterpret_cast<FloatOTE*>(Interpreter::m_floatPool.newByteObject(Pointers.ClassFloat));
	ASSERT(ObjectMemory::hasCurrentMark(newFloatPointer));
	ASSERT(newFloatPointer->m_oteClass == Pointers.ClassFloat);
	newFloatPointer->beImmutable();

	return newFloatPointer;
}

// Allocates and sets the value of a new float
inline FloatOTE* __stdcall Float::New(double fValue)
{
	ASSERT(sizeof(Float) == sizeof(double) + ObjectHeaderSize);

	FloatOTE* newFloatPointer = reinterpret_cast<FloatOTE*>(Interpreter::m_floatPool.newByteObject(Pointers.ClassFloat));
	ASSERT(ObjectMemory::hasCurrentMark(newFloatPointer));
	ASSERT(newFloatPointer->m_oteClass == Pointers.ClassFloat);
	newFloatPointer->beImmutable();

	Float* newFloat = newFloatPointer->m_location;
	newFloat->m_fValue = fValue;
	return newFloatPointer;
}

///////////////////////////////////////////////////////////////////////////////
//	Float conversion primitives

Oop* PRIMCALL Interpreter::primitiveAsFloat(Oop* const sp, primargcount_t)
{
	FloatOTE* oteResult = Float::New(ObjectMemoryIntegerValueOf(*sp));
	*sp = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct((OTE*)oteResult);
	return sp;
}

Oop* PRIMCALL Interpreter::primitiveFloatTimesTwoPower(Oop* const sp, primargcount_t)
{
	Oop oopArg = *sp;

	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SmallInteger arg = ObjectMemoryIntegerValueOf(oopArg);

		FloatOTE* oteResult = Float::New();
		FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*(sp-1));
		// ldexp in 10.0.21390.1 (Windows 10, May 21 Insider build) has an apparent new bug that it no longer returns 
		// zero if underflow denormal, so use theoretically equivalent scalbn instead.
		oteResult->m_location->m_fValue = scalbn(oteReceiver->m_location->m_fValue, arg);
		// exp2(1074) overflows when printing Float.FMin
		//oteResult->m_location->m_fValue = oteReceiver->m_location->m_fValue * exp2(arg);
		*(sp-1) = reinterpret_cast<Oop>(oteResult);
		ObjectMemory::AddToZct((OTE*)oteResult);
		return sp-1;
	}
	else
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

Oop* PRIMCALL Interpreter::primitiveFloatExponent(Oop* const sp, primargcount_t)
{
	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*sp);
	double fValue = oteReceiver->m_location->m_fValue;
	SmallInteger exponent = ilogb(fValue);
	*sp = ObjectMemoryIntegerObjectOf(exponent);
	return sp;
}

Oop* Interpreter::primitiveFloatClassify(Oop* const sp, primargcount_t)
{
	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*sp);
	double fValue = oteReceiver->m_location->m_fValue;
	SmallInteger classification = _fpclass(fValue);
	*sp = ObjectMemoryIntegerObjectOf(classification);
	return sp;
}

template <typename Op> static Oop* PRIMCALL Interpreter::primitiveFloatTruncationOp(Oop* const sp, primargcount_t)
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

template Oop* PRIMCALL Interpreter::primitiveFloatTruncationOp<Truncate>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatTruncationOp<Floor>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatTruncationOp<Ceiling>(Oop* const, primargcount_t);

template <typename Pred> static Oop* PRIMCALL Interpreter::primitiveFloatCompare(Oop* const sp, primargcount_t)
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

template Oop* PRIMCALL Interpreter::primitiveFloatCompare<std::greater<double>>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatCompare<std::less<double>>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatCompare<std::less_equal<double>>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatCompare<std::greater_equal<double>>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatCompare<std::equal_to<double>>(Oop* const, primargcount_t);

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

template <typename Op> static Oop* PRIMCALL Interpreter::primitiveFloatBinaryOp(Oop* const sp, primargcount_t)
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

template Oop* PRIMCALL Interpreter::primitiveFloatBinaryOp<std::plus<double>>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatBinaryOp<std::minus<double>>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatBinaryOp<std::multiplies<double>>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatBinaryOp<std::divides<double>>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatBinaryOp<Pow>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatBinaryOp<Atan2>(Oop* const, primargcount_t);

template <typename Op> static Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp(Oop* const sp, primargcount_t)
{
	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*sp);
	Float* receiver = oteReceiver->m_location;

	FloatOTE* oteResult = Float::New(Op()(receiver->m_fValue));

	*sp = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct((OTE*)oteResult);
	return sp;
}

template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<Sin>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<Tan>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<Cos>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<ArcSin>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<ArcTan>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<ArcCos>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<Log>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<Exp>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<Sqrt>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<Log10>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<Abs>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<Negated>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<FractionPart>(Oop* const, primargcount_t);
template Oop* PRIMCALL Interpreter::primitiveFloatUnaryOp<IntegerPart>(Oop* const, primargcount_t);

Oop* PRIMCALL Interpreter::primitiveLongDoubleAt(Oop* const sp, primargcount_t)
{
	Oop integerPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(integerPointer))
	{
		OTE* oteArg = reinterpret_cast<OTE*>(integerPointer);
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Index not an integer
	}

	SmallInteger offset = ObjectMemoryIntegerValueOf(integerPointer);
	OTE* receiver = reinterpret_cast<OTE*>(*(sp-1));

	ASSERT(!ObjectMemoryIsIntegerObject(receiver));
	ASSERT(receiver->isBytes());

	// Its a byte object, so its simpler (no ref counting and no fixed fields)
	double fValue;
	Behavior* behavior = receiver->m_oteClass->m_location;
	_FP80* pLongDbl;
	if (behavior->isIndirect())
	{
		ExternalAddress* ptr = static_cast<ExternalAddress*>(receiver->m_location);
		pLongDbl = reinterpret_cast<_FP80*>(static_cast<uint8_t*>(ptr->m_pointer)+offset);
	}
	else
	{
		BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(receiver);

		// We can check that the offset is in bounds
		if (offset < 0 || static_cast<size_t>(offset)+sizeof(double) > oteBytes->bytesSize())
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Out of bounds

		VariantByteObject* bytes = oteBytes->m_location;
		pLongDbl = reinterpret_cast<_FP80*>(&(bytes->m_fields[offset]));
	}

	// VC++ does not support 80-bit floats (it's long double type is the same as double), so we must use assembler here
	_asm
	{
		mov		eax, pLongDbl
		fld		TBYTE PTR[eax]
		fstp	fValue
		// Raise pending exceptions, e.g. overflow
		fwait
	}

	FloatOTE* oteResult = Float::New(fValue);
	*(sp-1) = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct((OTE*)oteResult);
	return sp-1;
}

