"Filed out from Dolphin Smalltalk X6"!

ISpProperties subclass: #ISpRecognizer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpRecognizer guid: (IID fromString: '{C2B5F241-DAA0-4507-9E16-5A1EAA2B7A5C}')!
ISpRecognizer comment: '<ISpRecognizer> is a wrapper class for the COM interface ''SpeechLib.ISpRecognizer'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpRecognizer Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(C2B5F241-DAA0-4507-9E16-5A1EAA2B7A5C), 
	helpstring("ISpRecognizer Interface"), 
	restricted
]
interface ISpRecognizer : ISpProperties {
	[id(0x60020000)]
	HRESULT __stdcall SetRecognizer(
		[in] ISpObjectToken* pRecognizer);
	[id(0x60020001)]
	HRESULT __stdcall GetRecognizer(
		[out] ISpObjectToken** ppRecognizer);
	[id(0x60020002)]
	HRESULT __stdcall SetInput(
		[in] IUnknown* pUnkInput,
		[in] long fAllowFormatChanges);
	[id(0x60020003)]
	HRESULT __stdcall GetInputObjectToken(
		[out] ISpObjectToken** ppToken);
	[id(0x60020004)]
	HRESULT __stdcall GetInputStream(
		[out] ISpStreamFormat** ppStream);
	[id(0x60020005)]
	HRESULT __stdcall CreateRecoContext(
		[out] ISpRecoContext** ppNewCtxt);
	[id(0x60020006)]
	HRESULT __stdcall GetRecoProfile(
		[out] ISpObjectToken** ppToken);
	[id(0x60020007)]
	HRESULT __stdcall SetRecoProfile(
		[in] ISpObjectToken* pToken);
	[id(0x60020008)]
	HRESULT __stdcall IsSharedInstance();
	[id(0x60020009)]
	HRESULT __stdcall GetRecoState(
		[out] SPRECOSTATE* pState);
	[id(0x6002000a)]
	HRESULT __stdcall SetRecoState(
		[in] SPRECOSTATE NewState);
	[id(0x6002000b)]
	HRESULT __stdcall GetStatus(
		[out] SPRECOGNIZERSTATUS* pStatus);
	[id(0x6002000c)]
	HRESULT __stdcall GetFormat(
		[in] SPSTREAMFORMATTYPE WaveFormatType,
		[out] GUID* pFormatId,
		[out] WaveFormatEx** ppCoMemWFEX);
	[id(0x6002000d)]
	HRESULT __stdcall IsUISupported(
		[in] unsigned short* pszTypeOfUI,
		[in] void* pvExtraData,
		[in] unsigned long cbExtraData,
		[out] long* pfSupported);
	[id(0x6002000e)]
	HRESULT __stdcall DisplayUI(
		[in] wireHWND hWndParent,
		[in] unsigned short* pszTitle,
		[in] unsigned short* pszTypeOfUI,
		[in] void* pvExtraData,
		[in] unsigned long cbExtraData);
	[id(0x6002000f)]
	HRESULT __stdcall EmulateRecognition(
		[in] ISpPhrase* pPhrase);
};
'!
!ISpRecognizer categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpRecognizer methodsFor!

createRecoContext
	"Answer the <ISpRecoContext> result of invoking the CreateRecoContext() method of the COM object."

	| answer |
	answer := ISpRecoContext newPointer.
	self CreateRecoContext: answer.
	^answer asObject
!

CreateRecoContext: ppNewCtxt
	"Private - Invoke the CreateRecoContext() method of the COM object.

		HRESULT __stdcall CreateRecoContext(
			[out] ISpRecoContext** ppNewCtxt);"

	<virtual stdcall: hresult 13 ISpRecoContext**>
	^self invalidCall
!

displayUI: hWndParent pszTitle: pszTitle pszTypeOfUI: pszTypeOfUI pvExtraData: pvExtraData cbExtraData: cbExtraData
	"Invoke the DisplayUI() method of the COM object."

	^self
		DisplayUI: hWndParent
		pszTitle: pszTitle
		pszTypeOfUI: pszTypeOfUI
		pvExtraData: pvExtraData
		cbExtraData: cbExtraData
!

DisplayUI: hWndParent pszTitle: pszTitle pszTypeOfUI: pszTypeOfUI pvExtraData: pvExtraData cbExtraData: cbExtraData
	"Private - Invoke the DisplayUI() method of the COM object.

		HRESULT __stdcall DisplayUI(
			[in] wireHWND hWndParent,
			[in] unsigned short* pszTitle,
			[in] unsigned short* pszTypeOfUI,
			[in] void* pvExtraData,
			[in] unsigned long cbExtraData);"

	<virtual stdcall: hresult 22 handle* word* word* void* dword>
	^self invalidCall
!

emulateRecognition: pPhrase
	"Invoke the EmulateRecognition() method of the COM object."

	^self EmulateRecognition: pPhrase
!

EmulateRecognition: pPhrase
	"Private - Invoke the EmulateRecognition() method of the COM object.

		HRESULT __stdcall EmulateRecognition(
			[in] ISpPhrase* pPhrase);"

	<virtual stdcall: hresult 23 ISpPhrase*>
	^self invalidCall
!

getFormat: waveFormatType
	"Invoke the GetFormat() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: GUID new;
				basicAt: 2 put: (WaveFormatEx newBufferClass: COMTaskMemory);
				yourself.
	self
		GetFormat: waveFormatType
		pFormatId: (answer basicAt: 1)
		ppCoMemWFEX: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetFormat: waveFormatType pFormatId: pFormatId ppCoMemWFEX: ppCoMemWFEX
	"Private - Invoke the GetFormat() method of the COM object.

		HRESULT __stdcall GetFormat(
			[in] SPSTREAMFORMATTYPE WaveFormatType,
			[out] GUID* pFormatId,
			[out] WaveFormatEx** ppCoMemWFEX);"

	<virtual stdcall: hresult 20 sdword GUID* WaveFormatEx**>
	^self invalidCall
!

getInputObjectToken
	"Answer the <ISpObjectToken> result of invoking the GetInputObjectToken() method of the COM object."

	| answer |
	answer := ISpObjectToken newPointer.
	self GetInputObjectToken: answer.
	^answer asObject
!

GetInputObjectToken: ppToken
	"Private - Invoke the GetInputObjectToken() method of the COM object.

		HRESULT __stdcall GetInputObjectToken(
			[out] ISpObjectToken** ppToken);"

	<virtual stdcall: hresult 11 ISpObjectToken**>
	^self invalidCall
!

getInputStream
	"Answer the <ISpStreamFormat> result of invoking the GetInputStream() method of the COM object."

	| answer |
	answer := ISpStreamFormat newPointer.
	self GetInputStream: answer.
	^answer asObject
!

GetInputStream: ppStream
	"Private - Invoke the GetInputStream() method of the COM object.

		HRESULT __stdcall GetInputStream(
			[out] ISpStreamFormat** ppStream);"

	<virtual stdcall: hresult 12 ISpStreamFormat**>
	^self invalidCall
!

getRecognizer
	"Answer the <ISpObjectToken> result of invoking the GetRecognizer() method of the COM object."

	| answer |
	answer := ISpObjectToken newPointer.
	self GetRecognizer: answer.
	^answer asObject
!

GetRecognizer: ppRecognizer
	"Private - Invoke the GetRecognizer() method of the COM object.

		HRESULT __stdcall GetRecognizer(
			[out] ISpObjectToken** ppRecognizer);"

	<virtual stdcall: hresult 9 ISpObjectToken**>
	^self invalidCall
!

getRecoProfile
	"Answer the <ISpObjectToken> result of invoking the GetRecoProfile() method of the COM object."

	| answer |
	answer := ISpObjectToken newPointer.
	self GetRecoProfile: answer.
	^answer asObject
!

GetRecoProfile: ppToken
	"Private - Invoke the GetRecoProfile() method of the COM object.

		HRESULT __stdcall GetRecoProfile(
			[out] ISpObjectToken** ppToken);"

	<virtual stdcall: hresult 14 ISpObjectToken**>
	^self invalidCall
!

getRecoState
	"Answer the <SDWORD> result of invoking the GetRecoState() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self GetRecoState: answer.
	^answer asObject
!

GetRecoState: pState
	"Private - Invoke the GetRecoState() method of the COM object.

		HRESULT __stdcall GetRecoState(
			[out] SPRECOSTATE* pState);"

	<virtual stdcall: hresult 17 sdword*>
	^self invalidCall
!

getStatus
	"Answer the <SPRECOGNIZERSTATUS> result of invoking the GetStatus() method of the COM object."

	| answer |
	answer := (SPRECOGNIZERSTATUS new).
	self GetStatus: answer.
	^answer asObject
!

GetStatus: pStatus
	"Private - Invoke the GetStatus() method of the COM object.

		HRESULT __stdcall GetStatus(
			[out] SPRECOGNIZERSTATUS* pStatus);"

	<virtual stdcall: hresult 19 SPRECOGNIZERSTATUS*>
	^self invalidCall
!

isSharedInstance
	"Invoke the IsSharedInstance() method of the COM object."

	^self IsSharedInstance
!

IsSharedInstance
	"Private - Invoke the IsSharedInstance() method of the COM object.

		HRESULT __stdcall IsSharedInstance();"

	<virtual stdcall: hresult 16>
	^self invalidCall
!

isUISupported: pszTypeOfUI pvExtraData: pvExtraData cbExtraData: cbExtraData
	"Answer the <SDWORD> result of invoking the IsUISupported() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		IsUISupported: pszTypeOfUI
		pvExtraData: pvExtraData
		cbExtraData: cbExtraData
		pfSupported: answer.
	^answer asObject
!

IsUISupported: pszTypeOfUI pvExtraData: pvExtraData cbExtraData: cbExtraData pfSupported: pfSupported
	"Private - Invoke the IsUISupported() method of the COM object.

		HRESULT __stdcall IsUISupported(
			[in] unsigned short* pszTypeOfUI,
			[in] void* pvExtraData,
			[in] unsigned long cbExtraData,
			[out] long* pfSupported);"

	<virtual stdcall: hresult 21 word* void* dword sdword*>
	^self invalidCall
!

setInput: pUnkInput fAllowFormatChanges: fAllowFormatChanges
	"Invoke the SetInput() method of the COM object."

	^self
		SetInput: pUnkInput
		fAllowFormatChanges: fAllowFormatChanges
!

SetInput: pUnkInput fAllowFormatChanges: fAllowFormatChanges
	"Private - Invoke the SetInput() method of the COM object.

		HRESULT __stdcall SetInput(
			[in] IUnknown* pUnkInput,
			[in] long fAllowFormatChanges);"

	<virtual stdcall: hresult 10 IUnknown* sdword>
	^self invalidCall
!

setRecognizer: pRecognizer
	"Invoke the SetRecognizer() method of the COM object."

	^self SetRecognizer: pRecognizer
!

SetRecognizer: pRecognizer
	"Private - Invoke the SetRecognizer() method of the COM object.

		HRESULT __stdcall SetRecognizer(
			[in] ISpObjectToken* pRecognizer);"

	<virtual stdcall: hresult 8 ISpObjectToken*>
	^self invalidCall
!

setRecoProfile: pToken
	"Invoke the SetRecoProfile() method of the COM object."

	^self SetRecoProfile: pToken
!

SetRecoProfile: pToken
	"Private - Invoke the SetRecoProfile() method of the COM object.

		HRESULT __stdcall SetRecoProfile(
			[in] ISpObjectToken* pToken);"

	<virtual stdcall: hresult 15 ISpObjectToken*>
	^self invalidCall
!

setRecoState: newState
	"Invoke the SetRecoState() method of the COM object."

	^self SetRecoState: newState
!

SetRecoState: newState
	"Private - Invoke the SetRecoState() method of the COM object.

		HRESULT __stdcall SetRecoState(
			[in] SPRECOSTATE NewState);"

	<virtual stdcall: hresult 18 sdword>
	^self invalidCall
! !
!ISpRecognizer categoriesFor: #createRecoContext!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #CreateRecoContext:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #displayUI:pszTitle:pszTypeOfUI:pvExtraData:cbExtraData:!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #DisplayUI:pszTitle:pszTypeOfUI:pvExtraData:cbExtraData:!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #emulateRecognition:!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #EmulateRecognition:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #getFormat:!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #GetFormat:pFormatId:ppCoMemWFEX:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #getInputObjectToken!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #GetInputObjectToken:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #getInputStream!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #GetInputStream:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #getRecognizer!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #GetRecognizer:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #getRecoProfile!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #GetRecoProfile:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #getRecoState!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #GetRecoState:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #getStatus!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #GetStatus:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #isSharedInstance!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #IsSharedInstance!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #isUISupported:pvExtraData:cbExtraData:!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #IsUISupported:pvExtraData:cbExtraData:pfSupported:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #setInput:fAllowFormatChanges:!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #SetInput:fAllowFormatChanges:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #setRecognizer:!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #SetRecognizer:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #setRecoProfile:!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #SetRecoProfile:!**auto generated**!COM Interfaces-ISpRecognizer!private! !
!ISpRecognizer categoriesFor: #setRecoState:!**auto generated**!methods!public! !
!ISpRecognizer categoriesFor: #SetRecoState:!**auto generated**!COM Interfaces-ISpRecognizer!private! !

!ISpRecognizer class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpRecognizer'
		ISpRecognizer defineTemplate"

	self
		defineFunction: #SetRecognizer:
			argumentTypes: 'ISpObjectToken*';
		defineFunction: #GetRecognizer:
			argumentTypes: 'ISpObjectToken**';
		defineFunction: #SetInput:fAllowFormatChanges:
			argumentTypes: 'IUnknown* sdword';
		defineFunction: #GetInputObjectToken:
			argumentTypes: 'ISpObjectToken**';
		defineFunction: #GetInputStream:
			argumentTypes: 'ISpStreamFormat**';
		defineFunction: #CreateRecoContext:
			argumentTypes: 'ISpRecoContext**';
		defineFunction: #GetRecoProfile:
			argumentTypes: 'ISpObjectToken**';
		defineFunction: #SetRecoProfile:
			argumentTypes: 'ISpObjectToken*';
		defineFunction: #IsSharedInstance;
		defineFunction: #GetRecoState:
			argumentTypes: 'sdword*';
		defineFunction: #SetRecoState:
			argumentTypes: 'sdword';
		defineFunction: #GetStatus:
			argumentTypes: 'SPRECOGNIZERSTATUS*';
		defineFunction: #GetFormat:pFormatId:ppCoMemWFEX:
			argumentTypes: 'sdword GUID* WaveFormatEx**';
		defineFunction: #IsUISupported:pvExtraData:cbExtraData:pfSupported:
			argumentTypes: 'word* void* dword sdword*';
		defineFunction: #DisplayUI:pszTitle:pszTypeOfUI:pvExtraData:cbExtraData:
			argumentTypes: 'handle* word* word* void* dword';
		defineFunction: #EmulateRecognition:
			argumentTypes: 'ISpPhrase*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpRecognizer initializeTypeLib"

	typeLib := SpeechLib! !
!ISpRecognizer class categoriesFor: #defineFunctions!initializing!public! !
!ISpRecognizer class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

