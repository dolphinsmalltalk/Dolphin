"Filed out from Dolphin Smalltalk 7"!

AbstractStringTest subclass: #StringTest
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

assimilateString: aString
	^aString!

collectionClass
	^String!

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
!StringTest categoriesFor: #assimilateString:!helpers!private! !
!StringTest categoriesFor: #collectionClass!helpers!private! !
!StringTest categoriesFor: #testAsPhrase!public!unit tests! !
!StringTest categoriesFor: #testIndexOfSubCollectionStartingAtGPF!public!unit tests! !
!StringTest categoriesFor: #testMatch!public!unit tests! !

