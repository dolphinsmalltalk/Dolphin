"Filed out from Dolphin Smalltalk 7"!

ISpGrammarBuilder subclass: #ISpRecoGrammar
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpRecoGrammar guid: (IID fromString: '{2177DB29-7F45-47D0-8554-067E91C80502}')!
ISpRecoGrammar comment: '<ISpRecoGrammar> is a wrapper class for the COM interface ''SpeechLib.ISpRecoGrammar'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpRecoGrammar Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2177DB29-7F45-47D0-8554-067E91C80502), 
	helpstring("ISpRecoGrammar Interface"), 
	restricted
]
interface ISpRecoGrammar : ISpGrammarBuilder {
	[id(0x60020000)]
	HRESULT __stdcall GetGrammarId(
		[out] unsigned __int64* pullGrammarId);
	[id(0x60020001)]
	HRESULT __stdcall GetRecoContext(
		[out] ISpRecoContext** ppRecoCtxt);
	[id(0x60020002)]
	HRESULT __stdcall LoadCmdFromFile(
		[in] LPWSTR pszFileName,
		[in] SPLOADOPTIONS Options);
	[id(0x60020003)]
	HRESULT __stdcall LoadCmdFromObject(
		[in] GUID* rcid,
		[in] LPWSTR pszGrammarName,
		[in] SPLOADOPTIONS Options);
	[id(0x60020004)]
	HRESULT __stdcall LoadCmdFromResource(
		[in] void* hModule,
		[in] LPWSTR pszResourceName,
		[in] LPWSTR pszResourceType,
		[in] unsigned short wLanguage,
		[in] SPLOADOPTIONS Options);
	[id(0x60020005)]
	HRESULT __stdcall LoadCmdFromMemory(
		[in] SPBINARYGRAMMAR* pGrammar,
		[in] SPLOADOPTIONS Options);
	[id(0x60020006)]
	HRESULT __stdcall LoadCmdFromProprietaryGrammar(
		[in] GUID* rguidParam,
		[in] LPWSTR pszStringParam,
		[in] void* pvDataPrarm,
		[in] unsigned long cbDataSize,
		[in] SPLOADOPTIONS Options);
	[id(0x60020007)]
	HRESULT __stdcall SetRuleState(
		[in] LPWSTR pszName,
		void* pReserved,
		[in] SPRULESTATE NewState);
	[id(0x60020008)]
	HRESULT __stdcall SetRuleIdState(
		[in] unsigned long ulRuleId,
		[in] SPRULESTATE NewState);
	[id(0x60020009)]
	HRESULT __stdcall LoadDictation(
		[in] LPWSTR pszTopicName,
		[in] SPLOADOPTIONS Options);
	[id(0x6002000a)]
	HRESULT __stdcall UnloadDictation();
	[id(0x6002000b)]
	HRESULT __stdcall SetDictationState(
		[in] SPRULESTATE NewState);
	[id(0x6002000c)]
	HRESULT __stdcall SetWordSequenceData(
		[in] unsigned short* pText,
		[in] unsigned long cchText,
		[in] SPTEXTSELECTIONINFO* pInfo);
	[id(0x6002000d)]
	HRESULT __stdcall SetTextSelection(
		[in] SPTEXTSELECTIONINFO* pInfo);
	[id(0x6002000e)]
	HRESULT __stdcall IsPronounceable(
		[in] LPWSTR pszWord,
		[out] SPWORDPRONOUNCEABLE* pWordPronounceable);
	[id(0x6002000f)]
	HRESULT __stdcall SetGrammarState(
		[in] SPGRAMMARSTATE eGrammarState);
	[id(0x60020010)]
	HRESULT __stdcall SaveCmd(
		[in] IStream* pStream,
		[out, optional] unsigned short** ppszCoMemErrorText);
	[id(0x60020011)]
	HRESULT __stdcall GetGrammarState(
		[out] SPGRAMMARSTATE* peGrammarState);
};
'!
!ISpRecoGrammar categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpRecoGrammar methodsFor!

getGrammarId
	"Answer the <ULARGE_INTEGER> result of invoking the GetGrammarId() method of the COM object."

	| answer |
	answer := (ULARGE_INTEGER new).
	self GetGrammarId: answer.
	^answer asObject
!

GetGrammarId: pullGrammarId
	"Private - Invoke the GetGrammarId() method of the COM object.

		HRESULT __stdcall GetGrammarId(
			[out] unsigned __int64* pullGrammarId);"

	<virtual stdcall: hresult 12 qword*>
	^self invalidCall
!

getGrammarState
	"Answer the <SDWORD> result of invoking the GetGrammarState() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self GetGrammarState: answer.
	^answer asObject
!

GetGrammarState: peGrammarState
	"Private - Invoke the GetGrammarState() method of the COM object.

		HRESULT __stdcall GetGrammarState(
			[out] SPGRAMMARSTATE* peGrammarState);"

	<virtual stdcall: hresult 29 sdword*>
	^self invalidCall
!

getRecoContext
	"Answer the <ISpRecoContext> result of invoking the GetRecoContext() method of the COM object."

	| answer |
	answer := ISpRecoContext newPointer.
	self GetRecoContext: answer.
	^answer asObject
!

GetRecoContext: ppRecoCtxt
	"Private - Invoke the GetRecoContext() method of the COM object.

		HRESULT __stdcall GetRecoContext(
			[out] ISpRecoContext** ppRecoCtxt);"

	<virtual stdcall: hresult 13 ISpRecoContext**>
	^self invalidCall
!

isPronounceable: pszWord
	"Answer the <SDWORD> result of invoking the IsPronounceable() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		IsPronounceable: pszWord asUnicodeString
		pWordPronounceable: answer.
	^answer asObject
!

IsPronounceable: pszWord pWordPronounceable: pWordPronounceable
	"Private - Invoke the IsPronounceable() method of the COM object.

		HRESULT __stdcall IsPronounceable(
			[in] LPWSTR pszWord,
			[out] SPWORDPRONOUNCEABLE* pWordPronounceable);"

	<virtual stdcall: hresult 26 lpwstr sdword*>
	^self invalidCall
!

loadCmdFromFile: pszFileName options: options
	"Invoke the LoadCmdFromFile() method of the COM object."

	^self
		LoadCmdFromFile: pszFileName asUnicodeString
		Options: options
!

LoadCmdFromFile: pszFileName Options: options
	"Private - Invoke the LoadCmdFromFile() method of the COM object.

		HRESULT __stdcall LoadCmdFromFile(
			[in] LPWSTR pszFileName,
			[in] SPLOADOPTIONS Options);"

	<virtual stdcall: hresult 14 lpwstr sdword>
	^self invalidCall
!

loadCmdFromMemory: pGrammar options: options
	"Invoke the LoadCmdFromMemory() method of the COM object."

	^self
		LoadCmdFromMemory: pGrammar
		Options: options
!

LoadCmdFromMemory: pGrammar Options: options
	"Private - Invoke the LoadCmdFromMemory() method of the COM object.

		HRESULT __stdcall LoadCmdFromMemory(
			[in] SPBINARYGRAMMAR* pGrammar,
			[in] SPLOADOPTIONS Options);"

	<virtual stdcall: hresult 17 SPBINARYGRAMMAR* sdword>
	^self invalidCall
!

loadCmdFromObject: rcid pszGrammarName: pszGrammarName options: options
	"Invoke the LoadCmdFromObject() method of the COM object."

	^self
		LoadCmdFromObject: rcid
		pszGrammarName: pszGrammarName asUnicodeString
		Options: options
!

LoadCmdFromObject: rcid pszGrammarName: pszGrammarName Options: options
	"Private - Invoke the LoadCmdFromObject() method of the COM object.

		HRESULT __stdcall LoadCmdFromObject(
			[in] GUID* rcid,
			[in] LPWSTR pszGrammarName,
			[in] SPLOADOPTIONS Options);"

	<virtual stdcall: hresult 15 GUID* lpwstr sdword>
	^self invalidCall
!

loadCmdFromProprietaryGrammar: rguidParam pszStringParam: pszStringParam pvDataPrarm: pvDataPrarm cbDataSize: cbDataSize options: options
	"Invoke the LoadCmdFromProprietaryGrammar() method of the COM object."

	^self
		LoadCmdFromProprietaryGrammar: rguidParam
		pszStringParam: pszStringParam asUnicodeString
		pvDataPrarm: pvDataPrarm
		cbDataSize: cbDataSize
		Options: options
!

LoadCmdFromProprietaryGrammar: rguidParam pszStringParam: pszStringParam pvDataPrarm: pvDataPrarm cbDataSize: cbDataSize Options: options
	"Private - Invoke the LoadCmdFromProprietaryGrammar() method of the COM object.

		HRESULT __stdcall LoadCmdFromProprietaryGrammar(
			[in] GUID* rguidParam,
			[in] LPWSTR pszStringParam,
			[in] void* pvDataPrarm,
			[in] unsigned long cbDataSize,
			[in] SPLOADOPTIONS Options);"

	<virtual stdcall: hresult 18 GUID* lpwstr void* dword sdword>
	^self invalidCall
!

loadCmdFromResource: hModule pszResourceName: pszResourceName pszResourceType: pszResourceType wLanguage: wLanguage options: options
	"Invoke the LoadCmdFromResource() method of the COM object."

	^self
		LoadCmdFromResource: hModule
		pszResourceName: pszResourceName asUnicodeString
		pszResourceType: pszResourceType asUnicodeString
		wLanguage: wLanguage
		Options: options
!

LoadCmdFromResource: hModule pszResourceName: pszResourceName pszResourceType: pszResourceType wLanguage: wLanguage Options: options
	"Private - Invoke the LoadCmdFromResource() method of the COM object.

		HRESULT __stdcall LoadCmdFromResource(
			[in] void* hModule,
			[in] LPWSTR pszResourceName,
			[in] LPWSTR pszResourceType,
			[in] unsigned short wLanguage,
			[in] SPLOADOPTIONS Options);"

	<virtual stdcall: hresult 16 void* lpwstr lpwstr word sdword>
	^self invalidCall
!

loadDictation: pszTopicName options: options
	"Invoke the LoadDictation() method of the COM object."

	^self
		LoadDictation: pszTopicName asUnicodeString
		Options: options
!

LoadDictation: pszTopicName Options: options
	"Private - Invoke the LoadDictation() method of the COM object.

		HRESULT __stdcall LoadDictation(
			[in] LPWSTR pszTopicName,
			[in] SPLOADOPTIONS Options);"

	<virtual stdcall: hresult 21 lpwstr sdword>
	^self invalidCall
!

saveCmd: pStream
	"Answer the <WORD> result of invoking the SaveCmd() method of the COM object."

	| answer |
	answer := (WORD newBufferClass: COMTaskMemory).
	self
		SaveCmd: pStream
		ppszCoMemErrorText: answer.
	^answer asObject
!

SaveCmd: pStream ppszCoMemErrorText: ppszCoMemErrorText
	"Private - Invoke the SaveCmd() method of the COM object.

		HRESULT __stdcall SaveCmd(
			[in] IStream* pStream,
			[out, optional] unsigned short** ppszCoMemErrorText);"

	<virtual stdcall: hresult 28 IStream* word**>
	^self invalidCall
!

setDictationState: newState
	"Invoke the SetDictationState() method of the COM object."

	^self SetDictationState: newState
!

SetDictationState: newState
	"Private - Invoke the SetDictationState() method of the COM object.

		HRESULT __stdcall SetDictationState(
			[in] SPRULESTATE NewState);"

	<virtual stdcall: hresult 23 sdword>
	^self invalidCall
!

setGrammarState: eGrammarState
	"Invoke the SetGrammarState() method of the COM object."

	^self SetGrammarState: eGrammarState
!

SetGrammarState: eGrammarState
	"Private - Invoke the SetGrammarState() method of the COM object.

		HRESULT __stdcall SetGrammarState(
			[in] SPGRAMMARSTATE eGrammarState);"

	<virtual stdcall: hresult 27 sdword>
	^self invalidCall
!

setRuleIdState: ulRuleId newState: newState
	"Invoke the SetRuleIdState() method of the COM object."

	^self
		SetRuleIdState: ulRuleId
		NewState: newState
!

SetRuleIdState: ulRuleId NewState: newState
	"Private - Invoke the SetRuleIdState() method of the COM object.

		HRESULT __stdcall SetRuleIdState(
			[in] unsigned long ulRuleId,
			[in] SPRULESTATE NewState);"

	<virtual stdcall: hresult 20 dword sdword>
	^self invalidCall
!

setRuleState: pszName pReserved: pReserved newState: newState
	"Invoke the SetRuleState() method of the COM object."

	^self
		SetRuleState: pszName asUnicodeString
		pReserved: pReserved
		NewState: newState
!

SetRuleState: pszName pReserved: pReserved NewState: newState
	"Private - Invoke the SetRuleState() method of the COM object.

		HRESULT __stdcall SetRuleState(
			[in] LPWSTR pszName,
			void* pReserved,
			[in] SPRULESTATE NewState);"

	<virtual stdcall: hresult 19 lpwstr void* sdword>
	^self invalidCall
!

setTextSelection: pInfo
	"Invoke the SetTextSelection() method of the COM object."

	^self SetTextSelection: pInfo
!

SetTextSelection: pInfo
	"Private - Invoke the SetTextSelection() method of the COM object.

		HRESULT __stdcall SetTextSelection(
			[in] SPTEXTSELECTIONINFO* pInfo);"

	<virtual stdcall: hresult 25 SPTEXTSELECTIONINFO*>
	^self invalidCall
!

setWordSequenceData: pText cchText: cchText pInfo: pInfo
	"Invoke the SetWordSequenceData() method of the COM object."

	^self
		SetWordSequenceData: pText
		cchText: cchText
		pInfo: pInfo
!

SetWordSequenceData: pText cchText: cchText pInfo: pInfo
	"Private - Invoke the SetWordSequenceData() method of the COM object.

		HRESULT __stdcall SetWordSequenceData(
			[in] unsigned short* pText,
			[in] unsigned long cchText,
			[in] SPTEXTSELECTIONINFO* pInfo);"

	<virtual stdcall: hresult 24 word* dword SPTEXTSELECTIONINFO*>
	^self invalidCall
!

unloadDictation
	"Invoke the UnloadDictation() method of the COM object."

	^self UnloadDictation
!

UnloadDictation
	"Private - Invoke the UnloadDictation() method of the COM object.

		HRESULT __stdcall UnloadDictation();"

	<virtual stdcall: hresult 22>
	^self invalidCall
! !
!ISpRecoGrammar categoriesFor: #getGrammarId!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #GetGrammarId:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #getGrammarState!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #GetGrammarState:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #getRecoContext!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #GetRecoContext:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #isPronounceable:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #IsPronounceable:pWordPronounceable:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #loadCmdFromFile:options:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #LoadCmdFromFile:Options:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #loadCmdFromMemory:options:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #LoadCmdFromMemory:Options:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #loadCmdFromObject:pszGrammarName:options:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #LoadCmdFromObject:pszGrammarName:Options:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #loadCmdFromProprietaryGrammar:pszStringParam:pvDataPrarm:cbDataSize:options:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #LoadCmdFromProprietaryGrammar:pszStringParam:pvDataPrarm:cbDataSize:Options:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #loadCmdFromResource:pszResourceName:pszResourceType:wLanguage:options:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #LoadCmdFromResource:pszResourceName:pszResourceType:wLanguage:Options:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #loadDictation:options:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #LoadDictation:Options:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #saveCmd:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #SaveCmd:ppszCoMemErrorText:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #setDictationState:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #SetDictationState:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #setGrammarState:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #SetGrammarState:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #setRuleIdState:newState:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #SetRuleIdState:NewState:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #setRuleState:pReserved:newState:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #SetRuleState:pReserved:NewState:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #setTextSelection:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #SetTextSelection:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #setWordSequenceData:cchText:pInfo:!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #SetWordSequenceData:cchText:pInfo:!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !
!ISpRecoGrammar categoriesFor: #unloadDictation!**auto generated**!methods!public! !
!ISpRecoGrammar categoriesFor: #UnloadDictation!**auto generated**!COM Interfaces-ISpRecoGrammar!private! !

!ISpRecoGrammar class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpRecoGrammar'
		ISpRecoGrammar defineTemplate"

	self
		defineFunction: #GetGrammarId:
			argumentTypes: 'qword*';
		defineFunction: #GetRecoContext:
			argumentTypes: 'ISpRecoContext**';
		defineFunction: #LoadCmdFromFile:Options:
			argumentTypes: 'lpwstr sdword';
		defineFunction: #LoadCmdFromObject:pszGrammarName:Options:
			argumentTypes: 'GUID* lpwstr sdword';
		defineFunction: #LoadCmdFromResource:pszResourceName:pszResourceType:wLanguage:Options:
			argumentTypes: 'void* lpwstr lpwstr word sdword';
		defineFunction: #LoadCmdFromMemory:Options:
			argumentTypes: 'SPBINARYGRAMMAR* sdword';
		defineFunction: #LoadCmdFromProprietaryGrammar:pszStringParam:pvDataPrarm:cbDataSize:Options:
			argumentTypes: 'GUID* lpwstr void* dword sdword';
		defineFunction: #SetRuleState:pReserved:NewState:
			argumentTypes: 'lpwstr void* sdword';
		defineFunction: #SetRuleIdState:NewState:
			argumentTypes: 'dword sdword';
		defineFunction: #LoadDictation:Options:
			argumentTypes: 'lpwstr sdword';
		defineFunction: #UnloadDictation;
		defineFunction: #SetDictationState:
			argumentTypes: 'sdword';
		defineFunction: #SetWordSequenceData:cchText:pInfo:
			argumentTypes: 'word* dword SPTEXTSELECTIONINFO*';
		defineFunction: #SetTextSelection:
			argumentTypes: 'SPTEXTSELECTIONINFO*';
		defineFunction: #IsPronounceable:pWordPronounceable:
			argumentTypes: 'lpwstr sdword*';
		defineFunction: #SetGrammarState:
			argumentTypes: 'sdword';
		defineFunction: #SaveCmd:ppszCoMemErrorText:
			argumentTypes: 'IStream* word**';
		defineFunction: #GetGrammarState:
			argumentTypes: 'sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpRecoGrammar initializeTypeLib"

	typeLib := SpeechLib! !
!ISpRecoGrammar class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpRecoGrammar class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

