"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #RemoveInstanceVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RemoveInstanceVariableTest guid: (GUID fromString: '{62348167-8106-437b-98fe-52a63f3b89ae}')!

RemoveInstanceVariableTest comment: ''!

!RemoveInstanceVariableTest categoriesForClass!Refactory-Testing! !

!RemoveInstanceVariableTest methodsFor!

testModelRemoveInstanceVariable
	| class |
	model 
		defineClass: 'nil subclass: #Object instanceVariableNames: ''foo1'' classVariableNames: '''' poolDictionaries: '''''.
	class := model classNamed: #Object.
	self assert: (class definesInstanceVariable: 'foo1').
	self executeRefactoring: (RemoveInstanceVariableRefactoring 
				model: model
				variable: 'foo1'
				class: class).
	self deny: (class definesInstanceVariable: 'foo1')!

testNonExistantName
	self shouldFail: (RemoveInstanceVariableRefactoring variable: 'name1'
				class: LintRuleTest)!

testReferencedVariable
	self shouldFail: (RemoveInstanceVariableRefactoring variable: 'name'
				class: LintRuleTest)!

testRemoveInstVar
	| refactoring class |
	refactoring := RemoveInstanceVariableRefactoring variable: 'foo1'
				class: LintRuleTest.
	class := refactoring model classNamed: #LintRuleTest.
	self assert: (class definesInstanceVariable: 'foo1').
	self executeRefactoring: refactoring.
	self deny: (class definesInstanceVariable: 'foo1')! !

!RemoveInstanceVariableTest categoriesForMethods!
testModelRemoveInstanceVariable!public!tests! !
testNonExistantName!failure tests!public! !
testReferencedVariable!failure tests!public! !
testRemoveInstVar!public!tests! !
!

