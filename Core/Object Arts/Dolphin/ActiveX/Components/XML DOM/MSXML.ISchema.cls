"Filed out from Dolphin Smalltalk 7"!

ISchemaItem subclass: #ISchema
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ISchema guid: (IID fromString: '{50ea08b4-dd1b-4664-9a50-c2f40f4bd79a}')!
ISchema comment: '<ISchema> is a wrapper class for the COM interface ''MSXML2.ISchema'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08B4-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema"), 
	dual, 
	nonextensible
]
interface ISchema : ISchemaItem
 {
	[id(0x000005c2), propget]
	HRESULT __stdcall targetNamespace(
		[out, retval]BSTR* targetNamespace);
	[id(0x000005c9), propget]
	HRESULT __stdcall version(
		[out, retval]BSTR* version);
	[id(0x000005c5), propget]
	HRESULT __stdcall types(
		[out, retval]ISchemaItemCollection** types);
	[id(0x0000059a), propget]
	HRESULT __stdcall elements(
		[out, retval]ISchemaItemCollection** elements);
	[id(0x00000593), propget]
	HRESULT __stdcall attributes(
		[out, retval]ISchemaItemCollection** attributes);
	[id(0x00000592), propget]
	HRESULT __stdcall attributeGroups(
		[out, retval]ISchemaItemCollection** attributeGroups);
	[id(0x000005b0), propget]
	HRESULT __stdcall modelGroups(
		[out, retval]ISchemaItemCollection** modelGroups);
	[id(0x000005b4), propget]
	HRESULT __stdcall notations(
		[out, retval]ISchemaItemCollection** notations);
	[id(0x000005bc), propget]
	HRESULT __stdcall schemaLocations(
		[out, retval]ISchemaStringCollection** schemaLocations);
};
'!
!ISchema categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!ISchema methodsFor!

attributeGroups
	"Answer the <ISchemaItemCollection> value of the 'attributeGroups' property of the receiver."

	| answer |
	answer := ISchemaItemCollection newPointer.
	self get_attributeGroups: answer.
	^answer asObject
!

attributes
	"Answer the <ISchemaItemCollection> value of the 'attributes' property of the receiver."

	| answer |
	answer := ISchemaItemCollection newPointer.
	self get_attributes: answer.
	^answer asObject
!

elements
	"Answer the <ISchemaItemCollection> value of the 'elements' property of the receiver."

	| answer |
	answer := ISchemaItemCollection newPointer.
	self get_elements: answer.
	^answer asObject
!

get_attributeGroups: attributeGroups
	"Private - Get the value of the 'attributeGroups' property of the receiver.

		HRESULT __stdcall attributeGroups(
			[out, retval]ISchemaItemCollection** attributeGroups);"

	<virtual stdcall: hresult 20 ISchemaItemCollection**>
	^self invalidCall: _failureCode!

get_attributes: attributes
	"Private - Get the value of the 'attributes' property of the receiver.

		HRESULT __stdcall attributes(
			[out, retval]ISchemaItemCollection** attributes);"

	<virtual stdcall: hresult 19 ISchemaItemCollection**>
	^self invalidCall: _failureCode!

get_elements: elements
	"Private - Get the value of the 'elements' property of the receiver.

		HRESULT __stdcall elements(
			[out, retval]ISchemaItemCollection** elements);"

	<virtual stdcall: hresult 18 ISchemaItemCollection**>
	^self invalidCall: _failureCode!

get_modelGroups: modelGroups
	"Private - Get the value of the 'modelGroups' property of the receiver.

		HRESULT __stdcall modelGroups(
			[out, retval]ISchemaItemCollection** modelGroups);"

	<virtual stdcall: hresult 21 ISchemaItemCollection**>
	^self invalidCall: _failureCode!

get_notations: notations
	"Private - Get the value of the 'notations' property of the receiver.

		HRESULT __stdcall notations(
			[out, retval]ISchemaItemCollection** notations);"

	<virtual stdcall: hresult 22 ISchemaItemCollection**>
	^self invalidCall: _failureCode!

get_schemaLocations: schemaLocations
	"Private - Get the value of the 'schemaLocations' property of the receiver.

		HRESULT __stdcall schemaLocations(
			[out, retval]ISchemaStringCollection** schemaLocations);"

	<virtual stdcall: hresult 23 ISchemaStringCollection**>
	^self invalidCall: _failureCode!

get_targetNamespace: targetNamespace
	"Private - Get the value of the 'targetNamespace' property of the receiver.

		HRESULT __stdcall targetNamespace(
			[out, retval]BSTR* targetNamespace);"

	<virtual stdcall: hresult 15 bstr*>
	^self invalidCall: _failureCode!

get_types: types
	"Private - Get the value of the 'types' property of the receiver.

		HRESULT __stdcall types(
			[out, retval]ISchemaItemCollection** types);"

	<virtual stdcall: hresult 17 ISchemaItemCollection**>
	^self invalidCall: _failureCode!

get_version: version
	"Private - Get the value of the 'version' property of the receiver.

		HRESULT __stdcall version(
			[out, retval]BSTR* version);"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall: _failureCode!

modelGroups
	"Answer the <ISchemaItemCollection> value of the 'modelGroups' property of the receiver."

	| answer |
	answer := ISchemaItemCollection newPointer.
	self get_modelGroups: answer.
	^answer asObject
!

notations
	"Answer the <ISchemaItemCollection> value of the 'notations' property of the receiver."

	| answer |
	answer := ISchemaItemCollection newPointer.
	self get_notations: answer.
	^answer asObject
!

schemaLocations
	"Answer the <ISchemaStringCollection> value of the 'schemaLocations' property of the receiver."

	| answer |
	answer := ISchemaStringCollection newPointer.
	self get_schemaLocations: answer.
	^answer asObject
!

targetNamespace
	"Answer the <bstr> value of the 'targetNamespace' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_targetNamespace: answer.
	^answer asObject
!

types
	"Answer the <ISchemaItemCollection> value of the 'types' property of the receiver."

	| answer |
	answer := ISchemaItemCollection newPointer.
	self get_types: answer.
	^answer asObject
!

version
	"Answer the <bstr> value of the 'version' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_version: answer.
	^answer asObject
! !
!ISchema categoriesFor: #attributeGroups!**auto generated**!properties!public! !
!ISchema categoriesFor: #attributes!**auto generated**!properties!public! !
!ISchema categoriesFor: #elements!**auto generated**!properties!public! !
!ISchema categoriesFor: #get_attributeGroups:!**auto generated**!COM Interfaces-ISchema!private! !
!ISchema categoriesFor: #get_attributes:!**auto generated**!COM Interfaces-ISchema!private! !
!ISchema categoriesFor: #get_elements:!**auto generated**!COM Interfaces-ISchema!private! !
!ISchema categoriesFor: #get_modelGroups:!**auto generated**!COM Interfaces-ISchema!private! !
!ISchema categoriesFor: #get_notations:!**auto generated**!COM Interfaces-ISchema!private! !
!ISchema categoriesFor: #get_schemaLocations:!**auto generated**!COM Interfaces-ISchema!private! !
!ISchema categoriesFor: #get_targetNamespace:!**auto generated**!COM Interfaces-ISchema!private! !
!ISchema categoriesFor: #get_types:!**auto generated**!COM Interfaces-ISchema!private! !
!ISchema categoriesFor: #get_version:!**auto generated**!COM Interfaces-ISchema!private! !
!ISchema categoriesFor: #modelGroups!**auto generated**!properties!public! !
!ISchema categoriesFor: #notations!**auto generated**!properties!public! !
!ISchema categoriesFor: #schemaLocations!**auto generated**!properties!public! !
!ISchema categoriesFor: #targetNamespace!**auto generated**!properties!public! !
!ISchema categoriesFor: #types!**auto generated**!properties!public! !
!ISchema categoriesFor: #version!**auto generated**!properties!public! !

!ISchema class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchema'
		ISchema defineTemplate"

	self
		defineFunction: #get_targetNamespace:
			argumentTypes: 'bstr*';
		defineFunction: #get_version:
			argumentTypes: 'bstr*';
		defineFunction: #get_types:
			argumentTypes: 'ISchemaItemCollection**';
		defineFunction: #get_elements:
			argumentTypes: 'ISchemaItemCollection**';
		defineFunction: #get_attributes:
			argumentTypes: 'ISchemaItemCollection**';
		defineFunction: #get_attributeGroups:
			argumentTypes: 'ISchemaItemCollection**';
		defineFunction: #get_modelGroups:
			argumentTypes: 'ISchemaItemCollection**';
		defineFunction: #get_notations:
			argumentTypes: 'ISchemaItemCollection**';
		defineFunction: #get_schemaLocations:
			argumentTypes: 'ISchemaStringCollection**'
! !
!ISchema class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

