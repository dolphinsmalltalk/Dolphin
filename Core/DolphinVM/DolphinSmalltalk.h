// DolphinSmalltalk.h : Declaration of the CDolphinSmalltalk
#pragma once

#ifndef USE_VM_DLL

#include "DolphinSmalltalk_i.h"
#include "rc_vm.h"

#include <combaseapi.h>
#include "ComObject.h"

constexpr WCHAR const DolphinProgId[] = L"Dolphin.Smalltalk.8";
constexpr WCHAR const DolphinVerIndProgId[] = L"Dolphin.Smalltalk";
constexpr WCHAR const EventLogKeyName[] = L"Dolphin";

typedef ComRegistrationDetails<DolphinProgId, DolphinVerIndProgId, IDS_APP_TITLE, EventLogKeyName> DolphinRegDetails;

/////////////////////////////////////////////////////////////////////////////
// CDolphinSmalltalk
class DolphinSmalltalk : 
	public ComObject<DolphinRegDetails, ComObjectBase, IDolphin, IDolphinStart >
{
public:
	DolphinSmalltalk() = default;
	~DolphinSmalltalk() = default;

// IDolphinStart
public:
	STDMETHOD(Initialise)(/*[in]*/HINSTANCE hInstance,
		/*[in]*/LPCSTR szImageName, /*[in]*/LPVOID pImageData, /*[in]*/UINT cImageSize, DWORD dwFlags);
	STDMETHOD(Run)(/*[in]*/IUnknown* punkOuter);
	STDMETHOD(GetVersionInfo)(/*[out]*/LPVOID);

// IDolphinStart4
	STDMETHOD(Initialise)(/*[in]*/HINSTANCE hInstance,
		/*[in]*/LPCWSTR szImageName, /*[in]*/LPVOID pImageData, /*[in]*/UINT cImageSize, DWORD dwFlags);

// IDolphin
public:
	STDMETHOD_(STVarObject*, GetVMPointers)(); 
    STDMETHOD_(POTE, NilPointer)();
	STDMETHOD_(void, AddReference)(/* [in] */ Oop objectPointer);
	STDMETHOD_(void, RemoveReference)(/* [in] */ Oop objectPointer);
        
	STDMETHOD_(POTE, FetchClassOf)(/* [in] */ Oop objectPointer);
        
	STDMETHOD_(BOOL, InheritsFrom)( 
            const POTE behaviorPointer,
            const POTE classPointer);
        
	STDMETHOD_(BOOL, IsBehavior)( 
            /* [in] */ Oop objectPointer);
        
	STDMETHOD_(BOOL, IsAMetaclass)( 
            /* [in] */ const POTE ote);
        
	STDMETHOD_(BOOL, IsAClass)( 
            /* [in] */ const POTE ote);
        
	STDMETHOD_(Oop, Perform)( 
            /* [in] */ Oop receiver,
            /* [in] */ POTE selector);
        
	STDMETHOD_(Oop, PerformWith)( 
            /* [in] */ Oop receiver,
            /* [in] */ POTE selector,
            /* [in] */ Oop arg);
        
	STDMETHOD_(Oop, PerformWithWith)( 
            /* [in] */ Oop receiver,
            /* [in] */ POTE selector,
            /* [in] */ Oop arg1,
            /* [in] */ Oop arg2);
        
	STDMETHOD_(Oop, PerformWithWithWith)( 
            /* [in] */ Oop receiver,
            /* [in] */ POTE selector,
            /* [in] */ Oop arg1,
            /* [in] */ Oop arg2,
            /* [in] */ Oop arg3);
        
	STDMETHOD_(Oop, PerformWithArguments)( 
            /* [in] */ Oop receiver,
            /* [in] */ POTE selector,
            /* [in] */ Oop argArray);
        
	STDMETHOD_(POTE, NewObject)( 
            /* [in] */ POTE classPointer);
        
	STDMETHOD_(POTE, NewObjectWithPointers)( 
            /* [in] */ POTE classPointer,
            /* [in] */ unsigned int size);
        
	STDMETHOD_(POTE, NewByteArray)( 
            /* [in] */ unsigned int len);
        
	STDMETHOD_(POTE, NewString)( 
            /* [in] */ LPCSTR szValue,
            /* [in] */ int len);
 
	STDMETHOD_(Oop, NewSignedInteger)( 
            /* [in] */ SDWORD value);
        
	STDMETHOD_(Oop, NewUnsignedInteger)( 
            /* [in] */ DWORD value);
        
	STDMETHOD_(POTE, NewCharacter)( 
            /* [in] */ DWORD value);
        
	STDMETHOD_(POTE, NewArray)( 
            /* [in] */ unsigned int size);
        
	STDMETHOD_(POTE, NewFloat)( 
		/* [in] */ double fValue);
        
	STDMETHOD_(POTE, InternSymbol1)( 
            /* [in] */ LPCSTR szName);
        
	STDMETHOD_(void, StorePointerWithValue)( 
            /* [out][in] */ Oop  *poopSlot,
            /* [in] */ Oop oopValue);
        
	STDMETHOD_(BOOL, DisableInterrupts)( 
            /* [in] */ BOOL bDisable);
        
	STDMETHOD_(int, CallbackExceptionFilter)( 
            /* [in] */ void  *info);
        
	STDMETHOD_(void, DecodeMethod)( 
            POTE  methodPointer,
            void  *pstream);

	STDMETHOD_(STVarObject*, GetObj)(POTE pote);

	STDMETHOD_(BOOL, IsKindOf)(Oop objectPointer, const POTE classPointer);

	STDMETHOD_(BOOL, DisableAsyncGC)( 
            /* [in] */ BOOL bDisable);

	STDMETHOD_(VOID, MakeImmutable)( 
		/* [in] */ Oop oop,
        /* [in] */ BOOL bImmutable);

	STDMETHOD_(BOOL, IsImmutable)( 
            /* [in] */ Oop oop);

	STDMETHOD_(BSTR, DebugPrintString)(
			/* [in] */ Oop oop);

	STDMETHOD_(POTE, NewUtf8String)(
		/* [in] */ LPCSTR szValue,
		/* [in] */ int len);

    STDMETHOD_(POTE, NewBindingRef)(
        /* [in] */ const char8_t* szQualifiedname,
		/* [in] */ int length,
        /* [in] */ Oop context,
        /* [in] */ BindingReferenceFlags flags
        );

	STDMETHOD_(POTE, InternSymbol)(
		/* [in] */ const char8_t* szName,
		/* [in] */ int length
		);
};

#endif