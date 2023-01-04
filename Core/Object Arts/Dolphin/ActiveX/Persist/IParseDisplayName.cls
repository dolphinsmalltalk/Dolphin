"Filed out from Dolphin Smalltalk"!

IUnknown subclass: #IParseDisplayName
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IParseDisplayName guid: (IID fromString: '{0000011a-0000-0000-c000-000000000046}')!
IParseDisplayName comment: '<IParseDisplayName> is a wrapper class for the COM interface ''OCIDL.IParseDisplayName'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IParseDisplayName categoriesForClass!COM-Interfaces!Win32-Interfaces! !
!IParseDisplayName methodsFor!

parseDisplayName: pbc pszDisplayName: pszDisplayName
	"Invoke the ParseDisplayName() method of the COM object."

	| outputs |
	outputs := {DWORD new. IMoniker newPointer}.
	self
		ParseDisplayName: pbc
		pszDisplayName: pszDisplayName asUtf16String
		pchEaten: (outputs basicAt: 1)
		ppmkOut: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

ParseDisplayName: pbc pszDisplayName: pszDisplayName pchEaten: pchEaten ppmkOut: ppmkOut
	"Private - Invoke the ParseDisplayName() method of the COM object.

		HRESULT __stdcall ParseDisplayName(
			[in]IBindCtx* pbc,
			[in]LPWSTR pszDisplayName,
			[out]ULONG* pchEaten,
			[out]IMoniker** ppmkOut);"

	<virtual stdcall: hresult 4 IBindCtx* lpwstr dword* IMoniker**>
	^self invalidCall: _failureCode! !
!IParseDisplayName categoriesForMethods!
parseDisplayName:pszDisplayName:!**auto generated**!methods!public! !
ParseDisplayName:pszDisplayName:pchEaten:ppmkOut:!**auto generated**!COM Interfaces-IParseDisplayName!private! !
!

!IParseDisplayName class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'Win32.IParseDisplayName'
		IParseDisplayName defineTemplate"

	self
		defineFunction: #ParseDisplayName:pszDisplayName:pchEaten:ppmkOut:
			argumentTypes: 'IBindCtx* lpwstr dword* IMoniker**'
! !
!IParseDisplayName class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

