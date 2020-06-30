"Filed out from Dolphin Smalltalk 7"!

TestCaseHelper subclass: #ReadStreamHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ReadStreamHelper guid: (GUID fromString: '{b1e7e2f2-0c17-49fd-a43e-698ad5d28f0b}')!
ReadStreamHelper comment: ''!
!ReadStreamHelper categoriesForClass!Unclassified! !
!ReadStreamHelper methodsFor!

canonicalObject

	^testCase canonicalObject!

object: anObject!

protocol
	^#'ReadStream'!

testXnextX

	self canonicalObject reset.
	self value: [self canonicalObject next: 3]
		should: [:r | r asArray = 'thi' asArray]
		conformTo: self protocol selector: #'next:'.

	self value: [self canonicalObject next: 0]
		should: [:r | r isEmpty]
		conformTo: self protocol selector: #'next:'.

	"Errors: amount < 0."
	self value: [self canonicalObject next: -1]
		shouldRaise: Error.!

testXupToX

	self canonicalObject reset.
	self value: [self canonicalObject upTo: $ ]
		should: [:r | r = 'this' & (self canonicalObject next = $i)]
		conformTo: self protocol selector: #upTo:.

	self value: [self canonicalObject upTo: $X]
		should: [:r | r = 's a string' & self canonicalObject atEnd]
		conformTo: self protocol selector: #upTo:.

	self value: [self canonicalObject upTo: $a]
		should: [:r | r isEmpty]
		conformTo: self protocol selector: #upTo:.! !
!ReadStreamHelper categoriesFor: #canonicalObject!public! !
!ReadStreamHelper categoriesFor: #object:!public! !
!ReadStreamHelper categoriesFor: #protocol!public! !
!ReadStreamHelper categoriesFor: #testXnextX!public! !
!ReadStreamHelper categoriesFor: #testXupToX!public! !

!ReadStreamHelper class methodsFor!

initialize
	"ReadStreamHelper  initialize"
	super initialize! !
!ReadStreamHelper class categoriesFor: #initialize!public! !

