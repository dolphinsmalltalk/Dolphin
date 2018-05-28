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
	Float* floatReceiver = oteFloat->m_location;

	double fValue = op(floatReceiver->m_fValue);

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
		}
		else
		{
			// Too large, have to handle it in Smalltalk
			return NULL;
		}
	}
	else
	{
		int intVal = static_cast<int>(fValue);
		*sp = ObjectMemoryIntegerObjectOf(intVal);
	}

	return sp;

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
#pragma float_control(precise, on, push)

template <class P1, class P2> __forceinline static Oop* primitiveFloatCompare(Oop* const sp, const P1 &pred, const P2& predMixed)
{
	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*(sp - 1));
	Oop oopArg = *sp;
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		FloatOTE* oteArg = reinterpret_cast<FloatOTE*>(oopArg);
		if (oteArg->m_oteClass == Pointers.ClassFloat)
		{
			*(sp - 1) = reinterpret_cast<Oop>(pred(oteReceiver->m_location->m_fValue, oteArg->m_location->m_fValue) 
							? Pointers.True : Pointers.False);
		}
		else
		{
			return NULL;
		}
	}
	else
	{
		*(sp - 1) = reinterpret_cast<Oop>(predMixed(oteReceiver->m_location->m_fValue, ObjectMemoryIntegerValueOf(oopArg))
			? Pointers.True : Pointers.False);
	}

	return sp - 1;
}

template <class T1, class T2> struct less {
	bool operator() (const T1& x, const T2& y) const { return x<y; }
};

Oop* Interpreter::primitiveFloatLessThan(Oop* const sp, unsigned)
{
	return primitiveFloatCompare(sp, ::less<double, double>(), ::less<double, SMALLINTEGER>());
}

template <class T1, class T2> struct greater {
	bool operator() (const T1& x, const T2& y) const { return x>y; }
};

Oop* Interpreter::primitiveFloatGreaterThan(Oop* const sp, unsigned)
{
	return primitiveFloatCompare(sp, ::greater<double, double>(), ::greater<double, SMALLINTEGER>());
}


template <class T1, class T2> struct less_equal {
	bool operator() (const T1& x, const T2& y) const { return x<=y; }
};

Oop* Interpreter::primitiveFloatLessOrEqual(Oop* const sp, unsigned)
{
	return primitiveFloatCompare(sp, ::less_equal<double, double>(), ::less_equal<double, SMALLINTEGER>());
}

template <class T1, class T2> struct greater_equal {
	bool operator() (const T1& x, const T2& y) const { return x>=y; }
};

Oop* Interpreter::primitiveFloatGreaterOrEqual(Oop* const sp, unsigned)
{
	return primitiveFloatCompare(sp, ::greater_equal<double, double>(), ::greater_equal<double, SMALLINTEGER>());
}

template <class T1, class T2> struct equal_to {
	bool operator() (const T1& x, const T2& y) const { return x==y; }
};

Oop* Interpreter::primitiveFloatEqual(Oop* const sp, unsigned)
{
	// Note that we can't optimise this for identical without allowing for the NaN case. Not really worth it.
	return primitiveFloatCompare(sp, ::equal_to<double, double>(), ::equal_to<double, SMALLINTEGER>());
}

#pragma float_control(pop)


///////////////////////////////////////////////////////////////////////////////
//	Float arithmetic primitives
// 
// These are carefully arranged for optimal code generation. In particular the
// Float object to hold the result is allocated before the FP calculation is
// performed. This will temporarily "leak" the object if there is an FP fault in 
// the calculation, although only until the next GC. By allocating the Float upfront, 
// the C++ compiler is able to generated code that stores directly from the XMM0 
// register into the object. If the Float is allocated after the calculation, then the result value 
// will be stored down to a local on the stack, and then copied into the object later, slowing
// down the primitives quite a lot.
// The conditions are also arranged so that the conditional forward jumps are taken in the less
// common case, which reduces branch misprediction overhead.

template <class O1, class O2> __forceinline static Oop* primitiveFloatBinaryOp(Oop* const sp, const O1 &op, const O2& opMixed)
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
			oteResult = Float::New();
			oteResult->m_location->m_fValue = op(receiver->m_fValue, oteArg->m_location->m_fValue);
		}
		else
		{
			return NULL;
		}
	}
	else
	{
		oteResult = Float::New();
		oteResult->m_location->m_fValue = opMixed(receiver->m_fValue, ObjectMemoryIntegerValueOf(oopArg));
	}

	*(sp-1) = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct((OTE*)oteResult);
	return sp-1;
}

// std::plus requires that T1 = T2
template <class T1, class T2> struct plus {
	double operator() (const T1& x, const T2& y) const { return x+y; }
};

Oop* Interpreter::primitiveFloatAdd(Oop* const sp, unsigned)
{
	return primitiveFloatBinaryOp(sp,	::plus<double, double>(), plus<double, SMALLINTEGER>());
}

template <class T1, class T2> struct minus {
	double operator() (const T1& x, const T2& y) const { return x - y; }
};

Oop* Interpreter::primitiveFloatSubtract(Oop* const sp, unsigned)
{
	return primitiveFloatBinaryOp(sp, minus<double, double>(), minus<double, SMALLINTEGER>());
}

template <class T1, class T2> struct multiplies {
	double operator() (const T1& x, const T2& y) const { return x * y; }
};

Oop* Interpreter::primitiveFloatMultiply(Oop* const sp, unsigned)
{
	return primitiveFloatBinaryOp(sp, multiplies<double, double>(), multiplies<double, SMALLINTEGER>());
}

// std::divides requires that T1 = T2
template <class T1, class T2> struct divides {
	double operator() (const T1& x, const T2& y) const { return x / y; }
};

Oop* Interpreter::primitiveFloatDivide(Oop* const sp, unsigned)
{
	return primitiveFloatBinaryOp(sp, divides<double, double>(), divides<double, SMALLINTEGER>());
}

template <class O1> __forceinline static Oop* primitiveFloatUnaryOp(Oop* const sp, const O1 &op)
{
	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*sp);
	Float* receiver = oteReceiver->m_location;

	FloatOTE* oteResult = Float::New();
	oteResult->m_location->m_fValue = op(receiver->m_fValue);

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

template <class T1, class T2> struct op_atan2 {
	double operator() (const T1& y, const T2& x) const { return atan2(y, x); }
};

Oop* Interpreter::primitiveFloatArcTan2(Oop* const sp, unsigned)
{
	return primitiveFloatBinaryOp(sp, op_atan2<double, double>(), op_atan2<double, SMALLINTEGER>());
}

Oop* Interpreter::primitiveFloatExp(Oop* const sp, unsigned)
{
	struct op {
		double operator() (const double& x) const { return exp(x); }
	};

	return primitiveFloatUnaryOp(sp, op());
}

Oop* Interpreter::primitiveFloatLog(Oop* const sp, unsigned)
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

template <class T1, class T2> struct op_pow {
	double operator() (const T1& x, const T2& y) const { return pow(x, y); }
};

Oop* Interpreter::primitiveFloatRaisedTo(Oop* const sp, unsigned)
{
	return primitiveFloatBinaryOp(sp, op_pow<double, double>(), op_pow<double, SMALLINTEGER>());
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

	// Its a byte object, so its simpler (no ref counting and no fixed fields)
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

	// Its a byte object, so its simpler (no ref counting and no fixed fields)
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

