"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.AddClassVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddClassVariableTest guid: (Core.GUID fromString: '{f9de1392-b16f-4543-891c-a1831dca7b74}')!
Refactory.Browser.Tests.AddClassVariableTest comment: ''!
!Refactory.Browser.Tests.AddClassVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddClassVariableTest methodsFor!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')!

testAddClassVariable
	| refactoring |
	refactoring := AddClassVariableRefactoring variable: 'Asdf' class: TransformationRuleTest.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.TransformationRuleTest')
				directlyDefinesClassVariable: #Asdf)!

testAlreadyExistingName
	self
		shouldFail: (AddClassVariableRefactoring variable: #RecursiveSelfRule class: TransformationRuleTest);
		shouldFail: (AddClassVariableRefactoring variable: self objectClassVariable
					class: TransformationRuleTest)!

testMetaclass
	| refactoring |
	refactoring := AddClassVariableRefactoring variable: #ClassVarName3
				class: (model classNamed: #'Core.Object') metaclass.
	refactoring model: model.
	self shouldFail: refactoring!

testMetaClassFailure
	self
		shouldFail: (AddClassVariableRefactoring variable: #VariableName class: TransformationRuleTest class)!

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
	self shouldFail: refactoring!

testModelMetaclass
	| refactoring |
	refactoring := AddClassVariableRefactoring
				model: model
				variable: #ClassVarName3
				class: (model classNamed: #Bar) metaclass.
	self shouldFail: refactoring! !
!Refactory.Browser.Tests.AddClassVariableTest categoriesFor: #setUp!public!set up! !
!Refactory.Browser.Tests.AddClassVariableTest categoriesFor: #testAddClassVariable!public!tests! !
!Refactory.Browser.Tests.AddClassVariableTest categoriesFor: #testAlreadyExistingName!failure tests!public! !
!Refactory.Browser.Tests.AddClassVariableTest categoriesFor: #testMetaclass!failure tests!public! !
!Refactory.Browser.Tests.AddClassVariableTest categoriesFor: #testMetaClassFailure!failure tests!public! !
!Refactory.Browser.Tests.AddClassVariableTest categoriesFor: #testModelAddClassVariable!public!tests! !
!Refactory.Browser.Tests.AddClassVariableTest categoriesFor: #testModelAlreadyExistingName!failure tests!public! !
!Refactory.Browser.Tests.AddClassVariableTest categoriesFor: #testModelMetaclass!failure tests!public! !

