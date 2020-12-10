"Filed out from Dolphin Smalltalk 7"!

AbstractPointTest subclass: #PointTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PointTest guid: (GUID fromString: '{98f92001-3f3a-4296-8a76-5e67f93030a6}')!
PointTest comment: 'This is the unit test for the class Point. Unit tests are a good way to exercise the functionality of your system in a repeatable and automatic manner. They are therefore recommended if you plan to release anything. For more information, see: 
	- http://www.c2.com/cgi/wiki?UnitTest
	- http://minnow.cc.gatech.edu/squeak/1547
	- the sunit class category'!
!PointTest categoriesForClass!Unclassified! !
!PointTest methodsFor!

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
!PointTest categoriesFor: #subjectClass!constants!private! !
!PointTest categoriesFor: #testAbs!public!unit tests! !
!PointTest categoriesFor: #testEquals!public!unit tests! !
!PointTest categoriesFor: #testIsZero!public!unit tests! !
!PointTest categoriesFor: #testStrictlyPositive!public!unit tests! !

