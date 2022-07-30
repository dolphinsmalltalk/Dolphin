"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Graphics.Tests.AbstractPointTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.AbstractPointTest guid: (Core.GUID fromString: '{a0f6e2b2-8bd1-44bc-b0ad-3343d7aa2c0f}')!
Graphics.Tests.AbstractPointTest isNonInstantiable: true!
Graphics.Tests.AbstractPointTest comment: ''!
!Graphics.Tests.AbstractPointTest methodsFor!

subjectClass
	^self subclassResponsibility!

testAsPoint
	| point subject |
	subject := self subjectClass x: 101 y: 202.
	point := subject asPoint.
	self assert: point class equals: Point.
	self assert: point x equals: 101.
	self assert: point y equals: 202!

testComparing
	| subject point |
	point := 101 @ 102.
	subject := self subjectClass x: point x y: point y.
	self assert: subject equals: subject.
	self assert: subject species identicalTo: Point.
	self assert: subject hash equals: point hash.
	self assert: subject equals: point.
	self assert: point equals: subject!

testIsZero
	| subject |
	subject := self subjectClass x: 101 y: 202.
	self deny: subject isZero.
	subject := self subjectClass new.
	self assert: subject isZero
	!

testMakePoint
	| point point2 originalMethod testMethod |
	point := self subjectClass x: 101 y: 202.
	self assert: point x equals: 101.
	self assert: point y equals: 202.
	originalMethod := self subjectClass class lookupMethod: #x:y:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	point2 := testMethod value: self subjectClass withArguments: #(101 202).
	self assert: point2 x equals: 101.
	self assert: point2 y equals: 202! !
!Graphics.Tests.AbstractPointTest categoriesForMethods!
subjectClass!constants!private! !
testAsPoint!public!unit tests! !
testComparing!public!unit tests! !
testIsZero!public!unit tests! !
testMakePoint!public!unit tests! !
!

