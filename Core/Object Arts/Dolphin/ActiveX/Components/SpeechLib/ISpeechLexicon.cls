"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechLexicon
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechLexicon guid: (IID fromString: '{3DA7627A-C7AE-4B23-8708-638C50362C25}')!
ISpeechLexicon comment: '<ISpeechLexicon> is a wrapper class for the COM interface ''SpeechLib.ISpeechLexicon'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechLexicon Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(3DA7627A-C7AE-4B23-8708-638C50362C25), 
	helpstring("ISpeechLexicon Interface"), 
	dual
]
interface ISpeechLexicon : IDispatch {
	[id(0x00000001), hidden, propget, helpstring("GenerationId")]
	HRESULT __stdcall GenerationId(
		[out, retval] long* GenerationId);
	[id(0x00000002), helpstring("GetWords")]
	HRESULT __stdcall GetWords(
		[in, defaultvalue(3)] SpeechLexiconType Flags,
		[out, defaultvalue(0)] long* GenerationId,
		[out, retval] ISpeechLexiconWords** Words);
	[id(0x00000003), helpstring("AddPronunciation")]
	HRESULT __stdcall AddPronunciation(
		[in] BSTR bstrWord,
		[in] long LangId,
		[in, defaultvalue(0)] SpeechPartOfSpeech PartOfSpeech,
		[in, defaultvalue("")] BSTR bstrPronunciation);
	[id(0x00000004), hidden, helpstring("AddPronunciationByPhoneIds")]
	HRESULT __stdcall AddPronunciationByPhoneIds(
		[in] BSTR bstrWord,
		[in] long LangId,
		[in, defaultvalue(0)] SpeechPartOfSpeech PartOfSpeech,
		[in, defaultvalue("")] VARIANT* PhoneIds);
	[id(0x00000005), helpstring("RemovePronunciation")]
	HRESULT __stdcall RemovePronunciation(
		[in] BSTR bstrWord,
		[in] long LangId,
		[in, defaultvalue(0)] SpeechPartOfSpeech PartOfSpeech,
		[in, defaultvalue("")] BSTR bstrPronunciation);
	[id(0x00000006), hidden, helpstring("RemovePronunciationByPhoneIds")]
	HRESULT __stdcall RemovePronunciationByPhoneIds(
		[in] BSTR bstrWord,
		[in] long LangId,
		[in, defaultvalue(0)] SpeechPartOfSpeech PartOfSpeech,
		[in, defaultvalue("")] VARIANT* PhoneIds);
	[id(0x00000007), helpstring("GetPronunciations")]
	HRESULT __stdcall GetPronunciations(
		[in] BSTR bstrWord,
		[in, defaultvalue(0)] long LangId,
		[in, defaultvalue(3)] SpeechLexiconType TypeFlags,
		[out, retval] ISpeechLexiconPronunciations** ppPronunciations);
	[id(0x00000008), hidden, helpstring("GetGenerationChange")]
	HRESULT __stdcall GetGenerationChange(
		[in, out] long* GenerationId,
		[out, retval] ISpeechLexiconWords** ppWords);
};
'!
!ISpeechLexicon categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechLexicon methodsFor!

addPronunciation: bstrWord langId: langId
	"Invoke the AddPronunciation() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 addPronunciation: bstrWord
		 langId: langId
		 partOfSpeech: 0
		 bstrPronunciation: ''!

addPronunciation: bstrWord langId: langId partOfSpeech: partOfSpeech bstrPronunciation: bstrPronunciation
	"Invoke the AddPronunciation() method of the COM object.
	Helpstring: 'AddPronunciation'"

	^self
		AddPronunciation: bstrWord
		LangId: langId
		PartOfSpeech: partOfSpeech
		bstrPronunciation: bstrPronunciation
!

AddPronunciation: bstrWord LangId: langId PartOfSpeech: partOfSpeech bstrPronunciation: bstrPronunciation
	"Private - Invoke the AddPronunciation() method of the COM object.
	Helpstring: 'AddPronunciation'

		HRESULT __stdcall AddPronunciation(
			[in] BSTR bstrWord,
			[in] long LangId,
			[in, defaultvalue(0)] SpeechPartOfSpeech PartOfSpeech,
			[in, defaultvalue("")] BSTR bstrPronunciation);"

	<virtual stdcall: hresult 10 bstr sdword sdword bstr>
	^self invalidCall
!

addPronunciationByPhoneIds: bstrWord langId: langId
	"Invoke the AddPronunciationByPhoneIds() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 addPronunciationByPhoneIds: bstrWord
		 langId: langId
		 partOfSpeech: 0
		 phoneIds: ''!

addPronunciationByPhoneIds: bstrWord langId: langId partOfSpeech: partOfSpeech phoneIds: phoneIds
	"Invoke the AddPronunciationByPhoneIds() method of the COM object.
	Helpstring: 'AddPronunciationByPhoneIds'"

	^self
		AddPronunciationByPhoneIds: bstrWord
		LangId: langId
		PartOfSpeech: partOfSpeech
		PhoneIds: phoneIds asVariant
!

AddPronunciationByPhoneIds: bstrWord LangId: langId PartOfSpeech: partOfSpeech PhoneIds: phoneIds
	"Private - Invoke the AddPronunciationByPhoneIds() method of the COM object.
	Helpstring: 'AddPronunciationByPhoneIds'

		HRESULT __stdcall AddPronunciationByPhoneIds(
			[in] BSTR bstrWord,
			[in] long LangId,
			[in, defaultvalue(0)] SpeechPartOfSpeech PartOfSpeech,
			[in, defaultvalue("")] VARIANT* PhoneIds);"

	<virtual stdcall: hresult 11 bstr sdword sdword variant*>
	^self invalidCall
!

generationId
	"Answer the <sdword> value of the 'GenerationId' property of the receiver.
	Helpstring: 'GenerationId'"

	| answer |
	answer := (SDWORD new).
	self get_GenerationId: answer.
	^answer asObject
!

get_GenerationId: generationId
	"Private - Get the value of the 'GenerationId' property of the receiver.

		HRESULT __stdcall GenerationId(
			[out, retval] long* GenerationId);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

getGenerationChange: generationId
	"Invoke the GetGenerationChange() method of the COM object.
	Helpstring: 'GetGenerationChange'"

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (SDWORD new value: generationId; yourself);
				basicAt: 2 put: ISpeechLexiconWords newPointer;
				yourself.
	self
		GetGenerationChange: (answer basicAt: 1)
		ppWords: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetGenerationChange: generationId ppWords: ppWords
	"Private - Invoke the GetGenerationChange() method of the COM object.
	Helpstring: 'GetGenerationChange'

		HRESULT __stdcall GetGenerationChange(
			[in, out] long* GenerationId,
			[out, retval] ISpeechLexiconWords** ppWords);"

	<virtual stdcall: hresult 15 sdword* ISpeechLexiconWords**>
	^self invalidCall
!

getPronunciations: bstrWord
	"Answer the <ISpeechLexiconPronunciations> result of invoking the GetPronunciations() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 getPronunciations: bstrWord
		 langId: 0
		 typeFlags: 3!

getPronunciations: bstrWord langId: langId typeFlags: typeFlags
	"Answer the <ISpeechLexiconPronunciations> result of invoking the GetPronunciations() method of the COM object.
	Helpstring: 'GetPronunciations'"

	| answer |
	answer := ISpeechLexiconPronunciations newPointer.
	self
		GetPronunciations: bstrWord
		LangId: langId
		TypeFlags: typeFlags
		ppPronunciations: answer.
	^answer asObject
!

GetPronunciations: bstrWord LangId: langId TypeFlags: typeFlags ppPronunciations: ppPronunciations
	"Private - Invoke the GetPronunciations() method of the COM object.
	Helpstring: 'GetPronunciations'

		HRESULT __stdcall GetPronunciations(
			[in] BSTR bstrWord,
			[in, defaultvalue(0)] long LangId,
			[in, defaultvalue(3)] SpeechLexiconType TypeFlags,
			[out, retval] ISpeechLexiconPronunciations** ppPronunciations);"

	<virtual stdcall: hresult 14 bstr sdword sdword ISpeechLexiconPronunciations**>
	^self invalidCall
!

getWords
	"Invoke the GetWords() method of the COM object.
	Default values are passed for all optional parameters."

	^self getWords: 3!

getWords: flags
	"Invoke the GetWords() method of the COM object.
	Helpstring: 'GetWords'"

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (SDWORD new);
				basicAt: 2 put: ISpeechLexiconWords newPointer;
				yourself.
	self
		GetWords: flags
		GenerationId: (answer basicAt: 1)
		Words: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetWords: flags GenerationId: generationId Words: words
	"Private - Invoke the GetWords() method of the COM object.
	Helpstring: 'GetWords'

		HRESULT __stdcall GetWords(
			[in, defaultvalue(3)] SpeechLexiconType Flags,
			[out, defaultvalue(0)] long* GenerationId,
			[out, retval] ISpeechLexiconWords** Words);"

	<virtual stdcall: hresult 9 sdword sdword* ISpeechLexiconWords**>
	^self invalidCall
!

removePronunciation: bstrWord langId: langId
	"Invoke the RemovePronunciation() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 removePronunciation: bstrWord
		 langId: langId
		 partOfSpeech: 0
		 bstrPronunciation: ''!

removePronunciation: bstrWord langId: langId partOfSpeech: partOfSpeech bstrPronunciation: bstrPronunciation
	"Invoke the RemovePronunciation() method of the COM object.
	Helpstring: 'RemovePronunciation'"

	^self
		RemovePronunciation: bstrWord
		LangId: langId
		PartOfSpeech: partOfSpeech
		bstrPronunciation: bstrPronunciation
!

RemovePronunciation: bstrWord LangId: langId PartOfSpeech: partOfSpeech bstrPronunciation: bstrPronunciation
	"Private - Invoke the RemovePronunciation() method of the COM object.
	Helpstring: 'RemovePronunciation'

		HRESULT __stdcall RemovePronunciation(
			[in] BSTR bstrWord,
			[in] long LangId,
			[in, defaultvalue(0)] SpeechPartOfSpeech PartOfSpeech,
			[in, defaultvalue("")] BSTR bstrPronunciation);"

	<virtual stdcall: hresult 12 bstr sdword sdword bstr>
	^self invalidCall
!

removePronunciationByPhoneIds: bstrWord langId: langId
	"Invoke the RemovePronunciationByPhoneIds() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 removePronunciationByPhoneIds: bstrWord
		 langId: langId
		 partOfSpeech: 0
		 phoneIds: ''!

removePronunciationByPhoneIds: bstrWord langId: langId partOfSpeech: partOfSpeech phoneIds: phoneIds
	"Invoke the RemovePronunciationByPhoneIds() method of the COM object.
	Helpstring: 'RemovePronunciationByPhoneIds'"

	^self
		RemovePronunciationByPhoneIds: bstrWord
		LangId: langId
		PartOfSpeech: partOfSpeech
		PhoneIds: phoneIds asVariant
!

RemovePronunciationByPhoneIds: bstrWord LangId: langId PartOfSpeech: partOfSpeech PhoneIds: phoneIds
	"Private - Invoke the RemovePronunciationByPhoneIds() method of the COM object.
	Helpstring: 'RemovePronunciationByPhoneIds'

		HRESULT __stdcall RemovePronunciationByPhoneIds(
			[in] BSTR bstrWord,
			[in] long LangId,
			[in, defaultvalue(0)] SpeechPartOfSpeech PartOfSpeech,
			[in, defaultvalue("")] VARIANT* PhoneIds);"

	<virtual stdcall: hresult 13 bstr sdword sdword variant*>
	^self invalidCall
! !
!ISpeechLexicon categoriesFor: #addPronunciation:langId:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #addPronunciation:langId:partOfSpeech:bstrPronunciation:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #AddPronunciation:LangId:PartOfSpeech:bstrPronunciation:!**auto generated**!COM Interfaces-ISpeechLexicon!private! !
!ISpeechLexicon categoriesFor: #addPronunciationByPhoneIds:langId:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #addPronunciationByPhoneIds:langId:partOfSpeech:phoneIds:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #AddPronunciationByPhoneIds:LangId:PartOfSpeech:PhoneIds:!**auto generated**!COM Interfaces-ISpeechLexicon!private! !
!ISpeechLexicon categoriesFor: #generationId!**auto generated**!properties!public! !
!ISpeechLexicon categoriesFor: #get_GenerationId:!**auto generated**!COM Interfaces-ISpeechLexicon!private! !
!ISpeechLexicon categoriesFor: #getGenerationChange:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #GetGenerationChange:ppWords:!**auto generated**!COM Interfaces-ISpeechLexicon!private! !
!ISpeechLexicon categoriesFor: #getPronunciations:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #getPronunciations:langId:typeFlags:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #GetPronunciations:LangId:TypeFlags:ppPronunciations:!**auto generated**!COM Interfaces-ISpeechLexicon!private! !
!ISpeechLexicon categoriesFor: #getWords!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #getWords:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #GetWords:GenerationId:Words:!**auto generated**!COM Interfaces-ISpeechLexicon!private! !
!ISpeechLexicon categoriesFor: #removePronunciation:langId:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #removePronunciation:langId:partOfSpeech:bstrPronunciation:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #RemovePronunciation:LangId:PartOfSpeech:bstrPronunciation:!**auto generated**!COM Interfaces-ISpeechLexicon!private! !
!ISpeechLexicon categoriesFor: #removePronunciationByPhoneIds:langId:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #removePronunciationByPhoneIds:langId:partOfSpeech:phoneIds:!**auto generated**!methods!public! !
!ISpeechLexicon categoriesFor: #RemovePronunciationByPhoneIds:LangId:PartOfSpeech:PhoneIds:!**auto generated**!COM Interfaces-ISpeechLexicon!private! !

!ISpeechLexicon class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechLexicon'
		ISpeechLexicon defineTemplate"

	self
		defineFunction: #get_GenerationId:
			argumentTypes: 'sdword*';
		defineFunction: #GetWords:GenerationId:Words:
			argumentTypes: 'sdword sdword* ISpeechLexiconWords**';
		defineFunction: #AddPronunciation:LangId:PartOfSpeech:bstrPronunciation:
			argumentTypes: 'bstr sdword sdword bstr';
		defineFunction: #AddPronunciationByPhoneIds:LangId:PartOfSpeech:PhoneIds:
			argumentTypes: 'bstr sdword sdword variant*';
		defineFunction: #RemovePronunciation:LangId:PartOfSpeech:bstrPronunciation:
			argumentTypes: 'bstr sdword sdword bstr';
		defineFunction: #RemovePronunciationByPhoneIds:LangId:PartOfSpeech:PhoneIds:
			argumentTypes: 'bstr sdword sdword variant*';
		defineFunction: #GetPronunciations:LangId:TypeFlags:ppPronunciations:
			argumentTypes: 'bstr sdword sdword ISpeechLexiconPronunciations**';
		defineFunction: #GetGenerationChange:ppWords:
			argumentTypes: 'sdword* ISpeechLexiconWords**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechLexicon initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechLexicon class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechLexicon class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

