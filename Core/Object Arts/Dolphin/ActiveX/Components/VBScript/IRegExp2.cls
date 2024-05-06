"Filed out from Dolphin Smalltalk"!

IRegExpAbstract subclass: #IRegExp2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IRegExp2 guid: (IID fromString: '{3f4dacb0-160d-11d2-a8e9-00104b365c9f}')!

IRegExp2 comment: '`IRegExp2` is a wrapper class for the COM interface ''VBScript_RegExp_55.IRegExp2'' generated from type information in the ''Microsoft VBScript Regular Expressions 5.5'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3f4dacb0-160d-11d2-a8e9-00104b365c9f), 
	hidden, 
	nonextensible, 
	dual
]
interface IRegExp2 : IDispatch
 {
	[id(0x00002711), propget]
	HRESULT __stdcall Pattern(
		[out, retval]BSTR* pPattern);
	[id(0x00002711), propput]
	HRESULT __stdcall Pattern(
		[in]BSTR pPattern);
	[id(0x00002712), propget]
	HRESULT __stdcall IgnoreCase(
		[out, retval]VARIANT_BOOL* pIgnoreCase);
	[id(0x00002712), propput]
	HRESULT __stdcall IgnoreCase(
		[in]VARIANT_BOOL pIgnoreCase);
	[id(0x00002713), propget]
	HRESULT __stdcall Global(
		[out, retval]VARIANT_BOOL* pGlobal);
	[id(0x00002713), propput]
	HRESULT __stdcall Global(
		[in]VARIANT_BOOL pGlobal);
	[id(0x00002717), propget]
	HRESULT __stdcall Multiline(
		[out, retval]VARIANT_BOOL* pMultiline);
	[id(0x00002717), propput]
	HRESULT __stdcall Multiline(
		[in]VARIANT_BOOL pMultiline);
	[id(0x00002714)]
	HRESULT __stdcall Execute(
		[in]BSTR sourceString,
		[out, retval]IDispatch** ppMatches);
	[id(0x00002715)]
	HRESULT __stdcall Test(
		[in]BSTR sourceString,
		[out, retval]VARIANT_BOOL* pMatch);
	[id(0x00002716)]
	HRESULT __stdcall Replace(
		[in]BSTR sourceString,
		[in]VARIANT replaceVar,
		[out, retval]BSTR* pDestString);
};
```
'!

!IRegExp2 categoriesForClass!COM-Interfaces!VBScript_RegExp_55-Interfaces! !

!IRegExp2 methodsFor!

Execute: sourceString ppMatches: ppMatches
	"Private - Invoke the Execute() method of the COM object.

		HRESULT __stdcall Execute(
			[in]BSTR sourceString,
			[out, retval]IDispatch** ppMatches);"

	<virtual stdcall: hresult 16 bstr IDispatch**>
	^self invalidCall: _failureCode!

get_Multiline: pMultiline
	"Private - Get the value of the 'Multiline' property of the receiver.

		HRESULT __stdcall Multiline(
			[out, retval]VARIANT_BOOL* pMultiline);"

	<virtual stdcall: hresult 14 varbool*>
	^self invalidCall: _failureCode!

matchCollectionClass
	^IMatchCollection2!

multiline
	"Answer the <varbool> value of the 'Multiline' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_Multiline: answer.
	^answer asObject!

multiline: pMultiline
	"Set the 'Multiline' property of the receiver to the <varbool> value of the argument."

	self put_Multiline: pMultiline!

put_Multiline: pMultiline
	"Private - Set the value of the 'Multiline' property of the object wrapped by the 
	 receiver to the <varbool> argument, pMultiline.

		HRESULT __stdcall Multiline(
			[in]VARIANT_BOOL pMultiline);"

	<virtual stdcall: hresult 15 varbool>
	^self invalidCall: _failureCode!

replace: sourceString replaceString: replaceString 
	"Answer the <String> result of performing a regular expression based search/replace, where
	the regular expression itself defines the text to search for, sourceString is the source text against
	which the search/replace is performed, and replaceString is the replacement pattern."

	^self replace: sourceString replaceVar: replaceString!

replace: sourceString replaceVar: replaceVar
	"Answer the <String> result of invoking the Replace() method of the COM object."

	| bstr answer |
	bstr := BSTR new.
	self
		Replace: sourceString
		replaceVar: replaceVar asVariant
		pDestString: bstr.
	answer := bstr asUtf16String.
	bstr free.
	^answer
!

Replace: sourceString replaceVar: replaceVar pDestString: pDestString
	"Private - Invoke the Replace() method of the COM object.

		HRESULT __stdcall Replace(
			[in]BSTR sourceString,
			[in]VARIANT replaceVar,
			[out, retval]BSTR* pDestString);"

	<virtual stdcall: hresult 18 bstr variant bstr*>
	^self invalidCall: _failureCode!

Test: sourceString pMatch: pMatch
	"Private - Invoke the Test() method of the COM object.

		HRESULT __stdcall Test(
			[in]BSTR sourceString,
			[out, retval]VARIANT_BOOL* pMatch);"

	<virtual stdcall: hresult 17 bstr varbool*>
	^self invalidCall: _failureCode! !

!IRegExp2 categoriesForMethods!
Execute:ppMatches:!**auto generated**!COM Interfaces-IRegExp2!private! !
get_Multiline:!**auto generated**!COM Interfaces-IRegExp2!private! !
matchCollectionClass!constants!private! !
multiline!**auto generated**!properties!public! !
multiline:!**auto generated**!properties!public! !
put_Multiline:!**auto generated**!COM Interfaces-IRegExp2!private! !
replace:replaceString:!methods!operations!public! !
replace:replaceVar:!methods!public! !
Replace:replaceVar:pDestString:!**auto generated**!COM Interfaces-IRegExp2!private! !
Test:pMatch:!**auto generated**!COM Interfaces-IRegExp2!private! !
!

!IRegExp2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'VBScript_RegExp_55.IRegExp2'
		IRegExp2 defineTemplate"

	self
		defineFunction: #get_Pattern:
			argumentTypes: 'bstr*';
		defineFunction: #put_Pattern:
			argumentTypes: 'bstr';
		defineFunction: #get_IgnoreCase:
			argumentTypes: 'varbool*';
		defineFunction: #put_IgnoreCase:
			argumentTypes: 'varbool';
		defineFunction: #get_Global:
			argumentTypes: 'varbool*';
		defineFunction: #put_Global:
			argumentTypes: 'varbool';
		defineFunction: #get_Multiline:
			argumentTypes: 'varbool*';
		defineFunction: #put_Multiline:
			argumentTypes: 'varbool';
		defineFunction: #Execute:ppMatches:
			argumentTypes: 'bstr IDispatch**';
		defineFunction: #Test:pMatch:
			argumentTypes: 'bstr varbool*';
		defineFunction: #Replace:replaceVar:pDestString:
			argumentTypes: 'bstr variant bstr*'
! !

!IRegExp2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

