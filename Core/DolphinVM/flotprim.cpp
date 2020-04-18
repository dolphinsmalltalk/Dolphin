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

	FloatOTE* newFloatPointer = reinterpret_cast<FloatOTE*>(Interpreter::m_otePools[static_cast<size_t>(Interpreter::Pools::Floats)].newByteObject(Pointers.ClassFloat, sizeof(double), Spaces::Floats));
	ASSERT(ObjectMemory::hasCurrentMark(newFloatPointer));
	ASSERT(newFloatPointer->m_oteClass == Pointers.ClassFloat);
	newFloatPointer->beImmutable();

	return newFloatPointer;
}

// Allocates and sets the value of a new float
inline FloatOTE* __stdcall Float::New(double fValue)
{
	ASSERT(sizeof(Float) == sizeof(double) + ObjectHeaderSize);

	FloatOTE* newFloatPointer = reinterpret_cast<FloatOTE*>(Interpreter::m_otePools[static_cast<size_t>(Interpreter::Pools::Floats)].newByteObject(Pointers.ClassFloat, sizeof(double), Spaces::Floats));
	ASSERT(ObjectMemory::hasCurrentMark(newFloatPointer));
	ASSERT(newFloatPointer->m_oteClass == Pointers.ClassFloat);
	newFloatPointer->beImmutable();

	Float* newFloat = newFloatPointer->m_location;
	newFloat->m_fValue = fValue;
	return newFloatPointer;
}

///////////////////////////////////////////////////////////////////////////////
//	Float conversion primitives

Oop* __fastcall Interpreter::primitiveAsFloat(Oop* const sp, primargcount_t)
{
	FloatOTE* oteResult = Float::New(ObjectMemoryIntegerValueOf(*sp));
	*sp = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct((OTE*)oteResult);
	return sp;
}

Oop* Interpreter::primitiveFloatTimesTwoPower(Oop* const sp, primargcount_t)
{
	Oop oopArg = *sp;

	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SmallInteger arg = ObjectMemoryIntegerValueOf(oopArg);

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
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

Oop* __fastcall Interpreter::primitiveFloatExponent(Oop* const sp, primargcount_t)
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

Oop* __fastcall Interpreter::primitiveLongDoubleAt(Oop* const sp, primargcount_t)
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

