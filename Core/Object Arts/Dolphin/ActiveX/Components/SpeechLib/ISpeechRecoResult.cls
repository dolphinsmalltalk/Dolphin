"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechRecoResult
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechRecoResult guid: (IID fromString: '{ED2879CF-CED9-4EE6-A534-DE0191D5468D}')!
ISpeechRecoResult comment: '<ISpeechRecoResult> is a wrapper class for the COM interface ''SpeechLib.ISpeechRecoResult'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechRecoResult Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(ED2879CF-CED9-4EE6-A534-DE0191D5468D), 
	helpstring("ISpeechRecoResult Interface"), 
	dual
]
interface ISpeechRecoResult : IDispatch {
	[id(0x00000001), propget, helpstring("RecoContext")]
	HRESULT __stdcall RecoContext(
		[out, retval] ISpeechRecoContext** RecoContext);
	[id(0x00000002), propget, helpstring("Times")]
	HRESULT __stdcall Times(
		[out, retval] ISpeechRecoResultTimes** Times);
	[id(0x00000003), propputref, helpstring("AudioFormat")]
	HRESULT __stdcall AudioFormat(
		[in] ISpeechAudioFormat* Format);
	[id(0x00000003), propget, helpstring("AudioFormat")]
	HRESULT __stdcall AudioFormat(
		[out, retval] ISpeechAudioFormat** Format);
	[id(0x00000004), propget, helpstring("PhraseInfo")]
	HRESULT __stdcall PhraseInfo(
		[out, retval] ISpeechPhraseInfo** PhraseInfo);
	[id(0x00000005), helpstring("Alternates")]
	HRESULT __stdcall Alternates(
		[in] long RequestCount,
		[in, defaultvalue(0)] long StartElement,
		[in, defaultvalue(-1)] long Elements,
		[out, retval] ISpeechPhraseAlternates** Alternates);
	[id(0x00000006), helpstring("Audio")]
	HRESULT __stdcall Audio(
		[in, defaultvalue(0)] long StartElement,
		[in, defaultvalue(-1)] long Elements,
		[out, retval] ISpeechMemoryStream** Stream);
	[id(0x00000007), helpstring("SpeakAudio")]
	HRESULT __stdcall SpeakAudio(
		[in, defaultvalue(0)] long StartElement,
		[in, defaultvalue(-1)] long Elements,
		[in, defaultvalue(0)] SpeechVoiceSpeakFlags Flags,
		[out, retval] long* StreamNumber);
	[id(0x00000008), helpstring("SaveToMemory")]
	HRESULT __stdcall SaveToMemory(
		[out, retval] VARIANT* ResultBlock);
	[id(0x00000009), helpstring("DiscardResultInfo")]
	HRESULT __stdcall DiscardResultInfo(
		[in] SpeechDiscardType ValueTypes);
};
'!
!ISpeechRecoResult categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechRecoResult methodsFor!

alternates: requestCount
	"Answer the <ISpeechPhraseAlternates> result of invoking the Alternates() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 alternates: requestCount
		 startElement: 0
		 elements: -1!

alternates: requestCount startElement: startElement elements: elements
	"Answer the <ISpeechPhraseAlternates> result of invoking the Alternates() method of the COM object.
	Helpstring: 'Alternates'"

	| answer |
	answer := ISpeechPhraseAlternates newPointer.
	self
		Alternates: requestCount
		StartElement: startElement
		Elements: elements
		Alternates: answer.
	^answer asObject
!

Alternates: requestCount StartElement: startElement Elements: elements Alternates: alternates
	"Private - Invoke the Alternates() method of the COM object.
	Helpstring: 'Alternates'

		HRESULT __stdcall Alternates(
			[in] long RequestCount,
			[in, defaultvalue(0)] long StartElement,
			[in, defaultvalue(-1)] long Elements,
			[out, retval] ISpeechPhraseAlternates** Alternates);"

	<virtual stdcall: hresult 13 sdword sdword sdword ISpeechPhraseAlternates**>
	^self invalidCall
!

audio
	"Answer the <ISpeechMemoryStream> result of invoking the Audio() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 audio: 0
		 elements: -1!

audio: startElement elements: elements
	"Answer the <ISpeechMemoryStream> result of invoking the Audio() method of the COM object.
	Helpstring: 'Audio'"

	| answer |
	answer := ISpeechMemoryStream newPointer.
	self
		Audio: startElement
		Elements: elements
		Stream: answer.
	^answer asObject
!

Audio: startElement Elements: elements Stream: stream
	"Private - Invoke the Audio() method of the COM object.
	Helpstring: 'Audio'

		HRESULT __stdcall Audio(
			[in, defaultvalue(0)] long StartElement,
			[in, defaultvalue(-1)] long Elements,
			[out, retval] ISpeechMemoryStream** Stream);"

	<virtual stdcall: hresult 14 sdword sdword ISpeechMemoryStream**>
	^self invalidCall
!

audioFormat
	"Answer the <ISpeechAudioFormat> value of the 'AudioFormat' property of the receiver.
	Helpstring: 'AudioFormat'"

	| answer |
	answer := ISpeechAudioFormat newPointer.
	self get_AudioFormat: answer.
	^answer asObject
!

discardResultInfo: valueTypes
	"Invoke the DiscardResultInfo() method of the COM object.
	Helpstring: 'DiscardResultInfo'"

	^self DiscardResultInfo: valueTypes
!

DiscardResultInfo: valueTypes
	"Private - Invoke the DiscardResultInfo() method of the COM object.
	Helpstring: 'DiscardResultInfo'

		HRESULT __stdcall DiscardResultInfo(
			[in] SpeechDiscardType ValueTypes);"

	<virtual stdcall: hresult 17 sdword>
	^self invalidCall
!

get_AudioFormat: format
	"Private - Get the value of the 'AudioFormat' property of the receiver.

		HRESULT __stdcall AudioFormat(
			[out, retval] ISpeechAudioFormat** Format);"

	<virtual stdcall: hresult 11 ISpeechAudioFormat**>
	^self invalidCall
!

get_PhraseInfo: phraseInfo
	"Private - Get the value of the 'PhraseInfo' property of the receiver.

		HRESULT __stdcall PhraseInfo(
			[out, retval] ISpeechPhraseInfo** PhraseInfo);"

	<virtual stdcall: hresult 12 ISpeechPhraseInfo**>
	^self invalidCall
!

get_RecoContext: recoContext
	"Private - Get the value of the 'RecoContext' property of the receiver.

		HRESULT __stdcall RecoContext(
			[out, retval] ISpeechRecoContext** RecoContext);"

	<virtual stdcall: hresult 8 ISpeechRecoContext**>
	^self invalidCall
!

get_Times: times
	"Private - Get the value of the 'Times' property of the receiver.

		HRESULT __stdcall Times(
			[out, retval] ISpeechRecoResultTimes** Times);"

	<virtual stdcall: hresult 9 ISpeechRecoResultTimes**>
	^self invalidCall
!

phraseInfo
	"Answer the <ISpeechPhraseInfo> value of the 'PhraseInfo' property of the receiver.
	Helpstring: 'PhraseInfo'"

	| answer |
	answer := ISpeechPhraseInfo newPointer.
	self get_PhraseInfo: answer.
	^answer asObject
!

putref_AudioFormat: format
	"Private - Set the value of the 'AudioFormat' property of the object wrapped by the 
	 receiver to the <ISpeechAudioFormat*> argument, format.

		HRESULT __stdcall AudioFormat(
			[in] ISpeechAudioFormat* Format);"

	<virtual stdcall: hresult 10 ISpeechAudioFormat*>
	^self invalidCall
!

recoContext
	"Answer the <ISpeechRecoContext> value of the 'RecoContext' property of the receiver.
	Helpstring: 'RecoContext'"

	| answer |
	answer := ISpeechRecoContext newPointer.
	self get_RecoContext: answer.
	^answer asObject
!

saveToMemory
	"Answer the <VARIANT> result of invoking the SaveToMemory() method of the COM object.
	Helpstring: 'SaveToMemory'"

	| answer |
	answer := VARIANT new.
	self SaveToMemory: answer.
	^answer asObject
!

SaveToMemory: resultBlock
	"Private - Invoke the SaveToMemory() method of the COM object.
	Helpstring: 'SaveToMemory'

		HRESULT __stdcall SaveToMemory(
			[out, retval] VARIANT* ResultBlock);"

	<virtual stdcall: hresult 16 variant*>
	^self invalidCall
!

setAudioFormat: format
	"Set the 'AudioFormat' property of the receiver to the <ISpeechAudioFormat*> value of the argument.
	Helpstring: 'AudioFormat'"

	self putref_AudioFormat: format
!

speakAudio
	"Answer the <SDWORD> result of invoking the SpeakAudio() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 speakAudio: 0
		 elements: -1
		 flags: 0!

speakAudio: startElement elements: elements flags: flags
	"Answer the <SDWORD> result of invoking the SpeakAudio() method of the COM object.
	Helpstring: 'SpeakAudio'"

	| answer |
	answer := (SDWORD new).
	self
		SpeakAudio: startElement
		Elements: elements
		Flags: flags
		StreamNumber: answer.
	^answer asObject
!

SpeakAudio: startElement Elements: elements Flags: flags StreamNumber: streamNumber
	"Private - Invoke the SpeakAudio() method of the COM object.
	Helpstring: 'SpeakAudio'

		HRESULT __stdcall SpeakAudio(
			[in, defaultvalue(0)] long StartElement,
			[in, defaultvalue(-1)] long Elements,
			[in, defaultvalue(0)] SpeechVoiceSpeakFlags Flags,
			[out, retval] long* StreamNumber);"

	<virtual stdcall: hresult 15 sdword sdword sdword sdword*>
	^self invalidCall
!

times
	"Answer the <ISpeechRecoResultTimes> value of the 'Times' property of the receiver.
	Helpstring: 'Times'"

	| answer |
	answer := ISpeechRecoResultTimes newPointer.
	self get_Times: answer.
	^answer asObject
! !
!ISpeechRecoResult categoriesFor: #alternates:!**auto generated**!methods!public! !
!ISpeechRecoResult categoriesFor: #alternates:startElement:elements:!**auto generated**!methods!public! !
!ISpeechRecoResult categoriesFor: #Alternates:StartElement:Elements:Alternates:!**auto generated**!COM Interfaces-ISpeechRecoResult!private! !
!ISpeechRecoResult categoriesFor: #audio!**auto generated**!methods!public! !
!ISpeechRecoResult categoriesFor: #audio:elements:!**auto generated**!methods!public! !
!ISpeechRecoResult categoriesFor: #Audio:Elements:Stream:!**auto generated**!COM Interfaces-ISpeechRecoResult!private! !
!ISpeechRecoResult categoriesFor: #audioFormat!**auto generated**!properties!public! !
!ISpeechRecoResult categoriesFor: #discardResultInfo:!**auto generated**!methods!public! !
!ISpeechRecoResult categoriesFor: #DiscardResultInfo:!**auto generated**!COM Interfaces-ISpeechRecoResult!private! !
!ISpeechRecoResult categoriesFor: #get_AudioFormat:!**auto generated**!COM Interfaces-ISpeechRecoResult!private! !
!ISpeechRecoResult categoriesFor: #get_PhraseInfo:!**auto generated**!COM Interfaces-ISpeechRecoResult!private! !
!ISpeechRecoResult categoriesFor: #get_RecoContext:!**auto generated**!COM Interfaces-ISpeechRecoResult!private! !
!ISpeechRecoResult categoriesFor: #get_Times:!**auto generated**!COM Interfaces-ISpeechRecoResult!private! !
!ISpeechRecoResult categoriesFor: #phraseInfo!**auto generated**!properties!public! !
!ISpeechRecoResult categoriesFor: #putref_AudioFormat:!**auto generated**!COM Interfaces-ISpeechRecoResult!private! !
!ISpeechRecoResult categoriesFor: #recoContext!**auto generated**!properties!public! !
!ISpeechRecoResult categoriesFor: #saveToMemory!**auto generated**!methods!public! !
!ISpeechRecoResult categoriesFor: #SaveToMemory:!**auto generated**!COM Interfaces-ISpeechRecoResult!private! !
!ISpeechRecoResult categoriesFor: #setAudioFormat:!**auto generated**!properties!public! !
!ISpeechRecoResult categoriesFor: #speakAudio!**auto generated**!methods!public! !
!ISpeechRecoResult categoriesFor: #speakAudio:elements:flags:!**auto generated**!methods!public! !
!ISpeechRecoResult categoriesFor: #SpeakAudio:Elements:Flags:StreamNumber:!**auto generated**!COM Interfaces-ISpeechRecoResult!private! !
!ISpeechRecoResult categoriesFor: #times!**auto generated**!properties!public! !

!ISpeechRecoResult class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechRecoResult'
		ISpeechRecoResult defineTemplate"

	self
		defineFunction: #get_RecoContext:
			argumentTypes: 'ISpeechRecoContext**';
		defineFunction: #get_Times:
			argumentTypes: 'ISpeechRecoResultTimes**';
		defineFunction: #putref_AudioFormat:
			argumentTypes: 'ISpeechAudioFormat*';
		defineFunction: #get_AudioFormat:
			argumentTypes: 'ISpeechAudioFormat**';
		defineFunction: #get_PhraseInfo:
			argumentTypes: 'ISpeechPhraseInfo**';
		defineFunction: #Alternates:StartElement:Elements:Alternates:
			argumentTypes: 'sdword sdword sdword ISpeechPhraseAlternates**';
		defineFunction: #Audio:Elements:Stream:
			argumentTypes: 'sdword sdword ISpeechMemoryStream**';
		defineFunction: #SpeakAudio:Elements:Flags:StreamNumber:
			argumentTypes: 'sdword sdword sdword sdword*';
		defineFunction: #SaveToMemory:
			argumentTypes: 'variant*';
		defineFunction: #DiscardResultInfo:
			argumentTypes: 'sdword'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechRecoResult initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechRecoResult class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechRecoResult class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

