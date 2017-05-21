"Filed out from Dolphin Smalltalk 7"!

ISpAudio subclass: #ISpMMSysAudio
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpMMSysAudio guid: (IID fromString: '{15806F6E-1D70-4B48-98E6-3B1A007509AB}')!
ISpMMSysAudio comment: '<ISpMMSysAudio> is a wrapper class for the COM interface ''SpeechLib.ISpMMSysAudio'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpMMSysAudio Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(15806F6E-1D70-4B48-98E6-3B1A007509AB), 
	helpstring("ISpMMSysAudio Interface"), 
	restricted
]
interface ISpMMSysAudio : ISpAudio {
	[id(0x60050000)]
	HRESULT __stdcall GetDeviceId(
		[out] unsigned int* puDeviceId);
	[id(0x60050001)]
	HRESULT __stdcall SetDeviceId(
		[in] unsigned int uDeviceId);
	[id(0x60050002)]
	HRESULT __stdcall GetMMHandle(
		void** pHandle);
	[id(0x60050003)]
	HRESULT __stdcall GetLineId(
		[out] unsigned int* puLineId);
	[id(0x60050004)]
	HRESULT __stdcall SetLineId(
		[in] unsigned int uLineId);
};
'!
!ISpMMSysAudio categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpMMSysAudio methodsFor!

getDeviceId
	"Answer the <DWORD> result of invoking the GetDeviceId() method of the COM object."

	| answer |
	answer := (DWORD new).
	self GetDeviceId: answer.
	^answer asObject
!

GetDeviceId: puDeviceId
	"Private - Invoke the GetDeviceId() method of the COM object.

		HRESULT __stdcall GetDeviceId(
			[out] unsigned int* puDeviceId);"

	<virtual stdcall: hresult 27 dword*>
	^self invalidCall
!

getLineId
	"Answer the <DWORD> result of invoking the GetLineId() method of the COM object."

	| answer |
	answer := (DWORD new).
	self GetLineId: answer.
	^answer asObject
!

GetLineId: puLineId
	"Private - Invoke the GetLineId() method of the COM object.

		HRESULT __stdcall GetLineId(
			[out] unsigned int* puLineId);"

	<virtual stdcall: hresult 30 dword*>
	^self invalidCall
!

getMMHandle: pHandle
	"Invoke the GetMMHandle() method of the COM object."

	^self GetMMHandle: pHandle
!

GetMMHandle: pHandle
	"Private - Invoke the GetMMHandle() method of the COM object.

		HRESULT __stdcall GetMMHandle(
			void** pHandle);"

	<virtual stdcall: hresult 29 void**>
	^self invalidCall
!

setDeviceId: uDeviceId
	"Invoke the SetDeviceId() method of the COM object."

	^self SetDeviceId: uDeviceId
!

SetDeviceId: uDeviceId
	"Private - Invoke the SetDeviceId() method of the COM object.

		HRESULT __stdcall SetDeviceId(
			[in] unsigned int uDeviceId);"

	<virtual stdcall: hresult 28 dword>
	^self invalidCall
!

setLineId: uLineId
	"Invoke the SetLineId() method of the COM object."

	^self SetLineId: uLineId
!

SetLineId: uLineId
	"Private - Invoke the SetLineId() method of the COM object.

		HRESULT __stdcall SetLineId(
			[in] unsigned int uLineId);"

	<virtual stdcall: hresult 31 dword>
	^self invalidCall
! !
!ISpMMSysAudio categoriesFor: #getDeviceId!**auto generated**!methods!public! !
!ISpMMSysAudio categoriesFor: #GetDeviceId:!**auto generated**!COM Interfaces-ISpMMSysAudio!private! !
!ISpMMSysAudio categoriesFor: #getLineId!**auto generated**!methods!public! !
!ISpMMSysAudio categoriesFor: #GetLineId:!**auto generated**!COM Interfaces-ISpMMSysAudio!private! !
!ISpMMSysAudio categoriesFor: #getMMHandle:!**auto generated**!methods!public! !
!ISpMMSysAudio categoriesFor: #GetMMHandle:!**auto generated**!COM Interfaces-ISpMMSysAudio!private! !
!ISpMMSysAudio categoriesFor: #setDeviceId:!**auto generated**!methods!public! !
!ISpMMSysAudio categoriesFor: #SetDeviceId:!**auto generated**!COM Interfaces-ISpMMSysAudio!private! !
!ISpMMSysAudio categoriesFor: #setLineId:!**auto generated**!methods!public! !
!ISpMMSysAudio categoriesFor: #SetLineId:!**auto generated**!COM Interfaces-ISpMMSysAudio!private! !

!ISpMMSysAudio class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpMMSysAudio'
		ISpMMSysAudio defineTemplate"

	self
		defineFunction: #GetDeviceId:
			argumentTypes: 'dword*';
		defineFunction: #SetDeviceId:
			argumentTypes: 'dword';
		defineFunction: #GetMMHandle:
			argumentTypes: 'void**';
		defineFunction: #GetLineId:
			argumentTypes: 'dword*';
		defineFunction: #SetLineId:
			argumentTypes: 'dword'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpMMSysAudio initializeTypeLib"

	typeLib := SpeechLib! !
!ISpMMSysAudio class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpMMSysAudio class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

