"Filed out from Dolphin Smalltalk 7"!

IRegExpAbstract subclass: #IRegExp2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IRegExp2 guid: (IID fromString: '{3F4DACB0-160D-11D2-A8E9-00104B365C9F}')!
IRegExp2 comment: '<IRegExp2> is a wrapper class for the COM interface ''VBScript_RegExp_55.IRegExp2'' generated from type information in the ''Microsoft VBScript Regular Expressions 5.5'' library. It contains methods to invoke the member functions exposed by that interface.

IRegExp2 is similar to IRegExp, but adds the ability to perform multiline matches, and the match collections it creates can be queried for details of sub-matches.

IDL definition follows:

[
	object, 
	uuid(3F4DACB0-160D-11D2-A8E9-00104B365C9F), 
	hidden, 
	dual, 
	nonextensible
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
'!
!IRegExp2 categoriesForClass!COM-Interfaces!VBScript_RegExp_55-Interfaces! !
!IRegExp2 methodsFor!

Execute: sourceString ppMatches: ppMatches
	"Private - Invoke the Execute() method of the COM object.

		HRESULT __stdcall Execute(
			[in]BSTR sourceString,
			[out, retval]IDispatch** ppMatches);"

	<virtual stdcall: hresult 16 bstr IDispatch**>
	^self invalidCall!

get_Multiline: pMultiline
	"Private - Get the value of the 'Multiline' property of the receiver.

		HRESULT __stdcall Multiline(
			[out, retval]VARIANT_BOOL* pMultiline);"

	<virtual stdcall: hresult 14 varbool*>
	^self invalidCall!

matchCollectionClass
	^IMatchCollection2!

multiline
	"Answer the <varbool> value of the 'Multiline' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Multiline: answer.
	^answer asObject
!

multiline: pMultiline
	"Set the 'Multiline' property of the receiver to the <varbool> value of the argument."

	self put_Multiline: pMultiline
!

put_Multiline: pMultiline
	"Private - Set the value of the 'Multiline' property of the object wrapped by the 
	 receiver to the <varbool> argument, pMultiline.

		HRESULT __stdcall Multiline(
			[in]VARIANT_BOOL pMultiline);"

	<virtual stdcall: hresult 15 varbool>
	^self invalidCall!

replace: sourceString replaceString: replaceString 
	"Answer the <String> result of performing a regular expression based search/replace, where
	the regular expression itself defines the text to search for, sourceString is the source text against
	which the search/replace is performed, and replaceString is the replacement pattern."

	^self replace: sourceString replaceVar: replaceString!

replace: sourceString replaceVar: replaceVar
	"Answer the <BSTR> result of invoking the Replace() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		Replace: sourceString
		replaceVar: replaceVar asVariant
		pDestString: answer.
	^answer asObject
!

Replace: sourceString replaceVar: replaceVar pDestString: pDestString
	"Private - Invoke the Replace() method of the COM object.

		HRESULT __stdcall Replace(
			[in]BSTR sourceString,
			[in]VARIANT replaceVar,
			[out, retval]BSTR* pDestString);"

	<virtual stdcall: hresult 18 bstr variant bstr*>
	^self invalidCall!

Test: sourceString pMatch: pMatch
	"Private - Invoke the Test() method of the COM object.

		HRESULT __stdcall Test(
			[in]BSTR sourceString,
			[out, retval]VARIANT_BOOL* pMatch);"

	<virtual stdcall: hresult 17 bstr varbool*>
	^self invalidCall! !
!IRegExp2 categoriesFor: #Execute:ppMatches:!**auto generated**!COM Interfaces-IRegExp2!private! !
!IRegExp2 categoriesFor: #get_Multiline:!**auto generated**!COM Interfaces-IRegExp2!private! !
!IRegExp2 categoriesFor: #matchCollectionClass!constants!private! !
!IRegExp2 categoriesFor: #multiline!**auto generated**!properties!public! !
!IRegExp2 categoriesFor: #multiline:!**auto generated**!properties!public! !
!IRegExp2 categoriesFor: #put_Multiline:!**auto generated**!COM Interfaces-IRegExp2!private! !
!IRegExp2 categoriesFor: #replace:replaceString:!methods!operations!public! !
!IRegExp2 categoriesFor: #replace:replaceVar:!**auto generated**!methods!public! !
!IRegExp2 categoriesFor: #Replace:replaceVar:pDestString:!**auto generated**!COM Interfaces-IRegExp2!private! !
!IRegExp2 categoriesFor: #Test:pMatch:!**auto generated**!COM Interfaces-IRegExp2!private! !

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
!IRegExp2 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

