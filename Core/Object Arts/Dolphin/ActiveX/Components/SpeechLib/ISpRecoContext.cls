"Filed out from Dolphin Smalltalk 7"!

ISpEventSource subclass: #ISpRecoContext
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpRecoContext guid: (IID fromString: '{F740A62F-7C15-489E-8234-940A33D9272D}')!
ISpRecoContext comment: '<ISpRecoContext> is a wrapper class for the COM interface ''SpeechLib.ISpRecoContext'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpRecoContext Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(F740A62F-7C15-489E-8234-940A33D9272D), 
	helpstring("ISpRecoContext Interface"), 
	restricted
]
interface ISpRecoContext : ISpEventSource {
	[id(0x60030000)]
	HRESULT __stdcall GetRecognizer(
		[out] ISpRecognizer** ppRecognizer);
	[id(0x60030001)]
	HRESULT __stdcall CreateGrammar(
		[in] unsigned __int64 ullGrammarID,
		[out] ISpRecoGrammar** ppGrammar);
	[id(0x60030002)]
	HRESULT __stdcall GetStatus(
		[out] SPRECOCONTEXTSTATUS* pStatus);
	[id(0x60030003)]
	HRESULT __stdcall GetMaxAlternates(
		[in] unsigned long* pcAlternates);
	[id(0x60030004)]
	HRESULT __stdcall SetMaxAlternates(
		[in] unsigned long cAlternates);
	[id(0x60030005)]
	HRESULT __stdcall SetAudioOptions(
		[in] SPAUDIOOPTIONS Options,
		[in] GUID* pAudioFormatId,
		[in] WaveFormatEx* pWaveFormatEx);
	[id(0x60030006)]
	HRESULT __stdcall GetAudioOptions(
		[in] SPAUDIOOPTIONS* pOptions,
		[out] GUID* pAudioFormatId,
		[out] WaveFormatEx** ppCoMemWFEX);
	[id(0x60030007)]
	HRESULT __stdcall DeserializeResult(
		[in] SPSERIALIZEDRESULT* pSerializedResult,
		[out] ISpRecoResult** ppResult);
	[id(0x60030008)]
	HRESULT __stdcall Bookmark(
		[in] SPBOOKMARKOPTIONS Options,
		[in] unsigned __int64 ullStreamPosition,
		[in] LONG_PTR lparamEvent);
	[id(0x60030009)]
	HRESULT __stdcall SetAdaptationData(
		[in] LPWSTR pAdaptationData,
		[in] unsigned long cch);
	[id(0x6003000a)]
	HRESULT __stdcall Pause(
		unsigned long dwReserved);
	[id(0x6003000b)]
	HRESULT __stdcall Resume(
		unsigned long dwReserved);
	[id(0x6003000c)]
	HRESULT __stdcall SetVoice(
		[in] ISpVoice* pVoice,
		[in] long fAllowFormatChanges);
	[id(0x6003000d)]
	HRESULT __stdcall GetVoice(
		[out] ISpVoice** ppVoice);
	[id(0x6003000e)]
	HRESULT __stdcall SetVoicePurgeEvent(
		[in] unsigned __int64 ullEventInterest);
	[id(0x6003000f)]
	HRESULT __stdcall GetVoicePurgeEvent(
		[out] unsigned __int64* pullEventInterest);
	[id(0x60030010)]
	HRESULT __stdcall SetContextState(
		[in] SPCONTEXTSTATE eContextState);
	[id(0x60030011)]
	HRESULT __stdcall GetContextState(
		[in] SPCONTEXTSTATE* peContextState);
};
'!
!ISpRecoContext categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpRecoContext methodsFor!

bookmark: options ullStreamPosition: ullStreamPosition lparamEvent: lparamEvent
	"Invoke the Bookmark() method of the COM object."

	^self
		Bookmark: options
		ullStreamPosition: ullStreamPosition
		lparamEvent: lparamEvent
!

Bookmark: options ullStreamPosition: ullStreamPosition lparamEvent: lparamEvent
	"Private - Invoke the Bookmark() method of the COM object.

		HRESULT __stdcall Bookmark(
			[in] SPBOOKMARKOPTIONS Options,
			[in] unsigned __int64 ullStreamPosition,
			[in] LONG_PTR lparamEvent);"

	<virtual stdcall: hresult 22 sdword qword sdword>
	^self invalidCall
!

createGrammar: ullGrammarID
	"Answer the <ISpRecoGrammar> result of invoking the CreateGrammar() method of the COM object."

	| answer |
	answer := ISpRecoGrammar newPointer.
	self
		CreateGrammar: ullGrammarID
		ppGrammar: answer.
	^answer asObject
!

CreateGrammar: ullGrammarID ppGrammar: ppGrammar
	"Private - Invoke the CreateGrammar() method of the COM object.

		HRESULT __stdcall CreateGrammar(
			[in] unsigned __int64 ullGrammarID,
			[out] ISpRecoGrammar** ppGrammar);"

	<virtual stdcall: hresult 15 qword ISpRecoGrammar**>
	^self invalidCall
!

deserializeResult: pSerializedResult
	"Answer the <ISpRecoResult> result of invoking the DeserializeResult() method of the COM object."

	| answer |
	answer := ISpRecoResult newPointer.
	self
		DeserializeResult: pSerializedResult
		ppResult: answer.
	^answer asObject
!

DeserializeResult: pSerializedResult ppResult: ppResult
	"Private - Invoke the DeserializeResult() method of the COM object.

		HRESULT __stdcall DeserializeResult(
			[in] SPSERIALIZEDRESULT* pSerializedResult,
			[out] ISpRecoResult** ppResult);"

	<virtual stdcall: hresult 21 SPSERIALIZEDRESULT* ISpRecoResult**>
	^self invalidCall
!

getAudioOptions: pOptions
	"Invoke the GetAudioOptions() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: GUID new;
				basicAt: 2 put: (WaveFormatEx newBufferClass: COMTaskMemory);
				yourself.
	self
		GetAudioOptions: pOptions
		pAudioFormatId: (answer basicAt: 1)
		ppCoMemWFEX: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetAudioOptions: pOptions pAudioFormatId: pAudioFormatId ppCoMemWFEX: ppCoMemWFEX
	"Private - Invoke the GetAudioOptions() method of the COM object.

		HRESULT __stdcall GetAudioOptions(
			[in] SPAUDIOOPTIONS* pOptions,
			[out] GUID* pAudioFormatId,
			[out] WaveFormatEx** ppCoMemWFEX);"

	<virtual stdcall: hresult 20 sdword* GUID* WaveFormatEx**>
	^self invalidCall
!

getContextState: peContextState
	"Invoke the GetContextState() method of the COM object."

	^self GetContextState: peContextState
!

GetContextState: peContextState
	"Private - Invoke the GetContextState() method of the COM object.

		HRESULT __stdcall GetContextState(
			[in] SPCONTEXTSTATE* peContextState);"

	<virtual stdcall: hresult 31 sdword*>
	^self invalidCall
!

getMaxAlternates: pcAlternates
	"Invoke the GetMaxAlternates() method of the COM object."

	^self GetMaxAlternates: pcAlternates
!

GetMaxAlternates: pcAlternates
	"Private - Invoke the GetMaxAlternates() method of the COM object.

		HRESULT __stdcall GetMaxAlternates(
			[in] unsigned long* pcAlternates);"

	<virtual stdcall: hresult 17 dword*>
	^self invalidCall
!

getRecognizer
	"Answer the <ISpRecognizer> result of invoking the GetRecognizer() method of the COM object."

	| answer |
	answer := ISpRecognizer newPointer.
	self GetRecognizer: answer.
	^answer asObject
!

GetRecognizer: ppRecognizer
	"Private - Invoke the GetRecognizer() method of the COM object.

		HRESULT __stdcall GetRecognizer(
			[out] ISpRecognizer** ppRecognizer);"

	<virtual stdcall: hresult 14 ISpRecognizer**>
	^self invalidCall
!

getStatus
	"Answer the <SPRECOCONTEXTSTATUS> result of invoking the GetStatus() method of the COM object."

	| answer |
	answer := (SPRECOCONTEXTSTATUS new).
	self GetStatus: answer.
	^answer asObject
!

GetStatus: pStatus
	"Private - Invoke the GetStatus() method of the COM object.

		HRESULT __stdcall GetStatus(
			[out] SPRECOCONTEXTSTATUS* pStatus);"

	<virtual stdcall: hresult 16 SPRECOCONTEXTSTATUS*>
	^self invalidCall
!

getVoice
	"Answer the <ISpVoice> result of invoking the GetVoice() method of the COM object."

	| answer |
	answer := ISpVoice newPointer.
	self GetVoice: answer.
	^answer asObject
!

GetVoice: ppVoice
	"Private - Invoke the GetVoice() method of the COM object.

		HRESULT __stdcall GetVoice(
			[out] ISpVoice** ppVoice);"

	<virtual stdcall: hresult 27 ISpVoice**>
	^self invalidCall
!

getVoicePurgeEvent
	"Answer the <ULARGE_INTEGER> result of invoking the GetVoicePurgeEvent() method of the COM object."

	| answer |
	answer := (ULARGE_INTEGER new).
	self GetVoicePurgeEvent: answer.
	^answer asObject
!

GetVoicePurgeEvent: pullEventInterest
	"Private - Invoke the GetVoicePurgeEvent() method of the COM object.

		HRESULT __stdcall GetVoicePurgeEvent(
			[out] unsigned __int64* pullEventInterest);"

	<virtual stdcall: hresult 29 qword*>
	^self invalidCall
!

pause: dwReserved
	"Invoke the Pause() method of the COM object."

	^self Pause: dwReserved
!

Pause: dwReserved
	"Private - Invoke the Pause() method of the COM object.

		HRESULT __stdcall Pause(
			unsigned long dwReserved);"

	<virtual stdcall: hresult 24 dword>
	^self invalidCall
!

resume: dwReserved
	"Invoke the Resume() method of the COM object."

	^self Resume: dwReserved
!

Resume: dwReserved
	"Private - Invoke the Resume() method of the COM object.

		HRESULT __stdcall Resume(
			unsigned long dwReserved);"

	<virtual stdcall: hresult 25 dword>
	^self invalidCall
!

setAdaptationData: pAdaptationData cch: cch
	"Invoke the SetAdaptationData() method of the COM object."

	^self
		SetAdaptationData: pAdaptationData asUnicodeString
		cch: cch
!

SetAdaptationData: pAdaptationData cch: cch
	"Private - Invoke the SetAdaptationData() method of the COM object.

		HRESULT __stdcall SetAdaptationData(
			[in] LPWSTR pAdaptationData,
			[in] unsigned long cch);"

	<virtual stdcall: hresult 23 lpwstr dword>
	^self invalidCall
!

setAudioOptions: options pAudioFormatId: pAudioFormatId pWaveFormatEx: pWaveFormatEx
	"Invoke the SetAudioOptions() method of the COM object."

	^self
		SetAudioOptions: options
		pAudioFormatId: pAudioFormatId
		pWaveFormatEx: pWaveFormatEx
!

SetAudioOptions: options pAudioFormatId: pAudioFormatId pWaveFormatEx: pWaveFormatEx
	"Private - Invoke the SetAudioOptions() method of the COM object.

		HRESULT __stdcall SetAudioOptions(
			[in] SPAUDIOOPTIONS Options,
			[in] GUID* pAudioFormatId,
			[in] WaveFormatEx* pWaveFormatEx);"

	<virtual stdcall: hresult 19 sdword GUID* WaveFormatEx*>
	^self invalidCall
!

setContextState: eContextState
	"Invoke the SetContextState() method of the COM object."

	^self SetContextState: eContextState
!

SetContextState: eContextState
	"Private - Invoke the SetContextState() method of the COM object.

		HRESULT __stdcall SetContextState(
			[in] SPCONTEXTSTATE eContextState);"

	<virtual stdcall: hresult 30 sdword>
	^self invalidCall
!

setMaxAlternates: cAlternates
	"Invoke the SetMaxAlternates() method of the COM object."

	^self SetMaxAlternates: cAlternates
!

SetMaxAlternates: cAlternates
	"Private - Invoke the SetMaxAlternates() method of the COM object.

		HRESULT __stdcall SetMaxAlternates(
			[in] unsigned long cAlternates);"

	<virtual stdcall: hresult 18 dword>
	^self invalidCall
!

setVoice: pVoice fAllowFormatChanges: fAllowFormatChanges
	"Invoke the SetVoice() method of the COM object."

	^self
		SetVoice: pVoice
		fAllowFormatChanges: fAllowFormatChanges
!

SetVoice: pVoice fAllowFormatChanges: fAllowFormatChanges
	"Private - Invoke the SetVoice() method of the COM object.

		HRESULT __stdcall SetVoice(
			[in] ISpVoice* pVoice,
			[in] long fAllowFormatChanges);"

	<virtual stdcall: hresult 26 ISpVoice* sdword>
	^self invalidCall
!

setVoicePurgeEvent: ullEventInterest
	"Invoke the SetVoicePurgeEvent() method of the COM object."

	^self SetVoicePurgeEvent: ullEventInterest
!

SetVoicePurgeEvent: ullEventInterest
	"Private - Invoke the SetVoicePurgeEvent() method of the COM object.

		HRESULT __stdcall SetVoicePurgeEvent(
			[in] unsigned __int64 ullEventInterest);"

	<virtual stdcall: hresult 28 qword>
	^self invalidCall
! !
!ISpRecoContext categoriesFor: #bookmark:ullStreamPosition:lparamEvent:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #Bookmark:ullStreamPosition:lparamEvent:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #createGrammar:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #CreateGrammar:ppGrammar:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #deserializeResult:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #DeserializeResult:ppResult:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #getAudioOptions:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #GetAudioOptions:pAudioFormatId:ppCoMemWFEX:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #getContextState:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #GetContextState:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #getMaxAlternates:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #GetMaxAlternates:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #getRecognizer!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #GetRecognizer:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #getStatus!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #GetStatus:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #getVoice!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #GetVoice:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #getVoicePurgeEvent!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #GetVoicePurgeEvent:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #pause:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #Pause:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #resume:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #Resume:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #setAdaptationData:cch:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #SetAdaptationData:cch:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #setAudioOptions:pAudioFormatId:pWaveFormatEx:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #SetAudioOptions:pAudioFormatId:pWaveFormatEx:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #setContextState:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #SetContextState:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #setMaxAlternates:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #SetMaxAlternates:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #setVoice:fAllowFormatChanges:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #SetVoice:fAllowFormatChanges:!**auto generated**!COM Interfaces-ISpRecoContext!private! !
!ISpRecoContext categoriesFor: #setVoicePurgeEvent:!**auto generated**!methods!public! !
!ISpRecoContext categoriesFor: #SetVoicePurgeEvent:!**auto generated**!COM Interfaces-ISpRecoContext!private! !

!ISpRecoContext class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpRecoContext'
		ISpRecoContext defineTemplate"

	self
		defineFunction: #GetRecognizer:
			argumentTypes: 'ISpRecognizer**';
		defineFunction: #CreateGrammar:ppGrammar:
			argumentTypes: 'qword ISpRecoGrammar**';
		defineFunction: #GetStatus:
			argumentTypes: 'SPRECOCONTEXTSTATUS*';
		defineFunction: #GetMaxAlternates:
			argumentTypes: 'dword*';
		defineFunction: #SetMaxAlternates:
			argumentTypes: 'dword';
		defineFunction: #SetAudioOptions:pAudioFormatId:pWaveFormatEx:
			argumentTypes: 'sdword GUID* WaveFormatEx*';
		defineFunction: #GetAudioOptions:pAudioFormatId:ppCoMemWFEX:
			argumentTypes: 'sdword* GUID* WaveFormatEx**';
		defineFunction: #DeserializeResult:ppResult:
			argumentTypes: 'SPSERIALIZEDRESULT* ISpRecoResult**';
		defineFunction: #Bookmark:ullStreamPosition:lparamEvent:
			argumentTypes: 'sdword qword sdword';
		defineFunction: #SetAdaptationData:cch:
			argumentTypes: 'lpwstr dword';
		defineFunction: #Pause:
			argumentTypes: 'dword';
		defineFunction: #Resume:
			argumentTypes: 'dword';
		defineFunction: #SetVoice:fAllowFormatChanges:
			argumentTypes: 'ISpVoice* sdword';
		defineFunction: #GetVoice:
			argumentTypes: 'ISpVoice**';
		defineFunction: #SetVoicePurgeEvent:
			argumentTypes: 'qword';
		defineFunction: #GetVoicePurgeEvent:
			argumentTypes: 'qword*';
		defineFunction: #SetContextState:
			argumentTypes: 'sdword';
		defineFunction: #GetContextState:
			argumentTypes: 'sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpRecoContext initializeTypeLib"

	typeLib := SpeechLib! !
!ISpRecoContext class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpRecoContext class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

