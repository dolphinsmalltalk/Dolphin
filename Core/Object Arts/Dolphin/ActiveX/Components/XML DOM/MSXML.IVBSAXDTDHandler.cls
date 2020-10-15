"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IVBSAXDTDHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IVBSAXDTDHandler guid: (OS.COM.IID fromString: '{24fb3297-302d-4620-ba39-3a732d850558}')!
MSXML.IVBSAXDTDHandler comment: '<IVBSAXDTDHandler> is a wrapper class for the COM interface ''MSXML2.IVBSAXDTDHandler'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBSAXDTDHandler interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(24FB3297-302D-4620-BA39-3A732D850558), 
	helpstring("IVBSAXDTDHandler interface"), 
	dual, 
	nonextensible
]
interface IVBSAXDTDHandler : IDispatch
 {
	[id(0x00000537), helpstring("Receive notification of a notation declaration event.")]
	HRESULT __stdcall notationDecl(
		[in, out]BSTR* strName,
		[in, out]BSTR* strPublicId,
		[in, out]BSTR* strSystemId);
	[id(0x00000538), helpstring("Receive notification of an unparsed entity declaration event.")]
	HRESULT __stdcall unparsedEntityDecl(
		[in, out]BSTR* strName,
		[in, out]BSTR* strPublicId,
		[in, out]BSTR* strSystemId,
		[in, out]BSTR* strNotationName);
};
'!
!MSXML.IVBSAXDTDHandler categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IVBSAXDTDHandler methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

notationDecl: strName strPublicId: strPublicId strSystemId: strSystemId
	"Invoke the notationDecl() method of the COM object.
	Helpstring: Receive notification of a notation declaration event."

	| outputs |
	outputs := {strName asBSTR. strPublicId asBSTR. strSystemId asBSTR}.
	self
		NotationDecl: (outputs basicAt: 1)
		strPublicId: (outputs basicAt: 2)
		strSystemId: (outputs basicAt: 3).
	^outputs collect: [:each | each asObject]!

NotationDecl: strName strPublicId: strPublicId strSystemId: strSystemId
	"Private - Invoke the notationDecl() method of the COM object.
	Helpstring: Receive notification of a notation declaration event.

		HRESULT __stdcall notationDecl(
			[in, out]BSTR* strName,
			[in, out]BSTR* strPublicId,
			[in, out]BSTR* strSystemId);"

	<virtual stdcall: hresult 8 bstr* bstr* bstr*>
	^self invalidCall: _failureCode!

unparsedEntityDecl: strName strPublicId: strPublicId strSystemId: strSystemId strNotationName: strNotationName
	"Invoke the unparsedEntityDecl() method of the COM object.
	Helpstring: Receive notification of an unparsed entity declaration event."

	| outputs |
	outputs := {strName asBSTR. strPublicId asBSTR. strSystemId asBSTR. strNotationName asBSTR}.
	self
		UnparsedEntityDecl: (outputs basicAt: 1)
		strPublicId: (outputs basicAt: 2)
		strSystemId: (outputs basicAt: 3)
		strNotationName: (outputs basicAt: 4).
	^outputs collect: [:each | each asObject]!

UnparsedEntityDecl: strName strPublicId: strPublicId strSystemId: strSystemId strNotationName: strNotationName
	"Private - Invoke the unparsedEntityDecl() method of the COM object.
	Helpstring: Receive notification of an unparsed entity declaration event.

		HRESULT __stdcall unparsedEntityDecl(
			[in, out]BSTR* strName,
			[in, out]BSTR* strPublicId,
			[in, out]BSTR* strSystemId,
			[in, out]BSTR* strNotationName);"

	<virtual stdcall: hresult 9 bstr* bstr* bstr* bstr*>
	^self invalidCall: _failureCode! !
!MSXML.IVBSAXDTDHandler categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IVBSAXDTDHandler categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.IVBSAXDTDHandler categoriesFor: #notationDecl:strPublicId:strSystemId:!**auto generated**!methods!public! !
!MSXML.IVBSAXDTDHandler categoriesFor: #NotationDecl:strPublicId:strSystemId:!**auto generated**!COM Interfaces-IVBSAXDTDHandler!private! !
!MSXML.IVBSAXDTDHandler categoriesFor: #unparsedEntityDecl:strPublicId:strSystemId:strNotationName:!**auto generated**!methods!public! !
!MSXML.IVBSAXDTDHandler categoriesFor: #UnparsedEntityDecl:strPublicId:strSystemId:strNotationName:!**auto generated**!COM Interfaces-IVBSAXDTDHandler!private! !

!MSXML.IVBSAXDTDHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBSAXDTDHandler'
		IVBSAXDTDHandler defineTemplate"

	self
		defineFunction: #NotationDecl:strPublicId:strSystemId:
			argumentTypes: 'bstr* bstr* bstr*';
		defineFunction: #UnparsedEntityDecl:strPublicId:strSystemId:strNotationName:
			argumentTypes: 'bstr* bstr* bstr* bstr*'
! !
!MSXML.IVBSAXDTDHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

