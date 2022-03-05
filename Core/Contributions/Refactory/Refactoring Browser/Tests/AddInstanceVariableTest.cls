"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #AddInstanceVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AddInstanceVariableTest guid: (GUID fromString: '{95c6c15d-0113-4ae8-81d5-766bece4b2ac}')!
AddInstanceVariableTest comment: ''!
!AddInstanceVariableTest categoriesForClass!Refactory-Testing! !
!AddInstanceVariableTest methodsFor!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')!

testAddInstanceVariable
	| refactoring |
	refactoring := AddInstanceVariableRefactoring variable: 'asdf'
				class: TransformationRuleTest.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #TransformationRuleTest) 
				directlyDefinesInstanceVariable: 'asdf')!

testAddToModel
	| refactoring |
	model := RBNamespace new.
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
	self assert: ((refactoring model classNamed: #FOOBAR) 
				directlyDefinesInstanceVariable: 'asdf')!

testAlreadyExistingName
	self
		shouldFail: (AddInstanceVariableRefactoring variable: 'class'
					class: TransformationRuleTest);
		shouldFail: (AddInstanceVariableRefactoring variable: 'name'
					class: TransformationRuleTest)!

testModelAlreadyExistingName
	| refactoring |
	refactoring := AddInstanceVariableRefactoring 
				model: model
				variable: 'instVarName1'
				class: (model classNamed: #Bar).
	self shouldFail: refactoring!

testModelMetaclassAlreadyExistingName
	| refactoring |
	(model metaclassNamed: #Foo) addInstanceVariable: 'instVarName1'.
	refactoring := AddInstanceVariableRefactoring 
				model: model
				variable: 'instVarName1'
				class: (model classNamed: #Bar).
	self shouldFail: refactoring!

testNewExistingName
	| refactoring |
	model := RBNamespace new.
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
	self shouldFail: refactoring!

testNewHierarchyExistingName
	| refactoring |
	model := RBNamespace new.
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
	self shouldFail: refactoring! !
!AddInstanceVariableTest categoriesForMethods!
setUp!public!set up! !
testAddInstanceVariable!public!tests! !
testAddToModel!public!tests! !
testAlreadyExistingName!failure tests!public! !
testModelAlreadyExistingName!failure tests!public! !
testModelMetaclassAlreadyExistingName!failure tests!public! !
testNewExistingName!failure tests!public! !
testNewHierarchyExistingName!failure tests!public! !
!

