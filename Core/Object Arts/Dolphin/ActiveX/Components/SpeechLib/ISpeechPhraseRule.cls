"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechPhraseRule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseRule guid: (IID fromString: '{A7BFE112-A4A0-48D9-B602-C313843F6964}')!
ISpeechPhraseRule comment: '<ISpeechPhraseRule> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseRule'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseRule Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(A7BFE112-A4A0-48D9-B602-C313843F6964), 
	helpstring("ISpeechPhraseRule Interface"), 
	dual
]
interface ISpeechPhraseRule : IDispatch {
	[id(0x00000001), propget, helpstring("Name")]
	HRESULT __stdcall Name(
		[out, retval] BSTR* Name);
	[id(0x00000002), propget, helpstring("Id")]
	HRESULT __stdcall Id(
		[out, retval] long* Id);
	[id(0x00000003), propget, helpstring("FirstElement")]
	HRESULT __stdcall FirstElement(
		[out, retval] long* FirstElement);
	[id(0x00000004), propget, helpstring("NumElements")]
	HRESULT __stdcall NumberOfElements(
		[out, retval] long* NumberOfElements);
	[id(0x00000005), propget, helpstring("Parent")]
	HRESULT __stdcall Parent(
		[out, retval] ISpeechPhraseRule** Parent);
	[id(0x00000006), propget, helpstring("Children")]
	HRESULT __stdcall Children(
		[out, retval] ISpeechPhraseRules** Children);
	[id(0x00000007), propget, helpstring("Confidence")]
	HRESULT __stdcall Confidence(
		[out, retval] SpeechEngineConfidence* ActualConfidence);
	[id(0x00000008), propget, helpstring("EngineConfidence")]
	HRESULT __stdcall EngineConfidence(
		[out, retval] single* EngineConfidence);
};
'!
!ISpeechPhraseRule categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseRule methodsFor!

children
	"Answer the <ISpeechPhraseRules> value of the 'Children' property of the receiver.
	Helpstring: 'Children'"

	| answer |
	answer := ISpeechPhraseRules newPointer.
	self get_Children: answer.
	^answer asObject
!

confidence
	"Answer the <sdword> value of the 'Confidence' property of the receiver.
	Helpstring: 'Confidence'"

	| answer |
	answer := (SDWORD new).
	self get_Confidence: answer.
	^answer asObject
!

engineConfidence
	"Answer the <float> value of the 'EngineConfidence' property of the receiver.
	Helpstring: 'EngineConfidence'"

	| answer |
	answer := (FLOAT new).
	self get_EngineConfidence: answer.
	^answer asObject
!

firstElement
	"Answer the <sdword> value of the 'FirstElement' property of the receiver.
	Helpstring: 'FirstElement'"

	| answer |
	answer := (SDWORD new).
	self get_FirstElement: answer.
	^answer asObject
!

get_Children: children
	"Private - Get the value of the 'Children' property of the receiver.

		HRESULT __stdcall Children(
			[out, retval] ISpeechPhraseRules** Children);"

	<virtual stdcall: hresult 13 ISpeechPhraseRules**>
	^self invalidCall
!

get_Confidence: actualConfidence
	"Private - Get the value of the 'Confidence' property of the receiver.

		HRESULT __stdcall Confidence(
			[out, retval] SpeechEngineConfidence* ActualConfidence);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall
!

get_EngineConfidence: engineConfidence
	"Private - Get the value of the 'EngineConfidence' property of the receiver.

		HRESULT __stdcall EngineConfidence(
			[out, retval] single* EngineConfidence);"

	<virtual stdcall: hresult 15 float*>
	^self invalidCall
!

get_FirstElement: firstElement
	"Private - Get the value of the 'FirstElement' property of the receiver.

		HRESULT __stdcall FirstElement(
			[out, retval] long* FirstElement);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

get_Id: id
	"Private - Get the value of the 'Id' property of the receiver.

		HRESULT __stdcall Id(
			[out, retval] long* Id);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

get_Name: name
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval] BSTR* Name);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall
!

get_NumberOfElements: numberOfElements
	"Private - Get the value of the 'NumberOfElements' property of the receiver.

		HRESULT __stdcall NumberOfElements(
			[out, retval] long* NumberOfElements);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall
!

get_Parent: parent
	"Private - Get the value of the 'Parent' property of the receiver.

		HRESULT __stdcall Parent(
			[out, retval] ISpeechPhraseRule** Parent);"

	<virtual stdcall: hresult 12 ISpeechPhraseRule**>
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

name
	"Answer the <bstr> value of the 'Name' property of the receiver.
	Helpstring: 'Name'"

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject
!

numberOfElements
	"Answer the <sdword> value of the 'NumberOfElements' property of the receiver.
	Helpstring: 'NumElements'"

	| answer |
	answer := (SDWORD new).
	self get_NumberOfElements: answer.
	^answer asObject
!

parent
	"Answer the <ISpeechPhraseRule> value of the 'Parent' property of the receiver.
	Helpstring: 'Parent'"

	| answer |
	answer := ISpeechPhraseRule newPointer.
	self get_Parent: answer.
	^answer asObject
! !
!ISpeechPhraseRule categoriesFor: #children!**auto generated**!properties!public! !
!ISpeechPhraseRule categoriesFor: #confidence!**auto generated**!properties!public! !
!ISpeechPhraseRule categoriesFor: #engineConfidence!**auto generated**!properties!public! !
!ISpeechPhraseRule categoriesFor: #firstElement!**auto generated**!properties!public! !
!ISpeechPhraseRule categoriesFor: #get_Children:!**auto generated**!COM Interfaces-ISpeechPhraseRule!private! !
!ISpeechPhraseRule categoriesFor: #get_Confidence:!**auto generated**!COM Interfaces-ISpeechPhraseRule!private! !
!ISpeechPhraseRule categoriesFor: #get_EngineConfidence:!**auto generated**!COM Interfaces-ISpeechPhraseRule!private! !
!ISpeechPhraseRule categoriesFor: #get_FirstElement:!**auto generated**!COM Interfaces-ISpeechPhraseRule!private! !
!ISpeechPhraseRule categoriesFor: #get_Id:!**auto generated**!COM Interfaces-ISpeechPhraseRule!private! !
!ISpeechPhraseRule categoriesFor: #get_Name:!**auto generated**!COM Interfaces-ISpeechPhraseRule!private! !
!ISpeechPhraseRule categoriesFor: #get_NumberOfElements:!**auto generated**!COM Interfaces-ISpeechPhraseRule!private! !
!ISpeechPhraseRule categoriesFor: #get_Parent:!**auto generated**!COM Interfaces-ISpeechPhraseRule!private! !
!ISpeechPhraseRule categoriesFor: #id!**auto generated**!properties!public! !
!ISpeechPhraseRule categoriesFor: #name!**auto generated**!properties!public! !
!ISpeechPhraseRule categoriesFor: #numberOfElements!**auto generated**!properties!public! !
!ISpeechPhraseRule categoriesFor: #parent!**auto generated**!properties!public! !

!ISpeechPhraseRule class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseRule'
		ISpeechPhraseRule defineTemplate"

	self
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_Id:
			argumentTypes: 'sdword*';
		defineFunction: #get_FirstElement:
			argumentTypes: 'sdword*';
		defineFunction: #get_NumberOfElements:
			argumentTypes: 'sdword*';
		defineFunction: #get_Parent:
			argumentTypes: 'ISpeechPhraseRule**';
		defineFunction: #get_Children:
			argumentTypes: 'ISpeechPhraseRules**';
		defineFunction: #get_Confidence:
			argumentTypes: 'sdword*';
		defineFunction: #get_EngineConfidence:
			argumentTypes: 'float*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseRule initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseRule class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseRule class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

