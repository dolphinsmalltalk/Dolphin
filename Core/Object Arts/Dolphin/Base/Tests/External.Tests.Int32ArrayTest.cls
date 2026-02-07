"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.Int32ArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.Int32ArrayTest guid: (Core.GUID fromString: '{732f3b46-f2d5-412c-b35d-6cbc5adfba95}')!

External.Tests.Int32ArrayTest comment: ''!

!External.Tests.Int32ArrayTest class methodsFor!

arrayClass
	^Int32Array!

elementFromIndex: anInteger
	^##({0. SmallInteger maximum. Int32.MinValue. SmallInteger minimum. Int32.MaxValue. SmallInteger maximum +1}) at: anInteger! !

!External.Tests.Int32ArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

