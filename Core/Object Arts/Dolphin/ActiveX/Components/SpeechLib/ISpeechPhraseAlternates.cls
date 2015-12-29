"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechPhraseAlternates
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseAlternates guid: (IID fromString: '{B238B6D5-F276-4C3D-A6C1-2974801C3CC2}')!
ISpeechPhraseAlternates comment: '<ISpeechPhraseAlternates> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseAlternates'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseAlternates Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(B238B6D5-F276-4C3D-A6C1-2974801C3CC2), 
	helpstring("ISpeechPhraseAlternates Interface"), 
	dual
]
interface ISpeechPhraseAlternates : IDispatch {
	[id(0x00000001), propget, helpstring("Count")]
	HRESULT __stdcall Count(
		[out, retval] long* Count);
	[id(0000000000), helpstring("Item")]
	HRESULT __stdcall Item(
		[in] long Index,
		[out, retval] ISpeechPhraseAlternate** PhraseAlternate);
	[id(0xfffffffc), propget, restricted, helpstring("Enumerates the alternates")]
	HRESULT __stdcall _NewEnum(
		[out, retval] IUnknown** EnumVARIANT);
};
'!
!ISpeechPhraseAlternates categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseAlternates methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver.
	Helpstring: 'Enumerates the alternates'"

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
	"Answer the <ISpeechPhraseAlternate> result of invoking the Item() method of the COM object.
	Helpstring: 'Item'"

	| answer |
	answer := ISpeechPhraseAlternate newPointer.
	self
		Item: index
		PhraseAlternate: answer.
	^answer asObject
!

Item: index PhraseAlternate: phraseAlternate
	"Private - Invoke the Item() method of the COM object.
	Helpstring: 'Item'

		HRESULT __stdcall Item(
			[in] long Index,
			[out, retval] ISpeechPhraseAlternate** PhraseAlternate);"

	<virtual stdcall: hresult 9 sdword ISpeechPhraseAlternate**>
	^self invalidCall
!

value: index
	"Set the 'Item' property of the receiver to the <ISpeechPhraseAlternate**> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self item: index
! !
!ISpeechPhraseAlternates categoriesFor: #_newEnum!**auto generated**!properties!public! !
!ISpeechPhraseAlternates categoriesFor: #count!**auto generated**!properties!public! !
!ISpeechPhraseAlternates categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-ISpeechPhraseAlternates!private! !
!ISpeechPhraseAlternates categoriesFor: #get_Count:!**auto generated**!COM Interfaces-ISpeechPhraseAlternates!private! !
!ISpeechPhraseAlternates categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechPhraseAlternates categoriesFor: #item:!**auto generated**!methods!public! !
!ISpeechPhraseAlternates categoriesFor: #Item:PhraseAlternate:!**auto generated**!COM Interfaces-ISpeechPhraseAlternates!private! !
!ISpeechPhraseAlternates categoriesFor: #value:!**auto generated**!properties!public! !

!ISpeechPhraseAlternates class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseAlternates'
		ISpeechPhraseAlternates defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Item:PhraseAlternate:
			argumentTypes: 'sdword ISpeechPhraseAlternate**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseAlternates initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseAlternates class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseAlternates class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

