"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.Int16ArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.Int16ArrayTest guid: (Core.GUID fromString: '{899ffc53-86db-45b3-ae91-d517e2148fcb}')!

External.Tests.Int16ArrayTest comment: ''!

!External.Tests.Int16ArrayTest class methodsFor!

arrayClass
	^Int16Array!

elementFromIndex: anInteger
	^##({ 0. 1. Int16.MinValue. Int16.MinValue + 1. Int16.MaxValue. -1 }) at: anInteger! !

!External.Tests.Int16ArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

