"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechPhraseReplacements
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseReplacements guid: (IID fromString: '{38BC662F-2257-4525-959E-2069D2596C05}')!
ISpeechPhraseReplacements comment: '<ISpeechPhraseReplacements> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseReplacements'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseReplacements Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(38BC662F-2257-4525-959E-2069D2596C05), 
	helpstring("ISpeechPhraseReplacements Interface"), 
	dual
]
interface ISpeechPhraseReplacements : IDispatch {
	[id(0x00000001), propget, helpstring("Count")]
	HRESULT __stdcall Count(
		[out, retval] long* Count);
	[id(0000000000), helpstring("Item")]
	HRESULT __stdcall Item(
		[in] long Index,
		[out, retval] ISpeechPhraseReplacement** Reps);
	[id(0xfffffffc), propget, restricted, helpstring("Enumerates the tokens")]
	HRESULT __stdcall _NewEnum(
		[out, retval] IUnknown** EnumVARIANT);
};
'!
!ISpeechPhraseReplacements categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseReplacements methodsFor!

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
	"Answer the <ISpeechPhraseReplacement> result of invoking the Item() method of the COM object.
	Helpstring: 'Item'"

	| answer |
	answer := ISpeechPhraseReplacement newPointer.
	self
		Item: index
		Reps: answer.
	^answer asObject
!

Item: index Reps: reps
	"Private - Invoke the Item() method of the COM object.
	Helpstring: 'Item'

		HRESULT __stdcall Item(
			[in] long Index,
			[out, retval] ISpeechPhraseReplacement** Reps);"

	<virtual stdcall: hresult 9 sdword ISpeechPhraseReplacement**>
	^self invalidCall
!

value: index
	"Set the 'Item' property of the receiver to the <ISpeechPhraseReplacement**> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self item: index
! !
!ISpeechPhraseReplacements categoriesFor: #_newEnum!**auto generated**!properties!public! !
!ISpeechPhraseReplacements categoriesFor: #count!**auto generated**!properties!public! !
!ISpeechPhraseReplacements categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-ISpeechPhraseReplacements!private! !
!ISpeechPhraseReplacements categoriesFor: #get_Count:!**auto generated**!COM Interfaces-ISpeechPhraseReplacements!private! !
!ISpeechPhraseReplacements categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechPhraseReplacements categoriesFor: #item:!**auto generated**!methods!public! !
!ISpeechPhraseReplacements categoriesFor: #Item:Reps:!**auto generated**!COM Interfaces-ISpeechPhraseReplacements!private! !
!ISpeechPhraseReplacements categoriesFor: #value:!**auto generated**!properties!public! !

!ISpeechPhraseReplacements class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseReplacements'
		ISpeechPhraseReplacements defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Item:Reps:
			argumentTypes: 'sdword ISpeechPhraseReplacement**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseReplacements initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseReplacements class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseReplacements class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

