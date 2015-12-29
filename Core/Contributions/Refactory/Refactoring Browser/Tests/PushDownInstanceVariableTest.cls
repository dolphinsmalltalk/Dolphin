"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RefactoringTest subclass: #PushDownInstanceVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PushDownInstanceVariableTest comment: ''!

PushDownInstanceVariableTest guid: (GUID fromString: '{69FAF87F-A963-4715-BA17-DC564B648DDE}')!

!PushDownInstanceVariableTest categoriesForClass!Refactory-Testing! !
!PushDownInstanceVariableTest methodsFor!

testModelPushDownToMetaclass
	model 
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model metaclassNamed: #SomeClass) addInstanceVariable: 'foo'.
	model 
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model metaclassNamed: #Subclass) compile: 'foo ^foo'
		classified: #(#accessing).
	self executeRefactoring: (PushDownInstanceVariableRefactoring 
				model: model
				variable: 'foo'
				class: (model metaclassNamed: #SomeClass)).
	self 
		deny: ((model metaclassNamed: #SomeClass) directlyDefinesVariable: 'foo').
	self 
		assert: ((model metaclassNamed: #Subclass) directlyDefinesVariable: 'foo')!

testModelPushDownToMultipleSubclasses
	model 
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: ''foo'' classVariableNames: '''' poolDictionaries: '''''.
	model 
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #Subclass) compile: 'foo ^foo' classified: #(#accessing).
	model 
		defineClass: 'SomeClass subclass: #AnotherSubclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #AnotherSubclass) compile: 'bar ^foo'
		classified: #(#accessing).
	self executeRefactoring: (PushDownInstanceVariableRefactoring 
				model: model
				variable: 'foo'
				class: (model classNamed: #SomeClass)).
	self deny: ((model classNamed: #SomeClass) directlyDefinesVariable: 'foo').
	self 
		assert: ((model classNamed: #Subclass) directlyDefinesVariable: 'foo').
	self assert: ((model classNamed: #AnotherSubclass) 
				directlyDefinesVariable: 'foo')!

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
	self shouldFail: (PushDownInstanceVariableRefactoring variable: 'foo'
				class: BasicLintRuleTest)!

testPushDownInstanceVariable
	| refactoring |
	refactoring := PushDownInstanceVariableRefactoring variable: 'foo1'
				class: LintRuleTest.
	self executeRefactoring: refactoring.
	(refactoring model classNamed: #LintRuleTest) withAllSubclasses 
		do: [:each | self deny: (each directlyDefinesInstanceVariable: 'foo1')]! !
!PushDownInstanceVariableTest categoriesFor: #testModelPushDownToMetaclass!public!tests! !
!PushDownInstanceVariableTest categoriesFor: #testModelPushDownToMultipleSubclasses!public!tests! !
!PushDownInstanceVariableTest categoriesFor: #testModelRemoveUnusedVariable!public!tests! !
!PushDownInstanceVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!PushDownInstanceVariableTest categoriesFor: #testPushDownInstanceVariable!public!tests! !

