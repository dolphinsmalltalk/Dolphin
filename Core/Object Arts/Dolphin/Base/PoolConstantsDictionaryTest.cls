"Filed out from Dolphin Smalltalk"!

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
	^$l!

makeKey: anObject
	^'_' , anObject displayString!

testAddExisting
	| dictionary |
	dictionary := self newDictionary.
	dictionary add: #a -> 1.
	[dictionary add: #a -> 2] on: ConfirmationRequiredWarning do: [:ex | ex confirm].
	self assert: (dictionary at: #a) equals: 2!

testAtIfAbsentString
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary at: 'key' ifAbsent: [2]) identicalTo: 1!

testAtPutExisting
	| dictionary |
	dictionary := self newDictionary.
	dictionary at: #a put: 1.
	[dictionary at: #a put: 2] on: ConfirmationRequiredWarning do: [:ex | ex confirm].
	self assert: (dictionary at: #a) equals: 2!

testChangeConstant
	!

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
!PoolConstantsDictionaryTest categoriesForMethods!
collectionClass!helpers!private! !
key3Value!private! !
makeKey:!helpers!private! !
testAddExisting!public!unit tests! !
testAtIfAbsentString!public!unit tests! !
testAtPutExisting!public!unit tests! !
testChangeConstant!public!unit tests! !
testIncludesKey!public!unit tests! !
testRemoveKeyString!public!unit tests! !
!

