"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechVoiceStatus
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechVoiceStatus guid: (IID fromString: '{8BE47B07-57F6-11D2-9EEE-00C04F797396}')!
ISpeechVoiceStatus comment: '<ISpeechVoiceStatus> is a wrapper class for the COM interface ''SpeechLib.ISpeechVoiceStatus'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechVoiceStatus Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(8BE47B07-57F6-11D2-9EEE-00C04F797396), 
	helpstring("ISpeechVoiceStatus Interface"), 
	dual
]
interface ISpeechVoiceStatus : IDispatch {
	[id(0x00000001), propget, helpstring("CurrentStreamNumber")]
	HRESULT __stdcall CurrentStreamNumber(
		[out, retval] long* StreamNumber);
	[id(0x00000002), propget, helpstring("LastStreamNumberQueued")]
	HRESULT __stdcall LastStreamNumberQueued(
		[out, retval] long* StreamNumber);
	[id(0x00000003), propget, helpstring("LastHResult")]
	HRESULT __stdcall LastHResult(
		[out, retval] long* HResult);
	[id(0x00000004), propget, helpstring("RunningState")]
	HRESULT __stdcall RunningState(
		[out, retval] SpeechRunState* State);
	[id(0x00000005), propget, helpstring("InputWordPosition")]
	HRESULT __stdcall InputWordPosition(
		[out, retval] long* Position);
	[id(0x00000006), propget, helpstring("InputWordLength")]
	HRESULT __stdcall InputWordLength(
		[out, retval] long* Length);
	[id(0x00000007), propget, helpstring("InputSentencePosition")]
	HRESULT __stdcall InputSentencePosition(
		[out, retval] long* Position);
	[id(0x00000008), propget, helpstring("InputSentenceLength")]
	HRESULT __stdcall InputSentenceLength(
		[out, retval] long* Length);
	[id(0x00000009), propget, helpstring("LastBookmark")]
	HRESULT __stdcall LastBookmark(
		[out, retval] BSTR* Bookmark);
	[id(0x0000000a), hidden, propget, helpstring("LastBookmarkId")]
	HRESULT __stdcall LastBookmarkId(
		[out, retval] long* BookmarkId);
	[id(0x0000000b), propget, helpstring("PhonemeId")]
	HRESULT __stdcall PhonemeId(
		[out, retval] short* PhoneId);
	[id(0x0000000c), propget, helpstring("VisemeId")]
	HRESULT __stdcall VisemeId(
		[out, retval] short* VisemeId);
};
'!
!ISpeechVoiceStatus categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechVoiceStatus methodsFor!

currentStreamNumber
	"Answer the <sdword> value of the 'CurrentStreamNumber' property of the receiver.
	Helpstring: 'CurrentStreamNumber'"

	| answer |
	answer := (SDWORD new).
	self get_CurrentStreamNumber: answer.
	^answer asObject
!

get_CurrentStreamNumber: streamNumber
	"Private - Get the value of the 'CurrentStreamNumber' property of the receiver.

		HRESULT __stdcall CurrentStreamNumber(
			[out, retval] long* StreamNumber);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_InputSentenceLength: length
	"Private - Get the value of the 'InputSentenceLength' property of the receiver.

		HRESULT __stdcall InputSentenceLength(
			[out, retval] long* Length);"

	<virtual stdcall: hresult 15 sdword*>
	^self invalidCall
!

get_InputSentencePosition: position
	"Private - Get the value of the 'InputSentencePosition' property of the receiver.

		HRESULT __stdcall InputSentencePosition(
			[out, retval] long* Position);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall
!

get_InputWordLength: length
	"Private - Get the value of the 'InputWordLength' property of the receiver.

		HRESULT __stdcall InputWordLength(
			[out, retval] long* Length);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall
!

get_InputWordPosition: position
	"Private - Get the value of the 'InputWordPosition' property of the receiver.

		HRESULT __stdcall InputWordPosition(
			[out, retval] long* Position);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall
!

get_LastBookmark: bookmark
	"Private - Get the value of the 'LastBookmark' property of the receiver.

		HRESULT __stdcall LastBookmark(
			[out, retval] BSTR* Bookmark);"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall
!

get_LastBookmarkId: bookmarkId
	"Private - Get the value of the 'LastBookmarkId' property of the receiver.

		HRESULT __stdcall LastBookmarkId(
			[out, retval] long* BookmarkId);"

	<virtual stdcall: hresult 17 sdword*>
	^self invalidCall
!

get_LastHResult: hResult
	"Private - Get the value of the 'LastHResult' property of the receiver.

		HRESULT __stdcall LastHResult(
			[out, retval] long* HResult);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

get_LastStreamNumberQueued: streamNumber
	"Private - Get the value of the 'LastStreamNumberQueued' property of the receiver.

		HRESULT __stdcall LastStreamNumberQueued(
			[out, retval] long* StreamNumber);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

get_PhonemeId: phoneId
	"Private - Get the value of the 'PhonemeId' property of the receiver.

		HRESULT __stdcall PhonemeId(
			[out, retval] short* PhoneId);"

	<virtual stdcall: hresult 18 sword*>
	^self invalidCall
!

get_RunningState: state
	"Private - Get the value of the 'RunningState' property of the receiver.

		HRESULT __stdcall RunningState(
			[out, retval] SpeechRunState* State);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall
!

get_VisemeId: visemeId
	"Private - Get the value of the 'VisemeId' property of the receiver.

		HRESULT __stdcall VisemeId(
			[out, retval] short* VisemeId);"

	<virtual stdcall: hresult 19 sword*>
	^self invalidCall
!

inputSentenceLength
	"Answer the <sdword> value of the 'InputSentenceLength' property of the receiver.
	Helpstring: 'InputSentenceLength'"

	| answer |
	answer := (SDWORD new).
	self get_InputSentenceLength: answer.
	^answer asObject
!

inputSentencePosition
	"Answer the <sdword> value of the 'InputSentencePosition' property of the receiver.
	Helpstring: 'InputSentencePosition'"

	| answer |
	answer := (SDWORD new).
	self get_InputSentencePosition: answer.
	^answer asObject
!

inputWordLength
	"Answer the <sdword> value of the 'InputWordLength' property of the receiver.
	Helpstring: 'InputWordLength'"

	| answer |
	answer := (SDWORD new).
	self get_InputWordLength: answer.
	^answer asObject
!

inputWordPosition
	"Answer the <sdword> value of the 'InputWordPosition' property of the receiver.
	Helpstring: 'InputWordPosition'"

	| answer |
	answer := (SDWORD new).
	self get_InputWordPosition: answer.
	^answer asObject
!

lastBookmark
	"Answer the <bstr> value of the 'LastBookmark' property of the receiver.
	Helpstring: 'LastBookmark'"

	| answer |
	answer := BSTR new.
	self get_LastBookmark: answer.
	^answer asObject
!

lastBookmarkId
	"Answer the <sdword> value of the 'LastBookmarkId' property of the receiver.
	Helpstring: 'LastBookmarkId'"

	| answer |
	answer := (SDWORD new).
	self get_LastBookmarkId: answer.
	^answer asObject
!

lastHResult
	"Answer the <sdword> value of the 'LastHResult' property of the receiver.
	Helpstring: 'LastHResult'"

	| answer |
	answer := (SDWORD new).
	self get_LastHResult: answer.
	^answer asObject
!

lastStreamNumberQueued
	"Answer the <sdword> value of the 'LastStreamNumberQueued' property of the receiver.
	Helpstring: 'LastStreamNumberQueued'"

	| answer |
	answer := (SDWORD new).
	self get_LastStreamNumberQueued: answer.
	^answer asObject
!

phonemeId
	"Answer the <sword> value of the 'PhonemeId' property of the receiver.
	Helpstring: 'PhonemeId'"

	| answer |
	answer := (SWORD new).
	self get_PhonemeId: answer.
	^answer asObject
!

runningState
	"Answer the <sdword> value of the 'RunningState' property of the receiver.
	Helpstring: 'RunningState'"

	| answer |
	answer := (SDWORD new).
	self get_RunningState: answer.
	^answer asObject
!

visemeId
	"Answer the <sword> value of the 'VisemeId' property of the receiver.
	Helpstring: 'VisemeId'"

	| answer |
	answer := (SWORD new).
	self get_VisemeId: answer.
	^answer asObject
! !
!ISpeechVoiceStatus categoriesFor: #currentStreamNumber!**auto generated**!properties!public! !
!ISpeechVoiceStatus categoriesFor: #get_CurrentStreamNumber:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #get_InputSentenceLength:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #get_InputSentencePosition:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #get_InputWordLength:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #get_InputWordPosition:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #get_LastBookmark:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #get_LastBookmarkId:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #get_LastHResult:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #get_LastStreamNumberQueued:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #get_PhonemeId:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #get_RunningState:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #get_VisemeId:!**auto generated**!COM Interfaces-ISpeechVoiceStatus!private! !
!ISpeechVoiceStatus categoriesFor: #inputSentenceLength!**auto generated**!properties!public! !
!ISpeechVoiceStatus categoriesFor: #inputSentencePosition!**auto generated**!properties!public! !
!ISpeechVoiceStatus categoriesFor: #inputWordLength!**auto generated**!properties!public! !
!ISpeechVoiceStatus categoriesFor: #inputWordPosition!**auto generated**!properties!public! !
!ISpeechVoiceStatus categoriesFor: #lastBookmark!**auto generated**!properties!public! !
!ISpeechVoiceStatus categoriesFor: #lastBookmarkId!**auto generated**!properties!public! !
!ISpeechVoiceStatus categoriesFor: #lastHResult!**auto generated**!properties!public! !
!ISpeechVoiceStatus categoriesFor: #lastStreamNumberQueued!**auto generated**!properties!public! !
!ISpeechVoiceStatus categoriesFor: #phonemeId!**auto generated**!properties!public! !
!ISpeechVoiceStatus categoriesFor: #runningState!**auto generated**!properties!public! !
!ISpeechVoiceStatus categoriesFor: #visemeId!**auto generated**!properties!public! !

!ISpeechVoiceStatus class methodsFor!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechVoiceStatus initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechVoiceStatus class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

