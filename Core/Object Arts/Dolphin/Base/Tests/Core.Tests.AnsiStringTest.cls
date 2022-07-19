"Filed out from Dolphin Smalltalk"!

Core.Tests.StringTest subclass: #'Core.Tests.AnsiStringTest'
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
			strings add: current]! !
!Core.Tests.AnsiStringTest categoriesForMethods!
assimilate:!helpers!private! !
assimilateString:!helpers!private! !
collectionClass!helpers!private! !
testAsPhrase!public!unit tests! !
testBeginsWithIgnoreCase!public!unit tests! !
testClassWith!public! !
testCopyReplaceAllWith!public!unit tests! !
testIndexOfSubCollectionStartingAtGPF!public!unit tests! !
!

