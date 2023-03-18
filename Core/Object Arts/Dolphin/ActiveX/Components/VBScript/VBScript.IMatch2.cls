"Filed out from Dolphin Smalltalk"!

VBScript.IMatch
	subclass: #'VBScript.IMatch2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
VBScript.IMatch2 guid: (OS.COM.IID fromString: '{3f4dacb1-160d-11d2-a8e9-00104b365c9f}')!
VBScript.IMatch2 comment: '`IMatch2` is a wrapper class for the COM interface ''VBScript_RegExp_55.IMatch2'' generated from type information in the ''Microsoft VBScript Regular Expressions 5.5'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3f4dacb1-160d-11d2-a8e9-00104b365c9f), 
	hidden, 
	nonextensible, 
	dual
]
interface IMatch2 : IDispatch
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
	[id(0x00002713), propget]
	HRESULT __stdcall SubMatches(
		[out, retval]IDispatch** ppSubMatches);
};
```
'!
!VBScript.IMatch2 categoriesForClass!COM-Interfaces!VBScript_RegExp_55-Interfaces! !
!VBScript.IMatch2 methodsFor!

get_SubMatches: ppSubMatches
	"Private - Get the value of the 'SubMatches' property of the receiver.

		HRESULT __stdcall SubMatches(
			[out, retval]IDispatch** ppSubMatches);"

	<virtual stdcall: hresult 11 IDispatch**>
	^self invalidCall: _failureCode!

subMatches
	"Answer an <Array> of <String> representing the sub-matches of the receiver."

	| subMatches answer |
	subMatches := ISubMatches newPointer.
	self get_SubMatches: subMatches.
	answer := subMatches asArray.
	subMatches free.
	^answer! !
!VBScript.IMatch2 categoriesForMethods!
get_SubMatches:!**auto generated**!COM Interfaces-IMatch2!private! !
subMatches!properties!public! !
!

!VBScript.IMatch2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'VBScript_RegExp_55.IMatch2'
		IMatch2 defineTemplate"

	self
		defineFunction: #get_SubMatches:
			argumentTypes: 'IDispatch**'
! !
!VBScript.IMatch2 class categoriesForMethods!
defineFunctions!initializing!public! !
!

