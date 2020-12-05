"Filed out from Dolphin Smalltalk 7"!

MSXML.ISchemaItem subclass: #'MSXML.ISchemaAttribute'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISchemaAttribute guid: (OS.COM.IID fromString: '{50ea08b6-dd1b-4664-9a50-c2f40f4bd79a}')!
MSXML.ISchemaAttribute comment: '<ISchemaAttribute> is a wrapper class for the COM interface ''MSXML2.ISchemaAttribute'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema Attribute"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08B6-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema Attribute"), 
	dual, 
	nonextensible
]
interface ISchemaAttribute : ISchemaItem
 {
	[id(0x000005c4), propget]
	HRESULT __stdcall type(
		[out, retval]ISchemaType** type);
	[id(0x000005bd), propget]
	HRESULT __stdcall scope(
		[out, retval]ISchemaComplexType** scope);
	[id(0x00000597), propget]
	HRESULT __stdcall defaultValue(
		[out, retval]BSTR* defaultValue);
	[id(0x0000059e), propget]
	HRESULT __stdcall fixedValue(
		[out, retval]BSTR* fixedValue);
	[id(0x000005c7), propget]
	HRESULT __stdcall use(
		[out, retval]SCHEMAUSE* use);
	[id(0x000005a4), propget]
	HRESULT __stdcall isReference(
		[out, retval]VARIANT_BOOL* reference);
};
'!
!MSXML.ISchemaAttribute categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISchemaAttribute methodsFor!

defaultValue
	"Answer the <bstr> value of the 'defaultValue' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_defaultValue: answer.
	^answer asObject
!

fixedValue
	"Answer the <bstr> value of the 'fixedValue' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_fixedValue: answer.
	^answer asObject
!

get_defaultValue: defaultValue
	"Private - Get the value of the 'defaultValue' property of the receiver.

		HRESULT __stdcall defaultValue(
			[out, retval]BSTR* defaultValue);"

	<virtual stdcall: hresult 17 bstr*>
	^self invalidCall: _failureCode!

get_fixedValue: fixedValue
	"Private - Get the value of the 'fixedValue' property of the receiver.

		HRESULT __stdcall fixedValue(
			[out, retval]BSTR* fixedValue);"

	<virtual stdcall: hresult 18 bstr*>
	^self invalidCall: _failureCode!

get_isReference: reference
	"Private - Get the value of the 'isReference' property of the receiver.

		HRESULT __stdcall isReference(
			[out, retval]VARIANT_BOOL* reference);"

	<virtual stdcall: hresult 20 varbool*>
	^self invalidCall: _failureCode!

get_scope: scope
	"Private - Get the value of the 'scope' property of the receiver.

		HRESULT __stdcall scope(
			[out, retval]ISchemaComplexType** scope);"

	<virtual stdcall: hresult 16 ISchemaComplexType**>
	^self invalidCall: _failureCode!

get_type: type
	"Private - Get the value of the 'type' property of the receiver.

		HRESULT __stdcall type(
			[out, retval]ISchemaType** type);"

	<virtual stdcall: hresult 15 ISchemaType**>
	^self invalidCall: _failureCode!

get_use: use
	"Private - Get the value of the 'use' property of the receiver.

		HRESULT __stdcall use(
			[out, retval]SCHEMAUSE* use);"

	<virtual stdcall: hresult 19 sdword*>
	^self invalidCall: _failureCode!

isReference
	"Answer the <varbool> value of the 'isReference' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_isReference: answer.
	^answer asObject
!

scope
	"Answer the <ISchemaComplexType> value of the 'scope' property of the receiver."

	| answer |
	answer := ISchemaComplexType newPointer.
	self get_scope: answer.
	^answer asObject!

type
	"Answer the <ISchemaType> value of the 'type' property of the receiver."

	| answer |
	answer := ISchemaType newPointer.
	self get_type: answer.
	^answer asObject!

use
	"Answer the <sdword> value of the 'use' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_use: answer.
	^answer asObject
! !
!MSXML.ISchemaAttribute categoriesFor: #defaultValue!**auto generated**!properties!public! !
!MSXML.ISchemaAttribute categoriesFor: #fixedValue!**auto generated**!properties!public! !
!MSXML.ISchemaAttribute categoriesFor: #get_defaultValue:!**auto generated**!COM Interfaces-ISchemaAttribute!private! !
!MSXML.ISchemaAttribute categoriesFor: #get_fixedValue:!**auto generated**!COM Interfaces-ISchemaAttribute!private! !
!MSXML.ISchemaAttribute categoriesFor: #get_isReference:!**auto generated**!COM Interfaces-ISchemaAttribute!private! !
!MSXML.ISchemaAttribute categoriesFor: #get_scope:!**auto generated**!COM Interfaces-ISchemaAttribute!private! !
!MSXML.ISchemaAttribute categoriesFor: #get_type:!**auto generated**!COM Interfaces-ISchemaAttribute!private! !
!MSXML.ISchemaAttribute categoriesFor: #get_use:!**auto generated**!COM Interfaces-ISchemaAttribute!private! !
!MSXML.ISchemaAttribute categoriesFor: #isReference!**auto generated**!properties!public! !
!MSXML.ISchemaAttribute categoriesFor: #scope!**auto generated**!properties!public! !
!MSXML.ISchemaAttribute categoriesFor: #type!**auto generated**!properties!public! !
!MSXML.ISchemaAttribute categoriesFor: #use!**auto generated**!properties!public! !

!MSXML.ISchemaAttribute class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchemaAttribute'
		ISchemaAttribute defineTemplate"

	self
		defineFunction: #get_type:
			argumentTypes: 'ISchemaType**';
		defineFunction: #get_scope:
			argumentTypes: 'ISchemaComplexType**';
		defineFunction: #get_defaultValue:
			argumentTypes: 'bstr*';
		defineFunction: #get_fixedValue:
			argumentTypes: 'bstr*';
		defineFunction: #get_use:
			argumentTypes: 'sdword*';
		defineFunction: #get_isReference:
			argumentTypes: 'varbool*'
! !
!MSXML.ISchemaAttribute class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

