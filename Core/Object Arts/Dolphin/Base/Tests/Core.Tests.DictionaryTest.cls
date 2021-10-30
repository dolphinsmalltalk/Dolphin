"Filed out from Dolphin Smalltalk"!

Core.Tests.AbstractDictionaryTest subclass: #'Core.Tests.DictionaryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DictionaryTest guid: (Core.GUID fromString: '{733b8918-1913-46df-995e-67541bd596aa}')!
Core.Tests.DictionaryTest comment: ''!
!Core.Tests.DictionaryTest categoriesForClass!Unclassified! !
!Core.Tests.DictionaryTest methodsFor!

collectionClass
	^Dictionary!

testAllInstancesValid
	| invalid |
	invalid := IdentitySet new.
	self collectionClass allInstances
		do: [:each | each keysDo: [:key | (each includesKey: key) ifFalse: [invalid add: each]]].
	self assert: invalid isEmpty!

testAtIfAbsentPutClean
	| dictionary initialSize f |
	super testAtIfAbsentPutClean.
	dictionary := self newEmpty.
	initialSize := dictionary size.
	"Verify equal but not identical keys"
	f := [2.0].
	self assert: f value hash equals: 2 hash.
	self assert: f value equals: 2.
	self assert: (dictionary at: 2 ifAbsentPutClean: f) identicalTo: f value.
	self assert: dictionary size identicalTo: initialSize + 1.
	self assert: (dictionary at: f value ifAbsentPutClean: [2]) identicalTo: f value.
	self assert: dictionary size identicalTo: initialSize + 1!

testAtIfAbsentPutValue
	| dictionary initialSize f |
	super testAtIfAbsentPutValue.
	dictionary := self newEmpty.
	initialSize := dictionary size.
	"Verify equal but not identical keys"
	f := 2.0.
	self assert: f hash equals: 2 hash.
	self assert: f equals: 2.
	self assert: (dictionary at: 2 ifAbsentPutValue: f) identicalTo: f.
	self assert: dictionary size identicalTo: initialSize + 1.
	self assert: (dictionary at: f ifAbsentPutValue: 2) identicalTo: f.
	self assert: dictionary size identicalTo: initialSize + 1! !
!Core.Tests.DictionaryTest categoriesForMethods!
collectionClass!helpers!private! !
testAllInstancesValid!public!unit tests! !
testAtIfAbsentPutClean!public!unit tests! !
testAtIfAbsentPutValue!public!unit tests! !
!

