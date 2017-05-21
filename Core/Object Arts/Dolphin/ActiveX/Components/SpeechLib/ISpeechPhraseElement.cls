"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechPhraseElement
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseElement guid: (IID fromString: '{E6176F96-E373-4801-B223-3B62C068C0B4}')!
ISpeechPhraseElement comment: '<ISpeechPhraseElement> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseElement'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseElement Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(E6176F96-E373-4801-B223-3B62C068C0B4), 
	helpstring("ISpeechPhraseElement Interface"), 
	dual
]
interface ISpeechPhraseElement : IDispatch {
	[id(0x00000001), propget, helpstring("AudioTimeOffset")]
	HRESULT __stdcall AudioTimeOffset(
		[out, retval] long* AudioTimeOffset);
	[id(0x00000002), propget, helpstring("AudioSizeTime")]
	HRESULT __stdcall AudioSizeTime(
		[out, retval] long* AudioSizeTime);
	[id(0x00000003), propget, helpstring("AudioStreamOffset")]
	HRESULT __stdcall AudioStreamOffset(
		[out, retval] long* AudioStreamOffset);
	[id(0x00000004), propget, helpstring("AudioSizeBytes")]
	HRESULT __stdcall AudioSizeBytes(
		[out, retval] long* AudioSizeBytes);
	[id(0x00000005), propget, helpstring("RetainedStreamOffset")]
	HRESULT __stdcall RetainedStreamOffset(
		[out, retval] long* RetainedStreamOffset);
	[id(0x00000006), propget, helpstring("RetainedSizeBytes")]
	HRESULT __stdcall RetainedSizeBytes(
		[out, retval] long* RetainedSizeBytes);
	[id(0x00000007), propget, helpstring("DisplayText")]
	HRESULT __stdcall DisplayText(
		[out, retval] BSTR* DisplayText);
	[id(0x00000008), propget, helpstring("LexicalForm")]
	HRESULT __stdcall LexicalForm(
		[out, retval] BSTR* LexicalForm);
	[id(0x00000009), propget, helpstring("Pronunciation")]
	HRESULT __stdcall Pronunciation(
		[out, retval] VARIANT* Pronunciation);
	[id(0x0000000a), propget, helpstring("DisplayAttributes")]
	HRESULT __stdcall DisplayAttributes(
		[out, retval] SpeechDisplayAttributes* DisplayAttributes);
	[id(0x0000000b), propget, helpstring("RequiredConfidence")]
	HRESULT __stdcall RequiredConfidence(
		[out, retval] SpeechEngineConfidence* RequiredConfidence);
	[id(0x0000000c), propget, helpstring("ActualConfidence")]
	HRESULT __stdcall ActualConfidence(
		[out, retval] SpeechEngineConfidence* ActualConfidence);
	[id(0x0000000d), propget, helpstring("EngineConfidence")]
	HRESULT __stdcall EngineConfidence(
		[out, retval] single* EngineConfidence);
};
'!
!ISpeechPhraseElement categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseElement methodsFor!

actualConfidence
	"Answer the <sdword> value of the 'ActualConfidence' property of the receiver.
	Helpstring: 'ActualConfidence'"

	| answer |
	answer := (SDWORD new).
	self get_ActualConfidence: answer.
	^answer asObject
!

audioSizeBytes
	"Answer the <sdword> value of the 'AudioSizeBytes' property of the receiver.
	Helpstring: 'AudioSizeBytes'"

	| answer |
	answer := (SDWORD new).
	self get_AudioSizeBytes: answer.
	^answer asObject
!

audioSizeTime
	"Answer the <sdword> value of the 'AudioSizeTime' property of the receiver.
	Helpstring: 'AudioSizeTime'"

	| answer |
	answer := (SDWORD new).
	self get_AudioSizeTime: answer.
	^answer asObject
!

audioStreamOffset
	"Answer the <sdword> value of the 'AudioStreamOffset' property of the receiver.
	Helpstring: 'AudioStreamOffset'"

	| answer |
	answer := (SDWORD new).
	self get_AudioStreamOffset: answer.
	^answer asObject
!

audioTimeOffset
	"Answer the <sdword> value of the 'AudioTimeOffset' property of the receiver.
	Helpstring: 'AudioTimeOffset'"

	| answer |
	answer := (SDWORD new).
	self get_AudioTimeOffset: answer.
	^answer asObject
!

displayAttributes
	"Answer the <sdword> value of the 'DisplayAttributes' property of the receiver.
	Helpstring: 'DisplayAttributes'"

	| answer |
	answer := (SDWORD new).
	self get_DisplayAttributes: answer.
	^answer asObject
!

displayText
	"Answer the <bstr> value of the 'DisplayText' property of the receiver.
	Helpstring: 'DisplayText'"

	| answer |
	answer := BSTR new.
	self get_DisplayText: answer.
	^answer asObject
!

engineConfidence
	"Answer the <float> value of the 'EngineConfidence' property of the receiver.
	Helpstring: 'EngineConfidence'"

	| answer |
	answer := (FLOAT new).
	self get_EngineConfidence: answer.
	^answer asObject
!

get_ActualConfidence: actualConfidence
	"Private - Get the value of the 'ActualConfidence' property of the receiver.

		HRESULT __stdcall ActualConfidence(
			[out, retval] SpeechEngineConfidence* ActualConfidence);"

	<virtual stdcall: hresult 19 sdword*>
	^self invalidCall
!

get_AudioSizeBytes: audioSizeBytes
	"Private - Get the value of the 'AudioSizeBytes' property of the receiver.

		HRESULT __stdcall AudioSizeBytes(
			[out, retval] long* AudioSizeBytes);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall
!

get_AudioSizeTime: audioSizeTime
	"Private - Get the value of the 'AudioSizeTime' property of the receiver.

		HRESULT __stdcall AudioSizeTime(
			[out, retval] long* AudioSizeTime);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

get_AudioStreamOffset: audioStreamOffset
	"Private - Get the value of the 'AudioStreamOffset' property of the receiver.

		HRESULT __stdcall AudioStreamOffset(
			[out, retval] long* AudioStreamOffset);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

get_AudioTimeOffset: audioTimeOffset
	"Private - Get the value of the 'AudioTimeOffset' property of the receiver.

		HRESULT __stdcall AudioTimeOffset(
			[out, retval] long* AudioTimeOffset);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_DisplayAttributes: displayAttributes
	"Private - Get the value of the 'DisplayAttributes' property of the receiver.

		HRESULT __stdcall DisplayAttributes(
			[out, retval] SpeechDisplayAttributes* DisplayAttributes);"

	<virtual stdcall: hresult 17 sdword*>
	^self invalidCall
!

get_DisplayText: displayText
	"Private - Get the value of the 'DisplayText' property of the receiver.

		HRESULT __stdcall DisplayText(
			[out, retval] BSTR* DisplayText);"

	<virtual stdcall: hresult 14 bstr*>
	^self invalidCall
!

get_EngineConfidence: engineConfidence
	"Private - Get the value of the 'EngineConfidence' property of the receiver.

		HRESULT __stdcall EngineConfidence(
			[out, retval] single* EngineConfidence);"

	<virtual stdcall: hresult 20 float*>
	^self invalidCall
!

get_LexicalForm: lexicalForm
	"Private - Get the value of the 'LexicalForm' property of the receiver.

		HRESULT __stdcall LexicalForm(
			[out, retval] BSTR* LexicalForm);"

	<virtual stdcall: hresult 15 bstr*>
	^self invalidCall
!

get_Pronunciation: pronunciation
	"Private - Get the value of the 'Pronunciation' property of the receiver.

		HRESULT __stdcall Pronunciation(
			[out, retval] VARIANT* Pronunciation);"

	<virtual stdcall: hresult 16 variant*>
	^self invalidCall
!

get_RequiredConfidence: requiredConfidence
	"Private - Get the value of the 'RequiredConfidence' property of the receiver.

		HRESULT __stdcall RequiredConfidence(
			[out, retval] SpeechEngineConfidence* RequiredConfidence);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall
!

get_RetainedSizeBytes: retainedSizeBytes
	"Private - Get the value of the 'RetainedSizeBytes' property of the receiver.

		HRESULT __stdcall RetainedSizeBytes(
			[out, retval] long* RetainedSizeBytes);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall
!

get_RetainedStreamOffset: retainedStreamOffset
	"Private - Get the value of the 'RetainedStreamOffset' property of the receiver.

		HRESULT __stdcall RetainedStreamOffset(
			[out, retval] long* RetainedStreamOffset);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall
!

lexicalForm
	"Answer the <bstr> value of the 'LexicalForm' property of the receiver.
	Helpstring: 'LexicalForm'"

	| answer |
	answer := BSTR new.
	self get_LexicalForm: answer.
	^answer asObject
!

pronunciation
	"Answer the <variant> value of the 'Pronunciation' property of the receiver.
	Helpstring: 'Pronunciation'"

	| answer |
	answer := VARIANT new.
	self get_Pronunciation: answer.
	^answer asObject
!

requiredConfidence
	"Answer the <sdword> value of the 'RequiredConfidence' property of the receiver.
	Helpstring: 'RequiredConfidence'"

	| answer |
	answer := (SDWORD new).
	self get_RequiredConfidence: answer.
	^answer asObject
!

retainedSizeBytes
	"Answer the <sdword> value of the 'RetainedSizeBytes' property of the receiver.
	Helpstring: 'RetainedSizeBytes'"

	| answer |
	answer := (SDWORD new).
	self get_RetainedSizeBytes: answer.
	^answer asObject
!

retainedStreamOffset
	"Answer the <sdword> value of the 'RetainedStreamOffset' property of the receiver.
	Helpstring: 'RetainedStreamOffset'"

	| answer |
	answer := (SDWORD new).
	self get_RetainedStreamOffset: answer.
	^answer asObject
! !
!ISpeechPhraseElement categoriesFor: #actualConfidence!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #audioSizeBytes!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #audioSizeTime!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #audioStreamOffset!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #audioTimeOffset!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #displayAttributes!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #displayText!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #engineConfidence!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #get_ActualConfidence:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_AudioSizeBytes:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_AudioSizeTime:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_AudioStreamOffset:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_AudioTimeOffset:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_DisplayAttributes:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_DisplayText:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_EngineConfidence:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_LexicalForm:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_Pronunciation:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_RequiredConfidence:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_RetainedSizeBytes:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #get_RetainedStreamOffset:!**auto generated**!COM Interfaces-ISpeechPhraseElement!private! !
!ISpeechPhraseElement categoriesFor: #lexicalForm!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #pronunciation!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #requiredConfidence!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #retainedSizeBytes!**auto generated**!properties!public! !
!ISpeechPhraseElement categoriesFor: #retainedStreamOffset!**auto generated**!properties!public! !

!ISpeechPhraseElement class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseElement'
		ISpeechPhraseElement defineTemplate"

	self
		defineFunction: #get_AudioTimeOffset:
			argumentTypes: 'sdword*';
		defineFunction: #get_AudioSizeTime:
			argumentTypes: 'sdword*';
		defineFunction: #get_AudioStreamOffset:
			argumentTypes: 'sdword*';
		defineFunction: #get_AudioSizeBytes:
			argumentTypes: 'sdword*';
		defineFunction: #get_RetainedStreamOffset:
			argumentTypes: 'sdword*';
		defineFunction: #get_RetainedSizeBytes:
			argumentTypes: 'sdword*';
		defineFunction: #get_DisplayText:
			argumentTypes: 'bstr*';
		defineFunction: #get_LexicalForm:
			argumentTypes: 'bstr*';
		defineFunction: #get_Pronunciation:
			argumentTypes: 'variant*';
		defineFunction: #get_DisplayAttributes:
			argumentTypes: 'sdword*';
		defineFunction: #get_RequiredConfidence:
			argumentTypes: 'sdword*';
		defineFunction: #get_ActualConfidence:
			argumentTypes: 'sdword*';
		defineFunction: #get_EngineConfidence:
			argumentTypes: 'float*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseElement initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseElement class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseElement class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

