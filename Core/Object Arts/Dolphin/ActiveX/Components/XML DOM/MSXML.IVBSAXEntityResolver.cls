﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'MSXML.IVBSAXEntityResolver'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.IVBSAXEntityResolver guid: (OS.COM.IID fromString: '{0c05d096-f45b-4aca-ad1a-aa0bc25518dc}')!

MSXML.IVBSAXEntityResolver comment: '<IVBSAXEntityResolver> is a wrapper class for the COM interface ''MSXML2.IVBSAXEntityResolver'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBSAXEntityResolver interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(0C05D096-F45B-4ACA-AD1A-AA0BC25518DC), 
	helpstring("IVBSAXEntityResolver interface"), 
	dual, 
	nonextensible
]
interface IVBSAXEntityResolver : IDispatch
 {
	[id(0x00000527), helpstring("Allow the application to resolve external entities.")]
	HRESULT __stdcall resolveEntity(
		[in, out]BSTR* strPublicId,
		[in, out]BSTR* strSystemId,
		[out, retval]VARIANT* varInput);
};
'!

!MSXML.IVBSAXEntityResolver categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !

!MSXML.IVBSAXEntityResolver methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

resolveEntity: strPublicId strSystemId: strSystemId
	"Invoke the resolveEntity() method of the COM object.
	Helpstring: Allow the application to resolve external entities."

	| outputs |
	outputs := {strPublicId asBSTR. strSystemId asBSTR. VARIANT new}.
	self
		ResolveEntity: (outputs basicAt: 1)
		strSystemId: (outputs basicAt: 2)
		varInput: (outputs basicAt: 3).
	^outputs collect: [:each | each asObject]!

ResolveEntity: strPublicId strSystemId: strSystemId varInput: varInput
	"Private - Invoke the resolveEntity() method of the COM object.
	Helpstring: Allow the application to resolve external entities.

		HRESULT __stdcall resolveEntity(
			[in, out]BSTR* strPublicId,
			[in, out]BSTR* strSystemId,
			[out, retval]VARIANT* varInput);"

	<virtual stdcall: hresult 8 bstr* bstr* variant*>
	^self invalidCall: _failureCode! !

!MSXML.IVBSAXEntityResolver categoriesForMethods!
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
resolveEntity:strSystemId:!**auto generated**!methods!public! !
ResolveEntity:strSystemId:varInput:!**auto generated**!COM Interfaces-IVBSAXEntityResolver!private! !
!

!MSXML.IVBSAXEntityResolver class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBSAXEntityResolver'
		IVBSAXEntityResolver defineTemplate"

	self
		defineFunction: #ResolveEntity:strSystemId:varInput:
			argumentTypes: 'bstr* bstr* variant*'
! !

!MSXML.IVBSAXEntityResolver class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

