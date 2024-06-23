"Filed out from Dolphin Smalltalk"!

Graphics.Tests.AbstractPointTest
	subclass: #'External.Tests.POINTTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Graphics private})
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.POINTTest guid: (Core.GUID fromString: '{9f425d20-35a5-4ddb-892b-1be3b6997ee3}')!

External.Tests.POINTTest isNonInstantiable: true!

External.Tests.POINTTest comment: ''!

!External.Tests.POINTTest methodsFor!

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
	self assert: (self subjectClass marshal: subject) identicalTo: subject!

testPrintString
	self assert: self subjectClass new printString equals: ('a ', self subjectClass name, '(0@0)').
	self assert: (self subjectClass fromPoint: (123@456)) printString equals: ('a ', self subjectClass name, '(123@456)')!

testValue
	| point subject |
	subject := self subjectClass x: 101 y: 202.
	point := subject value.
	self assert: point class equals: Point.
	self assert: point x equals: 101.
	self assert: point y equals: 202! !

!External.Tests.POINTTest categoriesForMethods!
testAsObject!public!unit tests! !
testMarshal!public!unit tests! !
testPrintString!public! !
testValue!public!unit tests! !
!

