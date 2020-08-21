#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "ist.h"

#include "rc_vm.h"
#include "DolphinSmalltalk_i.h"
#include "DolphinSmalltalk.h"

#include "ote.h"
#include "VMPointers.h"

#undef MinSmallInteger
#undef MaxSmallInteger

#include "ObjMem.h"
#define _STMETHODHEADER_H_
#include "Interprt.h"

#include "STObject.h"
#include "STByteArray.h"
#include "STCharacter.h"

CDolphinSmalltalk::CDolphinSmalltalk()
{
}

CDolphinSmalltalk::~CDolphinSmalltalk()
{
}

static Oop ExternaliseRef(Oop oop)
{
#ifdef _DEBUG
	Interpreter::AddVMReference(oop);
	ObjectMemory::countDown(oop);
#endif
	return oop;
}

/////////////////////////////////////////////////////////////////////
// IDolphin

STDMETHODIMP_(STVarObject*) CDolphinSmalltalk::GetVMPointers() 
{
	return reinterpret_cast<STVarObject*>(&Pointers);
}

STDMETHODIMP_(POTE) CDolphinSmalltalk::NilPointer()
{
	return (POTE)Pointers.Nil;
}

STDMETHODIMP_(void) CDolphinSmalltalk::AddReference(
        /* [in] */ Oop objectPointer)
{
#ifdef _DEBUG
	Interpreter::AddVMReference(objectPointer);
#else
	ObjectMemory::countUp(objectPointer);
#endif
}
    
STDMETHODIMP_(void) CDolphinSmalltalk::RemoveReference( 
        /* [in] */ Oop objectPointer)
{
#ifdef _DEBUG
	Interpreter::RemoveVMReference(objectPointer);
#else
	ObjectMemory::countDown(objectPointer);
#endif
}
    
STDMETHODIMP_(POTE) CDolphinSmalltalk::FetchClassOf(Oop objectPointer)
{
	return (POTE)ObjectMemory::fetchClassOf(objectPointer);
}
    
STDMETHODIMP_(BOOL) CDolphinSmalltalk::InheritsFrom( 
        const POTE behaviorPointer,
        const POTE classPointer)
{
	return ObjectMemory::inheritsFrom((const BehaviorOTE*)behaviorPointer, (const BehaviorOTE*)classPointer);
}
    
STDMETHODIMP_(BOOL) CDolphinSmalltalk::IsBehavior( 
        /* [in] */ Oop objectPointer)
{
	return ObjectMemory::isBehavior(objectPointer);
}
    
STDMETHODIMP_(BOOL) CDolphinSmalltalk::IsAMetaclass( 
        /* [in] */ const POTE ote)
{
	return ObjectMemory::isAMetaclass(reinterpret_cast<OTE*>(ote));
}
    
STDMETHODIMP_(BOOL) CDolphinSmalltalk::IsAClass( 
        /* [in] */ const POTE ote)
{
	return IsAMetaclass(FetchClassOf(reinterpret_cast<Oop>(ote)));
}
    
STDMETHODIMP_(Oop) CDolphinSmalltalk::Perform( 
        /* [in] */ Oop receiver,
        /* [in] */ POTE selector)
{
	return ExternaliseRef(Interpreter::perform(receiver, reinterpret_cast<SymbolOTE*>(selector)));
}
    
STDMETHODIMP_(Oop) CDolphinSmalltalk::PerformWith( 
        /* [in] */ Oop receiver,
        /* [in] */ POTE selector,
        /* [in] */ Oop arg)
{
	return ExternaliseRef(Interpreter::performWith(receiver, reinterpret_cast<SymbolOTE*>(selector), arg));
}
    
STDMETHODIMP_(Oop) CDolphinSmalltalk::PerformWithWith( 
        /* [in] */ Oop receiver,
        /* [in] */ POTE selector,
        /* [in] */ Oop arg1,
        /* [in] */ Oop arg2)
{
	return ExternaliseRef(Interpreter::performWithWith(receiver, reinterpret_cast<SymbolOTE*>(selector), arg1, arg2));
}
    
STDMETHODIMP_(Oop) CDolphinSmalltalk::PerformWithWithWith( 
        /* [in] */ Oop receiver,
        /* [in] */ POTE selector,
        /* [in] */ Oop arg1,
        /* [in] */ Oop arg2,
        /* [in] */ Oop arg3)
{
	return ExternaliseRef(Interpreter::performWithWithWith(receiver, reinterpret_cast<SymbolOTE*>(selector), arg1, arg2, arg3));
}
    
STDMETHODIMP_(Oop) CDolphinSmalltalk::PerformWithArguments( 
        /* [in] */ Oop receiver,
        /* [in] */ POTE selector,
        /* [in] */ Oop argArray)
{
	return ExternaliseRef(Interpreter::performWithArguments(receiver, reinterpret_cast<SymbolOTE*>(selector), argArray));
}


STDMETHODIMP_(POTE) CDolphinSmalltalk::NewObject( 
        /* [in] */ POTE classPointer)
{
	return (POTE)ObjectMemory::newPointerObject(reinterpret_cast<BehaviorOTE*>(classPointer));
}

STDMETHODIMP_(POTE) CDolphinSmalltalk::NewObjectWithPointers( 
        /* [in] */ POTE classPointer,
        /* [in] */ unsigned int size)
{
	return (POTE)ObjectMemory::newPointerObject(reinterpret_cast<BehaviorOTE*>(classPointer), size);
}
    
STDMETHODIMP_(POTE) CDolphinSmalltalk::NewByteArray( 
        /* [in] */ unsigned int len)
{
	return (POTE)ByteArray::New(len);
}

STDMETHODIMP_(POTE) CDolphinSmalltalk::NewString( 
        /* [in] */ LPCSTR szValue,
        /* [in] */ int len)
{
	return (POTE)AnsiString::New(szValue, len=-1?strlen(szValue):len);
}
    
STDMETHODIMP_(POTE) CDolphinSmalltalk::NewUtf8String(
	/* [in] */ LPCSTR szValue,
	/* [in] */ int len)
{
	return (POTE)Utf8String::New(szValue, len = -1 ? strlen(szValue) : len);
}

STDMETHODIMP_(Oop) CDolphinSmalltalk::NewSignedInteger( 
        /* [in] */ SDWORD value)
{
	return Integer::NewSigned32(value);
}
    
STDMETHODIMP_(Oop) CDolphinSmalltalk::NewUnsignedInteger( 
        /* [in] */ DWORD value)
{
	return Integer::NewUnsigned32(value);
}
    
STDMETHODIMP_(POTE) CDolphinSmalltalk::NewCharacter( 
        /* [in] */ DWORD codePoint)
{
	return (POTE)Character::NewUnicode(static_cast<char32_t>(codePoint));
}
    
STDMETHODIMP_(POTE) CDolphinSmalltalk::NewArray( 
        /* [in] */ unsigned int size)
{
	return (POTE)Array::New(size);
}
    
STDMETHODIMP_(POTE) CDolphinSmalltalk::NewFloat( 
        /* [in] */ double fValue)
{
	return (POTE)Float::New(fValue);
}
    
STDMETHODIMP_(POTE) CDolphinSmalltalk::InternSymbol( 
        /* [in] */ LPCSTR  szName)
{
	return (POTE)Interpreter::NewSymbol(szName);
}
    
STDMETHODIMP_(void) CDolphinSmalltalk::StorePointerWithValue( 
        /* [out][in] */ Oop  *poopSlot,
        /* [in] */ Oop oopValue)
{
	ObjectMemory::storePointerWithValue(*poopSlot, oopValue);
}
    
STDMETHODIMP_(BOOL) CDolphinSmalltalk::DisableInterrupts( 
        /* [in] */ BOOL bDisable)
{
	return Interpreter::disableInterrupts(bDisable?true:false);
}
    
STDMETHODIMP_(int) CDolphinSmalltalk::CallbackExceptionFilter( 
        /* [in] */ void  *info)
{
	return Interpreter::callbackExceptionFilter(LPEXCEPTION_POINTERS(info));
}
    
STDMETHODIMP_(void) CDolphinSmalltalk::DecodeMethod( 
        POTE methodPointer,
        void *pstream)
{
#ifdef _DEBUG
	Interpreter::decodeMethod(reinterpret_cast<MethodOTE*>(methodPointer)->m_location, 
			reinterpret_cast<std::wostream*>(pstream));
#else
	UNREFERENCED_PARAMETER(methodPointer);
	UNREFERENCED_PARAMETER(pstream);
#endif
}

STDMETHODIMP_(STVarObject*) CDolphinSmalltalk::GetObj(POTE pote)
{
	return reinterpret_cast<STVarObject*>(reinterpret_cast<OTE*>(pote)->m_location);
}

STDMETHODIMP_(BOOL) CDolphinSmalltalk::IsKindOf(Oop objectPointer, const POTE classPointer)
{
	POTE behaviorPointer = FetchClassOf(objectPointer);
	return InheritsFrom(behaviorPointer, classPointer);
}

STDMETHODIMP_(BOOL) CDolphinSmalltalk::DisableAsyncGC( 
        /* [in] */ BOOL bDisable)
{
	return Interpreter::disableAsyncGC(bDisable?true:false);
}

STDMETHODIMP_(VOID) CDolphinSmalltalk::MakeImmutable( 
		/* [in] */ Oop oop,
        /* [in] */ BOOL bImmutable)
{
	if (isIntegerObject(oop))
		return;

	if (bImmutable)
		reinterpret_cast<OTE*>(oop)->beImmutable();
	else
		reinterpret_cast<OTE*>(oop)->beMutable();
}

STDMETHODIMP_(BOOL) CDolphinSmalltalk::IsImmutable( 
		/* [in] */ Oop oop)
{
	return isIntegerObject(oop) || (reinterpret_cast<OTE*>(oop)->isImmutable());
}

STDMETHODIMP_(BSTR) CDolphinSmalltalk::DebugPrintString(
		/* [in] */ Oop oop)
{
	std::wstring str = Interpreter::PrintString(oop);
	return SysAllocString(str.c_str());
}

STDMETHODIMP_(POTE) CDolphinSmalltalk::NewBindingRef(/* [in] */ LPCSTR  szQualifiedName, /* [in] */Oop context, /* [in] */ BindingReferenceFlags flags)
{
    return (POTE)PerformWithWithWith((Oop)Pointers.ClassBindingReference, 
        Pointers.newBindingRefSelector, 
        (Oop)Utf8String::New(szQualifiedName), context, ObjectMemoryIntegerObjectOf(static_cast<unsigned>(flags)));
}

