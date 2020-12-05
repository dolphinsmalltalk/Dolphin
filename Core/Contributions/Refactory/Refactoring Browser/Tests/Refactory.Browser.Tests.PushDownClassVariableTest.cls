"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.PushDownClassVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.PushDownClassVariableTest guid: (Core.GUID fromString: '{a5398930-2959-4aa2-a55c-3bce05b7412a}')!
Refactory.Browser.Tests.PushDownClassVariableTest comment: ''!
!Refactory.Browser.Tests.PushDownClassVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.PushDownClassVariableTest methodsFor!

testModelNonExistantName
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	self shouldFail: (PushDownClassVariableRefactoring
				model: model
				variable: #Foo
				class: (model classNamed: #SomeClass))!

testModelPushDownToMultipleSubclassesFailure
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #Subclass) compile: 'foo ^Foo' classified: #(#accessing).
	model
		defineClass: 'SomeClass subclass: #AnotherSubclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model metaclassNamed: #AnotherSubclass) compile: 'bar ^Foo' classified: #(#accessing).
	self shouldFail: (PushDownClassVariableRefactoring
				model: model
				variable: #Foo
				class: (model classNamed: #SomeClass))!

testModelPushDownVariable
	| class |
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	class := model classNamed: #Subclass.
	class compile: 'foo ^Foo' classified: #(#accessing).
	self executeRefactoring: (PushDownClassVariableRefactoring
				model: model
				variable: #Foo
				class: class superclass).
	self deny: (class superclass directlyDefinesClassVariable: #Foo).
	self assert: (class directlyDefinesClassVariable: #Foo)!

testModelPushDownVariableToClassDownTwoLevels
	| class |
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model
		defineClass: 'Subclass subclass: #AnotherSubclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	class := model metaclassNamed: #AnotherSubclass.
	class compile: 'bar ^Foo' classified: #(#accessing).
	class := class nonMetaclass.
	self executeRefactoring: (PushDownClassVariableRefactoring
				model: model
				variable: #Foo
				class: class superclass superclass).
	self deny: (class superclass superclass directlyDefinesClassVariable: #Foo).
	self deny: (class superclass directlyDefinesClassVariable: #Foo).
	self assert: (class directlyDefinesClassVariable: #Foo)!

testModelPushDownVariableToMultipleClassesInSameHierarchy
	| class |
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	class := model classNamed: #Subclass.
	class compile: 'foo ^Foo' classified: #(#accessing).
	model
		defineClass: 'Subclass subclass: #AnotherSubclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model metaclassNamed: #AnotherSubclass) compile: 'bar ^Foo' classified: #(#accessing).
	self executeRefactoring: (PushDownClassVariableRefactoring
				model: model
				variable: #Foo
				class: class superclass).
	self deny: (class superclass directlyDefinesClassVariable: #Foo).
	self assert: (class directlyDefinesClassVariable: #Foo)!

testModelRemoveUnusedVariable
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	self assert: ((model classNamed: #SomeClass) directlyDefinesVariable: #Foo).
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	self executeRefactoring: (PushDownClassVariableRefactoring
				model: model
				variable: #Foo
				class: (model classNamed: #SomeClass)).
	self deny: ((model classNamed: #SomeClass) directlyDefinesVariable: #Foo).
	self deny: ((model classNamed: #Subclass) directlyDefinesVariable: #Foo)!

testNonExistantName
	self shouldFail: (PushDownClassVariableRefactoring variable: #Foo class: BasicLintRuleTest)!

testPushDownClassVariable
	| refactoring |
	refactoring := PushDownClassVariableRefactoring variable: #Foo1 class: LintRuleTest.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest')
				directlyDefinesClassVariable: #Foo1).
	self executeRefactoring: refactoring.
	(refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest') withAllSubclasses
		do: [:each | self deny: (each directlyDefinesClassVariable: #Foo1)]! !
!Refactory.Browser.Tests.PushDownClassVariableTest categoriesFor: #testModelNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.PushDownClassVariableTest categoriesFor: #testModelPushDownToMultipleSubclassesFailure!failure tests!public! !
!Refactory.Browser.Tests.PushDownClassVariableTest categoriesFor: #testModelPushDownVariable!public!tests! !
!Refactory.Browser.Tests.PushDownClassVariableTest categoriesFor: #testModelPushDownVariableToClassDownTwoLevels!public!tests! !
!Refactory.Browser.Tests.PushDownClassVariableTest categoriesFor: #testModelPushDownVariableToMultipleClassesInSameHierarchy!public!tests! !
!Refactory.Browser.Tests.PushDownClassVariableTest categoriesFor: #testModelRemoveUnusedVariable!public!tests! !
!Refactory.Browser.Tests.PushDownClassVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.PushDownClassVariableTest categoriesFor: #testPushDownClassVariable!public!tests! !

