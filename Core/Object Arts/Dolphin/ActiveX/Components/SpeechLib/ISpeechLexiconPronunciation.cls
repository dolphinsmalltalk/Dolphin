"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechLexiconPronunciation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechLexiconPronunciation guid: (IID fromString: '{95252C5D-9E43-4F4A-9899-48EE73352F9F}')!
ISpeechLexiconPronunciation comment: '<ISpeechLexiconPronunciation> is a wrapper class for the COM interface ''SpeechLib.ISpeechLexiconPronunciation'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechLexiconPronunciation Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(95252C5D-9E43-4F4A-9899-48EE73352F9F), 
	helpstring("ISpeechLexiconPronunciation Interface"), 
	dual
]
interface ISpeechLexiconPronunciation : IDispatch {
	[id(0x00000001), propget, helpstring("Type")]
	HRESULT __stdcall Type(
		[out, retval] SpeechLexiconType* LexiconType);
	[id(0x00000002), propget, helpstring("LangId")]
	HRESULT __stdcall LangId(
		[out, retval] long* LangId);
	[id(0x00000003), propget, helpstring("PartOfSpeech")]
	HRESULT __stdcall PartOfSpeech(
		[out, retval] SpeechPartOfSpeech* PartOfSpeech);
	[id(0x00000004), propget, helpstring("PhoneIds")]
	HRESULT __stdcall PhoneIds(
		[out, retval] VARIANT* PhoneIds);
	[id(0x00000005), propget, helpstring("Symbolic")]
	HRESULT __stdcall Symbolic(
		[out, retval] BSTR* Symbolic);
};
'!
!ISpeechLexiconPronunciation categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechLexiconPronunciation methodsFor!

get_LangId: langId
	"Private - Get the value of the 'LangId' property of the receiver.

		HRESULT __stdcall LangId(
			[out, retval] long* LangId);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

get_PartOfSpeech: partOfSpeech
	"Private - Get the value of the 'PartOfSpeech' property of the receiver.

		HRESULT __stdcall PartOfSpeech(
			[out, retval] SpeechPartOfSpeech* PartOfSpeech);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

get_PhoneIds: phoneIds
	"Private - Get the value of the 'PhoneIds' property of the receiver.

		HRESULT __stdcall PhoneIds(
			[out, retval] VARIANT* PhoneIds);"

	<virtual stdcall: hresult 11 variant*>
	^self invalidCall
!

get_Symbolic: symbolic
	"Private - Get the value of the 'Symbolic' property of the receiver.

		HRESULT __stdcall Symbolic(
			[out, retval] BSTR* Symbolic);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall
!

get_Type: lexiconType
	"Private - Get the value of the 'Type' property of the receiver.

		HRESULT __stdcall Type(
			[out, retval] SpeechLexiconType* LexiconType);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

langId
	"Answer the <sdword> value of the 'LangId' property of the receiver.
	Helpstring: 'LangId'"

	| answer |
	answer := (SDWORD new).
	self get_LangId: answer.
	^answer asObject
!

partOfSpeech
	"Answer the <sdword> value of the 'PartOfSpeech' property of the receiver.
	Helpstring: 'PartOfSpeech'"

	| answer |
	answer := (SDWORD new).
	self get_PartOfSpeech: answer.
	^answer asObject
!

phoneIds
	"Answer the <variant> value of the 'PhoneIds' property of the receiver.
	Helpstring: 'PhoneIds'"

	| answer |
	answer := VARIANT new.
	self get_PhoneIds: answer.
	^answer asObject
!

symbolic
	"Answer the <bstr> value of the 'Symbolic' property of the receiver.
	Helpstring: 'Symbolic'"

	| answer |
	answer := BSTR new.
	self get_Symbolic: answer.
	^answer asObject
!

type
	"Answer the <sdword> value of the 'Type' property of the receiver.
	Helpstring: 'Type'"

	| answer |
	answer := (SDWORD new).
	self get_Type: answer.
	^answer asObject
! !
!ISpeechLexiconPronunciation categoriesFor: #get_LangId:!**auto generated**!COM Interfaces-ISpeechLexiconPronunciation!private! !
!ISpeechLexiconPronunciation categoriesFor: #get_PartOfSpeech:!**auto generated**!COM Interfaces-ISpeechLexiconPronunciation!private! !
!ISpeechLexiconPronunciation categoriesFor: #get_PhoneIds:!**auto generated**!COM Interfaces-ISpeechLexiconPronunciation!private! !
!ISpeechLexiconPronunciation categoriesFor: #get_Symbolic:!**auto generated**!COM Interfaces-ISpeechLexiconPronunciation!private! !
!ISpeechLexiconPronunciation categoriesFor: #get_Type:!**auto generated**!COM Interfaces-ISpeechLexiconPronunciation!private! !
!ISpeechLexiconPronunciation categoriesFor: #langId!**auto generated**!properties!public! !
!ISpeechLexiconPronunciation categoriesFor: #partOfSpeech!**auto generated**!properties!public! !
!ISpeechLexiconPronunciation categoriesFor: #phoneIds!**auto generated**!properties!public! !
!ISpeechLexiconPronunciation categoriesFor: #symbolic!**auto generated**!properties!public! !
!ISpeechLexiconPronunciation categoriesFor: #type!**auto generated**!properties!public! !

!ISpeechLexiconPronunciation class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechLexiconPronunciation'
		ISpeechLexiconPronunciation defineTemplate"

	self
		defineFunction: #get_Type:
			argumentTypes: 'sdword*';
		defineFunction: #get_LangId:
			argumentTypes: 'sdword*';
		defineFunction: #get_PartOfSpeech:
			argumentTypes: 'sdword*';
		defineFunction: #get_PhoneIds:
			argumentTypes: 'variant*';
		defineFunction: #get_Symbolic:
			argumentTypes: 'bstr*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechLexiconPronunciation initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechLexiconPronunciation class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechLexiconPronunciation class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

