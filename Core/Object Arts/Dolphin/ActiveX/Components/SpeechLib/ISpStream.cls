"Filed out from Dolphin Smalltalk 7"!

ISpStreamFormat subclass: #ISpStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpStream guid: (IID fromString: '{12E3CCA9-7518-44C5-A5E7-BA5A79CB929E}')!
ISpStream comment: '<ISpStream> is a wrapper class for the COM interface ''SpeechLib.ISpStream'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpStream Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(12E3CCA9-7518-44C5-A5E7-BA5A79CB929E), 
	helpstring("ISpStream Interface"), 
	restricted
]
interface ISpStream : ISpStreamFormat {
	[id(0x60040000)]
	HRESULT __stdcall SetBaseStream(
		IStream* pStream,
		GUID* rguidFormat,
		WaveFormatEx* pWaveFormatEx);
	[id(0x60040001)]
	HRESULT __stdcall GetBaseStream(
		IStream** ppStream);
	[id(0x60040002)]
	HRESULT __stdcall BindToFile(
		unsigned short* pszFileName,
		SPFILEMODE eMode,
		GUID* pFormatId,
		WaveFormatEx* pWaveFormatEx,
		unsigned __int64 ullEventInterest);
	[id(0x60040003)]
	HRESULT __stdcall Close();
};
'!
!ISpStream categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpStream methodsFor!

bindToFile: pszFileName eMode: eMode pFormatId: pFormatId pWaveFormatEx: pWaveFormatEx ullEventInterest: ullEventInterest
	"Invoke the BindToFile() method of the COM object."

	^self
		BindToFile: pszFileName
		eMode: eMode
		pFormatId: pFormatId
		pWaveFormatEx: pWaveFormatEx
		ullEventInterest: ullEventInterest
!

BindToFile: pszFileName eMode: eMode pFormatId: pFormatId pWaveFormatEx: pWaveFormatEx ullEventInterest: ullEventInterest
	"Private - Invoke the BindToFile() method of the COM object.

		HRESULT __stdcall BindToFile(
			unsigned short* pszFileName,
			SPFILEMODE eMode,
			GUID* pFormatId,
			WaveFormatEx* pWaveFormatEx,
			unsigned __int64 ullEventInterest);"

	<virtual stdcall: hresult 18 word* sdword GUID* WaveFormatEx* qword>
	^self invalidCall
!

close
	"Invoke the Close() method of the COM object."

	^self Close
!

Close
	"Private - Invoke the Close() method of the COM object.

		HRESULT __stdcall Close();"

	<virtual stdcall: hresult 19>
	^self invalidCall
!

getBaseStream: ppStream
	"Invoke the GetBaseStream() method of the COM object."

	^self GetBaseStream: ppStream
!

GetBaseStream: ppStream
	"Private - Invoke the GetBaseStream() method of the COM object.

		HRESULT __stdcall GetBaseStream(
			IStream** ppStream);"

	<virtual stdcall: hresult 17 IStream**>
	^self invalidCall
!

setBaseStream: pStream rguidFormat: rguidFormat pWaveFormatEx: pWaveFormatEx
	"Invoke the SetBaseStream() method of the COM object."

	^self
		SetBaseStream: pStream
		rguidFormat: rguidFormat
		pWaveFormatEx: pWaveFormatEx
!

SetBaseStream: pStream rguidFormat: rguidFormat pWaveFormatEx: pWaveFormatEx
	"Private - Invoke the SetBaseStream() method of the COM object.

		HRESULT __stdcall SetBaseStream(
			IStream* pStream,
			GUID* rguidFormat,
			WaveFormatEx* pWaveFormatEx);"

	<virtual stdcall: hresult 16 IStream* GUID* WaveFormatEx*>
	^self invalidCall
! !
!ISpStream categoriesFor: #bindToFile:eMode:pFormatId:pWaveFormatEx:ullEventInterest:!**auto generated**!methods!public! !
!ISpStream categoriesFor: #BindToFile:eMode:pFormatId:pWaveFormatEx:ullEventInterest:!**auto generated**!COM Interfaces-ISpStream!private! !
!ISpStream categoriesFor: #close!**auto generated**!methods!public! !
!ISpStream categoriesFor: #Close!**auto generated**!COM Interfaces-ISpStream!private! !
!ISpStream categoriesFor: #getBaseStream:!**auto generated**!methods!public! !
!ISpStream categoriesFor: #GetBaseStream:!**auto generated**!COM Interfaces-ISpStream!private! !
!ISpStream categoriesFor: #setBaseStream:rguidFormat:pWaveFormatEx:!**auto generated**!methods!public! !
!ISpStream categoriesFor: #SetBaseStream:rguidFormat:pWaveFormatEx:!**auto generated**!COM Interfaces-ISpStream!private! !

!ISpStream class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpStream) for which the receiver is the default interface."

	^CLSID fromString: '{715D9C59-4442-11D2-9605-00C04F8EE628}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpStream'
		ISpStream defineTemplate"

	self
		defineFunction: #SetBaseStream:rguidFormat:pWaveFormatEx:
			argumentTypes: 'IStream* GUID* WaveFormatEx*';
		defineFunction: #GetBaseStream:
			argumentTypes: 'IStream**';
		defineFunction: #BindToFile:eMode:pFormatId:pWaveFormatEx:ullEventInterest:
			argumentTypes: 'word* sdword GUID* WaveFormatEx* qword';
		defineFunction: #Close
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpStream initializeTypeLib"

	typeLib := SpeechLib! !
!ISpStream class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpStream class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpStream class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

