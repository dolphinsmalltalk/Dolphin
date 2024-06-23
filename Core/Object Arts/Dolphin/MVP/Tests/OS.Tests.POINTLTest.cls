"Filed out from Dolphin Smalltalk"!

External.Tests.POINTTest
	subclass: #'OS.Tests.POINTLTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.POINTLTest guid: (Core.GUID fromString: '{10c5c3a8-def8-4e74-a3d7-1bb3783e1c3e}')!

OS.Tests.POINTLTest comment: ''!

!OS.Tests.POINTLTest methodsFor!

subjectClass
	^POINTL!

testAsUInt32OutOfRange
	| subject uint |
	subject := self subjectClass x: 16r10001 y: 16r10002.
	uint := subject asUInt32.
	self assert: uint equals: 16r00020001!

testDivideLarge
	| largeNeg largePos subject |
	largeNeg := SmallInteger minimum - 1.
	largePos := SmallInteger maximum + 1.
	subject := self subjectClass x: largeNeg y: largePos.
	self assert: subject / largeNeg equals: 1 @ (largePos / largeNeg)! !

!OS.Tests.POINTLTest categoriesForMethods!
subjectClass!constants!private! !
testAsUInt32OutOfRange!public!unit tests! !
testDivideLarge!public! !
!

