"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.POINTLArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.POINTLArrayTest guid: (Core.GUID fromString: '{2bbffd72-c82d-4cc5-9067-010c5e683b96}')!
External.Tests.POINTLArrayTest comment: ''!
!External.Tests.POINTLArrayTest methodsFor!

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

!

testSelfEvaluating
	| subject |
	subject := self newNumericArray: 3.
	self assert: subject isSelfEvaluating.
	self assert: subject printString
		equals: '(<1p> withAll: {<2p>. <3p>. <4p>})'
				<< ({self arrayClass} , ((1 to: 3) collect: [:i | self elementFromValue: i]))! !
!External.Tests.POINTLArrayTest categoriesForMethods!
arrayClass!constants!private! !
canonicalizeValue:!private!unit tests! !
elementFromValue:!private!unit tests! !
newArrayOfIntegers:!helpers!private! !
numericElementClass!constants!private! !
testSelfEvaluating!public!unit tests! !
!

