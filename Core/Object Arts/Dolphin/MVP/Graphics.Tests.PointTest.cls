"Filed out from Dolphin Smalltalk"!

Graphics.Tests.AbstractPointTest subclass: #'Graphics.Tests.PointTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.PointTest guid: (Core.GUID fromString: '{98f92001-3f3a-4296-8a76-5e67f93030a6}')!
Graphics.Tests.PointTest comment: ''!
!Graphics.Tests.PointTest categoriesForClass!Unclassified! !
!Graphics.Tests.PointTest methodsFor!

subjectClass
	^Point!

testAbs
	self assert: (self subjectClass x: 0 y: 0) abs equals: (self subjectClass x: 0 y: 0).
	self assert: (self subjectClass x: 1 y: 1) abs equals: (self subjectClass x: 1 y: 1).
	self assert: (self subjectClass x: -1 y: 1) abs equals: (self subjectClass x: 1 y: 1).
	self assert: (self subjectClass x: 1 y: -1) abs equals: (self subjectClass x: 1 y: 1).
	self assert: (self subjectClass x: -1 y: -1) abs equals: (self subjectClass x: 1 y: 1)!

testEquals
	self assert: (self subjectClass x: 0 y: 0) equals: 0.
	self assert: 0 equals: (self subjectClass x: 0 y: 0).
	self assert: (self subjectClass x: 1 y: 1) equals: (self subjectClass x: 1 y: 1).
	self deny: (self subjectClass x: 1 y: 2) equals: (self subjectClass x: 2 y: 1).
	self deny: (self subjectClass x: 1 y: 2) equals: 1.5!

testIsZero
	self assert: (self subjectClass x: 0 y: 0) isZero.
	self deny: (self subjectClass x: 0 y: 1) isZero.
	self deny: (self subjectClass x: 1 y: 0) isZero.
	self deny: (self subjectClass x: 1 y: 1) isZero!

testStrictlyPositive
	self deny: (self subjectClass x: 0 y: 0) strictlyPositive.
	self deny: (self subjectClass x: 0 y: 1) strictlyPositive.
	self deny: (self subjectClass x: 1 y: 0) strictlyPositive.
	self assert: (self subjectClass x: 1 y: 1) strictlyPositive.
	self deny: (self subjectClass x: 1 y: -1) strictlyPositive.
	self deny: (self subjectClass x: -1 y: 1) strictlyPositive! !
!Graphics.Tests.PointTest categoriesForMethods!
subjectClass!constants!private! !
testAbs!public!unit tests! !
testEquals!public!unit tests! !
testIsZero!public!unit tests! !
testStrictlyPositive!public!unit tests! !
!

