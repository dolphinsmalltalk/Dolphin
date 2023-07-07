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
	refactoring := PullUpClassVariableRefactoring
				model: model
				variable: #Bar
				class: LintRuleTestData.
	self executeRefactoring: refactoring.
	modelClass := model classFor: LintRuleTestData.
	bar := modelClass localBindingFor: 'Bar'.
	self assert: bar value equals: 123.
	self assert: bar environment identicalTo: modelClass.
	self assert: bar isImmutable.
	modelSubclass := model classFor: TransformationRuleTestData.
	self assertIsNil: (modelSubclass localBindingFor: 'Bar')!

testPullUpClassVariable
	| refactoring targetClass sourceSubClass refDataApp |
	targetClass := model classFor: LintRuleTestData.
	targetClass compile: 'refToClassVar ^TransformationRuleTestData.RecursiveSelfRule'.
	"Deliberately create a (partially-qualified) reference from outside the class hierarchy - these should be rewritten too."
	refDataApp := model classFor: RefactoryTestDataApp.
	refDataApp compile: 'refToExternalClassVar ^TransformationRuleTestData.RecursiveSelfRule'.
	refactoring := PullUpClassVariableRefactoring
				model: model
				variable: #RecursiveSelfRule
				class: LintRuleTestData.
	self executeRefactoring: refactoring.
	self assert: (targetClass directlyDefinesClassVariable: #RecursiveSelfRule).
	sourceSubClass := model classFor: TransformationRuleTestData.
	self deny: (sourceSubClass directlyDefinesClassVariable: #RecursiveSelfRule).
	self assert: (targetClass methodFor: #refToClassVar) parseTree
		equals: (self parseMethod: 'refToClassVar ^RecursiveSelfRule' in: targetClass).
	self assert: (sourceSubClass methodFor: #runRecursiveSelfRule:) parseTree
		equals: (self
				parseMethod: 'runRecursiveSelfRule: aParseTree ^RecursiveSelfRule executeTree: aParseTree initialAnswer: false'
				in: targetClass).
	"The external reference - can still be partially qualified because RefactoryTestDataApp is in the same namespace"
	self assert: (refDataApp methodFor: #refToExternalClassVar) parseTree
		equals: (self parseMethod: 'refToExternalClassVar ^LintRuleTestData.RecursiveSelfRule'
				in: targetClass).
	false ifTrue: [model browseChanges]! !
!Refactory.Browser.Tests.PullUpClassVariableRefactoringTest categoriesForMethods!
testMetaClassFailure!failure tests!public! !
testNonExistantName!failure tests!public! !
testPullUpClassConstant!public!tests! !
testPullUpClassVariable!public!tests! !
!

