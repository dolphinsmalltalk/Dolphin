"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #IParseDisplayName
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IParseDisplayName guid: (IID fromString: '{0000011A-0000-0000-C000-000000000046}')!
IParseDisplayName comment: '<IParseDisplayName> is a wrapper class for the COM interface ''OCIDL.IParseDisplayName'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IParseDisplayName categoriesForClass!COM-Interfaces! !
!IParseDisplayName methodsFor!

parseDisplayName: pbc pszDisplayName: pszDisplayName 
	"Invoke the ParseDisplayName() method of the COM Object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (DWORD new);
				basicAt: 2 put: IMoniker newPointer;
				yourself.
	self
		ParseDisplayName: pbc
		pszDisplayName: pszDisplayName asUnicodeString
		pchEaten: (answer basicAt: 1)
		ppmkOut: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

ParseDisplayName: pbc pszDisplayName: pszDisplayName pchEaten: pchEaten ppmkOut: ppmkOut
	"Private - Invoke the ParseDisplayName() method of the COM object wrapped by the receiver.

		HRESULT __stdcall ParseDisplayName(
			[in] IBindCtx* pbc,
			[in] LPWSTR pszDisplayName,
			[out] unsigned long* pchEaten,
			[out] IMoniker** ppmkOut);
	"

	<virtual stdcall: hresult 4 IBindCtx* lpwstr dword* IMoniker**>
	^self invalidCall
! !
!IParseDisplayName categoriesFor: #parseDisplayName:pszDisplayName:!**auto generated**!methods!public! !
!IParseDisplayName categoriesFor: #ParseDisplayName:pszDisplayName:pchEaten:ppmkOut:!**auto generated**!COM Interfaces-IParseDisplayName!private! !

IParseDisplayName methodProtocol: #IParseDisplayName attributes: #(#readOnly) selectors: #(#ParseDisplayName:pszDisplayName:pchEaten:ppmkOut:)!

!IParseDisplayName class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IParseDisplayName'
		IParseDisplayName defineTemplate
	"

	self
		defineFunction: #ParseDisplayName:pszDisplayName:pchEaten:ppmkOut:
			argumentTypes: 'IBindCtx* lpwstr dword* IMoniker**'
! !
!IParseDisplayName class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

