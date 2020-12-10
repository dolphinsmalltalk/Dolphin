"Filed out from Dolphin Smalltalk 7"!

GenericExternalArrayTest subclass: #StructureArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StructureArrayTest guid: (GUID fromString: '{1ab5e35e-9c82-4aa7-9c28-f51cb3baa646}')!
StructureArrayTest comment: ''!
!StructureArrayTest categoriesForClass!Unclassified! !
!StructureArrayTest methodsFor!

arrayClass
	^StructureArray!

newArrayOfIntegers: anArray
	^self arrayClass withAll: (anArray collect: [:each | self elementFromValue: each])
		elementClass: self numericElementClass! !
!StructureArrayTest categoriesFor: #arrayClass!constants!private! !
!StructureArrayTest categoriesFor: #newArrayOfIntegers:!helpers!private! !

