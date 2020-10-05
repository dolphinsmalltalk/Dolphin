"Filed out from Dolphin Smalltalk 7"!

ISchemaType subclass: #ISchemaComplexType
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ISchemaComplexType guid: (IID fromString: '{50ea08b9-dd1b-4664-9a50-c2f40f4bd79a}')!
ISchemaComplexType comment: '<ISchemaComplexType> is a wrapper class for the COM interface ''MSXML2.ISchemaComplexType'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema Complex Type"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08B9-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema Complex Type"), 
	dual, 
	nonextensible
]
interface ISchemaComplexType : ISchemaType
 {
	[id(0x000005a2), propget]
	HRESULT __stdcall isAbstract(
		[out, retval]VARIANT_BOOL* abstract);
	[id(0x00000591), propget]
	HRESULT __stdcall anyAttribute(
		[out, retval]ISchemaAny** anyAttribute);
	[id(0x00000593), propget]
	HRESULT __stdcall attributes(
		[out, retval]ISchemaItemCollection** attributes);
	[id(0x00000596), propget]
	HRESULT __stdcall contentType(
		[out, retval]SCHEMACONTENTTYPE* contentType);
	[id(0x00000595), propget]
	HRESULT __stdcall contentModel(
		[out, retval]ISchemaModelGroup** contentModel);
	[id(0x000005b8), propget]
	HRESULT __stdcall prohibitedSubstitutions(
		[out, retval]SCHEMADERIVATIONMETHOD* prohibited);
};
'!
!ISchemaComplexType categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!ISchemaComplexType methodsFor!

anyAttribute
	"Answer the <ISchemaAny> value of the 'anyAttribute' property of the receiver."

	| answer |
	answer := ISchemaAny newPointer.
	self get_anyAttribute: answer.
	^answer asObject
!

attributes
	"Answer the <ISchemaItemCollection> value of the 'attributes' property of the receiver."

	| answer |
	answer := ISchemaItemCollection newPointer.
	self get_attributes: answer.
	^answer asObject
!

contentModel
	"Answer the <ISchemaModelGroup> value of the 'contentModel' property of the receiver."

	| answer |
	answer := ISchemaModelGroup newPointer.
	self get_contentModel: answer.
	^answer asObject
!

contentType
	"Answer the <sdword> value of the 'contentType' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_contentType: answer.
	^answer asObject
!

get_anyAttribute: anyAttribute
	"Private - Get the value of the 'anyAttribute' property of the receiver.

		HRESULT __stdcall anyAttribute(
			[out, retval]ISchemaAny** anyAttribute);"

	<virtual stdcall: hresult 33 ISchemaAny**>
	^self invalidCall: _failureCode!

get_attributes: attributes
	"Private - Get the value of the 'attributes' property of the receiver.

		HRESULT __stdcall attributes(
			[out, retval]ISchemaItemCollection** attributes);"

	<virtual stdcall: hresult 34 ISchemaItemCollection**>
	^self invalidCall: _failureCode!

get_contentModel: contentModel
	"Private - Get the value of the 'contentModel' property of the receiver.

		HRESULT __stdcall contentModel(
			[out, retval]ISchemaModelGroup** contentModel);"

	<virtual stdcall: hresult 36 ISchemaModelGroup**>
	^self invalidCall: _failureCode!

get_contentType: contentType
	"Private - Get the value of the 'contentType' property of the receiver.

		HRESULT __stdcall contentType(
			[out, retval]SCHEMACONTENTTYPE* contentType);"

	<virtual stdcall: hresult 35 sdword*>
	^self invalidCall: _failureCode!

get_isAbstract: abstract
	"Private - Get the value of the 'isAbstract' property of the receiver.

		HRESULT __stdcall isAbstract(
			[out, retval]VARIANT_BOOL* abstract);"

	<virtual stdcall: hresult 32 varbool*>
	^self invalidCall: _failureCode!

get_prohibitedSubstitutions: prohibited
	"Private - Get the value of the 'prohibitedSubstitutions' property of the receiver.

		HRESULT __stdcall prohibitedSubstitutions(
			[out, retval]SCHEMADERIVATIONMETHOD* prohibited);"

	<virtual stdcall: hresult 37 sdword*>
	^self invalidCall: _failureCode!

isAbstract
	"Answer the <varbool> value of the 'isAbstract' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_isAbstract: answer.
	^answer asObject
!

prohibitedSubstitutions
	"Answer the <sdword> value of the 'prohibitedSubstitutions' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_prohibitedSubstitutions: answer.
	^answer asObject
! !
!ISchemaComplexType categoriesFor: #anyAttribute!**auto generated**!properties!public! !
!ISchemaComplexType categoriesFor: #attributes!**auto generated**!properties!public! !
!ISchemaComplexType categoriesFor: #contentModel!**auto generated**!properties!public! !
!ISchemaComplexType categoriesFor: #contentType!**auto generated**!properties!public! !
!ISchemaComplexType categoriesFor: #get_anyAttribute:!**auto generated**!COM Interfaces-ISchemaComplexType!private! !
!ISchemaComplexType categoriesFor: #get_attributes:!**auto generated**!COM Interfaces-ISchemaComplexType!private! !
!ISchemaComplexType categoriesFor: #get_contentModel:!**auto generated**!COM Interfaces-ISchemaComplexType!private! !
!ISchemaComplexType categoriesFor: #get_contentType:!**auto generated**!COM Interfaces-ISchemaComplexType!private! !
!ISchemaComplexType categoriesFor: #get_isAbstract:!**auto generated**!COM Interfaces-ISchemaComplexType!private! !
!ISchemaComplexType categoriesFor: #get_prohibitedSubstitutions:!**auto generated**!COM Interfaces-ISchemaComplexType!private! !
!ISchemaComplexType categoriesFor: #isAbstract!**auto generated**!properties!public! !
!ISchemaComplexType categoriesFor: #prohibitedSubstitutions!**auto generated**!properties!public! !

!ISchemaComplexType class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchemaComplexType'
		ISchemaComplexType defineTemplate"

	self
		defineFunction: #get_isAbstract:
			argumentTypes: 'varbool*';
		defineFunction: #get_anyAttribute:
			argumentTypes: 'ISchemaAny**';
		defineFunction: #get_attributes:
			argumentTypes: 'ISchemaItemCollection**';
		defineFunction: #get_contentType:
			argumentTypes: 'sdword*';
		defineFunction: #get_contentModel:
			argumentTypes: 'ISchemaModelGroup**';
		defineFunction: #get_prohibitedSubstitutions:
			argumentTypes: 'sdword*'
! !
!ISchemaComplexType class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

