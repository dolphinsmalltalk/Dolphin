"Filed out from Dolphin Smalltalk 7"!

MSXML.ISchemaParticle subclass: #'MSXML.ISchemaElement'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISchemaElement guid: (OS.COM.IID fromString: '{50ea08b7-dd1b-4664-9a50-c2f40f4bd79a}')!
MSXML.ISchemaElement comment: '<ISchemaElement> is a wrapper class for the COM interface ''MSXML2.ISchemaElement'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema Element"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08B7-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema Element"), 
	dual, 
	nonextensible
]
interface ISchemaElement : ISchemaParticle
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
	[id(0x000005a3), propget]
	HRESULT __stdcall isNillable(
		[out, retval]VARIANT_BOOL* nillable);
	[id(0x000005a1), propget]
	HRESULT __stdcall identityConstraints(
		[out, retval]ISchemaItemCollection** constraints);
	[id(0x000005bf), propget]
	HRESULT __stdcall substitutionGroup(
		[out, retval]ISchemaElement** element);
	[id(0x000005c0), propget]
	HRESULT __stdcall substitutionGroupExclusions(
		[out, retval]SCHEMADERIVATIONMETHOD* exclusions);
	[id(0x00000599), propget]
	HRESULT __stdcall disallowedSubstitutions(
		[out, retval]SCHEMADERIVATIONMETHOD* disallowed);
	[id(0x000005a2), propget]
	HRESULT __stdcall isAbstract(
		[out, retval]VARIANT_BOOL* abstract);
	[id(0x000005a4), propget]
	HRESULT __stdcall isReference(
		[out, retval]VARIANT_BOOL* reference);
};
'!
!MSXML.ISchemaElement categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISchemaElement methodsFor!

defaultValue
	"Answer the <bstr> value of the 'defaultValue' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_defaultValue: answer.
	^answer asObject
!

disallowedSubstitutions
	"Answer the <sdword> value of the 'disallowedSubstitutions' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_disallowedSubstitutions: answer.
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

	<virtual stdcall: hresult 19 bstr*>
	^self invalidCall: _failureCode!

get_disallowedSubstitutions: disallowed
	"Private - Get the value of the 'disallowedSubstitutions' property of the receiver.

		HRESULT __stdcall disallowedSubstitutions(
			[out, retval]SCHEMADERIVATIONMETHOD* disallowed);"

	<virtual stdcall: hresult 25 sdword*>
	^self invalidCall: _failureCode!

get_fixedValue: fixedValue
	"Private - Get the value of the 'fixedValue' property of the receiver.

		HRESULT __stdcall fixedValue(
			[out, retval]BSTR* fixedValue);"

	<virtual stdcall: hresult 20 bstr*>
	^self invalidCall: _failureCode!

get_identityConstraints: constraints
	"Private - Get the value of the 'identityConstraints' property of the receiver.

		HRESULT __stdcall identityConstraints(
			[out, retval]ISchemaItemCollection** constraints);"

	<virtual stdcall: hresult 22 ISchemaItemCollection**>
	^self invalidCall: _failureCode!

get_isAbstract: abstract
	"Private - Get the value of the 'isAbstract' property of the receiver.

		HRESULT __stdcall isAbstract(
			[out, retval]VARIANT_BOOL* abstract);"

	<virtual stdcall: hresult 26 varbool*>
	^self invalidCall: _failureCode!

get_isNillable: nillable
	"Private - Get the value of the 'isNillable' property of the receiver.

		HRESULT __stdcall isNillable(
			[out, retval]VARIANT_BOOL* nillable);"

	<virtual stdcall: hresult 21 varbool*>
	^self invalidCall: _failureCode!

get_isReference: reference
	"Private - Get the value of the 'isReference' property of the receiver.

		HRESULT __stdcall isReference(
			[out, retval]VARIANT_BOOL* reference);"

	<virtual stdcall: hresult 27 varbool*>
	^self invalidCall: _failureCode!

get_scope: scope
	"Private - Get the value of the 'scope' property of the receiver.

		HRESULT __stdcall scope(
			[out, retval]ISchemaComplexType** scope);"

	<virtual stdcall: hresult 18 ISchemaComplexType**>
	^self invalidCall: _failureCode!

get_substitutionGroup: element
	"Private - Get the value of the 'substitutionGroup' property of the receiver.

		HRESULT __stdcall substitutionGroup(
			[out, retval]ISchemaElement** element);"

	<virtual stdcall: hresult 23 ISchemaElement**>
	^self invalidCall: _failureCode!

get_substitutionGroupExclusions: exclusions
	"Private - Get the value of the 'substitutionGroupExclusions' property of the receiver.

		HRESULT __stdcall substitutionGroupExclusions(
			[out, retval]SCHEMADERIVATIONMETHOD* exclusions);"

	<virtual stdcall: hresult 24 sdword*>
	^self invalidCall: _failureCode!

get_type: type
	"Private - Get the value of the 'type' property of the receiver.

		HRESULT __stdcall type(
			[out, retval]ISchemaType** type);"

	<virtual stdcall: hresult 17 ISchemaType**>
	^self invalidCall: _failureCode!

identityConstraints
	"Answer the <ISchemaItemCollection> value of the 'identityConstraints' property of the receiver."

	| answer |
	answer := ISchemaItemCollection newPointer.
	self get_identityConstraints: answer.
	^answer asObject!

isAbstract
	"Answer the <varbool> value of the 'isAbstract' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_isAbstract: answer.
	^answer asObject
!

isNillable
	"Answer the <varbool> value of the 'isNillable' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_isNillable: answer.
	^answer asObject
!

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

substitutionGroup
	"Answer the <ISchemaElement> value of the 'substitutionGroup' property of the receiver."

	| answer |
	answer := ISchemaElement newPointer.
	self get_substitutionGroup: answer.
	^answer asObject!

substitutionGroupExclusions
	"Answer the <sdword> value of the 'substitutionGroupExclusions' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_substitutionGroupExclusions: answer.
	^answer asObject
!

type
	"Answer the <ISchemaType> value of the 'type' property of the receiver."

	| answer |
	answer := ISchemaType newPointer.
	self get_type: answer.
	^answer asObject! !
!MSXML.ISchemaElement categoriesFor: #defaultValue!**auto generated**!properties!public! !
!MSXML.ISchemaElement categoriesFor: #disallowedSubstitutions!**auto generated**!properties!public! !
!MSXML.ISchemaElement categoriesFor: #fixedValue!**auto generated**!properties!public! !
!MSXML.ISchemaElement categoriesFor: #get_defaultValue:!**auto generated**!COM Interfaces-ISchemaElement!private! !
!MSXML.ISchemaElement categoriesFor: #get_disallowedSubstitutions:!**auto generated**!COM Interfaces-ISchemaElement!private! !
!MSXML.ISchemaElement categoriesFor: #get_fixedValue:!**auto generated**!COM Interfaces-ISchemaElement!private! !
!MSXML.ISchemaElement categoriesFor: #get_identityConstraints:!**auto generated**!COM Interfaces-ISchemaElement!private! !
!MSXML.ISchemaElement categoriesFor: #get_isAbstract:!**auto generated**!COM Interfaces-ISchemaElement!private! !
!MSXML.ISchemaElement categoriesFor: #get_isNillable:!**auto generated**!COM Interfaces-ISchemaElement!private! !
!MSXML.ISchemaElement categoriesFor: #get_isReference:!**auto generated**!COM Interfaces-ISchemaElement!private! !
!MSXML.ISchemaElement categoriesFor: #get_scope:!**auto generated**!COM Interfaces-ISchemaElement!private! !
!MSXML.ISchemaElement categoriesFor: #get_substitutionGroup:!**auto generated**!COM Interfaces-ISchemaElement!private! !
!MSXML.ISchemaElement categoriesFor: #get_substitutionGroupExclusions:!**auto generated**!COM Interfaces-ISchemaElement!private! !
!MSXML.ISchemaElement categoriesFor: #get_type:!**auto generated**!COM Interfaces-ISchemaElement!private! !
!MSXML.ISchemaElement categoriesFor: #identityConstraints!**auto generated**!properties!public! !
!MSXML.ISchemaElement categoriesFor: #isAbstract!**auto generated**!properties!public! !
!MSXML.ISchemaElement categoriesFor: #isNillable!**auto generated**!properties!public! !
!MSXML.ISchemaElement categoriesFor: #isReference!**auto generated**!properties!public! !
!MSXML.ISchemaElement categoriesFor: #scope!**auto generated**!properties!public! !
!MSXML.ISchemaElement categoriesFor: #substitutionGroup!**auto generated**!properties!public! !
!MSXML.ISchemaElement categoriesFor: #substitutionGroupExclusions!**auto generated**!properties!public! !
!MSXML.ISchemaElement categoriesFor: #type!**auto generated**!properties!public! !

!MSXML.ISchemaElement class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchemaElement'
		ISchemaElement defineTemplate"

	self
		defineFunction: #get_type:
			argumentTypes: 'ISchemaType**';
		defineFunction: #get_scope:
			argumentTypes: 'ISchemaComplexType**';
		defineFunction: #get_defaultValue:
			argumentTypes: 'bstr*';
		defineFunction: #get_fixedValue:
			argumentTypes: 'bstr*';
		defineFunction: #get_isNillable:
			argumentTypes: 'varbool*';
		defineFunction: #get_identityConstraints:
			argumentTypes: 'ISchemaItemCollection**';
		defineFunction: #get_substitutionGroup:
			argumentTypes: 'ISchemaElement**';
		defineFunction: #get_substitutionGroupExclusions:
			argumentTypes: 'sdword*';
		defineFunction: #get_disallowedSubstitutions:
			argumentTypes: 'sdword*';
		defineFunction: #get_isAbstract:
			argumentTypes: 'varbool*';
		defineFunction: #get_isReference:
			argumentTypes: 'varbool*'
! !
!MSXML.ISchemaElement class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

