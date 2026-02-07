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
	^##({
		0.
		SmallInteger maximum.
		SmallInteger maximum + 1.
		Int32.MaxValue.
		Int32.MaxValue + 1.
		UInt32.MaxValue
	}) at: anInteger! !

!External.Tests.UInt32ArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

