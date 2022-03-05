"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #PushUpInstanceVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PushUpInstanceVariableTest guid: (GUID fromString: '{08db86cb-6161-486b-82f5-70846a431aa1}')!
PushUpInstanceVariableTest comment: ''!
!PushUpInstanceVariableTest categoriesForClass!Refactory-Testing! !
!PushUpInstanceVariableTest methodsFor!

testPullUpInstVar
	| refactoring |
	self proceedThroughWarning: 
			[refactoring := PullUpInstanceVariableRefactoring variable: 'result'
						class: LintRuleTest.
			self executeRefactoring: refactoring].
	self assert: ((refactoring model classNamed: #LintRuleTest) 
				directlyDefinesInstanceVariable: 'result').
	self deny: ((refactoring model classNamed: #BasicLintRuleTest) 
				directlyDefinesInstanceVariable: 'result')!

testPullUpVariableNotDefined
	self shouldFail: (PullUpInstanceVariableRefactoring 
				variable: 'notDefinedVariable'
				class: LintRuleTest)! !
!PushUpInstanceVariableTest categoriesForMethods!
testPullUpInstVar!public!tests! !
testPullUpVariableNotDefined!failure tests!public! !
!

