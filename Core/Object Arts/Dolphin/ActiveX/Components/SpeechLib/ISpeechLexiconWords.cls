"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechLexiconWords
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechLexiconWords guid: (IID fromString: '{8D199862-415E-47D5-AC4F-FAA608B424E6}')!
ISpeechLexiconWords comment: '<ISpeechLexiconWords> is a wrapper class for the COM interface ''SpeechLib.ISpeechLexiconWords'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechLexiconWords Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(8D199862-415E-47D5-AC4F-FAA608B424E6), 
	helpstring("ISpeechLexiconWords Interface"), 
	dual
]
interface ISpeechLexiconWords : IDispatch {
	[id(0x00000001), propget, helpstring("Count")]
	HRESULT __stdcall Count(
		[out, retval] long* Count);
	[id(0000000000), helpstring("Item")]
	HRESULT __stdcall Item(
		[in] long Index,
		[out, retval] ISpeechLexiconWord** Word);
	[id(0xfffffffc), propget, restricted, helpstring("Enumerates the tokens")]
	HRESULT __stdcall _NewEnum(
		[out, retval] IUnknown** EnumVARIANT);
};
'!
!ISpeechLexiconWords categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechLexiconWords methodsFor!

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
	"Answer the <ISpeechLexiconWord> result of invoking the Item() method of the COM object.
	Helpstring: 'Item'"

	| answer |
	answer := ISpeechLexiconWord newPointer.
	self
		Item: index
		Word: answer.
	^answer asObject
!

Item: index Word: word
	"Private - Invoke the Item() method of the COM object.
	Helpstring: 'Item'

		HRESULT __stdcall Item(
			[in] long Index,
			[out, retval] ISpeechLexiconWord** Word);"

	<virtual stdcall: hresult 9 sdword ISpeechLexiconWord**>
	^self invalidCall
!

value: index
	"Set the 'Item' property of the receiver to the <ISpeechLexiconWord**> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self item: index
! !
!ISpeechLexiconWords categoriesFor: #_newEnum!**auto generated**!properties!public! !
!ISpeechLexiconWords categoriesFor: #count!**auto generated**!properties!public! !
!ISpeechLexiconWords categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-ISpeechLexiconWords!private! !
!ISpeechLexiconWords categoriesFor: #get_Count:!**auto generated**!COM Interfaces-ISpeechLexiconWords!private! !
!ISpeechLexiconWords categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechLexiconWords categoriesFor: #item:!**auto generated**!methods!public! !
!ISpeechLexiconWords categoriesFor: #Item:Word:!**auto generated**!COM Interfaces-ISpeechLexiconWords!private! !
!ISpeechLexiconWords categoriesFor: #value:!**auto generated**!properties!public! !

!ISpeechLexiconWords class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechLexiconWords'
		ISpeechLexiconWords defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Item:Word:
			argumentTypes: 'sdword ISpeechLexiconWord**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechLexiconWords initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechLexiconWords class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechLexiconWords class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

