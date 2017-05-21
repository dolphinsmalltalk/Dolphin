"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechGrammarRule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechGrammarRule guid: (IID fromString: '{AFE719CF-5DD1-44F2-999C-7A399F1CFCCC}')!
ISpeechGrammarRule comment: '<ISpeechGrammarRule> is a wrapper class for the COM interface ''SpeechLib.ISpeechGrammarRule'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechGrammarRule Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(AFE719CF-5DD1-44F2-999C-7A399F1CFCCC), 
	helpstring("ISpeechGrammarRule Interface"), 
	dual
]
interface ISpeechGrammarRule : IDispatch {
	[id(0x00000001), propget, helpstring("RuleAttributes")]
	HRESULT __stdcall Attributes(
		[out, retval] SpeechRuleAttributes* Attributes);
	[id(0x00000002), propget, helpstring("InitialState")]
	HRESULT __stdcall InitialState(
		[out, retval] ISpeechGrammarRuleState** State);
	[id(0x00000003), propget, helpstring("Name")]
	HRESULT __stdcall Name(
		[out, retval] BSTR* Name);
	[id(0x00000004), propget, helpstring("Id")]
	HRESULT __stdcall Id(
		[out, retval] long* Id);
	[id(0x00000005), helpstring("Clear")]
	HRESULT __stdcall Clear();
	[id(0x00000006), helpstring("AddResource")]
	HRESULT __stdcall AddResource(
		[in] BSTR ResourceName,
		[in] BSTR ResourceValue);
	[id(0x00000007), helpstring("AddState")]
	HRESULT __stdcall AddState(
		[out, retval] ISpeechGrammarRuleState** State);
};
'!
!ISpeechGrammarRule categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechGrammarRule methodsFor!

addResource: resourceName resourceValue: resourceValue
	"Invoke the AddResource() method of the COM object.
	Helpstring: 'AddResource'"

	^self
		AddResource: resourceName
		ResourceValue: resourceValue
!

AddResource: resourceName ResourceValue: resourceValue
	"Private - Invoke the AddResource() method of the COM object.
	Helpstring: 'AddResource'

		HRESULT __stdcall AddResource(
			[in] BSTR ResourceName,
			[in] BSTR ResourceValue);"

	<virtual stdcall: hresult 13 bstr bstr>
	^self invalidCall
!

addState
	"Answer the <ISpeechGrammarRuleState> result of invoking the AddState() method of the COM object.
	Helpstring: 'AddState'"

	| answer |
	answer := ISpeechGrammarRuleState newPointer.
	self AddState: answer.
	^answer asObject
!

AddState: state
	"Private - Invoke the AddState() method of the COM object.
	Helpstring: 'AddState'

		HRESULT __stdcall AddState(
			[out, retval] ISpeechGrammarRuleState** State);"

	<virtual stdcall: hresult 14 ISpeechGrammarRuleState**>
	^self invalidCall
!

attributes
	"Answer the <sdword> value of the 'Attributes' property of the receiver.
	Helpstring: 'RuleAttributes'"

	| answer |
	answer := (SDWORD new).
	self get_Attributes: answer.
	^answer asObject
!

clear
	"Invoke the Clear() method of the COM object.
	Helpstring: 'Clear'"

	^self Clear
!

Clear
	"Private - Invoke the Clear() method of the COM object.
	Helpstring: 'Clear'

		HRESULT __stdcall Clear();"

	<virtual stdcall: hresult 12>
	^self invalidCall
!

get_Attributes: attributes
	"Private - Get the value of the 'Attributes' property of the receiver.

		HRESULT __stdcall Attributes(
			[out, retval] SpeechRuleAttributes* Attributes);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_Id: id
	"Private - Get the value of the 'Id' property of the receiver.

		HRESULT __stdcall Id(
			[out, retval] long* Id);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall
!

get_InitialState: state
	"Private - Get the value of the 'InitialState' property of the receiver.

		HRESULT __stdcall InitialState(
			[out, retval] ISpeechGrammarRuleState** State);"

	<virtual stdcall: hresult 9 ISpeechGrammarRuleState**>
	^self invalidCall
!

get_Name: name
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval] BSTR* Name);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

id
	"Answer the <sdword> value of the 'Id' property of the receiver.
	Helpstring: 'Id'"

	| answer |
	answer := (SDWORD new).
	self get_Id: answer.
	^answer asObject
!

initialState
	"Answer the <ISpeechGrammarRuleState> value of the 'InitialState' property of the receiver.
	Helpstring: 'InitialState'"

	| answer |
	answer := ISpeechGrammarRuleState newPointer.
	self get_InitialState: answer.
	^answer asObject
!

name
	"Answer the <bstr> value of the 'Name' property of the receiver.
	Helpstring: 'Name'"

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject
! !
!ISpeechGrammarRule categoriesFor: #addResource:resourceValue:!**auto generated**!methods!public! !
!ISpeechGrammarRule categoriesFor: #AddResource:ResourceValue:!**auto generated**!COM Interfaces-ISpeechGrammarRule!private! !
!ISpeechGrammarRule categoriesFor: #addState!**auto generated**!methods!public! !
!ISpeechGrammarRule categoriesFor: #AddState:!**auto generated**!COM Interfaces-ISpeechGrammarRule!private! !
!ISpeechGrammarRule categoriesFor: #attributes!**auto generated**!properties!public! !
!ISpeechGrammarRule categoriesFor: #clear!**auto generated**!methods!public! !
!ISpeechGrammarRule categoriesFor: #Clear!**auto generated**!COM Interfaces-ISpeechGrammarRule!private! !
!ISpeechGrammarRule categoriesFor: #get_Attributes:!**auto generated**!COM Interfaces-ISpeechGrammarRule!private! !
!ISpeechGrammarRule categoriesFor: #get_Id:!**auto generated**!COM Interfaces-ISpeechGrammarRule!private! !
!ISpeechGrammarRule categoriesFor: #get_InitialState:!**auto generated**!COM Interfaces-ISpeechGrammarRule!private! !
!ISpeechGrammarRule categoriesFor: #get_Name:!**auto generated**!COM Interfaces-ISpeechGrammarRule!private! !
!ISpeechGrammarRule categoriesFor: #id!**auto generated**!properties!public! !
!ISpeechGrammarRule categoriesFor: #initialState!**auto generated**!properties!public! !
!ISpeechGrammarRule categoriesFor: #name!**auto generated**!properties!public! !

!ISpeechGrammarRule class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechGrammarRule'
		ISpeechGrammarRule defineTemplate"

	self
		defineFunction: #get_Attributes:
			argumentTypes: 'sdword*';
		defineFunction: #get_InitialState:
			argumentTypes: 'ISpeechGrammarRuleState**';
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_Id:
			argumentTypes: 'sdword*';
		defineFunction: #Clear;
		defineFunction: #AddResource:ResourceValue:
			argumentTypes: 'bstr bstr';
		defineFunction: #AddState:
			argumentTypes: 'ISpeechGrammarRuleState**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechGrammarRule initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechGrammarRule class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechGrammarRule class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

