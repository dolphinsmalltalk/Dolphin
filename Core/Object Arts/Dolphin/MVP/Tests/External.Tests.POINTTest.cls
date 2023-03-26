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

testAsDword
	| dword subject |
	subject := self subjectClass x: 16r7654 y: 16r3210.
	dword := subject asDword.
	self assert: dword equals: 16r32107654!

testAsObject
	| point subject |
	subject := self subjectClass x: 101 y: 202.
	point := subject asObject.
	self assert: point class equals: Point.
	self assert: point x equals: 101.
	self assert: point y equals: 202!

testValue
	| point subject |
	subject := self subjectClass x: 101 y: 202.
	point := subject value.
	self assert: point class equals: Point.
	self assert: point x equals: 101.
	self assert: point y equals: 202! !
!External.Tests.POINTTest categoriesForMethods!
testAsDword!public!unit tests! !
testAsObject!public!unit tests! !
testValue!public!unit tests! !
!

