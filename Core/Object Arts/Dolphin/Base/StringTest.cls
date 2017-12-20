"Filed out from Dolphin Smalltalk 7"!

ArrayedCollectionTest subclass: #StringTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StringTest guid: (GUID fromString: '{c1474b06-e77d-41d7-ad4d-10d5114f8471}')!
StringTest comment: 'This is the unit test for the class String. Unit tests are a good way to exercise the functionality of your system in a repeatable and automatic manner. They are therefore recommended if you plan to release anything. For more information, see: 
	- http://www.c2.com/cgi/wiki?UnitTest
	- http://minnow.cc.gatech.edu/squeak/1547
	- the sunit class category'!
!StringTest categoriesForClass!Unclassified! !
!StringTest methodsFor!

assimilate: each 
	^Character codePoint: each asInteger!

collectionClass
	^String!

newNumericArray: anInteger 
	^self newCollection: ((1 to: anInteger) collect: [:each | Character digitValue: each])!

testAsByteArray
	super testAsByteArray.
	"Try round-trip"
	#('' 'A' 'AB' 'ABC' 'ABCD' 'ABCDE' 'ABCDEF') do: 
			[:each | 
			| bytes |
			bytes := self byteArrayForSequence: each.
			(self collectionClass fromAddress: bytes yourAddress length: each size) 
				= (self newCopy: each)]!

testAsPhrase
	self assert: #'' asPhrase = ''.
	self assert: #= asPhrase = '='.
	self assert: ':=' asSymbol asPhrase = '='.
	self assert: ':=:=' asSymbol asPhrase = '= ='.
	self assert: #x asPhrase = 'X'.
	self assert: #nl asPhrase = 'Nl'.
	self assert: #x: asPhrase = 'X'.
	self assert: ':' asSymbol asPhrase = ''.
	self assert: '::' asSymbol asPhrase = ''.
	self assert: ':a' asSymbol asPhrase = 'A'.
	self assert: ':A' asSymbol asPhrase = 'A'.
	self assert: ':a:' asSymbol asPhrase = 'A'.
	self assert: ':A:' asSymbol asPhrase = 'A'.
	self assert: '::a:' asSymbol asPhrase = 'A'.
	self assert: '::A:' asSymbol asPhrase = 'A'.
	self assert: '::a:b::c:D::E:f::G::h:' asSymbol asPhrase = 'A B C D E F G H'.
	self assert: #assert: asPhrase = 'Assert'.
	self assert: #testAsPhrase asPhrase = 'Test As Phrase'.
	self assert: #newCopy: asPhrase = 'New Copy'.
	self 
		assert: #replaceFrom:to:with:startingAt: asPhrase = 'Replace From To With Starting At'.
	self assert: #AXMethodName asPhrase = 'AXMethod Name'.
	self assert: #GetIDsOfNames:rgszNames:cNames:lcid:rgdispid: asPhrase =
			'Get IDs Of Names Rgsz Names C Names Lcid Rgdispid'.!

testAt
	self assert: ('Hello' at: 1) = $H!

testCapitalized
	| string cap |
	string := self newCollection: ''.
	self assert: (string capitalized equals: string).
	string := self newCollection: 'a'.
	cap := string capitalized.
	self assert: (cap equals: (self newCollection: 'A')).
	self assert: string = (self newCollection: 'a').
	string := self newCollection: 'A'.
	cap := string capitalized.
	self assert: (cap equals: (self newCollection: 'A')).
	self assert: string = (self newCollection: 'A').
	string := self newCollection: 'ab'.
	cap := string capitalized.
	self assert: (cap equals: (self newCollection: 'Ab')).
	self assert: string = (self newCollection: 'ab').
	string := self newCollection: 'Ab'.
	cap := string capitalized.
	self assert: (cap equals: (self newCollection: 'Ab')).
	self assert: string = (self newCollection: 'Ab')!

testFindStringStartingAt
	| searchee abc a empty ba ab bb bba abba |
	searchee := self newCollection: 'abcdefgabcdef'.
	abc := self newCollection: 'abc'.
	self assert: (searchee findString: abc startingAt: 1) = 1.
	self assert: (searchee findString: abc startingAt: 2) = 8.
	self assert: (searchee findString: abc startingAt: 9) = 0.
	self assert: (searchee findString: abc startingAt: 11) = 0.
	self assert: (searchee findString: abc startingAt: 1) = 1.
	self assert: (searchee findString: abc startingAt: 9) = 0.
	searchee := self newCollection: 'aabcabc'.
	self assert: (searchee findString: abc startingAt: 6) = 0.
	a := self newCollection: 'a'.
	empty := self newCollection: ''.
	self assert: (empty findString: a startingAt: 1) = 0.
	self assert: ('b' findString: a startingAt: 1) = 0.
	self assert: (a findString: a startingAt: 1) = 1.

	"Search for empty string, should return zero"
	self assert: (a findString: empty startingAt: 1) = 0.
	ba := self newCollection: 'ba'.
	self assert: (ba findString: a startingAt: 1) = 2.
	ab := self newCollection: 'ab'.
	self assert: (ab findString: a startingAt: 1) = 1.
	bb := self newCollection: 'bb'.
	self assert: (bb findString: a startingAt: 1) = 0.
	bba := self newCollection: 'bba'.
	self assert: (bba findString: a startingAt: 1) = 3.
	self assert: (bba findString: a startingAt: 2) = 3.
	self assert: (bba findString: a startingAt: 3) = 3.
	abba := self newCollection: 'abba'.
	self assert: (abba findString: ab startingAt: 3) = 0.
	self assert: (abba findString: ab startingAt: 4) = 0.
	self assert: (abba findString: ab startingAt: 2) = 0.
	self assert: (abba findString: ab startingAt: 1) = 1.
	searchee := self
				newCollection: 'Now''s the time for all good men to come to the aid of their country.'.
	self assert: (searchee findString: (self newCollection: 'time') startingAt: 1) = 11.
	self assert: (searchee findString: (self newCollection: 'timid') startingAt: 1) = 0.
	self assert: (searchee findString: (self newCollection: 'try') startingAt: 1) = 65.
	searchee := self newCollection: 'babcbabcabcaabcabcabcacabc'.
	self assert: (searchee findString: 'abcabcacab' startingAt: 1) = 16.
	searchee := self newCollection: 'aaaaaaabcabcadefg'.
	self assert: (searchee findString: (self newCollection: 'abcad') startingAt: 1) = 10.
	self assert: (searchee findString: ab startingAt: 1) = 7!

testFindStringStartingAtIgnoreCase
	| searchee abc a empty ba ab bb bba abba |
	searchee := self newCollection: 'abCdefgAbcdef'.
	(searchee respondsTo: #findString:startingAt:ignoreCase:) 
		ifFalse: 
			["Introduced in D6"
			^self].
	abc := self newCollection: 'aBc'.
	self assert: (searchee 
				findString: abc
				startingAt: 1
				ignoreCase: true) = 1.
	self assert: (searchee 
				findString: abc
				startingAt: 1
				ignoreCase: false) = 0.
	self assert: (searchee 
				findString: abc
				startingAt: 2
				ignoreCase: true) = 8.
	self assert: (searchee 
				findString: abc
				startingAt: 9
				ignoreCase: true) = 0.
	self assert: (searchee 
				findString: abc
				startingAt: 11
				ignoreCase: true) = 0.
	self assert: (searchee 
				findString: abc
				startingAt: 1
				ignoreCase: true) = 1.
	self assert: (searchee 
				findString: abc
				startingAt: 9
				ignoreCase: true) = 0.
	searchee := self newCollection: 'aAbcaBC'.
	self assert: (searchee 
				findString: abc
				startingAt: 6
				ignoreCase: true) = 0.
	a := self newCollection: 'a'.
	empty := self newCollection: ''.
	self assert: (empty 
				findString: a
				startingAt: 1
				ignoreCase: true) = 0.
	self assert: ('b' 
				findString: a
				startingAt: 1
				ignoreCase: true) = 0.
	self assert: (a 
				findString: a asUppercase
				startingAt: 1
				ignoreCase: true) = 1.

	"Search for empty string, should return zero"
	self assert: (a findString: empty startingAt: 1) = 0.
	ba := self newCollection: 'BA'.
	self assert: (ba 
				findString: a
				startingAt: 1
				ignoreCase: true) = 2.
	ab := self newCollection: 'AB'.
	self assert: (ab 
				findString: a
				startingAt: 1
				ignoreCase: true) = 1.
	bb := self newCollection: 'BB'.
	self assert: (bb 
				findString: a
				startingAt: 1
				ignoreCase: true) = 0.
	bba := self newCollection: 'BBA'.
	self assert: (bba 
				findString: a
				startingAt: 1
				ignoreCase: true) = 3.
	self assert: (bba 
				findString: a
				startingAt: 2
				ignoreCase: true) = 3.
	self assert: (bba 
				findString: a
				startingAt: 3
				ignoreCase: true) = 3.
	abba := self newCollection: 'ABBA'.
	self assert: (abba 
				findString: ab
				startingAt: 3
				ignoreCase: true) = 0.
	self assert: (abba 
				findString: ab
				startingAt: 4
				ignoreCase: true) = 0.
	self assert: (abba 
				findString: ab
				startingAt: 2
				ignoreCase: true) = 0.
	self assert: (abba 
				findString: ab
				startingAt: 1
				ignoreCase: true) = 1.
	searchee := self 
				newCollection: 'Now''s the time for all good men to come to the aid of their country.'.
	self 
		assert: (searchee 
				findString: (self newCollection: 'TIME')
				startingAt: 1
				ignoreCase: true) = 11.
	self 
		assert: (searchee 
				findString: (self newCollection: 'timiD')
				startingAt: 1
				ignoreCase: true) = 0.
	self 
		assert: (searchee 
				findString: (self newCollection: 'tRy')
				startingAt: 1
				ignoreCase: true) = 65.
	searchee := self newCollection: 'babcbabcabcaabcabcabcacabc'.
	self 
		assert: (searchee 
				findString: 'abcABCacab'
				startingAt: 1
				ignoreCase: true) = 16.
	searchee := self newCollection: 'AaAaAaAbCaBcAdEfG'.
	self 
		assert: (searchee 
				findString: (self newCollection: 'abcad')
				startingAt: 1
				ignoreCase: true) = 10.
	self assert: (searchee 
				findString: ab
				startingAt: 1
				ignoreCase: true) = 7!

testIndexOfSubCollectionStartingAtGPF
	| strings search current |
	#'1553'.
	search := String new: 26.
	strings := OrderedCollection new.
	1 to: 1000
		do: 
			[:i | 
			current := String new: 970.
			self assert: (current indexOfSubCollection: search startingAt: 965) == 0.
			strings add: current]!

testInvalidComparisons
	| str literals |
	str := 'blah'.
	literals := #(1.0 1 16rFFFFFFFF 1s2 $a #()).
	literals do: [:each | self deny: str = each].
	literals do: [:each | self assert: str ~= each].
	literals do: [:each | self should: [str < each] raise: Error].
	literals do: [:each | self should: [str <= each] raise: Error].
	literals do: [:each | self should: [str > each] raise: Error].
	literals do: [:each | self should: [str >= each] raise: Error].
	literals do: [:each | self should: [each < str] raise: Error].
	literals do: [:each | self should: [each <= str] raise: Error].
	literals do: [:each | self should: [each > str] raise: Error].
	literals do: [:each | self should: [each >= str] raise: Error]!

testMatch
	"Match anything"

	self assert: ('*' match: 'zort').
	self assert: ('*' match: '').
	"Leading wilcard, matches at end"
	self assert: ('*baz' match: 'mobaz').
	"Must match whole sequence"
	self deny: ('*baz' match: 'mobazo').
	"Leading and trailing wildcard"
	self assert: ('*baz*' match: 'mobazo').
	"No match"
	self deny: ('*baz*' match: 'mozo').
	"Trailing wildcard"
	self assert: ('foo*' match: 'foozo').
	self deny: ('foo*' match: 'bozo').
	"* can match any length sequence"
	self assert: ('foo*baz' match: 'foo23baz').
	"* matches empty sequence"
	self assert: ('foo*baz' match: 'foobaz').
	"Has to match whole sequence"
	self deny: ('foo*baz' match: 'foo23bazo').
	"Case insensitive"
	self assert: ('foo' match: 'Foo').
	self deny: ('foo*baz*zort' match: 'foobazort').
	"* should match empty sequence"
	self assert: ('foo*baz*zort' match: 'foobazzort').
	"# matches any single char"
	self assert: ('*foo#zort' match: 'afoo3zortthenfoo3zort').
	self assert: ('*foo*zort' match: 'afoodezortorfoo3zort').
	#('**' 'f**' 'f**o' 'f*' '*f*' 'f#*' 'f##' '*oo' '#oo' '*o*' '#o#' '#o*' '*o#' 'fo*' 'fo#' '*foo*' '###' '*#' 'f*#' 'f*#o')
		do: [:each | self assert: (each match: 'foo')].
	#('bar' 'foo#' '#foo' '*foo#' '#foo*' '*bar*') do: [:each | self deny: (each match: 'foo')]!

testSubStrings
	"Test single character delimiter"

	self assert: ((self newCollection: '') subStrings: $-) = (#() collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: 'a') subStrings: $-) = (#('a') collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: '-a') subStrings: $-) = (#('' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-') subStrings: $-) = (#('a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: '--a') subStrings: $-) = (#('' '' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a--') subStrings: $-) = (#('a' '') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab') subStrings: $-) = (#('ab') collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: '-ab') subStrings: $-) = (#('' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab-') subStrings: $-) = (#('ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab---') subStrings: $-) = (#('ab' '' '') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: '--ab') subStrings: $-) = (#('' '' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-b') subStrings: $-) = (#('a' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a--b') subStrings: $-) = (#('a' '' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab-c-') subStrings: $-) = (#('ab' 'c') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-b--c') subStrings: $-) = (#('a' 'b' '' 'c') collect: [:e | self newCopy: e]).

	"And again but using a string argument of only one character"
	self assert: ((self newCollection: '') subStrings: (self newCollection: '-')) = (#() collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: 'a') subStrings: (self newCollection: '-')) = (#('a') collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: '-a') subStrings: (self newCollection: '-')) = (#('' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-') subStrings: (self newCollection: '-')) = (#('a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: '--a') subStrings: (self newCollection: '-')) = (#('' '' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a--') subStrings: (self newCollection: '-')) = (#('a' '') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab') subStrings: (self newCollection: '-')) = (#('ab') collect: [:e | self newCollection: e]).
	self assert: ((self newCollection: '-ab') subStrings: (self newCollection: '-')) = (#('' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab-') subStrings: (self newCollection: '-')) = (#('ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab---') subStrings: (self newCollection: '-')) = (#('ab' '' '') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: '--ab') subStrings: (self newCollection: '-')) = (#('' '' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-b') subStrings: (self newCollection: '-')) = (#('a' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a--b') subStrings: (self newCollection: '-')) = (#('a' '' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'ab-c-') subStrings: (self newCollection: '-')) = (#('ab' 'c') collect: [:e | self newCopy: e]).
	self assert: ((self newCollection: 'a-b--c') subStrings: (self newCollection: '-')) = (#('a' 'b' '' 'c') collect: [:e | self newCopy: e]).

	"The separator an also be a string, but must not be empty"
	self should: [(self newCollection: 'abc') subStrings: (self newCollection: '')] raise: Error.

	#todo "Test multi-character separators".!

testTrimNulls
	"#1187"
	| string trimmed |
	string := self collectionClass new: 3.
	string at: 1 put: $a.
	trimmed := string trimNulls.
	self assert: trimmed size = 1.
	self assert: (self newCollection: trimmed) = (self newCollection: 'a')!

testUnescapePercents
	self assert: ((self newCollection: '') unescapePercents = (self newCopy: '')).
	self assert: ((self newCollection: '+') unescapePercents = (self newCopy: ' ')).
	self assert: ((self newCollection: 'A') unescapePercents = (self newCopy: 'A')).
	self assert: ((self newCollection: '+A') unescapePercents = (self newCopy: ' A')).
	self assert: ((self newCollection: '++A') unescapePercents = (self newCopy: '  A')).
	self assert: ((self newCollection: 'A+') unescapePercents = (self newCopy: 'A ')).
	self assert: ((self newCollection: 'A++') unescapePercents = (self newCopy: 'A  ')).
	self assert: ((self newCollection: 'AB') unescapePercents = (self newCopy: 'AB')).
	self assert: ((self newCollection: '+A+B+') unescapePercents = (self newCopy: ' A B ')).
	self assert: ((self newCollection: '++A++B++') unescapePercents = (self newCopy: '  A  B  ')).
	self assert: ((self newCollection: '%41') unescapePercents = (self newCopy: 'A')).
	self assert: ((self newCollection: '+%41+') unescapePercents = (self newCopy: ' A ')).
	self assert: ((self newCollection: '%41B') unescapePercents = (self newCopy: 'AB')).
	self assert: ((self newCollection: '%41+B') unescapePercents = (self newCopy: 'A B')).
	self assert: ((self newCollection: '%41++B') unescapePercents = (self newCopy: 'A  B')).
	self assert: ((self newCollection: '%41BC') unescapePercents = (self newCopy: 'ABC')).
	self assert: ((self newCollection: '%41%42') unescapePercents = (self newCopy: 'AB')).
	self assert: ((self newCollection: '%41B%43') unescapePercents = (self newCopy: 'ABC')).
	self assert: ((self newCollection: '%41BC%44') unescapePercents = (self newCopy: 'ABCD')).
	self assert: ((self newCollection: 'A%42%43') unescapePercents = (self newCopy: 'ABC')).
	self assert: ((self newCollection: 'AB%43%44') unescapePercents = (self newCopy: 'ABCD')).
	self assert: ((self newCollection: 'AB%43D%45') unescapePercents = (self newCopy: 'ABCDE')).
	self assert: ((self newCollection: 'AB%43DE%46') unescapePercents = (self newCopy: 'ABCDEF')).
	self assert: ((self newCollection: 'AB%43DE%46G') unescapePercents = (self newCopy: 'ABCDEFG')).
	self assert: ((self newCollection: 'AB%43DE%46GH') unescapePercents = (self newCopy: 'ABCDEFGH')).
	"Invalid (non-ascii) character, therefore assume not an escaped string"
	self assert: ((self newCollection: '%GA') unescapePercents = (self newCollection: '%GA')).
	self assert: ((self newCollection: '%AG') unescapePercents = (self newCollection: '%AG')).
	self assert: ((self newCollection: '%[1') unescapePercents = (self newCollection: '%[1')).
	self assert: ((self newCollection: '%1[') unescapePercents = (self newCollection: '%1[')).
!

testWithNormalizedLineDelimiters
	"Empty"

	| cr lf crlf char |
	char := self newCollection: '+'.
	cr := self newCollection: (self collectionClass with: Character cr).
	crlf := self newCollection: self collectionClass lineDelimiter.
	lf := self newCollection: (self collectionClass with: Character lf).
	self assert: (self newCollection: '') withNormalizedLineDelimiters = (self newCopy: '').
	"Not empty, but no delims"
	self assert: (self newCollection: '') withNormalizedLineDelimiters = (self newCopy: '').
	"Single CR"
	self assert: cr withNormalizedLineDelimiters = (self newCopy: crlf).
	self assert: (char , cr) withNormalizedLineDelimiters = (char , crlf).
	self assert: (char , cr , char) withNormalizedLineDelimiters = (char , crlf , char).
	"Single LF"
	self assert: lf withNormalizedLineDelimiters = (self newCopy: crlf).
	self assert: (char , lf) withNormalizedLineDelimiters = (char , crlf).
	self assert: (char , lf , char) withNormalizedLineDelimiters = (char , crlf , char).
	"Single CR/LF - no change"
	self assert: crlf withNormalizedLineDelimiters = (self newCopy: crlf).
	self assert: (char , crlf) withNormalizedLineDelimiters = (char , crlf).
	self assert: (char , crlf , char) withNormalizedLineDelimiters = (char , crlf , char).
	"LF,CR"
	self assert: (lf , cr) withNormalizedLineDelimiters = (crlf , crlf).
	self assert: (lf , cr , char) withNormalizedLineDelimiters = (crlf , crlf , char).
	self 
		assert: (char , lf , cr , char) withNormalizedLineDelimiters = (char , crlf , crlf , char).
	"LF,LF"
	self assert: (lf , lf) withNormalizedLineDelimiters = (crlf , crlf).
	self assert: (lf , lf , char) withNormalizedLineDelimiters = (crlf , crlf , char).
	self 
		assert: (char , lf , lf , char) withNormalizedLineDelimiters = (char , crlf , crlf , char).
	"CR,CR"
	self assert: (cr , cr) withNormalizedLineDelimiters = (crlf , crlf).
	self assert: (cr , cr , char) withNormalizedLineDelimiters = (crlf , crlf , char).
	self 
		assert: (char , cr , cr , char) withNormalizedLineDelimiters = (char , crlf , crlf , char).
	"CRLFLF"
	self assert: (cr , lf , lf) withNormalizedLineDelimiters = (crlf , crlf).
	"CRLFCR"
	self assert: (cr , lf , cr) withNormalizedLineDelimiters = (crlf , crlf)! !
!StringTest categoriesFor: #assimilate:!helpers!private! !
!StringTest categoriesFor: #collectionClass!helpers!private! !
!StringTest categoriesFor: #newNumericArray:!helpers!private! !
!StringTest categoriesFor: #testAsByteArray!public!unit tests! !
!StringTest categoriesFor: #testAsPhrase!public!unit tests! !
!StringTest categoriesFor: #testAt!public!testing / accessing! !
!StringTest categoriesFor: #testCapitalized!public!unit tests! !
!StringTest categoriesFor: #testFindStringStartingAt!public!unit tests! !
!StringTest categoriesFor: #testFindStringStartingAtIgnoreCase!public!unit tests! !
!StringTest categoriesFor: #testIndexOfSubCollectionStartingAtGPF!public!unit tests! !
!StringTest categoriesFor: #testInvalidComparisons!public!unit tests! !
!StringTest categoriesFor: #testMatch!public!unit tests! !
!StringTest categoriesFor: #testSubStrings!public!unit tests! !
!StringTest categoriesFor: #testTrimNulls!public!unit tests! !
!StringTest categoriesFor: #testUnescapePercents!public!unit tests! !
!StringTest categoriesFor: #testWithNormalizedLineDelimiters!public!unit tests! !

