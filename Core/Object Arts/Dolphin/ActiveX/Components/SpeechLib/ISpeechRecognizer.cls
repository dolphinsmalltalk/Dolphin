"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechRecognizer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechRecognizer guid: (IID fromString: '{2D5F1C0C-BD75-4B08-9478-3B11FEA2586C}')!
ISpeechRecognizer comment: '<ISpeechRecognizer> is a wrapper class for the COM interface ''SpeechLib.ISpeechRecognizer'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechRecognizer Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2D5F1C0C-BD75-4B08-9478-3B11FEA2586C), 
	helpstring("ISpeechRecognizer Interface"), 
	dual
]
interface ISpeechRecognizer : IDispatch {
	[id(0x00000001), propputref, helpstring("Recognizer")]
	HRESULT __stdcall Recognizer(
		[in] ISpeechObjectToken* Recognizer);
	[id(0x00000001), propget, helpstring("Recognizer")]
	HRESULT __stdcall Recognizer(
		[out, retval] ISpeechObjectToken** Recognizer);
	[id(0x00000002), hidden, propput, helpstring("AllowAudioInputFormatChangesOnNextSet")]
	HRESULT __stdcall AllowAudioInputFormatChangesOnNextSet(
		[in] VARIANT_BOOL Allow);
	[id(0x00000002), hidden, propget, helpstring("AllowAudioInputFormatChangesOnNextSet")]
	HRESULT __stdcall AllowAudioInputFormatChangesOnNextSet(
		[out, retval] VARIANT_BOOL* Allow);
	[id(0x00000003), propputref, helpstring("AudioInput")]
	HRESULT __stdcall AudioInput(
		[in, defaultvalue(0)] ISpeechObjectToken* AudioInput);
	[id(0x00000003), propget, helpstring("AudioInput")]
	HRESULT __stdcall AudioInput(
		[out, retval] ISpeechObjectToken** AudioInput);
	[id(0x00000004), propputref, helpstring("AudioInputStream")]
	HRESULT __stdcall AudioInputStream(
		[in, defaultvalue(0)] ISpeechBaseStream* AudioInputStream);
	[id(0x00000004), propget, helpstring("AudioInputStream")]
	HRESULT __stdcall AudioInputStream(
		[out, retval] ISpeechBaseStream** AudioInputStream);
	[id(0x00000005), propget, helpstring("IsShared")]
	HRESULT __stdcall IsShared(
		[out, retval] VARIANT_BOOL* Shared);
	[id(0x00000006), propput, helpstring("State")]
	HRESULT __stdcall State(
		[in] SpeechRecognizerState State);
	[id(0x00000006), propget, helpstring("State")]
	HRESULT __stdcall State(
		[out, retval] SpeechRecognizerState* State);
	[id(0x00000007), propget, helpstring("Status")]
	HRESULT __stdcall Status(
		[out, retval] ISpeechRecognizerStatus** Status);
	[id(0x00000008), propputref, helpstring("Profile")]
	HRESULT __stdcall Profile(
		[in, defaultvalue(0)] ISpeechObjectToken* Profile);
	[id(0x00000008), propget, helpstring("Profile")]
	HRESULT __stdcall Profile(
		[out, retval] ISpeechObjectToken** Profile);
	[id(0x00000009), helpstring("EmulateRecognition")]
	HRESULT __stdcall EmulateRecognition(
		[in] VARIANT TextElements,
		[in, defaultvalue("")] VARIANT* ElementDisplayAttributes,
		[in, defaultvalue(0)] long LanguageId);
	[id(0x0000000a), helpstring("CreateRecoContext")]
	HRESULT __stdcall CreateRecoContext(
		[out, retval] ISpeechRecoContext** NewContext);
	[id(0x0000000b), helpstring("GetFormat")]
	HRESULT __stdcall GetFormat(
		[in] SpeechFormatType Type,
		[out, retval] ISpeechAudioFormat** Format);
	[id(0x0000000c), hidden, helpstring("SetPropertyNumber")]
	HRESULT __stdcall SetPropertyNumber(
		[in] BSTR Name,
		[in] long Value,
		[out, retval] VARIANT_BOOL* Supported);
	[id(0x0000000d), hidden, helpstring("GetPropertyNumber")]
	HRESULT __stdcall GetPropertyNumber(
		[in] BSTR Name,
		[in, out] long* Value,
		[out, retval] VARIANT_BOOL* Supported);
	[id(0x0000000e), hidden, helpstring("SetPropertyString")]
	HRESULT __stdcall SetPropertyString(
		[in] BSTR Name,
		[in] BSTR Value,
		[out, retval] VARIANT_BOOL* Supported);
	[id(0x0000000f), hidden, helpstring("GetPropertyString")]
	HRESULT __stdcall GetPropertyString(
		[in] BSTR Name,
		[in, out] BSTR* Value,
		[out, retval] VARIANT_BOOL* Supported);
	[id(0x00000010), helpstring("IsUISupported")]
	HRESULT __stdcall IsUISupported(
		[in] BSTR TypeOfUI,
		[in, defaultvalue("")] VARIANT* ExtraData,
		[out, retval] VARIANT_BOOL* Supported);
	[id(0x00000011), helpstring("DisplayUI")]
	HRESULT __stdcall DisplayUI(
		[in] long hWndParent,
		[in] BSTR Title,
		[in] BSTR TypeOfUI,
		[in, defaultvalue("")] VARIANT* ExtraData);
	[id(0x00000012), helpstring("GetRecognizers")]
	HRESULT __stdcall GetRecognizers(
		[in, defaultvalue("")] BSTR RequiredAttributes,
		[in, defaultvalue("")] BSTR OptionalAttributes,
		[out, retval] ISpeechObjectTokens** ObjectTokens);
	[id(0x00000013), helpstring("GetAudioInputs")]
	HRESULT __stdcall GetAudioInputs(
		[in, defaultvalue("")] BSTR RequiredAttributes,
		[in, defaultvalue("")] BSTR OptionalAttributes,
		[out, retval] ISpeechObjectTokens** ObjectTokens);
	[id(0x00000014), helpstring("GetProfiles")]
	HRESULT __stdcall GetProfiles(
		[in, defaultvalue("")] BSTR RequiredAttributes,
		[in, defaultvalue("")] BSTR OptionalAttributes,
		[out, retval] ISpeechObjectTokens** ObjectTokens);
};
'!
!ISpeechRecognizer categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechRecognizer methodsFor!

allowAudioInputFormatChangesOnNextSet
	"Answer the <varbool> value of the 'AllowAudioInputFormatChangesOnNextSet' property of the receiver.
	Helpstring: 'AllowAudioInputFormatChangesOnNextSet'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_AllowAudioInputFormatChangesOnNextSet: answer.
	^answer asObject
!

allowAudioInputFormatChangesOnNextSet: allow
	"Set the 'AllowAudioInputFormatChangesOnNextSet' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'AllowAudioInputFormatChangesOnNextSet'"

	self put_AllowAudioInputFormatChangesOnNextSet: allow
!

audioInput
	"Answer the <ISpeechObjectToken> value of the 'AudioInput' property of the receiver.
	Helpstring: 'AudioInput'"

	| answer |
	answer := ISpeechObjectToken newPointer.
	self get_AudioInput: answer.
	^answer asObject
!

audioInputStream
	"Answer the <ISpeechBaseStream> value of the 'AudioInputStream' property of the receiver.
	Helpstring: 'AudioInputStream'"

	| answer |
	answer := ISpeechBaseStream newPointer.
	self get_AudioInputStream: answer.
	^answer asObject
!

createRecoContext
	"Answer the <ISpeechRecoContext> result of invoking the CreateRecoContext() method of the COM object.
	Helpstring: 'CreateRecoContext'"

	| answer |
	answer := ISpeechRecoContext newPointer.
	self CreateRecoContext: answer.
	^answer asObject
!

CreateRecoContext: newContext
	"Private - Invoke the CreateRecoContext() method of the COM object.
	Helpstring: 'CreateRecoContext'

		HRESULT __stdcall CreateRecoContext(
			[out, retval] ISpeechRecoContext** NewContext);"

	<virtual stdcall: hresult 23 ISpeechRecoContext**>
	^self invalidCall
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

	<virtual stdcall: hresult 30 sdword bstr bstr variant*>
	^self invalidCall
!

emulateRecognition: textElements
	"Invoke the EmulateRecognition() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 emulateRecognition: textElements
		 elementDisplayAttributes: ''
		 languageId: 0!

emulateRecognition: textElements elementDisplayAttributes: elementDisplayAttributes languageId: languageId
	"Invoke the EmulateRecognition() method of the COM object.
	Helpstring: 'EmulateRecognition'"

	^self
		EmulateRecognition: textElements asVariant
		ElementDisplayAttributes: elementDisplayAttributes asVariant
		LanguageId: languageId
!

EmulateRecognition: textElements ElementDisplayAttributes: elementDisplayAttributes LanguageId: languageId
	"Private - Invoke the EmulateRecognition() method of the COM object.
	Helpstring: 'EmulateRecognition'

		HRESULT __stdcall EmulateRecognition(
			[in] VARIANT TextElements,
			[in, defaultvalue("")] VARIANT* ElementDisplayAttributes,
			[in, defaultvalue(0)] long LanguageId);"

	<virtual stdcall: hresult 22 variant variant* sdword>
	^self invalidCall
!

get_AllowAudioInputFormatChangesOnNextSet: allow
	"Private - Get the value of the 'AllowAudioInputFormatChangesOnNextSet' property of the receiver.

		HRESULT __stdcall AllowAudioInputFormatChangesOnNextSet(
			[out, retval] VARIANT_BOOL* Allow);"

	<virtual stdcall: hresult 11 varbool*>
	^self invalidCall
!

get_AudioInput: audioInput
	"Private - Get the value of the 'AudioInput' property of the receiver.

		HRESULT __stdcall AudioInput(
			[out, retval] ISpeechObjectToken** AudioInput);"

	<virtual stdcall: hresult 13 ISpeechObjectToken**>
	^self invalidCall
!

get_AudioInputStream: audioInputStream
	"Private - Get the value of the 'AudioInputStream' property of the receiver.

		HRESULT __stdcall AudioInputStream(
			[out, retval] ISpeechBaseStream** AudioInputStream);"

	<virtual stdcall: hresult 15 ISpeechBaseStream**>
	^self invalidCall
!

get_IsShared: shared
	"Private - Get the value of the 'IsShared' property of the receiver.

		HRESULT __stdcall IsShared(
			[out, retval] VARIANT_BOOL* Shared);"

	<virtual stdcall: hresult 16 varbool*>
	^self invalidCall
!

get_Profile: profile
	"Private - Get the value of the 'Profile' property of the receiver.

		HRESULT __stdcall Profile(
			[out, retval] ISpeechObjectToken** Profile);"

	<virtual stdcall: hresult 21 ISpeechObjectToken**>
	^self invalidCall
!

get_Recognizer: recognizer
	"Private - Get the value of the 'Recognizer' property of the receiver.

		HRESULT __stdcall Recognizer(
			[out, retval] ISpeechObjectToken** Recognizer);"

	<virtual stdcall: hresult 9 ISpeechObjectToken**>
	^self invalidCall
!

get_State: state
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval] SpeechRecognizerState* State);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall
!

get_Status: status
	"Private - Get the value of the 'Status' property of the receiver.

		HRESULT __stdcall Status(
			[out, retval] ISpeechRecognizerStatus** Status);"

	<virtual stdcall: hresult 19 ISpeechRecognizerStatus**>
	^self invalidCall
!

getAudioInputs
	"Answer the <ISpeechObjectTokens> result of invoking the GetAudioInputs() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 getAudioInputs: ''
		 optionalAttributes: ''!

getAudioInputs: requiredAttributes optionalAttributes: optionalAttributes
	"Answer the <ISpeechObjectTokens> result of invoking the GetAudioInputs() method of the COM object.
	Helpstring: 'GetAudioInputs'"

	| answer |
	answer := ISpeechObjectTokens newPointer.
	self
		GetAudioInputs: requiredAttributes
		OptionalAttributes: optionalAttributes
		ObjectTokens: answer.
	^answer asObject
!

GetAudioInputs: requiredAttributes OptionalAttributes: optionalAttributes ObjectTokens: objectTokens
	"Private - Invoke the GetAudioInputs() method of the COM object.
	Helpstring: 'GetAudioInputs'

		HRESULT __stdcall GetAudioInputs(
			[in, defaultvalue("")] BSTR RequiredAttributes,
			[in, defaultvalue("")] BSTR OptionalAttributes,
			[out, retval] ISpeechObjectTokens** ObjectTokens);"

	<virtual stdcall: hresult 32 bstr bstr ISpeechObjectTokens**>
	^self invalidCall
!

getFormat: type
	"Answer the <ISpeechAudioFormat> result of invoking the GetFormat() method of the COM object.
	Helpstring: 'GetFormat'"

	| answer |
	answer := ISpeechAudioFormat newPointer.
	self
		GetFormat: type
		Format: answer.
	^answer asObject
!

GetFormat: type Format: format
	"Private - Invoke the GetFormat() method of the COM object.
	Helpstring: 'GetFormat'

		HRESULT __stdcall GetFormat(
			[in] SpeechFormatType Type,
			[out, retval] ISpeechAudioFormat** Format);"

	<virtual stdcall: hresult 24 sdword ISpeechAudioFormat**>
	^self invalidCall
!

getProfiles
	"Answer the <ISpeechObjectTokens> result of invoking the GetProfiles() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 getProfiles: ''
		 optionalAttributes: ''!

getProfiles: requiredAttributes optionalAttributes: optionalAttributes
	"Answer the <ISpeechObjectTokens> result of invoking the GetProfiles() method of the COM object.
	Helpstring: 'GetProfiles'"

	| answer |
	answer := ISpeechObjectTokens newPointer.
	self
		GetProfiles: requiredAttributes
		OptionalAttributes: optionalAttributes
		ObjectTokens: answer.
	^answer asObject
!

GetProfiles: requiredAttributes OptionalAttributes: optionalAttributes ObjectTokens: objectTokens
	"Private - Invoke the GetProfiles() method of the COM object.
	Helpstring: 'GetProfiles'

		HRESULT __stdcall GetProfiles(
			[in, defaultvalue("")] BSTR RequiredAttributes,
			[in, defaultvalue("")] BSTR OptionalAttributes,
			[out, retval] ISpeechObjectTokens** ObjectTokens);"

	<virtual stdcall: hresult 33 bstr bstr ISpeechObjectTokens**>
	^self invalidCall
!

getPropertyNumber: name value: value
	"Invoke the GetPropertyNumber() method of the COM object.
	Helpstring: 'GetPropertyNumber'"

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (SDWORD new value: value; yourself);
				basicAt: 2 put: (VARIANT_BOOL new);
				yourself.
	self
		GetPropertyNumber: name
		Value: (answer basicAt: 1)
		Supported: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetPropertyNumber: name Value: value Supported: supported
	"Private - Invoke the GetPropertyNumber() method of the COM object.
	Helpstring: 'GetPropertyNumber'

		HRESULT __stdcall GetPropertyNumber(
			[in] BSTR Name,
			[in, out] long* Value,
			[out, retval] VARIANT_BOOL* Supported);"

	<virtual stdcall: hresult 26 bstr sdword* varbool*>
	^self invalidCall
!

getPropertyString: name value: value
	"Invoke the GetPropertyString() method of the COM object.
	Helpstring: 'GetPropertyString'"

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: value asBSTR;
				basicAt: 2 put: (VARIANT_BOOL new);
				yourself.
	self
		GetPropertyString: name
		Value: (answer basicAt: 1)
		Supported: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetPropertyString: name Value: value Supported: supported
	"Private - Invoke the GetPropertyString() method of the COM object.
	Helpstring: 'GetPropertyString'

		HRESULT __stdcall GetPropertyString(
			[in] BSTR Name,
			[in, out] BSTR* Value,
			[out, retval] VARIANT_BOOL* Supported);"

	<virtual stdcall: hresult 28 bstr bstr* varbool*>
	^self invalidCall
!

getRecognizers
	"Answer the <ISpeechObjectTokens> result of invoking the GetRecognizers() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 getRecognizers: ''
		 optionalAttributes: ''!

getRecognizers: requiredAttributes optionalAttributes: optionalAttributes
	"Answer the <ISpeechObjectTokens> result of invoking the GetRecognizers() method of the COM object.
	Helpstring: 'GetRecognizers'"

	| answer |
	answer := ISpeechObjectTokens newPointer.
	self
		GetRecognizers: requiredAttributes
		OptionalAttributes: optionalAttributes
		ObjectTokens: answer.
	^answer asObject
!

GetRecognizers: requiredAttributes OptionalAttributes: optionalAttributes ObjectTokens: objectTokens
	"Private - Invoke the GetRecognizers() method of the COM object.
	Helpstring: 'GetRecognizers'

		HRESULT __stdcall GetRecognizers(
			[in, defaultvalue("")] BSTR RequiredAttributes,
			[in, defaultvalue("")] BSTR OptionalAttributes,
			[out, retval] ISpeechObjectTokens** ObjectTokens);"

	<virtual stdcall: hresult 31 bstr bstr ISpeechObjectTokens**>
	^self invalidCall
!

isShared
	"Answer the <varbool> value of the 'IsShared' property of the receiver.
	Helpstring: 'IsShared'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_IsShared: answer.
	^answer asObject
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

	<virtual stdcall: hresult 29 bstr variant* varbool*>
	^self invalidCall
!

profile
	"Answer the <ISpeechObjectToken> value of the 'Profile' property of the receiver.
	Helpstring: 'Profile'"

	| answer |
	answer := ISpeechObjectToken newPointer.
	self get_Profile: answer.
	^answer asObject
!

put_AllowAudioInputFormatChangesOnNextSet: allow
	"Private - Set the value of the 'AllowAudioInputFormatChangesOnNextSet' property of the object wrapped by the 
	 receiver to the <varbool> argument, allow.

		HRESULT __stdcall AllowAudioInputFormatChangesOnNextSet(
			[in] VARIANT_BOOL Allow);"

	<virtual stdcall: hresult 10 varbool>
	^self invalidCall
!

put_State: state
	"Private - Set the value of the 'State' property of the object wrapped by the 
	 receiver to the <sdword> argument, state.

		HRESULT __stdcall State(
			[in] SpeechRecognizerState State);"

	<virtual stdcall: hresult 17 sdword>
	^self invalidCall
!

putref_AudioInput: audioInput
	"Private - Set the value of the 'AudioInput' property of the object wrapped by the 
	 receiver to the <ISpeechObjectToken*> argument, audioInput.

		HRESULT __stdcall AudioInput(
			[in, defaultvalue(0)] ISpeechObjectToken* AudioInput);"

	<virtual stdcall: hresult 12 ISpeechObjectToken*>
	^self invalidCall
!

putref_AudioInputStream: audioInputStream
	"Private - Set the value of the 'AudioInputStream' property of the object wrapped by the 
	 receiver to the <ISpeechBaseStream*> argument, audioInputStream.

		HRESULT __stdcall AudioInputStream(
			[in, defaultvalue(0)] ISpeechBaseStream* AudioInputStream);"

	<virtual stdcall: hresult 14 ISpeechBaseStream*>
	^self invalidCall
!

putref_Profile: profile
	"Private - Set the value of the 'Profile' property of the object wrapped by the 
	 receiver to the <ISpeechObjectToken*> argument, profile.

		HRESULT __stdcall Profile(
			[in, defaultvalue(0)] ISpeechObjectToken* Profile);"

	<virtual stdcall: hresult 20 ISpeechObjectToken*>
	^self invalidCall
!

putref_Recognizer: recognizer
	"Private - Set the value of the 'Recognizer' property of the object wrapped by the 
	 receiver to the <ISpeechObjectToken*> argument, recognizer.

		HRESULT __stdcall Recognizer(
			[in] ISpeechObjectToken* Recognizer);"

	<virtual stdcall: hresult 8 ISpeechObjectToken*>
	^self invalidCall
!

recognizer
	"Answer the <ISpeechObjectToken> value of the 'Recognizer' property of the receiver.
	Helpstring: 'Recognizer'"

	| answer |
	answer := ISpeechObjectToken newPointer.
	self get_Recognizer: answer.
	^answer asObject
!

setAudioInput: audioInput
	"Set the 'AudioInput' property of the receiver to the <ISpeechObjectToken*> value of the argument.
	Helpstring: 'AudioInput'"

	self putref_AudioInput: audioInput
!

setAudioInputStream: audioInputStream
	"Set the 'AudioInputStream' property of the receiver to the <ISpeechBaseStream*> value of the argument.
	Helpstring: 'AudioInputStream'"

	self putref_AudioInputStream: audioInputStream
!

setProfile: profile
	"Set the 'Profile' property of the receiver to the <ISpeechObjectToken*> value of the argument.
	Helpstring: 'Profile'"

	self putref_Profile: profile
!

setPropertyNumber: name value: value
	"Answer the <VARIANT_BOOL> result of invoking the SetPropertyNumber() method of the COM object.
	Helpstring: 'SetPropertyNumber'"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		SetPropertyNumber: name
		Value: value
		Supported: answer.
	^answer asObject
!

SetPropertyNumber: name Value: value Supported: supported
	"Private - Invoke the SetPropertyNumber() method of the COM object.
	Helpstring: 'SetPropertyNumber'

		HRESULT __stdcall SetPropertyNumber(
			[in] BSTR Name,
			[in] long Value,
			[out, retval] VARIANT_BOOL* Supported);"

	<virtual stdcall: hresult 25 bstr sdword varbool*>
	^self invalidCall
!

setPropertyString: name value: value
	"Answer the <VARIANT_BOOL> result of invoking the SetPropertyString() method of the COM object.
	Helpstring: 'SetPropertyString'"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		SetPropertyString: name
		Value: value
		Supported: answer.
	^answer asObject
!

SetPropertyString: name Value: value Supported: supported
	"Private - Invoke the SetPropertyString() method of the COM object.
	Helpstring: 'SetPropertyString'

		HRESULT __stdcall SetPropertyString(
			[in] BSTR Name,
			[in] BSTR Value,
			[out, retval] VARIANT_BOOL* Supported);"

	<virtual stdcall: hresult 27 bstr bstr varbool*>
	^self invalidCall
!

setRecognizer: recognizer
	"Set the 'Recognizer' property of the receiver to the <ISpeechObjectToken*> value of the argument.
	Helpstring: 'Recognizer'"

	self putref_Recognizer: recognizer
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

status
	"Answer the <ISpeechRecognizerStatus> value of the 'Status' property of the receiver.
	Helpstring: 'Status'"

	| answer |
	answer := ISpeechRecognizerStatus newPointer.
	self get_Status: answer.
	^answer asObject
! !
!ISpeechRecognizer categoriesFor: #allowAudioInputFormatChangesOnNextSet!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #allowAudioInputFormatChangesOnNextSet:!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #audioInput!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #audioInputStream!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #createRecoContext!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #CreateRecoContext:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #displayUI:title:typeOfUI:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #displayUI:title:typeOfUI:extraData:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #DisplayUI:Title:TypeOfUI:ExtraData:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #emulateRecognition:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #emulateRecognition:elementDisplayAttributes:languageId:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #EmulateRecognition:ElementDisplayAttributes:LanguageId:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #get_AllowAudioInputFormatChangesOnNextSet:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #get_AudioInput:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #get_AudioInputStream:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #get_IsShared:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #get_Profile:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #get_Recognizer:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #get_State:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #get_Status:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #getAudioInputs!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #getAudioInputs:optionalAttributes:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #GetAudioInputs:OptionalAttributes:ObjectTokens:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #getFormat:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #GetFormat:Format:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #getProfiles!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #getProfiles:optionalAttributes:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #GetProfiles:OptionalAttributes:ObjectTokens:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #getPropertyNumber:value:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #GetPropertyNumber:Value:Supported:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #getPropertyString:value:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #GetPropertyString:Value:Supported:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #getRecognizers!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #getRecognizers:optionalAttributes:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #GetRecognizers:OptionalAttributes:ObjectTokens:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #isShared!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #isUISupported:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #isUISupported:extraData:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #IsUISupported:ExtraData:Supported:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #profile!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #put_AllowAudioInputFormatChangesOnNextSet:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #put_State:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #putref_AudioInput:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #putref_AudioInputStream:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #putref_Profile:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #putref_Recognizer:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #recognizer!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #setAudioInput:!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #setAudioInputStream:!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #setProfile:!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #setPropertyNumber:value:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #SetPropertyNumber:Value:Supported:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #setPropertyString:value:!**auto generated**!methods!public! !
!ISpeechRecognizer categoriesFor: #SetPropertyString:Value:Supported:!**auto generated**!COM Interfaces-ISpeechRecognizer!private! !
!ISpeechRecognizer categoriesFor: #setRecognizer:!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #state!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #state:!**auto generated**!properties!public! !
!ISpeechRecognizer categoriesFor: #status!**auto generated**!properties!public! !

!ISpeechRecognizer class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechRecognizer'
		ISpeechRecognizer defineTemplate"

	self
		defineFunction: #putref_Recognizer:
			argumentTypes: 'ISpeechObjectToken*';
		defineFunction: #get_Recognizer:
			argumentTypes: 'ISpeechObjectToken**';
		defineFunction: #put_AllowAudioInputFormatChangesOnNextSet:
			argumentTypes: 'varbool';
		defineFunction: #get_AllowAudioInputFormatChangesOnNextSet:
			argumentTypes: 'varbool*';
		defineFunction: #putref_AudioInput:
			argumentTypes: 'ISpeechObjectToken*';
		defineFunction: #get_AudioInput:
			argumentTypes: 'ISpeechObjectToken**';
		defineFunction: #putref_AudioInputStream:
			argumentTypes: 'ISpeechBaseStream*';
		defineFunction: #get_AudioInputStream:
			argumentTypes: 'ISpeechBaseStream**';
		defineFunction: #get_IsShared:
			argumentTypes: 'varbool*';
		defineFunction: #put_State:
			argumentTypes: 'sdword';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #get_Status:
			argumentTypes: 'ISpeechRecognizerStatus**';
		defineFunction: #putref_Profile:
			argumentTypes: 'ISpeechObjectToken*';
		defineFunction: #get_Profile:
			argumentTypes: 'ISpeechObjectToken**';
		defineFunction: #EmulateRecognition:ElementDisplayAttributes:LanguageId:
			argumentTypes: 'variant variant* sdword';
		defineFunction: #CreateRecoContext:
			argumentTypes: 'ISpeechRecoContext**';
		defineFunction: #GetFormat:Format:
			argumentTypes: 'sdword ISpeechAudioFormat**';
		defineFunction: #SetPropertyNumber:Value:Supported:
			argumentTypes: 'bstr sdword varbool*';
		defineFunction: #GetPropertyNumber:Value:Supported:
			argumentTypes: 'bstr sdword* varbool*';
		defineFunction: #SetPropertyString:Value:Supported:
			argumentTypes: 'bstr bstr varbool*';
		defineFunction: #GetPropertyString:Value:Supported:
			argumentTypes: 'bstr bstr* varbool*';
		defineFunction: #IsUISupported:ExtraData:Supported:
			argumentTypes: 'bstr variant* varbool*';
		defineFunction: #DisplayUI:Title:TypeOfUI:ExtraData:
			argumentTypes: 'sdword bstr bstr variant*';
		defineFunction: #GetRecognizers:OptionalAttributes:ObjectTokens:
			argumentTypes: 'bstr bstr ISpeechObjectTokens**';
		defineFunction: #GetAudioInputs:OptionalAttributes:ObjectTokens:
			argumentTypes: 'bstr bstr ISpeechObjectTokens**';
		defineFunction: #GetProfiles:OptionalAttributes:ObjectTokens:
			argumentTypes: 'bstr bstr ISpeechObjectTokens**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechRecognizer initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechRecognizer class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechRecognizer class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

