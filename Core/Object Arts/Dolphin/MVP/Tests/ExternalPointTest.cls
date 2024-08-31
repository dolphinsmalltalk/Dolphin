﻿"Filed out from Dolphin Smalltalk"!

AbstractPointTest subclass: #ExternalPointTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExternalPointTest guid: (GUID fromString: '{9f425d20-35a5-4ddb-892b-1be3b6997ee3}')!

ExternalPointTest isAbstract: true!

ExternalPointTest comment: ''!

!ExternalPointTest categoriesForClass!Unclassified! !

!ExternalPointTest methodsFor!

testAsObject
	| point subject |
	subject := self subjectClass x: 101 y: 202.
	point := subject asObject.
	self assert: point class equals: Point.
	self assert: point x equals: 101.
	self assert: point y equals: 202!

testMarshal
	| subject |
	subject := self subjectClass marshal: 101 @ 202.
	self assert: subject isKindOf: self subjectClass.
	self assert: subject equals: 101 @ 202.
	self assert: (self subjectClass marshal: subject) identicalTo: subject!

testPrintString
	self assert: self subjectClass new printString equals: ('a ', self subjectClass name, '(0@0)').
	self assert: (self subjectClass fromPoint: (123@456)) printString equals: ('a ', self subjectClass name, '(123@456)')!

testScaleBy
	"Test scaling in-place"

	| subject |
	subject := self subjectClass marshal: 6 @ 4.
	subject scaleBy: 2.
	self assert: subject x equals: 12.
	self assert: subject y equals: 8.
	subject := self subjectClass marshal: 6 @ 4.
	subject scaleBy: 1 / 2.
	self assert: subject x equals: 3.
	self assert: subject y equals: 2.
	subject scaleBy: 0.
	self assert: subject x equals: 0.
	self assert: subject y equals: 0!

testValue
	| point subject |
	subject := self subjectClass x: 101 y: 202.
	point := subject value.
	self assert: point class equals: Point.
	self assert: point x equals: 101.
	self assert: point y equals: 202! !

!ExternalPointTest categoriesForMethods!
testAsObject!public!unit tests! !
testMarshal!public!unit tests! !
testPrintString!public!unit tests! !
testScaleBy!public! !
testValue!public!unit tests! !
!
