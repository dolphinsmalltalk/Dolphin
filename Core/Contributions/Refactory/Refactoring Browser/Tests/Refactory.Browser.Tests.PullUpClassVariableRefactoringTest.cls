"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.PullUpClassVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.PullUpClassVariableRefactoringTest guid: (Core.GUID fromString: '{714d19ba-e40b-447b-b1d3-72e8d1f543ea}')!
Refactory.Browser.Tests.PullUpClassVariableRefactoringTest comment: ''!
!Refactory.Browser.Tests.PullUpClassVariableRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.PullUpClassVariableRefactoringTest methodsFor!

testMetaClassFailure
	self shouldFail: (PullUpClassVariableRefactoring variable: #RecursiveSelfRule
				class: LintRuleTestData class)
		withMessage: 'LintRuleTestData class is a metaclass'!

testNonExistantName
	self shouldFail: (PullUpClassVariableRefactoring variable: #Foo class: LintRuleTestData)
		withMessage: 'Could not find a class defining Foo'!

testPullUpClassConstant
	| refactoring bar modelClass modelSubclass |
	refactoring := PullUpClassVariableRefactoring variable: #Bar class: LintRuleTestData.
	self executeRefactoring: refactoring.
	modelClass := refactoring model classFor: LintRuleTestData.
	bar := modelClass localBindingFor: 'Bar'.
	self assert: bar value equals: 123.
	self assert: bar environment identicalTo: modelClass.
	self assert: bar isImmutable.
	modelSubclass := refactoring model classFor: TransformationRuleTestData.
	self assertIsNil: (modelSubclass localBindingFor: 'Bar')!

testPullUpClassVariable
	| refactoring |
	refactoring := PullUpClassVariableRefactoring variable: #RecursiveSelfRule class: LintRuleTestData.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classFor: LintRuleTestData)
				directlyDefinesClassVariable: #RecursiveSelfRule).
	self deny: ((refactoring model classFor: TransformationRuleTestData)
				directlyDefinesClassVariable: #RecursiveSelfRule)! !
!Refactory.Browser.Tests.PullUpClassVariableRefactoringTest categoriesForMethods!
testMetaClassFailure!failure tests!public! !
testNonExistantName!failure tests!public! !
testPullUpClassConstant!public!tests! !
testPullUpClassVariable!public!tests! !
!

