"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.PairTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.PairTest guid: (Core.GUID fromString: '{752723a5-58e1-45a4-ba7e-10c92064d896}')!

Core.Tests.PairTest comment: ''!

!Core.Tests.PairTest methodsFor!

testEquals
	| pair1 pair2 |
	pair1 := Pair first: 'a' second: 'b'.
	pair2 := Pair first: #a second: #b.
	self assert: pair1 equals: pair1.
	self assert: pair2 equals: pair2.
	self assert: pair1 equals: pair2.
	self assert: pair2 equals: pair1.
	self deny: pair1 equals: Pair new.
	self deny: pair1 equals: 1.
	self deny: pair1 equals: 'a'.
!

testHash
	| pair1 pair2 |
	pair1 := Pair first: 'a' second: 'b'.
	pair2 := Pair first: #a second: #b.
	self assert: pair1 hash equals: pair2 hash.
	self deny: pair1 hash equals: Pair new hash! !

!Core.Tests.PairTest categoriesForMethods!
testEquals!public! !
testHash!public! !
!

