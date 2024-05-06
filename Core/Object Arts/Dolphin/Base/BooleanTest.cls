"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #BooleanTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BooleanTest guid: (GUID fromString: '{5aa57122-600d-4018-870d-8425b90179b2}')!

BooleanTest comment: ''!

!BooleanTest categoriesForClass!Unclassified! !

!BooleanTest methodsFor!

testEvaluatingConjunction
	self deny: false & false.
	self deny: false & true.
	self deny: true & false.
	self assert: true & true.
	self should: [true & [false]] raise: Error.
	self should: [false & 1] raise: Error.
	self should: [true & 'a'] raise: Error!

testEvaluatingDisjunction
	self deny: (false | false).
	self assert: (false | true).
	self assert: (true | false).
	self assert: (true | true).
	self should: [true | [false]] raise: Error.
	self should: [false | 1] raise: Error.
	self should: [true | 'a'] raise: Error!

testNew
	self should: [Boolean new] raise: TestResult error.
	self should: [True new] raise: TestResult error.
	self should: [False new] raise: TestResult error!

testXor
	self assert: (true xor: false).
	self assert: (false xor: true).
	self deny: (false xor: false).
	self deny: (true xor: true)! !

!BooleanTest categoriesForMethods!
testEvaluatingConjunction!public!unit tests! !
testEvaluatingDisjunction!public!unit tests! !
testNew!public!testing! !
testXor!public!unit tests! !
!

