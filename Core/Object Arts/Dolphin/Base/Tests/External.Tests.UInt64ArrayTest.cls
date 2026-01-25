"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.UInt64ArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.UInt64ArrayTest guid: (Core.GUID fromString: '{c5df4cce-dd53-41d1-84e2-004c9ada7163}')!

External.Tests.UInt64ArrayTest comment: ''!

!External.Tests.UInt64ArrayTest class methodsFor!

arrayClass
	^UInt64Array!

elementFromIndex: anInteger
	^#(0 16r3FFFFFFF 16r80000000 16r7FFFFFFFFFFFFFFF 16r8000000000000000 16rFFFFFFFFFFFFFFFF)
		at: anInteger! !

!External.Tests.UInt64ArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

