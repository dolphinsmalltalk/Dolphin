"Filed out from Dolphin Smalltalk X6"!

ISpNotifySource subclass: #ISpEventSource
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpEventSource guid: (IID fromString: '{BE7A9CCE-5F9E-11D2-960F-00C04F8EE628}')!
ISpEventSource comment: '<ISpEventSource> is a wrapper class for the COM interface ''SpeechLib.ISpEventSource'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpEventSource Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(BE7A9CCE-5F9E-11D2-960F-00C04F8EE628), 
	helpstring("ISpEventSource Interface"), 
	restricted
]
interface ISpEventSource : ISpNotifySource {
	[id(0x60020000)]
	HRESULT __stdcall SetInterest(
		[in] unsigned __int64 ullEventInterest,
		[in] unsigned __int64 ullQueuedInterest);
	[id(0x60020001)]
	HRESULT __stdcall GetEvents(
		[in] unsigned long ulCount,
		[out] SPEVENT* pEventArray,
		[out] unsigned long* pulFetched);
	[id(0x60020002)]
	HRESULT __stdcall GetInfo(
		[out] SPEVENTSOURCEINFO* pInfo);
};
'!
!ISpEventSource categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpEventSource methodsFor!

getEvents: ulCount
	"Invoke the GetEvents() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (SPEVENT new);
				basicAt: 2 put: (DWORD new);
				yourself.
	self
		GetEvents: ulCount
		pEventArray: (answer basicAt: 1)
		pulFetched: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetEvents: ulCount pEventArray: pEventArray pulFetched: pulFetched
	"Private - Invoke the GetEvents() method of the COM object.

		HRESULT __stdcall GetEvents(
			[in] unsigned long ulCount,
			[out] SPEVENT* pEventArray,
			[out] unsigned long* pulFetched);"

	<virtual stdcall: hresult 12 dword SPEVENT* dword*>
	^self invalidCall
!

getInfo
	"Answer the <SPEVENTSOURCEINFO> result of invoking the GetInfo() method of the COM object."

	| answer |
	answer := (SPEVENTSOURCEINFO new).
	self GetInfo: answer.
	^answer asObject
!

GetInfo: pInfo
	"Private - Invoke the GetInfo() method of the COM object.

		HRESULT __stdcall GetInfo(
			[out] SPEVENTSOURCEINFO* pInfo);"

	<virtual stdcall: hresult 13 SPEVENTSOURCEINFO*>
	^self invalidCall
!

setInterest: ullEventInterest ullQueuedInterest: ullQueuedInterest
	"Invoke the SetInterest() method of the COM object."

	^self
		SetInterest: ullEventInterest
		ullQueuedInterest: ullQueuedInterest
!

SetInterest: ullEventInterest ullQueuedInterest: ullQueuedInterest
	"Private - Invoke the SetInterest() method of the COM object.

		HRESULT __stdcall SetInterest(
			[in] unsigned __int64 ullEventInterest,
			[in] unsigned __int64 ullQueuedInterest);"

	<virtual stdcall: hresult 11 qword qword>
	^self invalidCall
! !
!ISpEventSource categoriesFor: #getEvents:!**auto generated**!methods!public! !
!ISpEventSource categoriesFor: #GetEvents:pEventArray:pulFetched:!**auto generated**!COM Interfaces-ISpEventSource!private! !
!ISpEventSource categoriesFor: #getInfo!**auto generated**!methods!public! !
!ISpEventSource categoriesFor: #GetInfo:!**auto generated**!COM Interfaces-ISpEventSource!private! !
!ISpEventSource categoriesFor: #setInterest:ullQueuedInterest:!**auto generated**!methods!public! !
!ISpEventSource categoriesFor: #SetInterest:ullQueuedInterest:!**auto generated**!COM Interfaces-ISpEventSource!private! !

!ISpEventSource class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpEventSource'
		ISpEventSource defineTemplate"

	self
		defineFunction: #SetInterest:ullQueuedInterest:
			argumentTypes: 'qword qword';
		defineFunction: #GetEvents:pEventArray:pulFetched:
			argumentTypes: 'dword SPEVENT* dword*';
		defineFunction: #GetInfo:
			argumentTypes: 'SPEVENTSOURCEINFO*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpEventSource initializeTypeLib"

	typeLib := SpeechLib! !
!ISpEventSource class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpEventSource class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

