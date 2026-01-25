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
	^#(0 16r3FFFFFFF -16r80000000 -16r40000000 16r7FFFFFFF 16r40000000) at: anInteger! !

!External.Tests.Int32ArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

