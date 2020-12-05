"Filed out from Dolphin Smalltalk 7"!

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
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')!

testAddInstanceVariable
	| refactoring |
	refactoring := AddInstanceVariableRefactoring variable: 'asdf' class: TransformationRuleTest.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.TransformationRuleTest')
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
	self assert: ((refactoring model classNamed: #FOOBAR) directlyDefinesInstanceVariable: 'asdf')!

testAlreadyExistingName
	self
		shouldFail: (AddInstanceVariableRefactoring variable: 'class' class: TransformationRuleTest);
		shouldFail: (AddInstanceVariableRefactoring variable: 'name' class: TransformationRuleTest)!

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
!Refactory.Browser.Tests.AddInstanceVariableTest categoriesFor: #setUp!public!set up! !
!Refactory.Browser.Tests.AddInstanceVariableTest categoriesFor: #testAddInstanceVariable!public!tests! !
!Refactory.Browser.Tests.AddInstanceVariableTest categoriesFor: #testAddToModel!public!tests! !
!Refactory.Browser.Tests.AddInstanceVariableTest categoriesFor: #testAlreadyExistingName!failure tests!public! !
!Refactory.Browser.Tests.AddInstanceVariableTest categoriesFor: #testModelAlreadyExistingName!failure tests!public! !
!Refactory.Browser.Tests.AddInstanceVariableTest categoriesFor: #testModelMetaclassAlreadyExistingName!failure tests!public! !
!Refactory.Browser.Tests.AddInstanceVariableTest categoriesFor: #testNewExistingName!failure tests!public! !
!Refactory.Browser.Tests.AddInstanceVariableTest categoriesFor: #testNewHierarchyExistingName!failure tests!public! !

