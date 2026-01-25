"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.UInt16ArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.UInt16ArrayTest guid: (Core.GUID fromString: '{2744b3a0-35d0-4955-946c-600ebfdbc06f}')!

External.Tests.UInt16ArrayTest comment: ''!

!External.Tests.UInt16ArrayTest class methodsFor!

arrayClass
	^UInt16Array!

elementFromIndex: anInteger
	^#(0 32767 32768 65535 1 2) at: anInteger! !

!External.Tests.UInt16ArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

