"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechLexiconPronunciations
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechLexiconPronunciations guid: (IID fromString: '{72829128-5682-4704-A0D4-3E2BB6F2EAD3}')!
ISpeechLexiconPronunciations comment: '<ISpeechLexiconPronunciations> is a wrapper class for the COM interface ''SpeechLib.ISpeechLexiconPronunciations'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechLexiconPronunciations Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(72829128-5682-4704-A0D4-3E2BB6F2EAD3), 
	helpstring("ISpeechLexiconPronunciations Interface"), 
	dual
]
interface ISpeechLexiconPronunciations : IDispatch {
	[id(0x00000001), propget, helpstring("Count")]
	HRESULT __stdcall Count(
		[out, retval] long* Count);
	[id(0000000000), helpstring("Item")]
	HRESULT __stdcall Item(
		[in] long Index,
		[out, retval] ISpeechLexiconPronunciation** Pronunciation);
	[id(0xfffffffc), propget, restricted, helpstring("Enumerates the tokens")]
	HRESULT __stdcall _NewEnum(
		[out, retval] IUnknown** EnumVARIANT);
};
'!
!ISpeechLexiconPronunciations categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechLexiconPronunciations methodsFor!

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
	"Answer the <ISpeechLexiconPronunciation> result of invoking the Item() method of the COM object.
	Helpstring: 'Item'"

	| answer |
	answer := ISpeechLexiconPronunciation newPointer.
	self
		Item: index
		Pronunciation: answer.
	^answer asObject
!

Item: index Pronunciation: pronunciation
	"Private - Invoke the Item() method of the COM object.
	Helpstring: 'Item'

		HRESULT __stdcall Item(
			[in] long Index,
			[out, retval] ISpeechLexiconPronunciation** Pronunciation);"

	<virtual stdcall: hresult 9 sdword ISpeechLexiconPronunciation**>
	^self invalidCall
!

value: index
	"Set the 'Item' property of the receiver to the <ISpeechLexiconPronunciation**> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self item: index
! !
!ISpeechLexiconPronunciations categoriesFor: #_newEnum!**auto generated**!properties!public! !
!ISpeechLexiconPronunciations categoriesFor: #count!**auto generated**!properties!public! !
!ISpeechLexiconPronunciations categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-ISpeechLexiconPronunciations!private! !
!ISpeechLexiconPronunciations categoriesFor: #get_Count:!**auto generated**!COM Interfaces-ISpeechLexiconPronunciations!private! !
!ISpeechLexiconPronunciations categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechLexiconPronunciations categoriesFor: #item:!**auto generated**!methods!public! !
!ISpeechLexiconPronunciations categoriesFor: #Item:Pronunciation:!**auto generated**!COM Interfaces-ISpeechLexiconPronunciations!private! !
!ISpeechLexiconPronunciations categoriesFor: #value:!**auto generated**!properties!public! !

!ISpeechLexiconPronunciations class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechLexiconPronunciations'
		ISpeechLexiconPronunciations defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Item:Pronunciation:
			argumentTypes: 'sdword ISpeechLexiconPronunciation**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechLexiconPronunciations initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechLexiconPronunciations class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechLexiconPronunciations class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

