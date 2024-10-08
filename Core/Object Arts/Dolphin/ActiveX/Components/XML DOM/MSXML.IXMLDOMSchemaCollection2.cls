﻿"Filed out from Dolphin Smalltalk"!

MSXML.IXMLDOMSchemaCollection
	subclass: #'MSXML.IXMLDOMSchemaCollection2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.IXMLDOMSchemaCollection2 guid: (OS.COM.IID fromString: '{50ea08b0-dd1b-4664-9a50-c2f40f4bd79a}')!

MSXML.IXMLDOMSchemaCollection2 isEgressOnly: true!

MSXML.IXMLDOMSchemaCollection2 comment: '<IXMLDOMSchemaCollection2> is a wrapper class for the COM interface ''MSXML2.IXMLDOMSchemaCollection2'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schemas Collection 2"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08B0-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schemas Collection 2"), 
	dual, 
	nonextensible
]
interface IXMLDOMSchemaCollection2 : IXMLDOMSchemaCollection
 {
	[id(0x0000058b)]
	HRESULT __stdcall validate();
	[id(0x0000058c), propput]
	HRESULT __stdcall validateOnLoad(
		[in]VARIANT_BOOL validateOnLoad);
	[id(0x0000058c), propget]
	HRESULT __stdcall validateOnLoad(
		[out, retval]VARIANT_BOOL* validateOnLoad);
	[id(0x0000058d)]
	HRESULT __stdcall getSchema(
		[in]BSTR namespaceURI,
		[out, retval]ISchema** schema);
	[id(0x0000058e)]
	HRESULT __stdcall getDeclaration(
		[in]IXMLDOMNode* node,
		[out, retval]ISchemaItem** item);
};
'!

!MSXML.IXMLDOMSchemaCollection2 categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !

!MSXML.IXMLDOMSchemaCollection2 methodsFor!

get_validateOnLoad: validateOnLoad
	"Private - Get the value of the 'validateOnLoad' property of the receiver.

		HRESULT __stdcall validateOnLoad(
			[out, retval]VARIANT_BOOL* validateOnLoad);"

	<virtual stdcall: hresult 17 varbool*>
	^self invalidCall: _failureCode!

getDeclaration: node
	"Answer the <ISchemaItem> result of invoking the getDeclaration() method of the COM object."

	| answer |
	answer := ISchemaItem newPointer.
	self GetDeclaration: node item: answer.
	^answer asObject!

GetDeclaration: node item: item
	"Private - Invoke the getDeclaration() method of the COM object.

		HRESULT __stdcall getDeclaration(
			[in]IXMLDOMNode* node,
			[out, retval]ISchemaItem** item);"

	<virtual stdcall: hresult 19 IXMLDOMNode* ISchemaItem**>
	^self invalidCall: _failureCode!

getSchema: namespaceURI
	"Answer the <ISchema> result of invoking the getSchema() method of the COM object."

	| answer |
	answer := ISchema newPointer.
	self GetSchema: namespaceURI schema: answer.
	^answer asObject!

GetSchema: namespaceURI schema: schema
	"Private - Invoke the getSchema() method of the COM object.

		HRESULT __stdcall getSchema(
			[in]BSTR namespaceURI,
			[out, retval]ISchema** schema);"

	<virtual stdcall: hresult 18 bstr ISchema**>
	^self invalidCall: _failureCode!

put_validateOnLoad: validateOnLoad
	"Private - Set the value of the 'validateOnLoad' property of the object wrapped by the 
	 receiver to the <varbool> argument, validateOnLoad.

		HRESULT __stdcall validateOnLoad(
			[in]VARIANT_BOOL validateOnLoad);"

	<virtual stdcall: hresult 16 varbool>
	^self invalidCall: _failureCode!

Validate
	"Invoke the validate() method of the COM object.

		HRESULT __stdcall validate();"

	<virtual stdcall: hresult 15>
	^self invalidCall: _failureCode!

validateOnLoad
	"Answer the <varbool> value of the 'validateOnLoad' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_validateOnLoad: answer.
	^answer asObject!

validateOnLoad: validateOnLoad
	"Set the 'validateOnLoad' property of the receiver to the <varbool> value of the argument."

	self put_validateOnLoad: validateOnLoad! !

!MSXML.IXMLDOMSchemaCollection2 categoriesForMethods!
get_validateOnLoad:!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection2!private! !
getDeclaration:!**auto generated**!methods!public! !
GetDeclaration:item:!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection2!private! !
getSchema:!**auto generated**!methods!public! !
GetSchema:schema:!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection2!private! !
put_validateOnLoad:!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection2!private! !
Validate!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection2!public! !
validateOnLoad!**auto generated**!properties!public! !
validateOnLoad:!**auto generated**!properties!public! !
!

!MSXML.IXMLDOMSchemaCollection2 class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (XMLSchemaCache60) for which the receiver is the default interface."

	^CLSID fromString: '{88d96a07-f192-11d4-a65f-0040963251e5}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMSchemaCollection2'
		IXMLDOMSchemaCollection2 defineTemplate"

	self
		defineFunction: #Validate;
		defineFunction: #put_validateOnLoad:
			argumentTypes: 'varbool';
		defineFunction: #get_validateOnLoad:
			argumentTypes: 'varbool*';
		defineFunction: #GetSchema:schema:
			argumentTypes: 'bstr ISchema**';
		defineFunction: #GetDeclaration:item:
			argumentTypes: 'IXMLDOMNode* ISchemaItem**'
! !

!MSXML.IXMLDOMSchemaCollection2 class categoriesForMethods!
clsid!**auto generated**!constants!private! !
defineFunctions!**auto generated**!initializing!private! !
!

