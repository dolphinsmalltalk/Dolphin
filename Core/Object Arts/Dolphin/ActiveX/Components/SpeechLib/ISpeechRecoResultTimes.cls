"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechRecoResultTimes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechRecoResultTimes guid: (IID fromString: '{62B3B8FB-F6E7-41BE-BDCB-056B1C29EFC0}')!
ISpeechRecoResultTimes comment: '<ISpeechRecoResultTimes> is a wrapper class for the COM interface ''SpeechLib.ISpeechRecoResultTimes'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechRecoResultTimes Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(62B3B8FB-F6E7-41BE-BDCB-056B1C29EFC0), 
	helpstring("ISpeechRecoResultTimes Interface"), 
	dual
]
interface ISpeechRecoResultTimes : IDispatch {
	[id(0x00000001), propget, helpstring("StreamTime")]
	HRESULT __stdcall StreamTime(
		[out, retval] VARIANT* Time);
	[id(0x00000002), propget, helpstring("Length")]
	HRESULT __stdcall Length(
		[out, retval] VARIANT* Length);
	[id(0x00000003), propget, helpstring("TickCount")]
	HRESULT __stdcall TickCount(
		[out, retval] long* TickCount);
	[id(0x00000004), propget, helpstring("Start")]
	HRESULT __stdcall OffsetFromStart(
		[out, retval] VARIANT* OffsetFromStart);
};
'!
!ISpeechRecoResultTimes categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechRecoResultTimes methodsFor!

get_Length: length
	"Private - Get the value of the 'Length' property of the receiver.

		HRESULT __stdcall Length(
			[out, retval] VARIANT* Length);"

	<virtual stdcall: hresult 9 variant*>
	^self invalidCall
!

get_OffsetFromStart: offsetFromStart
	"Private - Get the value of the 'OffsetFromStart' property of the receiver.

		HRESULT __stdcall OffsetFromStart(
			[out, retval] VARIANT* OffsetFromStart);"

	<virtual stdcall: hresult 11 variant*>
	^self invalidCall
!

get_StreamTime: time
	"Private - Get the value of the 'StreamTime' property of the receiver.

		HRESULT __stdcall StreamTime(
			[out, retval] VARIANT* Time);"

	<virtual stdcall: hresult 8 variant*>
	^self invalidCall
!

get_TickCount: tickCount
	"Private - Get the value of the 'TickCount' property of the receiver.

		HRESULT __stdcall TickCount(
			[out, retval] long* TickCount);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

length
	"Answer the <variant> value of the 'Length' property of the receiver.
	Helpstring: 'Length'"

	| answer |
	answer := VARIANT new.
	self get_Length: answer.
	^answer asObject
!

offsetFromStart
	"Answer the <variant> value of the 'OffsetFromStart' property of the receiver.
	Helpstring: 'Start'"

	| answer |
	answer := VARIANT new.
	self get_OffsetFromStart: answer.
	^answer asObject
!

streamTime
	"Answer the <variant> value of the 'StreamTime' property of the receiver.
	Helpstring: 'StreamTime'"

	| answer |
	answer := VARIANT new.
	self get_StreamTime: answer.
	^answer asObject
!

tickCount
	"Answer the <sdword> value of the 'TickCount' property of the receiver.
	Helpstring: 'TickCount'"

	| answer |
	answer := (SDWORD new).
	self get_TickCount: answer.
	^answer asObject
! !
!ISpeechRecoResultTimes categoriesFor: #get_Length:!**auto generated**!COM Interfaces-ISpeechRecoResultTimes!private! !
!ISpeechRecoResultTimes categoriesFor: #get_OffsetFromStart:!**auto generated**!COM Interfaces-ISpeechRecoResultTimes!private! !
!ISpeechRecoResultTimes categoriesFor: #get_StreamTime:!**auto generated**!COM Interfaces-ISpeechRecoResultTimes!private! !
!ISpeechRecoResultTimes categoriesFor: #get_TickCount:!**auto generated**!COM Interfaces-ISpeechRecoResultTimes!private! !
!ISpeechRecoResultTimes categoriesFor: #length!**auto generated**!properties!public! !
!ISpeechRecoResultTimes categoriesFor: #offsetFromStart!**auto generated**!properties!public! !
!ISpeechRecoResultTimes categoriesFor: #streamTime!**auto generated**!properties!public! !
!ISpeechRecoResultTimes categoriesFor: #tickCount!**auto generated**!properties!public! !

!ISpeechRecoResultTimes class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechRecoResultTimes'
		ISpeechRecoResultTimes defineTemplate"

	self
		defineFunction: #get_StreamTime:
			argumentTypes: 'variant*';
		defineFunction: #get_Length:
			argumentTypes: 'variant*';
		defineFunction: #get_TickCount:
			argumentTypes: 'sdword*';
		defineFunction: #get_OffsetFromStart:
			argumentTypes: 'variant*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechRecoResultTimes initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechRecoResultTimes class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechRecoResultTimes class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

