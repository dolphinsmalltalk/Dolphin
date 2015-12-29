"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechPhraseAlternate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseAlternate guid: (IID fromString: '{27864A2A-2B9F-4CB8-92D3-0D2722FD1E73}')!
ISpeechPhraseAlternate comment: '<ISpeechPhraseAlternate> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseAlternate'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseAlternate Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(27864A2A-2B9F-4CB8-92D3-0D2722FD1E73), 
	helpstring("ISpeechPhraseAlternate Interface"), 
	dual
]
interface ISpeechPhraseAlternate : IDispatch {
	[id(0x00000001), propget, helpstring("RecoResult")]
	HRESULT __stdcall RecoResult(
		[out, retval] ISpeechRecoResult** RecoResult);
	[id(0x00000002), propget, helpstring("StartElementInResult")]
	HRESULT __stdcall StartElementInResult(
		[out, retval] long* StartElement);
	[id(0x00000003), propget, helpstring("NumberOfElementsInResult")]
	HRESULT __stdcall NumberOfElementsInResult(
		[out, retval] long* NumberOfElements);
	[id(0x00000004), propget, helpstring("Phrase")]
	HRESULT __stdcall PhraseInfo(
		[out, retval] ISpeechPhraseInfo** PhraseInfo);
	[id(0x00000005), helpstring("Commit")]
	HRESULT __stdcall Commit();
};
'!
!ISpeechPhraseAlternate categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseAlternate methodsFor!

commit
	"Invoke the Commit() method of the COM object.
	Helpstring: 'Commit'"

	^self Commit
!

Commit
	"Private - Invoke the Commit() method of the COM object.
	Helpstring: 'Commit'

		HRESULT __stdcall Commit();"

	<virtual stdcall: hresult 12>
	^self invalidCall
!

get_NumberOfElementsInResult: numberOfElements
	"Private - Get the value of the 'NumberOfElementsInResult' property of the receiver.

		HRESULT __stdcall NumberOfElementsInResult(
			[out, retval] long* NumberOfElements);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

get_PhraseInfo: phraseInfo
	"Private - Get the value of the 'PhraseInfo' property of the receiver.

		HRESULT __stdcall PhraseInfo(
			[out, retval] ISpeechPhraseInfo** PhraseInfo);"

	<virtual stdcall: hresult 11 ISpeechPhraseInfo**>
	^self invalidCall
!

get_RecoResult: recoResult
	"Private - Get the value of the 'RecoResult' property of the receiver.

		HRESULT __stdcall RecoResult(
			[out, retval] ISpeechRecoResult** RecoResult);"

	<virtual stdcall: hresult 8 ISpeechRecoResult**>
	^self invalidCall
!

get_StartElementInResult: startElement
	"Private - Get the value of the 'StartElementInResult' property of the receiver.

		HRESULT __stdcall StartElementInResult(
			[out, retval] long* StartElement);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

numberOfElementsInResult
	"Answer the <sdword> value of the 'NumberOfElementsInResult' property of the receiver.
	Helpstring: 'NumberOfElementsInResult'"

	| answer |
	answer := (SDWORD new).
	self get_NumberOfElementsInResult: answer.
	^answer asObject
!

phraseInfo
	"Answer the <ISpeechPhraseInfo> value of the 'PhraseInfo' property of the receiver.
	Helpstring: 'Phrase'"

	| answer |
	answer := ISpeechPhraseInfo newPointer.
	self get_PhraseInfo: answer.
	^answer asObject
!

recoResult
	"Answer the <ISpeechRecoResult> value of the 'RecoResult' property of the receiver.
	Helpstring: 'RecoResult'"

	| answer |
	answer := ISpeechRecoResult newPointer.
	self get_RecoResult: answer.
	^answer asObject
!

startElementInResult
	"Answer the <sdword> value of the 'StartElementInResult' property of the receiver.
	Helpstring: 'StartElementInResult'"

	| answer |
	answer := (SDWORD new).
	self get_StartElementInResult: answer.
	^answer asObject
! !
!ISpeechPhraseAlternate categoriesFor: #commit!**auto generated**!methods!public! !
!ISpeechPhraseAlternate categoriesFor: #Commit!**auto generated**!COM Interfaces-ISpeechPhraseAlternate!private! !
!ISpeechPhraseAlternate categoriesFor: #get_NumberOfElementsInResult:!**auto generated**!COM Interfaces-ISpeechPhraseAlternate!private! !
!ISpeechPhraseAlternate categoriesFor: #get_PhraseInfo:!**auto generated**!COM Interfaces-ISpeechPhraseAlternate!private! !
!ISpeechPhraseAlternate categoriesFor: #get_RecoResult:!**auto generated**!COM Interfaces-ISpeechPhraseAlternate!private! !
!ISpeechPhraseAlternate categoriesFor: #get_StartElementInResult:!**auto generated**!COM Interfaces-ISpeechPhraseAlternate!private! !
!ISpeechPhraseAlternate categoriesFor: #numberOfElementsInResult!**auto generated**!properties!public! !
!ISpeechPhraseAlternate categoriesFor: #phraseInfo!**auto generated**!properties!public! !
!ISpeechPhraseAlternate categoriesFor: #recoResult!**auto generated**!properties!public! !
!ISpeechPhraseAlternate categoriesFor: #startElementInResult!**auto generated**!properties!public! !

!ISpeechPhraseAlternate class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseAlternate'
		ISpeechPhraseAlternate defineTemplate"

	self
		defineFunction: #get_RecoResult:
			argumentTypes: 'ISpeechRecoResult**';
		defineFunction: #get_StartElementInResult:
			argumentTypes: 'sdword*';
		defineFunction: #get_NumberOfElementsInResult:
			argumentTypes: 'sdword*';
		defineFunction: #get_PhraseInfo:
			argumentTypes: 'ISpeechPhraseInfo**';
		defineFunction: #Commit
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseAlternate initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseAlternate class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseAlternate class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

