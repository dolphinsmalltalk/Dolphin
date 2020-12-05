"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.PushDownInstanceVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.PushDownInstanceVariableTest guid: (Core.GUID fromString: '{69faf87f-a963-4715-ba17-dc564b648dde}')!
Refactory.Browser.Tests.PushDownInstanceVariableTest comment: ''!
!Refactory.Browser.Tests.PushDownInstanceVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.PushDownInstanceVariableTest methodsFor!

testModelPushDownToMetaclass
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model metaclassNamed: #SomeClass) addInstanceVariable: 'foo'.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model metaclassNamed: #Subclass) compile: 'foo ^foo' classified: #(#accessing).
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
	(model classNamed: #Subclass) compile: 'foo ^foo' classified: #(#accessing).
	model
		defineClass: 'SomeClass subclass: #AnotherSubclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #AnotherSubclass) compile: 'bar ^foo' classified: #(#accessing).
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
	self shouldFail: (PushDownInstanceVariableRefactoring variable: 'foo' class: BasicLintRuleTest)!

testPushDownInstanceVariable
	| refactoring |
	refactoring := PushDownInstanceVariableRefactoring variable: 'foo1' class: LintRuleTest.
	self executeRefactoring: refactoring.
	(refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest') withAllSubclasses
		do: [:each | self deny: (each directlyDefinesInstanceVariable: 'foo1')]! !
!Refactory.Browser.Tests.PushDownInstanceVariableTest categoriesFor: #testModelPushDownToMetaclass!public!tests! !
!Refactory.Browser.Tests.PushDownInstanceVariableTest categoriesFor: #testModelPushDownToMultipleSubclasses!public!tests! !
!Refactory.Browser.Tests.PushDownInstanceVariableTest categoriesFor: #testModelRemoveUnusedVariable!public!tests! !
!Refactory.Browser.Tests.PushDownInstanceVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.PushDownInstanceVariableTest categoriesFor: #testPushDownInstanceVariable!public!tests! !

