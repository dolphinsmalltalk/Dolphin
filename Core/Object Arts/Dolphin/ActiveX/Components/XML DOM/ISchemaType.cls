"Filed out from Dolphin Smalltalk 7"!

ISchemaItem subclass: #ISchemaType
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ISchemaType guid: (IID fromString: '{50ea08b8-dd1b-4664-9a50-c2f40f4bd79a}')!
ISchemaType comment: '<ISchemaType> is a wrapper class for the COM interface ''MSXML2.ISchemaType'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema Type"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08B8-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema Type"), 
	dual, 
	nonextensible
]
interface ISchemaType : ISchemaItem
 {
	[id(0x00000594), propget]
	HRESULT __stdcall baseTypes(
		[out, retval]ISchemaItemCollection** baseTypes);
	[id(0x0000059d), propget]
	HRESULT __stdcall final(
		[out, retval]SCHEMADERIVATIONMETHOD* final);
	[id(0x000005c8), propget]
	HRESULT __stdcall variety(
		[out, retval]SCHEMATYPEVARIETY* variety);
	[id(0x00000598), propget]
	HRESULT __stdcall derivedBy(
		[out, retval]SCHEMADERIVATIONMETHOD* derivedBy);
	[id(0x000005a5)]
	HRESULT __stdcall isValid(
		[in]BSTR data,
		[out, retval]VARIANT_BOOL* valid);
	[id(0x000005ac), propget]
	HRESULT __stdcall minExclusive(
		[out, retval]BSTR* minExclusive);
	[id(0x000005ad), propget]
	HRESULT __stdcall minInclusive(
		[out, retval]BSTR* minInclusive);
	[id(0x000005a8), propget]
	HRESULT __stdcall maxExclusive(
		[out, retval]BSTR* maxExclusive);
	[id(0x000005a9), propget]
	HRESULT __stdcall maxInclusive(
		[out, retval]BSTR* maxInclusive);
	[id(0x000005c3), propget]
	HRESULT __stdcall totalDigits(
		[out, retval]VARIANT* totalDigits);
	[id(0x0000059f), propget]
	HRESULT __stdcall fractionDigits(
		[out, retval]VARIANT* fractionDigits);
	[id(0x000005a7), propget]
	HRESULT __stdcall length(
		[out, retval]VARIANT* length);
	[id(0x000005ae), propget]
	HRESULT __stdcall minLength(
		[out, retval]VARIANT* minLength);
	[id(0x000005aa), propget]
	HRESULT __stdcall maxLength(
		[out, retval]VARIANT* maxLength);
	[id(0x0000059b), propget]
	HRESULT __stdcall enumeration(
		[out, retval]ISchemaStringCollection** enumeration);
	[id(0x000005ca), propget]
	HRESULT __stdcall whitespace(
		[out, retval]SCHEMAWHITESPACE* whitespace);
	[id(0x000005b6), propget]
	HRESULT __stdcall patterns(
		[out, retval]ISchemaStringCollection** patterns);
};
'!
!ISchemaType categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!ISchemaType methodsFor!

baseTypes
	"Answer the <ISchemaItemCollection> value of the 'baseTypes' property of the receiver."

	| answer |
	answer := ISchemaItemCollection newPointer.
	self get_baseTypes: answer.
	^answer asObject
!

derivedBy
	"Answer the <sdword> value of the 'derivedBy' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_derivedBy: answer.
	^answer asObject
!

enumeration
	"Answer the <ISchemaStringCollection> value of the 'enumeration' property of the receiver."

	| answer |
	answer := ISchemaStringCollection newPointer.
	self get_enumeration: answer.
	^answer asObject
!

final
	"Answer the <sdword> value of the 'final' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_final: answer.
	^answer asObject
!

fractionDigits
	"Answer the <variant> value of the 'fractionDigits' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_fractionDigits: answer.
	^answer asObject
!

get_baseTypes: baseTypes
	"Private - Get the value of the 'baseTypes' property of the receiver.

		HRESULT __stdcall baseTypes(
			[out, retval]ISchemaItemCollection** baseTypes);"

	<virtual stdcall: hresult 15 ISchemaItemCollection**>
	^self invalidCall: _failureCode!

get_derivedBy: derivedBy
	"Private - Get the value of the 'derivedBy' property of the receiver.

		HRESULT __stdcall derivedBy(
			[out, retval]SCHEMADERIVATIONMETHOD* derivedBy);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall: _failureCode!

get_enumeration: enumeration
	"Private - Get the value of the 'enumeration' property of the receiver.

		HRESULT __stdcall enumeration(
			[out, retval]ISchemaStringCollection** enumeration);"

	<virtual stdcall: hresult 29 ISchemaStringCollection**>
	^self invalidCall: _failureCode!

get_final: final
	"Private - Get the value of the 'final' property of the receiver.

		HRESULT __stdcall final(
			[out, retval]SCHEMADERIVATIONMETHOD* final);"

	<virtual stdcall: hresult 16 sdword*>
	^self invalidCall: _failureCode!

get_fractionDigits: fractionDigits
	"Private - Get the value of the 'fractionDigits' property of the receiver.

		HRESULT __stdcall fractionDigits(
			[out, retval]VARIANT* fractionDigits);"

	<virtual stdcall: hresult 25 variant*>
	^self invalidCall: _failureCode!

get_length: length
	"Private - Get the value of the 'length' property of the receiver.

		HRESULT __stdcall length(
			[out, retval]VARIANT* length);"

	<virtual stdcall: hresult 26 variant*>
	^self invalidCall: _failureCode!

get_maxExclusive: maxExclusive
	"Private - Get the value of the 'maxExclusive' property of the receiver.

		HRESULT __stdcall maxExclusive(
			[out, retval]BSTR* maxExclusive);"

	<virtual stdcall: hresult 22 bstr*>
	^self invalidCall: _failureCode!

get_maxInclusive: maxInclusive
	"Private - Get the value of the 'maxInclusive' property of the receiver.

		HRESULT __stdcall maxInclusive(
			[out, retval]BSTR* maxInclusive);"

	<virtual stdcall: hresult 23 bstr*>
	^self invalidCall: _failureCode!

get_maxLength: maxLength
	"Private - Get the value of the 'maxLength' property of the receiver.

		HRESULT __stdcall maxLength(
			[out, retval]VARIANT* maxLength);"

	<virtual stdcall: hresult 28 variant*>
	^self invalidCall: _failureCode!

get_minExclusive: minExclusive
	"Private - Get the value of the 'minExclusive' property of the receiver.

		HRESULT __stdcall minExclusive(
			[out, retval]BSTR* minExclusive);"

	<virtual stdcall: hresult 20 bstr*>
	^self invalidCall: _failureCode!

get_minInclusive: minInclusive
	"Private - Get the value of the 'minInclusive' property of the receiver.

		HRESULT __stdcall minInclusive(
			[out, retval]BSTR* minInclusive);"

	<virtual stdcall: hresult 21 bstr*>
	^self invalidCall: _failureCode!

get_minLength: minLength
	"Private - Get the value of the 'minLength' property of the receiver.

		HRESULT __stdcall minLength(
			[out, retval]VARIANT* minLength);"

	<virtual stdcall: hresult 27 variant*>
	^self invalidCall: _failureCode!

get_patterns: patterns
	"Private - Get the value of the 'patterns' property of the receiver.

		HRESULT __stdcall patterns(
			[out, retval]ISchemaStringCollection** patterns);"

	<virtual stdcall: hresult 31 ISchemaStringCollection**>
	^self invalidCall: _failureCode!

get_totalDigits: totalDigits
	"Private - Get the value of the 'totalDigits' property of the receiver.

		HRESULT __stdcall totalDigits(
			[out, retval]VARIANT* totalDigits);"

	<virtual stdcall: hresult 24 variant*>
	^self invalidCall: _failureCode!

get_variety: variety
	"Private - Get the value of the 'variety' property of the receiver.

		HRESULT __stdcall variety(
			[out, retval]SCHEMATYPEVARIETY* variety);"

	<virtual stdcall: hresult 17 sdword*>
	^self invalidCall: _failureCode!

get_whitespace: whitespace
	"Private - Get the value of the 'whitespace' property of the receiver.

		HRESULT __stdcall whitespace(
			[out, retval]SCHEMAWHITESPACE* whitespace);"

	<virtual stdcall: hresult 30 sdword*>
	^self invalidCall: _failureCode!

isValid: data
	"Answer the <VARIANT_BOOL> result of invoking the isValid() method of the COM object."

	| answer |
	answer := (VARIANT_BOOL new).
	self
		IsValid: data
		valid: answer.
	^answer asObject
!

IsValid: data valid: valid
	"Private - Invoke the isValid() method of the COM object.

		HRESULT __stdcall isValid(
			[in]BSTR data,
			[out, retval]VARIANT_BOOL* valid);"

	<virtual stdcall: hresult 19 bstr varbool*>
	^self invalidCall: _failureCode!

length
	"Answer the <variant> value of the 'length' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_length: answer.
	^answer asObject
!

maxExclusive
	"Answer the <bstr> value of the 'maxExclusive' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_maxExclusive: answer.
	^answer asObject
!

maxInclusive
	"Answer the <bstr> value of the 'maxInclusive' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_maxInclusive: answer.
	^answer asObject
!

maxLength
	"Answer the <variant> value of the 'maxLength' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_maxLength: answer.
	^answer asObject
!

minExclusive
	"Answer the <bstr> value of the 'minExclusive' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_minExclusive: answer.
	^answer asObject
!

minInclusive
	"Answer the <bstr> value of the 'minInclusive' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_minInclusive: answer.
	^answer asObject
!

minLength
	"Answer the <variant> value of the 'minLength' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_minLength: answer.
	^answer asObject
!

patterns
	"Answer the <ISchemaStringCollection> value of the 'patterns' property of the receiver."

	| answer |
	answer := ISchemaStringCollection newPointer.
	self get_patterns: answer.
	^answer asObject
!

totalDigits
	"Answer the <variant> value of the 'totalDigits' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_totalDigits: answer.
	^answer asObject
!

variety
	"Answer the <sdword> value of the 'variety' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_variety: answer.
	^answer asObject
!

whitespace
	"Answer the <sdword> value of the 'whitespace' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_whitespace: answer.
	^answer asObject
! !
!ISchemaType categoriesFor: #baseTypes!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #derivedBy!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #enumeration!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #final!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #fractionDigits!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #get_baseTypes:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_derivedBy:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_enumeration:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_final:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_fractionDigits:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_length:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_maxExclusive:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_maxInclusive:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_maxLength:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_minExclusive:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_minInclusive:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_minLength:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_patterns:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_totalDigits:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_variety:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #get_whitespace:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #isValid:!**auto generated**!methods!public! !
!ISchemaType categoriesFor: #IsValid:valid:!**auto generated**!COM Interfaces-ISchemaType!private! !
!ISchemaType categoriesFor: #length!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #maxExclusive!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #maxInclusive!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #maxLength!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #minExclusive!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #minInclusive!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #minLength!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #patterns!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #totalDigits!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #variety!**auto generated**!properties!public! !
!ISchemaType categoriesFor: #whitespace!**auto generated**!properties!public! !

!ISchemaType class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchemaType'
		ISchemaType defineTemplate"

	self
		defineFunction: #get_baseTypes:
			argumentTypes: 'ISchemaItemCollection**';
		defineFunction: #get_final:
			argumentTypes: 'sdword*';
		defineFunction: #get_variety:
			argumentTypes: 'sdword*';
		defineFunction: #get_derivedBy:
			argumentTypes: 'sdword*';
		defineFunction: #IsValid:valid:
			argumentTypes: 'bstr varbool*';
		defineFunction: #get_minExclusive:
			argumentTypes: 'bstr*';
		defineFunction: #get_minInclusive:
			argumentTypes: 'bstr*';
		defineFunction: #get_maxExclusive:
			argumentTypes: 'bstr*';
		defineFunction: #get_maxInclusive:
			argumentTypes: 'bstr*';
		defineFunction: #get_totalDigits:
			argumentTypes: 'variant*';
		defineFunction: #get_fractionDigits:
			argumentTypes: 'variant*';
		defineFunction: #get_length:
			argumentTypes: 'variant*';
		defineFunction: #get_minLength:
			argumentTypes: 'variant*';
		defineFunction: #get_maxLength:
			argumentTypes: 'variant*';
		defineFunction: #get_enumeration:
			argumentTypes: 'ISchemaStringCollection**';
		defineFunction: #get_whitespace:
			argumentTypes: 'sdword*';
		defineFunction: #get_patterns:
			argumentTypes: 'ISchemaStringCollection**'
! !
!ISchemaType class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

