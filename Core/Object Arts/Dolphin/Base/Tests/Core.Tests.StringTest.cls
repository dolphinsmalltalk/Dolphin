"Filed out from Dolphin Smalltalk"!

Core.Tests.ArrayedCollectionTest
	subclass: #'Core.Tests.StringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.StringTest guid: (Core.GUID fromString: '{262b323f-d574-423e-8571-63b1fab0d021}')!

Core.Tests.StringTest isNonInstantiable: true!

Core.Tests.StringTest comment: ''!

!Core.Tests.StringTest methodsFor!

afterTestCases
	^#(#('ab' $a $b) #('ca£d' $a $£) #('ca£d' $£ $d))!

assimilate: anObject
	^Character codePoint: anObject asInteger!

assimilateString: aString
	^self subclassResponsibility!

beforeTestCases
	^#(#('ab' $b $a) #('ca£d' $£ $a) #('ca£d' $d $£))!

caseConversionCases
	^self ordinalCaseConversionCases!

caseInsensitiveEqualCases
	^#(#('' '') #('i' 'i') #('I' 'i') #('£' '£') #('a£' 'A£') #('straße' 'STRASSE'))!

caseInsensitiveLessThanCases
	^#(#('' 'i') #('i' 'j') #('i' 'J') #('i' 'ij') #('ij' 'j') #('I' 'j') #('i$' 'i£') #('I$' 'i£') #('i$' 'I£') #('I$' 'I£') #('£' '€'))!

conversionTestCases
	^#(#('' #()) #('a' #($a)) #('ab' #($a $b)) #('oña' #($o $ñ $a)) #('£€' #($£ $€)))
		collect: [:each | { self assimilateString: each first. each second }]!

copyClass
	^self collectionClass!

equalityTestCases
	^#(#('' '') #('a' 'A') #('abc' 'ABC') #('tükörfúrógép' 'TÜKÖRFÚRÓGÉP') #('a £=1.2€' 'A £=1.2€'))!

findActualIndicesOf: aCharacter in: aString
	| i found stream |
	found := OrderedCollection new.
	stream := aString readStream.
	i := 0.
	stream do: 
			[:ch |
			ch = aCharacter ifTrue: [found add: i + 1].
			i := stream position].
	^found asArray!

indexOfTestCases
	^#('' $a 'a' $a 'aa' $a 'b' $a '£' $£ '££' $£ 'a££b£' $£)!

lengthTestCases
	^#(#('' 0) #('a' 1) #('ab' 2) #('oña' 3) #('£€' 2))!

matchingPairs
	^#(#('*' 'zort') #('*baz' 'mobaz') #('foo*' 'foozo') #('foo*baz' 'foo23baz') #('foo*baz' 'foobaz') #('foo' 'Foo') #('foo*baz*zort' 'foobazzort') #('*foo#zort' 'afoo3zortthenfoo3zort') #('*foo*zort' 'afoodezortorfoo3zort'))!

mismatchedPairs
	^#(#('*baz' 'mobazo') #('*baz*' 'mozo') #('foo*' 'bozo') #('foo*baz' 'foo23bazo') #('foo*baz*zort' 'foobazort') #('#' ''))!

newNumericArray: anInteger
	^self newCollection: ((1 to: anInteger) collect: [:each | Character digitValue: each])!

ordinalCaseConversionCases
	^#(#('' '') #('abc £12' 'ABC £12') #('oña' 'OÑA') #('árvízturo tükörfúrógép' 'ÁRVÍZTURO TÜKÖRFÚRÓGÉP'))
		, { { AnsiString fromByteArray: #[97 0 98]. AnsiString fromByteArray: #[65 0 66] } }!

reverseTestCases
	^{#('' '').
		#('a' 'a').
		#('ab' 'ba').
		#('abc' 'cba').
		#('oña' 'año').
		{String
				with: $a
				with: $b
				with: $\0
				with: $c.
			String
				with: $c
				with: $\0
				with: $b
				with: $a}}!

testAfter
	self afterTestCases do: 
			[:each |
			| subject char expected actual |
			subject := self assimilateString: each first.
			char := each second.
			expected := each third.
			actual := subject after: char.
			self assert: actual equals: expected].
	self
		should: [(self assimilateString: 'ab') after: $b]
		raise: Error
		matching: [:ex | ex description = '$b is my last object'].
	self should: [self collectionClass empty after: $a] raise: NotFoundError.
	self should: [(self assimilateString: 'a') after: $b] raise: NotFoundError!

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
	self assert: ((self assimilateString: 'Hello') at: 1) equals: $H!

testBefore
	self beforeTestCases do: 
			[:each |
			| subject char expected actual |
			subject := self assimilateString: each first.
			char := each second.
			expected := each third.
			actual := subject before: char.
			self assert: actual equals: expected].
	self
		should: [(self assimilateString: 'ab') before: $a]
		raise: Error
		matching: [:ex | ex description = '$a is my first object'].
	self should: [self collectionClass empty before: $a] raise: NotFoundError.
	self should: [(self assimilateString: 'a') before: $b] raise: NotFoundError!

testBeginsWithEmbeddedNulls
	| empty null poundB |
	empty := self collectionClass empty.
	null := self newCollection: #($\0).
	self assert: (null beginsWith: null).
	self deny: (empty beginsWith: null).
	poundB := self newCollection: #($£ $\0 $b).
	{poundB asAnsiString. poundB asUtf8String. poundB asUtf16String} do: 
			[:each |
			| double |
			self assert: (poundB beginsWith: each).
			double := self assimilateString: poundB , poundB.
			self assert: (double occurrencesOf: $\0) equals: 2.
			self assert: (double beginsWith: each).
			self deny: ((self newCollection: #($a)) , poundB beginsWith: each)]!

testBeginsWithIgnoreCase
	| subject comparand |
	subject := self newCollection: {$a. $\0. $£. $b. $c}.
	self assert: (subject beginsWith: '' ignoreCase: true).
	self assert: (subject beginsWith: '' ignoreCase: false).
	self assert: (subject beginsWith: subject ignoreCase: true).
	self assert: (subject beginsWith: subject ignoreCase: false).
	comparand := self newCollection: {$A. $\0. $£}.
	self assert: (subject beginsWith: comparand ignoreCase: true).
	self deny: (subject beginsWith: comparand ignoreCase: false).
	comparand := self newCollection: {$A. $\0. $b. $£}.
	self deny: (subject beginsWith: comparand ignoreCase: false).
	self deny: (subject beginsWith: comparand ignoreCase: true)!

testBeginsWithMixedEncodings
	| empty a ab b abc ad |
	empty := self collectionClass empty.
	a := self newCollection: #($a).
	ab := self newCollection: #($a $£).
	b := self newCollection: #($b).
	abc := self newCollection: #($a $£ $c).
	ad := self newCollection: #($a $d).
	{'a' asAnsiString. $a asUtf8String. $a asUtf16String} do: 
			[:each |
			self deny: (empty beginsWith: each).
			self assert: (a beginsWith: a).
			self assert: (ab beginsWith: a).
			self deny: (b beginsWith: a)].
	{'a£' asAnsiString. 'a£' asUtf8String. 'a£' asUtf16String} do: 
			[:each |
			self deny: (empty beginsWith: each).
			self deny: (a beginsWith: each).
			self assert: (ab beginsWith: each).
			self assert: (abc beginsWith: each).
			self deny: (b beginsWith: each).
			self deny: (ad beginsWith: each)]!

testBinarySelectorExpandMacrosWith

	self assert: (self assimilateString: 'test <1d> displayString') << 1.23s2 equals: 'test 1.23 displayString'.
	self assert: (self assimilateString: 'test <1p> printString') << 1.23s2 equals: 'test 1.23s printString'.
	self assert: (self assimilateString: 'test <1s> asString') << $Z equals: 'test Z asString'.
	self assert: (self assimilateString: 'test <1?yes:no> conditional True') << true equals: 'test yes conditional True'.
	self assert: (self assimilateString: 'test <1?yes:no> conditional False') << false equals: 'test no conditional False'!

testBinarySelectorExpandMacrosWithArguments

	| pattern expectedResult dp |

	pattern := 'test displayString <1d> printString <2p> asString <3s> newline<N>tab<T>conditionals <4?yes:no> <5?yes:no> end test'.
	pattern := self assimilateString: pattern.
	dp := Locale userDefault decimalSeparator.
	expectedResult := 'test displayString 1', dp, '23 printString 4.56s asString Z newline', String lineDelimiter, 'tab	conditionals yes no end test'.
	expectedResult := self assimilateString: expectedResult.

	self assert: pattern << #(1.23 4.56s2 $Z true false) equals: expectedResult!

testBinarySelectorExpandMacrosWithCollection
	"Test special handling of collections when using << expandMacrosWith... binary selector"

	"A collection should be treated as a collection of arguments"

	self assert: (self assimilateString: 'test <1d> <2d> <3d> displayString') << (1 to: 10)
		equals: 'test 1 2 3 displayString'.
	self assert: (self assimilateString: 'test <1p> <2p> <3p> printString') << #(4 5 6)
		equals: 'test 4 5 6 printString'.
	self assert: (self assimilateString: 'test <1s><2s><3s> asString') << #($a $b $c)
		equals: 'test abc asString'.

	"Wrap in an Array to treat the collection as an individual argument"
	self assert: (self assimilateString: 'test <1d> displayString') << {1 to: 10}
		equals: 'test 1 .. 10 displayString'.
	self assert: (self assimilateString: 'test <1p> printString') << {#(4 5 6)}
		equals: 'test #(4 5 6) printString'.
	self assert: (self assimilateString: 'test <1s> asString') << {#($a $b $c)}
		equals: 'test abc asString'.

	"...but a String should always be treated as an individual argument"
	self assert: (self assimilateString: 'test <1d> displayString') << 'hello world'
		equals: 'test hello world displayString'.
	self assert: (self assimilateString: 'test <1p> printString') << 'hello world'
		equals: 'test ''hello world'' printString'.
	self assert: (self assimilateString: 'test <1s> asString') << 'hello world'
		equals: 'test hello world asString'.
	self assert: (self assimilateString: 'test <1d> displayString') << {'hello world'}
		equals: 'test hello world displayString'.
	self assert: (self assimilateString: 'test <1p> printString') << {'hello world'}
		equals: 'test ''hello world'' printString'.
	self assert: (self assimilateString: 'test <1s> asString') << {'hello world'}
		equals: 'test hello world asString'.

	"Similarly any non-sequenceable collection"
	self assert: (self assimilateString: 'test <1d> displayString') << (Set with: Object new)
		equals: 'test a Set(an Object) displayString'.
	self assert: (self assimilateString: 'test <1p> printString') << (Set with: Object new)
		equals: 'test a Set(an Object) printString'.
	self should: [self assert: (self assimilateString: 'test <1s> asString') << (Set with: 1)]
		raise: Error!

testCapitalized
	| string cap |
	string := self collectionClass empty.
	self assert: string capitalized equals: string.
	string := self assimilateString: 'a'.
	cap := string capitalized.
	self assert: cap equals: (self assimilateString: 'A').
	self assert: string equals: (self assimilateString: 'a').
	string := self assimilateString: 'A'.
	cap := string capitalized.
	self assert: cap equals: (self assimilateString: 'A').
	self assert: string equals: (self assimilateString: 'A').
	string := self assimilateString: 'ab'.
	cap := string capitalized.
	self assert: cap equals: (self assimilateString: 'Ab').
	self assert: string equals: (self assimilateString: 'ab').
	string := self assimilateString: 'Ab'.
	cap := string capitalized.
	self assert: cap equals: (self assimilateString: 'Ab').
	self assert: string equals: (self assimilateString: 'Ab')!

testCaseConversions
	| de |
	de := Locale named: 'de-DE'.
	self caseConversionCases do: 
			[:each |
			| subject actual expected |
			subject := self assimilateString: each first.
			expected := self assimilateString: each last.
			"Sanity check that the test cases are equal ignoring case"
			self assert: subject <=> expected equals: 0.
			subject asArray size = expected asArray size
				ifTrue: [self assert: (subject compareOrdinals: expected ignoringCase: true) equals: 0].
			self assert: (subject caseFolded: de) equals: (expected caseFolded: de).
			actual := subject asUppercase: de.
			self assert: actual equals: expected mutableCopy.
			"Not necessarily reversible, e.g. 'straße' -> 'STRASSE' -> 'strasse'"
			actual := expected asLowercase: de.
			self assert: actual <=> expected equals: 0.
			self assert: actual <=> subject equals: 0.
			subject asArray size = expected asArray size
				ifTrue: [self assert: actual equals: subject mutableCopy]]!

testClassFromAddress
	self equalityTestCases do: 
			[:each |
			| actual expected |
			expected := self assimilateString: each first.
			actual := self collectionClass fromAddress: expected yourAddress.
			self assert: actual equals: expected]!

testClassReadFrom
	"Tests String class>>readFrom:. Some interested cases are:
	- Content before the first quote (skipped - not sure that is right, but has always done that)
	- Unterminated (reads up to end)
	- Embedded (doubled) quotes - quotes are undoubled
	- Trailing content - should be left with the stream positioned after the final quote."

	{#('' '' '').
		#('abc' '' '').
		#('abc''A''B' 'A' 'B').
		#('a''AB''CD' 'AB' 'CD').
		#('''a''' 'a' '').
		#('''a' 'a' '').
		#('''abc''' 'abc' '').
		#('''abc' 'abc' '').
		#('''abc''''d'' ''e''' 'abc''d' ' ''e''')} do: 
				[:each |
				| actual expected stream remainder |
				expected := self assimilateString: each second.
				stream := each first readStream.
				actual := self collectionClass readFrom: stream.
				self assert: actual class identicalTo: self collectionClass.
				self assert: actual equals: expected.
				remainder := stream upToEnd.
				self assert: remainder equals: each last]!

testCopyToComTaskMemory
	| subject |
	self lengthTestCases do: 
			[:each |
			| subject heapBlock copy |
			subject := self assimilateString: each first.
			heapBlock := subject copyToCOMTaskMemory.
			copy := self collectionClass fromAddress: heapBlock.
			self assert: copy equals: subject]!

testCopyWith
	| subject copy |
	subject := self collectionClass empty.
	copy := subject copyWith: $£.
	self assert: copy class identicalTo: copy copyingClass.
	self assert: copy equals: '£'.
	subject := self assimilateString: 'a'.
	copy := subject copyWith: $©.
	self assert: copy class identicalTo: copy copyingClass.
	self assert: copy equals: 'a©'.
	subject := self assimilateString: 'a©b'.
	copy := subject copyWith: $£.
	self assert: copy class identicalTo: copy copyingClass.
	self assert: copy equals: 'a©b£'!

testCopyWithout
	| string |
	string := self assimilateString: 'abcba'.
	self assert: (string copyWithout: $a) equals: 'bcb'.
	self assert: (string copyWithout: $b) equals: 'aca'.
	self assert: (string copyWithout: $c) equals: 'abba'.
	"#957--non-ascii characters were unable to be recognized in a Utf8String in particular,
	might as well test all types of string"
	string := self assimilateString: 'ab©ba'.
	self assert: (string copyWithout: $©) equals: 'abba'.!

testEmpty
	self assert: self collectionClass empty class identicalTo: self collectionClass!

testEndsWithEmpty
	| empty |
	empty := self collectionClass empty.
	self deny: (empty endsWith: $d).
	self deny: (empty endsWith: $\0).
	self deny: (empty endsWith: $🐬).
	self deny: (empty endsWith: '🐬' asUtf8String).
	self deny: (empty endsWith: '🐬' asUtf16String).
	self deny: (empty endsWith: 'a' asAnsiString).
	self deny: (empty endsWith: #($a)).
	self deny: (empty endsWith: #[0]).
	self assert: (empty endsWith: AnsiString empty).
	self assert: (empty endsWith: Utf8String empty).
	self assert: (empty endsWith: Utf16String empty).
	self assert: (empty endsWith: #()).
	self assert: (empty endsWith: #[])!

testEquals
	| abc |
	self equalityTestCases do: 
			[:each |
			| subject copy utf8 utf16 |
			subject := self assimilateString: each first.
			"Identical must be equal"
			self assert: subject equals: subject.
			"Same characters must be equal"
			copy := subject copy.
			self assert: subject equals: copy.
			subject isEmpty ifFalse: [self deny: subject equals: subject asUppercase].
			utf8 := subject asUtf8String.
			self assert: subject equals: utf8.
			utf16 := subject asUtf16String.
			self assert: subject equals: utf16.
			"Not equal to ByteArrays"
			self deny: subject asByteArray equals: subject.
			self deny: subject equals: subject asByteArray.
			"Nor Arrays of characters"
			self deny: subject asArray equals: subject.
			self deny: subject equals: subject asArray].

	"Symbols are now equal to strings with the same characters"
	abc := self assimilateString: 'abc'.
	self assert: #abc equals: abc.
	self assert: abc equals: #abc!

testExpandMacrosWith

	self assert: ((self assimilateString: '<d> displayString<1d><1d>') expandMacrosWith: 1.23s2) equals: '1.23 displayString1.231.23'.
	self assert: ((self assimilateString: 'test <1p> printString') expandMacrosWith: 1.23s2) equals: 'test 1.23s printString'.
	self assert: ((self assimilateString: 'test <1s> asString') expandMacrosWith: $Z) equals: 'test Z asString'.
	self assert: ((self assimilateString: 'test <1?yes:no> conditional True') expandMacrosWith: true) equals: 'test yes conditional True'.
	self assert: ((self assimilateString: 'test <1?yes:no> conditional False') expandMacrosWith: false) equals: 'test no conditional False'.
	self assert: ((self assimilateString: 'test <p:substitute> for nil') expandMacrosWith: nil) equals: 'test substitute for nil'.
	self assert: ((self assimilateString: 'test <p:substitue> not nil') expandMacrosWith: #foo) equals: 'test #foo not nil'.

!

testExpandMacrosWithArguments

	| pattern expectedResult |

	pattern := 'test displayString <1d> printString <p> asString <3s> newline<N>tab<T>conditionals <4?yes:no> <5?yes:no> nil substitution <6d:foo> <7d:foo> end test'.
	pattern := self assimilateString: pattern.

	expectedResult := 'test displayString 1.23 printString 4.56s asString Z newline', String lineDelimiter, 'tab	conditionals yes no nil substitution foo bar end test'.
	expectedResult := self assimilateString: expectedResult.

	self assert: (pattern expandMacrosWithArguments: #(1.23 4.56s2 $Z true false nil 'bar')) equals: expectedResult!

testFindStringStartingAt
	| searchee abc a empty ba ab bb bba abba |
	searchee := self assimilateString: 'a£cdefga£cdef'.
	abc := self assimilateString: 'a£c'.
	self assert: (searchee findString: abc startingAt: 1) equals: 1.
	self assert: (searchee findString: abc startingAt: 2) equals: (searchee lastIndexOf: $£) - 1.
	self assert: (searchee findString: abc startingAt: searchee size) equals: 0.
	self assert: (searchee findString: abc startingAt: 11) equals: 0.
	self assert: (searchee findString: abc startingAt: 1) equals: 1.
	searchee := self assimilateString: 'aabcabc'.
	self assert: (searchee findString: abc startingAt: 6) equals: 0.
	a := self assimilateString: 'a'.
	empty := self collectionClass empty.
	self assert: (empty findString: a startingAt: 1) equals: 0.
	self assert: ('b' findString: a startingAt: 1) equals: 0.
	self assert: (a findString: a startingAt: 1) equals: 1.

	"Search for empty string, should return zero"
	self assert: (a findString: empty startingAt: 1) equals: 0.
	ba := self assimilateString: 'ba'.
	self assert: (ba findString: a startingAt: 1) equals: 2.
	ab := self assimilateString: 'ab'.
	self assert: (ab findString: a startingAt: 1) equals: 1.
	bb := self assimilateString: 'bb'.
	self assert: (bb findString: a startingAt: 1) equals: 0.
	bba := self assimilateString: 'bba'.
	self assert: (bba findString: a startingAt: 1) equals: 3.
	self assert: (bba findString: a startingAt: 2) equals: 3.
	self assert: (bba findString: a startingAt: 3) equals: 3.
	abba := self assimilateString: 'abba'.
	self assert: (abba findString: ab startingAt: 3) equals: 0.
	self assert: (abba findString: ab startingAt: 4) equals: 0.
	self assert: (abba findString: ab startingAt: 2) equals: 0.
	self assert: (abba findString: ab startingAt: 1) equals: 1.
	searchee := self
				assimilateString: 'Now''s the time for all good men to come to the aid of their country.'.
	self assert: (searchee findString: (self assimilateString: 'time') startingAt: 1) equals: 11.
	self assert: (searchee findString: (self assimilateString: 'timid') startingAt: 1) equals: 0.
	self assert: (searchee findString: (self assimilateString: 'try') startingAt: 1) equals: 65.
	searchee := self assimilateString: 'babcbabcabcaabcabcabcacabc'.
	self assert: (searchee findString: 'abcabcacab' startingAt: 1) equals: 16.
	searchee := self assimilateString: 'aaaaaaabcabcadefg'.
	self assert: (searchee findString: (self assimilateString: 'abcad') startingAt: 1) equals: 10.
	self assert: (searchee findString: ab startingAt: 1) equals: 7!

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
				ignoreCase: true)
		equals: 1.
	self assert: (searchee
				findString: abc
				startingAt: 1
				ignoreCase: false)
		equals: 0.
	self assert: (searchee
				findString: abc
				startingAt: 2
				ignoreCase: true)
		equals: 8.
	self assert: (searchee
				findString: abc
				startingAt: 9
				ignoreCase: true)
		equals: 0.
	self assert: (searchee
				findString: abc
				startingAt: 11
				ignoreCase: true)
		equals: 0.
	self assert: (searchee
				findString: abc
				startingAt: 1
				ignoreCase: true)
		equals: 1.
	self assert: (searchee
				findString: abc
				startingAt: 9
				ignoreCase: true)
		equals: 0.
	searchee := self newCollection: 'aAbcaBC'.
	self assert: (searchee
				findString: abc
				startingAt: 6
				ignoreCase: true)
		equals: 0.
	a := self newCollection: 'a'.
	empty := self newCollection: ''.
	self assert: (empty
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 0.
	self assert: ('b'
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 0.
	self assert: (a
				findString: a asUppercase
				startingAt: 1
				ignoreCase: true)
		equals: 1.

	"Search for empty string, should return zero"
	self assert: (a findString: empty startingAt: 1) equals: 0.
	ba := self newCollection: 'BA'.
	self assert: (ba
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 2.
	ab := self newCollection: 'AB'.
	self assert: (ab
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 1.
	bb := self newCollection: 'BB'.
	self assert: (bb
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 0.
	bba := self newCollection: 'BBA'.
	self assert: (bba
				findString: a
				startingAt: 1
				ignoreCase: true)
		equals: 3.
	self assert: (bba
				findString: a
				startingAt: 2
				ignoreCase: true)
		equals: 3.
	self assert: (bba
				findString: a
				startingAt: 3
				ignoreCase: true)
		equals: 3.
	abba := self newCollection: 'ABBA'.
	self assert: (abba
				findString: ab
				startingAt: 3
				ignoreCase: true)
		equals: 0.
	self assert: (abba
				findString: ab
				startingAt: 4
				ignoreCase: true)
		equals: 0.
	self assert: (abba
				findString: ab
				startingAt: 2
				ignoreCase: true)
		equals: 0.
	self assert: (abba
				findString: ab
				startingAt: 1
				ignoreCase: true)
		equals: 1.
	searchee := self
				newCollection: 'Now''s the time for all good men to come to the aid of their country.'.
	self assert: (searchee
				findString: (self newCollection: 'TIME')
				startingAt: 1
				ignoreCase: true)
		equals: 11.
	self assert: (searchee
				findString: (self newCollection: 'timiD')
				startingAt: 1
				ignoreCase: true)
		equals: 0.
	self assert: (searchee
				findString: (self newCollection: 'tRy')
				startingAt: 1
				ignoreCase: true)
		equals: 65.
	searchee := self newCollection: 'babcbabcabcaabcabcabcacabc'.
	self assert: (searchee
				findString: 'abcABCacab'
				startingAt: 1
				ignoreCase: true)
		equals: 16.
	searchee := self newCollection: 'AaAaAaAbCaBcAdEfG'.
	self assert: (searchee
				findString: (self newCollection: 'abcad')
				startingAt: 1
				ignoreCase: true)
		equals: 10.
	self assert: (searchee
				findString: ab
				startingAt: 1
				ignoreCase: true)
		equals: 7!

testFormatWith
	| actual |
	actual := 'Hello from %1, 🍺 cheers' formatWith: '🐬 Smalltalk'.
	self assert: actual equals: 'Hello from 🐬 Smalltalk, 🍺 cheers'!

testFromAddress
	self assertIsNil: (self collectionClass fromAddress: 0).
	self assertIsNil: (self collectionClass fromAddress: 0 length: 0)!

testFromAtomId
	| atom id |
	atom := self collectionClass fromAtomId: 0.
	self assert: atom isEmpty.
	atom := self collectionClass fromAtomId: 1.
	self assert: atom equals: '#1'.
	atom := self collectionClass fromAtomId: 16rBFFF.
	self assert: atom equals: '#49151'.
	id := OS.Kernel32 addAtom: '🐬 Smalltalk'.
	atom := self collectionClass fromAtomId: id.
	self assert: atom equals: '🐬 Smalltalk'!

testHash
	| abc |
	"Might fail if the hash algorithm is changed."
	self assert: (self assimilateString: '€') hash equals: 697271083.
	self assert: (self assimilateString: (String with: $\x7F)) hash equals: 973884365.
	self equalityTestCases do: 
			[:each |
			| subject |
			subject := self assimilateString: each first.
			"Same characters must be equal"
			self assert: subject hash equals: subject copy hash.
			"If representable as an ANSI string, should still have the same hash value (hash value is always that of the Utf-8 bytes"
			subject asAnsiString asUtf8String = subject
				ifTrue: [self assert: subject hash equals: subject asAnsiString hash].
			self assert: subject hash equals: subject asUtf8String hash.
			self assert: subject hash equals: subject asUtf16String hash].

	"Symbols are now equal to strings with the same characters"
	abc := self assimilateString: 'abc'.
	self assert: #abc hash equals: abc hash!

testIndexOfStartingAt
	self indexOfTestCases pairsDo: 
			[:each :char |
			| subject expectedIndices i actualIndices |
			subject := self assimilateString: each.
			expectedIndices := self findActualIndicesOf: char in: subject.
			actualIndices := OrderedCollection new.
			i := 0.
			
			[i := subject indexOf: char startingAt: i + 1.
			i == 0] whileFalse: [actualIndices add: i].
			actualIndices := actualIndices asArray.
			self assert: actualIndices equals: expectedIndices]!

testInvalidComparisons
	| str literals |
	str := self assimilateString: 'blah'.
	literals := #(1.0 1 16rFFFFFFFF 1s2 $a #()).
	literals do: [:each | self deny: str equals: each].
	literals do: [:each | self deny: str equals: each].
	literals do: [:each | self should: [str < each] raise: Error].
	literals do: [:each | self should: [str <= each] raise: Error].
	literals do: [:each | self should: [str > each] raise: Error].
	literals do: [:each | self should: [str >= each] raise: Error].
	literals do: [:each | self should: [each < str] raise: Error].
	literals do: [:each | self should: [each <= str] raise: Error].
	literals do: [:each | self should: [each > str] raise: Error].
	literals do: [:each | self should: [each >= str] raise: Error]!

testJoin
	self assert: (', ' join: #()) equals: ''.
	self assert: (', ' join: 'b') equals: 'b'.
	self assert: (', ' join: #('b')) equals: 'b'.
	self assert: (', ' join: 'ab') equals: 'a, b'.
	self assert: (', ' join: #('a' 'b')) equals: 'a, b'.
	self assert: (', ' join: {Object. Association}) equals: 'Core.Object, Core.Association'!

testLastCodeUnit
	self should: [(self newCollection: #()) lastCodeUnit] raise: BoundsError.
	self assert: (self newCollection: #(49)) lastCodeUnit equals: (self assimilate: 49).
	self assert: (self newCollection: #(49 127)) lastCodeUnit equals: (self assimilate: 127).
	self assert: (self newCollection: #(49 50 51)) lastCodeUnit equals: (self assimilate: 51)!

testLastIndexOf
	self indexOfTestCases pairsDo: 
			[:each :char |
			| subject expectedIndices expected actual |
			subject := self assimilateString: each.
			expectedIndices := self findActualIndicesOf: char in: subject.
			expected := expectedIndices isEmpty ifTrue: [0] ifFalse: [expectedIndices last].
			actual := subject lastIndexOf: char.
			self assert: actual equals: expected]!

testLength
	self lengthTestCases do: 
			[:each |
			| subject |
			subject := self assimilateString: each first.
			self assert: subject length equals: each last]!

testLessOrEqual
	self caseInsensitiveEqualCases do: 
			[:each |
			| a b subject ansi |
			a := each first.
			b := each second.
			subject := self assimilateString: a.
			ansi := b asAnsiString.
			(ansi includes: $?) ifFalse: [self assert: subject <= ansi].
			self assert: subject <= b asUtf8String.
			self assert: subject <= b asUtf16String.
			subject := self assimilateString: b.
			ansi := a asAnsiString.
			(ansi includes: $?) ifFalse: [self assert: subject <= ansi].
			self assert: subject <= a asUtf8String.
			self assert: subject <= a asUtf16String].
	self caseInsensitiveLessThanCases do: 
			[:each |
			| a b subject ansi |
			a := each first.
			b := each second.
			subject := self assimilateString: a.
			ansi := b asAnsiString.
			(ansi includes: $?) ifFalse: [self assert: subject <= ansi].
			self assert: subject <= b asUtf8String.
			self assert: subject <= b asUtf16String.
			subject := self assimilateString: b.
			ansi := a asAnsiString.
			(ansi includes: $?) ifFalse: [self deny: subject <= ansi].
			self deny: subject <= a asUtf8String.
			self deny: subject <= a asUtf16String]!

testLines
	| subject crlf actual empty |
	crlf := String lineDelimiter.
	subject := self assimilateString: 'A' , crlf , crlf , 'bc' , crlf , ' ' , crlf.
	actual := subject lines.
	empty := self collectionClass empty.
	self assert: actual
		equals: {self assimilateString: 'A'.
				empty.
				self assimilateString: 'bc'.
				self assimilateString: ' '.
				empty}!

testMatch
	#('**' 'f**' 'f**o' 'f*' '*f*' 'f#*' 'f##' '*oo' '#oo' '*o*' '#o#' '#o*' '*o#' 'fo*' 'fo#' '*foo*' '###' '*#' 'f*#' 'f*#o')
		do: [:each | self verifyPattern: each matches: 'foo'].
	#('#' 'bar' 'foo#' '#foo' '*foo#' '#foo*' '*bar*')
		do: [:each | self verifyPattern: each mismatch: 'foo'].
	#(#('*' 'zort') #('*#' 'a') #('*baz' 'mobaz') #('foo*' 'foozo') #('foo*baz' 'foo23baz') #('foo*baz' 'foobaz') #('foo' 'Foo') #('foo**' 'Foo') #('foo*baz*zort' 'foobazzort') #('*foo#zort' 'afoo3zortthenfoo3zort') #('*foo***zort' 'afoodezortorfoo3zort') #('*#c*d' 'abcd'))
		do: [:each | self verifyPattern: each first matches: each second].
	#(#('*baz' 'mobazo') #('*baz*' 'mozo') #('foo*' 'bozo') #('foo*baz' 'foo23bazo') #('foo*baz*zort' 'foobazort') #('#' ''))
		do: [:each | self verifyPattern: each first mismatch: each second]!

testMutableCopy
	self caseConversionCases do: 
			[:each |
			| subject actual |
			subject := self assimilateString: each first.
			actual := subject mutableCopy.
			self deny: actual identicalTo: subject.
			self assert: actual isKindOf: subject copyingClass.
			self assert: (actual compareOrdinals: subject ignoringCase: false) equals: 0]!

testOrdinalCaseInsensitiveComparison
	self ordinalCaseConversionCases do: 
			[:each |
			| subject upper |
			subject := self assimilateString: each first.
			upper := self assimilateString: each last.
			self assert: subject hashOrdinalsIgnoringCase equals: upper hashOrdinalsIgnoringCase.
			"The hash value should be equivalent to the hash of the UTF-8 encoded bytes of the uppercased characters of the string"
			self assert: (subject collect: [:ch | ch caseFolded]) asUtf8String asByteArray hash
				equals: subject hashOrdinalsIgnoringCase.
			self assert: (subject compareOrdinals: upper ignoringCase: true) equals: 0.
			self assert: (upper compareOrdinals: subject ignoringCase: true) equals: 0]!

testOrdinalCaseInsensitiveEquality
	| filenames |
	self equalityTestCases do: 
			[:each |
			| subject upper lower copy utf8 utf16 |
			subject := self assimilateString: each first.
			"Identical must be equal"
			self assert: (subject compareOrdinals: subject ignoringCase: true) equals: 0.
			self assert: subject <=> subject equals: 0.
			"Same characters must be equal"
			copy := subject copy.
			self assert: (subject compareOrdinals: copy ignoringCase: true) equals: 0.
			self assert: subject <=> copy equals: 0.
			upper := self assimilateString: each second.
			self assert: (subject compareOrdinals: upper ignoringCase: true) equals: 0.
			self assert: subject <=> upper equals: 0.
			lower := subject asLowercase.
			self assert: (subject compareOrdinals: lower ignoringCase: true) equals: 0.
			self assert: subject <=> lower equals: 0.
			self assert: upper hashOrdinalsIgnoringCase equals: subject hashOrdinalsIgnoringCase.
			self assert: lower hashOrdinalsIgnoringCase equals: subject hashOrdinalsIgnoringCase.
			self assert: (subject collect: [:ch | ch asLowercase]) hash equals: subject hashOrdinalsIgnoringCase.
			utf8 := subject asUtf8String.
			self assert: (subject compareOrdinals: utf8 ignoringCase: true) equals: 0.
			self assert: subject <=> utf8 equals: 0.
			utf16 := subject asUtf16String.
			self assert: (subject compareOrdinals: utf16 ignoringCase: true) equals: 0.
			self assert: subject <=> utf16 equals: 0].

	"This is an ordinal comparsion, not a linguistic one (cf. #<=>). The case-conversion is independent of locale. This does not mean that case-insensitivity applies to a-z, but it does mean that locale specific case conversions such as eszett and turkish dotless-i's are not considered equivalent."
	#(#('ß' 'ss' 1) #('ss' 'ß' -1) #('àãçæøž' 'ÀÃÇÆØŽ' 0)) do: 
			[:each |
			| string1 string2 cmp |
			string1 := self assimilateString: each first.
			string2 := self assimilateString: each second.
			"Sanity check - the test cases are equal by a linguistic comparison, even if not ordinally"
			self assert: each first <=> each second equals: 0.
			self assert: each second <=> each first equals: 0.
			cmp := each third.
			self assert: (string1 compareOrdinals: string2 ignoringCase: true) equals: cmp.
			self assert: (string2 compareOrdinals: string1 ignoringCase: true) equals: cmp negated].

	"These strings appear to be the same, but would be different files in the filesystem"
	filenames := #('ãåèéîïôõùú.txt' 'ãåèéîïôõùú.txt' 'ãåèéîïôõùú.txt' 'ãåèéîïôõùú.txt' 'ãåèéîïôõùú.txt' 'ãåèéîïôõùú.txt' 'ãåèéîïôõùú.txt' 'ãåèéîïôõùú.txt' 'ãåèéîïôõùú.txt' 'ãåèéîïôõùú.txt' 'ãåèéîïôõùú.txt' 'ãåèéîïôõùú.txt').
	filenames do: 
			[:i |
			filenames do: 
					[:j |
					self assert: i <=> j equals: 0.
					self assert: (i compareOrdinals: j ignoringCase: true) == 0 equals: i == j]]!

testReadFrom
	| stream |
	self assert: (self collectionClass readFrom: (self assimilateString: '') readStream) isEmpty.
	self assert: (self collectionClass readFrom: (self assimilateString: '''a') readStream) equals: 'a'.
	self assert: (self collectionClass readFrom: (self assimilateString: '''a''') readStream)
		equals: 'a'.
	self assert: (self collectionClass readFrom: (self assimilateString: '''''a''') readStream)
		equals: ''.
	stream := (self assimilateString: '''''''a''b') readStream.
	self assert: (self collectionClass readFrom: stream) equals: '''a'.
	self assert: stream next equals: $b.
	stream := (self assimilateString: '''''''a''''b''£') readStream.
	self assert: (self collectionClass readFrom: stream) equals: '''a''b'.
	self assert: stream next equals: $£!

testRefersToLiteral
	"Test that string literals in a method do not count as referring to a Symbol with the same contents, now that they are #= to said Symbol.

	N.B. they *should* still count as referring to other encodings of the same string."

	| str |
	str := 'abc' asUtf8String.
	self assert: (str refersToLiteral: 'abc' asAnsiString).
	self assert: (str refersToLiteral: 'abc' asUtf8String).
	self deny: (str refersToLiteral: #abc).
	self deny: (str refersToLiteral: 'ab')!

testResize
	| subject |
	super testResize.
	subject := self assimilateString: 'a£b'.
	self assert: (subject copy resize: subject size) equals: subject.
	self assert: (subject copy resize: 1) equals: 'a'.
	self assert: (subject copy resize: (self assimilateString: 'a£') size) equals: 'a£'.
	self assert: (subject copy resize: (self assimilateString: 'a£bd') size)
		equals: (subject copyWith: $\0).
	subject beImmutableObject.
	self should: [subject resize: 1] raise: Processor constWriteSignal!

testReverse
	"Tests reversing a variety of 1, 2, 3 and 4 byte encodings, and with embedded nulls"

	super testReverse.
	self reverseTestCases do: 
			[:each |
			| subject expected actual |
			subject := self assimilateString: each first.
			expected := self assimilateString: each last.
			actual := subject reverse.
			self assert: actual equals: expected.
			"Reverse it back"
			actual := actual reverse.
			self assert: actual equals: subject]!

testReversedFromTo
	"Tests reversing a variety of 1, 2, 3 and 4 byte encodings"

	| lenFirst lenLast |
	super testReversedFromTo.
	self reverseTestCases do: 
			[:each |
			| subject expected actual chars |
			subject := self assimilateString: each first.
			expected := self assimilateString: each last.
			actual := subject reversedFrom: 1 to: subject size.
			self assert: actual equals: expected.
			"Reverse it back"
			actual := actual reversedFrom: 1 to: subject size.
			self assert: actual equals: subject.
			chars := subject asArray.
			chars size > 2
				ifTrue: 
					[lenFirst := subject encodedSizeOf: chars first.
					lenLast := subject encodedSizeOf: chars last.
					actual := subject reversedFrom: 1 + lenFirst to: subject size - lenLast.
					expected := self newCollection: (chars copyFrom: 2 to: chars size - 1) reverse.
					self assert: actual equals: expected].
			self assert: (subject reversedFrom: subject size + 1 to: subject size) isEmpty]!

testReverseDo
	self reverseTestCases do: 
			[:each |
			| subject expected actual |
			subject := self assimilateString: each first.
			expected := each last asArray.
			actual := Array writeStream.
			subject reverseDo: [:ch | actual nextPut: ch].
			actual := actual contents.
			self assert: actual equals: expected]!

testSpaceships
	| abc |
	self equalityTestCases do: 
			[:each |
			| subject copy upper utf8 utf16 |
			subject := self assimilateString: each first.
			"Identical must be equal"
			self assert: subject <=> subject equals: 0.
			self assert: subject <==> subject equals: 0.
			"Same characters must be equal"
			copy := subject copy.
			self assert: subject <=> copy equals: 0.
			self assert: (subject compareOrdinals: copy ignoringCase: false) equals: 0.
			self assert: (subject compareOrdinals: copy ignoringCase: true) equals: 0.
			self assert: subject <==> copy equals: 0.
			upper := self assimilateString: each second.
			self assert: subject <=> upper equals: 0.
			self assert: (subject compareOrdinals: upper ignoringCase: true) equals: 0.
			subject isEmpty
				ifFalse: 
					[self deny: subject equals: upper.
					self deny: subject <==> upper equals: 0.
					self deny: (subject compareOrdinals: upper ignoringCase: false) equals: 0].
			utf8 := subject asUtf8String.
			self assert: subject <=> utf8 equals: 0.
			self assert: subject <==> utf8 equals: 0.
			utf16 := subject asUtf16String.
			self assert: subject <=> utf16 equals: 0.
			self assert: subject <==> utf16 equals: 0].
	self caseConversionCases do: 
			[:each |
			| subject upper |
			subject := self assimilateString: each first.
			upper := self assimilateString: each last.
			self assert: subject <=> upper equals: 0.
			self assert: upper <=> subject equals: 0].
	"Symbols compare equal to strings with the same characters"
	abc := self assimilateString: 'abc'.
	self assert: #abc <=> abc equals: 0.
	self assert: abc <==> #abc equals: 0!

testSpecies
	self assert: self collectionClass empty species identicalTo: String!

testSplitByCharacterArray
	| empty separators |
	empty := #().
	self assert: (empty split: (self assimilateString: 'abc')) equals: #('abc').

	"Split by multiple chars - each of the characters in the separator collection is a potential separator"
	separators := '.-' asArray.
	self assert: (separators split: empty) equals: (#() collect: [:e | self assimilateString: e]).
	self assert: (separators split: (self assimilateString: 'a'))
		equals: (#('a') collect: [:e | self assimilateString: e]).
	self assert: (separators split: (self assimilateString: '.a'))
		equals: (#('' 'a') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: '-a'))
		equals: (#('' 'a') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: 'a-'))
		equals: (#('a' '') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: '-.a'))
		equals: (#('' '' 'a') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: 'a.-'))
		equals: (#('a' '' '') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: 'ab'))
		equals: (#('ab') collect: [:e | self assimilateString: e]).
	self assert: (separators split: (self assimilateString: '-ab'))
		equals: (#('' 'ab') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: 'ab.'))
		equals: (#('ab' '') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: 'ab-..'))
		equals: (#('ab' '' '' '') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: '--ab'))
		equals: (#('' '' 'ab') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: 'a.b'))
		equals: (#('a' 'b') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: 'a-.b'))
		equals: (#('a' '' 'b') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: 'ab-c.'))
		equals: (#('ab' 'c' '') collect: [:e | self newCopy: e]).
	self assert: (separators split: (self assimilateString: 'a.b-.c'))
		equals: (#('a' 'b' '' 'c') collect: [:e | self newCopy: e]).
	1 to: 3
		do: 
			[:i |
			| subject |
			subject := self
						assimilateString: (String streamContents: [:strm | i timesRepeat: [strm nextPut: $-]]).
			self assert: (#($-) split: subject) equals: (Array new: i + 1 withAll: '')]!

testSplitByString
	"Test String>>split:, which tokenizes the argument string into sequences that are separated by the receiver string."

	| sep empty |
	empty := self collectionClass empty.
	self assert: (empty split: (self assimilateString: 'abc')) equals: #('abc').

	"And again but using a string argument of more than one character"
	sep := self assimilateString: String lineDelimiter.
	self assert: (sep split: empty) equals: (#() collect: [:e | self assimilateString: e]).
	self assert: (sep split: (self assimilateString: 'a'))
		equals: (#('a') collect: [:e | self assimilateString: e]).
	self assert: (sep split: (self assimilateString: sep , 'a'))
		equals: (#('' 'a') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self assimilateString: 'a' , sep))
		equals: (#('a' '') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self assimilateString: sep , sep , 'a'))
		equals: (#('' '' 'a') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self assimilateString: 'a' , sep , sep))
		equals: (#('a' '' '') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self assimilateString: 'ab'))
		equals: (#('ab') collect: [:e | self assimilateString: e]).
	self assert: (sep split: (self assimilateString: sep , 'ab'))
		equals: (#('' 'ab') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self assimilateString: 'ab' , sep))
		equals: (#('ab' '') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self assimilateString: 'ab' , sep , sep , sep))
		equals: (#('ab' '' '' '') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self assimilateString: sep , sep , 'ab'))
		equals: (#('' '' 'ab') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self assimilateString: 'a' , sep , 'b'))
		equals: (#('a' 'b') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self assimilateString: 'a' , sep , sep , 'b'))
		equals: (#('a' '' 'b') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self assimilateString: 'ab' , sep , 'c' , sep))
		equals: (#('ab' 'c' '') collect: [:e | self newCopy: e]).
	self assert: (sep split: (self assimilateString: 'a' , sep , 'b' , sep , sep , 'c'))
		equals: (#('a' 'b' '' 'c') collect: [:e | self newCopy: e]).
	1 to: 3
		do: 
			[:i |
			| subject |
			subject := self
						assimilateString: (String streamContents: [:strm | i timesRepeat: [strm nextPutAll: 'ab']]).
			self assert: ('ab' split: subject) equals: (Array new: i + 1 withAll: empty)]!

testSplitSingle
	"Test split by a single character string"

	| empty sep |
	empty := ''.
	"And again but using a string argument of only one character"
	sep := '-'.
	self assert: (sep split: empty) equals: #().
	self assert: (sep split: sep) equals: {empty. empty}.
	self assert: (sep split: 'a') equals: #('a').
	self assert: (sep split: '-a') equals: #('' 'a').
	self assert: (sep split: 'a-') equals: #('a' '').
	self assert: (sep split: '--a') equals: #('' '' 'a').
	self assert: (sep split: 'a--') equals: #('a' '' '').
	self assert: (sep split: 'ab') equals: #('ab').
	self assert: (sep split: '-ab') equals: #('' 'ab').
	self assert: (sep split: 'ab-') equals: #('ab' '').
	self assert: (sep split: 'ab---') equals: #('ab' '' '' '').
	self assert: (sep split: '--ab') equals: #('' '' 'ab').
	self assert: (sep split: 'a-b') equals: #('a' 'b').
	self assert: (sep split: 'a--b') equals: #('a' '' 'b').
	self assert: (sep split: 'ab-c-') equals: #('ab' 'c' '').
	self assert: (sep split: 'a-b--c') equals: #('a' 'b' '' 'c')!

testStreamUtfRoundTrip
	| expected actual |
	self collectionClass == Symbol ifTrue: [^self].
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

testSubStringsByCharacter
	"Test revised subStrings: behavior for single character delimiter (symmetric with respect to leading/trailing separators)."

	| empty |
	empty := self collectionClass empty.
	self assert: (empty subStrings: $-) equals: (#() collect: [:e | self assimilateString: e]).
	self assert: ('-' subStrings: $-) equals: {empty. empty}.
	self assert: ((self assimilateString: 'a') subStrings: $-)
		equals: (#('a') collect: [:e | self assimilateString: e]).
	self assert: ((self assimilateString: '-a') subStrings: $-)
		equals: (#('' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'a-') subStrings: $-)
		equals: (#('a' '') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: '--a') subStrings: $-)
		equals: (#('' '' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'a--') subStrings: $-)
		equals: (#('a' '' '') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'ab') subStrings: $-)
		equals: (#('ab') collect: [:e | self assimilateString: e]).
	self assert: ((self assimilateString: '-ab') subStrings: $-)
		equals: (#('' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'ab-') subStrings: $-)
		equals: (#('ab' '') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'ab---') subStrings: $-)
		equals: (#('ab' '' '' '') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: '--ab') subStrings: $-)
		equals: (#('' '' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'a-b') subStrings: $-)
		equals: (#('a' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'a--b') subStrings: $-)
		equals: (#('a' '' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'ab-c-') subStrings: $-)
		equals: (#('ab' 'c' '') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'a-b--c') subStrings: $-)
		equals: (#('a' 'b' '' 'c') collect: [:e | self newCopy: e]).

	"Note that if the string consists only of separators, then we get N+1 empty strings if there are N chars"
	1 to: 3
		do: 
			[:i |
			| subject |
			subject := self assimilateString: (String new: i withAll: $a).
			self assert: (subject subStrings: $a) equals: (Array new: i + 1 withAll: empty)]!

testSubStringsByString
	"Test subStrings: with a multi-character string argument. This is the historic behaviour, which ignored a trailing terminator. This will be corrected in 7.2 which will also adopt the ANSI specified behaviour of splitting by any of the 
	characters in the argument string. The String>>split: allows for splitting by all of a sequence of characters."

	| sep empty |
	empty := self collectionClass empty.
	self assert: (empty subStrings: $-) equals: (#() collect: [:e | self assimilateString: e]).
	sep := self assimilateString: String lineDelimiter.
	self assert: (empty subStrings: sep) equals: #().
	self assert: ((self assimilateString: 'a') subStrings: sep)
		equals: (#('a') collect: [:e | self assimilateString: e]).
	self assert: ((self assimilateString: sep , 'a') subStrings: sep)
		equals: (#('' 'a') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'a' , sep) subStrings: sep)
		equals: (#('a' '') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: sep , sep , 'a') subStrings: sep)
		equals: (#('' '' 'a') collect: [:e | self newCopy: e]).
	"Note asymmetry - two leading separators and we get a 3 element result, two trailing separator and we get a 2 element result."
	self assert: ((self assimilateString: 'a' , sep , sep) subStrings: sep)
		equals: (#('a' '' '') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'ab') subStrings: sep)
		equals: (#('ab') collect: [:e | self assimilateString: e]).
	self assert: ((self assimilateString: sep , 'ab') subStrings: sep)
		equals: (#('' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'ab' , sep) subStrings: sep)
		equals: (#('ab' '') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'ab' , sep , sep , sep) subStrings: sep)
		equals: (#('ab' '' '' '') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: sep , sep , 'ab') subStrings: sep)
		equals: (#('' '' 'ab') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'a' , sep , 'b') subStrings: sep)
		equals: (#('a' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'a' , sep , sep , 'b') subStrings: sep)
		equals: (#('a' '' 'b') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'ab' , sep , 'c' , sep) subStrings: sep)
		equals: (#('ab' 'c' '') collect: [:e | self newCopy: e]).
	self assert: ((self assimilateString: 'a' , sep , 'b' , sep , sep , 'c') subStrings: sep)
		equals: (#('a' 'b' '' 'c') collect: [:e | self newCopy: e]).
	1 to: 3
		do: 
			[:i |
			| subject |
			subject := self
						assimilateString: (String streamContents: [:strm | i timesRepeat: [strm nextPutAll: 'ab']]).
			self assert: (subject subStrings: 'ab') equals: (Array new: i + 1 withAll: empty)]!

testTitlecaseString
	| subject |
	self assert: ('istanbul' titleCased: (Locale standard: 'tr-Tr')) equals: 'İstanbul'.
	self assert: ('istanbul' titleCased: (Locale standard: 'en-GB')) equals: 'Istanbul'.
	subject := Locale invariant.
	"The invariant locale does perform linguistic case conversions, but only the turkic locales recognise the disinction between dotted and dotless 'i'"
	self assert: ('istanbul' titleCased: subject) equals: 'Istanbul'!

testTrimNulls
	"#1187"

	| string trimmed |
	string := self newCollection: #($a $\0 $\0).
	trimmed := string trimNulls.
	self assert: trimmed size equals: 1.
	self assert: (self assimilateString: trimmed) equals: (self assimilateString: 'a')!

testUrlDecoded
	"Test URI decoding per RFC3986"

	| unreserved misencoded |
	#(#('' '') #('+' ' ') #('A' 'A') #('+A' ' A') #('++A' '  A') #('A+' 'A ') #('A++' 'A  ') #('AB' 'AB') #('+A+B+' ' A B ') #('++A++B++' '  A  B  ') #('%41' 'A') #('+%41+' ' A ') #('%41B' 'AB') #('%41+B' 'A B') #('%41++B' 'A  B') #('%41BC' 'ABC') #('%41%42' 'AB') #('%41B%43' 'ABC') #('%41BC%44' 'ABCD') #('A%42%43' 'ABC') #('AB%43%44' 'ABCD') #('AB%43D%45' 'ABCDE') #('AB%43DE%46' 'ABCDEF') #('AB%43DE%46G' 'ABCDEFG') #('AB%43DE%46GH' 'ABCDEFGH') #('~25%25' '~25%'))
		do: 
			[:each |
			| subject actual |
			subject := self collectionClass fromString: each first.
			actual := subject urlDecoded.
			self assert: actual equals: each last].
	"Test case from @fxgallego"
	self assert: (self collectionClass fromString: 'Ca%C3%B1%C3%B3n') urlDecoded equals: 'Cañón'.
	"Non-latin 3-byte encoding test case from RFC3986"
	self assert: (self collectionClass fromString: '%E3%82%A2') urlDecoded equals: $\x30A2 asUtf8String.
	"And a 4-byte encoding for fun"
	self assert: (self collectionClass fromString: '%F0%9F%90%AC') urlDecoded equals: '🐬'.

	"All reserved characters in RFC3986, exception '+', should be unaffected by decoding"
	self assert: (self collectionClass fromString: ':/?#[]@!!$&''()*+,;=') urlDecoded
		equals: ':/?#[]@!!$&''()* ,;='.

	"Unreserved characters, also untouched"
	unreserved := (Character byteCharacterSet select: [:each | each isEnglishLetter or: [each isDigit]])
				, '-._~'.
	self assert: (self collectionClass fromString: unreserved) urlDecoded equals: unreserved.
	"But should be coded if found encoded"
	misencoded := String writeStream.
	unreserved do: 
			[:each |
			misencoded nextPut: $%.
			each asciiValue
				printOn: misencoded
				base: 16
				showRadix: false].
	misencoded := misencoded contents.
	self assert: (self collectionClass fromString: misencoded) urlDecoded equals: unreserved.

	"Invalid cases, therefore assume not an escaped string"
	#('%GA' '%AG' '%[1' '%1[' '+%A' '%1' '100%' '%+') do: 
			[:each |
			| subject actual |
			subject := self collectionClass fromString: each.
			actual := subject urlDecoded.
			self assert: actual equals: (self newCopy: subject)].

	"Special cases of non-ASCII input - these should be detected and not decoded"
	#('€5+&+change' '£5+') do: 
			[:each |
			| subject actual |
			subject := self collectionClass fromString: each.
			actual := subject urlDecoded.
			self assert: actual equals: each].
	self collectionClass == AnsiString
		ifFalse: 
			[| subject |
			subject := self collectionClass fromString: '%97+🐬'.
			self assert: subject urlDecoded equals: subject]!

testUrlEncoded
	"Test URI encoding per RFC3986"

	| unreserved reserved |
	unreserved := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~'.
	reserved := ':/?#[]@!!$&''()*+,;='.

	"Unreserved shouldn't be encoded"
	self assert: (self collectionClass withAll: unreserved) urlEncoded equals: unreserved.
	"Reserved should allways be encoded when used for some other purpose."
	self assert: (self collectionClass withAll: reserved) urlEncoded
		equals: '%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D'.
	self assert: (self collectionClass with: Character space) urlEncoded equals: '%20'.
	self assert: (self collectionClass with: $%) urlEncoded equals: '%25'.
	self assert: (self collectionClass withAll: String lineDelimiter) urlEncoded equals: '%0D%0A'.
	"Other common characters found in urls."
	self assert: (self collectionClass withAll: '"<>\^`{|}') urlEncoded
		equals: '%22%3C%3E%5C%5E%60%7B%7C%7D'.
	"Some unicode"
	self assert: '🐬 cañón CAÑÓN' urlEncoded
		equals: '%F0%9F%90%AC%20ca%C3%B1%C3%B3n%20CA%C3%91%C3%93N'.
	self assert: '🐬 cañón CAÑÓN' asUtf16String urlEncoded
		equals: '%F0%9F%90%AC%20ca%C3%B1%C3%B3n%20CA%C3%91%C3%93N'.
	self assert: '日本語' urlEncoded equals: '%E6%97%A5%E6%9C%AC%E8%AA%9E'.
	"Test reversions"
	self assert: '🐬 cañón CAÑÓN' urlEncoded urlDecoded equals: '🐬 cañón CAÑÓN'.
	self assert: String lineDelimiter urlEncoded urlDecoded equals: String lineDelimiter.
	self assert: ' ' urlEncoded urlDecoded equals: ' '.
	self assert: (self collectionClass withAll: unreserved) urlEncoded urlDecoded equals: unreserved.
	self assert: (self collectionClass withAll: reserved) urlEncoded urlDecoded equals: reserved!

testWithAll
	self withAllTestCases do: 
			[:each |
			| actual |
			actual := self collectionClass withAll: each first.
			self assert: actual equals: each last]!

testWithNormalizedLineDelimiters
	"Empty"

	| cr lf crlf char |
	char := self assimilateString: '+'.
	cr := self collectionClass with: Character cr.
	crlf := self assimilateString: self collectionClass lineDelimiter.
	lf := self collectionClass with: Character lf.
	self assert: self collectionClass empty withNormalizedLineDelimiters equals: (self newCopy: '').
	"Not empty, but no delims"
	self assert: self collectionClass empty withNormalizedLineDelimiters equals: (self newCopy: '').
	"Single CR"
	self assert: cr withNormalizedLineDelimiters equals: (self newCopy: crlf).
	self assert: (char , cr) withNormalizedLineDelimiters equals: char , crlf.
	self assert: (char , cr , char) withNormalizedLineDelimiters equals: char , crlf , char.
	"Single LF"
	self assert: lf withNormalizedLineDelimiters equals: (self newCopy: crlf).
	self assert: (char , lf) withNormalizedLineDelimiters equals: char , crlf.
	self assert: (char , lf , char) withNormalizedLineDelimiters equals: char , crlf , char.
	"Single CR/LF - no change"
	self assert: crlf withNormalizedLineDelimiters equals: (self newCopy: crlf).
	self assert: (char , crlf) withNormalizedLineDelimiters equals: char , crlf.
	self assert: (char , crlf , char) withNormalizedLineDelimiters equals: char , crlf , char.
	"LF,CR"
	self assert: (lf , cr) withNormalizedLineDelimiters equals: crlf , crlf.
	self assert: (lf , cr , char) withNormalizedLineDelimiters equals: crlf , crlf , char.
	self assert: (char , lf , cr , char) withNormalizedLineDelimiters equals: char , crlf , crlf , char.
	"LF,LF"
	self assert: (lf , lf) withNormalizedLineDelimiters equals: crlf , crlf.
	self assert: (lf , lf , char) withNormalizedLineDelimiters equals: crlf , crlf , char.
	self assert: (char , lf , lf , char) withNormalizedLineDelimiters equals: char , crlf , crlf , char.
	"CR,CR"
	self assert: (cr , cr) withNormalizedLineDelimiters equals: crlf , crlf.
	self assert: (cr , cr , char) withNormalizedLineDelimiters equals: crlf , crlf , char.
	self assert: (char , cr , cr , char) withNormalizedLineDelimiters equals: char , crlf , crlf , char.
	"CRLFLF"
	self assert: (cr , lf , lf) withNormalizedLineDelimiters equals: crlf , crlf.
	"CRLFCR"
	self assert: (cr , lf , cr) withNormalizedLineDelimiters equals: crlf , crlf!

verifyConcatenationResult: resultString of: receiverString with: argumentString
	"When concatenating strings the result should be of the same type as the receiver, unless a
	UTF string is being concatenated with an AnsiString, in which case the result will be of the
	same type as the argument."

	| expected |
	expected := Utf8String writeStream
				nextPutAll: receiverString;
				nextPutAll: argumentString;
				contents.
	self assert: resultString equals: expected!

verifyPattern: patternString matches: matchString
	self assert: ((self assimilateString: patternString) match: (self assimilateString: matchString))!

verifyPattern: patternString mismatch: matchString
	self deny: ((self assimilateString: patternString) match: matchString).
	self deny: ((self assimilateString: patternString) match: (self assimilateString: matchString)).
	self deny: (patternString match: (self assimilateString: matchString))!

withAllTestCases
	^#(#('') #('a') #('abc') #('£€') #(#($a $£ $1 $\x20AC) 'a£1€'))! !

!Core.Tests.StringTest categoriesForMethods!
afterTestCases!constants!private! !
assimilate:!helpers!private! !
assimilateString:!helpers!private! !
beforeTestCases!constants!private! !
caseConversionCases!constants!private! !
caseInsensitiveEqualCases!constants!private! !
caseInsensitiveLessThanCases!constants!private! !
conversionTestCases!constants!private! !
copyClass!constants!private! !
equalityTestCases!constants!private! !
findActualIndicesOf:in:!helpers!private! !
indexOfTestCases!constants!private! !
lengthTestCases!constants!private! !
matchingPairs!constants!private! !
mismatchedPairs!constants!private! !
newNumericArray:!helpers!private! !
ordinalCaseConversionCases!constants!private! !
reverseTestCases!constants!private! !
testAfter!public!unit tests! !
testAsByteArray!public!unit tests! !
testAt!public!unit tests! !
testBefore!public!unit tests! !
testBeginsWithEmbeddedNulls!public!unit tests! !
testBeginsWithIgnoreCase!public!unit tests! !
testBeginsWithMixedEncodings!public!unit tests! !
testBinarySelectorExpandMacrosWith!public!unit tests! !
testBinarySelectorExpandMacrosWithArguments!public!unit tests! !
testBinarySelectorExpandMacrosWithCollection!public!unit tests! !
testCapitalized!public!unit tests! !
testCaseConversions!public!unit tests! !
testClassFromAddress!public!unit tests! !
testClassReadFrom!public!unit tests! !
testCopyToComTaskMemory!public!unit tests! !
testCopyWith!public! !
testCopyWithout!public! !
testEmpty!public!unit tests! !
testEndsWithEmpty!public!unit tests! !
testEquals!public!unit tests! !
testExpandMacrosWith!public!unit tests! !
testExpandMacrosWithArguments!public!unit tests! !
testFindStringStartingAt!public!unit tests! !
testFindStringStartingAtIgnoreCase!public!unit tests! !
testFormatWith!public!unit tests! !
testFromAddress!public!unit tests! !
testFromAtomId!public!unit tests! !
testHash!public!unit tests! !
testIndexOfStartingAt!public!unit tests! !
testInvalidComparisons!public!unit tests! !
testJoin!public!unit tests! !
testLastCodeUnit!public!unit tests! !
testLastIndexOf!public!unit tests! !
testLength!public!unit tests! !
testLessOrEqual!public!unit tests! !
testLines!public!unit tests! !
testMatch!public! !
testMutableCopy!public!unit tests! !
testOrdinalCaseInsensitiveComparison!public!unit tests! !
testOrdinalCaseInsensitiveEquality!public!unit tests! !
testReadFrom!public!unit tests! !
testRefersToLiteral!public!unit tests! !
testResize!public!unit tests! !
testReverse!public!unit tests! !
testReversedFromTo!public!unit tests! !
testReverseDo!public!unit tests! !
testSpaceships!public!unit tests! !
testSpecies!public!unit tests! !
testSplitByCharacterArray!public!unit tests! !
testSplitByString!public!unit tests! !
testSplitSingle!public!unit tests! !
testStreamUtfRoundTrip!public!unit tests! !
testSubStringsByCharacter!public!unit tests! !
testSubStringsByString!public!unit tests! !
testTitlecaseString!public!unit tests! !
testTrimNulls!public!unit tests! !
testUrlDecoded!public!unit tests! !
testUrlEncoded!public!unit tests! !
testWithAll!public!unit tests! !
testWithNormalizedLineDelimiters!public!unit tests! !
verifyConcatenationResult:of:with:!helpers!private! !
verifyPattern:matches:!public! !
verifyPattern:mismatch:!public! !
withAllTestCases!constants!private! !
!

