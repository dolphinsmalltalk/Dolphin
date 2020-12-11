"Filed out from Dolphin Smalltalk 7"!

Core.Tests.ArrayedCollectionTest subclass: #'Core.Tests.RunArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.RunArrayTest guid: (Core.GUID fromString: '{656416ed-47db-44fd-a18d-124febcc1ddf}')!
Core.Tests.RunArrayTest comment: ''!
!Core.Tests.RunArrayTest categoriesForClass!Unclassified! !
!Core.Tests.RunArrayTest methodsFor!

collectionClass
	^RunArray!

testReplaceFromToWithStartingAt
	self should: [super testReplaceFromToWithStartingAt] raise: Error!

testReplaceIdentityWith
	self should: [super testReplaceIdentityWith] raise: Error!

testResize
	self shouldnt: [super testResize] implement: #resize:! !
!Core.Tests.RunArrayTest categoriesFor: #collectionClass!helpers!private! !
!Core.Tests.RunArrayTest categoriesFor: #testReplaceFromToWithStartingAt!public! !
!Core.Tests.RunArrayTest categoriesFor: #testReplaceIdentityWith!public! !
!Core.Tests.RunArrayTest categoriesFor: #testResize!public!unit tests! !

