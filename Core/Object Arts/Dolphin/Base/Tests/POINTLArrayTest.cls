"Filed out from Dolphin Smalltalk"!

ExternalArrayTest subclass: #POINTLArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

POINTLArrayTest guid: (GUID fromString: '{344f62c4-515b-4ff7-bc73-3bd0fab5d313}')!

POINTLArrayTest comment: ''!

!POINTLArrayTest categoriesForClass!Unclassified! !

!POINTLArrayTest methodsFor!

arrayClass
	^POINTLArray!

canonicalizeValue: anObject
	^self elementFromValue: anObject!

elementFromValue: anObject
	^anObject @ (anObject + 1)!

newArrayOfIntegers: anArray
	^self arrayClass withAll: (anArray collect: [:each | self elementFromValue: each])!

numericElementClass
	^POINTL

! !

!POINTLArrayTest categoriesForMethods!
arrayClass!constants!public! !
canonicalizeValue:!helpers!private! !
elementFromValue:!helpers!private! !
newArrayOfIntegers:!helpers!private! !
numericElementClass!helpers!private! !
!

