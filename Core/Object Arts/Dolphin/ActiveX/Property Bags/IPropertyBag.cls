"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IPropertyBag
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IPropertyBag guid: (IID fromString: '{55272A00-42CB-11CE-8135-00AA004BB851}')!
IPropertyBag comment: '<IPropertyBag> is a wrapper class for the COM interface ''OCIDL.IPropertyBag'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IPropertyBag categoriesForClass!COM-Interfaces! !
!IPropertyBag methodsFor!

read: pszPropName pErrorLog: pErrorLog
	"Answer the <VARIANT> result of invoking the COM Object's Read() method."

	| answer |
	answer := VARIANT new.
	self
		Read: pszPropName asUtf16String
		pVar: answer
		pErrorLog: pErrorLog.
	^answer asObject!

Read: pszPropName pVar: pVar pErrorLog: pErrorLog
	"Private - Invoke the Read() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Read(
			[in] LPWSTR pszPropName,
			[out] VARIANT* pVar,
			[in] IErrorLog* pErrorLog,
			[in] unsigned long varType,
			[in] IUnknown* pUnkObj);
	"

	<virtual stdcall: hresult 4 lpwstr VARIANT* IErrorLog*>
	^self invalidCall
!

write: pszPropName pVar: pVar
	"Invoke the Write() method of the COM Object."

	self Write: pszPropName asUtf16String pVar: pVar asVariant!

Write: pszPropName pVar: pVar
	"Private - Invoke the Write() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Write(
			[in] LPWSTR pszPropName,
			[in] VARIANT* pVar);
	"

	<virtual stdcall: hresult 5 lpwstr VARIANT*>
	^self invalidCall
! !
!IPropertyBag categoriesFor: #read:pErrorLog:!methods!public! !
!IPropertyBag categoriesFor: #Read:pVar:pErrorLog:!COM Interfaces-IPropertyBag!private! !
!IPropertyBag categoriesFor: #write:pVar:!**auto generated**!methods!public! !
!IPropertyBag categoriesFor: #Write:pVar:!**auto generated**!COM Interfaces-IPropertyBag!private! !

IPropertyBag methodProtocol: #IPropertyBag attributes: #(#readOnly) selectors: #(#Read:pVar:pErrorLog: #Write:pVar:)!

!IPropertyBag class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IPropertyBag'
		IPropertyBag defineTemplate
	"

	self
		defineFunction: #Read:pVar:pErrorLog:
			argumentTypes: 'lpwstr VARIANT* IErrorLog*';
		defineFunction: #Write:pVar:
			argumentTypes: 'lpwstr VARIANT*'
! !
!IPropertyBag class categoriesFor: #defineFunctions!initializing!public! !

