"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #PointTest
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

testAbs
	self assert: (0 @ 0) abs equals: 0 @ 0.
	self assert: (1 @ 1) abs equals: 1 @ 1.
	self assert: (-1 @ 1) abs equals: 1 @ 1.
	self assert: (1 @ -1) abs equals: 1 @ 1.
	self assert: (-1 @ -1) abs equals: 1 @ 1!

testEquals
	self assert: 0 @ 0 equals: 0.
	self assert: 0 equals: 0 @ 0.
	self assert: 1 @ 1 equals: 1 @ 1.
	self deny: 1 @ 2 equals: 2 @ 1.
	self deny: 1 @ 2 equals: 1.5!

testIsZero
	self assert: (0 @ 0) isZero.
	self deny: (0 @ 1) isZero.
	self deny: (1 @ 0) isZero.
	self deny: (1 @ 1) isZero! !
!PointTest categoriesFor: #testAbs!public!unit tests! !
!PointTest categoriesFor: #testEquals!public!unit tests! !
!PointTest categoriesFor: #testIsZero!public!testing / testing! !

