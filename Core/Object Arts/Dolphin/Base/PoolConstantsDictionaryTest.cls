"Filed out from Dolphin Smalltalk 7"!

AbstractDictionaryTest subclass: #PoolConstantsDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PoolConstantsDictionaryTest guid: (GUID fromString: '{9C4827FC-93B3-4424-BEC2-99F6BD7D76E9}')!
PoolConstantsDictionaryTest comment: ''!
!PoolConstantsDictionaryTest categoriesForClass!Unclassified! !
!PoolConstantsDictionaryTest methodsFor!

collectionClass
	^PoolConstantsDictionary!

makeKey: anObject
	^anObject displayString!

testAtIfAbsentString
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary at: 'key' ifAbsent: [2]) == 1!

testIncludesKey
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary includesKey: #key).
	self assert: (dictionary includesKey: 'key').
	self deny: (dictionary includesKey: #value)

!

testRemoveKeyString
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary removeKey: 'key') == 1.
	self should: [dictionary removeKey: 'key'] raise: NotFoundError! !
!PoolConstantsDictionaryTest categoriesFor: #collectionClass!helpers!private! !
!PoolConstantsDictionaryTest categoriesFor: #makeKey:!helpers!private! !
!PoolConstantsDictionaryTest categoriesFor: #testAtIfAbsentString!public!unit tests! !
!PoolConstantsDictionaryTest categoriesFor: #testIncludesKey!public!unit tests! !
!PoolConstantsDictionaryTest categoriesFor: #testRemoveKeyString!public!unit tests! !

