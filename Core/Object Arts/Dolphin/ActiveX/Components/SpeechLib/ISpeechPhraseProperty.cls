"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechPhraseProperty
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhraseProperty guid: (IID fromString: '{CE563D48-961E-4732-A2E1-378A42B430BE}')!
ISpeechPhraseProperty comment: '<ISpeechPhraseProperty> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhraseProperty'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhraseProperty Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(CE563D48-961E-4732-A2E1-378A42B430BE), 
	helpstring("ISpeechPhraseProperty Interface"), 
	dual
]
interface ISpeechPhraseProperty : IDispatch {
	[id(0x00000001), propget, helpstring("Name")]
	HRESULT __stdcall Name(
		[out, retval] BSTR* Name);
	[id(0x00000002), propget, helpstring("Id")]
	HRESULT __stdcall Id(
		[out, retval] long* Id);
	[id(0x00000003), propget, helpstring("Value")]
	HRESULT __stdcall Value(
		[out, retval] VARIANT* Value);
	[id(0x00000004), propget, helpstring("FirstElement")]
	HRESULT __stdcall FirstElement(
		[out, retval] long* FirstElement);
	[id(0x00000005), propget, helpstring("NumberOfElements")]
	HRESULT __stdcall NumberOfElements(
		[out, retval] long* NumberOfElements);
	[id(0x00000006), propget, helpstring("EngineConfidence")]
	HRESULT __stdcall EngineConfidence(
		[out, retval] single* Confidence);
	[id(0x00000007), propget, helpstring("Confidence")]
	HRESULT __stdcall Confidence(
		[out, retval] SpeechEngineConfidence* Confidence);
	[id(0x00000008), propget, helpstring("Parent")]
	HRESULT __stdcall Parent(
		[out, retval] ISpeechPhraseProperty** ParentProperty);
	[id(0x00000009), propget, helpstring("Children")]
	HRESULT __stdcall Children(
		[out, retval] ISpeechPhraseProperties** Children);
};
'!
!ISpeechPhraseProperty categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhraseProperty methodsFor!

children
	"Answer the <ISpeechPhraseProperties> value of the 'Children' property of the receiver.
	Helpstring: 'Children'"

	| answer |
	answer := ISpeechPhraseProperties newPointer.
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
			[out, retval] ISpeechPhraseProperties** Children);"

	<virtual stdcall: hresult 16 ISpeechPhraseProperties**>
	^self invalidCall
!

get_Confidence: confidence
	"Private - Get the value of the 'Confidence' property of the receiver.

		HRESULT __stdcall Confidence(
			[out, retval] SpeechEngineConfidence* Confidence);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall
!

get_EngineConfidence: confidence
	"Private - Get the value of the 'EngineConfidence' property of the receiver.

		HRESULT __stdcall EngineConfidence(
			[out, retval] single* Confidence);"

	<virtual stdcall: hresult 13 float*>
	^self invalidCall
!

get_FirstElement: firstElement
	"Private - Get the value of the 'FirstElement' property of the receiver.

		HRESULT __stdcall FirstElement(
			[out, retval] long* FirstElement);"

	<virtual stdcall: hresult 11 sdword*>
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

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall
!

get_Parent: parentProperty
	"Private - Get the value of the 'Parent' property of the receiver.

		HRESULT __stdcall Parent(
			[out, retval] ISpeechPhraseProperty** ParentProperty);"

	<virtual stdcall: hresult 15 ISpeechPhraseProperty**>
	^self invalidCall
!

get_Value: value
	"Private - Get the value of the 'Value' property of the receiver.

		HRESULT __stdcall Value(
			[out, retval] VARIANT* Value);"

	<virtual stdcall: hresult 10 variant*>
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
	Helpstring: 'NumberOfElements'"

	| answer |
	answer := (SDWORD new).
	self get_NumberOfElements: answer.
	^answer asObject
!

parent
	"Answer the <ISpeechPhraseProperty> value of the 'Parent' property of the receiver.
	Helpstring: 'Parent'"

	| answer |
	answer := ISpeechPhraseProperty newPointer.
	self get_Parent: answer.
	^answer asObject
!

value
	"Answer the <variant> value of the 'Value' property of the receiver.
	Helpstring: 'Value'"

	| answer |
	answer := VARIANT new.
	self get_Value: answer.
	^answer asObject
! !
!ISpeechPhraseProperty categoriesFor: #children!**auto generated**!properties!public! !
!ISpeechPhraseProperty categoriesFor: #confidence!**auto generated**!properties!public! !
!ISpeechPhraseProperty categoriesFor: #engineConfidence!**auto generated**!properties!public! !
!ISpeechPhraseProperty categoriesFor: #firstElement!**auto generated**!properties!public! !
!ISpeechPhraseProperty categoriesFor: #get_Children:!**auto generated**!COM Interfaces-ISpeechPhraseProperty!private! !
!ISpeechPhraseProperty categoriesFor: #get_Confidence:!**auto generated**!COM Interfaces-ISpeechPhraseProperty!private! !
!ISpeechPhraseProperty categoriesFor: #get_EngineConfidence:!**auto generated**!COM Interfaces-ISpeechPhraseProperty!private! !
!ISpeechPhraseProperty categoriesFor: #get_FirstElement:!**auto generated**!COM Interfaces-ISpeechPhraseProperty!private! !
!ISpeechPhraseProperty categoriesFor: #get_Id:!**auto generated**!COM Interfaces-ISpeechPhraseProperty!private! !
!ISpeechPhraseProperty categoriesFor: #get_Name:!**auto generated**!COM Interfaces-ISpeechPhraseProperty!private! !
!ISpeechPhraseProperty categoriesFor: #get_NumberOfElements:!**auto generated**!COM Interfaces-ISpeechPhraseProperty!private! !
!ISpeechPhraseProperty categoriesFor: #get_Parent:!**auto generated**!COM Interfaces-ISpeechPhraseProperty!private! !
!ISpeechPhraseProperty categoriesFor: #get_Value:!**auto generated**!COM Interfaces-ISpeechPhraseProperty!private! !
!ISpeechPhraseProperty categoriesFor: #id!**auto generated**!properties!public! !
!ISpeechPhraseProperty categoriesFor: #name!**auto generated**!properties!public! !
!ISpeechPhraseProperty categoriesFor: #numberOfElements!**auto generated**!properties!public! !
!ISpeechPhraseProperty categoriesFor: #parent!**auto generated**!properties!public! !
!ISpeechPhraseProperty categoriesFor: #value!**auto generated**!properties!public! !

!ISpeechPhraseProperty class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhraseProperty'
		ISpeechPhraseProperty defineTemplate"

	self
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_Id:
			argumentTypes: 'sdword*';
		defineFunction: #get_Value:
			argumentTypes: 'variant*';
		defineFunction: #get_FirstElement:
			argumentTypes: 'sdword*';
		defineFunction: #get_NumberOfElements:
			argumentTypes: 'sdword*';
		defineFunction: #get_EngineConfidence:
			argumentTypes: 'float*';
		defineFunction: #get_Confidence:
			argumentTypes: 'sdword*';
		defineFunction: #get_Parent:
			argumentTypes: 'ISpeechPhraseProperty**';
		defineFunction: #get_Children:
			argumentTypes: 'ISpeechPhraseProperties**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhraseProperty initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhraseProperty class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhraseProperty class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

