"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #RBConditionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBConditionTest guid: (GUID fromString: '{d7c6868f-bf84-4580-b4c0-20abbdcdb10e}')!
RBConditionTest comment: ''!
!RBConditionTest categoriesForClass!Refactory-Testing! !
!RBConditionTest methodsFor!

testConditions
	| condition newCondition |
	condition := RBCondition new
				type: #false
				block: [false]
				errorString: 'false'.
	condition errorMacro: '<1?true:false>'.
	self deny: condition check.
	self assert: condition errorString equals: 'false'.
	self assert: condition not check.
	self assert: condition printString equals: '#false'.
	self assert: condition not printString equals: 'NOT #false'.
	self deny: (condition not & condition) check.
	self assert: (condition not & condition) printString equals: 'NOT #false & #false'.
	self assert: (condition & condition) not check.
	self assert: (condition | condition not) check.
	self deny: (newCondition := condition | condition) check.
	self assert: newCondition errorString equals: 'false AND false'.
	self assert: (condition not | condition not) check.
	self deny: (newCondition := condition & condition) check.
	self assert: newCondition errorString equals: 'false'.
	self assert: (condition not & condition not) check.
	self assert: (condition & condition) errorString equals: 'false OR false'! !
!RBConditionTest categoriesFor: #testConditions!public!tests! !

