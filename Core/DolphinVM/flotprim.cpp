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

///////////////////////////////////////////////////////////////////////////////
// Primitive Helper routines

inline FloatOTE* __stdcall Float::New()
{
	ASSERT(sizeof(Float) == sizeof(double) + ObjectHeaderSize);

	FloatOTE* newFloatPointer = reinterpret_cast<FloatOTE*>(Interpreter::m_otePools[Interpreter::FLOATPOOL].newByteObject(Pointers.ClassFloat, sizeof(double), OTEFlags::FloatSpace));
	ASSERT(ObjectMemory::hasCurrentMark(newFloatPointer));
	ASSERT(newFloatPointer->m_oteClass == Pointers.ClassFloat);
	newFloatPointer->beImmutable();

	return newFloatPointer;
}

// Allocates and sets the value of a new float
inline FloatOTE* __stdcall Float::New(double fValue)
{
	ASSERT(sizeof(Float) == sizeof(double) + ObjectHeaderSize);

	FloatOTE* newFloatPointer = reinterpret_cast<FloatOTE*>(Interpreter::m_otePools[Interpreter::FLOATPOOL].newByteObject(Pointers.ClassFloat, sizeof(double), OTEFlags::FloatSpace));
	ASSERT(ObjectMemory::hasCurrentMark(newFloatPointer));
	ASSERT(newFloatPointer->m_oteClass == Pointers.ClassFloat);
	newFloatPointer->beImmutable();

	Float* newFloat = newFloatPointer->m_location;
	newFloat->m_fValue = fValue;
	return newFloatPointer;
}

///////////////////////////////////////////////////////////////////////////////
//	Float conversion primitives

Oop* __fastcall Interpreter::primitiveAsFloat(Oop* const sp, unsigned)
{
	FloatOTE* oteResult = Float::New(ObjectMemoryIntegerValueOf(*sp));
	*sp = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct((OTE*)oteResult);
	return sp;
}

template <class Op> __forceinline static Oop* primitiveTruncationOp(Oop* const sp, const Op& op)
{
	FloatOTE* oteFloat = reinterpret_cast<FloatOTE*>(*sp);
	double fValue = op(oteFloat->m_location->m_fValue);

	if (fValue < MinSmallInteger || fValue > MaxSmallInteger)
	{
		// It may to have to be a LargeInteger...
		if (fValue > double(_I64_MIN) && fValue < double(_I64_MAX))
		{
			// ... representable in 64-bits
			LONGLONG liTrunc = static_cast<LONGLONG>(fValue);
			Oop truncated = Integer::NewSigned64(liTrunc);
			// The truncated value might actually be a SmallInteger, e.g. (SmallInteger maximum + 0.1) truncated
			*sp = truncated;
			ObjectMemory::AddToZct(truncated);
			return sp;
		}
		else
			return nullptr;
	}
	else
	{
		int intVal = static_cast<int>(fValue);
		*sp = ObjectMemoryIntegerObjectOf(intVal);
		return sp;
	}
}


Oop* __fastcall Interpreter::primitiveTruncated(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return x; }
	};

	return primitiveTruncationOp(sp, op());
}


Oop* __fastcall Interpreter::primitiveFloatFloor(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return floor(x); }
	};

	return primitiveTruncationOp(sp, op());
}

Oop* __fastcall Interpreter::primitiveFloatCeiling(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return ceil(x); }
	};

	return primitiveTruncationOp(sp, op());
}

///////////////////////////////////////////////////////////////////////////////
//	Float comparison primitives

// For comparison, we do need precise so that NaN comparisons are performed correctly
// When precise is turned off the compiler generates code for the conditional operator
// statements that defaults the result to true.
// These is no significant performance impact of using precise for these comparisons.
//#pragma float_control(precise, on, push)

template <class P1> __forceinline static Oop* primitiveFloatCompare(Oop* const sp, const P1 &pred)
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
					*(sp - 1) = reinterpret_cast<Oop>(pred(receiver->m_fValue, arg->m_fValue) ? Pointers.True : Pointers.False);
					return sp - 1;
				}
			}
			else
			{
				// Unhandled arg type, fail into Smalltalk code
				return nullptr;
			}
		}
		else
		{
			*(sp - 1) = reinterpret_cast<Oop>(pred(receiver->m_fValue, ObjectMemoryIntegerValueOf(oopArg)) ? Pointers.True : Pointers.False);
			return sp - 1;
		}
	}

	*(sp - 1) = reinterpret_cast<Oop>(Pointers.False);
	return sp - 1;
}

Oop* Interpreter::primitiveFloatLessThan(Oop* const sp, unsigned)
{
	return primitiveFloatCompare(sp, std::less<double>());
}

Oop* Interpreter::primitiveFloatGreaterThan(Oop* const sp, unsigned)
{
	return primitiveFloatCompare(sp, std::greater<double>());
}

Oop* Interpreter::primitiveFloatLessOrEqual(Oop* const sp, unsigned)
{
	return primitiveFloatCompare(sp, std::less_equal<double>());
}

Oop* Interpreter::primitiveFloatGreaterOrEqual(Oop* const sp, unsigned)
{
	return primitiveFloatCompare(sp, std::greater_equal<double>());
}

Oop* Interpreter::primitiveFloatEqual(Oop* const sp, unsigned)
{
	// Note that we can't optimise this for identical without allowing for the NaN case. Not really worth it.
	return primitiveFloatCompare(sp, std::equal_to<double>());
}

//#pragma float_control(pop)


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

template <class T> __forceinline static Oop* primitiveFloatBinaryOp(Oop* const sp, const T &op)
{
	Oop oopArg = *sp;
	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*(sp-1));
	Float* receiver = oteReceiver->m_location;

	FloatOTE* oteResult;
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		FloatOTE* oteArg = reinterpret_cast<FloatOTE*>(oopArg);
		if (oteArg->m_oteClass == Pointers.ClassFloat)
		{
			oteResult = Float::New(op(receiver->m_fValue, oteArg->m_location->m_fValue));
			*(sp - 1) = reinterpret_cast<Oop>(oteResult);
			ObjectMemory::AddToZct((OTE*)oteResult);
			return sp - 1;
		}
		else
		{
			return nullptr;
		}
	}
	else
	{
		oteResult = Float::New(op(receiver->m_fValue, ObjectMemoryIntegerValueOf(oopArg)));
		*(sp - 1) = reinterpret_cast<Oop>(oteResult);
		ObjectMemory::AddToZct((OTE*)oteResult);
		return sp - 1;
	}
}

Oop* Interpreter::primitiveFloatAdd(Oop* const sp, unsigned)
{
	return primitiveFloatBinaryOp(sp, std::plus<double>());
}

Oop* Interpreter::primitiveFloatSubtract(Oop* const sp, unsigned)
{
	return primitiveFloatBinaryOp(sp, std::minus<double>());
}

Oop* Interpreter::primitiveFloatMultiply(Oop* const sp, unsigned)
{
	return primitiveFloatBinaryOp(sp, std::multiplies<double>());
}

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

Oop* Interpreter::primitiveFloatDivide(Oop* const sp, unsigned)
{
	return primitiveFloatBinaryOp(sp, std::divides<double>());
}

template <class T> __forceinline static Oop* primitiveFloatUnaryOp(Oop* const sp, const T &op)
{
	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*sp);
	Float* receiver = oteReceiver->m_location;

	FloatOTE* oteResult = Float::New(op(receiver->m_fValue));

	*sp = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct((OTE*)oteResult);
	return sp;
}

Oop* Interpreter::primitiveFloatSin(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return sin(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatCos(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return cos(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatTan(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return tan(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatArcSin(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return asin(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatArcCos(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return acos(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatArcTan(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return atan(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatArcTan2(Oop* const sp, unsigned)
{
	struct op_atan2 {
		double operator() (const double& y, const double& x) const { return atan2(y, x); }
	};

	return primitiveFloatBinaryOp(sp, op_atan2());
}

Oop* Interpreter::primitiveFloatExp(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return exp(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatLn(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return log(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatLog10(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return log10(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatSqrt(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return sqrt(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatTimesTwoPower(Oop* const sp, unsigned)
{
	Oop oopArg = *sp;

	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SMALLINTEGER arg = ObjectMemoryIntegerValueOf(oopArg);

		FloatOTE* oteResult = Float::New();
		FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*(sp-1));
		// Compiler doesn't have an intrinsic form for ldexp(), and the lib functions uses old x87 instructions
		oteResult->m_location->m_fValue = ldexp(oteReceiver->m_location->m_fValue, arg);
		// exp2(1074) overflows when printing Float.FMin
		//oteResult->m_location->m_fValue = oteReceiver->m_location->m_fValue * exp2(arg);

		*(sp-1) = reinterpret_cast<Oop>(oteResult);
		ObjectMemory::AddToZct((OTE*)oteResult);
		return sp-1;
	}
	else
		return NULL;
}

Oop* Interpreter::primitiveFloatAbs(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return fabs(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

template <class T> struct op_pow {
	double operator() (const T& x, const T& y) const { return pow(x, y); }
};

Oop* Interpreter::primitiveFloatRaisedTo(Oop* const sp, unsigned)
{
	return primitiveFloatBinaryOp(sp, op_pow<double>());
}

Oop* __fastcall Interpreter::primitiveFloatExponent(Oop* const sp, unsigned)
{
	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*sp);
	double fValue = oteReceiver->m_location->m_fValue;
	SMALLINTEGER exponent = ilogb(fValue);
	*sp = ObjectMemoryIntegerObjectOf(exponent);
	return sp;
}

Oop* Interpreter::primitiveFloatNegated(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return _chgsign(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatFractionPart(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { double integerPart;  return modf(x, &integerPart); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatIntegerPart(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { double integerPart;  modf(x, &integerPart); return integerPart; }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatClassify(Oop* const sp, unsigned)
{
	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*sp);
	double fValue = oteReceiver->m_location->m_fValue;
	SMALLINTEGER classification = _fpclass(fValue);
	*sp = ObjectMemoryIntegerObjectOf(classification);
	return sp;
}

///////////////////////////////////////////////////////////////////////////////
// Primitives for external buffer manipulation of floats/doubles
//
// The receivers of these primitives must be byte objects, else they will fail
// Note also that they work off the byte offset (zero based), rather than being
// 1 based like the Smalltalk #at:/#at:put: primitives.
//
// Remember, Smalltalk floats are double precision
// Single and Double precision versions of the accessor primitives are exactly
// the same, except that a different cast is used
//
// Unlike some other accessor primitives, these also work for indirection objects
// (e.g. ExternalAddress).
//

Oop* __fastcall Interpreter::primitiveDoublePrecisionFloatAt(Oop* const sp, unsigned)
{
	Oop integerPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(integerPointer))
	{
		OTE* oteArg = reinterpret_cast<OTE*>(integerPointer);
		return primitiveFailureWith(PrimitiveFailureNonInteger, oteArg);	// Index not an integer
	}

	SMALLUNSIGNED offset = ObjectMemoryIntegerValueOf(integerPointer);
	OTE* receiver = reinterpret_cast<OTE*>(*(sp-1));

	ASSERT(!ObjectMemoryIsIntegerObject(receiver));
	ASSERT(receiver->isBytes());

	FloatOTE* oteResult;
	Behavior* behavior = receiver->m_oteClass->m_location;
	if (behavior->isIndirect())
	{
		ExternalAddress* ptr = static_cast<ExternalAddress*>(receiver->m_location);
		oteResult = Float::New(*reinterpret_cast<double*>(static_cast<BYTE*>(ptr->m_pointer)+offset));
	}
	else
	{
		BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(receiver);

		// We can check that the offset is in bounds
		if (static_cast<int>(offset) < 0 ||	offset+sizeof(double) > oteBytes->bytesSize())
			return primitiveFailure(PrimitiveFailureBoundsError);	// Out of bounds

		VariantByteObject* bytes = oteBytes->m_location;
		oteResult = Float::New(*reinterpret_cast<double*>(&(bytes->m_fields[offset])));
	}

	*(sp-1) = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct((OTE*)oteResult);
	return sp-1;
}


Oop* __fastcall Interpreter::primitiveSinglePrecisionFloatAt(Oop* const sp, unsigned)
{
	Oop integerPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(integerPointer))
	{
		OTE* oteArg = reinterpret_cast<OTE*>(integerPointer);
		return primitiveFailureWith(PrimitiveFailureNonInteger, oteArg);	// Index not an integer
	}

	SMALLUNSIGNED offset = ObjectMemoryIntegerValueOf(integerPointer);
	OTE* receiver = reinterpret_cast<OTE*>(*(sp-1));

	ASSERT(!ObjectMemoryIsIntegerObject(receiver));
	ASSERT(receiver->isBytes());

	FloatOTE* oteResult;
	Behavior* behavior = receiver->m_oteClass->m_location;
	if (behavior->isIndirect())
	{
		ExternalAddress* ptr = static_cast<ExternalAddress*>(receiver->m_location);
		oteResult = Float::New(*reinterpret_cast<float*>(static_cast<BYTE*>(ptr->m_pointer)+offset));
	}
	else
	{
		BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(receiver);

		// We can check that the offset is in bounds
		if (static_cast<int>(offset) < 0 || offset+sizeof(float) > oteBytes->bytesSize())
			return primitiveFailure(PrimitiveFailureBoundsError);	// Out of bounds

		VariantByteObject* bytes = oteBytes->m_location;
		oteResult = Float::New(*reinterpret_cast<float*>(&(bytes->m_fields[offset])));
	}

	*(sp-1) = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct((OTE*)oteResult);
	return sp-1;
}


Oop* __fastcall Interpreter::primitiveDoublePrecisionFloatAtPut(Oop* const sp, unsigned)
{
	Oop integerPointer = *(sp-1);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
	{
		OTE* oteArg = reinterpret_cast<OTE*>(integerPointer);
		return primitiveFailureWith(PrimitiveFailureNonInteger, oteArg);	// Index not an integer
	}

	double fValue;
	Oop valuePointer = *sp;
	if (ObjectMemoryIsIntegerObject(valuePointer))
	{
		fValue = ObjectMemoryIntegerValueOf(valuePointer);
	}
	else
	{
		if (ObjectMemory::fetchClassOf(valuePointer) != Pointers.ClassFloat)
		{
			return primitiveFailure(PrimitiveFailureBadValue);
		}
		FloatOTE* oteValue = reinterpret_cast<FloatOTE*>(valuePointer);
		fValue = oteValue->m_location->m_fValue;
	}

	SMALLUNSIGNED offset = ObjectMemoryIntegerValueOf(integerPointer);

	OTE* receiver = reinterpret_cast<OTE*>(*(sp-2));
	ASSERT(!ObjectMemoryIsIntegerObject(receiver));
	ASSERT(receiver->isBytes());

	// All entry conditions passed, proceed to copy floating point value into buffer

	// Its a byte object, so its simpler (no ref counting and no fixed fields)
	Behavior* behavior = receiver->m_oteClass->m_location;
	if (behavior->isIndirect())
	{
		ExternalAddress* ptr = static_cast<ExternalAddress*>(receiver->m_location);
		*reinterpret_cast<double*>(static_cast<BYTE*>(ptr->m_pointer)+offset) = fValue;
	}
	else
	{
		BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(receiver);

		// We can check that the offset is in bounds
		if (static_cast<int>(offset) < 0 || static_cast<int>(offset+sizeof(double)) > oteBytes->bytesSizeForUpdate())
			return primitiveFailure(1);	// Non-integer value or Out of bounds

		VariantByteObject* bytes = oteBytes->m_location;
		*reinterpret_cast<double*>(&(bytes->m_fields[offset])) = fValue;
	}

	*(sp-2) = valuePointer;
	return sp-2;
}


Oop* __fastcall Interpreter::primitiveSinglePrecisionFloatAtPut(Oop* const sp, unsigned)
{
	Oop integerPointer = *(sp-1);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
	{
		OTE* oteArg = reinterpret_cast<OTE*>(integerPointer);
		return primitiveFailureWith(PrimitiveFailureNonInteger, oteArg);	// Index not an integer
	}

	float fValue;
	Oop valuePointer = *sp;
	if (ObjectMemoryIsIntegerObject(valuePointer))
	{
		fValue = static_cast<float>(ObjectMemoryIntegerValueOf(valuePointer));
	}
	else
	{
		if (ObjectMemory::fetchClassOf(valuePointer) != Pointers.ClassFloat)
		{
			return primitiveFailure(PrimitiveFailureBadValue);
		}
		FloatOTE* oteValue = reinterpret_cast<FloatOTE*>(valuePointer);
		fValue = static_cast<float>(oteValue->m_location->m_fValue);
	}

	SMALLUNSIGNED offset = ObjectMemoryIntegerValueOf(integerPointer);

	OTE* receiver = reinterpret_cast<OTE*>(*(sp-2));
	ASSERT(!ObjectMemoryIsIntegerObject(receiver));
	ASSERT(receiver->isBytes());

	// All entry conditions passed, proceed to copy floating point value into buffer

	// Its a byte object, so its simpler (no ref counting and no fixed fields)
	Behavior* behavior = receiver->m_oteClass->m_location;
	if (behavior->isIndirect())
	{
		ExternalAddress* ptr = static_cast<ExternalAddress*>(receiver->m_location);
		*reinterpret_cast<float*>(static_cast<BYTE*>(ptr->m_pointer)+offset) = fValue;
	}
	else
	{
		BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(receiver);

		// We can check that the offset is in bounds
		if (static_cast<int>(offset) < 0 || static_cast<int>(offset+sizeof(float)) > oteBytes->bytesSizeForUpdate())
			return primitiveFailure(PrimitiveFailureBoundsError);	// Out of bounds

		VariantByteObject* bytes = oteBytes->m_location;
		*reinterpret_cast<float*>(&(bytes->m_fields[offset])) = fValue;
	}

	*(sp-2) = valuePointer;
	return sp-2;
}

Oop* __fastcall Interpreter::primitiveLongDoubleAt(Oop* const sp, unsigned)
{
	Oop integerPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(integerPointer))
	{
		OTE* oteArg = reinterpret_cast<OTE*>(integerPointer);
		return primitiveFailureWith(PrimitiveFailureNonInteger, oteArg);	// Index not an integer
	}

	SMALLUNSIGNED offset = ObjectMemoryIntegerValueOf(integerPointer);
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
		pLongDbl = reinterpret_cast<_FP80*>(static_cast<BYTE*>(ptr->m_pointer)+offset);
	}
	else
	{
		BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(receiver);

		// We can check that the offset is in bounds
		if (static_cast<int>(offset) < 0 || offset+sizeof(double) > oteBytes->bytesSize())
			return primitiveFailure(PrimitiveFailureBoundsError);	// Out of bounds

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

