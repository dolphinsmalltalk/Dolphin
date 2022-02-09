"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.PushUpInstanceVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.PushUpInstanceVariableTest guid: (Core.GUID fromString: '{08db86cb-6161-486b-82f5-70846a431aa1}')!
Refactory.Browser.Tests.PushUpInstanceVariableTest comment: ''!
!Refactory.Browser.Tests.PushUpInstanceVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.PushUpInstanceVariableTest methodsFor!

testPullUpInstVar
	| refactoring |
	refactoring := PullUpInstanceVariableRefactoring variable: 'result' class: LintRuleTestData.
	refactoring setOption: #pullUpNonSharedInstVar
		toUse: 
			[:rcvr :var |
			self assert: var equals: 'result'.
			true].
	self executeRefactoring: refactoring.
	self
		assert: ((refactoring model classFor: LintRuleTestData) directlyDefinesInstanceVariable: 'result').
	self deny: ((refactoring model classNamed: #'Refactory.Browser.TestData.BasicLintRuleTestData')
				directlyDefinesInstanceVariable: 'result')!

testPullUpVariableNotDefined
	self
		shouldFail: (PullUpInstanceVariableRefactoring variable: 'notDefinedVariable' class: LintRuleTestData)
		withMessage: 'No subclass defines notDefinedVariable'! !
!Refactory.Browser.Tests.PushUpInstanceVariableTest categoriesForMethods!
testPullUpInstVar!public!tests! !
testPullUpVariableNotDefined!failure tests!public! !
!

