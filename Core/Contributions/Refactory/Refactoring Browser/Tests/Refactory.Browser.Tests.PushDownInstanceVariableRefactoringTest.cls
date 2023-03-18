"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.PushDownInstanceVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.PushDownInstanceVariableRefactoringTest guid: (Core.GUID fromString: '{69faf87f-a963-4715-ba17-dc564b648dde}')!
Refactory.Browser.Tests.PushDownInstanceVariableRefactoringTest comment: ''!
!Refactory.Browser.Tests.PushDownInstanceVariableRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.PushDownInstanceVariableRefactoringTest methodsFor!

testModelPushDownToMetaclass
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model metaclassNamed: #SomeClass) addInstanceVariable: 'foo'.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model metaclassNamed: #Subclass) compile: 'foo ^foo' classified: #accessing.
	self executeRefactoring: (PushDownInstanceVariableRefactoring
				model: model
				variable: 'foo'
				class: (model metaclassNamed: #SomeClass)).
	self deny: ((model metaclassNamed: #SomeClass) directlyDefinesVariable: 'foo').
	self assert: ((model metaclassNamed: #Subclass) directlyDefinesVariable: 'foo')!

testModelPushDownToMultipleSubclasses
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: ''foo'' classVariableNames: '''' poolDictionaries: '''''.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #Subclass) compile: 'foo ^foo' classified: #accessing.
	model
		defineClass: 'SomeClass subclass: #AnotherSubclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #AnotherSubclass) compile: 'bar ^foo' classified: #accessing.
	self executeRefactoring: (PushDownInstanceVariableRefactoring
				model: model
				variable: 'foo'
				class: (model classNamed: #SomeClass)).
	self deny: ((model classNamed: #SomeClass) directlyDefinesVariable: 'foo').
	self assert: ((model classNamed: #Subclass) directlyDefinesVariable: 'foo').
	self assert: ((model classNamed: #AnotherSubclass) directlyDefinesVariable: 'foo')!

testModelRemoveUnusedVariable
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: ''foo'' classVariableNames: '''' poolDictionaries: '''''.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	self executeRefactoring: (PushDownInstanceVariableRefactoring
				model: model
				variable: 'foo'
				class: (model classNamed: #SomeClass)).
	self deny: ((model classNamed: #SomeClass) directlyDefinesVariable: 'foo').
	self deny: ((model classNamed: #Subclass) directlyDefinesVariable: 'foo')!

testNonExistantName
	self shouldFail: (PushDownInstanceVariableRefactoring variable: 'foo' class: BasicLintRuleTestData)
		withMessage: 'BasicLintRuleTestData does not define an instance variable ''foo'''!

testPushDownInstanceVariable
	| refactoring |
	refactoring := PushDownInstanceVariableRefactoring variable: 'foo1' class: LintRuleTestData.
	self executeRefactoring: refactoring.
	(refactoring model classFor: LintRuleTestData) withAllSubclasses
		do: [:each | self deny: (each directlyDefinesInstanceVariable: 'foo1')]! !
!Refactory.Browser.Tests.PushDownInstanceVariableRefactoringTest categoriesForMethods!
testModelPushDownToMetaclass!public!tests! !
testModelPushDownToMultipleSubclasses!public!tests! !
testModelRemoveUnusedVariable!public!tests! !
testNonExistantName!failure tests!public! !
testPushDownInstanceVariable!public!tests! !
!

