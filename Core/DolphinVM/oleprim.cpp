/******************************************************************************

	File: OLEPrim.cpp

	Description:

******************************************************************************/
#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "rc_vm.h"
#include "InterprtPrim.inl"

// Smalltalk classes
#include "STByteArray.h"
#include "STExternal.h"
#include "STBehavior.h"

static Oop* AnswerNewStructure(BehaviorOTE* oteClass, void* ptr)
{
	if (isNil(oteClass))
	{
		return Interpreter::primitiveFailure(_PrimitiveFailureCode::ClassNotRegistered);
	}

	OTE* oteStruct = ExternalStructure::New(oteClass, ptr);
	Oop* const sp = Interpreter::m_registers.m_stackPointer;
	*sp = reinterpret_cast<Oop>(oteStruct);
	ObjectMemory::AddToZct(oteStruct);
	return sp;
}

static Oop* AnswerNewInterfacePointer(BehaviorOTE* oteClass, IUnknown* punk)
{
	if (isNil(oteClass))
	{
		return Interpreter::primitiveFailure(_PrimitiveFailureCode::ClassNotRegistered);
	}

	if (punk)
	{
		punk->AddRef();
	}

	OTE* poteUnk = ExternalStructure::NewPointer(oteClass, punk);
	poteUnk->beFinalizable();
	Oop* const sp = Interpreter::m_registers.m_stackPointer;
	*sp = reinterpret_cast<Oop>(poteUnk);
	ObjectMemory::AddToZct(poteUnk);
	return sp;
}

Oop* PRIMCALL Interpreter::primitiveVariantValue(Oop* const sp, primargcount_t)
{
	StructureOTE* oteReceiver = reinterpret_cast<StructureOTE*>(*sp);
	ExternalStructure* objVariant = oteReceiver->m_location;

	BytesOTE* oteContents = objVariant->m_contents;
	if (isIntegerObject(oteContents) || !oteContents->isBytes())
		// Badly formed
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);


	BehaviorOTE* oteBehaviour = oteContents->m_oteClass;
	Behavior* behaviour = oteBehaviour->m_location;
	VARIANT* pVar;
	if (behaviour->isIndirect())
	{
		ExternalAddress* addr = reinterpret_cast<ExternalAddress*>(oteContents->m_location);
		pVar = reinterpret_cast<VARIANT*>(addr->m_pointer);
		if (pVar == NULL)
			return primitiveFailure(_PrimitiveFailureCode::InvalidPointer);
	}
	else
		pVar = reinterpret_cast<VARIANT*>(oteContents->m_location->m_fields);

	VARTYPE vt = V_VT(pVar);

	if (vt & VT_BYREF)
	{
		BehaviorOTE* oteStructClass;
		void* pRef;

		switch(vt & ~VT_BYREF)
		{
		case VT_I1:
			oteStructClass = Pointers.ClassSBYTE;
			pRef = V_I1REF(pVar);
			break;

		case VT_I2:
			oteStructClass = Pointers.ClassSWORD;
			pRef = V_I2REF(pVar);
			break;

		case VT_INT:
		case VT_I4:
			oteStructClass = Pointers.ClassSDWORD;
			pRef = V_I4REF(pVar);
			break;

		case VT_I8:
			oteStructClass = Pointers.ClassSQWORD;
			pRef = V_I8REF(pVar);
			break;

		case VT_R4:
			oteStructClass = Pointers.ClassFLOAT;
			pRef = V_R4REF(pVar);
			break;

		case VT_R8:
			oteStructClass = Pointers.ClassDOUBLE;
			pRef = V_R8REF(pVar);
			break;

		case VT_BSTR:
			oteStructClass = Pointers.ClassLPBSTR;
			pRef = V_BSTRREF(pVar);
			break;

		case VT_DATE:
			oteStructClass = Pointers.ClassDATE;
			pRef = V_DATEREF(pVar);
			break;

		case VT_DISPATCH:
			oteStructClass = Pointers.ClassLPVOID;
			pRef = V_DISPATCHREF(pVar);
			break;

		case VT_UNKNOWN:
			oteStructClass = Pointers.ClassLPVOID;
			pRef = V_UNKNOWNREF(pVar);
			break;

		case VT_BOOL:
			oteStructClass = Pointers.ClassVARBOOL;
			pRef = V_BOOLREF(pVar);
			break;

		case VT_UI1:
			oteStructClass = Pointers.ClassBYTE;
			pRef = V_UI1REF(pVar);
			break;
		
		case VT_UI2:
			oteStructClass = Pointers.ClassWORD;
			pRef = V_UI2REF(pVar);
			break;

		case VT_UINT:
		case VT_UI4:
			oteStructClass = Pointers.ClassDWORD;
			pRef = V_UI4REF(pVar);
			break;

		case VT_UI8:
			oteStructClass = Pointers.ClassQWORD;
			pRef = V_UI8REF(pVar);
			break;

		case VT_CY:
			oteStructClass = Pointers.ClassCURRENCY;
			pRef = V_CYREF(pVar);
			break;

		case VT_DECIMAL:
			oteStructClass = Pointers.ClassDECIMAL;
			pRef = V_DECIMALREF(pVar);
			break;

		case VT_VARIANT:
			oteStructClass = Pointers.ClassVARIANT;
			pRef = V_VARIANTREF(pVar);
			break;

		case VT_ERROR:
		default:
			// Anything else, we'll leave the error handling to the image
			return primitiveFailure(_PrimitiveFailureCode::InvalidVariant);
			break;
		}

		if (oteStructClass == reinterpret_cast<BehaviorOTE*>(Pointers.Nil))
			return primitiveFailure(_PrimitiveFailureCode::ClassNotRegistered);

		OTE* oteRef = ExternalStructure::NewPointer(oteStructClass, pRef);

		*sp = reinterpret_cast<Oop>(oteRef);
		ObjectMemory::AddToZct(oteRef);
		return sp;
	}
	else
	{
		Oop value;

		switch(vt)
		{
		case VT_NULL:
		case VT_EMPTY:
			value = reinterpret_cast<Oop>(Pointers.Nil);
			break;

		case VT_I1:
			{
				SmallInteger i1 = V_I1(pVar);
				value = ObjectMemoryIntegerObjectOf(i1);
			}
			break;

		case VT_I2:
			{
				SmallInteger i2 = V_I2(pVar);
				value = ObjectMemoryIntegerObjectOf(i2);
			}
			break;

		case VT_INT:
		case VT_I4:
			value = Integer::NewSigned32(V_I4(pVar));
			break;

		case VT_I8:
			value = LargeInteger::NewSigned64(V_I8(pVar));
			break;

		case VT_R4:
			value = reinterpret_cast<Oop>(Float::New(V_R4(pVar)));
			break;

		case VT_R8:
			value = reinterpret_cast<Oop>(Float::New(V_R8(pVar)));
			break;

		case VT_BSTR:
			value = reinterpret_cast<Oop>(Utf16String::NewFromBSTR(V_BSTR(pVar)));
			break;

		case VT_DATE:
			return AnswerNewStructure(Pointers.ClassDATE, &(V_DATE(pVar)));
			break;

		case VT_DISPATCH:
			{
				IDispatch* pdisp = V_DISPATCH(pVar);
				return AnswerNewInterfacePointer(Pointers.ClassIDispatch, pdisp);
			}
			break;

		case VT_UNKNOWN:
			{
				IUnknown* punk= V_UNKNOWN(pVar);
				return AnswerNewInterfacePointer(Pointers.ClassIUnknown, punk);
			}
			break;

		case VT_BOOL:
			value = reinterpret_cast<Oop>(V_BOOL(pVar) ? Pointers.True : Pointers.False);
			break;

		case VT_UI1:
			{
				SmallUinteger ui1 = V_UI1(pVar);
				value = ObjectMemoryIntegerObjectOf(ui1);
			}
			break;
		
		case VT_UI2:
			{
				SmallUinteger ui2 = V_UI2(pVar);
				value = ObjectMemoryIntegerObjectOf(ui2);
			}
			break;

		case VT_UINT:
		case VT_UI4:
			value = Integer::NewUnsigned32(V_UI4(pVar));
			break;

		case VT_UI8:
			value = LargeInteger::NewUnsigned64(V_UI8(pVar));
			break;

		case VT_CY:
		case VT_DECIMAL:
			// These are represented as ScaledDecimals, the format of which is subject to change, so
			// we'll let the Smalltalk code handle it.

		case VT_ERROR:
			// Needs to be an HRESULT, and we don't ref. that class from the VM's pointer table

		default:
			// Anything else, we'll leave the error handling to the image
			return primitiveFailure(_PrimitiveFailureCode::InvalidVariant);
			break;
		}

		// Note that we must write the object to the stack before adding to the ZCT, as if the 
		// ZCT overflows the object would otherwise be freed.
		*sp = value;
		ObjectMemory::AddOopToZct(value);
		return sp;
	}
}