﻿"Filed out from Dolphin Smalltalk"!

MSXML.ISchemaItem
	subclass: #'MSXML.ISchemaAttributeGroup'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.ISchemaAttributeGroup guid: (OS.COM.IID fromString: '{50ea08ba-dd1b-4664-9a50-c2f40f4bd79a}')!

MSXML.ISchemaAttributeGroup isEgressOnly: true!

MSXML.ISchemaAttributeGroup comment: '<ISchemaAttributeGroup> is a wrapper class for the COM interface ''MSXML2.ISchemaAttributeGroup'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema Attribute Group"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08BA-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema Attribute Group"), 
	dual, 
	nonextensible
]
interface ISchemaAttributeGroup : ISchemaItem
 {
	[id(0x00000591), propget]
	HRESULT __stdcall anyAttribute(
		[out, retval]ISchemaAny** anyAttribute);
	[id(0x00000593), propget]
	HRESULT __stdcall attributes(
		[out, retval]ISchemaItemCollection** attributes);
};
'!

!MSXML.ISchemaAttributeGroup categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !

!MSXML.ISchemaAttributeGroup methodsFor!

anyAttribute
	"Answer the <ISchemaAny> value of the 'anyAttribute' property of the receiver."

	| answer |
	answer := ISchemaAny newPointer.
	self get_anyAttribute: answer.
	^answer asObject!

attributes
	"Answer the <ISchemaItemCollection> value of the 'attributes' property of the receiver."

	| answer |
	answer := ISchemaItemCollection newPointer.
	self get_attributes: answer.
	^answer asObject!

get_anyAttribute: anyAttribute
	"Private - Get the value of the 'anyAttribute' property of the receiver.

		HRESULT __stdcall anyAttribute(
			[out, retval]ISchemaAny** anyAttribute);"

	<virtual stdcall: hresult 15 ISchemaAny**>
	^self invalidCall: _failureCode!

get_attributes: attributes
	"Private - Get the value of the 'attributes' property of the receiver.

		HRESULT __stdcall attributes(
			[out, retval]ISchemaItemCollection** attributes);"

	<virtual stdcall: hresult 16 ISchemaItemCollection**>
	^self invalidCall: _failureCode! !

!MSXML.ISchemaAttributeGroup categoriesForMethods!
anyAttribute!**auto generated**!properties!public! !
attributes!**auto generated**!properties!public! !
get_anyAttribute:!**auto generated**!COM Interfaces-ISchemaAttributeGroup!private! !
get_attributes:!**auto generated**!COM Interfaces-ISchemaAttributeGroup!private! !
!

!MSXML.ISchemaAttributeGroup class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchemaAttributeGroup'
		ISchemaAttributeGroup defineTemplate"

	self
		defineFunction: #get_anyAttribute:
			argumentTypes: 'ISchemaAny**';
		defineFunction: #get_attributes:
			argumentTypes: 'ISchemaItemCollection**'
! !

!MSXML.ISchemaAttributeGroup class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

