"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechPhraseReplacement
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseReplacement guid: (IID fromString: '{2890A410-53A7-4FB5-94EC-06D4998E3D02}')!
ISpeechPhraseReplacement comment: '<ISpeechPhraseReplacement> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseReplacement'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseReplacement Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2890A410-53A7-4FB5-94EC-06D4998E3D02), 
	helpstring("ISpeechPhraseReplacement Interface"), 
	dual
]
interface ISpeechPhraseReplacement : IDispatch {
	[id(0x00000001), propget, helpstring("DisplayAttributes")]
	HRESULT __stdcall DisplayAttributes(
		[out, retval] SpeechDisplayAttributes* DisplayAttributes);
	[id(0x00000002), propget, helpstring("Text")]
	HRESULT __stdcall Text(
		[out, retval] BSTR* Text);
	[id(0x00000003), propget, helpstring("FirstElement")]
	HRESULT __stdcall FirstElement(
		[out, retval] long* FirstElement);
	[id(0x00000004), propget, helpstring("NumElements")]
	HRESULT __stdcall NumberOfElements(
		[out, retval] long* NumberOfElements);
};
'!
!ISpeechPhraseReplacement categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseReplacement methodsFor!

displayAttributes
	"Answer the <sdword> value of the 'DisplayAttributes' property of the receiver.
	Helpstring: 'DisplayAttributes'"

	| answer |
	answer := (SDWORD new).
	self get_DisplayAttributes: answer.
	^answer asObject
!

firstElement
	"Answer the <sdword> value of the 'FirstElement' property of the receiver.
	Helpstring: 'FirstElement'"

	| answer |
	answer := (SDWORD new).
	self get_FirstElement: answer.
	^answer asObject
!

get_DisplayAttributes: displayAttributes
	"Private - Get the value of the 'DisplayAttributes' property of the receiver.

		HRESULT __stdcall DisplayAttributes(
			[out, retval] SpeechDisplayAttributes* DisplayAttributes);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_FirstElement: firstElement
	"Private - Get the value of the 'FirstElement' property of the receiver.

		HRESULT __stdcall FirstElement(
			[out, retval] long* FirstElement);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

get_NumberOfElements: numberOfElements
	"Private - Get the value of the 'NumberOfElements' property of the receiver.

		HRESULT __stdcall NumberOfElements(
			[out, retval] long* NumberOfElements);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall
!

get_Text: text
	"Private - Get the value of the 'Text' property of the receiver.

		HRESULT __stdcall Text(
			[out, retval] BSTR* Text);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall
!

numberOfElements
	"Answer the <sdword> value of the 'NumberOfElements' property of the receiver.
	Helpstring: 'NumElements'"

	| answer |
	answer := (SDWORD new).
	self get_NumberOfElements: answer.
	^answer asObject
!

text
	"Answer the <bstr> value of the 'Text' property of the receiver.
	Helpstring: 'Text'"

	| answer |
	answer := BSTR new.
	self get_Text: answer.
	^answer asObject
! !
!ISpeechPhraseReplacement categoriesFor: #displayAttributes!**auto generated**!properties!public! !
!ISpeechPhraseReplacement categoriesFor: #firstElement!**auto generated**!properties!public! !
!ISpeechPhraseReplacement categoriesFor: #get_DisplayAttributes:!**auto generated**!COM Interfaces-ISpeechPhraseReplacement!private! !
!ISpeechPhraseReplacement categoriesFor: #get_FirstElement:!**auto generated**!COM Interfaces-ISpeechPhraseReplacement!private! !
!ISpeechPhraseReplacement categoriesFor: #get_NumberOfElements:!**auto generated**!COM Interfaces-ISpeechPhraseReplacement!private! !
!ISpeechPhraseReplacement categoriesFor: #get_Text:!**auto generated**!COM Interfaces-ISpeechPhraseReplacement!private! !
!ISpeechPhraseReplacement categoriesFor: #numberOfElements!**auto generated**!properties!public! !
!ISpeechPhraseReplacement categoriesFor: #text!**auto generated**!properties!public! !

!ISpeechPhraseReplacement class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseReplacement'
		ISpeechPhraseReplacement defineTemplate"

	self
		defineFunction: #get_DisplayAttributes:
			argumentTypes: 'sdword*';
		defineFunction: #get_Text:
			argumentTypes: 'bstr*';
		defineFunction: #get_FirstElement:
			argumentTypes: 'sdword*';
		defineFunction: #get_NumberOfElements:
			argumentTypes: 'sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseReplacement initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseReplacement class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseReplacement class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

