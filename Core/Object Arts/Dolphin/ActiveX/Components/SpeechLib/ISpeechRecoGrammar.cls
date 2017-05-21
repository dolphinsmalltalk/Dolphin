"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechRecoGrammar
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechRecoGrammar guid: (IID fromString: '{B6D6F79F-2158-4E50-B5BC-9A9CCD852A09}')!
ISpeechRecoGrammar comment: '<ISpeechRecoGrammar> is a wrapper class for the COM interface ''SpeechLib.ISpeechRecoGrammar'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechRecoGrammar Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(B6D6F79F-2158-4E50-B5BC-9A9CCD852A09), 
	helpstring("ISpeechRecoGrammar Interface"), 
	dual
]
interface ISpeechRecoGrammar : IDispatch {
	[id(0x00000001), propget, helpstring("Id")]
	HRESULT __stdcall Id(
		[out, retval] VARIANT* Id);
	[id(0x00000002), propget, helpstring("RecoContext")]
	HRESULT __stdcall RecoContext(
		[out, retval] ISpeechRecoContext** RecoContext);
	[id(0x00000003), propput, helpstring("State")]
	HRESULT __stdcall State(
		[in] SpeechGrammarState State);
	[id(0x00000003), propget, helpstring("State")]
	HRESULT __stdcall State(
		[out, retval] SpeechGrammarState* State);
	[id(0x00000004), propget, helpstring("Rules")]
	HRESULT __stdcall Rules(
		[out, retval] ISpeechGrammarRules** Rules);
	[id(0x00000005), helpstring("Reset")]
	HRESULT __stdcall Reset(
		[in, defaultvalue(0)] long NewLanguage);
	[id(0x00000007), helpstring("CmdLoadFromFile")]
	HRESULT __stdcall CmdLoadFromFile(
		[in] BSTR FileName,
		[in, defaultvalue(0)] SpeechLoadOption LoadOption);
	[id(0x00000008), helpstring("CmdLoadFromObject")]
	HRESULT __stdcall CmdLoadFromObject(
		[in] BSTR ClassId,
		[in] BSTR GrammarName,
		[in, defaultvalue(0)] SpeechLoadOption LoadOption);
	[id(0x00000009), helpstring("CmdLoadFromResource")]
	HRESULT __stdcall CmdLoadFromResource(
		[in] long hModule,
		[in] VARIANT ResourceName,
		[in] VARIANT ResourceType,
		[in] long LanguageId,
		[in, defaultvalue(0)] SpeechLoadOption LoadOption);
	[id(0x0000000a), helpstring("CmdLoadFromMemory")]
	HRESULT __stdcall CmdLoadFromMemory(
		[in] VARIANT GrammarData,
		[in, defaultvalue(0)] SpeechLoadOption LoadOption);
	[id(0x0000000b), helpstring("CmdLoadFromProprietaryGrammar")]
	HRESULT __stdcall CmdLoadFromProprietaryGrammar(
		[in] BSTR ProprietaryGuid,
		[in] BSTR ProprietaryString,
		[in] VARIANT ProprietaryData,
		[in, defaultvalue(0)] SpeechLoadOption LoadOption);
	[id(0x0000000c), helpstring("CmdSetRuleState")]
	HRESULT __stdcall CmdSetRuleState(
		[in] BSTR Name,
		[in] SpeechRuleState State);
	[id(0x0000000d), helpstring("CmdSetRuleIdState")]
	HRESULT __stdcall CmdSetRuleIdState(
		[in] long RuleId,
		[in] SpeechRuleState State);
	[id(0x0000000e), helpstring("DictationLoad")]
	HRESULT __stdcall DictationLoad(
		[in, defaultvalue("")] BSTR TopicName,
		[in, defaultvalue(0)] SpeechLoadOption LoadOption);
	[id(0x0000000f), helpstring("DictationUnload")]
	HRESULT __stdcall DictationUnload();
	[id(0x00000010), helpstring("DictationSetState")]
	HRESULT __stdcall DictationSetState(
		[in] SpeechRuleState State);
	[id(0x00000011), helpstring("SetWordSequenceData")]
	HRESULT __stdcall SetWordSequenceData(
		[in] BSTR Text,
		[in] long TextLength,
		[in] ISpeechTextSelectionInformation* Info);
	[id(0x00000012), helpstring("SetTextSelection")]
	HRESULT __stdcall SetTextSelection(
		[in] ISpeechTextSelectionInformation* Info);
	[id(0x00000013), helpstring("IsPronounceable")]
	HRESULT __stdcall IsPronounceable(
		[in] BSTR Word,
		[out, retval] SpeechWordPronounceable* WordPronounceable);
};
'!
!ISpeechRecoGrammar categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechRecoGrammar methodsFor!

cmdLoadFromFile: fileName
	"Invoke the CmdLoadFromFile() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 cmdLoadFromFile: fileName
		 loadOption: 0!

cmdLoadFromFile: fileName loadOption: loadOption
	"Invoke the CmdLoadFromFile() method of the COM object.
	Helpstring: 'CmdLoadFromFile'"

	^self
		CmdLoadFromFile: fileName
		LoadOption: loadOption
!

CmdLoadFromFile: fileName LoadOption: loadOption
	"Private - Invoke the CmdLoadFromFile() method of the COM object.
	Helpstring: 'CmdLoadFromFile'

		HRESULT __stdcall CmdLoadFromFile(
			[in] BSTR FileName,
			[in, defaultvalue(0)] SpeechLoadOption LoadOption);"

	<virtual stdcall: hresult 14 bstr sdword>
	^self invalidCall
!

cmdLoadFromMemory: grammarData
	"Invoke the CmdLoadFromMemory() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 cmdLoadFromMemory: grammarData
		 loadOption: 0!

cmdLoadFromMemory: grammarData loadOption: loadOption
	"Invoke the CmdLoadFromMemory() method of the COM object.
	Helpstring: 'CmdLoadFromMemory'"

	^self
		CmdLoadFromMemory: grammarData asVariant
		LoadOption: loadOption
!

CmdLoadFromMemory: grammarData LoadOption: loadOption
	"Private - Invoke the CmdLoadFromMemory() method of the COM object.
	Helpstring: 'CmdLoadFromMemory'

		HRESULT __stdcall CmdLoadFromMemory(
			[in] VARIANT GrammarData,
			[in, defaultvalue(0)] SpeechLoadOption LoadOption);"

	<virtual stdcall: hresult 17 variant sdword>
	^self invalidCall
!

cmdLoadFromObject: classId grammarName: grammarName
	"Invoke the CmdLoadFromObject() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 cmdLoadFromObject: classId
		 grammarName: grammarName
		 loadOption: 0!

cmdLoadFromObject: classId grammarName: grammarName loadOption: loadOption
	"Invoke the CmdLoadFromObject() method of the COM object.
	Helpstring: 'CmdLoadFromObject'"

	^self
		CmdLoadFromObject: classId
		GrammarName: grammarName
		LoadOption: loadOption
!

CmdLoadFromObject: classId GrammarName: grammarName LoadOption: loadOption
	"Private - Invoke the CmdLoadFromObject() method of the COM object.
	Helpstring: 'CmdLoadFromObject'

		HRESULT __stdcall CmdLoadFromObject(
			[in] BSTR ClassId,
			[in] BSTR GrammarName,
			[in, defaultvalue(0)] SpeechLoadOption LoadOption);"

	<virtual stdcall: hresult 15 bstr bstr sdword>
	^self invalidCall
!

cmdLoadFromProprietaryGrammar: proprietaryGuid proprietaryString: proprietaryString proprietaryData: proprietaryData
	"Invoke the CmdLoadFromProprietaryGrammar() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 cmdLoadFromProprietaryGrammar: proprietaryGuid
		 proprietaryString: proprietaryString
		 proprietaryData: proprietaryData
		 loadOption: 0!

cmdLoadFromProprietaryGrammar: proprietaryGuid proprietaryString: proprietaryString proprietaryData: proprietaryData loadOption: loadOption
	"Invoke the CmdLoadFromProprietaryGrammar() method of the COM object.
	Helpstring: 'CmdLoadFromProprietaryGrammar'"

	^self
		CmdLoadFromProprietaryGrammar: proprietaryGuid
		ProprietaryString: proprietaryString
		ProprietaryData: proprietaryData asVariant
		LoadOption: loadOption
!

CmdLoadFromProprietaryGrammar: proprietaryGuid ProprietaryString: proprietaryString ProprietaryData: proprietaryData LoadOption: loadOption
	"Private - Invoke the CmdLoadFromProprietaryGrammar() method of the COM object.
	Helpstring: 'CmdLoadFromProprietaryGrammar'

		HRESULT __stdcall CmdLoadFromProprietaryGrammar(
			[in] BSTR ProprietaryGuid,
			[in] BSTR ProprietaryString,
			[in] VARIANT ProprietaryData,
			[in, defaultvalue(0)] SpeechLoadOption LoadOption);"

	<virtual stdcall: hresult 18 bstr bstr variant sdword>
	^self invalidCall
!

cmdLoadFromResource: hModule resourceName: resourceName resourceType: resourceType languageId: languageId
	"Invoke the CmdLoadFromResource() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 cmdLoadFromResource: hModule
		 resourceName: resourceName
		 resourceType: resourceType
		 languageId: languageId
		 loadOption: 0!

cmdLoadFromResource: hModule resourceName: resourceName resourceType: resourceType languageId: languageId loadOption: loadOption
	"Invoke the CmdLoadFromResource() method of the COM object.
	Helpstring: 'CmdLoadFromResource'"

	^self
		CmdLoadFromResource: hModule
		ResourceName: resourceName asVariant
		ResourceType: resourceType asVariant
		LanguageId: languageId
		LoadOption: loadOption
!

CmdLoadFromResource: hModule ResourceName: resourceName ResourceType: resourceType LanguageId: languageId LoadOption: loadOption
	"Private - Invoke the CmdLoadFromResource() method of the COM object.
	Helpstring: 'CmdLoadFromResource'

		HRESULT __stdcall CmdLoadFromResource(
			[in] long hModule,
			[in] VARIANT ResourceName,
			[in] VARIANT ResourceType,
			[in] long LanguageId,
			[in, defaultvalue(0)] SpeechLoadOption LoadOption);"

	<virtual stdcall: hresult 16 sdword variant variant sdword sdword>
	^self invalidCall
!

cmdSetRuleIdState: ruleId state: state
	"Invoke the CmdSetRuleIdState() method of the COM object.
	Helpstring: 'CmdSetRuleIdState'"

	^self
		CmdSetRuleIdState: ruleId
		State: state
!

CmdSetRuleIdState: ruleId State: state
	"Private - Invoke the CmdSetRuleIdState() method of the COM object.
	Helpstring: 'CmdSetRuleIdState'

		HRESULT __stdcall CmdSetRuleIdState(
			[in] long RuleId,
			[in] SpeechRuleState State);"

	<virtual stdcall: hresult 20 sdword sdword>
	^self invalidCall
!

cmdSetRuleState: name state: state
	"Invoke the CmdSetRuleState() method of the COM object.
	Helpstring: 'CmdSetRuleState'"

	^self
		CmdSetRuleState: name
		State: state
!

CmdSetRuleState: name State: state
	"Private - Invoke the CmdSetRuleState() method of the COM object.
	Helpstring: 'CmdSetRuleState'

		HRESULT __stdcall CmdSetRuleState(
			[in] BSTR Name,
			[in] SpeechRuleState State);"

	<virtual stdcall: hresult 19 bstr sdword>
	^self invalidCall
!

dictationLoad
	"Invoke the DictationLoad() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 dictationLoad: ''
		 loadOption: 0!

dictationLoad: topicName loadOption: loadOption
	"Invoke the DictationLoad() method of the COM object.
	Helpstring: 'DictationLoad'"

	^self
		DictationLoad: topicName
		LoadOption: loadOption
!

DictationLoad: topicName LoadOption: loadOption
	"Private - Invoke the DictationLoad() method of the COM object.
	Helpstring: 'DictationLoad'

		HRESULT __stdcall DictationLoad(
			[in, defaultvalue("")] BSTR TopicName,
			[in, defaultvalue(0)] SpeechLoadOption LoadOption);"

	<virtual stdcall: hresult 21 bstr sdword>
	^self invalidCall
!

dictationSetState: state
	"Invoke the DictationSetState() method of the COM object.
	Helpstring: 'DictationSetState'"

	^self DictationSetState: state
!

DictationSetState: state
	"Private - Invoke the DictationSetState() method of the COM object.
	Helpstring: 'DictationSetState'

		HRESULT __stdcall DictationSetState(
			[in] SpeechRuleState State);"

	<virtual stdcall: hresult 23 sdword>
	^self invalidCall
!

dictationUnload
	"Invoke the DictationUnload() method of the COM object.
	Helpstring: 'DictationUnload'"

	^self DictationUnload
!

DictationUnload
	"Private - Invoke the DictationUnload() method of the COM object.
	Helpstring: 'DictationUnload'

		HRESULT __stdcall DictationUnload();"

	<virtual stdcall: hresult 22>
	^self invalidCall
!

get_Id: id
	"Private - Get the value of the 'Id' property of the receiver.

		HRESULT __stdcall Id(
			[out, retval] VARIANT* Id);"

	<virtual stdcall: hresult 8 variant*>
	^self invalidCall
!

get_RecoContext: recoContext
	"Private - Get the value of the 'RecoContext' property of the receiver.

		HRESULT __stdcall RecoContext(
			[out, retval] ISpeechRecoContext** RecoContext);"

	<virtual stdcall: hresult 9 ISpeechRecoContext**>
	^self invalidCall
!

get_Rules: rules
	"Private - Get the value of the 'Rules' property of the receiver.

		HRESULT __stdcall Rules(
			[out, retval] ISpeechGrammarRules** Rules);"

	<virtual stdcall: hresult 12 ISpeechGrammarRules**>
	^self invalidCall
!

get_State: state
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval] SpeechGrammarState* State);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall
!

id
	"Answer the <variant> value of the 'Id' property of the receiver.
	Helpstring: 'Id'"

	| answer |
	answer := VARIANT new.
	self get_Id: answer.
	^answer asObject
!

isPronounceable: word
	"Answer the <SDWORD> result of invoking the IsPronounceable() method of the COM object.
	Helpstring: 'IsPronounceable'"

	| answer |
	answer := (SDWORD new).
	self
		IsPronounceable: word
		WordPronounceable: answer.
	^answer asObject
!

IsPronounceable: word WordPronounceable: wordPronounceable
	"Private - Invoke the IsPronounceable() method of the COM object.
	Helpstring: 'IsPronounceable'

		HRESULT __stdcall IsPronounceable(
			[in] BSTR Word,
			[out, retval] SpeechWordPronounceable* WordPronounceable);"

	<virtual stdcall: hresult 26 bstr sdword*>
	^self invalidCall
!

put_State: state
	"Private - Set the value of the 'State' property of the object wrapped by the 
	 receiver to the <sdword> argument, state.

		HRESULT __stdcall State(
			[in] SpeechGrammarState State);"

	<virtual stdcall: hresult 10 sdword>
	^self invalidCall
!

recoContext
	"Answer the <ISpeechRecoContext> value of the 'RecoContext' property of the receiver.
	Helpstring: 'RecoContext'"

	| answer |
	answer := ISpeechRecoContext newPointer.
	self get_RecoContext: answer.
	^answer asObject
!

reset
	"Invoke the Reset() method of the COM object.
	Default values are passed for all optional parameters."

	^self reset: 0!

reset: newLanguage
	"Invoke the Reset() method of the COM object.
	Helpstring: 'Reset'"

	^self Reset: newLanguage
!

Reset: newLanguage
	"Private - Invoke the Reset() method of the COM object.
	Helpstring: 'Reset'

		HRESULT __stdcall Reset(
			[in, defaultvalue(0)] long NewLanguage);"

	<virtual stdcall: hresult 13 sdword>
	^self invalidCall
!

rules
	"Answer the <ISpeechGrammarRules> value of the 'Rules' property of the receiver.
	Helpstring: 'Rules'"

	| answer |
	answer := ISpeechGrammarRules newPointer.
	self get_Rules: answer.
	^answer asObject
!

setTextSelection: info
	"Invoke the SetTextSelection() method of the COM object.
	Helpstring: 'SetTextSelection'"

	^self SetTextSelection: info
!

SetTextSelection: info
	"Private - Invoke the SetTextSelection() method of the COM object.
	Helpstring: 'SetTextSelection'

		HRESULT __stdcall SetTextSelection(
			[in] ISpeechTextSelectionInformation* Info);"

	<virtual stdcall: hresult 25 ISpeechTextSelectionInformation*>
	^self invalidCall
!

setWordSequenceData: text textLength: textLength info: info
	"Invoke the SetWordSequenceData() method of the COM object.
	Helpstring: 'SetWordSequenceData'"

	^self
		SetWordSequenceData: text
		TextLength: textLength
		Info: info
!

SetWordSequenceData: text TextLength: textLength Info: info
	"Private - Invoke the SetWordSequenceData() method of the COM object.
	Helpstring: 'SetWordSequenceData'

		HRESULT __stdcall SetWordSequenceData(
			[in] BSTR Text,
			[in] long TextLength,
			[in] ISpeechTextSelectionInformation* Info);"

	<virtual stdcall: hresult 24 bstr sdword ISpeechTextSelectionInformation*>
	^self invalidCall
!

state
	"Answer the <sdword> value of the 'State' property of the receiver.
	Helpstring: 'State'"

	| answer |
	answer := (SDWORD new).
	self get_State: answer.
	^answer asObject
!

state: state
	"Set the 'State' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'State'"

	self put_State: state
! !
!ISpeechRecoGrammar categoriesFor: #cmdLoadFromFile:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #cmdLoadFromFile:loadOption:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #CmdLoadFromFile:LoadOption:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #cmdLoadFromMemory:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #cmdLoadFromMemory:loadOption:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #CmdLoadFromMemory:LoadOption:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #cmdLoadFromObject:grammarName:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #cmdLoadFromObject:grammarName:loadOption:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #CmdLoadFromObject:GrammarName:LoadOption:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #cmdLoadFromProprietaryGrammar:proprietaryString:proprietaryData:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #cmdLoadFromProprietaryGrammar:proprietaryString:proprietaryData:loadOption:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #CmdLoadFromProprietaryGrammar:ProprietaryString:ProprietaryData:LoadOption:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #cmdLoadFromResource:resourceName:resourceType:languageId:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #cmdLoadFromResource:resourceName:resourceType:languageId:loadOption:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #CmdLoadFromResource:ResourceName:ResourceType:LanguageId:LoadOption:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #cmdSetRuleIdState:state:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #CmdSetRuleIdState:State:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #cmdSetRuleState:state:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #CmdSetRuleState:State:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #dictationLoad!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #dictationLoad:loadOption:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #DictationLoad:LoadOption:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #dictationSetState:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #DictationSetState:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #dictationUnload!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #DictationUnload!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #get_Id:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #get_RecoContext:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #get_Rules:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #get_State:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #id!**auto generated**!properties!public! !
!ISpeechRecoGrammar categoriesFor: #isPronounceable:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #IsPronounceable:WordPronounceable:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #put_State:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #recoContext!**auto generated**!properties!public! !
!ISpeechRecoGrammar categoriesFor: #reset!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #reset:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #Reset:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #rules!**auto generated**!properties!public! !
!ISpeechRecoGrammar categoriesFor: #setTextSelection:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #SetTextSelection:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #setWordSequenceData:textLength:info:!**auto generated**!methods!public! !
!ISpeechRecoGrammar categoriesFor: #SetWordSequenceData:TextLength:Info:!**auto generated**!COM Interfaces-ISpeechRecoGrammar!private! !
!ISpeechRecoGrammar categoriesFor: #state!**auto generated**!properties!public! !
!ISpeechRecoGrammar categoriesFor: #state:!**auto generated**!properties!public! !

!ISpeechRecoGrammar class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechRecoGrammar'
		ISpeechRecoGrammar defineTemplate"

	self
		defineFunction: #get_Id:
			argumentTypes: 'variant*';
		defineFunction: #get_RecoContext:
			argumentTypes: 'ISpeechRecoContext**';
		defineFunction: #put_State:
			argumentTypes: 'sdword';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #get_Rules:
			argumentTypes: 'ISpeechGrammarRules**';
		defineFunction: #Reset:
			argumentTypes: 'sdword';
		defineFunction: #CmdLoadFromFile:LoadOption:
			argumentTypes: 'bstr sdword';
		defineFunction: #CmdLoadFromObject:GrammarName:LoadOption:
			argumentTypes: 'bstr bstr sdword';
		defineFunction: #CmdLoadFromResource:ResourceName:ResourceType:LanguageId:LoadOption:
			argumentTypes: 'sdword variant variant sdword sdword';
		defineFunction: #CmdLoadFromMemory:LoadOption:
			argumentTypes: 'variant sdword';
		defineFunction: #CmdLoadFromProprietaryGrammar:ProprietaryString:ProprietaryData:LoadOption:
			argumentTypes: 'bstr bstr variant sdword';
		defineFunction: #CmdSetRuleState:State:
			argumentTypes: 'bstr sdword';
		defineFunction: #CmdSetRuleIdState:State:
			argumentTypes: 'sdword sdword';
		defineFunction: #DictationLoad:LoadOption:
			argumentTypes: 'bstr sdword';
		defineFunction: #DictationUnload;
		defineFunction: #DictationSetState:
			argumentTypes: 'sdword';
		defineFunction: #SetWordSequenceData:TextLength:Info:
			argumentTypes: 'bstr sdword ISpeechTextSelectionInformation*';
		defineFunction: #SetTextSelection:
			argumentTypes: 'ISpeechTextSelectionInformation*';
		defineFunction: #IsPronounceable:WordPronounceable:
			argumentTypes: 'bstr sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechRecoGrammar initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechRecoGrammar class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechRecoGrammar class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

