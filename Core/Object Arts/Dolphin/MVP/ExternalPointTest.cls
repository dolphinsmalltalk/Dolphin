"Filed out from Dolphin Smalltalk"!

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
!ExternalPointTest categoriesForMethods!
testAsDword!public!unit tests! !
testAsObject!public!unit tests! !
testValue!public!unit tests! !
!

