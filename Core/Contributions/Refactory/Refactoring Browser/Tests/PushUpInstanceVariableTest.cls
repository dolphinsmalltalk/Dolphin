"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RefactoringTest subclass: #PushUpInstanceVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PushUpInstanceVariableTest comment: ''!

PushUpInstanceVariableTest guid: (GUID fromString: '{08DB86CB-6161-486B-82F5-70846A431AA1}')!

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
!PushUpInstanceVariableTest categoriesFor: #testPullUpInstVar!public!tests! !
!PushUpInstanceVariableTest categoriesFor: #testPullUpVariableNotDefined!failure tests!public! !

