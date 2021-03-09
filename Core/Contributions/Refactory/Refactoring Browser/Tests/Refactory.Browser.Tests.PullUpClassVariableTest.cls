"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.PullUpClassVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.PullUpClassVariableTest guid: (Core.GUID fromString: '{714d19ba-e40b-447b-b1d3-72e8d1f543ea}')!
Refactory.Browser.Tests.PullUpClassVariableTest comment: ''!
!Refactory.Browser.Tests.PullUpClassVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.PullUpClassVariableTest methodsFor!

testMetaClassFailure
	self
		shouldFail: (PullUpClassVariableRefactoring variable: #RecursiveSelfRule class: LintRuleTest class)!

testNonExistantName
	self shouldFail: (PullUpClassVariableRefactoring variable: #Foo class: LintRuleTest)!

testPullUpClassConstant
	| refactoring bar |
	refactoring := PullUpClassVariableRefactoring variable: #Bar class: LintRuleTest.
	self executeRefactoring: refactoring.
	bar := (refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest') classConstants
				detect: [:each | each key = 'Bar'].
	self assert: bar value equals: 123.
	self
		deny: ((refactoring model classNamed: #'Refactory.Browser.Tests.TransformationRuleTest')
				classConstants anySatisfy: [:each | each key = 'Bar'])!

testPullUpClassVariable
	| refactoring |
	refactoring := PullUpClassVariableRefactoring variable: #RecursiveSelfRule class: LintRuleTest.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest')
				directlyDefinesClassVariable: #RecursiveSelfRule).
	self deny: ((refactoring model classNamed: #'Refactory.Browser.Tests.TransformationRuleTest')
				directlyDefinesClassVariable: #RecursiveSelfRule)! !
!Refactory.Browser.Tests.PullUpClassVariableTest categoriesFor: #testMetaClassFailure!failure tests!public! !
!Refactory.Browser.Tests.PullUpClassVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.PullUpClassVariableTest categoriesFor: #testPullUpClassConstant!public!tests! !
!Refactory.Browser.Tests.PullUpClassVariableTest categoriesFor: #testPullUpClassVariable!public!tests! !

