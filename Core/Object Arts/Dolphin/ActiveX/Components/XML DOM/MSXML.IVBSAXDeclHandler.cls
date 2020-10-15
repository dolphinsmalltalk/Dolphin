"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IVBSAXDeclHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IVBSAXDeclHandler guid: (OS.COM.IID fromString: '{e8917260-7579-4be1-b5dd-7afbfa6f077b}')!
MSXML.IVBSAXDeclHandler comment: '<IVBSAXDeclHandler> is a wrapper class for the COM interface ''MSXML2.IVBSAXDeclHandler'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBSAXDeclHandler interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(E8917260-7579-4BE1-B5DD-7AFBFA6F077B), 
	helpstring("IVBSAXDeclHandler interface"), 
	dual, 
	nonextensible
]
interface IVBSAXDeclHandler : IDispatch
 {
	[id(0x00000557), helpstring("Report an element type declaration.")]
	HRESULT __stdcall elementDecl(
		[in, out]BSTR* strName,
		[in, out]BSTR* strModel);
	[id(0x00000558), helpstring("Report an attribute type declaration.")]
	HRESULT __stdcall attributeDecl(
		[in, out]BSTR* strElementName,
		[in, out]BSTR* strAttributeName,
		[in, out]BSTR* strType,
		[in, out]BSTR* strValueDefault,
		[in, out]BSTR* strValue);
	[id(0x00000559), helpstring("Report an internal entity declaration.")]
	HRESULT __stdcall internalEntityDecl(
		[in, out]BSTR* strName,
		[in, out]BSTR* strValue);
	[id(0x0000055a), helpstring("Report a parsed external entity declaration.")]
	HRESULT __stdcall externalEntityDecl(
		[in, out]BSTR* strName,
		[in, out]BSTR* strPublicId,
		[in, out]BSTR* strSystemId);
};
'!
!MSXML.IVBSAXDeclHandler categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IVBSAXDeclHandler methodsFor!

attributeDecl: strElementName strAttributeName: strAttributeName strType: strType strValueDefault: strValueDefault strValue: strValue
	"Invoke the attributeDecl() method of the COM object.
	Helpstring: Report an attribute type declaration."

	| outputs |
	outputs := {strElementName asBSTR.
				strAttributeName asBSTR.
				strType asBSTR.
				strValueDefault asBSTR.
				strValue asBSTR}.
	self
		AttributeDecl: (outputs basicAt: 1)
		strAttributeName: (outputs basicAt: 2)
		strType: (outputs basicAt: 3)
		strValueDefault: (outputs basicAt: 4)
		strValue: (outputs basicAt: 5).
	^outputs collect: [:each | each asObject]!

AttributeDecl: strElementName strAttributeName: strAttributeName strType: strType strValueDefault: strValueDefault strValue: strValue
	"Private - Invoke the attributeDecl() method of the COM object.
	Helpstring: Report an attribute type declaration.

		HRESULT __stdcall attributeDecl(
			[in, out]BSTR* strElementName,
			[in, out]BSTR* strAttributeName,
			[in, out]BSTR* strType,
			[in, out]BSTR* strValueDefault,
			[in, out]BSTR* strValue);"

	<virtual stdcall: hresult 9 bstr* bstr* bstr* bstr* bstr*>
	^self invalidCall: _failureCode!

elementDecl: strName strModel: strModel
	"Invoke the elementDecl() method of the COM object.
	Helpstring: Report an element type declaration."

	| outputs |
	outputs := {strName asBSTR. strModel asBSTR}.
	self ElementDecl: (outputs basicAt: 1) strModel: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

ElementDecl: strName strModel: strModel
	"Private - Invoke the elementDecl() method of the COM object.
	Helpstring: Report an element type declaration.

		HRESULT __stdcall elementDecl(
			[in, out]BSTR* strName,
			[in, out]BSTR* strModel);"

	<virtual stdcall: hresult 8 bstr* bstr*>
	^self invalidCall: _failureCode!

externalEntityDecl: strName strPublicId: strPublicId strSystemId: strSystemId
	"Invoke the externalEntityDecl() method of the COM object.
	Helpstring: Report a parsed external entity declaration."

	| outputs |
	outputs := {strName asBSTR. strPublicId asBSTR. strSystemId asBSTR}.
	self
		ExternalEntityDecl: (outputs basicAt: 1)
		strPublicId: (outputs basicAt: 2)
		strSystemId: (outputs basicAt: 3).
	^outputs collect: [:each | each asObject]!

ExternalEntityDecl: strName strPublicId: strPublicId strSystemId: strSystemId
	"Private - Invoke the externalEntityDecl() method of the COM object.
	Helpstring: Report a parsed external entity declaration.

		HRESULT __stdcall externalEntityDecl(
			[in, out]BSTR* strName,
			[in, out]BSTR* strPublicId,
			[in, out]BSTR* strSystemId);"

	<virtual stdcall: hresult 11 bstr* bstr* bstr*>
	^self invalidCall: _failureCode!

internalEntityDecl: strName strValue: strValue
	"Invoke the internalEntityDecl() method of the COM object.
	Helpstring: Report an internal entity declaration."

	| outputs |
	outputs := {strName asBSTR. strValue asBSTR}.
	self InternalEntityDecl: (outputs basicAt: 1) strValue: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

InternalEntityDecl: strName strValue: strValue
	"Private - Invoke the internalEntityDecl() method of the COM object.
	Helpstring: Report an internal entity declaration.

		HRESULT __stdcall internalEntityDecl(
			[in, out]BSTR* strName,
			[in, out]BSTR* strValue);"

	<virtual stdcall: hresult 10 bstr* bstr*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !
!MSXML.IVBSAXDeclHandler categoriesFor: #attributeDecl:strAttributeName:strType:strValueDefault:strValue:!**auto generated**!methods!public! !
!MSXML.IVBSAXDeclHandler categoriesFor: #AttributeDecl:strAttributeName:strType:strValueDefault:strValue:!**auto generated**!COM Interfaces-IVBSAXDeclHandler!private! !
!MSXML.IVBSAXDeclHandler categoriesFor: #elementDecl:strModel:!**auto generated**!methods!public! !
!MSXML.IVBSAXDeclHandler categoriesFor: #ElementDecl:strModel:!**auto generated**!COM Interfaces-IVBSAXDeclHandler!private! !
!MSXML.IVBSAXDeclHandler categoriesFor: #externalEntityDecl:strPublicId:strSystemId:!**auto generated**!methods!public! !
!MSXML.IVBSAXDeclHandler categoriesFor: #ExternalEntityDecl:strPublicId:strSystemId:!**auto generated**!COM Interfaces-IVBSAXDeclHandler!private! !
!MSXML.IVBSAXDeclHandler categoriesFor: #internalEntityDecl:strValue:!**auto generated**!methods!public! !
!MSXML.IVBSAXDeclHandler categoriesFor: #InternalEntityDecl:strValue:!**auto generated**!COM Interfaces-IVBSAXDeclHandler!private! !
!MSXML.IVBSAXDeclHandler categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IVBSAXDeclHandler categoriesFor: #isVBCollection!**auto generated**!public!testing! !

!MSXML.IVBSAXDeclHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBSAXDeclHandler'
		IVBSAXDeclHandler defineTemplate"

	self
		defineFunction: #ElementDecl:strModel:
			argumentTypes: 'bstr* bstr*';
		defineFunction: #AttributeDecl:strAttributeName:strType:strValueDefault:strValue:
			argumentTypes: 'bstr* bstr* bstr* bstr* bstr*';
		defineFunction: #InternalEntityDecl:strValue:
			argumentTypes: 'bstr* bstr*';
		defineFunction: #ExternalEntityDecl:strPublicId:strSystemId:
			argumentTypes: 'bstr* bstr* bstr*'
! !
!MSXML.IVBSAXDeclHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

