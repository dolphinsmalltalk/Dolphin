"Filed out from Dolphin Smalltalk 7"!

GenericExternalArrayTest subclass: #StructureArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StructureArrayTest guid: (GUID fromString: '{1AB5E35E-9C82-4AA7-9C28-F51CB3BAA646}')!
StructureArrayTest comment: ''!
!StructureArrayTest categoriesForClass!Unclassified! !
!StructureArrayTest methodsFor!

arrayClass
	^StructureArray!

elementClass
	^SDWORD!

newArrayOfIntegers: anArray 
	^self arrayClass withAll: (anArray collect: [:each | self elementFromValue: each])
		elementClass: self elementClass! !
!StructureArrayTest categoriesFor: #arrayClass!constants!private! !
!StructureArrayTest categoriesFor: #elementClass!helpers!private! !
!StructureArrayTest categoriesFor: #newArrayOfIntegers:!helpers!private! !

