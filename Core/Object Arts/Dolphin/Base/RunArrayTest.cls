"Filed out from Dolphin Smalltalk 7"!

ArrayedCollectionTest subclass: #RunArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RunArrayTest guid: (GUID fromString: '{656416ed-47db-44fd-a18d-124febcc1ddf}')!
RunArrayTest comment: ''!
!RunArrayTest categoriesForClass!Unclassified! !
!RunArrayTest methodsFor!

collectionClass
	^RunArray!

testReplaceFromToWithStartingAt
	self should: [super testReplaceFromToWithStartingAt] raise: Error!

testReplaceIdentityWith
	self should: [super testReplaceIdentityWith] raise: Error!

testResize
	self shouldnt: [super testResize] implement: #resize:! !
!RunArrayTest categoriesFor: #collectionClass!helpers!private! !
!RunArrayTest categoriesFor: #testReplaceFromToWithStartingAt!public! !
!RunArrayTest categoriesFor: #testReplaceIdentityWith!public! !
!RunArrayTest categoriesFor: #testResize!public!unit tests! !

