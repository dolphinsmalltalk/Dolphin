"Filed out from Dolphin Smalltalk"!

Core.Tests.ArrayedCollectionTest
	subclass: #'Core.Tests.RunArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.RunArrayTest guid: (Core.GUID fromString: '{656416ed-47db-44fd-a18d-124febcc1ddf}')!

Core.Tests.RunArrayTest comment: ''!

!Core.Tests.RunArrayTest methodsFor!

collectionClass
	^RunArray!

testReplaceFromToWithStartingAt
	self should: [super testReplaceFromToWithStartingAt] raise: Error!

testReplaceIdentityWith
	self should: [super testReplaceIdentityWith] raise: Error!

testResize
	self shouldnt: [super testResize] implement: #resize:!

testSortColon
	| subject |
	subject := self newCollection: #(3 1 2 4 1).
	self
		should: [subject sort]
		raise: Error
		matching: [:ex | ex messageText = 'RunArray should not implement #sortUsing:']! !

!Core.Tests.RunArrayTest categoriesForMethods!
collectionClass!helpers!private! !
testReplaceFromToWithStartingAt!public! !
testReplaceIdentityWith!public! !
testResize!public!unit tests! !
testSortColon!public!unit tests! !
!

