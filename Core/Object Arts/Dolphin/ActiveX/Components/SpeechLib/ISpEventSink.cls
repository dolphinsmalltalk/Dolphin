"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #ISpEventSink
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpEventSink guid: (IID fromString: '{BE7A9CC9-5F9E-11D2-960F-00C04F8EE628}')!
ISpEventSink comment: '<ISpEventSink> is a wrapper class for the COM interface ''SpeechLib.ISpEventSink'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpEventSink Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(BE7A9CC9-5F9E-11D2-960F-00C04F8EE628), 
	helpstring("ISpEventSink Interface"), 
	restricted
]
interface ISpEventSink : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall AddEvents(
		[in] SPEVENT* pEventArray,
		[in] unsigned long ulCount);
	[id(0x60010001)]
	HRESULT __stdcall GetEventInterest(
		[out] unsigned __int64* pullEventInterest);
};
'!
!ISpEventSink categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpEventSink methodsFor!

addEvents: pEventArray ulCount: ulCount
	"Invoke the AddEvents() method of the COM object."

	^self
		AddEvents: pEventArray
		ulCount: ulCount
!

AddEvents: pEventArray ulCount: ulCount
	"Private - Invoke the AddEvents() method of the COM object.

		HRESULT __stdcall AddEvents(
			[in] SPEVENT* pEventArray,
			[in] unsigned long ulCount);"

	<virtual stdcall: hresult 4 SPEVENT* dword>
	^self invalidCall
!

getEventInterest
	"Answer the <ULARGE_INTEGER> result of invoking the GetEventInterest() method of the COM object."

	| answer |
	answer := (ULARGE_INTEGER new).
	self GetEventInterest: answer.
	^answer asObject
!

GetEventInterest: pullEventInterest
	"Private - Invoke the GetEventInterest() method of the COM object.

		HRESULT __stdcall GetEventInterest(
			[out] unsigned __int64* pullEventInterest);"

	<virtual stdcall: hresult 5 qword*>
	^self invalidCall
! !
!ISpEventSink categoriesFor: #addEvents:ulCount:!**auto generated**!methods!public! !
!ISpEventSink categoriesFor: #AddEvents:ulCount:!**auto generated**!COM Interfaces-ISpEventSink!private! !
!ISpEventSink categoriesFor: #getEventInterest!**auto generated**!methods!public! !
!ISpEventSink categoriesFor: #GetEventInterest:!**auto generated**!COM Interfaces-ISpEventSink!private! !

!ISpEventSink class methodsFor!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpEventSink initializeTypeLib"

	typeLib := SpeechLib! !
!ISpEventSink class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

