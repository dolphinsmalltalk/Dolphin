"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.PushDownClassVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.PushDownClassVariableRefactoringTest guid: (Core.GUID fromString: '{a5398930-2959-4aa2-a55c-3bce05b7412a}')!
Refactory.Browser.Tests.PushDownClassVariableRefactoringTest comment: ''!
!Refactory.Browser.Tests.PushDownClassVariableRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.PushDownClassVariableRefactoringTest methodsFor!

testModelNonExistantName
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	self shouldFail: (PushDownClassVariableRefactoring
				model: model
				variable: #Foo
				class: (model classNamed: #SomeClass))
		withMessage: 'SomeClass does not define class variable/constant #Foo'!

testModelPushDownToMultipleSubclassesFailure
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #Subclass) compile: 'foo ^Foo' classified: #accessing.
	model
		defineClass: 'SomeClass subclass: #AnotherSubclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model metaclassNamed: #AnotherSubclass) compile: 'bar ^Foo' classified: #accessing.
	self shouldFail: (PushDownClassVariableRefactoring
				model: model
				variable: #Foo
				class: (model classNamed: #SomeClass))
		withMessage: 'Multiple subclasses reference Foo'!

testModelPushDownVariable
	| class |
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	class := model classNamed: #Subclass.
	class compile: 'foo ^Foo' classified: #accessing.
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
	class compile: 'bar ^Foo' classified: #accessing.
	class := class instanceClass.
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
	class compile: 'foo ^Foo' classified: #accessing.
	model
		defineClass: 'Subclass subclass: #AnotherSubclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model metaclassNamed: #AnotherSubclass) compile: 'bar ^Foo' classified: #accessing.
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
	self shouldFail: (PushDownClassVariableRefactoring variable: #Foo class: BasicLintRuleTestData)
		withMessage: '<1p> does not define class variable/constant #Foo' << BasicLintRuleTestData!

testPushDownClassVariable
	| refactoring refDataApp sourceClass targetClass |
	"Deliberately create a (partially-qualified) reference from outside the class hierarchy - these should be rewritten too."
	refDataApp := model classFor: RefactoryTestDataApp.
	refDataApp
		compile: 'refToExternalClassVar ^{ #(#{_.LintRuleTestData.Foo1}). LintRuleTestData.Foo1. #{_.LintRuleTestData.Foo1}. #{Refactory.Browser.TestData.LintRuleTestData.Foo1}. Refactory.Browser.TestData.LintRuleTestData.Foo1 }'.
	refactoring := PushDownClassVariableRefactoring
				model: model
				variable: #Foo1
				class: LintRuleTestData.
	sourceClass := model classFor: LintRuleTestData.
	self assert: (sourceClass directlyDefinesClassVariable: #Foo1).
	targetClass := model classFor: BasicLintRuleTestData.
	self assert: (targetClass metaclass includesSelector: #foo1).
	self executeRefactoring: refactoring.
	false ifTrue: [model browseChanges].
	(sourceClass withAllSubclasses copyWithout: targetClass)
		do: [:each | self deny: (each directlyDefinesClassVariable: #Foo1)].
	self assert: (targetClass directlyDefinesClassVariable: #Foo1).
	"Note that the fully-qualified binding refs are deliberately not shorted, but anything relative is adjusted"
	self assert: (targetClass metaclass methodFor: #foo1) parseTree
		equals: (self
				parseMethod: 'foo1 ^{ Foo1. Foo1. Foo1. #(#{Foo1} #{Refactory.Browser.TestData.BasicLintRuleTestData.Foo1}). #{Foo1}. #{Refactory.Browser.TestData.BasicLintRuleTestData.Foo1} }'
				in: targetClass).
	"The external reference - can still be partially qualified because RefactoryTestDataApp is in the same namespace"
	self assert: (refDataApp methodFor: #refToExternalClassVar) parseTree
		equals: (self
				parseMethod: 'refToExternalClassVar ^{ #(#{_.BasicLintRuleTestData.Foo1}). BasicLintRuleTestData.Foo1. #{_.BasicLintRuleTestData.Foo1}. #{Refactory.Browser.TestData.BasicLintRuleTestData.Foo1}. BasicLintRuleTestData.Foo1 }'
				in: targetClass)! !
!Refactory.Browser.Tests.PushDownClassVariableRefactoringTest categoriesForMethods!
testModelNonExistantName!failure tests!public! !
testModelPushDownToMultipleSubclassesFailure!failure tests!public! !
testModelPushDownVariable!public!tests! !
testModelPushDownVariableToClassDownTwoLevels!public!tests! !
testModelPushDownVariableToMultipleClassesInSameHierarchy!public!tests! !
testModelRemoveUnusedVariable!public!tests! !
testNonExistantName!failure tests!public! !
testPushDownClassVariable!public!tests! !
!

