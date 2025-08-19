"Filed out from Dolphin Smalltalk"!

Graphics.Tests.AbstractPointTest
	subclass: #'Graphics.Tests.PointTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.PointTest guid: (Core.GUID fromString: '{98f92001-3f3a-4296-8a76-5e67f93030a6}')!

Graphics.Tests.PointTest comment: ''!

!Graphics.Tests.PointTest methodsFor!

subjectClass
	^Point!

subjectSupportNonIntegralValues
	^true!

testAbs
	self assert: (self subjectClass x: 0 y: 0) abs equals: (self subjectClass x: 0 y: 0).
	self assert: (self subjectClass x: 1 y: 1) abs equals: (self subjectClass x: 1 y: 1).
	self assert: (self subjectClass x: -1 y: 1) abs equals: (self subjectClass x: 1 y: 1).
	self assert: (self subjectClass x: 1 y: -1) abs equals: (self subjectClass x: 1 y: 1).
	self assert: (self subjectClass x: -1 y: -1) abs equals: (self subjectClass x: 1 y: 1)!

testAsUInt32OutOfRange
	| subject uint |
	subject := self subjectClass x: 16r10001 y: 16r10002.
	uint := subject asUInt32.
	self assert: uint equals: 16r00020001!

testAsUIntPtr
	| result |
	result := ((17 / 4) @ (11 / 4)) asUIntPtr.
	self assert: result >> VMConstants.HalfPtrBits equals: 3.
	self assert: (result bitAnd: VMConstants.HalfPtrMask) equals: 4!

testCloseToPrecision
	self assert: (125@-125 closeTo: 126@-126 precision: 1).
	self assert: (125@-125 closeTo: 124@-124 precision: 1).
	self deny: (125@-125 closeTo: -126@126 precision: 1).
	self deny: (125@-125 closeTo: 127@-125 precision: 1).
	self deny: (125@-125 closeTo: 125@-123 precision: 1)!

testDivideLarge
	| largeNeg largePos subject |
	largeNeg := SmallInteger minimum - 1.
	largePos := SmallInteger maximum + 1.
	subject := self subjectClass x: largeNeg y: largePos.
	self assert: subject / largeNeg equals: 1 @ (largePos / largeNeg)!

testEquals
	self assert: (self subjectClass x: 0 y: 0) equals: 0.
	self assert: 0 equals: (self subjectClass x: 0 y: 0).
	self assert: (self subjectClass x: 1 y: 1) equals: (self subjectClass x: 1 y: 1).
	self deny: (self subjectClass x: 1 y: 2) equals: (self subjectClass x: 2 y: 1).
	self deny: (self subjectClass x: 1 y: 2) equals: 1.5!

testStrictlyPositive
	self deny: (self subjectClass x: 0 y: 0) strictlyPositive.
	self deny: (self subjectClass x: 0 y: 1) strictlyPositive.
	self deny: (self subjectClass x: 1 y: 0) strictlyPositive.
	self assert: (self subjectClass x: 1 y: 1) strictlyPositive.
	self deny: (self subjectClass x: 1 y: -1) strictlyPositive.
	self deny: (self subjectClass x: -1 y: 1) strictlyPositive! !

!Graphics.Tests.PointTest categoriesForMethods!
subjectClass!constants!private! !
subjectSupportNonIntegralValues!private!testing! !
testAbs!public!unit tests! !
testAsUInt32OutOfRange!public!unit tests! !
testAsUIntPtr!public! !
testCloseToPrecision!public!unit tests! !
testDivideLarge!public! !
testEquals!public!unit tests! !
testStrictlyPositive!public!unit tests! !
!

