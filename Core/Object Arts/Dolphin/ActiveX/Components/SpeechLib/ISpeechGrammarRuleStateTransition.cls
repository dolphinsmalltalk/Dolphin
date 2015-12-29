"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechGrammarRuleStateTransition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechGrammarRuleStateTransition guid: (IID fromString: '{CAFD1DB1-41D1-4A06-9863-E2E81DA17A9A}')!
ISpeechGrammarRuleStateTransition comment: '<ISpeechGrammarRuleStateTransition> is a wrapper class for the COM interface ''SpeechLib.ISpeechGrammarRuleStateTransition'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechGrammarRuleStateTransition Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(CAFD1DB1-41D1-4A06-9863-E2E81DA17A9A), 
	helpstring("ISpeechGrammarRuleStateTransition Interface"), 
	dual
]
interface ISpeechGrammarRuleStateTransition : IDispatch {
	[id(0x00000001), propget, helpstring("Type")]
	HRESULT __stdcall Type(
		[out, retval] SpeechGrammarRuleStateTransitionType* Type);
	[id(0x00000002), propget, helpstring("Text")]
	HRESULT __stdcall Text(
		[out, retval] BSTR* Text);
	[id(0x00000003), propget, helpstring("Rule")]
	HRESULT __stdcall Rule(
		[out, retval] ISpeechGrammarRule** Rule);
	[id(0x00000004), propget, helpstring("Weight")]
	HRESULT __stdcall Weight(
		[out, retval] VARIANT* Weight);
	[id(0x00000005), propget, helpstring("PropertyName")]
	HRESULT __stdcall PropertyName(
		[out, retval] BSTR* PropertyName);
	[id(0x00000006), propget, helpstring("PropertyId")]
	HRESULT __stdcall PropertyId(
		[out, retval] long* PropertyId);
	[id(0x00000007), propget, helpstring("PropertyValue")]
	HRESULT __stdcall PropertyValue(
		[out, retval] VARIANT* PropertyValue);
	[id(0x00000008), propget, helpstring("NextState")]
	HRESULT __stdcall NextState(
		[out, retval] ISpeechGrammarRuleState** NextState);
};
'!
!ISpeechGrammarRuleStateTransition categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechGrammarRuleStateTransition methodsFor!

get_NextState: nextState
	"Private - Get the value of the 'NextState' property of the receiver.

		HRESULT __stdcall NextState(
			[out, retval] ISpeechGrammarRuleState** NextState);"

	<virtual stdcall: hresult 15 ISpeechGrammarRuleState**>
	^self invalidCall
!

get_PropertyId: propertyId
	"Private - Get the value of the 'PropertyId' property of the receiver.

		HRESULT __stdcall PropertyId(
			[out, retval] long* PropertyId);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall
!

get_PropertyName: propertyName
	"Private - Get the value of the 'PropertyName' property of the receiver.

		HRESULT __stdcall PropertyName(
			[out, retval] BSTR* PropertyName);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall
!

get_PropertyValue: propertyValue
	"Private - Get the value of the 'PropertyValue' property of the receiver.

		HRESULT __stdcall PropertyValue(
			[out, retval] VARIANT* PropertyValue);"

	<virtual stdcall: hresult 14 variant*>
	^self invalidCall
!

get_Rule: rule
	"Private - Get the value of the 'Rule' property of the receiver.

		HRESULT __stdcall Rule(
			[out, retval] ISpeechGrammarRule** Rule);"

	<virtual stdcall: hresult 10 ISpeechGrammarRule**>
	^self invalidCall
!

get_Text: text
	"Private - Get the value of the 'Text' property of the receiver.

		HRESULT __stdcall Text(
			[out, retval] BSTR* Text);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall
!

get_Type: type
	"Private - Get the value of the 'Type' property of the receiver.

		HRESULT __stdcall Type(
			[out, retval] SpeechGrammarRuleStateTransitionType* Type);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_Weight: weight
	"Private - Get the value of the 'Weight' property of the receiver.

		HRESULT __stdcall Weight(
			[out, retval] VARIANT* Weight);"

	<virtual stdcall: hresult 11 variant*>
	^self invalidCall
!

nextState
	"Answer the <ISpeechGrammarRuleState> value of the 'NextState' property of the receiver.
	Helpstring: 'NextState'"

	| answer |
	answer := ISpeechGrammarRuleState newPointer.
	self get_NextState: answer.
	^answer asObject
!

propertyId
	"Answer the <sdword> value of the 'PropertyId' property of the receiver.
	Helpstring: 'PropertyId'"

	| answer |
	answer := (SDWORD new).
	self get_PropertyId: answer.
	^answer asObject
!

propertyName
	"Answer the <bstr> value of the 'PropertyName' property of the receiver.
	Helpstring: 'PropertyName'"

	| answer |
	answer := BSTR new.
	self get_PropertyName: answer.
	^answer asObject
!

propertyValue
	"Answer the <variant> value of the 'PropertyValue' property of the receiver.
	Helpstring: 'PropertyValue'"

	| answer |
	answer := VARIANT new.
	self get_PropertyValue: answer.
	^answer asObject
!

rule
	"Answer the <ISpeechGrammarRule> value of the 'Rule' property of the receiver.
	Helpstring: 'Rule'"

	| answer |
	answer := ISpeechGrammarRule newPointer.
	self get_Rule: answer.
	^answer asObject
!

text
	"Answer the <bstr> value of the 'Text' property of the receiver.
	Helpstring: 'Text'"

	| answer |
	answer := BSTR new.
	self get_Text: answer.
	^answer asObject
!

type
	"Answer the <sdword> value of the 'Type' property of the receiver.
	Helpstring: 'Type'"

	| answer |
	answer := (SDWORD new).
	self get_Type: answer.
	^answer asObject
!

weight
	"Answer the <variant> value of the 'Weight' property of the receiver.
	Helpstring: 'Weight'"

	| answer |
	answer := VARIANT new.
	self get_Weight: answer.
	^answer asObject
! !
!ISpeechGrammarRuleStateTransition categoriesFor: #get_NextState:!**auto generated**!COM Interfaces-ISpeechGrammarRuleStateTransition!private! !
!ISpeechGrammarRuleStateTransition categoriesFor: #get_PropertyId:!**auto generated**!COM Interfaces-ISpeechGrammarRuleStateTransition!private! !
!ISpeechGrammarRuleStateTransition categoriesFor: #get_PropertyName:!**auto generated**!COM Interfaces-ISpeechGrammarRuleStateTransition!private! !
!ISpeechGrammarRuleStateTransition categoriesFor: #get_PropertyValue:!**auto generated**!COM Interfaces-ISpeechGrammarRuleStateTransition!private! !
!ISpeechGrammarRuleStateTransition categoriesFor: #get_Rule:!**auto generated**!COM Interfaces-ISpeechGrammarRuleStateTransition!private! !
!ISpeechGrammarRuleStateTransition categoriesFor: #get_Text:!**auto generated**!COM Interfaces-ISpeechGrammarRuleStateTransition!private! !
!ISpeechGrammarRuleStateTransition categoriesFor: #get_Type:!**auto generated**!COM Interfaces-ISpeechGrammarRuleStateTransition!private! !
!ISpeechGrammarRuleStateTransition categoriesFor: #get_Weight:!**auto generated**!COM Interfaces-ISpeechGrammarRuleStateTransition!private! !
!ISpeechGrammarRuleStateTransition categoriesFor: #nextState!**auto generated**!properties!public! !
!ISpeechGrammarRuleStateTransition categoriesFor: #propertyId!**auto generated**!properties!public! !
!ISpeechGrammarRuleStateTransition categoriesFor: #propertyName!**auto generated**!properties!public! !
!ISpeechGrammarRuleStateTransition categoriesFor: #propertyValue!**auto generated**!properties!public! !
!ISpeechGrammarRuleStateTransition categoriesFor: #rule!**auto generated**!properties!public! !
!ISpeechGrammarRuleStateTransition categoriesFor: #text!**auto generated**!properties!public! !
!ISpeechGrammarRuleStateTransition categoriesFor: #type!**auto generated**!properties!public! !
!ISpeechGrammarRuleStateTransition categoriesFor: #weight!**auto generated**!properties!public! !

!ISpeechGrammarRuleStateTransition class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechGrammarRuleStateTransition'
		ISpeechGrammarRuleStateTransition defineTemplate"

	self
		defineFunction: #get_Type:
			argumentTypes: 'sdword*';
		defineFunction: #get_Text:
			argumentTypes: 'bstr*';
		defineFunction: #get_Rule:
			argumentTypes: 'ISpeechGrammarRule**';
		defineFunction: #get_Weight:
			argumentTypes: 'variant*';
		defineFunction: #get_PropertyName:
			argumentTypes: 'bstr*';
		defineFunction: #get_PropertyId:
			argumentTypes: 'sdword*';
		defineFunction: #get_PropertyValue:
			argumentTypes: 'variant*';
		defineFunction: #get_NextState:
			argumentTypes: 'ISpeechGrammarRuleState**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechGrammarRuleStateTransition initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechGrammarRuleStateTransition class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechGrammarRuleStateTransition class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

