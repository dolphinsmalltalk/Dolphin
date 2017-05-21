"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechPhraseRules
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseRules guid: (IID fromString: '{9047D593-01DD-4B72-81A3-E4A0CA69F407}')!
ISpeechPhraseRules comment: '<ISpeechPhraseRules> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseRules'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseRules Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(9047D593-01DD-4B72-81A3-E4A0CA69F407), 
	helpstring("ISpeechPhraseRules Interface"), 
	dual
]
interface ISpeechPhraseRules : IDispatch {
	[id(0x00000001), propget, helpstring("Count")]
	HRESULT __stdcall Count(
		[out, retval] long* Count);
	[id(0000000000), helpstring("Item")]
	HRESULT __stdcall Item(
		[in] long Index,
		[out, retval] ISpeechPhraseRule** Rule);
	[id(0xfffffffc), propget, restricted, helpstring("Enumerates the Rules")]
	HRESULT __stdcall _NewEnum(
		[out, retval] IUnknown** EnumVARIANT);
};
'!
!ISpeechPhraseRules categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseRules methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver.
	Helpstring: 'Enumerates the Rules'"

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
	"Answer the <ISpeechPhraseRule> result of invoking the Item() method of the COM object.
	Helpstring: 'Item'"

	| answer |
	answer := ISpeechPhraseRule newPointer.
	self
		Item: index
		Rule: answer.
	^answer asObject
!

Item: index Rule: rule
	"Private - Invoke the Item() method of the COM object.
	Helpstring: 'Item'

		HRESULT __stdcall Item(
			[in] long Index,
			[out, retval] ISpeechPhraseRule** Rule);"

	<virtual stdcall: hresult 9 sdword ISpeechPhraseRule**>
	^self invalidCall
!

value: index
	"Set the 'Item' property of the receiver to the <ISpeechPhraseRule**> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self item: index
! !
!ISpeechPhraseRules categoriesFor: #_newEnum!**auto generated**!properties!public! !
!ISpeechPhraseRules categoriesFor: #count!**auto generated**!properties!public! !
!ISpeechPhraseRules categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-ISpeechPhraseRules!private! !
!ISpeechPhraseRules categoriesFor: #get_Count:!**auto generated**!COM Interfaces-ISpeechPhraseRules!private! !
!ISpeechPhraseRules categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechPhraseRules categoriesFor: #item:!**auto generated**!methods!public! !
!ISpeechPhraseRules categoriesFor: #Item:Rule:!**auto generated**!COM Interfaces-ISpeechPhraseRules!private! !
!ISpeechPhraseRules categoriesFor: #value:!**auto generated**!properties!public! !

!ISpeechPhraseRules class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseRules'
		ISpeechPhraseRules defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Item:Rule:
			argumentTypes: 'sdword ISpeechPhraseRule**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseRules initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseRules class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseRules class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

