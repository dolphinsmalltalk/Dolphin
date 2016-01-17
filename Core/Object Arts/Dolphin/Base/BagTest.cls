"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #BagTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BagTest guid: (GUID fromString: '{31D1ECFC-CD30-4437-906F-69585C9E9C94}')!
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
			self assert: (copy includes: any)]!

testFailure
	self assert: false! !
!BagTest categoriesFor: #testDeepCopy!public! !
!BagTest categoriesFor: #testFailure!public! !

