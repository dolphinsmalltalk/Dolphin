"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechGrammarRuleStateTransitions
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechGrammarRuleStateTransitions guid: (IID fromString: '{EABCE657-75BC-44A2-AA7F-C56476742963}')!
ISpeechGrammarRuleStateTransitions comment: '<ISpeechGrammarRuleStateTransitions> is a wrapper class for the COM interface ''SpeechLib.ISpeechGrammarRuleStateTransitions'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechGrammarRuleStateTransitions Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(EABCE657-75BC-44A2-AA7F-C56476742963), 
	helpstring("ISpeechGrammarRuleStateTransitions Interface"), 
	dual
]
interface ISpeechGrammarRuleStateTransitions : IDispatch {
	[id(0x00000001), propget, helpstring("Count")]
	HRESULT __stdcall Count(
		[out, retval] long* Count);
	[id(0000000000), helpstring("Item")]
	HRESULT __stdcall Item(
		[in] long Index,
		[out, retval] ISpeechGrammarRuleStateTransition** Transition);
	[id(0xfffffffc), propget, restricted, helpstring("Enumerates the transitions")]
	HRESULT __stdcall _NewEnum(
		[out, retval] IUnknown** EnumVARIANT);
};
'!
!ISpeechGrammarRuleStateTransitions categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechGrammarRuleStateTransitions methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver.
	Helpstring: 'Enumerates the transitions'"

	| answer |
	answer := IUnknown newPointer.
	self get__NewEnum: answer.
	^answer asObject
!

count
	"Answer the <sdword> value of the 'Count' property of the receiver.
	Helpstring: 'Count'"

	| answer |
	answer := (SDWORD new).
	self get_Count: answer.
	^answer asObject
!

get__NewEnum: enumVARIANT
	"Private - Get the value of the '_NewEnum' property of the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval] IUnknown** EnumVARIANT);"

	<virtual stdcall: hresult 10 IUnknown**>
	^self invalidCall
!

get_Count: count
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval] long* Count);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

isVBCollection
	"Answer whether the receiver is a VB style collection.
	The receiver is dynamically extensible, so we cannot determine this from the
	type library, and must perform a run-time check for the _NewEnum property."

	^true!

item: index
	"Answer the <ISpeechGrammarRuleStateTransition> result of invoking the Item() method of the COM object.
	Helpstring: 'Item'"

	| answer |
	answer := ISpeechGrammarRuleStateTransition newPointer.
	self
		Item: index
		Transition: answer.
	^answer asObject
!

Item: index Transition: transition
	"Private - Invoke the Item() method of the COM object.
	Helpstring: 'Item'

		HRESULT __stdcall Item(
			[in] long Index,
			[out, retval] ISpeechGrammarRuleStateTransition** Transition);"

	<virtual stdcall: hresult 9 sdword ISpeechGrammarRuleStateTransition**>
	^self invalidCall
!

value: index
	"Set the 'Item' property of the receiver to the <ISpeechGrammarRuleStateTransition**> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self item: index
! !
!ISpeechGrammarRuleStateTransitions categoriesFor: #_newEnum!**auto generated**!properties!public! !
!ISpeechGrammarRuleStateTransitions categoriesFor: #count!**auto generated**!properties!public! !
!ISpeechGrammarRuleStateTransitions categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-ISpeechGrammarRuleStateTransitions!private! !
!ISpeechGrammarRuleStateTransitions categoriesFor: #get_Count:!**auto generated**!COM Interfaces-ISpeechGrammarRuleStateTransitions!private! !
!ISpeechGrammarRuleStateTransitions categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechGrammarRuleStateTransitions categoriesFor: #item:!**auto generated**!methods!public! !
!ISpeechGrammarRuleStateTransitions categoriesFor: #Item:Transition:!**auto generated**!COM Interfaces-ISpeechGrammarRuleStateTransitions!private! !
!ISpeechGrammarRuleStateTransitions categoriesFor: #value:!**auto generated**!properties!public! !

!ISpeechGrammarRuleStateTransitions class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechGrammarRuleStateTransitions'
		ISpeechGrammarRuleStateTransitions defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Item:Transition:
			argumentTypes: 'sdword ISpeechGrammarRuleStateTransition**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechGrammarRuleStateTransitions initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechGrammarRuleStateTransitions class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechGrammarRuleStateTransitions class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

