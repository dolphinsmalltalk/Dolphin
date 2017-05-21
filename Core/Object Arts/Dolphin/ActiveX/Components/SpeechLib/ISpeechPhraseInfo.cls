"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechPhraseInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseInfo guid: (IID fromString: '{961559CF-4E67-4662-8BF0-D93F1FCD61B3}')!
ISpeechPhraseInfo comment: '<ISpeechPhraseInfo> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseInfo'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseInfo Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(961559CF-4E67-4662-8BF0-D93F1FCD61B3), 
	helpstring("ISpeechPhraseInfo Interface"), 
	dual
]
interface ISpeechPhraseInfo : IDispatch {
	[id(0x00000001), propget, helpstring("LanguageId")]
	HRESULT __stdcall LanguageId(
		[out, retval] long* LanguageId);
	[id(0x00000002), propget, helpstring("GrammarId")]
	HRESULT __stdcall GrammarId(
		[out, retval] VARIANT* GrammarId);
	[id(0x00000003), propget, helpstring("StartTime")]
	HRESULT __stdcall StartTime(
		[out, retval] VARIANT* StartTime);
	[id(0x00000004), propget, helpstring("AudioStreamPosition")]
	HRESULT __stdcall AudioStreamPosition(
		[out, retval] VARIANT* AudioStreamPosition);
	[id(0x00000005), propget, helpstring("AudioSizeBytes")]
	HRESULT __stdcall AudioSizeBytes(
		[out, retval] long* pAudioSizeBytes);
	[id(0x00000006), propget, helpstring("RetainedSizeBytes")]
	HRESULT __stdcall RetainedSizeBytes(
		[out, retval] long* RetainedSizeBytes);
	[id(0x00000007), propget, helpstring("AudioSizeTime")]
	HRESULT __stdcall AudioSizeTime(
		[out, retval] long* AudioSizeTime);
	[id(0x00000008), propget, helpstring("Rule")]
	HRESULT __stdcall Rule(
		[out, retval] ISpeechPhraseRule** Rule);
	[id(0x00000009), propget, helpstring("Properties")]
	HRESULT __stdcall Properties(
		[out, retval] ISpeechPhraseProperties** Properties);
	[id(0x0000000a), propget, helpstring("Elements")]
	HRESULT __stdcall Elements(
		[out, retval] ISpeechPhraseElements** Elements);
	[id(0x0000000b), propget, helpstring("Replacements")]
	HRESULT __stdcall Replacements(
		[out, retval] ISpeechPhraseReplacements** Replacements);
	[id(0x0000000c), propget, helpstring("EngineId")]
	HRESULT __stdcall EngineId(
		[out, retval] BSTR* EngineIdGuid);
	[id(0x0000000d), propget, helpstring("EnginePrivateData")]
	HRESULT __stdcall EnginePrivateData(
		[out, retval] VARIANT* PrivateData);
	[id(0x0000000e), helpstring("SaveToMemory")]
	HRESULT __stdcall SaveToMemory(
		[out, retval] VARIANT* PhraseBlock);
	[id(0x0000000f), helpstring("GetText")]
	HRESULT __stdcall GetText(
		[in, defaultvalue(0)] long StartElement,
		[in, defaultvalue(-1)] long Elements,
		[in, defaultvalue(true)] VARIANT_BOOL UseReplacements,
		[out, retval] BSTR* Text);
	[id(0x00000010), helpstring("DisplayAttributes")]
	HRESULT __stdcall GetDisplayAttributes(
		[in, defaultvalue(0)] long StartElement,
		[in, defaultvalue(-1)] long Elements,
		[in, defaultvalue(true)] VARIANT_BOOL UseReplacements,
		[out, retval] SpeechDisplayAttributes* DisplayAttributes);
};
'!
!ISpeechPhraseInfo categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseInfo methodsFor!

audioSizeBytes
	"Answer the <sdword> value of the 'AudioSizeBytes' property of the receiver.
	Helpstring: 'AudioSizeBytes'"

	| answer |
	answer := (SDWORD new).
	self get_AudioSizeBytes: answer.
	^answer asObject
!

audioSizeTime
	"Answer the <sdword> value of the 'AudioSizeTime' property of the receiver.
	Helpstring: 'AudioSizeTime'"

	| answer |
	answer := (SDWORD new).
	self get_AudioSizeTime: answer.
	^answer asObject
!

audioStreamPosition
	"Answer the <variant> value of the 'AudioStreamPosition' property of the receiver.
	Helpstring: 'AudioStreamPosition'"

	| answer |
	answer := VARIANT new.
	self get_AudioStreamPosition: answer.
	^answer asObject
!

elements
	"Answer the <ISpeechPhraseElements> value of the 'Elements' property of the receiver.
	Helpstring: 'Elements'"

	| answer |
	answer := ISpeechPhraseElements newPointer.
	self get_Elements: answer.
	^answer asObject
!

engineId
	"Answer the <bstr> value of the 'EngineId' property of the receiver.
	Helpstring: 'EngineId'"

	| answer |
	answer := BSTR new.
	self get_EngineId: answer.
	^answer asObject
!

enginePrivateData
	"Answer the <variant> value of the 'EnginePrivateData' property of the receiver.
	Helpstring: 'EnginePrivateData'"

	| answer |
	answer := VARIANT new.
	self get_EnginePrivateData: answer.
	^answer asObject
!

get_AudioSizeBytes: pAudioSizeBytes
	"Private - Get the value of the 'AudioSizeBytes' property of the receiver.

		HRESULT __stdcall AudioSizeBytes(
			[out, retval] long* pAudioSizeBytes);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall
!

get_AudioSizeTime: audioSizeTime
	"Private - Get the value of the 'AudioSizeTime' property of the receiver.

		HRESULT __stdcall AudioSizeTime(
			[out, retval] long* AudioSizeTime);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall
!

get_AudioStreamPosition: audioStreamPosition
	"Private - Get the value of the 'AudioStreamPosition' property of the receiver.

		HRESULT __stdcall AudioStreamPosition(
			[out, retval] VARIANT* AudioStreamPosition);"

	<virtual stdcall: hresult 11 variant*>
	^self invalidCall
!

get_Elements: elements
	"Private - Get the value of the 'Elements' property of the receiver.

		HRESULT __stdcall Elements(
			[out, retval] ISpeechPhraseElements** Elements);"

	<virtual stdcall: hresult 17 ISpeechPhraseElements**>
	^self invalidCall
!

get_EngineId: engineIdGuid
	"Private - Get the value of the 'EngineId' property of the receiver.

		HRESULT __stdcall EngineId(
			[out, retval] BSTR* EngineIdGuid);"

	<virtual stdcall: hresult 19 bstr*>
	^self invalidCall
!

get_EnginePrivateData: privateData
	"Private - Get the value of the 'EnginePrivateData' property of the receiver.

		HRESULT __stdcall EnginePrivateData(
			[out, retval] VARIANT* PrivateData);"

	<virtual stdcall: hresult 20 variant*>
	^self invalidCall
!

get_GrammarId: grammarId
	"Private - Get the value of the 'GrammarId' property of the receiver.

		HRESULT __stdcall GrammarId(
			[out, retval] VARIANT* GrammarId);"

	<virtual stdcall: hresult 9 variant*>
	^self invalidCall
!

get_LanguageId: languageId
	"Private - Get the value of the 'LanguageId' property of the receiver.

		HRESULT __stdcall LanguageId(
			[out, retval] long* LanguageId);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_Properties: properties
	"Private - Get the value of the 'Properties' property of the receiver.

		HRESULT __stdcall Properties(
			[out, retval] ISpeechPhraseProperties** Properties);"

	<virtual stdcall: hresult 16 ISpeechPhraseProperties**>
	^self invalidCall
!

get_Replacements: replacements
	"Private - Get the value of the 'Replacements' property of the receiver.

		HRESULT __stdcall Replacements(
			[out, retval] ISpeechPhraseReplacements** Replacements);"

	<virtual stdcall: hresult 18 ISpeechPhraseReplacements**>
	^self invalidCall
!

get_RetainedSizeBytes: retainedSizeBytes
	"Private - Get the value of the 'RetainedSizeBytes' property of the receiver.

		HRESULT __stdcall RetainedSizeBytes(
			[out, retval] long* RetainedSizeBytes);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall
!

get_Rule: rule
	"Private - Get the value of the 'Rule' property of the receiver.

		HRESULT __stdcall Rule(
			[out, retval] ISpeechPhraseRule** Rule);"

	<virtual stdcall: hresult 15 ISpeechPhraseRule**>
	^self invalidCall
!

get_StartTime: startTime
	"Private - Get the value of the 'StartTime' property of the receiver.

		HRESULT __stdcall StartTime(
			[out, retval] VARIANT* StartTime);"

	<virtual stdcall: hresult 10 variant*>
	^self invalidCall
!

getDisplayAttributes
	"Answer the <SDWORD> result of invoking the GetDisplayAttributes() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 getDisplayAttributes: 0
		 elements: -1
		 useReplacements: true!

getDisplayAttributes: startElement elements: elements useReplacements: useReplacements
	"Answer the <SDWORD> result of invoking the GetDisplayAttributes() method of the COM object.
	Helpstring: 'DisplayAttributes'"

	| answer |
	answer := (SDWORD new).
	self
		GetDisplayAttributes: startElement
		Elements: elements
		UseReplacements: useReplacements
		DisplayAttributes: answer.
	^answer asObject
!

GetDisplayAttributes: startElement Elements: elements UseReplacements: useReplacements DisplayAttributes: displayAttributes
	"Private - Invoke the GetDisplayAttributes() method of the COM object.
	Helpstring: 'DisplayAttributes'

		HRESULT __stdcall GetDisplayAttributes(
			[in, defaultvalue(0)] long StartElement,
			[in, defaultvalue(-1)] long Elements,
			[in, defaultvalue(true)] VARIANT_BOOL UseReplacements,
			[out, retval] SpeechDisplayAttributes* DisplayAttributes);"

	<virtual stdcall: hresult 23 sdword sdword varbool sdword*>
	^self invalidCall
!

getText
	"Answer the <BSTR> result of invoking the GetText() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 getText: 0
		 elements: -1
		 useReplacements: true!

getText: startElement elements: elements useReplacements: useReplacements
	"Answer the <BSTR> result of invoking the GetText() method of the COM object.
	Helpstring: 'GetText'"

	| answer |
	answer := BSTR new.
	self
		GetText: startElement
		Elements: elements
		UseReplacements: useReplacements
		Text: answer.
	^answer asObject
!

GetText: startElement Elements: elements UseReplacements: useReplacements Text: text
	"Private - Invoke the GetText() method of the COM object.
	Helpstring: 'GetText'

		HRESULT __stdcall GetText(
			[in, defaultvalue(0)] long StartElement,
			[in, defaultvalue(-1)] long Elements,
			[in, defaultvalue(true)] VARIANT_BOOL UseReplacements,
			[out, retval] BSTR* Text);"

	<virtual stdcall: hresult 22 sdword sdword varbool bstr*>
	^self invalidCall
!

grammarId
	"Answer the <variant> value of the 'GrammarId' property of the receiver.
	Helpstring: 'GrammarId'"

	| answer |
	answer := VARIANT new.
	self get_GrammarId: answer.
	^answer asObject
!

languageId
	"Answer the <sdword> value of the 'LanguageId' property of the receiver.
	Helpstring: 'LanguageId'"

	| answer |
	answer := (SDWORD new).
	self get_LanguageId: answer.
	^answer asObject
!

properties
	"Answer the <ISpeechPhraseProperties> value of the 'Properties' property of the receiver.
	Helpstring: 'Properties'"

	| answer |
	answer := ISpeechPhraseProperties newPointer.
	self get_Properties: answer.
	^answer asObject
!

replacements
	"Answer the <ISpeechPhraseReplacements> value of the 'Replacements' property of the receiver.
	Helpstring: 'Replacements'"

	| answer |
	answer := ISpeechPhraseReplacements newPointer.
	self get_Replacements: answer.
	^answer asObject
!

retainedSizeBytes
	"Answer the <sdword> value of the 'RetainedSizeBytes' property of the receiver.
	Helpstring: 'RetainedSizeBytes'"

	| answer |
	answer := (SDWORD new).
	self get_RetainedSizeBytes: answer.
	^answer asObject
!

rule
	"Answer the <ISpeechPhraseRule> value of the 'Rule' property of the receiver.
	Helpstring: 'Rule'"

	| answer |
	answer := ISpeechPhraseRule newPointer.
	self get_Rule: answer.
	^answer asObject
!

saveToMemory
	"Answer the <VARIANT> result of invoking the SaveToMemory() method of the COM object.
	Helpstring: 'SaveToMemory'"

	| answer |
	answer := VARIANT new.
	self SaveToMemory: answer.
	^answer asObject
!

SaveToMemory: phraseBlock
	"Private - Invoke the SaveToMemory() method of the COM object.
	Helpstring: 'SaveToMemory'

		HRESULT __stdcall SaveToMemory(
			[out, retval] VARIANT* PhraseBlock);"

	<virtual stdcall: hresult 21 variant*>
	^self invalidCall
!

startTime
	"Answer the <variant> value of the 'StartTime' property of the receiver.
	Helpstring: 'StartTime'"

	| answer |
	answer := VARIANT new.
	self get_StartTime: answer.
	^answer asObject
! !
!ISpeechPhraseInfo categoriesFor: #audioSizeBytes!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #audioSizeTime!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #audioStreamPosition!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #elements!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #engineId!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #enginePrivateData!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #get_AudioSizeBytes:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_AudioSizeTime:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_AudioStreamPosition:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_Elements:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_EngineId:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_EnginePrivateData:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_GrammarId:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_LanguageId:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_Properties:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_Replacements:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_RetainedSizeBytes:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_Rule:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #get_StartTime:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #getDisplayAttributes!**auto generated**!methods!public! !
!ISpeechPhraseInfo categoriesFor: #getDisplayAttributes:elements:useReplacements:!**auto generated**!methods!public! !
!ISpeechPhraseInfo categoriesFor: #GetDisplayAttributes:Elements:UseReplacements:DisplayAttributes:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #getText!**auto generated**!methods!public! !
!ISpeechPhraseInfo categoriesFor: #getText:elements:useReplacements:!**auto generated**!methods!public! !
!ISpeechPhraseInfo categoriesFor: #GetText:Elements:UseReplacements:Text:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #grammarId!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #languageId!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #properties!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #replacements!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #retainedSizeBytes!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #rule!**auto generated**!properties!public! !
!ISpeechPhraseInfo categoriesFor: #saveToMemory!**auto generated**!methods!public! !
!ISpeechPhraseInfo categoriesFor: #SaveToMemory:!**auto generated**!COM Interfaces-ISpeechPhraseInfo!private! !
!ISpeechPhraseInfo categoriesFor: #startTime!**auto generated**!properties!public! !

!ISpeechPhraseInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseInfo'
		ISpeechPhraseInfo defineTemplate"

	self
		defineFunction: #get_LanguageId:
			argumentTypes: 'sdword*';
		defineFunction: #get_GrammarId:
			argumentTypes: 'variant*';
		defineFunction: #get_StartTime:
			argumentTypes: 'variant*';
		defineFunction: #get_AudioStreamPosition:
			argumentTypes: 'variant*';
		defineFunction: #get_AudioSizeBytes:
			argumentTypes: 'sdword*';
		defineFunction: #get_RetainedSizeBytes:
			argumentTypes: 'sdword*';
		defineFunction: #get_AudioSizeTime:
			argumentTypes: 'sdword*';
		defineFunction: #get_Rule:
			argumentTypes: 'ISpeechPhraseRule**';
		defineFunction: #get_Properties:
			argumentTypes: 'ISpeechPhraseProperties**';
		defineFunction: #get_Elements:
			argumentTypes: 'ISpeechPhraseElements**';
		defineFunction: #get_Replacements:
			argumentTypes: 'ISpeechPhraseReplacements**';
		defineFunction: #get_EngineId:
			argumentTypes: 'bstr*';
		defineFunction: #get_EnginePrivateData:
			argumentTypes: 'variant*';
		defineFunction: #SaveToMemory:
			argumentTypes: 'variant*';
		defineFunction: #GetText:Elements:UseReplacements:Text:
			argumentTypes: 'sdword sdword varbool bstr*';
		defineFunction: #GetDisplayAttributes:Elements:UseReplacements:DisplayAttributes:
			argumentTypes: 'sdword sdword varbool sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseInfo initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseInfo class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseInfo class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

