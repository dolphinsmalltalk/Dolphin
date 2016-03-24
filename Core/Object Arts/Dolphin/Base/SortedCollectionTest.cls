"Filed out from Dolphin Smalltalk 7"!

OrderedCollectionTest subclass: #SortedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SortedCollectionTest guid: (GUID fromString: '{5AE7C3BC-62C7-454A-9917-C6ACCD854BE1}')!
SortedCollectionTest comment: ''!
!SortedCollectionTest categoriesForClass!Unclassified! !
!SortedCollectionTest methodsFor!

collectionClass
	^SortedCollection!

shouldnt: aNiladicBlock implement: aSymbol 
	self 
		should: aNiladicBlock
		raise: Error
		matching: 
			[:ex | 
			ex description 
				= ('<1p> should not implement <2p>' expandMacrosWith: self collectionClass with: aSymbol)]!

testAddAllFirst
	self shouldnt: [super testAddAllFirst] implement: #addAllFirst:!

testAddAllFirst2
	^self shouldnt: [super testAddAllFirst2] implement: #addAllFirst:!

testAddAllLast
	self shouldnt: [super testAddAllLast] implement: #addAllLast:!

testBinaryIncludes
	| searchee |
	searchee := self newCollection: 'abc'.
	self assert: (searchee binaryIncludes:  (self assimilate: $a)).
	self assert: (searchee binaryIncludes: (self assimilate: $b)).
	self assert: (searchee binaryIncludes: (self assimilate: $c)).
	self deny: (searchee binaryIncludes: (self assimilate: $A)).
	self deny: (searchee binaryIncludes: (self assimilate: $d)).
	self should: [searchee binaryIncludes: Object new] raise: MessageNotUnderstood!

testReplaceFromToWithStartingAt
	self shouldnt: [super testReplaceFromToWithStartingAt] implement: #replaceFrom:to:with:startingAt:!

testStrongTalkTests
!

unsortedCollectionClass
	^OrderedCollection! !
!SortedCollectionTest categoriesFor: #collectionClass!constants!private! !
!SortedCollectionTest categoriesFor: #shouldnt:implement:!private!unit tests! !
!SortedCollectionTest categoriesFor: #testAddAllFirst!public!unit tests! !
!SortedCollectionTest categoriesFor: #testAddAllFirst2!public!unit tests! !
!SortedCollectionTest categoriesFor: #testAddAllLast!public!unit tests! !
!SortedCollectionTest categoriesFor: #testBinaryIncludes!public!unit tests! !
!SortedCollectionTest categoriesFor: #testReplaceFromToWithStartingAt!public!unit tests! !
!SortedCollectionTest categoriesFor: #testStrongTalkTests!public!unit tests! !
!SortedCollectionTest categoriesFor: #unsortedCollectionClass!public!unit tests! !

