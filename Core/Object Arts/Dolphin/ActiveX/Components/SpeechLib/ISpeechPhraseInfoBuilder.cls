"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechPhraseInfoBuilder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseInfoBuilder guid: (IID fromString: '{3B151836-DF3A-4E0A-846C-D2ADC9334333}')!
ISpeechPhraseInfoBuilder comment: '<ISpeechPhraseInfoBuilder> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseInfoBuilder'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseInfoBuilder Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(3B151836-DF3A-4E0A-846C-D2ADC9334333), 
	helpstring("ISpeechPhraseInfoBuilder Interface"), 
	dual
]
interface ISpeechPhraseInfoBuilder : IDispatch {
	[id(0x00000001), helpstring("RestorePhraseFromMemory")]
	HRESULT __stdcall RestorePhraseFromMemory(
		[in] VARIANT* PhraseInMemory,
		[out, retval] ISpeechPhraseInfo** PhraseInfo);
};
'!
!ISpeechPhraseInfoBuilder categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseInfoBuilder methodsFor!

restorePhraseFromMemory: phraseInMemory
	"Answer the <ISpeechPhraseInfo> result of invoking the RestorePhraseFromMemory() method of the COM object.
	Helpstring: 'RestorePhraseFromMemory'"

	| answer |
	answer := ISpeechPhraseInfo newPointer.
	self
		RestorePhraseFromMemory: phraseInMemory asVariant
		PhraseInfo: answer.
	^answer asObject
!

RestorePhraseFromMemory: phraseInMemory PhraseInfo: phraseInfo
	"Private - Invoke the RestorePhraseFromMemory() method of the COM object.
	Helpstring: 'RestorePhraseFromMemory'

		HRESULT __stdcall RestorePhraseFromMemory(
			[in] VARIANT* PhraseInMemory,
			[out, retval] ISpeechPhraseInfo** PhraseInfo);"

	<virtual stdcall: hresult 8 variant* ISpeechPhraseInfo**>
	^self invalidCall
! !
!ISpeechPhraseInfoBuilder categoriesFor: #restorePhraseFromMemory:!**auto generated**!methods!public! !
!ISpeechPhraseInfoBuilder categoriesFor: #RestorePhraseFromMemory:PhraseInfo:!**auto generated**!COM Interfaces-ISpeechPhraseInfoBuilder!private! !

!ISpeechPhraseInfoBuilder class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpPhraseInfoBuilder) for which the receiver is the default interface."

	^CLSID fromString: '{C23FC28D-C55F-4720-8B32-91F73C2BD5D1}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseInfoBuilder'
		ISpeechPhraseInfoBuilder defineTemplate"

	self
		defineFunction: #RestorePhraseFromMemory:PhraseInfo:
			argumentTypes: 'variant* ISpeechPhraseInfo**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseInfoBuilder initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseInfoBuilder class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpeechPhraseInfoBuilder class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseInfoBuilder class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

