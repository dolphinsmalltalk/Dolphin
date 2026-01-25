"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.UInt32ArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.UInt32ArrayTest guid: (Core.GUID fromString: '{4cf3a550-fd9e-46c2-a81b-367815cdf70d}')!

External.Tests.UInt32ArrayTest comment: ''!

!External.Tests.UInt32ArrayTest class methodsFor!

arrayClass
	^UInt32Array!

elementFromIndex: anInteger
	^#(0 16r3FFFFFFF 16r40000000 16r7FFFFFFF 16rFFFFFFFF 1) at: anInteger! !

!External.Tests.UInt32ArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

