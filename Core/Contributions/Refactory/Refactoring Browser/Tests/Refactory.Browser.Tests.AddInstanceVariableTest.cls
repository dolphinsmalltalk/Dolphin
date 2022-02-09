"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.AddInstanceVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddInstanceVariableTest guid: (Core.GUID fromString: '{95c6c15d-0113-4ae8-81d5-766bece4b2ac}')!
Refactory.Browser.Tests.AddInstanceVariableTest comment: ''!
!Refactory.Browser.Tests.AddInstanceVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddInstanceVariableTest methodsFor!

setUp
	super setUp.
	model := self abstractVariableTestData!

testAddInstanceVariable
	| refactoring |
	refactoring := AddInstanceVariableRefactoring variable: 'asdf' class: TransformationRuleTestData.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.TestData.TransformationRuleTestData')
				directlyDefinesInstanceVariable: 'asdf')!

testAddToModel
	| refactoring |
	model := RBModel new.
	model name: 'Add instance variable'.
	model
		defineClass: 'Object subclass: #FOOBAR 
				instanceVariableNames: ''fdsa'' 	
				classVariableNames: ''''
				poolDictionaries: ''''
				category: ''Refactory-Test data'''.
	refactoring := AddInstanceVariableRefactoring
				model: model
				variable: 'asdf'
				class: (model classNamed: #FOOBAR).
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #FOOBAR) directlyDefinesInstanceVariable: 'asdf')!

testAlreadyExistingName
	self
		shouldFail: (AddInstanceVariableRefactoring variable: 'class' class: TransformationRuleTestData)
			withMessage: 'TransformationRuleTestData or one of its subclasses defines variable ''class''';
		shouldFail: (AddInstanceVariableRefactoring variable: 'name' class: TransformationRuleTestData)
			withMessage: 'TransformationRuleTestData or one of its subclasses defines variable ''name'''!

testModelAlreadyExistingName
	| refactoring |
	refactoring := AddInstanceVariableRefactoring
				model: model
				variable: 'instVarName1'
				class: (model classNamed: #Bar).
	self shouldFail: refactoring
		withMessage: 'Bar or one of its subclasses defines variable ''instVarName1'''!

testModelMetaclassAlreadyExistingName
	| refactoring |
	(model metaclassNamed: #Foo) addInstanceVariable: 'classInstVarName1'.
	refactoring := AddInstanceVariableRefactoring
				model: model
				variable: 'classInstVarName1'
				class: (model classNamed: #Bar) metaclass.
	self shouldFail: refactoring withMessage: 'Bar class or one of its subclasses defines variable ''classInstVarName1'''!

testNewExistingName
	| refactoring |
	model := RBModel new.
	model name: 'Add instance variable'.
	model
		defineClass: 'Object subclass: #FOOBAR 
				instanceVariableNames: ''asdf'' 	
				classVariableNames: ''''
				poolDictionaries: ''''
				category: ''Refactory-Test data'''.
	refactoring := AddInstanceVariableRefactoring
				model: model
				variable: 'asdf'
				class: (model classNamed: #FOOBAR).
	self shouldFail: refactoring
		withMessage: 'FOOBAR or one of its subclasses defines variable ''asdf'''!

testNewHierarchyExistingName
	| refactoring |
	model := RBModel new.
	model name: 'Add instance variable'.
	model
		defineClass: 'Object subclass: #FOOBAR 
				instanceVariableNames: ''asdf'' 	
				classVariableNames: ''''
				poolDictionaries: ''''
				category: ''Refactory-Test data'''.
	model
		defineClass: 'FOOBAR subclass: #BARFOO 
				instanceVariableNames: '''' 	
				classVariableNames: ''''
				poolDictionaries: ''''
				category: ''Refactory-Test data'''.
	refactoring := AddInstanceVariableRefactoring
				model: model
				variable: 'asdf'
				class: (model classNamed: #BARFOO).
	self shouldFail: refactoring
		withMessage: 'BARFOO or one of its subclasses defines variable ''asdf'''! !
!Refactory.Browser.Tests.AddInstanceVariableTest categoriesForMethods!
setUp!public!set up! !
testAddInstanceVariable!public!tests! !
testAddToModel!public!tests! !
testAlreadyExistingName!failure tests!public! !
testModelAlreadyExistingName!failure tests!public! !
testModelMetaclassAlreadyExistingName!failure tests!public! !
testNewExistingName!failure tests!public! !
testNewHierarchyExistingName!failure tests!public! !
!

