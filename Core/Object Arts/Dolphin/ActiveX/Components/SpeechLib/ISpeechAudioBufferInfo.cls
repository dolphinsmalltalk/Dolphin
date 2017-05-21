"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechAudioBufferInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechAudioBufferInfo guid: (IID fromString: '{11B103D8-1142-4EDF-A093-82FB3915F8CC}')!
ISpeechAudioBufferInfo comment: '<ISpeechAudioBufferInfo> is a wrapper class for the COM interface ''SpeechLib.ISpeechAudioBufferInfo'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechAudioBufferInfo Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(11B103D8-1142-4EDF-A093-82FB3915F8CC), 
	helpstring("ISpeechAudioBufferInfo Interface"), 
	dual
]
interface ISpeechAudioBufferInfo : IDispatch {
	[id(0x00000001), propget, helpstring("MinNotification")]
	HRESULT __stdcall MinNotification(
		[out, retval] long* MinNotification);
	[id(0x00000001), propput, helpstring("MinNotification")]
	HRESULT __stdcall MinNotification(
		[in] long MinNotification);
	[id(0x00000002), propget, helpstring("BufferSize")]
	HRESULT __stdcall BufferSize(
		[out, retval] long* BufferSize);
	[id(0x00000002), propput, helpstring("BufferSize")]
	HRESULT __stdcall BufferSize(
		[in] long BufferSize);
	[id(0x00000003), propget, helpstring("EventBias")]
	HRESULT __stdcall EventBias(
		[out, retval] long* EventBias);
	[id(0x00000003), propput, helpstring("EventBias")]
	HRESULT __stdcall EventBias(
		[in] long EventBias);
};
'!
!ISpeechAudioBufferInfo categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechAudioBufferInfo methodsFor!

bufferSize
	"Answer the <sdword> value of the 'BufferSize' property of the receiver.
	Helpstring: 'BufferSize'"

	| answer |
	answer := (SDWORD new).
	self get_BufferSize: answer.
	^answer asObject
!

bufferSize: bufferSize
	"Set the 'BufferSize' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'BufferSize'"

	self put_BufferSize: bufferSize
!

eventBias
	"Answer the <sdword> value of the 'EventBias' property of the receiver.
	Helpstring: 'EventBias'"

	| answer |
	answer := (SDWORD new).
	self get_EventBias: answer.
	^answer asObject
!

eventBias: eventBias
	"Set the 'EventBias' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'EventBias'"

	self put_EventBias: eventBias
!

get_BufferSize: bufferSize
	"Private - Get the value of the 'BufferSize' property of the receiver.

		HRESULT __stdcall BufferSize(
			[out, retval] long* BufferSize);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

get_EventBias: eventBias
	"Private - Get the value of the 'EventBias' property of the receiver.

		HRESULT __stdcall EventBias(
			[out, retval] long* EventBias);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall
!

get_MinNotification: minNotification
	"Private - Get the value of the 'MinNotification' property of the receiver.

		HRESULT __stdcall MinNotification(
			[out, retval] long* MinNotification);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

minNotification
	"Answer the <sdword> value of the 'MinNotification' property of the receiver.
	Helpstring: 'MinNotification'"

	| answer |
	answer := (SDWORD new).
	self get_MinNotification: answer.
	^answer asObject
!

minNotification: minNotification
	"Set the 'MinNotification' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'MinNotification'"

	self put_MinNotification: minNotification
!

put_BufferSize: bufferSize
	"Private - Set the value of the 'BufferSize' property of the object wrapped by the 
	 receiver to the <sdword> argument, bufferSize.

		HRESULT __stdcall BufferSize(
			[in] long BufferSize);"

	<virtual stdcall: hresult 11 sdword>
	^self invalidCall
!

put_EventBias: eventBias
	"Private - Set the value of the 'EventBias' property of the object wrapped by the 
	 receiver to the <sdword> argument, eventBias.

		HRESULT __stdcall EventBias(
			[in] long EventBias);"

	<virtual stdcall: hresult 13 sdword>
	^self invalidCall
!

put_MinNotification: minNotification
	"Private - Set the value of the 'MinNotification' property of the object wrapped by the 
	 receiver to the <sdword> argument, minNotification.

		HRESULT __stdcall MinNotification(
			[in] long MinNotification);"

	<virtual stdcall: hresult 9 sdword>
	^self invalidCall
! !
!ISpeechAudioBufferInfo categoriesFor: #bufferSize!**auto generated**!properties!public! !
!ISpeechAudioBufferInfo categoriesFor: #bufferSize:!**auto generated**!properties!public! !
!ISpeechAudioBufferInfo categoriesFor: #eventBias!**auto generated**!properties!public! !
!ISpeechAudioBufferInfo categoriesFor: #eventBias:!**auto generated**!properties!public! !
!ISpeechAudioBufferInfo categoriesFor: #get_BufferSize:!**auto generated**!COM Interfaces-ISpeechAudioBufferInfo!private! !
!ISpeechAudioBufferInfo categoriesFor: #get_EventBias:!**auto generated**!COM Interfaces-ISpeechAudioBufferInfo!private! !
!ISpeechAudioBufferInfo categoriesFor: #get_MinNotification:!**auto generated**!COM Interfaces-ISpeechAudioBufferInfo!private! !
!ISpeechAudioBufferInfo categoriesFor: #minNotification!**auto generated**!properties!public! !
!ISpeechAudioBufferInfo categoriesFor: #minNotification:!**auto generated**!properties!public! !
!ISpeechAudioBufferInfo categoriesFor: #put_BufferSize:!**auto generated**!COM Interfaces-ISpeechAudioBufferInfo!private! !
!ISpeechAudioBufferInfo categoriesFor: #put_EventBias:!**auto generated**!COM Interfaces-ISpeechAudioBufferInfo!private! !
!ISpeechAudioBufferInfo categoriesFor: #put_MinNotification:!**auto generated**!COM Interfaces-ISpeechAudioBufferInfo!private! !

!ISpeechAudioBufferInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechAudioBufferInfo'
		ISpeechAudioBufferInfo defineTemplate"

	self
		defineFunction: #get_MinNotification:
			argumentTypes: 'sdword*';
		defineFunction: #put_MinNotification:
			argumentTypes: 'sdword';
		defineFunction: #get_BufferSize:
			argumentTypes: 'sdword*';
		defineFunction: #put_BufferSize:
			argumentTypes: 'sdword';
		defineFunction: #get_EventBias:
			argumentTypes: 'sdword*';
		defineFunction: #put_EventBias:
			argumentTypes: 'sdword'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechAudioBufferInfo initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechAudioBufferInfo class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechAudioBufferInfo class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

