"Filed out from Dolphin Smalltalk"!

ArrayedCollectionTest subclass: #RunArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!RunArrayTest categoriesForMethods!
collectionClass!helpers!private! !
testReplaceFromToWithStartingAt!public! !
testReplaceIdentityWith!public! !
testResize!public!unit tests! !
!

