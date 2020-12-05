"Filed out from Dolphin Smalltalk 7"!

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
	self proceedThroughWarning: 
			[refactoring := PullUpInstanceVariableRefactoring variable: 'result' class: LintRuleTest.
			self executeRefactoring: refactoring].
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest')
				directlyDefinesInstanceVariable: 'result').
	self deny: ((refactoring model classNamed: #'Refactory.Browser.Tests.BasicLintRuleTest')
				directlyDefinesInstanceVariable: 'result')!

testPullUpVariableNotDefined
	self
		shouldFail: (PullUpInstanceVariableRefactoring variable: 'notDefinedVariable' class: LintRuleTest)! !
!Refactory.Browser.Tests.PushUpInstanceVariableTest categoriesFor: #testPullUpInstVar!public!tests! !
!Refactory.Browser.Tests.PushUpInstanceVariableTest categoriesFor: #testPullUpVariableNotDefined!failure tests!public! !

