"Filed out from Dolphin Smalltalk 7"!

ISpEventSource subclass: #ISpVoice
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpVoice guid: (IID fromString: '{6C44DF74-72B9-4992-A1EC-EF996E0422D4}')!
ISpVoice comment: '<ISpVoice> is a wrapper class for the COM interface ''SpeechLib.ISpVoice'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpVoice Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(6C44DF74-72B9-4992-A1EC-EF996E0422D4), 
	helpstring("ISpVoice Interface"), 
	restricted
]
interface ISpVoice : ISpEventSource {
	[id(0x60030000)]
	HRESULT __stdcall SetOutput(
		[in] IUnknown* pUnkOutput,
		[in] long fAllowFormatChanges);
	[id(0x60030001)]
	HRESULT __stdcall GetOutputObjectToken(
		[out] ISpObjectToken** ppObjectToken);
	[id(0x60030002)]
	HRESULT __stdcall GetOutputStream(
		[out] ISpStreamFormat** ppStream);
	[id(0x60030003)]
	HRESULT __stdcall Pause();
	[id(0x60030004)]
	HRESULT __stdcall Resume();
	[id(0x60030005)]
	HRESULT __stdcall SetVoice(
		[in] ISpObjectToken* pToken);
	[id(0x60030006)]
	HRESULT __stdcall GetVoice(
		[out] ISpObjectToken** ppToken);
	[id(0x60030007)]
	HRESULT __stdcall Speak(
		[in] LPWSTR pwcs,
		[in] unsigned long dwFlags,
		[out] unsigned long* pulStreamNumber);
	[id(0x60030008)]
	HRESULT __stdcall SpeakStream(
		[in] IStream* pStream,
		[in] unsigned long dwFlags,
		[out] unsigned long* pulStreamNumber);
	[id(0x60030009)]
	HRESULT __stdcall GetStatus(
		[out] SPVOICESTATUS* pStatus,
		[out] LPWSTR* ppszLastBookmark);
	[id(0x6003000a)]
	HRESULT __stdcall Skip(
		[in] LPWSTR pItemType,
		[in] long lNumItems,
		[out] unsigned long* pulNumSkipped);
	[id(0x6003000b)]
	HRESULT __stdcall SetPriority(
		[in] SPVPRIORITY ePriority);
	[id(0x6003000c)]
	HRESULT __stdcall GetPriority(
		[out] SPVPRIORITY* pePriority);
	[id(0x6003000d)]
	HRESULT __stdcall SetAlertBoundary(
		[in] SPEVENTENUM eBoundary);
	[id(0x6003000e)]
	HRESULT __stdcall GetAlertBoundary(
		[out] SPEVENTENUM* peBoundary);
	[id(0x6003000f)]
	HRESULT __stdcall SetRate(
		[in] long RateAdjust);
	[id(0x60030010)]
	HRESULT __stdcall GetRate(
		[out] long* pRateAdjust);
	[id(0x60030011)]
	HRESULT __stdcall SetVolume(
		[in] unsigned short usVolume);
	[id(0x60030012)]
	HRESULT __stdcall GetVolume(
		[out] unsigned short* pusVolume);
	[id(0x60030013)]
	HRESULT __stdcall WaitUntilDone(
		[in] unsigned long msTimeout);
	[id(0x60030014)]
	HRESULT __stdcall SetSyncSpeakTimeout(
		[in] unsigned long msTimeout);
	[id(0x60030015)]
	HRESULT __stdcall GetSyncSpeakTimeout(
		[out] unsigned long* pmsTimeout);
	[id(0x60030016)]
	void* __stdcall SpeakCompleteEvent();
	[id(0x60030017)]
	HRESULT __stdcall IsUISupported(
		[in] unsigned short* pszTypeOfUI,
		[in] void* pvExtraData,
		[in] unsigned long cbExtraData,
		[out] long* pfSupported);
	[id(0x60030018)]
	HRESULT __stdcall DisplayUI(
		[in] wireHWND hWndParent,
		[in] unsigned short* pszTitle,
		[in] unsigned short* pszTypeOfUI,
		[in] void* pvExtraData,
		[in] unsigned long cbExtraData);
};
'!
!ISpVoice categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpVoice methodsFor!

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

	<virtual stdcall: hresult 38 handle* word* word* void* dword>
	^self invalidCall
!

getAlertBoundary
	"Answer the <SDWORD> result of invoking the GetAlertBoundary() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self GetAlertBoundary: answer.
	^answer asObject
!

GetAlertBoundary: peBoundary
	"Private - Invoke the GetAlertBoundary() method of the COM object.

		HRESULT __stdcall GetAlertBoundary(
			[out] SPEVENTENUM* peBoundary);"

	<virtual stdcall: hresult 28 sdword*>
	^self invalidCall
!

getOutputObjectToken
	"Answer the <ISpObjectToken> result of invoking the GetOutputObjectToken() method of the COM object."

	| answer |
	answer := ISpObjectToken newPointer.
	self GetOutputObjectToken: answer.
	^answer asObject
!

GetOutputObjectToken: ppObjectToken
	"Private - Invoke the GetOutputObjectToken() method of the COM object.

		HRESULT __stdcall GetOutputObjectToken(
			[out] ISpObjectToken** ppObjectToken);"

	<virtual stdcall: hresult 15 ISpObjectToken**>
	^self invalidCall
!

getOutputStream
	"Answer the <ISpStreamFormat> result of invoking the GetOutputStream() method of the COM object."

	| answer |
	answer := ISpStreamFormat newPointer.
	self GetOutputStream: answer.
	^answer asObject
!

GetOutputStream: ppStream
	"Private - Invoke the GetOutputStream() method of the COM object.

		HRESULT __stdcall GetOutputStream(
			[out] ISpStreamFormat** ppStream);"

	<virtual stdcall: hresult 16 ISpStreamFormat**>
	^self invalidCall
!

getPriority
	"Answer the <SDWORD> result of invoking the GetPriority() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self GetPriority: answer.
	^answer asObject
!

GetPriority: pePriority
	"Private - Invoke the GetPriority() method of the COM object.

		HRESULT __stdcall GetPriority(
			[out] SPVPRIORITY* pePriority);"

	<virtual stdcall: hresult 26 sdword*>
	^self invalidCall
!

getRate
	"Answer the <SDWORD> result of invoking the GetRate() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self GetRate: answer.
	^answer asObject
!

GetRate: pRateAdjust
	"Private - Invoke the GetRate() method of the COM object.

		HRESULT __stdcall GetRate(
			[out] long* pRateAdjust);"

	<virtual stdcall: hresult 30 sdword*>
	^self invalidCall
!

getStatus
	"Invoke the GetStatus() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (SPVOICESTATUS new);
				basicAt: 2 put: (StructurePointer newNull: COMTaskMemory elementClass: UnicodeString);
				yourself.
	self
		GetStatus: (answer basicAt: 1)
		ppszLastBookmark: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetStatus: pStatus ppszLastBookmark: ppszLastBookmark
	"Private - Invoke the GetStatus() method of the COM object.

		HRESULT __stdcall GetStatus(
			[out] SPVOICESTATUS* pStatus,
			[out] LPWSTR* ppszLastBookmark);"

	<virtual stdcall: hresult 23 SPVOICESTATUS* lpwstr*>
	^self invalidCall
!

getSyncSpeakTimeout
	"Answer the <DWORD> result of invoking the GetSyncSpeakTimeout() method of the COM object."

	| answer |
	answer := (DWORD new).
	self GetSyncSpeakTimeout: answer.
	^answer asObject
!

GetSyncSpeakTimeout: pmsTimeout
	"Private - Invoke the GetSyncSpeakTimeout() method of the COM object.

		HRESULT __stdcall GetSyncSpeakTimeout(
			[out] unsigned long* pmsTimeout);"

	<virtual stdcall: hresult 35 dword*>
	^self invalidCall
!

getVoice
	"Answer the <ISpObjectToken> result of invoking the GetVoice() method of the COM object."

	| answer |
	answer := ISpObjectToken newPointer.
	self GetVoice: answer.
	^answer asObject
!

GetVoice: ppToken
	"Private - Invoke the GetVoice() method of the COM object.

		HRESULT __stdcall GetVoice(
			[out] ISpObjectToken** ppToken);"

	<virtual stdcall: hresult 20 ISpObjectToken**>
	^self invalidCall
!

getVolume
	"Answer the <WORD> result of invoking the GetVolume() method of the COM object."

	| answer |
	answer := (WORD new).
	self GetVolume: answer.
	^answer asObject
!

GetVolume: pusVolume
	"Private - Invoke the GetVolume() method of the COM object.

		HRESULT __stdcall GetVolume(
			[out] unsigned short* pusVolume);"

	<virtual stdcall: hresult 32 word*>
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

	<virtual stdcall: hresult 37 word* void* dword sdword*>
	^self invalidCall
!

pause
	"Invoke the Pause() method of the COM object."

	^self Pause
!

Pause
	"Private - Invoke the Pause() method of the COM object.

		HRESULT __stdcall Pause();"

	<virtual stdcall: hresult 17>
	^self invalidCall
!

resume
	"Invoke the Resume() method of the COM object."

	^self Resume
!

Resume
	"Private - Invoke the Resume() method of the COM object.

		HRESULT __stdcall Resume();"

	<virtual stdcall: hresult 18>
	^self invalidCall
!

setAlertBoundary: eBoundary
	"Invoke the SetAlertBoundary() method of the COM object."

	^self SetAlertBoundary: eBoundary
!

SetAlertBoundary: eBoundary
	"Private - Invoke the SetAlertBoundary() method of the COM object.

		HRESULT __stdcall SetAlertBoundary(
			[in] SPEVENTENUM eBoundary);"

	<virtual stdcall: hresult 27 sdword>
	^self invalidCall
!

setOutput: pUnkOutput fAllowFormatChanges: fAllowFormatChanges
	"Invoke the SetOutput() method of the COM object."

	^self
		SetOutput: pUnkOutput
		fAllowFormatChanges: fAllowFormatChanges
!

SetOutput: pUnkOutput fAllowFormatChanges: fAllowFormatChanges
	"Private - Invoke the SetOutput() method of the COM object.

		HRESULT __stdcall SetOutput(
			[in] IUnknown* pUnkOutput,
			[in] long fAllowFormatChanges);"

	<virtual stdcall: hresult 14 IUnknown* sdword>
	^self invalidCall
!

setPriority: ePriority
	"Invoke the SetPriority() method of the COM object."

	^self SetPriority: ePriority
!

SetPriority: ePriority
	"Private - Invoke the SetPriority() method of the COM object.

		HRESULT __stdcall SetPriority(
			[in] SPVPRIORITY ePriority);"

	<virtual stdcall: hresult 25 sdword>
	^self invalidCall
!

setRate: rateAdjust
	"Invoke the SetRate() method of the COM object."

	^self SetRate: rateAdjust
!

SetRate: rateAdjust
	"Private - Invoke the SetRate() method of the COM object.

		HRESULT __stdcall SetRate(
			[in] long RateAdjust);"

	<virtual stdcall: hresult 29 sdword>
	^self invalidCall
!

setSyncSpeakTimeout: msTimeout
	"Invoke the SetSyncSpeakTimeout() method of the COM object."

	^self SetSyncSpeakTimeout: msTimeout
!

SetSyncSpeakTimeout: msTimeout
	"Private - Invoke the SetSyncSpeakTimeout() method of the COM object.

		HRESULT __stdcall SetSyncSpeakTimeout(
			[in] unsigned long msTimeout);"

	<virtual stdcall: hresult 34 dword>
	^self invalidCall
!

setVoice: pToken
	"Invoke the SetVoice() method of the COM object."

	^self SetVoice: pToken
!

SetVoice: pToken
	"Private - Invoke the SetVoice() method of the COM object.

		HRESULT __stdcall SetVoice(
			[in] ISpObjectToken* pToken);"

	<virtual stdcall: hresult 19 ISpObjectToken*>
	^self invalidCall
!

setVolume: usVolume
	"Invoke the SetVolume() method of the COM object."

	^self SetVolume: usVolume
!

SetVolume: usVolume
	"Private - Invoke the SetVolume() method of the COM object.

		HRESULT __stdcall SetVolume(
			[in] unsigned short usVolume);"

	<virtual stdcall: hresult 31 word>
	^self invalidCall
!

skip: pItemType lNumItems: lNumItems
	"Answer the <DWORD> result of invoking the Skip() method of the COM object."

	| answer |
	answer := (DWORD new).
	self
		Skip: pItemType asUnicodeString
		lNumItems: lNumItems
		pulNumSkipped: answer.
	^answer asObject
!

Skip: pItemType lNumItems: lNumItems pulNumSkipped: pulNumSkipped
	"Private - Invoke the Skip() method of the COM object.

		HRESULT __stdcall Skip(
			[in] LPWSTR pItemType,
			[in] long lNumItems,
			[out] unsigned long* pulNumSkipped);"

	<virtual stdcall: hresult 24 lpwstr sdword dword*>
	^self invalidCall
!

speak: pwcs dwFlags: dwFlags
	"Answer the <DWORD> result of invoking the Speak() method of the COM object."

	| answer |
	answer := (DWORD new).
	self
		Speak: pwcs asUnicodeString
		dwFlags: dwFlags
		pulStreamNumber: answer.
	^answer asObject
!

Speak: pwcs dwFlags: dwFlags pulStreamNumber: pulStreamNumber
	"Private - Invoke the Speak() method of the COM object.

		HRESULT __stdcall Speak(
			[in] LPWSTR pwcs,
			[in] unsigned long dwFlags,
			[out] unsigned long* pulStreamNumber);"

	<virtual stdcall: hresult 21 lpwstr dword dword*>
	^self invalidCall
!

speakCompleteEvent
	"Answer the <VOID> result of invoking the SpeakCompleteEvent() method of the COM object."

	^self SpeakCompleteEvent
!

SpeakCompleteEvent
	"Private - Invoke the SpeakCompleteEvent() method of the COM object.

		void* __stdcall SpeakCompleteEvent();"

	<virtual stdcall: void* 36>
	^self invalidCall
!

speakStream: pStream dwFlags: dwFlags
	"Answer the <DWORD> result of invoking the SpeakStream() method of the COM object."

	| answer |
	answer := (DWORD new).
	self
		SpeakStream: pStream
		dwFlags: dwFlags
		pulStreamNumber: answer.
	^answer asObject
!

SpeakStream: pStream dwFlags: dwFlags pulStreamNumber: pulStreamNumber
	"Private - Invoke the SpeakStream() method of the COM object.

		HRESULT __stdcall SpeakStream(
			[in] IStream* pStream,
			[in] unsigned long dwFlags,
			[out] unsigned long* pulStreamNumber);"

	<virtual stdcall: hresult 22 IStream* dword dword*>
	^self invalidCall
!

waitUntilDone: msTimeout
	"Invoke the WaitUntilDone() method of the COM object."

	^self WaitUntilDone: msTimeout
!

WaitUntilDone: msTimeout
	"Private - Invoke the WaitUntilDone() method of the COM object.

		HRESULT __stdcall WaitUntilDone(
			[in] unsigned long msTimeout);"

	<virtual stdcall: hresult 33 dword>
	^self invalidCall
! !
!ISpVoice categoriesFor: #displayUI:pszTitle:pszTypeOfUI:pvExtraData:cbExtraData:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #DisplayUI:pszTitle:pszTypeOfUI:pvExtraData:cbExtraData:!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #getAlertBoundary!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #GetAlertBoundary:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #getOutputObjectToken!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #GetOutputObjectToken:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #getOutputStream!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #GetOutputStream:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #getPriority!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #GetPriority:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #getRate!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #GetRate:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #getStatus!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #GetStatus:ppszLastBookmark:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #getSyncSpeakTimeout!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #GetSyncSpeakTimeout:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #getVoice!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #GetVoice:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #getVolume!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #GetVolume:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #isUISupported:pvExtraData:cbExtraData:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #IsUISupported:pvExtraData:cbExtraData:pfSupported:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #pause!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #Pause!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #resume!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #Resume!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #setAlertBoundary:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #SetAlertBoundary:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #setOutput:fAllowFormatChanges:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #SetOutput:fAllowFormatChanges:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #setPriority:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #SetPriority:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #setRate:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #SetRate:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #setSyncSpeakTimeout:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #SetSyncSpeakTimeout:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #setVoice:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #SetVoice:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #setVolume:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #SetVolume:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #skip:lNumItems:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #Skip:lNumItems:pulNumSkipped:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #speak:dwFlags:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #Speak:dwFlags:pulStreamNumber:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #speakCompleteEvent!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #SpeakCompleteEvent!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #speakStream:dwFlags:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #SpeakStream:dwFlags:pulStreamNumber:!**auto generated**!COM Interfaces-ISpVoice!private! !
!ISpVoice categoriesFor: #waitUntilDone:!**auto generated**!methods!public! !
!ISpVoice categoriesFor: #WaitUntilDone:!**auto generated**!COM Interfaces-ISpVoice!private! !

!ISpVoice class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpVoice'
		ISpVoice defineTemplate"

	self
		defineFunction: #SetOutput:fAllowFormatChanges:
			argumentTypes: 'IUnknown* sdword';
		defineFunction: #GetOutputObjectToken:
			argumentTypes: 'ISpObjectToken**';
		defineFunction: #GetOutputStream:
			argumentTypes: 'ISpStreamFormat**';
		defineFunction: #Pause;
		defineFunction: #Resume;
		defineFunction: #SetVoice:
			argumentTypes: 'ISpObjectToken*';
		defineFunction: #GetVoice:
			argumentTypes: 'ISpObjectToken**';
		defineFunction: #Speak:dwFlags:pulStreamNumber:
			argumentTypes: 'lpwstr dword dword*';
		defineFunction: #SpeakStream:dwFlags:pulStreamNumber:
			argumentTypes: 'IStream* dword dword*';
		defineFunction: #GetStatus:ppszLastBookmark:
			argumentTypes: 'SPVOICESTATUS* lpwstr*';
		defineFunction: #Skip:lNumItems:pulNumSkipped:
			argumentTypes: 'lpwstr sdword dword*';
		defineFunction: #SetPriority:
			argumentTypes: 'sdword';
		defineFunction: #GetPriority:
			argumentTypes: 'sdword*';
		defineFunction: #SetAlertBoundary:
			argumentTypes: 'sdword';
		defineFunction: #GetAlertBoundary:
			argumentTypes: 'sdword*';
		defineFunction: #SetRate:
			argumentTypes: 'sdword';
		defineFunction: #GetRate:
			argumentTypes: 'sdword*';
		defineFunction: #SetVolume:
			argumentTypes: 'word';
		defineFunction: #GetVolume:
			argumentTypes: 'word*';
		defineFunction: #WaitUntilDone:
			argumentTypes: 'dword';
		defineFunction: #SetSyncSpeakTimeout:
			argumentTypes: 'dword';
		defineFunction: #GetSyncSpeakTimeout:
			argumentTypes: 'dword*';
		defineFunction: #SpeakCompleteEvent
			returnType: 'void*';
		defineFunction: #IsUISupported:pvExtraData:cbExtraData:pfSupported:
			argumentTypes: 'word* void* dword sdword*';
		defineFunction: #DisplayUI:pszTitle:pszTypeOfUI:pvExtraData:cbExtraData:
			argumentTypes: 'handle* word* word* void* dword'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpVoice initializeTypeLib"

	typeLib := SpeechLib! !
!ISpVoice class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpVoice class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

