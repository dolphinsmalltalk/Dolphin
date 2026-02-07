"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.Int8ArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.Int8ArrayTest guid: (Core.GUID fromString: '{d8be7b81-23ce-4e26-b017-be7aff0de660}')!

External.Tests.Int8ArrayTest comment: ''!

!External.Tests.Int8ArrayTest class methodsFor!

arrayClass
	^Int8Array!

elementFromIndex: anInteger
	^##({ 0. 1. Int8.MinValue. Int8.MinValue + 1. Int8.MaxValue. -1 }) at: anInteger! !

!External.Tests.Int8ArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

