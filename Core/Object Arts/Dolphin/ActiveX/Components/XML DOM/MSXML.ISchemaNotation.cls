"Filed out from Dolphin Smalltalk 7"!

MSXML.ISchemaItem subclass: #'MSXML.ISchemaNotation'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISchemaNotation guid: (OS.COM.IID fromString: '{50ea08be-dd1b-4664-9a50-c2f40f4bd79a}')!
MSXML.ISchemaNotation comment: '<ISchemaNotation> is a wrapper class for the COM interface ''MSXML2.ISchemaNotation'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema Notation"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08BE-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema Notation"), 
	dual, 
	nonextensible
]
interface ISchemaNotation : ISchemaItem
 {
	[id(0x000005c1), propget]
	HRESULT __stdcall systemIdentifier(
		[out, retval]BSTR* uri);
	[id(0x000005b9), propget]
	HRESULT __stdcall publicIdentifier(
		[out, retval]BSTR* uri);
};
'!
!MSXML.ISchemaNotation categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISchemaNotation methodsFor!

get_publicIdentifier: uri
	"Private - Get the value of the 'publicIdentifier' property of the receiver.

		HRESULT __stdcall publicIdentifier(
			[out, retval]BSTR* uri);"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall: _failureCode!

get_systemIdentifier: uri
	"Private - Get the value of the 'systemIdentifier' property of the receiver.

		HRESULT __stdcall systemIdentifier(
			[out, retval]BSTR* uri);"

	<virtual stdcall: hresult 15 bstr*>
	^self invalidCall: _failureCode!

publicIdentifier
	"Answer the <bstr> value of the 'publicIdentifier' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_publicIdentifier: answer.
	^answer asObject!

systemIdentifier
	"Answer the <bstr> value of the 'systemIdentifier' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_systemIdentifier: answer.
	^answer asObject! !
!MSXML.ISchemaNotation categoriesFor: #get_publicIdentifier:!**auto generated**!COM Interfaces-ISchemaNotation!private! !
!MSXML.ISchemaNotation categoriesFor: #get_systemIdentifier:!**auto generated**!COM Interfaces-ISchemaNotation!private! !
!MSXML.ISchemaNotation categoriesFor: #publicIdentifier!**auto generated**!properties!public! !
!MSXML.ISchemaNotation categoriesFor: #systemIdentifier!**auto generated**!properties!public! !

!MSXML.ISchemaNotation class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchemaNotation'
		ISchemaNotation defineTemplate"

	self
		defineFunction: #get_systemIdentifier:
			argumentTypes: 'bstr*';
		defineFunction: #get_publicIdentifier:
			argumentTypes: 'bstr*'
! !
!MSXML.ISchemaNotation class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

