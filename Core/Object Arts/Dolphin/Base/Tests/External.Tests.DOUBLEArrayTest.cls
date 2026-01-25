"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.DOUBLEArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.DOUBLEArrayTest guid: (Core.GUID fromString: '{d4fa7f6e-7be8-407b-a002-47d609d8d311}')!

External.Tests.DOUBLEArrayTest comment: ''!

!External.Tests.DOUBLEArrayTest class methodsFor!

arrayClass
	^DOUBLEArray!

elementFromIndex: anInteger
	^{ 0.0. 1.25. Float infinity. Float negativeInfinity. Float fmax. Float fmin } at: anInteger! !

!External.Tests.DOUBLEArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!private!unit tests! !
!

