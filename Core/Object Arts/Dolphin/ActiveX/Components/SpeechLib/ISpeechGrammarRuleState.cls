"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechGrammarRuleState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechGrammarRuleState guid: (IID fromString: '{D4286F2C-EE67-45AE-B928-28D695362EDA}')!
ISpeechGrammarRuleState comment: '<ISpeechGrammarRuleState> is a wrapper class for the COM interface ''SpeechLib.ISpeechGrammarRuleState'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechGrammarRuleState Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(D4286F2C-EE67-45AE-B928-28D695362EDA), 
	helpstring("ISpeechGrammarRuleState Interface"), 
	dual
]
interface ISpeechGrammarRuleState : IDispatch {
	[id(0x00000001), propget, helpstring("Rule")]
	HRESULT __stdcall Rule(
		[out, retval] ISpeechGrammarRule** Rule);
	[id(0x00000002), propget, helpstring("Transitions")]
	HRESULT __stdcall Transitions(
		[out, retval] ISpeechGrammarRuleStateTransitions** Transitions);
	[id(0x00000003), helpstring("AddWordTransition")]
	HRESULT __stdcall AddWordTransition(
		[in] ISpeechGrammarRuleState* DestState,
		[in] BSTR Words,
		[in, defaultvalue(" ")] BSTR Separators,
		[in, defaultvalue(1)] SpeechGrammarWordType Type,
		[in, defaultvalue("")] BSTR PropertyName,
		[in, defaultvalue(0)] long PropertyId,
		[in, defaultvalue("")] VARIANT* PropertyValue,
		[in, defaultvalue(1.0)] single Weight);
	[id(0x00000004), helpstring("AddRuleTransition")]
	HRESULT __stdcall AddRuleTransition(
		[in] ISpeechGrammarRuleState* DestinationState,
		[in] ISpeechGrammarRule* Rule,
		[in, defaultvalue("")] BSTR PropertyName,
		[in, defaultvalue(0)] long PropertyId,
		[in, defaultvalue("")] VARIANT* PropertyValue,
		[in, defaultvalue(1.0)] single Weight);
	[id(0x00000005), helpstring("AddSpecialTransition")]
	HRESULT __stdcall AddSpecialTransition(
		[in] ISpeechGrammarRuleState* DestinationState,
		[in] SpeechSpecialTransitionType Type,
		[in, defaultvalue("")] BSTR PropertyName,
		[in, defaultvalue(0)] long PropertyId,
		[in, defaultvalue("")] VARIANT* PropertyValue,
		[in, defaultvalue(1.0)] single Weight);
};
'!
!ISpeechGrammarRuleState categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechGrammarRuleState methodsFor!

addRuleTransition: destinationState rule: rule
	"Invoke the AddRuleTransition() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 addRuleTransition: destinationState
		 rule: rule
		 propertyName: ''
		 propertyId: 0
		 propertyValue: ''
		 weight: 1.0!

addRuleTransition: destinationState rule: rule propertyName: propertyName propertyId: propertyId propertyValue: propertyValue weight: weight
	"Invoke the AddRuleTransition() method of the COM object.
	Helpstring: 'AddRuleTransition'"

	^self
		AddRuleTransition: destinationState
		Rule: rule
		PropertyName: propertyName
		PropertyId: propertyId
		PropertyValue: propertyValue asVariant
		Weight: weight
!

AddRuleTransition: destinationState Rule: rule PropertyName: propertyName PropertyId: propertyId PropertyValue: propertyValue Weight: weight
	"Private - Invoke the AddRuleTransition() method of the COM object.
	Helpstring: 'AddRuleTransition'

		HRESULT __stdcall AddRuleTransition(
			[in] ISpeechGrammarRuleState* DestinationState,
			[in] ISpeechGrammarRule* Rule,
			[in, defaultvalue("")] BSTR PropertyName,
			[in, defaultvalue(0)] long PropertyId,
			[in, defaultvalue("")] VARIANT* PropertyValue,
			[in, defaultvalue(1.0)] single Weight);"

	<virtual stdcall: hresult 11 ISpeechGrammarRuleState* ISpeechGrammarRule* bstr sdword variant* float>
	^self invalidCall
!

addSpecialTransition: destinationState type: type
	"Invoke the AddSpecialTransition() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 addSpecialTransition: destinationState
		 type: type
		 propertyName: ''
		 propertyId: 0
		 propertyValue: ''
		 weight: 1.0!

addSpecialTransition: destinationState type: type propertyName: propertyName propertyId: propertyId propertyValue: propertyValue weight: weight
	"Invoke the AddSpecialTransition() method of the COM object.
	Helpstring: 'AddSpecialTransition'"

	^self
		AddSpecialTransition: destinationState
		Type: type
		PropertyName: propertyName
		PropertyId: propertyId
		PropertyValue: propertyValue asVariant
		Weight: weight
!

AddSpecialTransition: destinationState Type: type PropertyName: propertyName PropertyId: propertyId PropertyValue: propertyValue Weight: weight
	"Private - Invoke the AddSpecialTransition() method of the COM object.
	Helpstring: 'AddSpecialTransition'

		HRESULT __stdcall AddSpecialTransition(
			[in] ISpeechGrammarRuleState* DestinationState,
			[in] SpeechSpecialTransitionType Type,
			[in, defaultvalue("")] BSTR PropertyName,
			[in, defaultvalue(0)] long PropertyId,
			[in, defaultvalue("")] VARIANT* PropertyValue,
			[in, defaultvalue(1.0)] single Weight);"

	<virtual stdcall: hresult 12 ISpeechGrammarRuleState* sdword bstr sdword variant* float>
	^self invalidCall
!

addWordTransition: destState words: words
	"Invoke the AddWordTransition() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 addWordTransition: destState
		 words: words
		 separators: ' '
		 type: 1
		 propertyName: ''
		 propertyId: 0
		 propertyValue: ''
		 weight: 1.0!

addWordTransition: destState words: words separators: separators type: type propertyName: propertyName propertyId: propertyId propertyValue: propertyValue weight: weight
	"Invoke the AddWordTransition() method of the COM object.
	Helpstring: 'AddWordTransition'"

	^self
		AddWordTransition: destState
		Words: words
		Separators: separators
		Type: type
		PropertyName: propertyName
		PropertyId: propertyId
		PropertyValue: propertyValue asVariant
		Weight: weight
!

AddWordTransition: destState Words: words Separators: separators Type: type PropertyName: propertyName PropertyId: propertyId PropertyValue: propertyValue Weight: weight
	"Private - Invoke the AddWordTransition() method of the COM object.
	Helpstring: 'AddWordTransition'

		HRESULT __stdcall AddWordTransition(
			[in] ISpeechGrammarRuleState* DestState,
			[in] BSTR Words,
			[in, defaultvalue(" ")] BSTR Separators,
			[in, defaultvalue(1)] SpeechGrammarWordType Type,
			[in, defaultvalue("")] BSTR PropertyName,
			[in, defaultvalue(0)] long PropertyId,
			[in, defaultvalue("")] VARIANT* PropertyValue,
			[in, defaultvalue(1.0)] single Weight);"

	<virtual stdcall: hresult 10 ISpeechGrammarRuleState* bstr bstr sdword bstr sdword variant* float>
	^self invalidCall
!

get_Rule: rule
	"Private - Get the value of the 'Rule' property of the receiver.

		HRESULT __stdcall Rule(
			[out, retval] ISpeechGrammarRule** Rule);"

	<virtual stdcall: hresult 8 ISpeechGrammarRule**>
	^self invalidCall
!

get_Transitions: transitions
	"Private - Get the value of the 'Transitions' property of the receiver.

		HRESULT __stdcall Transitions(
			[out, retval] ISpeechGrammarRuleStateTransitions** Transitions);"

	<virtual stdcall: hresult 9 ISpeechGrammarRuleStateTransitions**>
	^self invalidCall
!

rule
	"Answer the <ISpeechGrammarRule> value of the 'Rule' property of the receiver.
	Helpstring: 'Rule'"

	| answer |
	answer := ISpeechGrammarRule newPointer.
	self get_Rule: answer.
	^answer asObject
!

transitions
	"Answer the <ISpeechGrammarRuleStateTransitions> value of the 'Transitions' property of the receiver.
	Helpstring: 'Transitions'"

	| answer |
	answer := ISpeechGrammarRuleStateTransitions newPointer.
	self get_Transitions: answer.
	^answer asObject
! !
!ISpeechGrammarRuleState categoriesFor: #addRuleTransition:rule:!**auto generated**!methods!public! !
!ISpeechGrammarRuleState categoriesFor: #addRuleTransition:rule:propertyName:propertyId:propertyValue:weight:!**auto generated**!methods!public! !
!ISpeechGrammarRuleState categoriesFor: #AddRuleTransition:Rule:PropertyName:PropertyId:PropertyValue:Weight:!**auto generated**!COM Interfaces-ISpeechGrammarRuleState!private! !
!ISpeechGrammarRuleState categoriesFor: #addSpecialTransition:type:!**auto generated**!methods!public! !
!ISpeechGrammarRuleState categoriesFor: #addSpecialTransition:type:propertyName:propertyId:propertyValue:weight:!**auto generated**!methods!public! !
!ISpeechGrammarRuleState categoriesFor: #AddSpecialTransition:Type:PropertyName:PropertyId:PropertyValue:Weight:!**auto generated**!COM Interfaces-ISpeechGrammarRuleState!private! !
!ISpeechGrammarRuleState categoriesFor: #addWordTransition:words:!**auto generated**!methods!public! !
!ISpeechGrammarRuleState categoriesFor: #addWordTransition:words:separators:type:propertyName:propertyId:propertyValue:weight:!**auto generated**!methods!public! !
!ISpeechGrammarRuleState categoriesFor: #AddWordTransition:Words:Separators:Type:PropertyName:PropertyId:PropertyValue:Weight:!**auto generated**!COM Interfaces-ISpeechGrammarRuleState!private! !
!ISpeechGrammarRuleState categoriesFor: #get_Rule:!**auto generated**!COM Interfaces-ISpeechGrammarRuleState!private! !
!ISpeechGrammarRuleState categoriesFor: #get_Transitions:!**auto generated**!COM Interfaces-ISpeechGrammarRuleState!private! !
!ISpeechGrammarRuleState categoriesFor: #rule!**auto generated**!properties!public! !
!ISpeechGrammarRuleState categoriesFor: #transitions!**auto generated**!properties!public! !

!ISpeechGrammarRuleState class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechGrammarRuleState'
		ISpeechGrammarRuleState defineTemplate"

	self
		defineFunction: #get_Rule:
			argumentTypes: 'ISpeechGrammarRule**';
		defineFunction: #get_Transitions:
			argumentTypes: 'ISpeechGrammarRuleStateTransitions**';
		defineFunction: #AddWordTransition:Words:Separators:Type:PropertyName:PropertyId:PropertyValue:Weight:
			argumentTypes: 'ISpeechGrammarRuleState* bstr bstr sdword bstr sdword variant* float';
		defineFunction: #AddRuleTransition:Rule:PropertyName:PropertyId:PropertyValue:Weight:
			argumentTypes: 'ISpeechGrammarRuleState* ISpeechGrammarRule* bstr sdword variant* float';
		defineFunction: #AddSpecialTransition:Type:PropertyName:PropertyId:PropertyValue:Weight:
			argumentTypes: 'ISpeechGrammarRuleState* sdword bstr sdword variant* float'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechGrammarRuleState initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechGrammarRuleState class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechGrammarRuleState class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

