﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch subclass: #'VBScript.IMatch'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
VBScript.IMatch guid: (OS.COM.IID fromString: '{3f4daca1-160d-11d2-a8e9-00104b365c9f}')!
VBScript.IMatch comment: '`IMatch` is a wrapper class for the COM interface ''VBScript_RegExp_55.IMatch'' generated from type information in the ''Microsoft VBScript Regular Expressions 5.5'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3f4daca1-160d-11d2-a8e9-00104b365c9f), 
	hidden, 
	nonextensible, 
	dual
]
interface IMatch : IDispatch
 {
	[id(0000000000), propget]
	HRESULT __stdcall Value(
		[out, retval]BSTR* pValue);
	[id(0x00002711), propget]
	HRESULT __stdcall FirstIndex(
		[out, retval]long* pFirstIndex);
	[id(0x00002712), propget]
	HRESULT __stdcall Length(
		[out, retval]long* pLength);
};
```'!
!VBScript.IMatch categoriesForClass!COM-Interfaces!VBScript_RegExp_55-Interfaces! !
!VBScript.IMatch methodsFor!

firstIndex
	"Answer the <sdword> value of the 'FirstIndex' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_FirstIndex: answer.
	^answer asObject!

get_FirstIndex: pFirstIndex
	"Private - Get the value of the 'FirstIndex' property of the receiver.

		HRESULT __stdcall FirstIndex(
			[out, retval]long* pFirstIndex);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall: _failureCode!

get_Length: pLength
	"Private - Get the value of the 'Length' property of the receiver.

		HRESULT __stdcall Length(
			[out, retval]long* pLength);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall: _failureCode!

get_Value: pValue
	"Private - Get the value of the 'Value' property of the receiver.

		HRESULT __stdcall Value(
			[out, retval]BSTR* pValue);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

length
	"Answer the <sdword> value of the 'Length' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Length: answer.
	^answer asObject!

range
	"Answer the <Interval> in which this match was found in the source text."

	| start |
	start := self firstIndex.
	^start + 1 to: start + self length!

value
	"Answer the <String> value of the regex match."

	| bstr answer |
	bstr := BSTR new.
	self get_Value: bstr.
	answer := bstr asUtf16String.
	bstr free.
	^answer! !
!VBScript.IMatch categoriesFor: #firstIndex!**auto generated**!properties!public! !
!VBScript.IMatch categoriesFor: #get_FirstIndex:!**auto generated**!COM Interfaces-IMatch!private! !
!VBScript.IMatch categoriesFor: #get_Length:!**auto generated**!COM Interfaces-IMatch!private! !
!VBScript.IMatch categoriesFor: #get_Value:!**auto generated**!COM Interfaces-IMatch!private! !
!VBScript.IMatch categoriesFor: #isExtensible!**auto generated**!public!testing! !
!VBScript.IMatch categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!VBScript.IMatch categoriesFor: #length!**auto generated**!properties!public! !
!VBScript.IMatch categoriesFor: #range!accessing!public! !
!VBScript.IMatch categoriesFor: #value!properties!public! !

!VBScript.IMatch class methodsFor!

clsid
	"Private - Answer the CLSID of the associated coclass, Match, which is noncreatable."

	^CLSID fromString: '{3F4DACA5-160D-11D2-A8E9-00104B365C9F}'!

defineFunctions
	"Declare the virtual function table for the COM interface 'VBScript_RegExp_55.IMatch'
		IMatch defineTemplate"

	self
		defineFunction: #get_Value:
			argumentTypes: 'bstr*';
		defineFunction: #get_FirstIndex:
			argumentTypes: 'sdword*';
		defineFunction: #get_Length:
			argumentTypes: 'sdword*'! !
!VBScript.IMatch class categoriesFor: #clsid!constants!private! !
!VBScript.IMatch class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
