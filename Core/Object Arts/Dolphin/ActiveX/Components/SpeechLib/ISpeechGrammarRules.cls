"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechGrammarRules
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechGrammarRules guid: (IID fromString: '{6FFA3B44-FC2D-40D1-8AFC-32911C7F1AD1}')!
ISpeechGrammarRules comment: '<ISpeechGrammarRules> is a wrapper class for the COM interface ''SpeechLib.ISpeechGrammarRules'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechGrammarRules Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(6FFA3B44-FC2D-40D1-8AFC-32911C7F1AD1), 
	helpstring("ISpeechGrammarRules Interface"), 
	dual
]
interface ISpeechGrammarRules : IDispatch {
	[id(0x00000001), propget, helpstring("Count")]
	HRESULT __stdcall Count(
		[out, retval] long* Count);
	[id(0x00000006), helpstring("FindRule")]
	HRESULT __stdcall FindRule(
		[in] VARIANT RuleNameOrId,
		[out, retval] ISpeechGrammarRule** Rule);
	[id(0000000000), helpstring("Item")]
	HRESULT __stdcall Item(
		[in] long Index,
		[out, retval] ISpeechGrammarRule** Rule);
	[id(0xfffffffc), propget, restricted, helpstring("Enumerates the alternates")]
	HRESULT __stdcall _NewEnum(
		[out, retval] IUnknown** EnumVARIANT);
	[id(0x00000002), propget, helpstring("Dynamic")]
	HRESULT __stdcall Dynamic(
		[out, retval] VARIANT_BOOL* Dynamic);
	[id(0x00000003), helpstring("Add")]
	HRESULT __stdcall Add(
		[in] BSTR RuleName,
		[in] SpeechRuleAttributes Attributes,
		[in, defaultvalue(0)] long RuleId,
		[out, retval] ISpeechGrammarRule** Rule);
	[id(0x00000004), helpstring("Commit")]
	HRESULT __stdcall Commit();
	[id(0x00000005), helpstring("CommitAndSave")]
	HRESULT __stdcall CommitAndSave(
		[out] BSTR* ErrorText,
		[out, retval] VARIANT* SaveStream);
};
'!
!ISpeechGrammarRules categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechGrammarRules methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver.
	Helpstring: 'Enumerates the alternates'"

	| answer |
	answer := IUnknown newPointer.
	self get__NewEnum: answer.
	^answer asObject
!

add: ruleName attributes: attributes
	"Answer the <ISpeechGrammarRule> result of invoking the Add() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 add: ruleName
		 attributes: attributes
		 ruleId: 0!

add: ruleName attributes: attributes ruleId: ruleId
	"Answer the <ISpeechGrammarRule> result of invoking the Add() method of the COM object.
	Helpstring: 'Add'"

	| answer |
	answer := ISpeechGrammarRule newPointer.
	self
		Add: ruleName
		Attributes: attributes
		RuleId: ruleId
		Rule: answer.
	^answer asObject
!

Add: ruleName Attributes: attributes RuleId: ruleId Rule: rule
	"Private - Invoke the Add() method of the COM object.
	Helpstring: 'Add'

		HRESULT __stdcall Add(
			[in] BSTR RuleName,
			[in] SpeechRuleAttributes Attributes,
			[in, defaultvalue(0)] long RuleId,
			[out, retval] ISpeechGrammarRule** Rule);"

	<virtual stdcall: hresult 13 bstr sdword sdword ISpeechGrammarRule**>
	^self invalidCall
!

commit
	"Invoke the Commit() method of the COM object.
	Helpstring: 'Commit'"

	^self Commit
!

Commit
	"Private - Invoke the Commit() method of the COM object.
	Helpstring: 'Commit'

		HRESULT __stdcall Commit();"

	<virtual stdcall: hresult 14>
	^self invalidCall
!

commitAndSave
	"Invoke the CommitAndSave() method of the COM object.
	Helpstring: 'CommitAndSave'"

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: BSTR new;
				basicAt: 2 put: VARIANT new;
				yourself.
	self
		CommitAndSave: (answer basicAt: 1)
		SaveStream: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

CommitAndSave: errorText SaveStream: saveStream
	"Private - Invoke the CommitAndSave() method of the COM object.
	Helpstring: 'CommitAndSave'

		HRESULT __stdcall CommitAndSave(
			[out] BSTR* ErrorText,
			[out, retval] VARIANT* SaveStream);"

	<virtual stdcall: hresult 15 bstr* variant*>
	^self invalidCall
!

count
	"Answer the <sdword> value of the 'Count' property of the receiver.
	Helpstring: 'Count'"

	| answer |
	answer := (SDWORD new).
	self get_Count: answer.
	^answer asObject
!

dynamic
	"Answer the <varbool> value of the 'Dynamic' property of the receiver.
	Helpstring: 'Dynamic'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Dynamic: answer.
	^answer asObject
!

findRule: ruleNameOrId
	"Answer the <ISpeechGrammarRule> result of invoking the FindRule() method of the COM object.
	Helpstring: 'FindRule'"

	| answer |
	answer := ISpeechGrammarRule newPointer.
	self
		FindRule: ruleNameOrId asVariant
		Rule: answer.
	^answer asObject
!

FindRule: ruleNameOrId Rule: rule
	"Private - Invoke the FindRule() method of the COM object.
	Helpstring: 'FindRule'

		HRESULT __stdcall FindRule(
			[in] VARIANT RuleNameOrId,
			[out, retval] ISpeechGrammarRule** Rule);"

	<virtual stdcall: hresult 9 variant ISpeechGrammarRule**>
	^self invalidCall
!

get__NewEnum: enumVARIANT
	"Private - Get the value of the '_NewEnum' property of the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval] IUnknown** EnumVARIANT);"

	<virtual stdcall: hresult 11 IUnknown**>
	^self invalidCall
!

get_Count: count
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval] long* Count);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_Dynamic: dynamic
	"Private - Get the value of the 'Dynamic' property of the receiver.

		HRESULT __stdcall Dynamic(
			[out, retval] VARIANT_BOOL* Dynamic);"

	<virtual stdcall: hresult 12 varbool*>
	^self invalidCall
!

isVBCollection
	"Answer whether the receiver is a VB style collection.
	The receiver is dynamically extensible, so we cannot determine this from the
	type library, and must perform a run-time check for the _NewEnum property."

	^true!

item: index
	"Answer the <ISpeechGrammarRule> result of invoking the Item() method of the COM object.
	Helpstring: 'Item'"

	| answer |
	answer := ISpeechGrammarRule newPointer.
	self
		Item: index
		Rule: answer.
	^answer asObject
!

Item: index Rule: rule
	"Private - Invoke the Item() method of the COM object.
	Helpstring: 'Item'

		HRESULT __stdcall Item(
			[in] long Index,
			[out, retval] ISpeechGrammarRule** Rule);"

	<virtual stdcall: hresult 10 sdword ISpeechGrammarRule**>
	^self invalidCall
!

value: index
	"Set the 'Item' property of the receiver to the <ISpeechGrammarRule**> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self item: index
! !
!ISpeechGrammarRules categoriesFor: #_newEnum!**auto generated**!properties!public! !
!ISpeechGrammarRules categoriesFor: #add:attributes:!**auto generated**!methods!public! !
!ISpeechGrammarRules categoriesFor: #add:attributes:ruleId:!**auto generated**!methods!public! !
!ISpeechGrammarRules categoriesFor: #Add:Attributes:RuleId:Rule:!**auto generated**!COM Interfaces-ISpeechGrammarRules!private! !
!ISpeechGrammarRules categoriesFor: #commit!**auto generated**!methods!public! !
!ISpeechGrammarRules categoriesFor: #Commit!**auto generated**!COM Interfaces-ISpeechGrammarRules!private! !
!ISpeechGrammarRules categoriesFor: #commitAndSave!**auto generated**!methods!public! !
!ISpeechGrammarRules categoriesFor: #CommitAndSave:SaveStream:!**auto generated**!COM Interfaces-ISpeechGrammarRules!private! !
!ISpeechGrammarRules categoriesFor: #count!**auto generated**!properties!public! !
!ISpeechGrammarRules categoriesFor: #dynamic!**auto generated**!properties!public! !
!ISpeechGrammarRules categoriesFor: #findRule:!**auto generated**!methods!public! !
!ISpeechGrammarRules categoriesFor: #FindRule:Rule:!**auto generated**!COM Interfaces-ISpeechGrammarRules!private! !
!ISpeechGrammarRules categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-ISpeechGrammarRules!private! !
!ISpeechGrammarRules categoriesFor: #get_Count:!**auto generated**!COM Interfaces-ISpeechGrammarRules!private! !
!ISpeechGrammarRules categoriesFor: #get_Dynamic:!**auto generated**!COM Interfaces-ISpeechGrammarRules!private! !
!ISpeechGrammarRules categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISpeechGrammarRules categoriesFor: #item:!**auto generated**!methods!public! !
!ISpeechGrammarRules categoriesFor: #Item:Rule:!**auto generated**!COM Interfaces-ISpeechGrammarRules!private! !
!ISpeechGrammarRules categoriesFor: #value:!**auto generated**!properties!public! !

!ISpeechGrammarRules class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechGrammarRules'
		ISpeechGrammarRules defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #FindRule:Rule:
			argumentTypes: 'variant ISpeechGrammarRule**';
		defineFunction: #Item:Rule:
			argumentTypes: 'sdword ISpeechGrammarRule**';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**';
		defineFunction: #get_Dynamic:
			argumentTypes: 'varbool*';
		defineFunction: #Add:Attributes:RuleId:Rule:
			argumentTypes: 'bstr sdword sdword ISpeechGrammarRule**';
		defineFunction: #Commit;
		defineFunction: #CommitAndSave:SaveStream:
			argumentTypes: 'bstr* variant*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechGrammarRules initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechGrammarRules class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechGrammarRules class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

