"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechRecognizerStatus
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechRecognizerStatus guid: (IID fromString: '{BFF9E781-53EC-484E-BB8A-0E1B5551E35C}')!
ISpeechRecognizerStatus comment: '<ISpeechRecognizerStatus> is a wrapper class for the COM interface ''SpeechLib.ISpeechRecognizerStatus'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechRecognizerStatus Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(BFF9E781-53EC-484E-BB8A-0E1B5551E35C), 
	helpstring("ISpeechRecognizerStatus Interface"), 
	dual
]
interface ISpeechRecognizerStatus : IDispatch {
	[id(0x00000001), propget, helpstring("AudioStatus")]
	HRESULT __stdcall AudioStatus(
		[out, retval] ISpeechAudioStatus** AudioStatus);
	[id(0x00000002), propget, helpstring("CurrentStreamPosition")]
	HRESULT __stdcall CurrentStreamPosition(
		[out, retval] VARIANT* pCurrentStreamPos);
	[id(0x00000003), propget, helpstring("CurrentStreamNumber")]
	HRESULT __stdcall CurrentStreamNumber(
		[out, retval] long* StreamNumber);
	[id(0x00000004), propget, helpstring("NumberOfActiveRules")]
	HRESULT __stdcall NumberOfActiveRules(
		[out, retval] long* NumberOfActiveRules);
	[id(0x00000005), propget, helpstring("ClsidEngine")]
	HRESULT __stdcall ClsidEngine(
		[out, retval] BSTR* ClsidEngine);
	[id(0x00000006), propget, helpstring("SupportedLanguages")]
	HRESULT __stdcall SupportedLanguages(
		[out, retval] VARIANT* SupportedLanguages);
};
'!
!ISpeechRecognizerStatus categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechRecognizerStatus methodsFor!

audioStatus
	"Answer the <ISpeechAudioStatus> value of the 'AudioStatus' property of the receiver.
	Helpstring: 'AudioStatus'"

	| answer |
	answer := ISpeechAudioStatus newPointer.
	self get_AudioStatus: answer.
	^answer asObject
!

clsidEngine
	"Answer the <bstr> value of the 'ClsidEngine' property of the receiver.
	Helpstring: 'ClsidEngine'"

	| answer |
	answer := BSTR new.
	self get_ClsidEngine: answer.
	^answer asObject
!

currentStreamNumber
	"Answer the <sdword> value of the 'CurrentStreamNumber' property of the receiver.
	Helpstring: 'CurrentStreamNumber'"

	| answer |
	answer := (SDWORD new).
	self get_CurrentStreamNumber: answer.
	^answer asObject
!

currentStreamPosition
	"Answer the <variant> value of the 'CurrentStreamPosition' property of the receiver.
	Helpstring: 'CurrentStreamPosition'"

	| answer |
	answer := VARIANT new.
	self get_CurrentStreamPosition: answer.
	^answer asObject
!

get_AudioStatus: audioStatus
	"Private - Get the value of the 'AudioStatus' property of the receiver.

		HRESULT __stdcall AudioStatus(
			[out, retval] ISpeechAudioStatus** AudioStatus);"

	<virtual stdcall: hresult 8 ISpeechAudioStatus**>
	^self invalidCall
!

get_ClsidEngine: clsidEngine
	"Private - Get the value of the 'ClsidEngine' property of the receiver.

		HRESULT __stdcall ClsidEngine(
			[out, retval] BSTR* ClsidEngine);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall
!

get_CurrentStreamNumber: streamNumber
	"Private - Get the value of the 'CurrentStreamNumber' property of the receiver.

		HRESULT __stdcall CurrentStreamNumber(
			[out, retval] long* StreamNumber);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

get_CurrentStreamPosition: pCurrentStreamPos
	"Private - Get the value of the 'CurrentStreamPosition' property of the receiver.

		HRESULT __stdcall CurrentStreamPosition(
			[out, retval] VARIANT* pCurrentStreamPos);"

	<virtual stdcall: hresult 9 variant*>
	^self invalidCall
!

get_NumberOfActiveRules: numberOfActiveRules
	"Private - Get the value of the 'NumberOfActiveRules' property of the receiver.

		HRESULT __stdcall NumberOfActiveRules(
			[out, retval] long* NumberOfActiveRules);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall
!

get_SupportedLanguages: supportedLanguages
	"Private - Get the value of the 'SupportedLanguages' property of the receiver.

		HRESULT __stdcall SupportedLanguages(
			[out, retval] VARIANT* SupportedLanguages);"

	<virtual stdcall: hresult 13 variant*>
	^self invalidCall
!

numberOfActiveRules
	"Answer the <sdword> value of the 'NumberOfActiveRules' property of the receiver.
	Helpstring: 'NumberOfActiveRules'"

	| answer |
	answer := (SDWORD new).
	self get_NumberOfActiveRules: answer.
	^answer asObject
!

supportedLanguages
	"Answer the <variant> value of the 'SupportedLanguages' property of the receiver.
	Helpstring: 'SupportedLanguages'"

	| answer |
	answer := VARIANT new.
	self get_SupportedLanguages: answer.
	^answer asObject
! !
!ISpeechRecognizerStatus categoriesFor: #audioStatus!**auto generated**!properties!public! !
!ISpeechRecognizerStatus categoriesFor: #clsidEngine!**auto generated**!properties!public! !
!ISpeechRecognizerStatus categoriesFor: #currentStreamNumber!**auto generated**!properties!public! !
!ISpeechRecognizerStatus categoriesFor: #currentStreamPosition!**auto generated**!properties!public! !
!ISpeechRecognizerStatus categoriesFor: #get_AudioStatus:!**auto generated**!COM Interfaces-ISpeechRecognizerStatus!private! !
!ISpeechRecognizerStatus categoriesFor: #get_ClsidEngine:!**auto generated**!COM Interfaces-ISpeechRecognizerStatus!private! !
!ISpeechRecognizerStatus categoriesFor: #get_CurrentStreamNumber:!**auto generated**!COM Interfaces-ISpeechRecognizerStatus!private! !
!ISpeechRecognizerStatus categoriesFor: #get_CurrentStreamPosition:!**auto generated**!COM Interfaces-ISpeechRecognizerStatus!private! !
!ISpeechRecognizerStatus categoriesFor: #get_NumberOfActiveRules:!**auto generated**!COM Interfaces-ISpeechRecognizerStatus!private! !
!ISpeechRecognizerStatus categoriesFor: #get_SupportedLanguages:!**auto generated**!COM Interfaces-ISpeechRecognizerStatus!private! !
!ISpeechRecognizerStatus categoriesFor: #numberOfActiveRules!**auto generated**!properties!public! !
!ISpeechRecognizerStatus categoriesFor: #supportedLanguages!**auto generated**!properties!public! !

!ISpeechRecognizerStatus class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechRecognizerStatus'
		ISpeechRecognizerStatus defineTemplate"

	self
		defineFunction: #get_AudioStatus:
			argumentTypes: 'ISpeechAudioStatus**';
		defineFunction: #get_CurrentStreamPosition:
			argumentTypes: 'variant*';
		defineFunction: #get_CurrentStreamNumber:
			argumentTypes: 'sdword*';
		defineFunction: #get_NumberOfActiveRules:
			argumentTypes: 'sdword*';
		defineFunction: #get_ClsidEngine:
			argumentTypes: 'bstr*';
		defineFunction: #get_SupportedLanguages:
			argumentTypes: 'variant*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechRecognizerStatus initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechRecognizerStatus class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechRecognizerStatus class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

