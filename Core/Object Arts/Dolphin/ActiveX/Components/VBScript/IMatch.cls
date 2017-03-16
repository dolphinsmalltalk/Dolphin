"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IMatch
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IMatch guid: (IID fromString: '{3F4DACA1-160D-11D2-A8E9-00104B365C9F}')!
IMatch comment: '<IMatch> is a wrapper class for the COM interface ''VBScript_RegExp_55.IMatch'' generated from type information in the ''Microsoft VBScript Regular Expressions 5.5'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(3F4DACA1-160D-11D2-A8E9-00104B365C9F), 
	hidden, 
	dual, 
	nonextensible
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
'!
!IMatch categoriesForClass!COM-Interfaces!VBScript_RegExp_55-Interfaces! !
!IMatch methodsFor!

firstIndex
	"Answer the <sdword> value of the 'FirstIndex' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_FirstIndex: answer.
	^answer asObject
!

get_FirstIndex: pFirstIndex
	"Private - Get the value of the 'FirstIndex' property of the receiver.

		HRESULT __stdcall FirstIndex(
			[out, retval]long* pFirstIndex);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall!

get_Length: pLength
	"Private - Get the value of the 'Length' property of the receiver.

		HRESULT __stdcall Length(
			[out, retval]long* pLength);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall!

get_Value: pValue
	"Private - Get the value of the 'Value' property of the receiver.

		HRESULT __stdcall Value(
			[out, retval]BSTR* pValue);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

length
	"Answer the <sdword> value of the 'Length' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Length: answer.
	^answer asObject
!

range
	"Answer the <Interval> in which this match was found in the source text."

	| start |
	start := self firstIndex.
	^start + 1 to: start + self length!

value
	"Answer the <bstr> value of the 'Value' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Value: answer.
	^answer asObject
! !
!IMatch categoriesFor: #firstIndex!**auto generated**!properties!public! !
!IMatch categoriesFor: #get_FirstIndex:!**auto generated**!COM Interfaces-IMatch!private! !
!IMatch categoriesFor: #get_Length:!**auto generated**!COM Interfaces-IMatch!private! !
!IMatch categoriesFor: #get_Value:!**auto generated**!COM Interfaces-IMatch!private! !
!IMatch categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IMatch categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IMatch categoriesFor: #length!**auto generated**!properties!public! !
!IMatch categoriesFor: #range!accessing!public! !
!IMatch categoriesFor: #value!**auto generated**!properties!public! !

!IMatch class methodsFor!

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
			argumentTypes: 'sdword*'
! !
!IMatch class categoriesFor: #clsid!constants!private! !
!IMatch class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

