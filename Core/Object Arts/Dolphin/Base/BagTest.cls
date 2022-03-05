"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #BagTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BagTest guid: (GUID fromString: '{31d1ecfc-cd30-4437-906f-69585c9e9c94}')!
BagTest comment: ''!
!BagTest categoriesForClass!Unclassified! !
!BagTest methodsFor!

testDeepCopy
	| bag |
	bag := Bag with: Object new with: Object new.
	2 timesRepeat: 
			[| copy any |
			copy := bag deepCopy.
			any := copy detect: [:each | true].
			self assert: (copy includes: any)]! !
!BagTest categoriesForMethods!
testDeepCopy!public! !
!

