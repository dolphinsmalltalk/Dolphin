"Filed out from Dolphin Smalltalk"!

OrderedCollectionTest subclass: #SortedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SortedCollectionTest guid: (GUID fromString: '{5ae7c3bc-62c7-454a-9917-c6accd854be1}')!

SortedCollectionTest comment: ''!

!SortedCollectionTest categoriesForClass!Unclassified! !

!SortedCollectionTest methodsFor!

collectionClass
	^SortedCollection!

testAddAllFirst
	self shouldnt: [super testAddAllFirst] implement: #addAllFirst:!

testAddAllFirst2
	^self shouldnt: [super testAddAllFirst2] implement: #addAllFirst:!

testAddAllLast
	self shouldnt: [super testAddAllLast] implement: #addAllLast:!

testAddFirst
	self shouldnt: [super testAddFirst] implement: #addFirst:!

testBinaryIncludes
	| searchee |
	searchee := self newCollection: 'abc'.
	self assert: (searchee binaryIncludes:  (self assimilate: $a)).
	self assert: (searchee binaryIncludes: (self assimilate: $b)).
	self assert: (searchee binaryIncludes: (self assimilate: $c)).
	self deny: (searchee binaryIncludes: (self assimilate: $A)).
	self deny: (searchee binaryIncludes: (self assimilate: $d)).
	self should: [searchee binaryIncludes: Object new] raise: MessageNotUnderstood!

testCopyReplaceAllWith
	self shouldnt: [super testCopyReplaceAllWith] implement: #replaceFrom:to:with:startingAt:!

testCopyWithAtIndex
	self shouldnt: [super testCopyWithAtIndex] implement: #replaceFrom:to:with:startingAt:!

testReplaceFromToWithStartingAt
	self shouldnt: [super testReplaceFromToWithStartingAt] implement: #replaceFrom:to:with:startingAt:!

testResize
	| subject actual |
	subject := self newCollection: #().
	actual := subject resize: 0.
	self assert: actual identicalTo: subject.
	self assert: actual equals: (self newCollection: #()).
	subject := self newCollection: #($c $a $b).
	actual := subject resize: 2.
	self assert: actual identicalTo: subject.
	self assert: actual equals: (self newCollection: #($a $b)).
	self should: [subject resize: 3] raise: Error!

testStrongTalkTests
!

unsortedCollectionClass
	^OrderedCollection!

verifyConcatenation: b with: a
	| result |
	result := a , b.
	(a isKindOf: SortedCollection)
		ifTrue: [self assert: ((a symmetricDifference: result) noDifference: b)]
		ifFalse: [super verifyConcatenation: b with: a].
	^result! !

!SortedCollectionTest categoriesForMethods!
collectionClass!constants!private! !
testAddAllFirst!public!unit tests! !
testAddAllFirst2!public!unit tests! !
testAddAllLast!public!unit tests! !
testAddFirst!public!unit tests! !
testBinaryIncludes!public!unit tests! !
testCopyReplaceAllWith!public!unit tests! !
testCopyWithAtIndex!public!unit tests! !
testReplaceFromToWithStartingAt!public!unit tests! !
testResize!public!unit tests! !
testStrongTalkTests!public!unit tests! !
unsortedCollectionClass!constants!private! !
verifyConcatenation:with:!public!unit tests! !
!

