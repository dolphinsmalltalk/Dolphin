"Filed out from Dolphin Smalltalk 7"!

IRegExpAbstract subclass: #IRegExp
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IRegExp guid: (IID fromString: '{3f4daca0-160d-11d2-a8e9-00104b365c9f}')!
IRegExp comment: '`IRegExp` is a wrapper class for the COM interface ''VBScript_RegExp_55.IRegExp'' generated from type information in the ''Microsoft VBScript Regular Expressions 5.5'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3f4daca0-160d-11d2-a8e9-00104b365c9f), 
	hidden, 
	nonextensible, 
	dual
]
interface IRegExp : IDispatch
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
		[in]BSTR replaceString,
		[out, retval]BSTR* pDestString);
};
```
'!
!IRegExp categoriesForClass!COM-Interfaces!VBScript_RegExp_55-Interfaces! !
!IRegExp methodsFor!

Execute: sourceString ppMatches: ppMatches
	"Private - Invoke the Execute() method of the COM object.

		HRESULT __stdcall Execute(
			[in]BSTR sourceString,
			[out, retval]IDispatch** ppMatches);"

	<virtual stdcall: hresult 14 bstr IDispatch**>
	^self invalidCall: _failureCode!

matchCollectionClass
	^IMatchCollection!

replace: sourceString replaceString: replaceString
	"Answer the <String> result of performing a regular expression based search/replace, where
	the regular expression itself defines the text to search for, sourceString is the source text against
	which the search/replace is performed, and replaceString is the replacement pattern."

	| bstr answer |
	bstr := BSTR new.
	self
		Replace: sourceString
		replaceString: replaceString
		pDestString: bstr.
	answer := bstr asUtf16String.
	bstr free.
	^answer!

Replace: sourceString replaceString: replaceString pDestString: pDestString
	"Private - Invoke the Replace() method of the COM object.

		HRESULT __stdcall Replace(
			[in]BSTR sourceString,
			[in]BSTR replaceString,
			[out, retval]BSTR* pDestString);"

	<virtual stdcall: hresult 16 bstr bstr bstr*>
	^self invalidCall: _failureCode!

Test: sourceString pMatch: pMatch
	"Private - Invoke the Test() method of the COM object.

		HRESULT __stdcall Test(
			[in]BSTR sourceString,
			[out, retval]VARIANT_BOOL* pMatch);"

	<virtual stdcall: hresult 15 bstr varbool*>
	^self invalidCall: _failureCode! !
!IRegExp categoriesFor: #Execute:ppMatches:!**auto generated**!COM Interfaces-IRegExp!private! !
!IRegExp categoriesFor: #matchCollectionClass!constants!private! !
!IRegExp categoriesFor: #replace:replaceString:!operations!public! !
!IRegExp categoriesFor: #Replace:replaceString:pDestString:!**auto generated**!COM Interfaces-IRegExp!private! !
!IRegExp categoriesFor: #Test:pMatch:!**auto generated**!COM Interfaces-IRegExp!private! !

!IRegExp class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'VBScript_RegExp_55.IRegExp'
		IRegExp defineTemplate"

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
		defineFunction: #Execute:ppMatches:
			argumentTypes: 'bstr IDispatch**';
		defineFunction: #Test:pMatch:
			argumentTypes: 'bstr varbool*';
		defineFunction: #Replace:replaceString:pDestString:
			argumentTypes: 'bstr bstr bstr*'
! !
!IRegExp class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

