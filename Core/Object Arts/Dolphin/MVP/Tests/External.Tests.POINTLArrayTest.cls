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

canonicalizeValue: anObject
	^self elementFromIndex: anObject!

testSelfEvaluating
	| subject |
	subject := self newTestSubjectOfSize: 3.
	self assert: subject isSelfEvaluating.
	self assert: subject printString
		equals: '(<1p> withAll: {<2p>. <3p>. <4p>})'
				<< ({self arrayClass} , ((1 to: 3) collect: [:i | self elementFromIndex: i]))! !

!External.Tests.POINTLArrayTest categoriesForMethods!
canonicalizeValue:!private!unit tests! !
testSelfEvaluating!public!unit tests! !
!

!External.Tests.POINTLArrayTest class methodsFor!

arrayClass
	^POINTLArray!

elementFromIndex: anInteger
	^anInteger @ (anInteger - 1)! !

!External.Tests.POINTLArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!private!unit tests! !
!

