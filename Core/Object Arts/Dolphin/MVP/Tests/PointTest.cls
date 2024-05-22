"Filed out from Dolphin Smalltalk"!

AbstractPointTest subclass: #PointTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PointTest guid: (GUID fromString: '{98f92001-3f3a-4296-8a76-5e67f93030a6}')!

PointTest comment: 'This is the unit test for the class Point. Unit tests are a good way to exercise the functionality of your system in a repeatable and automatic manner. They are therefore recommended if you plan to release anything. For more information, see: 
	- http://www.c2.com/cgi/wiki?UnitTest
	- http://minnow.cc.gatech.edu/squeak/1547
	- the sunit class category'!

!PointTest categoriesForClass!Unclassified! !

!PointTest methodsFor!

subjectClass
	^Point!

subjectSupportNonIntegralValues
	^true!

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
	self deny: (125@-125 closeTo: 125@-123 precision: 1).!

testDivideLarge
	| largeNeg largePos subject |
	largeNeg := SmallInteger minimum - 1.
	largePos := SmallInteger maximum + 1.
	subject := self subjectClass x: largeNeg y: largePos.
	self assert: subject / largeNeg equals: 1 @ (largePos / largeNeg)!

testStrictlyPositive
	self deny: (self subjectClass x: 0 y: 0) strictlyPositive.
	self deny: (self subjectClass x: 0 y: 1) strictlyPositive.
	self deny: (self subjectClass x: 1 y: 0) strictlyPositive.
	self assert: (self subjectClass x: 1 y: 1) strictlyPositive.
	self deny: (self subjectClass x: 1 y: -1) strictlyPositive.
	self deny: (self subjectClass x: -1 y: 1) strictlyPositive! !

!PointTest categoriesForMethods!
subjectClass!constants!private! !
subjectSupportNonIntegralValues!private!testing! !
testAsUIntPtr!public! !
testCloseToPrecision!public!unit tests! !
testDivideLarge!public! !
testStrictlyPositive!public!unit tests! !
!

