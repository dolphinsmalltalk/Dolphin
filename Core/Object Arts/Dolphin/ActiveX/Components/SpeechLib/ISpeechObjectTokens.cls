"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechObjectTokens
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechObjectTokens guid: (IID fromString: '{9285B776-2E7B-4BC0-B53E-580EB6FA967F}')!
ISpeechObjectTokens comment: '<ISpeechObjectTokens> is a wrapper class for the COM interface ''SpeechLib.ISpeechObjectTokens'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechObjectTokens Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(9285B776-2E7B-4BC0-B53E-580EB6FA967F), 
	helpstring("ISpeechObjectTokens Interface"), 
	dual
]
interface ISpeechObjectTokens : IDispatch {
	[id(0x00000001), propget, helpstring("Count")]
	HRESULT __stdcall Count(
		[out, retval] long* Count);
	[id(0000000000), helpstring("Item")]
	HRESULT __stdcall Item(
		[in] long Index,
		[out, retval] ISpeechObjectToken** Token);
	[id(0xfffffffc), propget, restricted, helpstring("Enumerates the tokens")]
	HRESULT __stdcall _NewEnum(
		[out, retval] IUnknown** ppEnumVARIANT);
};
'!
!ISpeechObjectTokens categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechObjectTokens methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver.
	Helpstring: 'Enumerates the tokens'"

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

get__NewEnum: ppEnumVARIANT
	"Private - Get the value of the '_NewEnum' property of the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval] IUnknown** ppEnumVARIANT);"

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
	"Answer the <ISpeechObjectToken> result of invoking the Item() method of the COM object.
	Helpstring: 'Item'"

	| answer |
	answer := ISpeechObjectToken newPointer.
	self
		Item: index
		Token: answer.
	^answer asObject
!

Item: index Token: token
	"Private - Invoke the Item() method of the COM object.
	Helpstring: 'Item'

		HRESULT __stdcall Item(
			[in] long Index,
			[out, retval] ISpeechObjectToken** Token);"

	<virtual stdcall: hresult 9 sdword ISpeechObjectToken**>
	^self invalidCall
!

tokens
	^(1 to: self count) collect: [:n | self item: n - 1]!

value: index
	"Set the 'Item' property of the receiver to the <ISpeechObjectToken**> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self item: index
! !
!ISpeechObjectTokens categoriesFor: #_newEnum!**auto generated**!properties!public! !
!ISpeechObjectTokens categoriesFor: #count!**auto generated**!properties!public! !
!ISpeechObjectTokens categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-ISpeechObjectTokens!private! !
!ISpeechObjectTokens categoriesFor: #get_Count:!**auto generated**!COM Interfaces-ISpeechObjectTokens!private! !
!ISpeechObjectTokens categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechObjectTokens categoriesFor: #item:!**auto generated**!methods!public! !
!ISpeechObjectTokens categoriesFor: #Item:Token:!**auto generated**!COM Interfaces-ISpeechObjectTokens!private! !
!ISpeechObjectTokens categoriesFor: #tokens!accessing!public! !
!ISpeechObjectTokens categoriesFor: #value:!**auto generated**!properties!public! !

!ISpeechObjectTokens class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechObjectTokens'
		ISpeechObjectTokens defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Item:Token:
			argumentTypes: 'sdword ISpeechObjectToken**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechObjectTokens initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechObjectTokens class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechObjectTokens class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

