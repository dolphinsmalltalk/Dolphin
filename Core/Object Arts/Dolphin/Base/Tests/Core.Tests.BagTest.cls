"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.BagTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.BagTest guid: (Core.GUID fromString: '{31d1ecfc-cd30-4437-906f-69585c9e9c94}')!
Core.Tests.BagTest comment: ''!
!Core.Tests.BagTest categoriesForClass!Unclassified! !
!Core.Tests.BagTest methodsFor!

testDeepCopy
	| bag |
	bag := Bag with: Object new with: Object new.
	2 timesRepeat: 
			[| copy any |
			copy := bag deepCopy.
			any := copy detect: [:each | true].
			self assert: (copy includes: any)]! !
!Core.Tests.BagTest categoriesFor: #testDeepCopy!public! !

