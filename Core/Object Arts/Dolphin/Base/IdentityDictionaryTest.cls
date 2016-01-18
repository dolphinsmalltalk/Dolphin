"Filed out from Dolphin Smalltalk 7"!

LookupTableTest subclass: #IdentityDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdentityDictionaryTest guid: (GUID fromString: '{89184496-00FE-46A7-A9D7-2E531F4B088C}')!
IdentityDictionaryTest comment: ''!
!IdentityDictionaryTest categoriesForClass!Unclassified! !
!IdentityDictionaryTest methodsFor!

collectionClass
	^IdentityDictionary!

testAtIfAbsentPutModifyingCollection
	"Test at:ifAbsentPut: when modifying the collection in the block"

	| dictionary test keys |
	dictionary := self newEmpty.
	"First test keys that collide: For this test to work they must collide, so verify that. This
	will break if the new collection capacity is not 3"
	self assert: (dictionary findKeyOrNil: 1) == (dictionary findKeyOrNil: 4).
	dictionary at: 1
		ifAbsentPut: 
			[dictionary at: 4 put: 4.
			1].
	"self assert: dictionary size = 2.
	self assert: (dictionary at: 4) == 4.
	self assert: (dictionary at: 1) == 1."
	"Another test, this time attempting to create duplicate key entries"
	dictionary := self newEmpty.
	"This one will only work if the keys collide and the collection grows"
	self assert: (dictionary basicSize == 3 
				and: [(dictionary findKeyOrNil: 10) == (dictionary findKeyOrNil: 1)]).
	test := dictionary.
	test at: 10
		ifAbsentPut: 
			[test
				at: 0 put: 0;
				at: 1 put: 1;
				at: 10 put: 10].
	keys := OrderedCollection new.
	test keysDo: [:each | keys addLast: each].
	self assert: keys asSortedCollection asArray = #(0 1 10)! !
!IdentityDictionaryTest categoriesFor: #collectionClass!helpers!private! !
!IdentityDictionaryTest categoriesFor: #testAtIfAbsentPutModifyingCollection!public!unit tests! !

