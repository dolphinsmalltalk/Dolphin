"Filed out from Dolphin Smalltalk 7"!

ISpeechBaseStream subclass: #ISpeechAudio
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechAudio guid: (IID fromString: '{CFF8E175-019E-11D3-A08E-00C04F8EF9B5}')!
ISpeechAudio comment: '<ISpeechAudio> is a wrapper class for the COM interface ''SpeechLib.ISpeechAudio'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechAudio Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(CFF8E175-019E-11D3-A08E-00C04F8EF9B5), 
	helpstring("ISpeechAudio Interface"), 
	dual
]
interface ISpeechAudio : ISpeechBaseStream {
	[id(0x000000c8), propget, helpstring("Status")]
	HRESULT __stdcall Status(
		[out, retval] ISpeechAudioStatus** Status);
	[id(0x000000c9), propget, helpstring("BufferInfo")]
	HRESULT __stdcall BufferInfo(
		[out, retval] ISpeechAudioBufferInfo** BufferInfo);
	[id(0x000000ca), propget, helpstring("DefaultFormat")]
	HRESULT __stdcall DefaultFormat(
		[out, retval] ISpeechAudioFormat** StreamFormat);
	[id(0x000000cb), propget, helpstring("Volume")]
	HRESULT __stdcall Volume(
		[out, retval] long* Volume);
	[id(0x000000cb), propput, helpstring("Volume")]
	HRESULT __stdcall Volume(
		[in] long Volume);
	[id(0x000000cc), propget, helpstring("BufferNotifySize")]
	HRESULT __stdcall BufferNotifySize(
		[out, retval] long* BufferNotifySize);
	[id(0x000000cc), propput, helpstring("BufferNotifySize")]
	HRESULT __stdcall BufferNotifySize(
		[in] long BufferNotifySize);
	[id(0x000000cd), hidden, propget, helpstring("EventHandle")]
	HRESULT __stdcall EventHandle(
		[out, retval] long* EventHandle);
	[id(0x000000ce), hidden, helpstring("SetState")]
	HRESULT __stdcall SetState(
		[in] SpeechAudioState State);
};
'!
!ISpeechAudio categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechAudio methodsFor!

bufferInfo
	"Answer the <ISpeechAudioBufferInfo> value of the 'BufferInfo' property of the receiver.
	Helpstring: 'BufferInfo'"

	| answer |
	answer := ISpeechAudioBufferInfo newPointer.
	self get_BufferInfo: answer.
	^answer asObject
!

bufferNotifySize
	"Answer the <sdword> value of the 'BufferNotifySize' property of the receiver.
	Helpstring: 'BufferNotifySize'"

	| answer |
	answer := (SDWORD new).
	self get_BufferNotifySize: answer.
	^answer asObject
!

bufferNotifySize: bufferNotifySize
	"Set the 'BufferNotifySize' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'BufferNotifySize'"

	self put_BufferNotifySize: bufferNotifySize
!

defaultFormat
	"Answer the <ISpeechAudioFormat> value of the 'DefaultFormat' property of the receiver.
	Helpstring: 'DefaultFormat'"

	| answer |
	answer := ISpeechAudioFormat newPointer.
	self get_DefaultFormat: answer.
	^answer asObject
!

eventHandle
	"Answer the <sdword> value of the 'EventHandle' property of the receiver.
	Helpstring: 'EventHandle'"

	| answer |
	answer := (SDWORD new).
	self get_EventHandle: answer.
	^answer asObject
!

get_BufferInfo: bufferInfo
	"Private - Get the value of the 'BufferInfo' property of the receiver.

		HRESULT __stdcall BufferInfo(
			[out, retval] ISpeechAudioBufferInfo** BufferInfo);"

	<virtual stdcall: hresult 14 ISpeechAudioBufferInfo**>
	^self invalidCall
!

get_BufferNotifySize: bufferNotifySize
	"Private - Get the value of the 'BufferNotifySize' property of the receiver.

		HRESULT __stdcall BufferNotifySize(
			[out, retval] long* BufferNotifySize);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall
!

get_DefaultFormat: streamFormat
	"Private - Get the value of the 'DefaultFormat' property of the receiver.

		HRESULT __stdcall DefaultFormat(
			[out, retval] ISpeechAudioFormat** StreamFormat);"

	<virtual stdcall: hresult 15 ISpeechAudioFormat**>
	^self invalidCall
!

get_EventHandle: eventHandle
	"Private - Get the value of the 'EventHandle' property of the receiver.

		HRESULT __stdcall EventHandle(
			[out, retval] long* EventHandle);"

	<virtual stdcall: hresult 20 sdword*>
	^self invalidCall
!

get_Status: status
	"Private - Get the value of the 'Status' property of the receiver.

		HRESULT __stdcall Status(
			[out, retval] ISpeechAudioStatus** Status);"

	<virtual stdcall: hresult 13 ISpeechAudioStatus**>
	^self invalidCall
!

get_Volume: volume
	"Private - Get the value of the 'Volume' property of the receiver.

		HRESULT __stdcall Volume(
			[out, retval] long* Volume);"

	<virtual stdcall: hresult 16 sdword*>
	^self invalidCall
!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^true!

isVBCollection
	"Answer whether the receiver is a VB style collection.
	The receiver is dynamically extensible, so we cannot determine this from the
	type library, and must perform a run-time check for the _NewEnum property."

	^self has_NewEnum!

put_BufferNotifySize: bufferNotifySize
	"Private - Set the value of the 'BufferNotifySize' property of the object wrapped by the 
	 receiver to the <sdword> argument, bufferNotifySize.

		HRESULT __stdcall BufferNotifySize(
			[in] long BufferNotifySize);"

	<virtual stdcall: hresult 19 sdword>
	^self invalidCall
!

put_Volume: volume
	"Private - Set the value of the 'Volume' property of the object wrapped by the 
	 receiver to the <sdword> argument, volume.

		HRESULT __stdcall Volume(
			[in] long Volume);"

	<virtual stdcall: hresult 17 sdword>
	^self invalidCall
!

setState: state
	"Invoke the SetState() method of the COM object.
	Helpstring: 'SetState'"

	^self SetState: state
!

SetState: state
	"Private - Invoke the SetState() method of the COM object.
	Helpstring: 'SetState'

		HRESULT __stdcall SetState(
			[in] SpeechAudioState State);"

	<virtual stdcall: hresult 21 sdword>
	^self invalidCall
!

status
	"Answer the <ISpeechAudioStatus> value of the 'Status' property of the receiver.
	Helpstring: 'Status'"

	| answer |
	answer := ISpeechAudioStatus newPointer.
	self get_Status: answer.
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
! !
!ISpeechAudio categoriesFor: #bufferInfo!**auto generated**!properties!public! !
!ISpeechAudio categoriesFor: #bufferNotifySize!**auto generated**!properties!public! !
!ISpeechAudio categoriesFor: #bufferNotifySize:!**auto generated**!properties!public! !
!ISpeechAudio categoriesFor: #defaultFormat!**auto generated**!properties!public! !
!ISpeechAudio categoriesFor: #eventHandle!**auto generated**!properties!public! !
!ISpeechAudio categoriesFor: #get_BufferInfo:!**auto generated**!COM Interfaces-ISpeechAudio!private! !
!ISpeechAudio categoriesFor: #get_BufferNotifySize:!**auto generated**!COM Interfaces-ISpeechAudio!private! !
!ISpeechAudio categoriesFor: #get_DefaultFormat:!**auto generated**!COM Interfaces-ISpeechAudio!private! !
!ISpeechAudio categoriesFor: #get_EventHandle:!**auto generated**!COM Interfaces-ISpeechAudio!private! !
!ISpeechAudio categoriesFor: #get_Status:!**auto generated**!COM Interfaces-ISpeechAudio!private! !
!ISpeechAudio categoriesFor: #get_Volume:!**auto generated**!COM Interfaces-ISpeechAudio!private! !
!ISpeechAudio categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ISpeechAudio categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechAudio categoriesFor: #put_BufferNotifySize:!**auto generated**!COM Interfaces-ISpeechAudio!private! !
!ISpeechAudio categoriesFor: #put_Volume:!**auto generated**!COM Interfaces-ISpeechAudio!private! !
!ISpeechAudio categoriesFor: #setState:!**auto generated**!methods!public! !
!ISpeechAudio categoriesFor: #SetState:!**auto generated**!COM Interfaces-ISpeechAudio!private! !
!ISpeechAudio categoriesFor: #status!**auto generated**!properties!public! !
!ISpeechAudio categoriesFor: #volume!**auto generated**!properties!public! !
!ISpeechAudio categoriesFor: #volume:!**auto generated**!properties!public! !

!ISpeechAudio class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechAudio'
		ISpeechAudio defineTemplate"

	self
		defineFunction: #get_Status:
			argumentTypes: 'ISpeechAudioStatus**';
		defineFunction: #get_BufferInfo:
			argumentTypes: 'ISpeechAudioBufferInfo**';
		defineFunction: #get_DefaultFormat:
			argumentTypes: 'ISpeechAudioFormat**';
		defineFunction: #get_Volume:
			argumentTypes: 'sdword*';
		defineFunction: #put_Volume:
			argumentTypes: 'sdword';
		defineFunction: #get_BufferNotifySize:
			argumentTypes: 'sdword*';
		defineFunction: #put_BufferNotifySize:
			argumentTypes: 'sdword';
		defineFunction: #get_EventHandle:
			argumentTypes: 'sdword*';
		defineFunction: #SetState:
			argumentTypes: 'sdword'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechAudio initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechAudio class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechAudio class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

