"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'OS.Tests.POINTSArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.POINTSArrayTest guid: (Core.GUID fromString: '{2bbffd72-c82d-4cc5-9067-010c5e683b96}')!

OS.Tests.POINTSArrayTest comment: ''!

!OS.Tests.POINTSArrayTest methodsFor!

canonicalizeValue: anObject
	^self elementFromIndex: anObject! !

!OS.Tests.POINTSArrayTest categoriesForMethods!
canonicalizeValue:!private!unit tests! !
!

!OS.Tests.POINTSArrayTest class methodsFor!

arrayClass
	^POINTSArray!

elementFromIndex: anInteger
	^anInteger @ (anInteger - 1)! !

!OS.Tests.POINTSArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!private!unit tests! !
!

