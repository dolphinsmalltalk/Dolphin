"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #ISpGrammarBuilder
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpGrammarBuilder guid: (IID fromString: '{8137828F-591A-4A42-BE58-49EA7EBAAC68}')!
ISpGrammarBuilder comment: '<ISpGrammarBuilder> is a wrapper class for the COM interface ''SpeechLib.ISpGrammarBuilder'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpGrammarBuilder Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(8137828F-591A-4A42-BE58-49EA7EBAAC68), 
	helpstring("ISpGrammarBuilder Interface"), 
	restricted
]
interface ISpGrammarBuilder : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall ResetGrammar(
		[in] unsigned short NewLanguage);
	[id(0x60010001)]
	HRESULT __stdcall GetRule(
		[in] unsigned short* pszRuleName,
		[in] unsigned long dwRuleId,
		[in] unsigned long dwAttributes,
		[in] long fCreateIfNotExist,
		[out] void** phInitialState);
	[id(0x60010002)]
	HRESULT __stdcall ClearRule(
		void* hState);
	[id(0x60010003)]
	HRESULT __stdcall CreateNewState(
		void* hState,
		void** phState);
	[id(0x60010004)]
	HRESULT __stdcall AddWordTransition(
		void* hFromState,
		void* hToState,
		unsigned short* psz,
		unsigned short* pszSeparators,
		SPGRAMMARWORDTYPE eWordType,
		single Weight,
		SPPROPERTYINFO* pPropInfo);
	[id(0x60010005)]
	HRESULT __stdcall AddRuleTransition(
		void* hFromState,
		void* hToState,
		void* hRule,
		single Weight,
		SPPROPERTYINFO* pPropInfo);
	[id(0x60010006)]
	HRESULT __stdcall AddResource(
		[in] void* hRuleState,
		[in] unsigned short* pszResourceName,
		[in] unsigned short* pszResourceValue);
	[id(0x60010007)]
	HRESULT __stdcall Commit(
		unsigned long dwReserved);
};
'!
!ISpGrammarBuilder categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpGrammarBuilder methodsFor!

addResource: hRuleState pszResourceName: pszResourceName pszResourceValue: pszResourceValue
	"Invoke the AddResource() method of the COM object."

	^self
		AddResource: hRuleState
		pszResourceName: pszResourceName
		pszResourceValue: pszResourceValue
!

AddResource: hRuleState pszResourceName: pszResourceName pszResourceValue: pszResourceValue
	"Private - Invoke the AddResource() method of the COM object.

		HRESULT __stdcall AddResource(
			[in] void* hRuleState,
			[in] unsigned short* pszResourceName,
			[in] unsigned short* pszResourceValue);"

	<virtual stdcall: hresult 10 void* word* word*>
	^self invalidCall
!

addRuleTransition: hFromState hToState: hToState hRule: hRule weight: weight pPropInfo: pPropInfo
	"Invoke the AddRuleTransition() method of the COM object."

	^self
		AddRuleTransition: hFromState
		hToState: hToState
		hRule: hRule
		Weight: weight
		pPropInfo: pPropInfo
!

AddRuleTransition: hFromState hToState: hToState hRule: hRule Weight: weight pPropInfo: pPropInfo
	"Private - Invoke the AddRuleTransition() method of the COM object.

		HRESULT __stdcall AddRuleTransition(
			void* hFromState,
			void* hToState,
			void* hRule,
			single Weight,
			SPPROPERTYINFO* pPropInfo);"

	<virtual stdcall: hresult 9 void* void* void* float SPPROPERTYINFO*>
	^self invalidCall
!

addWordTransition: hFromState hToState: hToState psz: psz pszSeparators: pszSeparators eWordType: eWordType weight: weight pPropInfo: pPropInfo
	"Invoke the AddWordTransition() method of the COM object."

	^self
		AddWordTransition: hFromState
		hToState: hToState
		psz: psz
		pszSeparators: pszSeparators
		eWordType: eWordType
		Weight: weight
		pPropInfo: pPropInfo
!

AddWordTransition: hFromState hToState: hToState psz: psz pszSeparators: pszSeparators eWordType: eWordType Weight: weight pPropInfo: pPropInfo
	"Private - Invoke the AddWordTransition() method of the COM object.

		HRESULT __stdcall AddWordTransition(
			void* hFromState,
			void* hToState,
			unsigned short* psz,
			unsigned short* pszSeparators,
			SPGRAMMARWORDTYPE eWordType,
			single Weight,
			SPPROPERTYINFO* pPropInfo);"

	<virtual stdcall: hresult 8 void* void* word* word* sdword float SPPROPERTYINFO*>
	^self invalidCall
!

clearRule: hState
	"Invoke the ClearRule() method of the COM object."

	^self ClearRule: hState
!

ClearRule: hState
	"Private - Invoke the ClearRule() method of the COM object.

		HRESULT __stdcall ClearRule(
			void* hState);"

	<virtual stdcall: hresult 6 void*>
	^self invalidCall
!

commit: dwReserved
	"Invoke the Commit() method of the COM object."

	^self Commit: dwReserved
!

Commit: dwReserved
	"Private - Invoke the Commit() method of the COM object.

		HRESULT __stdcall Commit(
			unsigned long dwReserved);"

	<virtual stdcall: hresult 11 dword>
	^self invalidCall
!

createNewState: hState phState: phState
	"Invoke the CreateNewState() method of the COM object."

	^self
		CreateNewState: hState
		phState: phState
!

CreateNewState: hState phState: phState
	"Private - Invoke the CreateNewState() method of the COM object.

		HRESULT __stdcall CreateNewState(
			void* hState,
			void** phState);"

	<virtual stdcall: hresult 7 void* void**>
	^self invalidCall
!

getRule: pszRuleName dwRuleId: dwRuleId dwAttributes: dwAttributes fCreateIfNotExist: fCreateIfNotExist
	"Answer the <VOID> result of invoking the GetRule() method of the COM object."

	| answer |
	answer := (VOID newBufferClass: COMTaskMemory).
	self
		GetRule: pszRuleName
		dwRuleId: dwRuleId
		dwAttributes: dwAttributes
		fCreateIfNotExist: fCreateIfNotExist
		phInitialState: answer.
	^answer asObject
!

GetRule: pszRuleName dwRuleId: dwRuleId dwAttributes: dwAttributes fCreateIfNotExist: fCreateIfNotExist phInitialState: phInitialState
	"Private - Invoke the GetRule() method of the COM object.

		HRESULT __stdcall GetRule(
			[in] unsigned short* pszRuleName,
			[in] unsigned long dwRuleId,
			[in] unsigned long dwAttributes,
			[in] long fCreateIfNotExist,
			[out] void** phInitialState);"

	<virtual stdcall: hresult 5 word* dword dword sdword void**>
	^self invalidCall
!

resetGrammar: newLanguage
	"Invoke the ResetGrammar() method of the COM object."

	^self ResetGrammar: newLanguage
!

ResetGrammar: newLanguage
	"Private - Invoke the ResetGrammar() method of the COM object.

		HRESULT __stdcall ResetGrammar(
			[in] unsigned short NewLanguage);"

	<virtual stdcall: hresult 4 word>
	^self invalidCall
! !
!ISpGrammarBuilder categoriesFor: #addResource:pszResourceName:pszResourceValue:!**auto generated**!methods!public! !
!ISpGrammarBuilder categoriesFor: #AddResource:pszResourceName:pszResourceValue:!**auto generated**!COM Interfaces-ISpGrammarBuilder!private! !
!ISpGrammarBuilder categoriesFor: #addRuleTransition:hToState:hRule:weight:pPropInfo:!**auto generated**!methods!public! !
!ISpGrammarBuilder categoriesFor: #AddRuleTransition:hToState:hRule:Weight:pPropInfo:!**auto generated**!COM Interfaces-ISpGrammarBuilder!private! !
!ISpGrammarBuilder categoriesFor: #addWordTransition:hToState:psz:pszSeparators:eWordType:weight:pPropInfo:!**auto generated**!methods!public! !
!ISpGrammarBuilder categoriesFor: #AddWordTransition:hToState:psz:pszSeparators:eWordType:Weight:pPropInfo:!**auto generated**!COM Interfaces-ISpGrammarBuilder!private! !
!ISpGrammarBuilder categoriesFor: #clearRule:!**auto generated**!methods!public! !
!ISpGrammarBuilder categoriesFor: #ClearRule:!**auto generated**!COM Interfaces-ISpGrammarBuilder!private! !
!ISpGrammarBuilder categoriesFor: #commit:!**auto generated**!methods!public! !
!ISpGrammarBuilder categoriesFor: #Commit:!**auto generated**!COM Interfaces-ISpGrammarBuilder!private! !
!ISpGrammarBuilder categoriesFor: #createNewState:phState:!**auto generated**!methods!public! !
!ISpGrammarBuilder categoriesFor: #CreateNewState:phState:!**auto generated**!COM Interfaces-ISpGrammarBuilder!private! !
!ISpGrammarBuilder categoriesFor: #getRule:dwRuleId:dwAttributes:fCreateIfNotExist:!**auto generated**!methods!public! !
!ISpGrammarBuilder categoriesFor: #GetRule:dwRuleId:dwAttributes:fCreateIfNotExist:phInitialState:!**auto generated**!COM Interfaces-ISpGrammarBuilder!private! !
!ISpGrammarBuilder categoriesFor: #resetGrammar:!**auto generated**!methods!public! !
!ISpGrammarBuilder categoriesFor: #ResetGrammar:!**auto generated**!COM Interfaces-ISpGrammarBuilder!private! !

!ISpGrammarBuilder class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpGrammarBuilder'
		ISpGrammarBuilder defineTemplate"

	self
		defineFunction: #ResetGrammar:
			argumentTypes: 'word';
		defineFunction: #GetRule:dwRuleId:dwAttributes:fCreateIfNotExist:phInitialState:
			argumentTypes: 'word* dword dword sdword void**';
		defineFunction: #ClearRule:
			argumentTypes: 'void*';
		defineFunction: #CreateNewState:phState:
			argumentTypes: 'void* void**';
		defineFunction: #AddWordTransition:hToState:psz:pszSeparators:eWordType:Weight:pPropInfo:
			argumentTypes: 'void* void* word* word* sdword float SPPROPERTYINFO*';
		defineFunction: #AddRuleTransition:hToState:hRule:Weight:pPropInfo:
			argumentTypes: 'void* void* void* float SPPROPERTYINFO*';
		defineFunction: #AddResource:pszResourceName:pszResourceValue:
			argumentTypes: 'void* word* word*';
		defineFunction: #Commit:
			argumentTypes: 'dword'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpGrammarBuilder initializeTypeLib"

	typeLib := SpeechLib! !
!ISpGrammarBuilder class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpGrammarBuilder class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

