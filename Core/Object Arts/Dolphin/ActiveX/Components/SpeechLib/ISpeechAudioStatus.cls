"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechAudioStatus
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechAudioStatus guid: (IID fromString: '{C62D9C91-7458-47F6-862D-1EF86FB0B278}')!
ISpeechAudioStatus comment: '<ISpeechAudioStatus> is a wrapper class for the COM interface ''SpeechLib.ISpeechAudioStatus'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechAudioStatus Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(C62D9C91-7458-47F6-862D-1EF86FB0B278), 
	helpstring("ISpeechAudioStatus Interface"), 
	dual
]
interface ISpeechAudioStatus : IDispatch {
	[id(0x00000001), propget, helpstring("FreeBufferSpace")]
	HRESULT __stdcall FreeBufferSpace(
		[out, retval] long* FreeBufferSpace);
	[id(0x00000002), propget, helpstring("NonBlockingIO")]
	HRESULT __stdcall NonBlockingIO(
		[out, retval] long* NonBlockingIO);
	[id(0x00000003), propget, helpstring("State")]
	HRESULT __stdcall State(
		[out, retval] SpeechAudioState* State);
	[id(0x00000004), propget, helpstring("CurrentSeekPosition")]
	HRESULT __stdcall CurrentSeekPosition(
		[out, retval] VARIANT* CurrentSeekPosition);
	[id(0x00000005), propget, helpstring("CurrentDevicePosition")]
	HRESULT __stdcall CurrentDevicePosition(
		[out, retval] VARIANT* CurrentDevicePosition);
};
'!
!ISpeechAudioStatus categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechAudioStatus methodsFor!

currentDevicePosition
	"Answer the <variant> value of the 'CurrentDevicePosition' property of the receiver.
	Helpstring: 'CurrentDevicePosition'"

	| answer |
	answer := VARIANT new.
	self get_CurrentDevicePosition: answer.
	^answer asObject
!

currentSeekPosition
	"Answer the <variant> value of the 'CurrentSeekPosition' property of the receiver.
	Helpstring: 'CurrentSeekPosition'"

	| answer |
	answer := VARIANT new.
	self get_CurrentSeekPosition: answer.
	^answer asObject
!

freeBufferSpace
	"Answer the <sdword> value of the 'FreeBufferSpace' property of the receiver.
	Helpstring: 'FreeBufferSpace'"

	| answer |
	answer := (SDWORD new).
	self get_FreeBufferSpace: answer.
	^answer asObject
!

get_CurrentDevicePosition: currentDevicePosition
	"Private - Get the value of the 'CurrentDevicePosition' property of the receiver.

		HRESULT __stdcall CurrentDevicePosition(
			[out, retval] VARIANT* CurrentDevicePosition);"

	<virtual stdcall: hresult 12 variant*>
	^self invalidCall
!

get_CurrentSeekPosition: currentSeekPosition
	"Private - Get the value of the 'CurrentSeekPosition' property of the receiver.

		HRESULT __stdcall CurrentSeekPosition(
			[out, retval] VARIANT* CurrentSeekPosition);"

	<virtual stdcall: hresult 11 variant*>
	^self invalidCall
!

get_FreeBufferSpace: freeBufferSpace
	"Private - Get the value of the 'FreeBufferSpace' property of the receiver.

		HRESULT __stdcall FreeBufferSpace(
			[out, retval] long* FreeBufferSpace);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_NonBlockingIO: nonBlockingIO
	"Private - Get the value of the 'NonBlockingIO' property of the receiver.

		HRESULT __stdcall NonBlockingIO(
			[out, retval] long* NonBlockingIO);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

get_State: state
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval] SpeechAudioState* State);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

nonBlockingIO
	"Answer the <sdword> value of the 'NonBlockingIO' property of the receiver.
	Helpstring: 'NonBlockingIO'"

	| answer |
	answer := (SDWORD new).
	self get_NonBlockingIO: answer.
	^answer asObject
!

state
	"Answer the <sdword> value of the 'State' property of the receiver.
	Helpstring: 'State'"

	| answer |
	answer := (SDWORD new).
	self get_State: answer.
	^answer asObject
! !
!ISpeechAudioStatus categoriesFor: #currentDevicePosition!**auto generated**!properties!public! !
!ISpeechAudioStatus categoriesFor: #currentSeekPosition!**auto generated**!properties!public! !
!ISpeechAudioStatus categoriesFor: #freeBufferSpace!**auto generated**!properties!public! !
!ISpeechAudioStatus categoriesFor: #get_CurrentDevicePosition:!**auto generated**!COM Interfaces-ISpeechAudioStatus!private! !
!ISpeechAudioStatus categoriesFor: #get_CurrentSeekPosition:!**auto generated**!COM Interfaces-ISpeechAudioStatus!private! !
!ISpeechAudioStatus categoriesFor: #get_FreeBufferSpace:!**auto generated**!COM Interfaces-ISpeechAudioStatus!private! !
!ISpeechAudioStatus categoriesFor: #get_NonBlockingIO:!**auto generated**!COM Interfaces-ISpeechAudioStatus!private! !
!ISpeechAudioStatus categoriesFor: #get_State:!**auto generated**!COM Interfaces-ISpeechAudioStatus!private! !
!ISpeechAudioStatus categoriesFor: #nonBlockingIO!**auto generated**!properties!public! !
!ISpeechAudioStatus categoriesFor: #state!**auto generated**!properties!public! !

!ISpeechAudioStatus class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechAudioStatus'
		ISpeechAudioStatus defineTemplate"

	self
		defineFunction: #get_FreeBufferSpace:
			argumentTypes: 'sdword*';
		defineFunction: #get_NonBlockingIO:
			argumentTypes: 'sdword*';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #get_CurrentSeekPosition:
			argumentTypes: 'variant*';
		defineFunction: #get_CurrentDevicePosition:
			argumentTypes: 'variant*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechAudioStatus initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechAudioStatus class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechAudioStatus class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

