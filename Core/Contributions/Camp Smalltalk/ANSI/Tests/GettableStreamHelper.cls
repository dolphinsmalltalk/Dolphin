"Filed out from Dolphin Smalltalk 7"!

TestCaseHelper subclass: #GettableStreamHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GettableStreamHelper guid: (GUID fromString: '{7d036737-d26d-4eb6-966b-b4807d3b7cb6}')!
GettableStreamHelper comment: ''!
!GettableStreamHelper categoriesForClass!Unclassified! !
!GettableStreamHelper methodsFor!

canonicalObject

	^testCase canonicalObject!

object: anObject!

protocol
	^#'gettableStream'!

testXatEnd

	self canonicalObject reset.
	self value: [self canonicalObject atEnd]
		shouldnt: [:r | r]
		conformTo: self protocol selector: #'atEnd'.

	self canonicalObject setToEnd.
	self value: [self canonicalObject atEnd]
		should: [:r | r]
		conformTo: self protocol selector: #'atEnd'.!

testXdoX
	| list list2 |
	self canonicalObject reset.
	list := OrderedCollection new.
	self value: [self canonicalObject do: [ :elem | list add: elem]]
		should: [:r | list asArray = 'this is a string' asArray]
		conformTo: self protocol selector: #'do:'.

	self canonicalObject setToEnd.
	list2 := OrderedCollection new.
	self value: [self canonicalObject do: [ :elem | list2 add: elem]]
		should: [:r | "r UNSPECIFIED" list2 isEmpty]
		conformTo: self protocol selector: #'do:'.!

testXnext

	self canonicalObject reset.
	self value: [self canonicalObject next]
		should: [:r | r = $t]
		conformTo: self protocol selector: #'next'.!

testXnextLine

	self canonicalObject reset.
	self value: [self canonicalObject nextLine]
		should: [:r | true "The result is undefined if there are no future sequence values in the receiver or if the future-sequence values do not include the end-of-line sequence."]
		conformTo: self protocol selector: #'nextLine'.!

testXnextMatchForX

	self canonicalObject reset.
	self value: [self canonicalObject nextMatchFor: $t]
		should: [:r | r]
		conformTo: self protocol selector: #'nextMatchFor:'.

	self value: [self canonicalObject nextMatchFor: $t]
		shouldnt: [:r | r]
		conformTo: self protocol selector: #'nextMatchFor:'.!

testXnextX

	self canonicalObject reset.
	self value: [self canonicalObject next: 3]
		should: [:r | r asArray = 'thi' asArray]
		conformTo: self protocol selector: #'next:'.!

testXpeek

	self canonicalObject reset.
	self value: [self canonicalObject peek]
		should: [:r | r = $t]
		conformTo: self protocol selector: #'peek'.

	self canonicalObject setToEnd.
	self value: [self canonicalObject peek]
		should: [:r | r = nil]
		conformTo: self protocol selector: #'peek'.!

testXpeekForX

	self canonicalObject reset.
	self value: [self canonicalObject peekFor: $t]
		should: [:r | r]
		conformTo: self protocol selector: #'peekFor:'.

	self value: [self canonicalObject peekFor: $X]
		shouldnt: [:r | r]
		conformTo: self protocol selector: #'peekFor:'.!

testXskipToX

	self canonicalObject reset.
	self value: [self canonicalObject skipTo: $a]
		should: [:r | r  & (self canonicalObject position = 9)]
		conformTo: self protocol selector: #'skipTo:'.

	self value: [self canonicalObject skipTo: $X]
		should: [:r | r = false & self canonicalObject atEnd]
		conformTo: self protocol selector: #'skipTo:'.!

testXskipX
	self canonicalObject reset.
	self
		value: [self canonicalObject skip: 3]
		should: 
			[:r |
			"r UNSPECIFIED"
			self canonicalObject next = $s]
		conformTo: self protocol
		selector: #skip:.
	self canonicalObject position: self canonicalObject contents size - 1.
	"The standard is fairly clear that gettableStream>>skip: should not raise an error if the offset takes the stream out of bounds, but in both Squeak/Pharo and Dolphin this is an error."
	self isStrict
		ifTrue: 
			[self
				value: [self canonicalObject skip: 3]
				should: 
					[:r |
					"r UNSPECIFIED"
					self canonicalObject next = nil]
				conformTo: self protocol
				selector: #skip:]
		ifFalse: [self should: [self canonicalObject skip: 3] raise: Error]!

testXupToX

	self canonicalObject reset.
	self value: [self canonicalObject upTo: $ ]
		should: [:r | r = 'this' & (self canonicalObject next = $i)]
		conformTo: self protocol selector: #'upTo:'.

	self value: [self canonicalObject upTo: $X]
		should: [:r | r = 's a string' & self canonicalObject atEnd]
		conformTo: self protocol selector: #'upTo:'.

	self value: [self canonicalObject upTo: $a]
		should: [:r | r isEmpty]
		conformTo: self protocol selector: #'upTo:'.! !
!GettableStreamHelper categoriesFor: #canonicalObject!public! !
!GettableStreamHelper categoriesFor: #object:!public! !
!GettableStreamHelper categoriesFor: #protocol!public! !
!GettableStreamHelper categoriesFor: #testXatEnd!public! !
!GettableStreamHelper categoriesFor: #testXdoX!public! !
!GettableStreamHelper categoriesFor: #testXnext!public! !
!GettableStreamHelper categoriesFor: #testXnextLine!public! !
!GettableStreamHelper categoriesFor: #testXnextMatchForX!public! !
!GettableStreamHelper categoriesFor: #testXnextX!public! !
!GettableStreamHelper categoriesFor: #testXpeek!public! !
!GettableStreamHelper categoriesFor: #testXpeekForX!public! !
!GettableStreamHelper categoriesFor: #testXskipToX!public! !
!GettableStreamHelper categoriesFor: #testXskipX!public! !
!GettableStreamHelper categoriesFor: #testXupToX!public! !

!GettableStreamHelper class methodsFor!

initialize
	"GettableStreamHelper  initialize"
	super initialize! !
!GettableStreamHelper class categoriesFor: #initialize!public! !

