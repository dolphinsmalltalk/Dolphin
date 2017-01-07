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

#include <string.h>
#include <math.h>
#include <float.h>
#include <limits.h>
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

#ifdef _DEBUG
	int __cdecl _matherr( struct _exception *except )
	{
		_asm int 3;
		return 0;
	}
#endif

// Just allocs the space for a new float
FloatOTE* __stdcall Float::New()
{
	ASSERT(sizeof(Float) == sizeof(double)+ObjectHeaderSize);

	FloatOTE* newFloatPointer = reinterpret_cast<FloatOTE*>(Interpreter::m_otePools[Interpreter::FLOATPOOL].newByteObject(Pointers.ClassFloat, sizeof(double), OTEFlags::FloatSpace));
	ASSERT(newFloatPointer->hasCurrentMark());
	ASSERT(newFloatPointer->m_oteClass == Pointers.ClassFloat);

	return newFloatPointer;
}

// Allocates and sets the value of a new float
FloatOTE* __stdcall Float::New(double fValue)
{
	FloatOTE* newFloatPointer = New();
	Float* newFloat = newFloatPointer->m_location;
	newFloat->m_fValue = fValue;
	newFloatPointer->beImmutable();
	return newFloatPointer;
}

///////////////////////////////////////////////////////////////////////////////
//	Float primitives

Oop* __fastcall Interpreter::primitiveAsFloat()
{
	Oop* const sp = m_registers.m_stackPointer;

	FloatOTE* oteResult = Float::New(ObjectMemoryIntegerValueOf(*sp));
	*sp = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct(oteResult);
	return sp;
}

// We need to be careful here - C semantics for truncation are too
// crude; we must check that the receiver is representable in 30
// or 31 bits
Oop* __fastcall Interpreter::primitiveTruncated()
{
	Oop* const sp = m_registers.m_stackPointer;

	// This primitive should only be called from the Float class and so does not
	// check that the receiver is a float
	FloatOTE* oteFloat = reinterpret_cast<FloatOTE*>(*sp);
	ASSERT(isAFloat(Oop(oteFloat)));
	Float* floatReceiver = oteFloat->m_location;

	double fValue = floatReceiver->m_fValue;

	if (fValue < MinSmallInteger || fValue > MaxSmallInteger)
	{
		// It's going to have to be a LargeInteger...
		if (fValue > double(_I64_MIN) && fValue < double(_I64_MAX))
		{
			// ... representable in 64-bits
			LONGLONG liTrunc = static_cast<LONGLONG>(fValue);
			Oop truncated = Integer::NewSigned64(liTrunc);
			*sp = truncated;
			ObjectMemory::AddToZct(reinterpret_cast<OTE*>(truncated));
		}
		else
			return primitiveFailure(1);
	}
	else
	{
		int intVal = static_cast<int>(fValue);
		*sp = ObjectMemoryIntegerObjectOf(intVal);
	}

	return sp;
}

Oop* Interpreter::primitiveFloatLessThan()
{
	Oop* const sp = m_registers.m_stackPointer;

	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*(sp - 1));
	Oop oopArg = *sp;
	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		ASSERT(isAFloat(Oop(oteReceiver)));
		*(sp - 1) = reinterpret_cast<Oop>(oteReceiver->m_location->m_fValue < ObjectMemoryIntegerValueOf(oopArg)
			? Pointers.True : Pointers.False);
	}
	else
	{
		FloatOTE* oteArg = reinterpret_cast<FloatOTE*>(oopArg);
		if (oteArg->m_oteClass != Pointers.ClassFloat)
		{
			return NULL;
		}
		*(sp - 1) = reinterpret_cast<Oop>(oteReceiver->m_location->m_fValue < oteArg->m_location->m_fValue
			? Pointers.True : Pointers.False);
	}
	return sp - 1;
}

Oop* Interpreter::primitiveFloatGreaterThan()
{
	Oop* const sp = m_registers.m_stackPointer;

	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*(sp - 1));
	Oop oopArg = *sp;
	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		ASSERT(isAFloat(Oop(oteReceiver)));
		*(sp - 1) = reinterpret_cast<Oop>(oteReceiver->m_location->m_fValue > ObjectMemoryIntegerValueOf(oopArg)
			? Pointers.True : Pointers.False);
	}
	else
	{
		FloatOTE* oteArg = reinterpret_cast<FloatOTE*>(oopArg);
		if (oteArg->m_oteClass != Pointers.ClassFloat)
		{
			return NULL;
		}
		*(sp - 1) = reinterpret_cast<Oop>(oteReceiver->m_location->m_fValue > oteArg->m_location->m_fValue
			? Pointers.True : Pointers.False);
	}
	return sp - 1;
}

Oop* Interpreter::primitiveFloatEqual()
{
	Oop* const sp = m_registers.m_stackPointer;

	FloatOTE* oteReceiver = reinterpret_cast<FloatOTE*>(*(sp - 1));
	Oop oopArg = *sp;
	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		ASSERT(isAFloat(Oop(oteReceiver)));
		*(sp - 1) = reinterpret_cast<Oop>(oteReceiver->m_location->m_fValue == ObjectMemoryIntegerValueOf(oopArg)
			? Pointers.True : Pointers.False);
	}
	else
	{
		FloatOTE* oteArg = reinterpret_cast<FloatOTE*>(oopArg);
		if (oteArg->m_oteClass != Pointers.ClassFloat)
		{
			return NULL;
		}
		*(sp - 1) = reinterpret_cast<Oop>(oteReceiver->m_location->m_fValue == oteArg->m_location->m_fValue
			? Pointers.True : Pointers.False);
	}
	return sp - 1;
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

Oop* __fastcall Interpreter::primitiveDoublePrecisionFloatAt()
{
	Oop* const sp = m_registers.m_stackPointer;

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
	FloatOTE* oteResult = Float::New();
	Behavior* behavior = receiver->m_oteClass->m_location;
	Float* result = oteResult->m_location;
	if (behavior->isIndirect())
	{
		ExternalAddress* ptr = static_cast<ExternalAddress*>(receiver->m_location);
		result->m_fValue = *reinterpret_cast<double*>(static_cast<BYTE*>(ptr->m_pointer)+offset);
	}
	else
	{
		BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(receiver);

		// We can check that the offset is in bounds
		if (static_cast<int>(offset) < 0 ||	offset+sizeof(double) > oteBytes->bytesSize())
			return primitiveFailure(PrimitiveFailureBoundsError);	// Out of bounds

		VariantByteObject* bytes = oteBytes->m_location;
		result->m_fValue = *reinterpret_cast<double*>(&(bytes->m_fields[offset]));
	}

	oteResult->beImmutable();
	*(sp - 1) = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteResult));
	return sp - 1;
}


Oop* __fastcall Interpreter::primitiveSinglePrecisionFloatAt()
{
	Oop* const sp = m_registers.m_stackPointer;

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
	FloatOTE* oteResult = Float::New();
	Behavior* behavior = receiver->m_oteClass->m_location;
	Float* result = oteResult->m_location;
	if (behavior->isIndirect())
	{
		ExternalAddress* ptr = static_cast<ExternalAddress*>(receiver->m_location);
		result->m_fValue = *reinterpret_cast<float*>(static_cast<BYTE*>(ptr->m_pointer)+offset);
	}
	else
	{
		BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(receiver);

		// We can check that the offset is in bounds
		if (static_cast<int>(offset) < 0 || offset+sizeof(float) > oteBytes->bytesSize())
			return primitiveFailure(PrimitiveFailureBoundsError);	// Out of bounds

		VariantByteObject* bytes = oteBytes->m_location;
		result->m_fValue = *reinterpret_cast<float*>(&(bytes->m_fields[offset]));
	}

	oteResult->beImmutable();
	*(sp - 1) = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteResult));
	return sp - 1;
}


Oop* __fastcall Interpreter::primitiveDoublePrecisionFloatAtPut()
{
	Oop* const sp = m_registers.m_stackPointer;

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


Oop* __fastcall Interpreter::primitiveSinglePrecisionFloatAtPut()
{
	Oop* const sp = m_registers.m_stackPointer;

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

Oop* __fastcall Interpreter::primitiveLongDoubleAt()
{
	Oop* const sp = m_registers.m_stackPointer;
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
	*(sp - 1) = reinterpret_cast<Oop>(oteResult);
	ObjectMemory::AddToZct(reinterpret_cast<OTE*>(oteResult));
	return sp - 1;
}

