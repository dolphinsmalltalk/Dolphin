"Filed out from Dolphin Smalltalk X6"!

ISpStreamFormat subclass: #ISpStreamFormatConverter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpStreamFormatConverter guid: (IID fromString: '{678A932C-EA71-4446-9B41-78FDA6280A29}')!
ISpStreamFormatConverter comment: '<ISpStreamFormatConverter> is a wrapper class for the COM interface ''SpeechLib.ISpStreamFormatConverter'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpStreamFormatConverter Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(678A932C-EA71-4446-9B41-78FDA6280A29), 
	helpstring("ISpStreamFormatConverter Interface"), 
	restricted
]
interface ISpStreamFormatConverter : ISpStreamFormat {
	[id(0x60040000)]
	HRESULT __stdcall SetBaseStream(
		[in] ISpStreamFormat* pStream,
		[in] long fSetFormatToBaseStreamFormat,
		[in] long fWriteToBaseStream);
	[id(0x60040001)]
	HRESULT __stdcall GetBaseStream(
		[out] ISpStreamFormat** ppStream);
	[id(0x60040002)]
	HRESULT __stdcall SetFormat(
		[in] GUID* rguidFormatIdOfConvertedStream,
		[in] WaveFormatEx* pWaveFormatExOfConvertedStream);
	[id(0x60040003)]
	HRESULT __stdcall ResetSeekPosition();
	[id(0x60040004)]
	HRESULT __stdcall ScaleConvertedToBaseOffset(
		[in] unsigned __int64 ullOffsetConvertedStream,
		[out] unsigned __int64* pullOffsetBaseStream);
	[id(0x60040005)]
	HRESULT __stdcall ScaleBaseToConvertedOffset(
		[in] unsigned __int64 ullOffsetBaseStream,
		[out] unsigned __int64* pullOffsetConvertedStream);
};
'!
!ISpStreamFormatConverter categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpStreamFormatConverter methodsFor!

getBaseStream
	"Answer the <ISpStreamFormat> result of invoking the GetBaseStream() method of the COM object."

	| answer |
	answer := ISpStreamFormat newPointer.
	self GetBaseStream: answer.
	^answer asObject
!

GetBaseStream: ppStream
	"Private - Invoke the GetBaseStream() method of the COM object.

		HRESULT __stdcall GetBaseStream(
			[out] ISpStreamFormat** ppStream);"

	<virtual stdcall: hresult 17 ISpStreamFormat**>
	^self invalidCall
!

resetSeekPosition
	"Invoke the ResetSeekPosition() method of the COM object."

	^self ResetSeekPosition
!

ResetSeekPosition
	"Private - Invoke the ResetSeekPosition() method of the COM object.

		HRESULT __stdcall ResetSeekPosition();"

	<virtual stdcall: hresult 19>
	^self invalidCall
!

scaleBaseToConvertedOffset: ullOffsetBaseStream
	"Answer the <ULARGE_INTEGER> result of invoking the ScaleBaseToConvertedOffset() method of the COM object."

	| answer |
	answer := (ULARGE_INTEGER new).
	self
		ScaleBaseToConvertedOffset: ullOffsetBaseStream
		pullOffsetConvertedStream: answer.
	^answer asObject
!

ScaleBaseToConvertedOffset: ullOffsetBaseStream pullOffsetConvertedStream: pullOffsetConvertedStream
	"Private - Invoke the ScaleBaseToConvertedOffset() method of the COM object.

		HRESULT __stdcall ScaleBaseToConvertedOffset(
			[in] unsigned __int64 ullOffsetBaseStream,
			[out] unsigned __int64* pullOffsetConvertedStream);"

	<virtual stdcall: hresult 21 qword qword*>
	^self invalidCall
!

scaleConvertedToBaseOffset: ullOffsetConvertedStream
	"Answer the <ULARGE_INTEGER> result of invoking the ScaleConvertedToBaseOffset() method of the COM object."

	| answer |
	answer := (ULARGE_INTEGER new).
	self
		ScaleConvertedToBaseOffset: ullOffsetConvertedStream
		pullOffsetBaseStream: answer.
	^answer asObject
!

ScaleConvertedToBaseOffset: ullOffsetConvertedStream pullOffsetBaseStream: pullOffsetBaseStream
	"Private - Invoke the ScaleConvertedToBaseOffset() method of the COM object.

		HRESULT __stdcall ScaleConvertedToBaseOffset(
			[in] unsigned __int64 ullOffsetConvertedStream,
			[out] unsigned __int64* pullOffsetBaseStream);"

	<virtual stdcall: hresult 20 qword qword*>
	^self invalidCall
!

setBaseStream: pStream fSetFormatToBaseStreamFormat: fSetFormatToBaseStreamFormat fWriteToBaseStream: fWriteToBaseStream
	"Invoke the SetBaseStream() method of the COM object."

	^self
		SetBaseStream: pStream
		fSetFormatToBaseStreamFormat: fSetFormatToBaseStreamFormat
		fWriteToBaseStream: fWriteToBaseStream
!

SetBaseStream: pStream fSetFormatToBaseStreamFormat: fSetFormatToBaseStreamFormat fWriteToBaseStream: fWriteToBaseStream
	"Private - Invoke the SetBaseStream() method of the COM object.

		HRESULT __stdcall SetBaseStream(
			[in] ISpStreamFormat* pStream,
			[in] long fSetFormatToBaseStreamFormat,
			[in] long fWriteToBaseStream);"

	<virtual stdcall: hresult 16 ISpStreamFormat* sdword sdword>
	^self invalidCall
!

setFormat: rguidFormatIdOfConvertedStream pWaveFormatExOfConvertedStream: pWaveFormatExOfConvertedStream
	"Invoke the SetFormat() method of the COM object."

	^self
		SetFormat: rguidFormatIdOfConvertedStream
		pWaveFormatExOfConvertedStream: pWaveFormatExOfConvertedStream
!

SetFormat: rguidFormatIdOfConvertedStream pWaveFormatExOfConvertedStream: pWaveFormatExOfConvertedStream
	"Private - Invoke the SetFormat() method of the COM object.

		HRESULT __stdcall SetFormat(
			[in] GUID* rguidFormatIdOfConvertedStream,
			[in] WaveFormatEx* pWaveFormatExOfConvertedStream);"

	<virtual stdcall: hresult 18 GUID* WaveFormatEx*>
	^self invalidCall
! !
!ISpStreamFormatConverter categoriesFor: #getBaseStream!**auto generated**!methods!public! !
!ISpStreamFormatConverter categoriesFor: #GetBaseStream:!**auto generated**!COM Interfaces-ISpStreamFormatConverter!private! !
!ISpStreamFormatConverter categoriesFor: #resetSeekPosition!**auto generated**!methods!public! !
!ISpStreamFormatConverter categoriesFor: #ResetSeekPosition!**auto generated**!COM Interfaces-ISpStreamFormatConverter!private! !
!ISpStreamFormatConverter categoriesFor: #scaleBaseToConvertedOffset:!**auto generated**!methods!public! !
!ISpStreamFormatConverter categoriesFor: #ScaleBaseToConvertedOffset:pullOffsetConvertedStream:!**auto generated**!COM Interfaces-ISpStreamFormatConverter!private! !
!ISpStreamFormatConverter categoriesFor: #scaleConvertedToBaseOffset:!**auto generated**!methods!public! !
!ISpStreamFormatConverter categoriesFor: #ScaleConvertedToBaseOffset:pullOffsetBaseStream:!**auto generated**!COM Interfaces-ISpStreamFormatConverter!private! !
!ISpStreamFormatConverter categoriesFor: #setBaseStream:fSetFormatToBaseStreamFormat:fWriteToBaseStream:!**auto generated**!methods!public! !
!ISpStreamFormatConverter categoriesFor: #SetBaseStream:fSetFormatToBaseStreamFormat:fWriteToBaseStream:!**auto generated**!COM Interfaces-ISpStreamFormatConverter!private! !
!ISpStreamFormatConverter categoriesFor: #setFormat:pWaveFormatExOfConvertedStream:!**auto generated**!methods!public! !
!ISpStreamFormatConverter categoriesFor: #SetFormat:pWaveFormatExOfConvertedStream:!**auto generated**!COM Interfaces-ISpStreamFormatConverter!private! !

!ISpStreamFormatConverter class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpStreamFormatConverter) for which the receiver is the default interface."

	^CLSID fromString: '{7013943A-E2EC-11D2-A086-00C04F8EF9B5}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpStreamFormatConverter'
		ISpStreamFormatConverter defineTemplate"

	self
		defineFunction: #SetBaseStream:fSetFormatToBaseStreamFormat:fWriteToBaseStream:
			argumentTypes: 'ISpStreamFormat* sdword sdword';
		defineFunction: #GetBaseStream:
			argumentTypes: 'ISpStreamFormat**';
		defineFunction: #SetFormat:pWaveFormatExOfConvertedStream:
			argumentTypes: 'GUID* WaveFormatEx*';
		defineFunction: #ResetSeekPosition;
		defineFunction: #ScaleConvertedToBaseOffset:pullOffsetBaseStream:
			argumentTypes: 'qword qword*';
		defineFunction: #ScaleBaseToConvertedOffset:pullOffsetConvertedStream:
			argumentTypes: 'qword qword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpStreamFormatConverter initializeTypeLib"

	typeLib := SpeechLib! !
!ISpStreamFormatConverter class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpStreamFormatConverter class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpStreamFormatConverter class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

