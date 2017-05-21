"Filed out from Dolphin Smalltalk 7"!

ISpeechAudio subclass: #ISpeechMMSysAudio
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechMMSysAudio guid: (IID fromString: '{3C76AF6D-1FD7-4831-81D1-3B71D5A13C44}')!
ISpeechMMSysAudio comment: '<ISpeechMMSysAudio> is a wrapper class for the COM interface ''SpeechLib.ISpeechMMSysAudio'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechMMSysAudio Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(3C76AF6D-1FD7-4831-81D1-3B71D5A13C44), 
	helpstring("ISpeechMMSysAudio Interface"), 
	dual
]
interface ISpeechMMSysAudio : ISpeechAudio {
	[id(0x0000012c), propget, helpstring("DeviceId")]
	HRESULT __stdcall DeviceId(
		[out, retval] long* DeviceId);
	[id(0x0000012c), propput, helpstring("DeviceId")]
	HRESULT __stdcall DeviceId(
		[in] long DeviceId);
	[id(0x0000012d), propget, helpstring("LineId")]
	HRESULT __stdcall LineId(
		[out, retval] long* LineId);
	[id(0x0000012d), propput, helpstring("LineId")]
	HRESULT __stdcall LineId(
		[in] long LineId);
	[id(0x0000012e), hidden, propget, helpstring("MMHandle")]
	HRESULT __stdcall MMHandle(
		[out, retval] long* Handle);
};
'!
!ISpeechMMSysAudio categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechMMSysAudio methodsFor!

deviceId
	"Answer the <sdword> value of the 'DeviceId' property of the receiver.
	Helpstring: 'DeviceId'"

	| answer |
	answer := (SDWORD new).
	self get_DeviceId: answer.
	^answer asObject
!

deviceId: deviceId
	"Set the 'DeviceId' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'DeviceId'"

	self put_DeviceId: deviceId
!

get_DeviceId: deviceId
	"Private - Get the value of the 'DeviceId' property of the receiver.

		HRESULT __stdcall DeviceId(
			[out, retval] long* DeviceId);"

	<virtual stdcall: hresult 22 sdword*>
	^self invalidCall
!

get_LineId: lineId
	"Private - Get the value of the 'LineId' property of the receiver.

		HRESULT __stdcall LineId(
			[out, retval] long* LineId);"

	<virtual stdcall: hresult 24 sdword*>
	^self invalidCall
!

get_MMHandle: handle
	"Private - Get the value of the 'MMHandle' property of the receiver.

		HRESULT __stdcall MMHandle(
			[out, retval] long* Handle);"

	<virtual stdcall: hresult 26 sdword*>
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

lineId
	"Answer the <sdword> value of the 'LineId' property of the receiver.
	Helpstring: 'LineId'"

	| answer |
	answer := (SDWORD new).
	self get_LineId: answer.
	^answer asObject
!

lineId: lineId
	"Set the 'LineId' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'LineId'"

	self put_LineId: lineId
!

mmHandle
	"Answer the <sdword> value of the 'MMHandle' property of the receiver.
	Helpstring: 'MMHandle'"

	| answer |
	answer := (SDWORD new).
	self get_MMHandle: answer.
	^answer asObject
!

put_DeviceId: deviceId
	"Private - Set the value of the 'DeviceId' property of the object wrapped by the 
	 receiver to the <sdword> argument, deviceId.

		HRESULT __stdcall DeviceId(
			[in] long DeviceId);"

	<virtual stdcall: hresult 23 sdword>
	^self invalidCall
!

put_LineId: lineId
	"Private - Set the value of the 'LineId' property of the object wrapped by the 
	 receiver to the <sdword> argument, lineId.

		HRESULT __stdcall LineId(
			[in] long LineId);"

	<virtual stdcall: hresult 25 sdword>
	^self invalidCall
! !
!ISpeechMMSysAudio categoriesFor: #deviceId!**auto generated**!properties!public! !
!ISpeechMMSysAudio categoriesFor: #deviceId:!**auto generated**!properties!public! !
!ISpeechMMSysAudio categoriesFor: #get_DeviceId:!**auto generated**!COM Interfaces-ISpeechMMSysAudio!private! !
!ISpeechMMSysAudio categoriesFor: #get_LineId:!**auto generated**!COM Interfaces-ISpeechMMSysAudio!private! !
!ISpeechMMSysAudio categoriesFor: #get_MMHandle:!**auto generated**!COM Interfaces-ISpeechMMSysAudio!private! !
!ISpeechMMSysAudio categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ISpeechMMSysAudio categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechMMSysAudio categoriesFor: #lineId!**auto generated**!properties!public! !
!ISpeechMMSysAudio categoriesFor: #lineId:!**auto generated**!properties!public! !
!ISpeechMMSysAudio categoriesFor: #mmHandle!**auto generated**!properties!public! !
!ISpeechMMSysAudio categoriesFor: #put_DeviceId:!**auto generated**!COM Interfaces-ISpeechMMSysAudio!private! !
!ISpeechMMSysAudio categoriesFor: #put_LineId:!**auto generated**!COM Interfaces-ISpeechMMSysAudio!private! !

!ISpeechMMSysAudio class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechMMSysAudio'
		ISpeechMMSysAudio defineTemplate"

	self
		defineFunction: #get_DeviceId:
			argumentTypes: 'sdword*';
		defineFunction: #put_DeviceId:
			argumentTypes: 'sdword';
		defineFunction: #get_LineId:
			argumentTypes: 'sdword*';
		defineFunction: #put_LineId:
			argumentTypes: 'sdword';
		defineFunction: #get_MMHandle:
			argumentTypes: 'sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechMMSysAudio initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechMMSysAudio class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechMMSysAudio class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

