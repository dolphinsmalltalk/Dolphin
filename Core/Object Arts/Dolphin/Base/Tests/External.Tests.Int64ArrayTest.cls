"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.Int64ArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.Int64ArrayTest guid: (Core.GUID fromString: '{e785e960-3e61-4353-87d0-44ab79e57b71}')!

External.Tests.Int64ArrayTest comment: ''!

!External.Tests.Int64ArrayTest class methodsFor!

arrayClass
	^Int64Array!

elementFromIndex: anInteger
	^#(0 16r3FFFFFFF -16r40000000 16r40000000 16r7FFFFFFFFFFFFFFF -16r8000000000000000)
		at: anInteger! !

!External.Tests.Int64ArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

