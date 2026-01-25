"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.UInt8ArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.UInt8ArrayTest guid: (Core.GUID fromString: '{a04998d8-28b3-46e0-b1bb-b173b8af04a0}')!

External.Tests.UInt8ArrayTest comment: ''!

!External.Tests.UInt8ArrayTest class methodsFor!

arrayClass
	^UInt8Array!

elementFromIndex: anInteger
	^#(0 127 128 255 1 2) at: anInteger! !

!External.Tests.UInt8ArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

