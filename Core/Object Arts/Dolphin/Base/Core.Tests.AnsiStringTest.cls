"Filed out from Dolphin Smalltalk 7"!

Core.Tests.StringTest subclass: #'Core.Tests.AnsiStringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.AnsiStringTest guid: (Core.GUID fromString: '{c1474b06-e77d-41d7-ad4d-10d5114f8471}')!
Core.Tests.AnsiStringTest comment: 'Tests AnsiString.'!
!Core.Tests.AnsiStringTest categoriesForClass!Unclassified! !
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
	| subject comperand |
	subject := self newCollection: {$a. $\0. $£. $b. $c}.
	self assert: (subject beginsWith: subject ignoreCase: true).
	self assert: (subject beginsWith: subject ignoreCase: false).
	comperand := self newCollection: {$A. $\0. $£}.
	self assert: (subject beginsWith: comperand ignoreCase: true).
	self deny: (subject beginsWith: comperand ignoreCase: false).
	comperand := self newCollection: {$A. $\0. $b. $£}.
	self deny: (subject beginsWith: comperand ignoreCase: false).
	self deny: (subject beginsWith: comperand ignoreCase: true)!

testClassWith
	self assert: (AnsiString with: $a) equals: 'a' asAnsiString.
	self assert: (AnsiString with: Character replacement)
		equals: (AnsiString with: (Character value: 63))!

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
			strings add: current]!

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
	#('bar' 'foo#' '#foo' '*foo#' '#foo*' '*bar*') do: [:each | self deny: (each match: 'foo')]! !
!Core.Tests.AnsiStringTest categoriesFor: #assimilate:!helpers!private! !
!Core.Tests.AnsiStringTest categoriesFor: #assimilateString:!helpers!private! !
!Core.Tests.AnsiStringTest categoriesFor: #collectionClass!helpers!private! !
!Core.Tests.AnsiStringTest categoriesFor: #testAsPhrase!public!unit tests! !
!Core.Tests.AnsiStringTest categoriesFor: #testBeginsWithIgnoreCase!public!unit tests! !
!Core.Tests.AnsiStringTest categoriesFor: #testClassWith!public! !
!Core.Tests.AnsiStringTest categoriesFor: #testCopyReplaceAllWith!public!unit tests! !
!Core.Tests.AnsiStringTest categoriesFor: #testIndexOfSubCollectionStartingAtGPF!public!unit tests! !
!Core.Tests.AnsiStringTest categoriesFor: #testMatch!public!unit tests! !

