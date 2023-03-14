"Filed out from Dolphin Smalltalk"!

Core.Tests.StringTest
	subclass: #'Core.Tests.AnsiStringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.AnsiStringTest guid: (Core.GUID fromString: '{c1474b06-e77d-41d7-ad4d-10d5114f8471}')!
Core.Tests.AnsiStringTest comment: 'Tests AnsiString.'!
!Core.Tests.AnsiStringTest methodsFor!

assimilate: each
	^Character ansiValue: each asInteger!

assimilateString: aString
	^aString asAnsiString!

collectionClass
	^AnsiString!

testAsPhrase
	self assert: #'' asPhrase equals: ''.
	self assert: #= asPhrase equals: '='.
	self assert: ':=' asSymbol asPhrase equals: '='.
	self assert: ':=:=' asSymbol asPhrase equals: '= ='.
	self assert: #x asPhrase equals: 'X'.
	self assert: #nl asPhrase equals: 'Nl'.
	self assert: #x: asPhrase equals: 'X'.
	self assert: ':' asSymbol asPhrase equals: ''.
	self assert: '::' asSymbol asPhrase equals: ''.
	self assert: ':a' asSymbol asPhrase equals: 'A'.
	self assert: ':A' asSymbol asPhrase equals: 'A'.
	self assert: ':a:' asSymbol asPhrase equals: 'A'.
	self assert: ':A:' asSymbol asPhrase equals: 'A'.
	self assert: '::a:' asSymbol asPhrase equals: 'A'.
	self assert: '::A:' asSymbol asPhrase equals: 'A'.
	self assert: '::a:b::c:D::E:f::G::h:' asSymbol asPhrase equals: 'A B C D E F G H'.
	self assert: #assert: asPhrase equals: 'Assert'.
	self assert: #testAsPhrase asPhrase equals: 'Test As Phrase'.
	self assert: #newCopy: asPhrase equals: 'New Copy'.
	self assert: #replaceFrom:to:with:startingAt: asPhrase equals: 'Replace From To With Starting At'.
	self assert: #AXMethodName asPhrase equals: 'AXMethod Name'.
	self assert: #GetIDsOfNames:rgszNames:cNames:lcid:rgdispid: asPhrase
		equals: 'Get IDs Of Names Rgsz Names C Names Lcid Rgdispid'!

testBeginsWithIgnoreCase
	| subject comparand |
	subject := self newCollection: {$a. $\0. $£. $b. $c}.
	self assert: (subject beginsWith: subject ignoreCase: true).
	self assert: (subject beginsWith: subject ignoreCase: false).
	comparand := self newCollection: {$A. $\0. $£}.
	self assert: (subject beginsWith: comparand ignoreCase: true).
	self deny: (subject beginsWith: comparand ignoreCase: false).
	comparand := self newCollection: {$A. $\0. $b. $£}.
	self deny: (subject beginsWith: comparand ignoreCase: false).
	self deny: (subject beginsWith: comparand ignoreCase: true)!

testClassWith
	self assert: (AnsiString with: $a) equals: 'a' asAnsiString.
	self assert: (AnsiString with: Character replacement)
		equals: (AnsiString with: (Character value: 63))!

testConcatenateInvalidUtf16
	"The result will preserve any invalid chars in the suffix as is because it is assumed to be well-formed UTF-16 already"

	| actual invalid invalidBytes |
	invalidBytes := #[98 0 163 0 172 32 0 220 61 216].
	invalid := Utf16String fromByteArray: invalidBytes.
	actual :=  '£' asAnsiString , invalid.
	self assert: actual isKindOf: Utf16String.
	self assert: actual equals: (Utf16String fromByteArray: #[163 0] , invalidBytes)!

testConcatenateInvalidUtf8
	"The result will preserve any invalid chars in the suffix as is because it is assumed to be well-formed UTF-8 already"

	| actual |
	actual := '£' asAnsiString
				, (Utf8String fromByteArray: #[98 194 226 130 172 144 128 128 240 159 172]).
	self assert: actual isKindOf: Utf8String.
	self assert: actual
		equals: (Utf8String fromByteArray: #[194 163 98 194 226 130 172 144 128 128 240 159 172])!

testConcatenation
	| actual triples |
	actual := AnsiString empty , AnsiString empty.
	self assert: actual isKindOf: AnsiString.
	self assert: actual equals: ''.
	self deny: actual identicalTo: AnsiString empty.
	triples := #(#('' '€' '€') #('' '€£' '€£') #('£' '€' '£€') #('£' '€~' '£€~') #('€~' '£' '€~£')).
	triples do: 
			[:each |
			actual := each first asAnsiString , each second asAnsiString.
			self assert: actual isKindOf: AnsiString.
			self assert: actual equals: each third.
			actual := each second asAnsiString , each first asAnsiString.
			self assert: actual isKindOf: AnsiString.
			self assert: actual
				equals: (AnsiString writeStream
						nextPutAll: each second;
						nextPutAll: each first;
						contents)].
	actual := (AnsiString with: $\0 with: $£) , '€~' asAnsiString.
	self assert: actual isKindOf: AnsiString.
	self assert: actual
		equals: (AnsiString
				with: $\0
				with: $£
				with: $€
				with: $~).
	actual := AnsiString empty , Utf8String empty.
	self assert: actual isKindOf: Utf8String.
	self assert: actual equals: ''.
	self deny: actual identicalTo: Utf8String empty.
	triples := #(#('' '€' '€') #('€' '' '€') #('' '€£' '€£') #('€£' '' '€£') #('a' '£' 'a£') #('a' '€' 'a€') #('' '🐬' '🐬') #('£' 'a' '£a') #('€' 'a' '€a') #('£' '€~🐬' '£€~🐬') #('a£~€' 'b£€�𐀀🐬' 'a£~€b£€�𐀀🐬')).
	triples do: 
			[:each |
			| utf8 ansi |
			ansi := each first asAnsiString.
			utf8 := each second asUtf8String.
			actual := ansi , utf8.
			self assert: actual isKindOf: Utf8String.
			self assert: actual equals: each third.
			self assert: utf8 , ansi equals: utf8 , ansi asUtf8String].
	triples do: 
			[:each |
			| ansi utf16 |
			ansi := each first asAnsiString.
			utf16 := each second asUtf16String.
			actual := ansi , utf16.
			self assert: actual isKindOf: Utf16String.
			self assert: actual equals: each third.
			self assert: utf16 , ansi equals: utf16 , ansi asUtf16String]!

testCopyReplaceAllWith
	| subject actual |
	super testCopyReplaceAllWith.
	subject := self assimilateString: 'a£aa£'.
	actual := subject copyReplaceAll: 'a£' asUtf8String with: 'a€' asUtf8String.
	self assert: actual equals: 'a€aa€'.
	actual := subject copyReplaceAll: 'a£' asUtf16String with: 'a€' asUtf16String.
	self assert: actual equals: 'a€aa€'.
	actual := subject copyReplaceAll: 'a£' asArray with: 'a€' asArray.
	self assert: actual equals: 'a€aa€'!

testFindUtfStringStartingAt
	"Test searching for a UtfEncodedString in an AnsiString. More complex cases are non-ascii and outside BMP (non-Ansi representable) characters."

	| searchee |
	searchee := self assimilateString: 'a£cd€ga£cd€g'.
	{ 'a£c' asUtf8String. 'a£c' asUtf16String } do: 
			[:abc |
			self assert: (searchee findString: abc startingAt: 1) equals: 1.
			self assert: (searchee findString: abc startingAt: 2) equals: (searchee lastIndexOf: $£) - 1.
			self assert: (searchee findString: abc startingAt: searchee size) equals: 0.
			self assert: (searchee findString: abc startingAt: 11) equals: 0.
			self assert: (searchee findString: abc startingAt: 1) equals: 1].
	{ '€g' asUtf8String. '€g' asUtf16String } do: 
			[:each |
			self assert: (searchee findString: each startingAt: 1) equals: 5.
			self assert: (searchee findString: each startingAt: 2) equals: 5.
			self assert: (searchee findString: each startingAt: searchee size) equals: 0.
			self assert: (searchee findString: each startingAt: 5) equals: 5.
			self assert: (searchee findString: each startingAt: 6) equals: 11].
	"If the search string contains any chars that cannot be represented in an AnsiString, then the result must always be 0 (not found). Shouldn't match against Ansi replacement character"
	searchee := self assimilateString: 'a?£'.
	{ '🐬£' asUtf8String. '🐬£' asUtf16String }
		do: [:each | self assert: (searchee findString: each startingAt: 1) equals: 0].

	"Also test invalid UTF-8 sequence - e.g. overlong U+002F"
	searchee := self assimilateString: 'a/b'.
	self assert: (searchee findString: '/' startingAt: 1) equals: 2.
	self assert: (searchee findString: (Utf8String fromByteArray: #[16rE0 16r80 16rAF]) startingAt: 1)
		equals: 0.
	self assert: ('a??b' findString: (Utf8String fromByteArray: #[16rC0 16rAF]) startingAt: 1) equals: 0!

testIndexOfSubCollectionStartingAtGPF
	| strings search current |
	#'1553'.
	search := String new: 26.
	strings := OrderedCollection new.
	1 to: 1000
		do: 
			[:i |
			current := String new: 970.
			self assert: (current indexOfSubCollection: search startingAt: 965) identicalTo: 0.
			strings add: current]! !
!Core.Tests.AnsiStringTest categoriesForMethods!
assimilate:!helpers!private! !
assimilateString:!helpers!private! !
collectionClass!helpers!private! !
testAsPhrase!public!unit tests! !
testBeginsWithIgnoreCase!public!unit tests! !
testClassWith!public! !
testConcatenateInvalidUtf16!public!unit tests! !
testConcatenateInvalidUtf8!public!unit tests! !
testConcatenation!public!unit tests! !
testCopyReplaceAllWith!public!unit tests! !
testFindUtfStringStartingAt!public!unit tests! !
testIndexOfSubCollectionStartingAtGPF!public!unit tests! !
!

