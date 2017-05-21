"Filed out from Dolphin Smalltalk 7"!

ISpPhrase subclass: #ISpRecoResult
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpRecoResult guid: (IID fromString: '{20B053BE-E235-43CD-9A2A-8D17A48B7842}')!
ISpRecoResult comment: '<ISpRecoResult> is a wrapper class for the COM interface ''SpeechLib.ISpRecoResult'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpRecoResult Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(20B053BE-E235-43CD-9A2A-8D17A48B7842), 
	helpstring("ISpRecoResult Interface"), 
	restricted
]
interface ISpRecoResult : ISpPhrase {
	[id(0x60020000)]
	HRESULT __stdcall GetResultTimes(
		[out] SPRECORESULTTIMES* pTimes);
	[id(0x60020001)]
	HRESULT __stdcall GetAlternates(
		[in] unsigned long ulStartElement,
		[in] unsigned long cElements,
		[in] unsigned long ulRequestCount,
		[out] ISpPhraseAlt** ppPhrases,
		[out] unsigned long* pcPhrasesReturned);
	[id(0x60020002)]
	HRESULT __stdcall GetAudio(
		[in] unsigned long ulStartElement,
		[in] unsigned long cElements,
		[out] ISpStreamFormat** ppStream);
	[id(0x60020003)]
	HRESULT __stdcall SpeakAudio(
		[in] unsigned long ulStartElement,
		[in] unsigned long cElements,
		[in] unsigned long dwFlags,
		[out] unsigned long* pulStreamNumber);
	[id(0x60020004)]
	HRESULT __stdcall Serialize(
		[out] SPSERIALIZEDRESULT** ppCoMemSerializedResult);
	[id(0x60020005)]
	HRESULT __stdcall ScaleAudio(
		[in] GUID* pAudioFormatId,
		[in] WaveFormatEx* pWaveFormatEx);
	[id(0x60020006)]
	HRESULT __stdcall GetRecoContext(
		[out] ISpRecoContext** ppRecoContext);
};
'!
!ISpRecoResult categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpRecoResult methodsFor!

getAlternates: ulStartElement cElements: cElements ulRequestCount: ulRequestCount
	"Invoke the GetAlternates() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: ISpPhraseAlt newPointer;
				basicAt: 2 put: (DWORD new);
				yourself.
	self
		GetAlternates: ulStartElement
		cElements: cElements
		ulRequestCount: ulRequestCount
		ppPhrases: (answer basicAt: 1)
		pcPhrasesReturned: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetAlternates: ulStartElement cElements: cElements ulRequestCount: ulRequestCount ppPhrases: ppPhrases pcPhrasesReturned: pcPhrasesReturned
	"Private - Invoke the GetAlternates() method of the COM object.

		HRESULT __stdcall GetAlternates(
			[in] unsigned long ulStartElement,
			[in] unsigned long cElements,
			[in] unsigned long ulRequestCount,
			[out] ISpPhraseAlt** ppPhrases,
			[out] unsigned long* pcPhrasesReturned);"

	<virtual stdcall: hresult 9 dword dword dword ISpPhraseAlt** dword*>
	^self invalidCall
!

getAudio: ulStartElement cElements: cElements
	"Answer the <ISpStreamFormat> result of invoking the GetAudio() method of the COM object."

	| answer |
	answer := ISpStreamFormat newPointer.
	self
		GetAudio: ulStartElement
		cElements: cElements
		ppStream: answer.
	^answer asObject
!

GetAudio: ulStartElement cElements: cElements ppStream: ppStream
	"Private - Invoke the GetAudio() method of the COM object.

		HRESULT __stdcall GetAudio(
			[in] unsigned long ulStartElement,
			[in] unsigned long cElements,
			[out] ISpStreamFormat** ppStream);"

	<virtual stdcall: hresult 10 dword dword ISpStreamFormat**>
	^self invalidCall
!

getRecoContext
	"Answer the <ISpRecoContext> result of invoking the GetRecoContext() method of the COM object."

	| answer |
	answer := ISpRecoContext newPointer.
	self GetRecoContext: answer.
	^answer asObject
!

GetRecoContext: ppRecoContext
	"Private - Invoke the GetRecoContext() method of the COM object.

		HRESULT __stdcall GetRecoContext(
			[out] ISpRecoContext** ppRecoContext);"

	<virtual stdcall: hresult 14 ISpRecoContext**>
	^self invalidCall
!

getResultTimes
	"Answer the <SPRECORESULTTIMES> result of invoking the GetResultTimes() method of the COM object."

	| answer |
	answer := (SPRECORESULTTIMES new).
	self GetResultTimes: answer.
	^answer asObject
!

GetResultTimes: pTimes
	"Private - Invoke the GetResultTimes() method of the COM object.

		HRESULT __stdcall GetResultTimes(
			[out] SPRECORESULTTIMES* pTimes);"

	<virtual stdcall: hresult 8 SPRECORESULTTIMES*>
	^self invalidCall
!

scaleAudio: pAudioFormatId pWaveFormatEx: pWaveFormatEx
	"Invoke the ScaleAudio() method of the COM object."

	^self
		ScaleAudio: pAudioFormatId
		pWaveFormatEx: pWaveFormatEx
!

ScaleAudio: pAudioFormatId pWaveFormatEx: pWaveFormatEx
	"Private - Invoke the ScaleAudio() method of the COM object.

		HRESULT __stdcall ScaleAudio(
			[in] GUID* pAudioFormatId,
			[in] WaveFormatEx* pWaveFormatEx);"

	<virtual stdcall: hresult 13 GUID* WaveFormatEx*>
	^self invalidCall
!

serialize
	"Answer the <SPSERIALIZEDRESULT> result of invoking the Serialize() method of the COM object."

	| answer |
	answer := (SPSERIALIZEDRESULT newBufferClass: COMTaskMemory).
	self Serialize: answer.
	^answer asObject
!

Serialize: ppCoMemSerializedResult
	"Private - Invoke the Serialize() method of the COM object.

		HRESULT __stdcall Serialize(
			[out] SPSERIALIZEDRESULT** ppCoMemSerializedResult);"

	<virtual stdcall: hresult 12 SPSERIALIZEDRESULT**>
	^self invalidCall
!

speakAudio: ulStartElement cElements: cElements dwFlags: dwFlags
	"Answer the <DWORD> result of invoking the SpeakAudio() method of the COM object."

	| answer |
	answer := (DWORD new).
	self
		SpeakAudio: ulStartElement
		cElements: cElements
		dwFlags: dwFlags
		pulStreamNumber: answer.
	^answer asObject
!

SpeakAudio: ulStartElement cElements: cElements dwFlags: dwFlags pulStreamNumber: pulStreamNumber
	"Private - Invoke the SpeakAudio() method of the COM object.

		HRESULT __stdcall SpeakAudio(
			[in] unsigned long ulStartElement,
			[in] unsigned long cElements,
			[in] unsigned long dwFlags,
			[out] unsigned long* pulStreamNumber);"

	<virtual stdcall: hresult 11 dword dword dword dword*>
	^self invalidCall
! !
!ISpRecoResult categoriesFor: #getAlternates:cElements:ulRequestCount:!**auto generated**!methods!public! !
!ISpRecoResult categoriesFor: #GetAlternates:cElements:ulRequestCount:ppPhrases:pcPhrasesReturned:!**auto generated**!COM Interfaces-ISpRecoResult!private! !
!ISpRecoResult categoriesFor: #getAudio:cElements:!**auto generated**!methods!public! !
!ISpRecoResult categoriesFor: #GetAudio:cElements:ppStream:!**auto generated**!COM Interfaces-ISpRecoResult!private! !
!ISpRecoResult categoriesFor: #getRecoContext!**auto generated**!methods!public! !
!ISpRecoResult categoriesFor: #GetRecoContext:!**auto generated**!COM Interfaces-ISpRecoResult!private! !
!ISpRecoResult categoriesFor: #getResultTimes!**auto generated**!methods!public! !
!ISpRecoResult categoriesFor: #GetResultTimes:!**auto generated**!COM Interfaces-ISpRecoResult!private! !
!ISpRecoResult categoriesFor: #scaleAudio:pWaveFormatEx:!**auto generated**!methods!public! !
!ISpRecoResult categoriesFor: #ScaleAudio:pWaveFormatEx:!**auto generated**!COM Interfaces-ISpRecoResult!private! !
!ISpRecoResult categoriesFor: #serialize!**auto generated**!methods!public! !
!ISpRecoResult categoriesFor: #Serialize:!**auto generated**!COM Interfaces-ISpRecoResult!private! !
!ISpRecoResult categoriesFor: #speakAudio:cElements:dwFlags:!**auto generated**!methods!public! !
!ISpRecoResult categoriesFor: #SpeakAudio:cElements:dwFlags:pulStreamNumber:!**auto generated**!COM Interfaces-ISpRecoResult!private! !

!ISpRecoResult class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpRecoResult'
		ISpRecoResult defineTemplate"

	self
		defineFunction: #GetResultTimes:
			argumentTypes: 'SPRECORESULTTIMES*';
		defineFunction: #GetAlternates:cElements:ulRequestCount:ppPhrases:pcPhrasesReturned:
			argumentTypes: 'dword dword dword ISpPhraseAlt** dword*';
		defineFunction: #GetAudio:cElements:ppStream:
			argumentTypes: 'dword dword ISpStreamFormat**';
		defineFunction: #SpeakAudio:cElements:dwFlags:pulStreamNumber:
			argumentTypes: 'dword dword dword dword*';
		defineFunction: #Serialize:
			argumentTypes: 'SPSERIALIZEDRESULT**';
		defineFunction: #ScaleAudio:pWaveFormatEx:
			argumentTypes: 'GUID* WaveFormatEx*';
		defineFunction: #GetRecoContext:
			argumentTypes: 'ISpRecoContext**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpRecoResult initializeTypeLib"

	typeLib := SpeechLib! !
!ISpRecoResult class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpRecoResult class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

