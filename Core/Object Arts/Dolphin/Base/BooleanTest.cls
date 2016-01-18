"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #BooleanTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BooleanTest guid: (GUID fromString: '{5AA57122-600D-4018-870D-8425B90179B2}')!
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
	self should: [False new] raise: TestResult error! !
!BooleanTest categoriesFor: #testEvaluatingConjunction!public!unit tests! !
!BooleanTest categoriesFor: #testEvaluatingDisjunction!public!unit tests! !
!BooleanTest categoriesFor: #testNew!public!testing! !

