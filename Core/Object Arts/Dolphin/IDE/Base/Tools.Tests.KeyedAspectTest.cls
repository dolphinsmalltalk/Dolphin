﻿"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Tools.Tests.KeyedAspectTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.KeyedAspectTest guid: (Core.GUID fromString: '{d76395c9-f61a-49dc-b5b1-87a2adf2020f}')!

Tools.Tests.KeyedAspectTest comment: ''!

!Tools.Tests.KeyedAspectTest methodsFor!

collectionKeyedAspectsTest: subject
	| aspects batchSize |
	batchSize := subject publishedKeyedAspectsBatchSize.
	aspects := subject publishedKeyedAspects.
	self assert: aspects size equals: batchSize + 1.
	0 to: 1
		do: 
			[:i |
			| nextBatch |
			1 to: batchSize
				do: 
					[:each |
					| aspect |
					aspect := aspects at: each.
					self assert: aspect name equals: aspect key.
					self assert: each + (i * batchSize) equals: aspect key.
					self assert: (aspect accessorFor: subject) value equals: (subject at: each + (i * batchSize))].
			nextBatch := aspects at: batchSize + 1.
			self assert: nextBatch isKindOf: KeyedAspectBatch.
			self assert: nextBatch key equals: batchSize * (i + 1) + 1.
			self assert: nextBatch keys asArray equals: subject keys asSortedCollection asArray.
			self assert: nextBatch batchSize equals: batchSize.
			"Expand out - should allow full expansion"
			aspects := (nextBatch accessorFor: subject) getBatchAccessors
						collect: [:each | each aspectDescriptor]].
	self assert: aspects size identicalTo: 1.
	self assert: (aspects first accessorFor: subject) value equals: (subject at: aspects first key)!

dictionaryKeyedAspectsTest: dictClass
	"Expand out - should allow full expansion"

	| subject batchSize |
	subject := dictClass new.
	batchSize := subject publishedKeyedAspectsBatchSize.
	1 to: batchSize * 2 + 1 do: [:i | subject at: i put: i printString].
	self collectionKeyedAspectsTest: subject!

sequenceableCollectionKeyedAspectsTest: seqCollClass
	"Expand out - should allow full expansion"

	| subject batchSize |
	subject := seqCollClass new.
	batchSize := subject publishedKeyedAspectsBatchSize.
	subject := seqCollClass withAll: (1 to: batchSize * 2 + 1).
	self collectionKeyedAspectsTest: subject!

testArrayPublishedKeyedAspects
	self sequenceableCollectionKeyedAspectsTest: Array!

testDictionaryPublishedKeyedAspects
	self dictionaryKeyedAspectsTest: Dictionary!

testLookupTablePublishedKeyedAspects
	self dictionaryKeyedAspectsTest: LookupTable!

testOrderedCollectionPublishedKeyedAspects
	self sequenceableCollectionKeyedAspectsTest: OrderedCollection!

testUInt32ArrayPublishedKeyedAspects
	self sequenceableCollectionKeyedAspectsTest: External.UInt32Array! !

!Tools.Tests.KeyedAspectTest categoriesForMethods!
collectionKeyedAspectsTest:!helpers!private! !
dictionaryKeyedAspectsTest:!helpers!private! !
sequenceableCollectionKeyedAspectsTest:!helpers!private! !
testArrayPublishedKeyedAspects!public!unit tests! !
testDictionaryPublishedKeyedAspects!public!unit tests! !
testLookupTablePublishedKeyedAspects!public!unit tests! !
testOrderedCollectionPublishedKeyedAspects!public!unit tests! !
testUInt32ArrayPublishedKeyedAspects!public!unit tests! !
!

