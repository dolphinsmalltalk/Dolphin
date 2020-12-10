"Filed out from Dolphin Smalltalk 7"!

AbstractDictionaryTest subclass: #DictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DictionaryTest guid: (GUID fromString: '{733b8918-1913-46df-995e-67541bd596aa}')!
DictionaryTest comment: ''!
!DictionaryTest categoriesForClass!Unclassified! !
!DictionaryTest methodsFor!

collectionClass
	^Dictionary!

testAllInstancesValid
	| invalid |
	invalid := IdentitySet new.
	self collectionClass allSubinstances
		do: [:each | each keysDo: [:key | (each includesKey: key) ifFalse: [invalid add: each]]].
	self assert: invalid isEmpty!

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
!DictionaryTest categoriesFor: #collectionClass!helpers!private! !
!DictionaryTest categoriesFor: #testAllInstancesValid!public!unit tests! !
!DictionaryTest categoriesFor: #testAtIfAbsentPutValue!public!unit tests! !

