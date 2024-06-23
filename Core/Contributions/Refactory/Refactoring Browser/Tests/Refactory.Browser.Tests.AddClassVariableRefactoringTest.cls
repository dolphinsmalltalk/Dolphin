"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.AddClassVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.AddClassVariableRefactoringTest guid: (Core.GUID fromString: '{f9de1392-b16f-4543-891c-a1831dca7b74}')!

Refactory.Browser.Tests.AddClassVariableRefactoringTest comment: ''!

!Refactory.Browser.Tests.AddClassVariableRefactoringTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.AddClassVariableRefactoringTest methodsFor!

setUp
	super setUp.
	model := self abstractVariableTestData!

testAddClassVariable
	| refactoring |
	refactoring := AddClassVariableRefactoring variable: 'Asdf' class: TransformationRuleTestData.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.TestData.TransformationRuleTestData')
				directlyDefinesClassVariable: #Asdf)!

testAlreadyExistingClass
	"Attempting to add a class variable to a Namespace that clashes with a class binding"

	self shouldFail: (AddClassVariableRefactoring variable: #Object class: Core)
		withMessage: 'Core or one of its subclasses defines variable ''Object'''.
	self shouldFail: (AddClassVariableRefactoring variable: #Core class: Root)
		withMessage: 'Root or one of its subclasses defines variable ''Core'''!

testAlreadyExistingName
	self
		shouldFail: (AddClassVariableRefactoring variable: #RecursiveSelfRule
					class: TransformationRuleTestData)
			withMessage: 'TransformationRuleTestData or one of its subclasses defines variable ''RecursiveSelfRule''';
		shouldFail: (AddClassVariableRefactoring variable: self objectClassVariable
					class: TransformationRuleTestData)
			withMessage: 'TransformationRuleTestData or one of its subclasses defines variable <1p>'
					<< self objectClassVariable!

testMetaClassFailure
	self shouldFail: (AddClassVariableRefactoring variable: #VariableName
				class: TransformationRuleTestData class)
		withMessage: 'TransformationRuleTestData class is a metaclass'!

testModelAddClassVariable
	| refactoring |
	refactoring := AddClassVariableRefactoring
				model: model
				variable: #ClassVarName3
				class: (model classNamed: #Bar).
	self executeRefactoring: refactoring.
	self assert: ((model classNamed: #Bar) directlyDefinesClassVariable: #ClassVarName3)!

testModelAlreadyExistingName
	| refactoring |
	refactoring := AddClassVariableRefactoring
				model: model
				variable: #ClassVarName2
				class: (model classNamed: #Bar).
	self shouldFail: refactoring
		withMessage: 'Bar or one of its subclasses defines variable ''ClassVarName2'''!

testModelMetaclassFailure
	| refactoring |
	refactoring := AddClassVariableRefactoring
				model: model
				variable: #ClassVarName3
				class: (model classNamed: #Bar) metaclass.
	self shouldFail: refactoring withMessage: 'Bar class is a metaclass'!

testRBMetaclassFailure
	| refactoring |
	refactoring := AddClassVariableRefactoring variable: #ClassVarName3
				class: (model classNamed: #'Core.Object') metaclass.
	refactoring model: model.
	self shouldFail: refactoring withMessage: 'Object class is a metaclass'! !

!Refactory.Browser.Tests.AddClassVariableRefactoringTest categoriesForMethods!
setUp!public!set up! !
testAddClassVariable!public!tests! !
testAlreadyExistingClass!failure tests!public! !
testAlreadyExistingName!failure tests!public! !
testMetaClassFailure!failure tests!public! !
testModelAddClassVariable!public!tests! !
testModelAlreadyExistingName!failure tests!public! !
testModelMetaclassFailure!failure tests!public! !
testRBMetaclassFailure!failure tests!public! !
!

