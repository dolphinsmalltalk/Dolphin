"Filed out from Dolphin Smalltalk X6"!

ISpStreamFormat subclass: #ISpAudio
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpAudio guid: (IID fromString: '{C05C768F-FAE8-4EC2-8E07-338321C12452}')!
ISpAudio comment: '<ISpAudio> is a wrapper class for the COM interface ''SpeechLib.ISpAudio'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpAudio Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(C05C768F-FAE8-4EC2-8E07-338321C12452), 
	helpstring("ISpAudio Interface"), 
	restricted
]
interface ISpAudio : ISpStreamFormat {
	[id(0x60040000)]
	HRESULT __stdcall SetState(
		[in] SPAUDIOSTATE NewState,
		[in] unsigned __int64 ullReserved);
	[id(0x60040001)]
	HRESULT __stdcall SetFormat(
		[in] GUID* rguidFmtId,
		[in] WaveFormatEx* pWaveFormatEx);
	[id(0x60040002)]
	HRESULT __stdcall GetStatus(
		[out] SPAUDIOSTATUS* pStatus);
	[id(0x60040003)]
	HRESULT __stdcall SetBufferInfo(
		[in] SPAUDIOBUFFERINFO* pBuffInfo);
	[id(0x60040004)]
	HRESULT __stdcall GetBufferInfo(
		[out] SPAUDIOBUFFERINFO* pBuffInfo);
	[id(0x60040005)]
	HRESULT __stdcall GetDefaultFormat(
		[out] GUID* pFormatId,
		[out] WaveFormatEx** ppCoMemWaveFormatEx);
	[id(0x60040006)]
	void* __stdcall EventHandle();
	[id(0x60040007)]
	HRESULT __stdcall GetVolumeLevel(
		[out] unsigned long* pLevel);
	[id(0x60040008)]
	HRESULT __stdcall SetVolumeLevel(
		[in] unsigned long Level);
	[id(0x60040009)]
	HRESULT __stdcall GetBufferNotifySize(
		[out] unsigned long* pcbSize);
	[id(0x6004000a)]
	HRESULT __stdcall SetBufferNotifySize(
		[in] unsigned long cbSize);
};
'!
!ISpAudio categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpAudio methodsFor!

eventHandle
	"Answer the <VOID> result of invoking the EventHandle() method of the COM object."

	^self EventHandle
!

EventHandle
	"Private - Invoke the EventHandle() method of the COM object.

		void* __stdcall EventHandle();"

	<virtual stdcall: void* 22>
	^self invalidCall
!

getBufferInfo
	"Answer the <SPAUDIOBUFFERINFO> result of invoking the GetBufferInfo() method of the COM object."

	| answer |
	answer := (SPAUDIOBUFFERINFO new).
	self GetBufferInfo: answer.
	^answer asObject
!

GetBufferInfo: pBuffInfo
	"Private - Invoke the GetBufferInfo() method of the COM object.

		HRESULT __stdcall GetBufferInfo(
			[out] SPAUDIOBUFFERINFO* pBuffInfo);"

	<virtual stdcall: hresult 20 SPAUDIOBUFFERINFO*>
	^self invalidCall
!

getBufferNotifySize
	"Answer the <DWORD> result of invoking the GetBufferNotifySize() method of the COM object."

	| answer |
	answer := (DWORD new).
	self GetBufferNotifySize: answer.
	^answer asObject
!

GetBufferNotifySize: pcbSize
	"Private - Invoke the GetBufferNotifySize() method of the COM object.

		HRESULT __stdcall GetBufferNotifySize(
			[out] unsigned long* pcbSize);"

	<virtual stdcall: hresult 25 dword*>
	^self invalidCall
!

getDefaultFormat
	"Invoke the GetDefaultFormat() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: GUID new;
				basicAt: 2 put: (WaveFormatEx newBufferClass: COMTaskMemory);
				yourself.
	self
		GetDefaultFormat: (answer basicAt: 1)
		ppCoMemWaveFormatEx: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetDefaultFormat: pFormatId ppCoMemWaveFormatEx: ppCoMemWaveFormatEx
	"Private - Invoke the GetDefaultFormat() method of the COM object.

		HRESULT __stdcall GetDefaultFormat(
			[out] GUID* pFormatId,
			[out] WaveFormatEx** ppCoMemWaveFormatEx);"

	<virtual stdcall: hresult 21 GUID* WaveFormatEx**>
	^self invalidCall
!

getStatus
	"Answer the <SPAUDIOSTATUS> result of invoking the GetStatus() method of the COM object."

	| answer |
	answer := (SPAUDIOSTATUS new).
	self GetStatus: answer.
	^answer asObject
!

GetStatus: pStatus
	"Private - Invoke the GetStatus() method of the COM object.

		HRESULT __stdcall GetStatus(
			[out] SPAUDIOSTATUS* pStatus);"

	<virtual stdcall: hresult 18 SPAUDIOSTATUS*>
	^self invalidCall
!

getVolumeLevel
	"Answer the <DWORD> result of invoking the GetVolumeLevel() method of the COM object."

	| answer |
	answer := (DWORD new).
	self GetVolumeLevel: answer.
	^answer asObject
!

GetVolumeLevel: pLevel
	"Private - Invoke the GetVolumeLevel() method of the COM object.

		HRESULT __stdcall GetVolumeLevel(
			[out] unsigned long* pLevel);"

	<virtual stdcall: hresult 23 dword*>
	^self invalidCall
!

setBufferInfo: pBuffInfo
	"Invoke the SetBufferInfo() method of the COM object."

	^self SetBufferInfo: pBuffInfo
!

SetBufferInfo: pBuffInfo
	"Private - Invoke the SetBufferInfo() method of the COM object.

		HRESULT __stdcall SetBufferInfo(
			[in] SPAUDIOBUFFERINFO* pBuffInfo);"

	<virtual stdcall: hresult 19 SPAUDIOBUFFERINFO*>
	^self invalidCall
!

setBufferNotifySize: cbSize
	"Invoke the SetBufferNotifySize() method of the COM object."

	^self SetBufferNotifySize: cbSize
!

SetBufferNotifySize: cbSize
	"Private - Invoke the SetBufferNotifySize() method of the COM object.

		HRESULT __stdcall SetBufferNotifySize(
			[in] unsigned long cbSize);"

	<virtual stdcall: hresult 26 dword>
	^self invalidCall
!

setFormat: rguidFmtId pWaveFormatEx: pWaveFormatEx
	"Invoke the SetFormat() method of the COM object."

	^self
		SetFormat: rguidFmtId
		pWaveFormatEx: pWaveFormatEx
!

SetFormat: rguidFmtId pWaveFormatEx: pWaveFormatEx
	"Private - Invoke the SetFormat() method of the COM object.

		HRESULT __stdcall SetFormat(
			[in] GUID* rguidFmtId,
			[in] WaveFormatEx* pWaveFormatEx);"

	<virtual stdcall: hresult 17 GUID* WaveFormatEx*>
	^self invalidCall
!

setState: newState ullReserved: ullReserved
	"Invoke the SetState() method of the COM object."

	^self
		SetState: newState
		ullReserved: ullReserved
!

SetState: newState ullReserved: ullReserved
	"Private - Invoke the SetState() method of the COM object.

		HRESULT __stdcall SetState(
			[in] SPAUDIOSTATE NewState,
			[in] unsigned __int64 ullReserved);"

	<virtual stdcall: hresult 16 sdword qword>
	^self invalidCall
!

setVolumeLevel: level
	"Invoke the SetVolumeLevel() method of the COM object."

	^self SetVolumeLevel: level
!

SetVolumeLevel: level
	"Private - Invoke the SetVolumeLevel() method of the COM object.

		HRESULT __stdcall SetVolumeLevel(
			[in] unsigned long Level);"

	<virtual stdcall: hresult 24 dword>
	^self invalidCall
! !
!ISpAudio categoriesFor: #eventHandle!**auto generated**!methods!public! !
!ISpAudio categoriesFor: #EventHandle!**auto generated**!COM Interfaces-ISpAudio!private! !
!ISpAudio categoriesFor: #getBufferInfo!**auto generated**!methods!public! !
!ISpAudio categoriesFor: #GetBufferInfo:!**auto generated**!COM Interfaces-ISpAudio!private! !
!ISpAudio categoriesFor: #getBufferNotifySize!**auto generated**!methods!public! !
!ISpAudio categoriesFor: #GetBufferNotifySize:!**auto generated**!COM Interfaces-ISpAudio!private! !
!ISpAudio categoriesFor: #getDefaultFormat!**auto generated**!methods!public! !
!ISpAudio categoriesFor: #GetDefaultFormat:ppCoMemWaveFormatEx:!**auto generated**!COM Interfaces-ISpAudio!private! !
!ISpAudio categoriesFor: #getStatus!**auto generated**!methods!public! !
!ISpAudio categoriesFor: #GetStatus:!**auto generated**!COM Interfaces-ISpAudio!private! !
!ISpAudio categoriesFor: #getVolumeLevel!**auto generated**!methods!public! !
!ISpAudio categoriesFor: #GetVolumeLevel:!**auto generated**!COM Interfaces-ISpAudio!private! !
!ISpAudio categoriesFor: #setBufferInfo:!**auto generated**!methods!public! !
!ISpAudio categoriesFor: #SetBufferInfo:!**auto generated**!COM Interfaces-ISpAudio!private! !
!ISpAudio categoriesFor: #setBufferNotifySize:!**auto generated**!methods!public! !
!ISpAudio categoriesFor: #SetBufferNotifySize:!**auto generated**!COM Interfaces-ISpAudio!private! !
!ISpAudio categoriesFor: #setFormat:pWaveFormatEx:!**auto generated**!methods!public! !
!ISpAudio categoriesFor: #SetFormat:pWaveFormatEx:!**auto generated**!COM Interfaces-ISpAudio!private! !
!ISpAudio categoriesFor: #setState:ullReserved:!**auto generated**!methods!public! !
!ISpAudio categoriesFor: #SetState:ullReserved:!**auto generated**!COM Interfaces-ISpAudio!private! !
!ISpAudio categoriesFor: #setVolumeLevel:!**auto generated**!methods!public! !
!ISpAudio categoriesFor: #SetVolumeLevel:!**auto generated**!COM Interfaces-ISpAudio!private! !

!ISpAudio class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpAudio'
		ISpAudio defineTemplate"

	self
		defineFunction: #SetState:ullReserved:
			argumentTypes: 'sdword qword';
		defineFunction: #SetFormat:pWaveFormatEx:
			argumentTypes: 'GUID* WaveFormatEx*';
		defineFunction: #GetStatus:
			argumentTypes: 'SPAUDIOSTATUS*';
		defineFunction: #SetBufferInfo:
			argumentTypes: 'SPAUDIOBUFFERINFO*';
		defineFunction: #GetBufferInfo:
			argumentTypes: 'SPAUDIOBUFFERINFO*';
		defineFunction: #GetDefaultFormat:ppCoMemWaveFormatEx:
			argumentTypes: 'GUID* WaveFormatEx**';
		defineFunction: #EventHandle
			returnType: 'void*';
		defineFunction: #GetVolumeLevel:
			argumentTypes: 'dword*';
		defineFunction: #SetVolumeLevel:
			argumentTypes: 'dword';
		defineFunction: #GetBufferNotifySize:
			argumentTypes: 'dword*';
		defineFunction: #SetBufferNotifySize:
			argumentTypes: 'dword'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpAudio initializeTypeLib"

	typeLib := SpeechLib! !
!ISpAudio class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpAudio class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

