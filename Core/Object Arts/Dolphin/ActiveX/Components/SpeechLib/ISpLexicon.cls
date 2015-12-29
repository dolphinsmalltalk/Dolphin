"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #ISpLexicon
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpLexicon guid: (IID fromString: '{DA41A7C2-5383-4DB2-916B-6C1719E3DB58}')!
ISpLexicon comment: '<ISpLexicon> is a wrapper class for the COM interface ''SpeechLib.ISpLexicon'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpLexicon Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(DA41A7C2-5383-4DB2-916B-6C1719E3DB58), 
	helpstring("ISpLexicon Interface"), 
	restricted
]
interface ISpLexicon : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall GetPronunciations(
		[in] unsigned short* pszWord,
		[in] unsigned short LangId,
		[in] unsigned long dwFlags,
		[in, out] SPWORDPRONUNCIATIONLIST* pWordPronunciationList);
	[id(0x60010001)]
	HRESULT __stdcall AddPronunciation(
		[in] unsigned short* pszWord,
		[in] unsigned short LangId,
		[in] SPPARTOFSPEECH ePartOfSpeech,
		[in] unsigned short* pszPronunciation);
	[id(0x60010002)]
	HRESULT __stdcall RemovePronunciation(
		[in] unsigned short* pszWord,
		[in] unsigned short LangId,
		[in] SPPARTOFSPEECH ePartOfSpeech,
		[in] unsigned short* pszPronunciation);
	[id(0x60010003)]
	HRESULT __stdcall GetGeneration(
		unsigned long* pdwGeneration);
	[id(0x60010004)]
	HRESULT __stdcall GetGenerationChange(
		[in] unsigned long dwFlags,
		[in, out] unsigned long* pdwGeneration,
		[in, out] SPWORDLIST* pWordList);
	[id(0x60010005)]
	HRESULT __stdcall GetWords(
		[in] unsigned long dwFlags,
		[in, out] unsigned long* pdwGeneration,
		[in, out] unsigned long* pdwCookie,
		[in, out] SPWORDLIST* pWordList);
};
'!
!ISpLexicon categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpLexicon methodsFor!

addPronunciation: pszWord langId: langId ePartOfSpeech: ePartOfSpeech pszPronunciation: pszPronunciation
	"Invoke the AddPronunciation() method of the COM object."

	^self
		AddPronunciation: pszWord
		LangId: langId
		ePartOfSpeech: ePartOfSpeech
		pszPronunciation: pszPronunciation
!

AddPronunciation: pszWord LangId: langId ePartOfSpeech: ePartOfSpeech pszPronunciation: pszPronunciation
	"Private - Invoke the AddPronunciation() method of the COM object.

		HRESULT __stdcall AddPronunciation(
			[in] unsigned short* pszWord,
			[in] unsigned short LangId,
			[in] SPPARTOFSPEECH ePartOfSpeech,
			[in] unsigned short* pszPronunciation);"

	<virtual stdcall: hresult 5 word* word sdword word*>
	^self invalidCall
!

getGeneration: pdwGeneration
	"Invoke the GetGeneration() method of the COM object."

	^self GetGeneration: pdwGeneration
!

GetGeneration: pdwGeneration
	"Private - Invoke the GetGeneration() method of the COM object.

		HRESULT __stdcall GetGeneration(
			unsigned long* pdwGeneration);"

	<virtual stdcall: hresult 7 dword*>
	^self invalidCall
!

getGenerationChange: dwFlags pdwGeneration: pdwGeneration pWordList: pWordList
	"Invoke the GetGenerationChange() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (DWORD new value: pdwGeneration; yourself);
				basicAt: 2 put: (SPWORDLIST new value: pWordList; yourself);
				yourself.
	self
		GetGenerationChange: dwFlags
		pdwGeneration: (answer basicAt: 1)
		pWordList: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetGenerationChange: dwFlags pdwGeneration: pdwGeneration pWordList: pWordList
	"Private - Invoke the GetGenerationChange() method of the COM object.

		HRESULT __stdcall GetGenerationChange(
			[in] unsigned long dwFlags,
			[in, out] unsigned long* pdwGeneration,
			[in, out] SPWORDLIST* pWordList);"

	<virtual stdcall: hresult 8 dword dword* SPWORDLIST*>
	^self invalidCall
!

getPronunciations: pszWord langId: langId dwFlags: dwFlags pWordPronunciationList: pWordPronunciationList
	"Answer the <SPWORDPRONUNCIATIONLIST> result of invoking the GetPronunciations() method of the COM object."

	| answer |
	answer := (SPWORDPRONUNCIATIONLIST new value: pWordPronunciationList; yourself).
	self
		GetPronunciations: pszWord
		LangId: langId
		dwFlags: dwFlags
		pWordPronunciationList: answer.
	^answer asObject
!

GetPronunciations: pszWord LangId: langId dwFlags: dwFlags pWordPronunciationList: pWordPronunciationList
	"Private - Invoke the GetPronunciations() method of the COM object.

		HRESULT __stdcall GetPronunciations(
			[in] unsigned short* pszWord,
			[in] unsigned short LangId,
			[in] unsigned long dwFlags,
			[in, out] SPWORDPRONUNCIATIONLIST* pWordPronunciationList);"

	<virtual stdcall: hresult 4 word* word dword SPWORDPRONUNCIATIONLIST*>
	^self invalidCall
!

getWords: dwFlags pdwGeneration: pdwGeneration pdwCookie: pdwCookie pWordList: pWordList
	"Invoke the GetWords() method of the COM object."

	| answer |
	answer := (Array new: 3)
				basicAt: 1 put: (DWORD new value: pdwGeneration; yourself);
				basicAt: 2 put: (DWORD new value: pdwCookie; yourself);
				basicAt: 3 put: (SPWORDLIST new value: pWordList; yourself);
				yourself.
	self
		GetWords: dwFlags
		pdwGeneration: (answer basicAt: 1)
		pdwCookie: (answer basicAt: 2)
		pWordList: (answer basicAt: 3).
	^answer collect: [:e | e asObject]
!

GetWords: dwFlags pdwGeneration: pdwGeneration pdwCookie: pdwCookie pWordList: pWordList
	"Private - Invoke the GetWords() method of the COM object.

		HRESULT __stdcall GetWords(
			[in] unsigned long dwFlags,
			[in, out] unsigned long* pdwGeneration,
			[in, out] unsigned long* pdwCookie,
			[in, out] SPWORDLIST* pWordList);"

	<virtual stdcall: hresult 9 dword dword* dword* SPWORDLIST*>
	^self invalidCall
!

removePronunciation: pszWord langId: langId ePartOfSpeech: ePartOfSpeech pszPronunciation: pszPronunciation
	"Invoke the RemovePronunciation() method of the COM object."

	^self
		RemovePronunciation: pszWord
		LangId: langId
		ePartOfSpeech: ePartOfSpeech
		pszPronunciation: pszPronunciation
!

RemovePronunciation: pszWord LangId: langId ePartOfSpeech: ePartOfSpeech pszPronunciation: pszPronunciation
	"Private - Invoke the RemovePronunciation() method of the COM object.

		HRESULT __stdcall RemovePronunciation(
			[in] unsigned short* pszWord,
			[in] unsigned short LangId,
			[in] SPPARTOFSPEECH ePartOfSpeech,
			[in] unsigned short* pszPronunciation);"

	<virtual stdcall: hresult 6 word* word sdword word*>
	^self invalidCall
! !
!ISpLexicon categoriesFor: #addPronunciation:langId:ePartOfSpeech:pszPronunciation:!**auto generated**!methods!public! !
!ISpLexicon categoriesFor: #AddPronunciation:LangId:ePartOfSpeech:pszPronunciation:!**auto generated**!COM Interfaces-ISpLexicon!private! !
!ISpLexicon categoriesFor: #getGeneration:!**auto generated**!methods!public! !
!ISpLexicon categoriesFor: #GetGeneration:!**auto generated**!COM Interfaces-ISpLexicon!private! !
!ISpLexicon categoriesFor: #getGenerationChange:pdwGeneration:pWordList:!**auto generated**!methods!public! !
!ISpLexicon categoriesFor: #GetGenerationChange:pdwGeneration:pWordList:!**auto generated**!COM Interfaces-ISpLexicon!private! !
!ISpLexicon categoriesFor: #getPronunciations:langId:dwFlags:pWordPronunciationList:!**auto generated**!methods!public! !
!ISpLexicon categoriesFor: #GetPronunciations:LangId:dwFlags:pWordPronunciationList:!**auto generated**!COM Interfaces-ISpLexicon!private! !
!ISpLexicon categoriesFor: #getWords:pdwGeneration:pdwCookie:pWordList:!**auto generated**!methods!public! !
!ISpLexicon categoriesFor: #GetWords:pdwGeneration:pdwCookie:pWordList:!**auto generated**!COM Interfaces-ISpLexicon!private! !
!ISpLexicon categoriesFor: #removePronunciation:langId:ePartOfSpeech:pszPronunciation:!**auto generated**!methods!public! !
!ISpLexicon categoriesFor: #RemovePronunciation:LangId:ePartOfSpeech:pszPronunciation:!**auto generated**!COM Interfaces-ISpLexicon!private! !

!ISpLexicon class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpCompressedLexicon) for which the receiver is the default interface."

	^CLSID fromString: '{90903716-2F42-11D3-9C26-00C04F8EF87C}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpLexicon'
		ISpLexicon defineTemplate"

	self
		defineFunction: #GetPronunciations:LangId:dwFlags:pWordPronunciationList:
			argumentTypes: 'word* word dword SPWORDPRONUNCIATIONLIST*';
		defineFunction: #AddPronunciation:LangId:ePartOfSpeech:pszPronunciation:
			argumentTypes: 'word* word sdword word*';
		defineFunction: #RemovePronunciation:LangId:ePartOfSpeech:pszPronunciation:
			argumentTypes: 'word* word sdword word*';
		defineFunction: #GetGeneration:
			argumentTypes: 'dword*';
		defineFunction: #GetGenerationChange:pdwGeneration:pWordList:
			argumentTypes: 'dword dword* SPWORDLIST*';
		defineFunction: #GetWords:pdwGeneration:pdwCookie:pWordList:
			argumentTypes: 'dword dword* dword* SPWORDLIST*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpLexicon initializeTypeLib"

	typeLib := SpeechLib! !
!ISpLexicon class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpLexicon class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpLexicon class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

