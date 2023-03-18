"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'VBScript.IRegExpAbstract'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
VBScript.IRegExpAbstract guid: (OS.COM.IID fromString: '{427e61d6-dda9-489b-9102-c745ec40641b}')!
VBScript.IRegExpAbstract isNonInstantiable: true!
VBScript.IRegExpAbstract comment: '`IRegExpAbstract` is an abstract class implementing methods common between the Microsoft Scripting IRegExp COM interfaces.'!
!VBScript.IRegExpAbstract categoriesForClass!COM-Interfaces! !
!VBScript.IRegExpAbstract methodsFor!

execute: aString
	"Answer an <sequencedReadableCollection> containing all sub-strings of the <String> argument which match this regular expression."

	| matches answer |
	matches := self matchCollectionClass newPointer.
	self Execute: aString ppMatches: matches.
	answer := matches asArray.
	matches free.
	^answer!

Execute: sourceString ppMatches: ppMatches
	^self subclassResponsibility!

get_Global: pGlobal
	"Private - Get the value of the 'Global' property of the receiver.

		HRESULT __stdcall Global(
			[out, retval]VARIANT_BOOL* pGlobal);"

	<virtual stdcall: hresult 12 varbool*>
	^self invalidCall: _failureCode!

get_IgnoreCase: pIgnoreCase
	"Private - Get the value of the 'IgnoreCase' property of the receiver.

		HRESULT __stdcall IgnoreCase(
			[out, retval]VARIANT_BOOL* pIgnoreCase);"

	<virtual stdcall: hresult 10 varbool*>
	^self invalidCall: _failureCode!

get_Pattern: pPattern
	"Private - Get the value of the 'Pattern' property of the receiver.

		HRESULT __stdcall Pattern(
			[out, retval]BSTR* pPattern);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall: _failureCode!

global
	"Answer whether the regular expression should be tested against all possible matches in a
	string, false by default."

	| answer |
	answer := VARIANT_BOOL new.
	self get_Global: answer.
	^answer value!

global: aBoolean 
	"Set whether the regular expression should be tested against all possible matches in a
	string, false by default."

	self put_Global: aBoolean!

ignoreCase
	"Answer whether the regular expression search should be case insensitive, false by default."

	| answer |
	answer := VARIANT_BOOL new.
	self get_IgnoreCase: answer.
	^answer value!

ignoreCase: aBoolean 
	"Set whether the regular expression search should be case insensitive, false by default."

	self put_IgnoreCase: aBoolean!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

matchCollectionClass
	^self subclassResponsibility!

matchSingle: aString
	"Answer the single matching <String> in the argument matching this regular expression. If there is not exactly one match, throw an InvalidFormat exception."

	| matches match count |
	matches := self matchCollectionClass newPointer.
	self Execute: aString ppMatches: matches.
	count := matches count.
	count == 1 ifFalse: [InvalidFormat signal: aString with: self].
	match := matches item: 0.
	matches free.
	^match!

pattern
	"Answer the regular expression search <String>. See
	http://msdn.microsoft.com/library/en-us/dnclinic/html/scripting051099.asp for help and
	examples."

	| bstr answer |
	bstr := BSTR new.
	self get_Pattern: bstr.
	answer := bstr asUtf16String.
	bstr free.
	^answer!

pattern: aString 
	"Set the regular expression search <String>. See [Regular Expression Syntax (Scripting)](https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/scripting-articles/1400241x%28v%3dvs.84%29)"

	self put_Pattern: aString!

printValueOn: aStream
	aStream print: (self isNull ifFalse: [self pattern])!

put_Global: pGlobal
	"Private - Set the value of the 'Global' property of the object wrapped by the 
	 receiver to the <varbool> argument, pGlobal.

		HRESULT __stdcall Global(
			[in]VARIANT_BOOL pGlobal);"

	<virtual stdcall: hresult 13 varbool>
	^self invalidCall: _failureCode!

put_IgnoreCase: pIgnoreCase
	"Private - Set the value of the 'IgnoreCase' property of the object wrapped by the 
	 receiver to the <varbool> argument, pIgnoreCase.

		HRESULT __stdcall IgnoreCase(
			[in]VARIANT_BOOL pIgnoreCase);"

	<virtual stdcall: hresult 11 varbool>
	^self invalidCall: _failureCode!

put_Pattern: pPattern
	"Private - Set the value of the 'Pattern' property of the object wrapped by the 
	 receiver to the <bstr> argument, pPattern.

		HRESULT __stdcall Pattern(
			[in]BSTR pPattern);"

	<virtual stdcall: hresult 9 bstr>
	^self invalidCall: _failureCode!

replace: sourceString replaceString: replaceString
	"Answer the <String> result of performing a regular expression based search/replace, where
	the regular expression itself defines the text to search for, sourceString is the source text against
	which the search/replace is performed, and replaceString is the replacement pattern."

	^self subclassResponsibility!

test: aString
	"Answer whether the <String> argument matches the current regular expression."

	| buf |
	buf := ByteArray newFixed: 2.
	self Test: aString pMatch: buf.
	^(buf int16AtOffset: 0) ~~ 0!

Test: sourceString pMatch: pMatch
	^self subclassResponsibility! !
!VBScript.IRegExpAbstract categoriesForMethods!
execute:!operations!public! !
Execute:ppMatches:!private! !
get_Global:!private! !
get_IgnoreCase:!private! !
get_Pattern:!private! !
global!properties!public! !
global:!properties!public! !
ignoreCase!properties!public! !
ignoreCase:!properties!public! !
isExtensible!public!testing! !
isVBCollection!public!testing! !
matchCollectionClass!constants!private! !
matchSingle:!operations!public! !
pattern!properties!public! !
pattern:!properties!public! !
printValueOn:!printing!private! !
put_Global:!private! !
put_IgnoreCase:!private! !
put_Pattern:!private! !
replace:replaceString:!operations!public! !
test:!operations!public! !
Test:pMatch:!private! !
!

!VBScript.IRegExpAbstract class methodsFor!

clsid
	"Private - Answer the CLSID of the associated coclass, RegExp. When VBScript RegExp 5.5 is
	installed, the coclass supports IRegExp2, but on older installations (such as a standard
	Win98 2e) only IRegExp is supported."

	^##(CLSID fromString: '{3f4daca4-160d-11d2-a8e9-00104b365c9f}')
!

pattern: aString
	^self new pattern: aString! !
!VBScript.IRegExpAbstract class categoriesForMethods!
clsid!constants!private! !
pattern:!instance creation!public! !
!

