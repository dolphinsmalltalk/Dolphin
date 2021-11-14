"Filed out from Dolphin Smalltalk"!

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
	self shouldFail: (PullUpClassVariableRefactoring variable: #RecursiveSelfRule
				class: LintRuleTestData class)
		withMessage: 'LintRuleTestData class is a metaclass'!

testNonExistantName
	self shouldFail: (PullUpClassVariableRefactoring variable: #Foo class: LintRuleTestData)
		withMessage: 'Could not find a class defining Foo'!

testPullUpClassConstant
	| refactoring bar |
	refactoring := PullUpClassVariableRefactoring variable: #Bar class: LintRuleTestData.
	self executeRefactoring: refactoring.
	bar := (refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTestData') classConstants
				detect: [:each | each key = 'Bar'].
	self assert: bar value equals: 123.
	self
		deny: ((refactoring model classNamed: #'Refactory.Browser.Tests.TransformationRuleTestData')
				classConstants anySatisfy: [:each | each key = 'Bar'])!

testPullUpClassVariable
	| refactoring |
	refactoring := PullUpClassVariableRefactoring variable: #RecursiveSelfRule class: LintRuleTestData.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTestData')
				directlyDefinesClassVariable: #RecursiveSelfRule).
	self deny: ((refactoring model classNamed: #'Refactory.Browser.Tests.TransformationRuleTestData')
				directlyDefinesClassVariable: #RecursiveSelfRule)! !
!Refactory.Browser.Tests.PullUpClassVariableTest categoriesForMethods!
testMetaClassFailure!failure tests!public! !
testNonExistantName!failure tests!public! !
testPullUpClassConstant!public!tests! !
testPullUpClassVariable!public!tests! !
!

