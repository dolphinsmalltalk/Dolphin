"Filed out from Dolphin Smalltalk 7"!

MSXML.ISchemaParticle subclass: #'MSXML.ISchemaAny'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISchemaAny guid: (OS.COM.IID fromString: '{50ea08bc-dd1b-4664-9a50-c2f40f4bd79a}')!
MSXML.ISchemaAny comment: '<ISchemaAny> is a wrapper class for the COM interface ''MSXML2.ISchemaAny'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema Any"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08BC-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema Any"), 
	dual, 
	nonextensible
]
interface ISchemaAny : ISchemaParticle
 {
	[id(0x000005b2), propget]
	HRESULT __stdcall namespaces(
		[out, retval]ISchemaStringCollection** namespaces);
	[id(0x000005b7), propget]
	HRESULT __stdcall processContents(
		[out, retval]SCHEMAPROCESSCONTENTS* processContents);
};
'!
!MSXML.ISchemaAny categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISchemaAny methodsFor!

get_namespaces: namespaces
	"Private - Get the value of the 'namespaces' property of the receiver.

		HRESULT __stdcall namespaces(
			[out, retval]ISchemaStringCollection** namespaces);"

	<virtual stdcall: hresult 17 ISchemaStringCollection**>
	^self invalidCall: _failureCode!

get_processContents: processContents
	"Private - Get the value of the 'processContents' property of the receiver.

		HRESULT __stdcall processContents(
			[out, retval]SCHEMAPROCESSCONTENTS* processContents);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall: _failureCode!

namespaces
	"Answer the <ISchemaStringCollection> value of the 'namespaces' property of the receiver."

	| answer |
	answer := ISchemaStringCollection newPointer.
	self get_namespaces: answer.
	^answer asObject!

processContents
	"Answer the <sdword> value of the 'processContents' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_processContents: answer.
	^answer asObject! !
!MSXML.ISchemaAny categoriesFor: #get_namespaces:!**auto generated**!COM Interfaces-ISchemaAny!private! !
!MSXML.ISchemaAny categoriesFor: #get_processContents:!**auto generated**!COM Interfaces-ISchemaAny!private! !
!MSXML.ISchemaAny categoriesFor: #namespaces!**auto generated**!properties!public! !
!MSXML.ISchemaAny categoriesFor: #processContents!**auto generated**!properties!public! !

!MSXML.ISchemaAny class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchemaAny'
		ISchemaAny defineTemplate"

	self
		defineFunction: #get_namespaces:
			argumentTypes: 'ISchemaStringCollection**';
		defineFunction: #get_processContents:
			argumentTypes: 'sdword*'
! !
!MSXML.ISchemaAny class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

