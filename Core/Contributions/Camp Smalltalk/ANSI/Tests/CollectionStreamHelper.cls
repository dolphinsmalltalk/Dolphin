"Filed out from Dolphin Smalltalk 7"!

TestCaseHelper subclass: #CollectionStreamHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CollectionStreamHelper guid: (GUID fromString: '{42d3564c-fcc9-4e6e-a28c-7ac21388a210}')!
CollectionStreamHelper comment: ''!
!CollectionStreamHelper categoriesForClass!Unclassified! !
!CollectionStreamHelper methodsFor!

canonicalObject

	^testCase canonicalObject!

object: anObject!

testXcontents

	self value: [self canonicalObject contents]
		should: [:r | r = 'this is a string'
				& r size = self canonicalObject size]
		conformTo: self protocol selector: #'contents'.! !
!CollectionStreamHelper categoriesFor: #canonicalObject!public! !
!CollectionStreamHelper categoriesFor: #object:!public! !
!CollectionStreamHelper categoriesFor: #testXcontents!public! !

!CollectionStreamHelper class methodsFor!

initialize
	"CollectionStreamHelper  initialize"
	super initialize! !
!CollectionStreamHelper class categoriesFor: #initialize!public! !

