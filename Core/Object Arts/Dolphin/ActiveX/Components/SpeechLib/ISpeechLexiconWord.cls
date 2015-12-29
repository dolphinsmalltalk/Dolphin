"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechLexiconWord
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechLexiconWord guid: (IID fromString: '{4E5B933C-C9BE-48ED-8842-1EE51BB1D4FF}')!
ISpeechLexiconWord comment: '<ISpeechLexiconWord> is a wrapper class for the COM interface ''SpeechLib.ISpeechLexiconWord'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechLexiconWord Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(4E5B933C-C9BE-48ED-8842-1EE51BB1D4FF), 
	helpstring("ISpeechLexiconWord Interface"), 
	dual
]
interface ISpeechLexiconWord : IDispatch {
	[id(0x00000001), propget]
	HRESULT __stdcall LangId(
		[out, retval] long* LangId);
	[id(0x00000002), propget]
	HRESULT __stdcall Type(
		[out, retval] SpeechWordType* WordType);
	[id(0x00000003), propget]
	HRESULT __stdcall Word(
		[out, retval] BSTR* Word);
	[id(0x00000004), propget]
	HRESULT __stdcall Pronunciations(
		[out, retval] ISpeechLexiconPronunciations** Pronunciations);
};
'!
!ISpeechLexiconWord categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechLexiconWord methodsFor!

get_LangId: langId
	"Private - Get the value of the 'LangId' property of the receiver.

		HRESULT __stdcall LangId(
			[out, retval] long* LangId);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_Pronunciations: pronunciations
	"Private - Get the value of the 'Pronunciations' property of the receiver.

		HRESULT __stdcall Pronunciations(
			[out, retval] ISpeechLexiconPronunciations** Pronunciations);"

	<virtual stdcall: hresult 11 ISpeechLexiconPronunciations**>
	^self invalidCall
!

get_Type: wordType
	"Private - Get the value of the 'Type' property of the receiver.

		HRESULT __stdcall Type(
			[out, retval] SpeechWordType* WordType);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

get_Word: word
	"Private - Get the value of the 'Word' property of the receiver.

		HRESULT __stdcall Word(
			[out, retval] BSTR* Word);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

langId
	"Answer the <sdword> value of the 'LangId' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_LangId: answer.
	^answer asObject
!

pronunciations
	"Answer the <ISpeechLexiconPronunciations> value of the 'Pronunciations' property of the receiver."

	| answer |
	answer := ISpeechLexiconPronunciations newPointer.
	self get_Pronunciations: answer.
	^answer asObject
!

type
	"Answer the <sdword> value of the 'Type' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Type: answer.
	^answer asObject
!

word
	"Answer the <bstr> value of the 'Word' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Word: answer.
	^answer asObject
! !
!ISpeechLexiconWord categoriesFor: #get_LangId:!**auto generated**!COM Interfaces-ISpeechLexiconWord!private! !
!ISpeechLexiconWord categoriesFor: #get_Pronunciations:!**auto generated**!COM Interfaces-ISpeechLexiconWord!private! !
!ISpeechLexiconWord categoriesFor: #get_Type:!**auto generated**!COM Interfaces-ISpeechLexiconWord!private! !
!ISpeechLexiconWord categoriesFor: #get_Word:!**auto generated**!COM Interfaces-ISpeechLexiconWord!private! !
!ISpeechLexiconWord categoriesFor: #langId!**auto generated**!properties!public! !
!ISpeechLexiconWord categoriesFor: #pronunciations!**auto generated**!properties!public! !
!ISpeechLexiconWord categoriesFor: #type!**auto generated**!properties!public! !
!ISpeechLexiconWord categoriesFor: #word!**auto generated**!properties!public! !

!ISpeechLexiconWord class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechLexiconWord'
		ISpeechLexiconWord defineTemplate"

	self
		defineFunction: #get_LangId:
			argumentTypes: 'sdword*';
		defineFunction: #get_Type:
			argumentTypes: 'sdword*';
		defineFunction: #get_Word:
			argumentTypes: 'bstr*';
		defineFunction: #get_Pronunciations:
			argumentTypes: 'ISpeechLexiconPronunciations**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechLexiconWord initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechLexiconWord class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechLexiconWord class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

