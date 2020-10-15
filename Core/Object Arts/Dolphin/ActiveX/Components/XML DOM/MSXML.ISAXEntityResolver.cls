"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'MSXML.ISAXEntityResolver'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISAXEntityResolver guid: (OS.COM.IID fromString: '{99bca7bd-e8c4-4d5f-a0cf-6d907901ff07}')!
MSXML.ISAXEntityResolver comment: '<ISAXEntityResolver> is a wrapper class for the COM interface ''MSXML2.ISAXEntityResolver'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

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
!MSXML.ISAXEntityResolver categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISAXEntityResolver methodsFor!

resolveEntity: pwchPublicId pwchSystemId: pwchSystemId
	"Answer the <variant> result of invoking the resolveEntity() method of the COM object."

	| answer |
	answer := VARIANT new.
	self
		ResolveEntity: pwchPublicId
		pwchSystemId: pwchSystemId
		pvarInput: answer.
	^answer asObject!

ResolveEntity: pwchPublicId pwchSystemId: pwchSystemId pvarInput: pvarInput
	"Private - Invoke the resolveEntity() method of the COM object.

		HRESULT __stdcall resolveEntity(
			[in]unsigned short* pwchPublicId,
			[in]unsigned short* pwchSystemId,
			[out, retval]VARIANT* pvarInput);"

	<virtual stdcall: hresult 4 word* word* variant*>
	^self invalidCall: _failureCode! !
!MSXML.ISAXEntityResolver categoriesFor: #resolveEntity:pwchSystemId:!**auto generated**!methods!public! !
!MSXML.ISAXEntityResolver categoriesFor: #ResolveEntity:pwchSystemId:pvarInput:!**auto generated**!COM Interfaces-ISAXEntityResolver!private! !

!MSXML.ISAXEntityResolver class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISAXEntityResolver'
		ISAXEntityResolver defineTemplate"

	self
		defineFunction: #ResolveEntity:pwchSystemId:pvarInput:
			argumentTypes: 'word* word* variant*'
! !
!MSXML.ISAXEntityResolver class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

