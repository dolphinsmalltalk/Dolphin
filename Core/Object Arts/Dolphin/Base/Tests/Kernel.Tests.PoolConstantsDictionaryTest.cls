"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.PoolConstantsDictionaryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.PoolConstantsDictionaryTest guid: (Core.GUID fromString: '{9c4827fc-93b3-4424-bec2-99f6bd7d76e9}')!
Kernel.Tests.PoolConstantsDictionaryTest comment: ''!
!Kernel.Tests.PoolConstantsDictionaryTest methodsFor!

key3Value
	^$l!

newDictionary
	| subject |
	"We are no longer using PoolConstantsDictionary, but retain the test unchanged to verify that the behaviour of SharedPool classes is compatible."
	subject := self newEmpty.
	subject at: #key put: 1.
	^subject!

newEmpty
	"We are no longer using PoolConstantsDictionary, but retain the test unchanged to verify that the behaviour of SharedPool classes is compatible."

	^SharedPool newAnonymousSubclass!

testAtIfAbsentString
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary at: 'key' ifAbsent: 2) identicalTo: 1!

testIncludesKey
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary includesKey: #key).
	self assert: (dictionary includesKey: 'key').
	self deny: (dictionary includesKey: #value)!

testRemoveKeyString
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary removeKey: 'key') identicalTo: 1.
	self should: [dictionary removeKey: 'key'] raise: NotFoundError! !
!Kernel.Tests.PoolConstantsDictionaryTest categoriesForMethods!
key3Value!private! !
newDictionary!private!unit tests! !
newEmpty!private!unit tests! !
testAtIfAbsentString!public!unit tests! !
testIncludesKey!public!unit tests! !
testRemoveKeyString!public!unit tests! !
!

