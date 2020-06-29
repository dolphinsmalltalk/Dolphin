"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #ISAXEntityResolver
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ISAXEntityResolver guid: (IID fromString: '{99bca7bd-e8c4-4d5f-a0cf-6d907901ff07}')!
ISAXEntityResolver comment: '<ISAXEntityResolver> is a wrapper class for the COM interface ''MSXML2.ISAXEntityResolver'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISAXEntityResolver interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(99BCA7BD-E8C4-4D5F-A0CF-6D907901FF07), 
	helpstring("ISAXEntityResolver interface"), 
	hidden
]
interface ISAXEntityResolver : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall resolveEntity(
		[in]unsigned short* pwchPublicId,
		[in]unsigned short* pwchSystemId,
		[out, retval]VARIANT* pvarInput);
};
'!
!ISAXEntityResolver categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!ISAXEntityResolver methodsFor!

resolveEntity: pwchPublicId pwchSystemId: pwchSystemId
	"Answer the <VARIANT> result of invoking the resolveEntity() method of the COM object."

	| answer |
	answer := VARIANT new.
	self
		ResolveEntity: pwchPublicId
		pwchSystemId: pwchSystemId
		pvarInput: answer.
	^answer asObject
!

ResolveEntity: pwchPublicId pwchSystemId: pwchSystemId pvarInput: pvarInput
	"Private - Invoke the resolveEntity() method of the COM object.

		HRESULT __stdcall resolveEntity(
			[in]unsigned short* pwchPublicId,
			[in]unsigned short* pwchSystemId,
			[out, retval]VARIANT* pvarInput);"

	<virtual stdcall: hresult 4 word* word* variant*>
	^self invalidCall: _failureCode! !
!ISAXEntityResolver categoriesFor: #resolveEntity:pwchSystemId:!**auto generated**!methods!public! !
!ISAXEntityResolver categoriesFor: #ResolveEntity:pwchSystemId:pvarInput:!**auto generated**!COM Interfaces-ISAXEntityResolver!private! !

!ISAXEntityResolver class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISAXEntityResolver'
		ISAXEntityResolver defineTemplate"

	self
		defineFunction: #ResolveEntity:pwchSystemId:pvarInput:
			argumentTypes: 'word* word* variant*'
! !
!ISAXEntityResolver class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

