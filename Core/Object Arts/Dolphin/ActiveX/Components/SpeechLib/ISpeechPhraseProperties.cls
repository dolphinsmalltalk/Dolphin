"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechPhraseProperties
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseProperties guid: (IID fromString: '{08166B47-102E-4B23-A599-BDB98DBFD1F4}')!
ISpeechPhraseProperties comment: '<ISpeechPhraseProperties> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseProperties'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseProperties Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(08166B47-102E-4B23-A599-BDB98DBFD1F4), 
	helpstring("ISpeechPhraseProperties Interface"), 
	dual
]
interface ISpeechPhraseProperties : IDispatch {
	[id(0x00000001), propget, helpstring("Count")]
	HRESULT __stdcall Count(
		[out, retval] long* Count);
	[id(0000000000), helpstring("Item")]
	HRESULT __stdcall Item(
		[in] long Index,
		[out, retval] ISpeechPhraseProperty** Property);
	[id(0xfffffffc), propget, restricted, helpstring("Enumerates the alternates")]
	HRESULT __stdcall _NewEnum(
		[out, retval] IUnknown** EnumVARIANT);
};
'!
!ISpeechPhraseProperties categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseProperties methodsFor!

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
	"Answer the <ISpeechPhraseProperty> result of invoking the Item() method of the COM object.
	Helpstring: 'Item'"

	| answer |
	answer := ISpeechPhraseProperty newPointer.
	self
		Item: index
		Property: answer.
	^answer asObject
!

Item: index Property: property
	"Private - Invoke the Item() method of the COM object.
	Helpstring: 'Item'

		HRESULT __stdcall Item(
			[in] long Index,
			[out, retval] ISpeechPhraseProperty** Property);"

	<virtual stdcall: hresult 9 sdword ISpeechPhraseProperty**>
	^self invalidCall
!

value: index
	"Set the 'Item' property of the receiver to the <ISpeechPhraseProperty**> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self item: index
! !
!ISpeechPhraseProperties categoriesFor: #_newEnum!**auto generated**!properties!public! !
!ISpeechPhraseProperties categoriesFor: #count!**auto generated**!properties!public! !
!ISpeechPhraseProperties categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-ISpeechPhraseProperties!private! !
!ISpeechPhraseProperties categoriesFor: #get_Count:!**auto generated**!COM Interfaces-ISpeechPhraseProperties!private! !
!ISpeechPhraseProperties categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechPhraseProperties categoriesFor: #item:!**auto generated**!methods!public! !
!ISpeechPhraseProperties categoriesFor: #Item:Property:!**auto generated**!COM Interfaces-ISpeechPhraseProperties!private! !
!ISpeechPhraseProperties categoriesFor: #value:!**auto generated**!properties!public! !

!ISpeechPhraseProperties class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseProperties'
		ISpeechPhraseProperties defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Item:Property:
			argumentTypes: 'sdword ISpeechPhraseProperty**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseProperties initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseProperties class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseProperties class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

