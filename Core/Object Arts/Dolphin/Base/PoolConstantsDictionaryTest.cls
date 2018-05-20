"Filed out from Dolphin Smalltalk 7"!

AbstractDictionaryTest subclass: #PoolConstantsDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PoolConstantsDictionaryTest guid: (GUID fromString: '{9c4827fc-93b3-4424-bec2-99f6bd7d76e9}')!
PoolConstantsDictionaryTest comment: ''!
!PoolConstantsDictionaryTest categoriesForClass!Unclassified! !
!PoolConstantsDictionaryTest methodsFor!

collectionClass
	^PoolConstantsDictionary!

key3Value
	^$k!

makeKey: anObject
	^'_' , anObject displayString!

testAtIfAbsentString
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary at: 'key' ifAbsent: [2]) identicalTo: 1!

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
	self assert: (dictionary removeKey: 'key') identicalTo: 1.
	self should: [dictionary removeKey: 'key'] raise: NotFoundError! !
!PoolConstantsDictionaryTest categoriesFor: #collectionClass!helpers!private! !
!PoolConstantsDictionaryTest categoriesFor: #key3Value!private! !
!PoolConstantsDictionaryTest categoriesFor: #makeKey:!helpers!private! !
!PoolConstantsDictionaryTest categoriesFor: #testAtIfAbsentString!public!unit tests! !
!PoolConstantsDictionaryTest categoriesFor: #testIncludesKey!public!unit tests! !
!PoolConstantsDictionaryTest categoriesFor: #testRemoveKeyString!public!unit tests! !

