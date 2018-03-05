"Filed out from Dolphin Smalltalk 7"!

ArrayedCollectionTest subclass: #AbstractStringTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractStringTest guid: (GUID fromString: '{262b323f-d574-423e-8571-63b1fab0d021}')!
AbstractStringTest isAbstract: true!
AbstractStringTest comment: ''!
!AbstractStringTest categoriesForClass!Unclassified! !
!AbstractStringTest methodsFor!

assimilate: each 
	^Character codePoint: each asInteger!

assimilateString: aString
	^self subclassResponsibility!

caseConversionCases
	^#(#('abc £12' 'ABC £12') #('oña' 'OÑA') #('árvízturo tükörfúrógép' 'ÁRVÍZTURO TÜKÖRFÚRÓGÉP'))!

equalityTestCases
	^#('' 'a' 'abc' '' 'tükörfúrógép')!

newNumericArray: anInteger 
	^self newCollection: ((1 to: anInteger) collect: [:each | Character digitValue: each])!

reverseTestCases
	^#(#('abc' 'cba') #('oña' 'año'))!

testAsByteArray
	super testAsByteArray.
	"Try round-trip"
	#('' 'A' 'AB' 'ABC' 'ABCD' 'ABCDE' 'ABCDEF') do: 
			[:each | 
			| bytes |
			bytes := self byteArrayForSequence: each.
			(self collectionClass fromAddress: bytes yourAddress length: each size) 
				= (self newCopy: each)]!

testAt
	self assert: ((self newCollection: 'Hello') at: 1) = $H!

testCapitalized
	| string cap |
	string := self assimilateString: ''.
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

testCaseConversions
	| subject actual expected |
	self caseConversionCases do: 
			[:each |
			subject := self assimilateString: each first.
			actual := subject asUppercase.
			expected := (self assimilateString: each last) basicCopy.
			self assert: actual equals: expected.
			self assert: actual asLowercase equals: subject basicCopy]!

testEmpty
	self assert: self collectionClass empty class sameAs: self collectionClass!

testEquals
	| abc |
	self equalityTestCases do: 
			[:each |
			| subject |
			subject := self assimilateString: each.
			"Identical must be equal"
			self assert: subject equals: subject.
			"Same characters must be equal"
			self assert: subject equals: subject copy.
			each isEmpty ifFalse: [self deny: subject equals: subject asUppercase].
			self assert: subject equals: subject asUtf8String.
			self assert: subject equals: subject asUtf16String.
			"Not equal to ByteArrays"
			self deny: subject asByteArray equals: subject.
			self deny: subject equals: subject asByteArray.
			"Nor Arrays of characters"
			self deny: subject asArray equals: subject.
			self deny: subject equals: subject asArray].
	"Symbols are only ever equal to other symbols, not strings with the same characters"
	abc := self assimilateString: 'abc'.
	self deny: #abc equals: abc.
	self deny: abc equals: #abc.
!

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

testInvalidComparisons
	| str literals |
	str := self newCollection: 'blah'.
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

testReverse
	"Tests reversing a variety of 1, 2, 3 and 4 byte encodings"

	self reverseTestCases do: 
			[:each |
			| subject expected actual |
			subject := self assimilateString: each first.
			expected := self assimilateString: each last.
			actual := subject reverse.
			self assert: actual equals: expected basicCopy]!

testStreamUtfRoundTrip
	| expected actual |
	self skipUnless: [self collectionClass ~~ Symbol].
	"Test a variety of 1 to 4 byte encodings"
	{''.
		'a'.
		'abc'.
		'£'.
		'être'.
		Utf8String fromByteArray: #[228 185 157 233 190 141 231 129 163].
		Utf8String
			fromByteArray: #[230 150 135 229 173 151 229 140 150 227 129 145 227 131 134 227 130 185 227 131 136].
		Utf8String
			fromByteArray: #[216 167 217 132 216 165 216 185 217 132 216 167 217 134 32 216 167 217 132 216 185 216 167 217 132 217 133 217 137 32 217 132 216 173 217 130 217 136 217 130 32 216 167 217 132 216 165 217 134 216 179 216 167 217 134].
		Utf8String fromByteArray: #[240 144 140 176 240 144 140 177 240 144 140 178]} do: 
				[:each |
				expected := self assimilateString: each.
				actual := expected species writeStream
							nextPutAll: expected;
							contents.
				self assert: (self assimilateString: actual) equals: expected]!

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
!AbstractStringTest categoriesFor: #assimilate:!helpers!private! !
!AbstractStringTest categoriesFor: #assimilateString:!helpers!private! !
!AbstractStringTest categoriesFor: #caseConversionCases!constants!private! !
!AbstractStringTest categoriesFor: #equalityTestCases!constants!private! !
!AbstractStringTest categoriesFor: #newNumericArray:!helpers!private! !
!AbstractStringTest categoriesFor: #reverseTestCases!constants!private! !
!AbstractStringTest categoriesFor: #testAsByteArray!public!unit tests! !
!AbstractStringTest categoriesFor: #testAt!public!testing / accessing! !
!AbstractStringTest categoriesFor: #testCapitalized!public!unit tests! !
!AbstractStringTest categoriesFor: #testCaseConversions!public! !
!AbstractStringTest categoriesFor: #testEmpty!public!testing / accessing! !
!AbstractStringTest categoriesFor: #testEquals!public!unit tests! !
!AbstractStringTest categoriesFor: #testFindStringStartingAt!public!unit tests! !
!AbstractStringTest categoriesFor: #testFindStringStartingAtIgnoreCase!public!unit tests! !
!AbstractStringTest categoriesFor: #testInvalidComparisons!public!unit tests! !
!AbstractStringTest categoriesFor: #testReverse!public! !
!AbstractStringTest categoriesFor: #testStreamUtfRoundTrip!public! !
!AbstractStringTest categoriesFor: #testSubStrings!public!unit tests! !
!AbstractStringTest categoriesFor: #testTrimNulls!public!unit tests! !
!AbstractStringTest categoriesFor: #testUnescapePercents!public!unit tests! !
!AbstractStringTest categoriesFor: #testWithNormalizedLineDelimiters!public!unit tests! !

