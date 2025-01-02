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

STDMETHODIMP_(STVarObject*) DolphinSmalltalk::GetVMPointers() 
{
	return reinterpret_cast<STVarObject*>(&Pointers);
}

STDMETHODIMP_(POTE) DolphinSmalltalk::NilPointer()
{
	return (POTE)Pointers.Nil;
}

STDMETHODIMP_(void) DolphinSmalltalk::AddReference(
        /* [in] */ Oop objectPointer)
{
#ifdef _DEBUG
	Interpreter::AddVMReference(objectPointer);
#else
	ObjectMemory::countUp(objectPointer);
#endif
}
    
STDMETHODIMP_(void) DolphinSmalltalk::RemoveReference( 
        /* [in] */ Oop objectPointer)
{
#ifdef _DEBUG
	Interpreter::RemoveVMReference(objectPointer);
#else
	ObjectMemory::countDown(objectPointer);
#endif
}
    
STDMETHODIMP_(POTE) DolphinSmalltalk::FetchClassOf(Oop objectPointer)
{
	return (POTE)ObjectMemory::fetchClassOf(objectPointer);
}
    
STDMETHODIMP_(BOOL) DolphinSmalltalk::InheritsFrom( 
        const POTE behaviorPointer,
        const POTE classPointer)
{
	return ObjectMemory::inheritsFrom((const BehaviorOTE*)behaviorPointer, (const BehaviorOTE*)classPointer);
}
    
STDMETHODIMP_(BOOL) DolphinSmalltalk::IsBehavior( 
        /* [in] */ Oop objectPointer)
{
	return ObjectMemory::isBehavior(objectPointer);
}
    
STDMETHODIMP_(BOOL) DolphinSmalltalk::IsAMetaclass( 
        /* [in] */ const POTE ote)
{
	return ObjectMemory::isAMetaclass(reinterpret_cast<OTE*>(ote));
}
    
STDMETHODIMP_(BOOL) DolphinSmalltalk::IsAClass( 
        /* [in] */ const POTE ote)
{
	return IsAMetaclass(FetchClassOf(reinterpret_cast<Oop>(ote)));
}
    
STDMETHODIMP_(Oop) DolphinSmalltalk::Perform( 
        /* [in] */ Oop receiver,
        /* [in] */ POTE selector)
{
	return ExternaliseRef(Interpreter::perform(receiver, reinterpret_cast<SymbolOTE*>(selector)));
}
    
STDMETHODIMP_(Oop) DolphinSmalltalk::PerformWith( 
        /* [in] */ Oop receiver,
        /* [in] */ POTE selector,
        /* [in] */ Oop arg)
{
	return ExternaliseRef(Interpreter::performWith(receiver, reinterpret_cast<SymbolOTE*>(selector), arg));
}
    
STDMETHODIMP_(Oop) DolphinSmalltalk::PerformWithWith( 
        /* [in] */ Oop receiver,
        /* [in] */ POTE selector,
        /* [in] */ Oop arg1,
        /* [in] */ Oop arg2)
{
	return ExternaliseRef(Interpreter::performWithWith(receiver, reinterpret_cast<SymbolOTE*>(selector), arg1, arg2));
}
    
STDMETHODIMP_(Oop) DolphinSmalltalk::PerformWithWithWith( 
        /* [in] */ Oop receiver,
        /* [in] */ POTE selector,
        /* [in] */ Oop arg1,
        /* [in] */ Oop arg2,
        /* [in] */ Oop arg3)
{
	return ExternaliseRef(Interpreter::performWithWithWith(receiver, reinterpret_cast<SymbolOTE*>(selector), arg1, arg2, arg3));
}
    
STDMETHODIMP_(Oop) DolphinSmalltalk::PerformWithArguments( 
        /* [in] */ Oop receiver,
        /* [in] */ POTE selector,
        /* [in] */ Oop argArray)
{
	return ExternaliseRef(Interpreter::performWithArguments(receiver, reinterpret_cast<SymbolOTE*>(selector), argArray));
}


STDMETHODIMP_(POTE) DolphinSmalltalk::NewObject( 
        /* [in] */ POTE classPointer)
{
	return (POTE)ObjectMemory::newPointerObject(reinterpret_cast<BehaviorOTE*>(classPointer));
}

STDMETHODIMP_(POTE) DolphinSmalltalk::NewObjectWithPointers( 
        /* [in] */ POTE classPointer,
        /* [in] */ unsigned int size)
{
	return (POTE)ObjectMemory::newPointerObject(reinterpret_cast<BehaviorOTE*>(classPointer), size);
}
    
STDMETHODIMP_(POTE) DolphinSmalltalk::NewByteArray( 
        /* [in] */ unsigned int len)
{
	return (POTE)ByteArray::New(len);
}

STDMETHODIMP_(POTE) DolphinSmalltalk::NewString( 
        /* [in] */ LPCSTR szValue,
        /* [in] */ int len)
{
	return (POTE)AnsiString::New(szValue, len == -1 ? strlen(szValue) : len);
}
    
STDMETHODIMP_(POTE) DolphinSmalltalk::NewUtf8String(
	/* [in] */ LPCSTR szValue,
	/* [in] */ int len)
{
	return (POTE)Utf8String::New((const char8_t*)szValue, len == -1 ? strlen(szValue) : len);
}

STDMETHODIMP_(Oop) DolphinSmalltalk::NewSignedInteger( 
        /* [in] */ SDWORD value)
{
	return Integer::NewSigned32(value);
}
    
STDMETHODIMP_(Oop) DolphinSmalltalk::NewUnsignedInteger( 
        /* [in] */ DWORD value)
{
	return Integer::NewUnsigned32(value);
}
    
STDMETHODIMP_(POTE) DolphinSmalltalk::NewCharacter( 
        /* [in] */ DWORD codePoint)
{
	return (POTE)Character::NewUtf32(static_cast<char32_t>(codePoint));
}
    
STDMETHODIMP_(POTE) DolphinSmalltalk::NewArray( 
        /* [in] */ unsigned int size)
{
	return (POTE)Array::New(size);
}
    
STDMETHODIMP_(POTE) DolphinSmalltalk::NewFloat( 
        /* [in] */ double fValue)
{
	return (POTE)Float::New(fValue);
}
    
STDMETHODIMP_(POTE) DolphinSmalltalk::InternSymbol1( 
        /* [in] */ LPCSTR  szName)
{
	return (POTE)Interpreter::NewSymbol((const char8_t*)szName, strlen(szName));
}
    
STDMETHODIMP_(void) DolphinSmalltalk::StorePointerWithValue( 
        /* [out][in] */ Oop  *poopSlot,
        /* [in] */ Oop oopValue)
{
	ObjectMemory::storePointerWithValue(*poopSlot, oopValue);
}
    
STDMETHODIMP_(BOOL) DolphinSmalltalk::DisableInterrupts( 
        /* [in] */ BOOL bDisable)
{
	return Interpreter::disableInterrupts(bDisable?true:false);
}
    
STDMETHODIMP_(int) DolphinSmalltalk::CallbackExceptionFilter( 
        /* [in] */ void  *info)
{
	return Interpreter::callbackExceptionFilter(LPEXCEPTION_POINTERS(info));
}
    
STDMETHODIMP_(void) DolphinSmalltalk::DecodeMethod( 
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

STDMETHODIMP_(STVarObject*) DolphinSmalltalk::GetObj(POTE pote)
{
	return reinterpret_cast<STVarObject*>(reinterpret_cast<OTE*>(pote)->m_location);
}

STDMETHODIMP_(BOOL) DolphinSmalltalk::IsKindOf(Oop objectPointer, const POTE classPointer)
{
	POTE behaviorPointer = FetchClassOf(objectPointer);
	return InheritsFrom(behaviorPointer, classPointer);
}

STDMETHODIMP_(BOOL) DolphinSmalltalk::DisableAsyncGC( 
        /* [in] */ BOOL bDisable)
{
	return Interpreter::disableAsyncGC(bDisable?true:false);
}

STDMETHODIMP_(VOID) DolphinSmalltalk::MakeImmutable( 
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

STDMETHODIMP_(BOOL) DolphinSmalltalk::IsImmutable( 
		/* [in] */ Oop oop)
{
	return isIntegerObject(oop) || (reinterpret_cast<OTE*>(oop)->isImmutable());
}

STDMETHODIMP_(BSTR) DolphinSmalltalk::DebugPrintString(
		/* [in] */ Oop oop)
{
	std::wstring str = Interpreter::PrintString(oop);
	return SysAllocString(str.c_str());
}

STDMETHODIMP_(POTE) DolphinSmalltalk::NewBindingRef(/* [in] */ const char8_t*  qualifiedName, /* [in] */int length, /* [in] */Oop context, /* [in] */ BindingReferenceFlags flags)
{
    return reinterpret_cast<POTE>(PerformWithWithWith((Oop)Pointers.ClassBindingReference, 
        Pointers.newBindingRefSelector, 
        (Oop)Utf8String::New(qualifiedName, length < 0 ? strlen((LPCSTR)qualifiedName) : length), context, ObjectMemoryIntegerObjectOf(static_cast<unsigned>(flags))));
}

STDMETHODIMP_(POTE) DolphinSmalltalk::InternSymbol(
	/* [in] */ const char8_t*  name,
	/* [in] */ int length)
{
	return (POTE)Interpreter::NewSymbol(name, length < 0 ? strlen((LPCSTR)name) : length);
}
