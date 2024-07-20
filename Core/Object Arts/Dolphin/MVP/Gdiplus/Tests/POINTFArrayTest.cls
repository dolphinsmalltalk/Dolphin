"Filed out from Dolphin Smalltalk"!

ExternalArrayTest subclass: #POINTFArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

POINTFArrayTest guid: (GUID fromString: '{49f29acd-c127-4bd7-9a1a-d2f5acc1608a}')!

POINTFArrayTest comment: ''!

!POINTFArrayTest categoriesForClass!Unclassified! !

!POINTFArrayTest methodsFor!

arrayClass
	^POINTFArray!

canonicalizeValue: anObject
	^self elementFromValue: anObject!

elementFromValue: anObject
	^anObject asFloat @ (anObject + 1) asFloat!

newArrayOfIntegers: anArray
	^self arrayClass withAll: (anArray collect: [:each | each @ (each + 1)])!

numericElementClass
	^POINTF

! !

!POINTFArrayTest categoriesForMethods!
arrayClass!constants!private! !
canonicalizeValue:!private!unit tests! !
elementFromValue:!private!unit tests! !
newArrayOfIntegers:!helpers!private! !
numericElementClass!constants!private! !
!

