"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RemoveInstanceVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveInstanceVariableTest guid: (Core.GUID fromString: '{62348167-8106-437b-98fe-52a63f3b89ae}')!
Refactory.Browser.Tests.RemoveInstanceVariableTest comment: ''!
!Refactory.Browser.Tests.RemoveInstanceVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveInstanceVariableTest methodsFor!

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
	self shouldFail: (RemoveInstanceVariableRefactoring variable: 'name1' class: LintRuleTest)!

testReferencedVariable
	self shouldFail: (RemoveInstanceVariableRefactoring variable: 'name' class: LintRuleTest)!

testRemoveInstVar
	| refactoring class |
	refactoring := RemoveInstanceVariableRefactoring variable: 'foo1' class: LintRuleTest.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest'.
	self assert: (class definesInstanceVariable: 'foo1').
	self executeRefactoring: refactoring.
	self deny: (class definesInstanceVariable: 'foo1')! !
!Refactory.Browser.Tests.RemoveInstanceVariableTest categoriesFor: #testModelRemoveInstanceVariable!public!tests! !
!Refactory.Browser.Tests.RemoveInstanceVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.RemoveInstanceVariableTest categoriesFor: #testReferencedVariable!failure tests!public! !
!Refactory.Browser.Tests.RemoveInstanceVariableTest categoriesFor: #testRemoveInstVar!public!tests! !

