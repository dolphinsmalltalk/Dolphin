/******************************************************************************

	File: OLEPrim.cpp

	Description:

******************************************************************************/
#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include <string.h>
#include "ObjMem.h"
#include "Interprt.h"
#include "rc_vm.h"
#include "InterprtPrim.inl"

// Smalltalk classes
#include "STByteArray.h"
#include "STExternal.h"
#include "STBehavior.h"

static BOOL AnswerNewStructure(BehaviorOTE* oteClass, void* ptr)
{
	if (oteClass->isNil())
		return Interpreter::primitiveFailure(4);

	Interpreter::replaceStackTopWithNew(ExternalStructure::New(oteClass, ptr));
	return primitiveSuccess();
}

static BOOL AnswerNewInterfacePointer(BehaviorOTE* oteClass, IUnknown* punk)
{
	if (oteClass->isNil())
		return Interpreter::primitiveFailure(4);

	if (punk)
		punk->AddRef();

	OTE* poteUnk = ExternalStructure::NewPointer(oteClass, punk);
	poteUnk->beFinalizable();
	Interpreter::replaceStackTopWithNew(poteUnk);
	return primitiveSuccess();
}

// Answer an array of allInstances of the receiver.
// Fails if receiver is not a Class/MetaClass
// No effect on stack pointer, and doesn't use successFlag.
// No arguments, so leaves a clean stack (no ref. counted objects above stack top).
BOOL __fastcall Interpreter::primitiveVariantValue()
{
	StructureOTE* oteReceiver = reinterpret_cast<StructureOTE*>stackTop();
	ExternalStructure* objVariant = oteReceiver->m_location;

	BytesOTE* oteContents = objVariant->m_contents;
	if (isIntegerObject(oteContents) || !oteContents->isBytes())
		// Badly formed
		return primitiveFailure(0);


	BehaviorOTE* oteBehaviour = oteContents->m_oteClass;
	Behavior* behaviour = oteBehaviour->m_location;
	VARIANT* pVar;
	if (behaviour->isIndirect())
	{
		ExternalAddress* addr = reinterpret_cast<ExternalAddress*>(oteContents->m_location);
		pVar = reinterpret_cast<VARIANT*>(addr->m_pointer);
		if (pVar == NULL)
			return primitiveFailure(1);
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
			return primitiveFailure(3);
			break;
		}

		if (oteStructClass == reinterpret_cast<BehaviorOTE*>(Pointers.Nil))
			return primitiveFailure(4);

		replaceStackTopWithNew(ExternalStructure::NewPointer(oteStructClass, pRef));
	}
	else
	{
		switch(vt)
		{
		case VT_NULL:
		case VT_EMPTY:
			replaceStackTopWith(Pointers.Nil);
			break;

		case VT_I1:
			{
				SDWORD i1 = V_I1(pVar);
				replaceStackTopWith(ObjectMemoryIntegerObjectOf(i1));
			}
			break;

		case VT_I2:
			{
				SDWORD i2 = V_I2(pVar);
				replaceStackTopWith(ObjectMemoryIntegerObjectOf(i2));
			}
			break;

		case VT_INT:
		case VT_I4:
			replaceStackTopWithNew(Integer::NewSigned32(V_I4(pVar)));
			break;

		case VT_I8:
			replaceStackTopWithNew(LargeInteger::NewSigned64(V_I8(pVar)));
			break;

		case VT_R4:
			replaceStackTopWithNew(V_R4(pVar));
			break;

		case VT_R8:
			replaceStackTopWithNew(V_R8(pVar));
			break;


		case VT_BSTR:
			replaceStackTopWithNew(String::NewFromBSTR(V_BSTR(pVar)));
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
			replaceStackTopWith(reinterpret_cast<Oop>(V_BOOL(pVar) ? Pointers.True : Pointers.False));
			break;

		case VT_UI1:
			{
				DWORD ui1 = V_UI1(pVar);
				replaceStackTopWith(ObjectMemoryIntegerObjectOf(ui1));
			}
			break;
		
		case VT_UI2:
			{
				DWORD ui2 = V_UI2(pVar);
				replaceStackTopWith(ObjectMemoryIntegerObjectOf(ui2));
			}
			break;

		case VT_UINT:
		case VT_UI4:
			replaceStackTopWithNew(Integer::NewUnsigned32(V_UI4(pVar)));
			break;

		case VT_UI8:
			replaceStackTopWithNew(LargeInteger::NewUnsigned64(V_UI8(pVar)));
			break;

		case VT_CY:
		case VT_DECIMAL:
			// These are represented as ScaledDecimals, the format of which is subject to change, so
			// we'll let the Smalltalk code handle it.

		case VT_ERROR:
			// Needs to be an HRESULT, and we don't ref. that class from the VM's pointer table

		default:
			// Anything else, we'll leave the error handling to the image
			return primitiveFailure(3);
			break;
		}
	}

	return primitiveSuccess();
}