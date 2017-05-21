"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechPhraseElements
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseElements guid: (IID fromString: '{0626B328-3478-467D-A0B3-D0853B93DDA3}')!
ISpeechPhraseElements comment: '<ISpeechPhraseElements> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseElements'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseElements Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(0626B328-3478-467D-A0B3-D0853B93DDA3), 
	helpstring("ISpeechPhraseElements Interface"), 
	dual
]
interface ISpeechPhraseElements : IDispatch {
	[id(0x00000001), propget, helpstring("Count")]
	HRESULT __stdcall Count(
		[out, retval] long* Count);
	[id(0000000000), helpstring("Item")]
	HRESULT __stdcall Item(
		[in] long Index,
		[out, retval] ISpeechPhraseElement** Element);
	[id(0xfffffffc), propget, restricted, helpstring("Enumerates the tokens")]
	HRESULT __stdcall _NewEnum(
		[out, retval] IUnknown** EnumVARIANT);
};
'!
!ISpeechPhraseElements categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseElements methodsFor!

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
	"Answer the <ISpeechPhraseElement> result of invoking the Item() method of the COM object.
	Helpstring: 'Item'"

	| answer |
	answer := ISpeechPhraseElement newPointer.
	self
		Item: index
		Element: answer.
	^answer asObject
!

Item: index Element: element
	"Private - Invoke the Item() method of the COM object.
	Helpstring: 'Item'

		HRESULT __stdcall Item(
			[in] long Index,
			[out, retval] ISpeechPhraseElement** Element);"

	<virtual stdcall: hresult 9 sdword ISpeechPhraseElement**>
	^self invalidCall
!

value: index
	"Set the 'Item' property of the receiver to the <ISpeechPhraseElement**> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self item: index
! !
!ISpeechPhraseElements categoriesFor: #_newEnum!**auto generated**!properties!public! !
!ISpeechPhraseElements categoriesFor: #count!**auto generated**!properties!public! !
!ISpeechPhraseElements categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-ISpeechPhraseElements!private! !
!ISpeechPhraseElements categoriesFor: #get_Count:!**auto generated**!COM Interfaces-ISpeechPhraseElements!private! !
!ISpeechPhraseElements categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechPhraseElements categoriesFor: #item:!**auto generated**!methods!public! !
!ISpeechPhraseElements categoriesFor: #Item:Element:!**auto generated**!COM Interfaces-ISpeechPhraseElements!private! !
!ISpeechPhraseElements categoriesFor: #value:!**auto generated**!properties!public! !

!ISpeechPhraseElements class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseElements'
		ISpeechPhraseElements defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Item:Element:
			argumentTypes: 'sdword ISpeechPhraseElement**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseElements initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseElements class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseElements class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

