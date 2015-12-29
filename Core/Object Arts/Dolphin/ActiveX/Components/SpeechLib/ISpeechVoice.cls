"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechVoice
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechVoice guid: (IID fromString: '{269316D8-57BD-11D2-9EEE-00C04F797396}')!
ISpeechVoice comment: '<ISpeechVoice> is a wrapper class for the COM interface ''SpeechLib.ISpeechVoice'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechVoice Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(269316D8-57BD-11D2-9EEE-00C04F797396), 
	helpstring("ISpeechVoice Interface"), 
	dual
]
interface ISpeechVoice : IDispatch {
	[id(0x00000001), propget, helpstring("Status")]
	HRESULT __stdcall Status(
		[out, retval] ISpeechVoiceStatus** Status);
	[id(0x00000002), propget, helpstring("Voice")]
	HRESULT __stdcall Voice(
		[out, retval] ISpeechObjectToken** Voice);
	[id(0x00000002), propputref, helpstring("Voice")]
	HRESULT __stdcall Voice(
		[in] ISpeechObjectToken* Voice);
	[id(0x00000003), propget, helpstring("Gets the audio output object")]
	HRESULT __stdcall AudioOutput(
		[out, retval] ISpeechObjectToken** AudioOutput);
	[id(0x00000003), propputref, helpstring("Gets the audio output object")]
	HRESULT __stdcall AudioOutput(
		[in] ISpeechObjectToken* AudioOutput);
	[id(0x00000004), propget, helpstring("Gets the audio output stream")]
	HRESULT __stdcall AudioOutputStream(
		[out, retval] ISpeechBaseStream** AudioOutputStream);
	[id(0x00000004), propputref, helpstring("Gets the audio output stream")]
	HRESULT __stdcall AudioOutputStream(
		[in] ISpeechBaseStream* AudioOutputStream);
	[id(0x00000005), propget, helpstring("Rate")]
	HRESULT __stdcall Rate(
		[out, retval] long* Rate);
	[id(0x00000005), propput, helpstring("Rate")]
	HRESULT __stdcall Rate(
		[in] long Rate);
	[id(0x00000006), propget, helpstring("Volume")]
	HRESULT __stdcall Volume(
		[out, retval] long* Volume);
	[id(0x00000006), propput, helpstring("Volume")]
	HRESULT __stdcall Volume(
		[in] long Volume);
	[id(0x00000007), hidden, propput, helpstring("AllowAudioOutputFormatChangesOnNextSet")]
	HRESULT __stdcall AllowAudioOutputFormatChangesOnNextSet(
		[in] VARIANT_BOOL Allow);
	[id(0x00000007), hidden, propget, helpstring("AllowAudioOutputFormatChangesOnNextSet")]
	HRESULT __stdcall AllowAudioOutputFormatChangesOnNextSet(
		[out, retval] VARIANT_BOOL* Allow);
	[id(0x00000008), propget, helpstring("EventInterests")]
	HRESULT __stdcall EventInterests(
		[out, retval] SpeechVoiceEvents* EventInterestFlags);
	[id(0x00000008), propput, helpstring("EventInterests")]
	HRESULT __stdcall EventInterests(
		[in] SpeechVoiceEvents EventInterestFlags);
	[id(0x00000009), propput, helpstring("Priority")]
	HRESULT __stdcall Priority(
		[in] SpeechVoicePriority Priority);
	[id(0x00000009), propget, helpstring("Priority")]
	HRESULT __stdcall Priority(
		[out, retval] SpeechVoicePriority* Priority);
	[id(0x0000000a), propput, helpstring("AlertBoundary")]
	HRESULT __stdcall AlertBoundary(
		[in] SpeechVoiceEvents Boundary);
	[id(0x0000000a), propget, helpstring("AlertBoundary")]
	HRESULT __stdcall AlertBoundary(
		[out, retval] SpeechVoiceEvents* Boundary);
	[id(0x0000000b), propput, helpstring("SyncSpeakTimeout")]
	HRESULT __stdcall SynchronousSpeakTimeout(
		[in] long msTimeout);
	[id(0x0000000b), propget, helpstring("SyncSpeakTimeout")]
	HRESULT __stdcall SynchronousSpeakTimeout(
		[out, retval] long* msTimeout);
	[id(0x0000000c), helpstring("Speak")]
	HRESULT __stdcall Speak(
		[in] BSTR Text,
		[in, defaultvalue(0)] SpeechVoiceSpeakFlags Flags,
		[out, retval] long* StreamNumber);
	[id(0x0000000d), helpstring("SpeakStream")]
	HRESULT __stdcall SpeakStream(
		[in] ISpeechBaseStream* Stream,
		[in, defaultvalue(0)] SpeechVoiceSpeakFlags Flags,
		[out, retval] long* StreamNumber);
	[id(0x0000000e), helpstring("Pauses the voices rendering.")]
	HRESULT __stdcall Pause();
	[id(0x0000000f), helpstring("Resumes the voices rendering.")]
	HRESULT __stdcall Resume();
	[id(0x00000010), helpstring("Skips rendering the specified number of items.")]
	HRESULT __stdcall Skip(
		[in] BSTR Type,
		[in] long NumItems,
		[out, retval] long* NumSkipped);
	[id(0x00000011), helpstring("GetVoices")]
	HRESULT __stdcall GetVoices(
		[in, defaultvalue("")] BSTR RequiredAttributes,
		[in, defaultvalue("")] BSTR OptionalAttributes,
		[out, retval] ISpeechObjectTokens** ObjectTokens);
	[id(0x00000012), helpstring("GetAudioOutputs")]
	HRESULT __stdcall GetAudioOutputs(
		[in, defaultvalue("")] BSTR RequiredAttributes,
		[in, defaultvalue("")] BSTR OptionalAttributes,
		[out, retval] ISpeechObjectTokens** ObjectTokens);
	[id(0x00000013), helpstring("WaitUntilDone")]
	HRESULT __stdcall WaitUntilDone(
		[in] long msTimeout,
		[out, retval] VARIANT_BOOL* Done);
	[id(0x00000014), hidden, helpstring("SpeakCompleteEvent")]
	HRESULT __stdcall SpeakCompleteEvent(
		[out, retval] long* Handle);
	[id(0x00000015), helpstring("IsUISupported")]
	HRESULT __stdcall IsUISupported(
		[in] BSTR TypeOfUI,
		[in, defaultvalue("")] VARIANT* ExtraData,
		[out, retval] VARIANT_BOOL* Supported);
	[id(0x00000016), helpstring("DisplayUI")]
	HRESULT __stdcall DisplayUI(
		[in] long hWndParent,
		[in] BSTR Title,
		[in] BSTR TypeOfUI,
		[in, defaultvalue("")] VARIANT* ExtraData);
};
'!
!ISpeechVoice categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechVoice methodsFor!

alertBoundary
	"Answer the <sdword> value of the 'AlertBoundary' property of the receiver.
	Helpstring: 'AlertBoundary'"

	| answer |
	answer := (SDWORD new).
	self get_AlertBoundary: answer.
	^answer asObject
!

alertBoundary: boundary
	"Set the 'AlertBoundary' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'AlertBoundary'"

	self put_AlertBoundary: boundary
!

allowAudioOutputFormatChangesOnNextSet
	"Answer the <varbool> value of the 'AllowAudioOutputFormatChangesOnNextSet' property of the receiver.
	Helpstring: 'AllowAudioOutputFormatChangesOnNextSet'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_AllowAudioOutputFormatChangesOnNextSet: answer.
	^answer asObject
!

allowAudioOutputFormatChangesOnNextSet: allow
	"Set the 'AllowAudioOutputFormatChangesOnNextSet' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'AllowAudioOutputFormatChangesOnNextSet'"

	self put_AllowAudioOutputFormatChangesOnNextSet: allow
!

audioOutput
	"Answer the <ISpeechObjectToken> value of the 'AudioOutput' property of the receiver.
	Helpstring: 'Gets the audio output object'"

	| answer |
	answer := ISpeechObjectToken newPointer.
	self get_AudioOutput: answer.
	^answer asObject
!

audioOutputStream
	"Answer the <ISpeechBaseStream> value of the 'AudioOutputStream' property of the receiver.
	Helpstring: 'Gets the audio output stream'"

	| answer |
	answer := ISpeechBaseStream newPointer.
	self get_AudioOutputStream: answer.
	^answer asObject
!

displayUI: hWndParent title: title typeOfUI: typeOfUI
	"Invoke the DisplayUI() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 displayUI: hWndParent
		 title: title
		 typeOfUI: typeOfUI
		 extraData: ''!

displayUI: hWndParent title: title typeOfUI: typeOfUI extraData: extraData
	"Invoke the DisplayUI() method of the COM object.
	Helpstring: 'DisplayUI'"

	^self
		DisplayUI: hWndParent
		Title: title
		TypeOfUI: typeOfUI
		ExtraData: extraData asVariant
!

DisplayUI: hWndParent Title: title TypeOfUI: typeOfUI ExtraData: extraData
	"Private - Invoke the DisplayUI() method of the COM object.
	Helpstring: 'DisplayUI'

		HRESULT __stdcall DisplayUI(
			[in] long hWndParent,
			[in] BSTR Title,
			[in] BSTR TypeOfUI,
			[in, defaultvalue("")] VARIANT* ExtraData);"

	<virtual stdcall: hresult 39 sdword bstr bstr variant*>
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

eventInterests: eventInterestFlags
	"Set the 'EventInterests' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'EventInterests'"

	self put_EventInterests: eventInterestFlags
!

get_AlertBoundary: boundary
	"Private - Get the value of the 'AlertBoundary' property of the receiver.

		HRESULT __stdcall AlertBoundary(
			[out, retval] SpeechVoiceEvents* Boundary);"

	<virtual stdcall: hresult 26 sdword*>
	^self invalidCall
!

get_AllowAudioOutputFormatChangesOnNextSet: allow
	"Private - Get the value of the 'AllowAudioOutputFormatChangesOnNextSet' property of the receiver.

		HRESULT __stdcall AllowAudioOutputFormatChangesOnNextSet(
			[out, retval] VARIANT_BOOL* Allow);"

	<virtual stdcall: hresult 20 varbool*>
	^self invalidCall
!

get_AudioOutput: audioOutput
	"Private - Get the value of the 'AudioOutput' property of the receiver.

		HRESULT __stdcall AudioOutput(
			[out, retval] ISpeechObjectToken** AudioOutput);"

	<virtual stdcall: hresult 11 ISpeechObjectToken**>
	^self invalidCall
!

get_AudioOutputStream: audioOutputStream
	"Private - Get the value of the 'AudioOutputStream' property of the receiver.

		HRESULT __stdcall AudioOutputStream(
			[out, retval] ISpeechBaseStream** AudioOutputStream);"

	<virtual stdcall: hresult 13 ISpeechBaseStream**>
	^self invalidCall
!

get_EventInterests: eventInterestFlags
	"Private - Get the value of the 'EventInterests' property of the receiver.

		HRESULT __stdcall EventInterests(
			[out, retval] SpeechVoiceEvents* EventInterestFlags);"

	<virtual stdcall: hresult 21 sdword*>
	^self invalidCall
!

get_Priority: priority
	"Private - Get the value of the 'Priority' property of the receiver.

		HRESULT __stdcall Priority(
			[out, retval] SpeechVoicePriority* Priority);"

	<virtual stdcall: hresult 24 sdword*>
	^self invalidCall
!

get_Rate: rate
	"Private - Get the value of the 'Rate' property of the receiver.

		HRESULT __stdcall Rate(
			[out, retval] long* Rate);"

	<virtual stdcall: hresult 15 sdword*>
	^self invalidCall
!

get_Status: status
	"Private - Get the value of the 'Status' property of the receiver.

		HRESULT __stdcall Status(
			[out, retval] ISpeechVoiceStatus** Status);"

	<virtual stdcall: hresult 8 ISpeechVoiceStatus**>
	^self invalidCall
!

get_SynchronousSpeakTimeout: msTimeout
	"Private - Get the value of the 'SynchronousSpeakTimeout' property of the receiver.

		HRESULT __stdcall SynchronousSpeakTimeout(
			[out, retval] long* msTimeout);"

	<virtual stdcall: hresult 28 sdword*>
	^self invalidCall
!

get_Voice: voice
	"Private - Get the value of the 'Voice' property of the receiver.

		HRESULT __stdcall Voice(
			[out, retval] ISpeechObjectToken** Voice);"

	<virtual stdcall: hresult 9 ISpeechObjectToken**>
	^self invalidCall
!

get_Volume: volume
	"Private - Get the value of the 'Volume' property of the receiver.

		HRESULT __stdcall Volume(
			[out, retval] long* Volume);"

	<virtual stdcall: hresult 17 sdword*>
	^self invalidCall
!

getAudioOutputs
	"Answer the <ISpeechObjectTokens> result of invoking the GetAudioOutputs() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 getAudioOutputs: ''
		 optionalAttributes: ''!

getAudioOutputs: requiredAttributes optionalAttributes: optionalAttributes
	"Answer the <ISpeechObjectTokens> result of invoking the GetAudioOutputs() method of the COM object.
	Helpstring: 'GetAudioOutputs'"

	| answer |
	answer := ISpeechObjectTokens newPointer.
	self
		GetAudioOutputs: requiredAttributes
		OptionalAttributes: optionalAttributes
		ObjectTokens: answer.
	^answer asObject
!

GetAudioOutputs: requiredAttributes OptionalAttributes: optionalAttributes ObjectTokens: objectTokens
	"Private - Invoke the GetAudioOutputs() method of the COM object.
	Helpstring: 'GetAudioOutputs'

		HRESULT __stdcall GetAudioOutputs(
			[in, defaultvalue("")] BSTR RequiredAttributes,
			[in, defaultvalue("")] BSTR OptionalAttributes,
			[out, retval] ISpeechObjectTokens** ObjectTokens);"

	<virtual stdcall: hresult 35 bstr bstr ISpeechObjectTokens**>
	^self invalidCall
!

getVoices
	"Answer the <ISpeechObjectTokens> result of invoking the GetVoices() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 getVoices: ''
		 optionalAttributes: ''!

getVoices: requiredAttributes optionalAttributes: optionalAttributes
	"Answer the <ISpeechObjectTokens> result of invoking the GetVoices() method of the COM object.
	Helpstring: 'GetVoices'"

	| answer |
	answer := ISpeechObjectTokens newPointer.
	self
		GetVoices: requiredAttributes
		OptionalAttributes: optionalAttributes
		ObjectTokens: answer.
	^answer asObject
!

GetVoices: requiredAttributes OptionalAttributes: optionalAttributes ObjectTokens: objectTokens
	"Private - Invoke the GetVoices() method of the COM object.
	Helpstring: 'GetVoices'

		HRESULT __stdcall GetVoices(
			[in, defaultvalue("")] BSTR RequiredAttributes,
			[in, defaultvalue("")] BSTR OptionalAttributes,
			[out, retval] ISpeechObjectTokens** ObjectTokens);"

	<virtual stdcall: hresult 34 bstr bstr ISpeechObjectTokens**>
	^self invalidCall
!

isUISupported: typeOfUI
	"Answer the <VARIANT_BOOL> result of invoking the IsUISupported() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 isUISupported: typeOfUI
		 extraData: ''!

isUISupported: typeOfUI extraData: extraData
	"Answer the <VARIANT_BOOL> result of invoking the IsUISupported() method of the COM object.
	Helpstring: 'IsUISupported'"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		IsUISupported: typeOfUI
		ExtraData: extraData asVariant
		Supported: answer.
	^answer asObject
!

IsUISupported: typeOfUI ExtraData: extraData Supported: supported
	"Private - Invoke the IsUISupported() method of the COM object.
	Helpstring: 'IsUISupported'

		HRESULT __stdcall IsUISupported(
			[in] BSTR TypeOfUI,
			[in, defaultvalue("")] VARIANT* ExtraData,
			[out, retval] VARIANT_BOOL* Supported);"

	<virtual stdcall: hresult 38 bstr variant* varbool*>
	^self invalidCall
!

pause
	"Invoke the Pause() method of the COM object.
	Helpstring: 'Pauses the voices rendering.'"

	^self Pause
!

Pause
	"Private - Invoke the Pause() method of the COM object.
	Helpstring: 'Pauses the voices rendering.'

		HRESULT __stdcall Pause();"

	<virtual stdcall: hresult 31>
	^self invalidCall
!

priority
	"Answer the <sdword> value of the 'Priority' property of the receiver.
	Helpstring: 'Priority'"

	| answer |
	answer := (SDWORD new).
	self get_Priority: answer.
	^answer asObject
!

priority: priority
	"Set the 'Priority' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Priority'"

	self put_Priority: priority
!

put_AlertBoundary: boundary
	"Private - Set the value of the 'AlertBoundary' property of the object wrapped by the 
	 receiver to the <sdword> argument, boundary.

		HRESULT __stdcall AlertBoundary(
			[in] SpeechVoiceEvents Boundary);"

	<virtual stdcall: hresult 25 sdword>
	^self invalidCall
!

put_AllowAudioOutputFormatChangesOnNextSet: allow
	"Private - Set the value of the 'AllowAudioOutputFormatChangesOnNextSet' property of the object wrapped by the 
	 receiver to the <varbool> argument, allow.

		HRESULT __stdcall AllowAudioOutputFormatChangesOnNextSet(
			[in] VARIANT_BOOL Allow);"

	<virtual stdcall: hresult 19 varbool>
	^self invalidCall
!

put_EventInterests: eventInterestFlags
	"Private - Set the value of the 'EventInterests' property of the object wrapped by the 
	 receiver to the <sdword> argument, eventInterestFlags.

		HRESULT __stdcall EventInterests(
			[in] SpeechVoiceEvents EventInterestFlags);"

	<virtual stdcall: hresult 22 sdword>
	^self invalidCall
!

put_Priority: priority
	"Private - Set the value of the 'Priority' property of the object wrapped by the 
	 receiver to the <sdword> argument, priority.

		HRESULT __stdcall Priority(
			[in] SpeechVoicePriority Priority);"

	<virtual stdcall: hresult 23 sdword>
	^self invalidCall
!

put_Rate: rate
	"Private - Set the value of the 'Rate' property of the object wrapped by the 
	 receiver to the <sdword> argument, rate.

		HRESULT __stdcall Rate(
			[in] long Rate);"

	<virtual stdcall: hresult 16 sdword>
	^self invalidCall
!

put_SynchronousSpeakTimeout: msTimeout
	"Private - Set the value of the 'SynchronousSpeakTimeout' property of the object wrapped by the 
	 receiver to the <sdword> argument, msTimeout.

		HRESULT __stdcall SynchronousSpeakTimeout(
			[in] long msTimeout);"

	<virtual stdcall: hresult 27 sdword>
	^self invalidCall
!

put_Volume: volume
	"Private - Set the value of the 'Volume' property of the object wrapped by the 
	 receiver to the <sdword> argument, volume.

		HRESULT __stdcall Volume(
			[in] long Volume);"

	<virtual stdcall: hresult 18 sdword>
	^self invalidCall
!

putref_AudioOutput: audioOutput
	"Private - Set the value of the 'AudioOutput' property of the object wrapped by the 
	 receiver to the <ISpeechObjectToken*> argument, audioOutput.

		HRESULT __stdcall AudioOutput(
			[in] ISpeechObjectToken* AudioOutput);"

	<virtual stdcall: hresult 12 ISpeechObjectToken*>
	^self invalidCall
!

putref_AudioOutputStream: audioOutputStream
	"Private - Set the value of the 'AudioOutputStream' property of the object wrapped by the 
	 receiver to the <ISpeechBaseStream*> argument, audioOutputStream.

		HRESULT __stdcall AudioOutputStream(
			[in] ISpeechBaseStream* AudioOutputStream);"

	<virtual stdcall: hresult 14 ISpeechBaseStream*>
	^self invalidCall
!

putref_Voice: voice
	"Private - Set the value of the 'Voice' property of the object wrapped by the 
	 receiver to the <ISpeechObjectToken*> argument, voice.

		HRESULT __stdcall Voice(
			[in] ISpeechObjectToken* Voice);"

	<virtual stdcall: hresult 10 ISpeechObjectToken*>
	^self invalidCall
!

rate
	"Answer the <sdword> value of the 'Rate' property of the receiver.
	Helpstring: 'Rate'"

	| answer |
	answer := (SDWORD new).
	self get_Rate: answer.
	^answer asObject
!

rate: rate
	"Set the 'Rate' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Rate'"

	self put_Rate: rate
!

resume
	"Invoke the Resume() method of the COM object.
	Helpstring: 'Resumes the voices rendering.'"

	^self Resume
!

Resume
	"Private - Invoke the Resume() method of the COM object.
	Helpstring: 'Resumes the voices rendering.'

		HRESULT __stdcall Resume();"

	<virtual stdcall: hresult 32>
	^self invalidCall
!

setAudioOutput: audioOutput
	"Set the 'AudioOutput' property of the receiver to the <ISpeechObjectToken*> value of the argument.
	Helpstring: 'Gets the audio output object'"

	self putref_AudioOutput: audioOutput
!

setAudioOutputStream: audioOutputStream
	"Set the 'AudioOutputStream' property of the receiver to the <ISpeechBaseStream*> value of the argument.
	Helpstring: 'Gets the audio output stream'"

	self putref_AudioOutputStream: audioOutputStream
!

setVoice: voice
	"Set the 'Voice' property of the receiver to the <ISpeechObjectToken*> value of the argument.
	Helpstring: 'Voice'"

	self putref_Voice: voice
!

skip: type numItems: numItems
	"Answer the <SDWORD> result of invoking the Skip() method of the COM object.
	Helpstring: 'Skips rendering the specified number of items.'"

	| answer |
	answer := (SDWORD new).
	self
		Skip: type
		NumItems: numItems
		NumSkipped: answer.
	^answer asObject
!

Skip: type NumItems: numItems NumSkipped: numSkipped
	"Private - Invoke the Skip() method of the COM object.
	Helpstring: 'Skips rendering the specified number of items.'

		HRESULT __stdcall Skip(
			[in] BSTR Type,
			[in] long NumItems,
			[out, retval] long* NumSkipped);"

	<virtual stdcall: hresult 33 bstr sdword sdword*>
	^self invalidCall
!

speak: text
	"Answer the <SDWORD> result of invoking the Speak() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 speak: text
		 flags: 0!

speak: text flags: flags
	"Answer the <SDWORD> result of invoking the Speak() method of the COM object.
	Helpstring: 'Speak'"

	| answer |
	answer := (SDWORD new).
	self
		Speak: text
		Flags: flags
		StreamNumber: answer.
	^answer asObject
!

Speak: text Flags: flags StreamNumber: streamNumber
	"Private - Invoke the Speak() method of the COM object.
	Helpstring: 'Speak'

		HRESULT __stdcall Speak(
			[in] BSTR Text,
			[in, defaultvalue(0)] SpeechVoiceSpeakFlags Flags,
			[out, retval] long* StreamNumber);"

	<virtual stdcall: hresult 29 bstr sdword sdword*>
	^self invalidCall
!

speakCompleteEvent
	"Answer the <SDWORD> result of invoking the SpeakCompleteEvent() method of the COM object.
	Helpstring: 'SpeakCompleteEvent'"

	| answer |
	answer := (SDWORD new).
	self SpeakCompleteEvent: answer.
	^answer asObject
!

SpeakCompleteEvent: handle
	"Private - Invoke the SpeakCompleteEvent() method of the COM object.
	Helpstring: 'SpeakCompleteEvent'

		HRESULT __stdcall SpeakCompleteEvent(
			[out, retval] long* Handle);"

	<virtual stdcall: hresult 37 sdword*>
	^self invalidCall
!

speakStream: stream
	"Answer the <SDWORD> result of invoking the SpeakStream() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 speakStream: stream
		 flags: 0!

speakStream: stream flags: flags
	"Answer the <SDWORD> result of invoking the SpeakStream() method of the COM object.
	Helpstring: 'SpeakStream'"

	| answer |
	answer := (SDWORD new).
	self
		SpeakStream: stream
		Flags: flags
		StreamNumber: answer.
	^answer asObject
!

SpeakStream: stream Flags: flags StreamNumber: streamNumber
	"Private - Invoke the SpeakStream() method of the COM object.
	Helpstring: 'SpeakStream'

		HRESULT __stdcall SpeakStream(
			[in] ISpeechBaseStream* Stream,
			[in, defaultvalue(0)] SpeechVoiceSpeakFlags Flags,
			[out, retval] long* StreamNumber);"

	<virtual stdcall: hresult 30 ISpeechBaseStream* sdword sdword*>
	^self invalidCall
!

status
	"Answer the <ISpeechVoiceStatus> value of the 'Status' property of the receiver.
	Helpstring: 'Status'"

	| answer |
	answer := ISpeechVoiceStatus newPointer.
	self get_Status: answer.
	^answer asObject
!

synchronousSpeakTimeout
	"Answer the <sdword> value of the 'SynchronousSpeakTimeout' property of the receiver.
	Helpstring: 'SyncSpeakTimeout'"

	| answer |
	answer := (SDWORD new).
	self get_SynchronousSpeakTimeout: answer.
	^answer asObject
!

synchronousSpeakTimeout: msTimeout
	"Set the 'SynchronousSpeakTimeout' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'SyncSpeakTimeout'"

	self put_SynchronousSpeakTimeout: msTimeout
!

voice
	"Answer the <ISpeechObjectToken> value of the 'Voice' property of the receiver.
	Helpstring: 'Voice'"

	| answer |
	answer := ISpeechObjectToken newPointer.
	self get_Voice: answer.
	^answer asObject
!

volume
	"Answer the <sdword> value of the 'Volume' property of the receiver.
	Helpstring: 'Volume'"

	| answer |
	answer := (SDWORD new).
	self get_Volume: answer.
	^answer asObject
!

volume: volume
	"Set the 'Volume' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Volume'"

	self put_Volume: volume
!

waitUntilDone: msTimeout
	"Answer the <VARIANT_BOOL> result of invoking the WaitUntilDone() method of the COM object.
	Helpstring: 'WaitUntilDone'"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		WaitUntilDone: msTimeout
		Done: answer.
	^answer asObject
!

WaitUntilDone: msTimeout Done: done
	"Private - Invoke the WaitUntilDone() method of the COM object.
	Helpstring: 'WaitUntilDone'

		HRESULT __stdcall WaitUntilDone(
			[in] long msTimeout,
			[out, retval] VARIANT_BOOL* Done);"

	<virtual stdcall: hresult 36 sdword varbool*>
	^self invalidCall
! !
!ISpeechVoice categoriesFor: #alertBoundary!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #alertBoundary:!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #allowAudioOutputFormatChangesOnNextSet!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #allowAudioOutputFormatChangesOnNextSet:!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #audioOutput!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #audioOutputStream!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #displayUI:title:typeOfUI:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #displayUI:title:typeOfUI:extraData:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #DisplayUI:Title:TypeOfUI:ExtraData:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #eventInterests!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #eventInterests:!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #get_AlertBoundary:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #get_AllowAudioOutputFormatChangesOnNextSet:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #get_AudioOutput:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #get_AudioOutputStream:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #get_EventInterests:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #get_Priority:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #get_Rate:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #get_Status:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #get_SynchronousSpeakTimeout:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #get_Voice:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #get_Volume:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #getAudioOutputs!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #getAudioOutputs:optionalAttributes:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #GetAudioOutputs:OptionalAttributes:ObjectTokens:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #getVoices!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #getVoices:optionalAttributes:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #GetVoices:OptionalAttributes:ObjectTokens:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #isUISupported:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #isUISupported:extraData:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #IsUISupported:ExtraData:Supported:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #pause!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #Pause!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #priority!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #priority:!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #put_AlertBoundary:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #put_AllowAudioOutputFormatChangesOnNextSet:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #put_EventInterests:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #put_Priority:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #put_Rate:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #put_SynchronousSpeakTimeout:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #put_Volume:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #putref_AudioOutput:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #putref_AudioOutputStream:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #putref_Voice:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #rate!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #rate:!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #resume!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #Resume!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #setAudioOutput:!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #setAudioOutputStream:!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #setVoice:!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #skip:numItems:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #Skip:NumItems:NumSkipped:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #speak:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #speak:flags:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #Speak:Flags:StreamNumber:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #speakCompleteEvent!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #SpeakCompleteEvent:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #speakStream:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #speakStream:flags:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #SpeakStream:Flags:StreamNumber:!**auto generated**!COM Interfaces-ISpeechVoice!private! !
!ISpeechVoice categoriesFor: #status!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #synchronousSpeakTimeout!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #synchronousSpeakTimeout:!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #voice!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #volume!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #volume:!**auto generated**!properties!public! !
!ISpeechVoice categoriesFor: #waitUntilDone:!**auto generated**!methods!public! !
!ISpeechVoice categoriesFor: #WaitUntilDone:Done:!**auto generated**!COM Interfaces-ISpeechVoice!private! !

!ISpeechVoice class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpVoice) for which the receiver is the default interface."

	^CLSID fromString: '{96749377-3391-11D2-9EE3-00C04F797396}'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechVoice initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechVoice class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpeechVoice class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

