"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #AbstractPointTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractPointTest guid: (GUID fromString: '{a0f6e2b2-8bd1-44bc-b0ad-3343d7aa2c0f}')!

AbstractPointTest isAbstract: true!

AbstractPointTest comment: ''!

!AbstractPointTest categoriesForClass!Unclassified! !

!AbstractPointTest methodsFor!

subjectClass
	^self subclassResponsibility!

testAsPoint
	| point subject |
	subject := self subjectClass x: 101 y: 202.
	point := subject asPoint.
	self assert: point class equals: Point.
	self assert: point x equals: 101.
	self assert: point y equals: 202!

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

!AbstractPointTest categoriesForMethods!
subjectClass!constants!private! !
testAsPoint!public!unit tests! !
testMakePoint!public!unit tests! !
!

