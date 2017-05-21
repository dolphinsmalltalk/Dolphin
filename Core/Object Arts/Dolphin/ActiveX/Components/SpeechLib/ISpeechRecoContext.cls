"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechRecoContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechRecoContext guid: (IID fromString: '{580AA49D-7E1E-4809-B8E2-57DA806104B8}')!
ISpeechRecoContext comment: '<ISpeechRecoContext> is a wrapper class for the COM interface ''SpeechLib.ISpeechRecoContext'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechRecoContext Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(580AA49D-7E1E-4809-B8E2-57DA806104B8), 
	helpstring("ISpeechRecoContext Interface"), 
	dual
]
interface ISpeechRecoContext : IDispatch {
	[id(0x00000001), propget, helpstring("Recognizer")]
	HRESULT __stdcall Recognizer(
		[out, retval] ISpeechRecognizer** Recognizer);
	[id(0x00000002), propget, helpstring("AudioInInterferenceStatus")]
	HRESULT __stdcall AudioInputInterferenceStatus(
		[out, retval] SpeechInterference* Interference);
	[id(0x00000003), propget, helpstring("RequestedUIType")]
	HRESULT __stdcall RequestedUIType(
		[out, retval] BSTR* UIType);
	[id(0x00000004), propputref, helpstring("Voice")]
	HRESULT __stdcall Voice(
		[in] ISpeechVoice* Voice);
	[id(0x00000004), propget, helpstring("Voice")]
	HRESULT __stdcall Voice(
		[out, retval] ISpeechVoice** Voice);
	[id(0x00000005), hidden, propput, helpstring("AllowVoiceFormatMatchingOnNextSet")]
	HRESULT __stdcall AllowVoiceFormatMatchingOnNextSet(
		[in] VARIANT_BOOL pAllow);
	[id(0x00000005), hidden, propget, helpstring("AllowVoiceFormatMatchingOnNextSet")]
	HRESULT __stdcall AllowVoiceFormatMatchingOnNextSet(
		[out, retval] VARIANT_BOOL* pAllow);
	[id(0x00000006), propput, helpstring("VoicePurgeEvent")]
	HRESULT __stdcall VoicePurgeEvent(
		[in] SpeechRecoEvents EventInterest);
	[id(0x00000006), propget, helpstring("VoicePurgeEvent")]
	HRESULT __stdcall VoicePurgeEvent(
		[out, retval] SpeechRecoEvents* EventInterest);
	[id(0x00000007), propput, helpstring("EventInterests")]
	HRESULT __stdcall EventInterests(
		[in] SpeechRecoEvents EventInterest);
	[id(0x00000007), propget, helpstring("EventInterests")]
	HRESULT __stdcall EventInterests(
		[out, retval] SpeechRecoEvents* EventInterest);
	[id(0x00000008), propput, helpstring("CmdMaxAlternates")]
	HRESULT __stdcall CmdMaxAlternates(
		[in] long MaxAlternates);
	[id(0x00000008), propget, helpstring("CmdMaxAlternates")]
	HRESULT __stdcall CmdMaxAlternates(
		[out, retval] long* MaxAlternates);
	[id(0x00000009), propput, helpstring("State")]
	HRESULT __stdcall State(
		[in] SpeechRecoContextState State);
	[id(0x00000009), propget, helpstring("State")]
	HRESULT __stdcall State(
		[out, retval] SpeechRecoContextState* State);
	[id(0x0000000a), propput, helpstring("RetainedAudio")]
	HRESULT __stdcall RetainedAudio(
		[in] SpeechRetainedAudioOptions Option);
	[id(0x0000000a), propget, helpstring("RetainedAudio")]
	HRESULT __stdcall RetainedAudio(
		[out, retval] SpeechRetainedAudioOptions* Option);
	[id(0x0000000b), propputref, helpstring("RetainedAudioFormat")]
	HRESULT __stdcall RetainedAudioFormat(
		[in] ISpeechAudioFormat* Format);
	[id(0x0000000b), propget, helpstring("RetainedAudioFormat")]
	HRESULT __stdcall RetainedAudioFormat(
		[out, retval] ISpeechAudioFormat** Format);
	[id(0x0000000c), helpstring("Pause")]
	HRESULT __stdcall Pause();
	[id(0x0000000d), helpstring("Resume")]
	HRESULT __stdcall Resume();
	[id(0x0000000e), helpstring("CreateGrammar")]
	HRESULT __stdcall CreateGrammar(
		[in, defaultvalue(0)] VARIANT GrammarId,
		[out, retval] ISpeechRecoGrammar** Grammar);
	[id(0x0000000f), helpstring("CreateResultFromMemory")]
	HRESULT __stdcall CreateResultFromMemory(
		[in] VARIANT* ResultBlock,
		[out, retval] ISpeechRecoResult** Result);
	[id(0x00000010), helpstring("Bookmark")]
	HRESULT __stdcall Bookmark(
		[in] SpeechBookmarkOptions Options,
		[in] VARIANT StreamPos,
		[in] VARIANT BookmarkId);
	[id(0x00000011), helpstring("SetAdaptationData")]
	HRESULT __stdcall SetAdaptationData(
		[in] BSTR AdaptationString);
};
'!
!ISpeechRecoContext categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechRecoContext methodsFor!

allowVoiceFormatMatchingOnNextSet
	"Answer the <varbool> value of the 'AllowVoiceFormatMatchingOnNextSet' property of the receiver.
	Helpstring: 'AllowVoiceFormatMatchingOnNextSet'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_AllowVoiceFormatMatchingOnNextSet: answer.
	^answer asObject
!

allowVoiceFormatMatchingOnNextSet: pAllow
	"Set the 'AllowVoiceFormatMatchingOnNextSet' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'AllowVoiceFormatMatchingOnNextSet'"

	self put_AllowVoiceFormatMatchingOnNextSet: pAllow
!

audioInputInterferenceStatus
	"Answer the <sdword> value of the 'AudioInputInterferenceStatus' property of the receiver.
	Helpstring: 'AudioInInterferenceStatus'"

	| answer |
	answer := (SDWORD new).
	self get_AudioInputInterferenceStatus: answer.
	^answer asObject
!

bookmark: options streamPos: streamPos bookmarkId: bookmarkId
	"Invoke the Bookmark() method of the COM object.
	Helpstring: 'Bookmark'"

	^self
		Bookmark: options
		StreamPos: streamPos asVariant
		BookmarkId: bookmarkId asVariant
!

Bookmark: options StreamPos: streamPos BookmarkId: bookmarkId
	"Private - Invoke the Bookmark() method of the COM object.
	Helpstring: 'Bookmark'

		HRESULT __stdcall Bookmark(
			[in] SpeechBookmarkOptions Options,
			[in] VARIANT StreamPos,
			[in] VARIANT BookmarkId);"

	<virtual stdcall: hresult 31 sdword variant variant>
	^self invalidCall
!

cmdMaxAlternates
	"Answer the <sdword> value of the 'CmdMaxAlternates' property of the receiver.
	Helpstring: 'CmdMaxAlternates'"

	| answer |
	answer := (SDWORD new).
	self get_CmdMaxAlternates: answer.
	^answer asObject
!

cmdMaxAlternates: maxAlternates
	"Set the 'CmdMaxAlternates' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'CmdMaxAlternates'"

	self put_CmdMaxAlternates: maxAlternates
!

createGrammar
	"Answer the <ISpeechRecoGrammar> result of invoking the CreateGrammar() method of the COM object.
	Default values are passed for all optional parameters."

	^self createGrammar: 0!

createGrammar: grammarId
	"Answer the <ISpeechRecoGrammar> result of invoking the CreateGrammar() method of the COM object.
	Helpstring: 'CreateGrammar'"

	| answer |
	answer := ISpeechRecoGrammar newPointer.
	self
		CreateGrammar: grammarId asVariant
		Grammar: answer.
	^answer asObject
!

CreateGrammar: grammarId Grammar: grammar
	"Private - Invoke the CreateGrammar() method of the COM object.
	Helpstring: 'CreateGrammar'

		HRESULT __stdcall CreateGrammar(
			[in, defaultvalue(0)] VARIANT GrammarId,
			[out, retval] ISpeechRecoGrammar** Grammar);"

	<virtual stdcall: hresult 29 variant ISpeechRecoGrammar**>
	^self invalidCall
!

createResultFromMemory: resultBlock
	"Answer the <ISpeechRecoResult> result of invoking the CreateResultFromMemory() method of the COM object.
	Helpstring: 'CreateResultFromMemory'"

	| answer |
	answer := ISpeechRecoResult newPointer.
	self
		CreateResultFromMemory: resultBlock asVariant
		Result: answer.
	^answer asObject
!

CreateResultFromMemory: resultBlock Result: result
	"Private - Invoke the CreateResultFromMemory() method of the COM object.
	Helpstring: 'CreateResultFromMemory'

		HRESULT __stdcall CreateResultFromMemory(
			[in] VARIANT* ResultBlock,
			[out, retval] ISpeechRecoResult** Result);"

	<virtual stdcall: hresult 30 variant* ISpeechRecoResult**>
	^self invalidCall
!

eventInterests
	"Answer the <sdword> value of the 'EventInterests' property of the receiver.
	Helpstring: 'EventInterests'"

	| answer |
	answer := (SDWORD new).
	self get_EventInterests: answer.
	^answer asObject
!

eventInterests: eventInterest
	"Set the 'EventInterests' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'EventInterests'"

	self put_EventInterests: eventInterest
!

get_AllowVoiceFormatMatchingOnNextSet: pAllow
	"Private - Get the value of the 'AllowVoiceFormatMatchingOnNextSet' property of the receiver.

		HRESULT __stdcall AllowVoiceFormatMatchingOnNextSet(
			[out, retval] VARIANT_BOOL* pAllow);"

	<virtual stdcall: hresult 14 varbool*>
	^self invalidCall
!

get_AudioInputInterferenceStatus: interference
	"Private - Get the value of the 'AudioInputInterferenceStatus' property of the receiver.

		HRESULT __stdcall AudioInputInterferenceStatus(
			[out, retval] SpeechInterference* Interference);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

get_CmdMaxAlternates: maxAlternates
	"Private - Get the value of the 'CmdMaxAlternates' property of the receiver.

		HRESULT __stdcall CmdMaxAlternates(
			[out, retval] long* MaxAlternates);"

	<virtual stdcall: hresult 20 sdword*>
	^self invalidCall
!

get_EventInterests: eventInterest
	"Private - Get the value of the 'EventInterests' property of the receiver.

		HRESULT __stdcall EventInterests(
			[out, retval] SpeechRecoEvents* EventInterest);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall
!

get_Recognizer: recognizer
	"Private - Get the value of the 'Recognizer' property of the receiver.

		HRESULT __stdcall Recognizer(
			[out, retval] ISpeechRecognizer** Recognizer);"

	<virtual stdcall: hresult 8 ISpeechRecognizer**>
	^self invalidCall
!

get_RequestedUIType: uiType
	"Private - Get the value of the 'RequestedUIType' property of the receiver.

		HRESULT __stdcall RequestedUIType(
			[out, retval] BSTR* UIType);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

get_RetainedAudio: option
	"Private - Get the value of the 'RetainedAudio' property of the receiver.

		HRESULT __stdcall RetainedAudio(
			[out, retval] SpeechRetainedAudioOptions* Option);"

	<virtual stdcall: hresult 24 sdword*>
	^self invalidCall
!

get_RetainedAudioFormat: format
	"Private - Get the value of the 'RetainedAudioFormat' property of the receiver.

		HRESULT __stdcall RetainedAudioFormat(
			[out, retval] ISpeechAudioFormat** Format);"

	<virtual stdcall: hresult 26 ISpeechAudioFormat**>
	^self invalidCall
!

get_State: state
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval] SpeechRecoContextState* State);"

	<virtual stdcall: hresult 22 sdword*>
	^self invalidCall
!

get_Voice: voice
	"Private - Get the value of the 'Voice' property of the receiver.

		HRESULT __stdcall Voice(
			[out, retval] ISpeechVoice** Voice);"

	<virtual stdcall: hresult 12 ISpeechVoice**>
	^self invalidCall
!

get_VoicePurgeEvent: eventInterest
	"Private - Get the value of the 'VoicePurgeEvent' property of the receiver.

		HRESULT __stdcall VoicePurgeEvent(
			[out, retval] SpeechRecoEvents* EventInterest);"

	<virtual stdcall: hresult 16 sdword*>
	^self invalidCall
!

pause
	"Invoke the Pause() method of the COM object.
	Helpstring: 'Pause'"

	^self Pause
!

Pause
	"Private - Invoke the Pause() method of the COM object.
	Helpstring: 'Pause'

		HRESULT __stdcall Pause();"

	<virtual stdcall: hresult 27>
	^self invalidCall
!

put_AllowVoiceFormatMatchingOnNextSet: pAllow
	"Private - Set the value of the 'AllowVoiceFormatMatchingOnNextSet' property of the object wrapped by the 
	 receiver to the <varbool> argument, pAllow.

		HRESULT __stdcall AllowVoiceFormatMatchingOnNextSet(
			[in] VARIANT_BOOL pAllow);"

	<virtual stdcall: hresult 13 varbool>
	^self invalidCall
!

put_CmdMaxAlternates: maxAlternates
	"Private - Set the value of the 'CmdMaxAlternates' property of the object wrapped by the 
	 receiver to the <sdword> argument, maxAlternates.

		HRESULT __stdcall CmdMaxAlternates(
			[in] long MaxAlternates);"

	<virtual stdcall: hresult 19 sdword>
	^self invalidCall
!

put_EventInterests: eventInterest
	"Private - Set the value of the 'EventInterests' property of the object wrapped by the 
	 receiver to the <sdword> argument, eventInterest.

		HRESULT __stdcall EventInterests(
			[in] SpeechRecoEvents EventInterest);"

	<virtual stdcall: hresult 17 sdword>
	^self invalidCall
!

put_RetainedAudio: option
	"Private - Set the value of the 'RetainedAudio' property of the object wrapped by the 
	 receiver to the <sdword> argument, option.

		HRESULT __stdcall RetainedAudio(
			[in] SpeechRetainedAudioOptions Option);"

	<virtual stdcall: hresult 23 sdword>
	^self invalidCall
!

put_State: state
	"Private - Set the value of the 'State' property of the object wrapped by the 
	 receiver to the <sdword> argument, state.

		HRESULT __stdcall State(
			[in] SpeechRecoContextState State);"

	<virtual stdcall: hresult 21 sdword>
	^self invalidCall
!

put_VoicePurgeEvent: eventInterest
	"Private - Set the value of the 'VoicePurgeEvent' property of the object wrapped by the 
	 receiver to the <sdword> argument, eventInterest.

		HRESULT __stdcall VoicePurgeEvent(
			[in] SpeechRecoEvents EventInterest);"

	<virtual stdcall: hresult 15 sdword>
	^self invalidCall
!

putref_RetainedAudioFormat: format
	"Private - Set the value of the 'RetainedAudioFormat' property of the object wrapped by the 
	 receiver to the <ISpeechAudioFormat*> argument, format.

		HRESULT __stdcall RetainedAudioFormat(
			[in] ISpeechAudioFormat* Format);"

	<virtual stdcall: hresult 25 ISpeechAudioFormat*>
	^self invalidCall
!

putref_Voice: voice
	"Private - Set the value of the 'Voice' property of the object wrapped by the 
	 receiver to the <ISpeechVoice*> argument, voice.

		HRESULT __stdcall Voice(
			[in] ISpeechVoice* Voice);"

	<virtual stdcall: hresult 11 ISpeechVoice*>
	^self invalidCall
!

recognizer
	"Answer the <ISpeechRecognizer> value of the 'Recognizer' property of the receiver.
	Helpstring: 'Recognizer'"

	| answer |
	answer := ISpeechRecognizer newPointer.
	self get_Recognizer: answer.
	^answer asObject
!

requestedUIType
	"Answer the <bstr> value of the 'RequestedUIType' property of the receiver.
	Helpstring: 'RequestedUIType'"

	| answer |
	answer := BSTR new.
	self get_RequestedUIType: answer.
	^answer asObject
!

resume
	"Invoke the Resume() method of the COM object.
	Helpstring: 'Resume'"

	^self Resume
!

Resume
	"Private - Invoke the Resume() method of the COM object.
	Helpstring: 'Resume'

		HRESULT __stdcall Resume();"

	<virtual stdcall: hresult 28>
	^self invalidCall
!

retainedAudio
	"Answer the <sdword> value of the 'RetainedAudio' property of the receiver.
	Helpstring: 'RetainedAudio'"

	| answer |
	answer := (SDWORD new).
	self get_RetainedAudio: answer.
	^answer asObject
!

retainedAudio: option
	"Set the 'RetainedAudio' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'RetainedAudio'"

	self put_RetainedAudio: option
!

retainedAudioFormat
	"Answer the <ISpeechAudioFormat> value of the 'RetainedAudioFormat' property of the receiver.
	Helpstring: 'RetainedAudioFormat'"

	| answer |
	answer := ISpeechAudioFormat newPointer.
	self get_RetainedAudioFormat: answer.
	^answer asObject
!

setAdaptationData: adaptationString
	"Invoke the SetAdaptationData() method of the COM object.
	Helpstring: 'SetAdaptationData'"

	^self SetAdaptationData: adaptationString
!

SetAdaptationData: adaptationString
	"Private - Invoke the SetAdaptationData() method of the COM object.
	Helpstring: 'SetAdaptationData'

		HRESULT __stdcall SetAdaptationData(
			[in] BSTR AdaptationString);"

	<virtual stdcall: hresult 32 bstr>
	^self invalidCall
!

setRetainedAudioFormat: format
	"Set the 'RetainedAudioFormat' property of the receiver to the <ISpeechAudioFormat*> value of the argument.
	Helpstring: 'RetainedAudioFormat'"

	self putref_RetainedAudioFormat: format
!

setVoice: voice
	"Set the 'Voice' property of the receiver to the <ISpeechVoice*> value of the argument.
	Helpstring: 'Voice'"

	self putref_Voice: voice
!

state
	"Answer the <sdword> value of the 'State' property of the receiver.
	Helpstring: 'State'"

	| answer |
	answer := (SDWORD new).
	self get_State: answer.
	^answer asObject
!

state: state
	"Set the 'State' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'State'"

	self put_State: state
!

voice
	"Answer the <ISpeechVoice> value of the 'Voice' property of the receiver.
	Helpstring: 'Voice'"

	| answer |
	answer := ISpeechVoice newPointer.
	self get_Voice: answer.
	^answer asObject
!

voicePurgeEvent
	"Answer the <sdword> value of the 'VoicePurgeEvent' property of the receiver.
	Helpstring: 'VoicePurgeEvent'"

	| answer |
	answer := (SDWORD new).
	self get_VoicePurgeEvent: answer.
	^answer asObject
!

voicePurgeEvent: eventInterest
	"Set the 'VoicePurgeEvent' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'VoicePurgeEvent'"

	self put_VoicePurgeEvent: eventInterest
! !
!ISpeechRecoContext categoriesFor: #allowVoiceFormatMatchingOnNextSet!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #allowVoiceFormatMatchingOnNextSet:!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #audioInputInterferenceStatus!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #bookmark:streamPos:bookmarkId:!**auto generated**!methods!public! !
!ISpeechRecoContext categoriesFor: #Bookmark:StreamPos:BookmarkId:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #cmdMaxAlternates!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #cmdMaxAlternates:!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #createGrammar!**auto generated**!methods!public! !
!ISpeechRecoContext categoriesFor: #createGrammar:!**auto generated**!methods!public! !
!ISpeechRecoContext categoriesFor: #CreateGrammar:Grammar:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #createResultFromMemory:!**auto generated**!methods!public! !
!ISpeechRecoContext categoriesFor: #CreateResultFromMemory:Result:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #eventInterests!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #eventInterests:!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #get_AllowVoiceFormatMatchingOnNextSet:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #get_AudioInputInterferenceStatus:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #get_CmdMaxAlternates:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #get_EventInterests:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #get_Recognizer:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #get_RequestedUIType:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #get_RetainedAudio:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #get_RetainedAudioFormat:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #get_State:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #get_Voice:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #get_VoicePurgeEvent:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #pause!**auto generated**!methods!public! !
!ISpeechRecoContext categoriesFor: #Pause!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #put_AllowVoiceFormatMatchingOnNextSet:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #put_CmdMaxAlternates:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #put_EventInterests:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #put_RetainedAudio:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #put_State:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #put_VoicePurgeEvent:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #putref_RetainedAudioFormat:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #putref_Voice:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #recognizer!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #requestedUIType!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #resume!**auto generated**!methods!public! !
!ISpeechRecoContext categoriesFor: #Resume!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #retainedAudio!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #retainedAudio:!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #retainedAudioFormat!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #setAdaptationData:!**auto generated**!methods!public! !
!ISpeechRecoContext categoriesFor: #SetAdaptationData:!**auto generated**!COM Interfaces-ISpeechRecoContext!private! !
!ISpeechRecoContext categoriesFor: #setRetainedAudioFormat:!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #setVoice:!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #state!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #state:!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #voice!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #voicePurgeEvent!**auto generated**!properties!public! !
!ISpeechRecoContext categoriesFor: #voicePurgeEvent:!**auto generated**!properties!public! !

!ISpeechRecoContext class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechRecoContext'
		ISpeechRecoContext defineTemplate"

	self
		defineFunction: #get_Recognizer:
			argumentTypes: 'ISpeechRecognizer**';
		defineFunction: #get_AudioInputInterferenceStatus:
			argumentTypes: 'sdword*';
		defineFunction: #get_RequestedUIType:
			argumentTypes: 'bstr*';
		defineFunction: #putref_Voice:
			argumentTypes: 'ISpeechVoice*';
		defineFunction: #get_Voice:
			argumentTypes: 'ISpeechVoice**';
		defineFunction: #put_AllowVoiceFormatMatchingOnNextSet:
			argumentTypes: 'varbool';
		defineFunction: #get_AllowVoiceFormatMatchingOnNextSet:
			argumentTypes: 'varbool*';
		defineFunction: #put_VoicePurgeEvent:
			argumentTypes: 'sdword';
		defineFunction: #get_VoicePurgeEvent:
			argumentTypes: 'sdword*';
		defineFunction: #put_EventInterests:
			argumentTypes: 'sdword';
		defineFunction: #get_EventInterests:
			argumentTypes: 'sdword*';
		defineFunction: #put_CmdMaxAlternates:
			argumentTypes: 'sdword';
		defineFunction: #get_CmdMaxAlternates:
			argumentTypes: 'sdword*';
		defineFunction: #put_State:
			argumentTypes: 'sdword';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #put_RetainedAudio:
			argumentTypes: 'sdword';
		defineFunction: #get_RetainedAudio:
			argumentTypes: 'sdword*';
		defineFunction: #putref_RetainedAudioFormat:
			argumentTypes: 'ISpeechAudioFormat*';
		defineFunction: #get_RetainedAudioFormat:
			argumentTypes: 'ISpeechAudioFormat**';
		defineFunction: #Pause;
		defineFunction: #Resume;
		defineFunction: #CreateGrammar:Grammar:
			argumentTypes: 'variant ISpeechRecoGrammar**';
		defineFunction: #CreateResultFromMemory:Result:
			argumentTypes: 'variant* ISpeechRecoResult**';
		defineFunction: #Bookmark:StreamPos:BookmarkId:
			argumentTypes: 'sdword variant variant';
		defineFunction: #SetAdaptationData:
			argumentTypes: 'bstr'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechRecoContext initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechRecoContext class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechRecoContext class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

