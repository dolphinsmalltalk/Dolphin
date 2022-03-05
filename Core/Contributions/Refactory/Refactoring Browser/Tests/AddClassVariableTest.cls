"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #AddClassVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AddClassVariableTest guid: (GUID fromString: '{f9de1392-b16f-4543-891c-a1831dca7b74}')!
AddClassVariableTest comment: ''!
!AddClassVariableTest categoriesForClass!Refactory-Testing! !
!AddClassVariableTest methodsFor!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')!

testAddClassVariable
	| refactoring |
	refactoring := AddClassVariableRefactoring variable: 'Asdf'
				class: TransformationRuleTest.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #TransformationRuleTest) 
				directlyDefinesClassVariable: #Asdf)!

testAlreadyExistingName
	self
		shouldFail: (AddClassVariableRefactoring variable: #RecursiveSelfRule
					class: TransformationRuleTest);
		shouldFail: (AddClassVariableRefactoring variable: self objectClassVariable
					class: TransformationRuleTest)!

testMetaclass
	| refactoring |
	refactoring := AddClassVariableRefactoring variable: #ClassVarName3
				class: (model classNamed: #Object) metaclass.
	refactoring model: model.
	self shouldFail: refactoring!

testMetaClassFailure
	self shouldFail: (AddClassVariableRefactoring variable: #VariableName
				class: TransformationRuleTest class)!

testModelAddClassVariable
	| refactoring |
	refactoring := AddClassVariableRefactoring 
				model: model
				variable: #ClassVarName3
				class: (model classNamed: #Bar).
	self executeRefactoring: refactoring.
	self assert: ((model classNamed: #Bar) 
				directlyDefinesClassVariable: #ClassVarName3)!

testModelAlreadyExistingName
	| refactoring |
	refactoring := AddClassVariableRefactoring 
				model: model
				variable: #ClassVarName2
				class: (model classNamed: #Bar).
	self shouldFail: refactoring!

testModelMetaclass
	| refactoring |
	refactoring := AddClassVariableRefactoring 
				model: model
				variable: #ClassVarName3
				class: (model classNamed: #Bar) metaclass.
	self shouldFail: refactoring! !
!AddClassVariableTest categoriesForMethods!
setUp!public!set up! !
testAddClassVariable!public!tests! !
testAlreadyExistingName!failure tests!public! !
testMetaclass!failure tests!public! !
testMetaClassFailure!failure tests!public! !
testModelAddClassVariable!public!tests! !
testModelAlreadyExistingName!failure tests!public! !
testModelMetaclass!failure tests!public! !
!

