"Filed out from Dolphin Smalltalk 7"!

External.Tests.GenericExternalArrayTest subclass: #'External.Tests.StructureArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.StructureArrayTest guid: (Core.GUID fromString: '{1ab5e35e-9c82-4aa7-9c28-f51cb3baa646}')!
External.Tests.StructureArrayTest comment: ''!
!External.Tests.StructureArrayTest categoriesForClass!Unclassified! !
!External.Tests.StructureArrayTest methodsFor!

arrayClass
	^StructureArray!

newArrayOfIntegers: anArray
	^self arrayClass withAll: (anArray collect: [:each | self elementFromValue: each])
		elementClass: self numericElementClass! !
!External.Tests.StructureArrayTest categoriesFor: #arrayClass!constants!private! !
!External.Tests.StructureArrayTest categoriesFor: #newArrayOfIntegers:!helpers!private! !

