"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RemoveInstanceVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveInstanceVariableRefactoringTest guid: (Core.GUID fromString: '{62348167-8106-437b-98fe-52a63f3b89ae}')!
Refactory.Browser.Tests.RemoveInstanceVariableRefactoringTest comment: ''!
!Refactory.Browser.Tests.RemoveInstanceVariableRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveInstanceVariableRefactoringTest methodsFor!

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
	self shouldFail: (RemoveInstanceVariableRefactoring variable: 'name1' class: LintRuleTestData)
		withMessage: 'LintRuleTestData does not define an instance variable ''name1'''!

testReferencedVariable
	self shouldFail: (RemoveInstanceVariableRefactoring variable: 'name' class: LintRuleTestData)
		withMessage: '''name'' is still referenced.

Browse references?'!

testRemoveInstVar
	| refactoring class |
	refactoring := RemoveInstanceVariableRefactoring variable: 'foo1' class: LintRuleTestData.
	class := refactoring model classFor: LintRuleTestData.
	self assert: (class definesInstanceVariable: 'foo1').
	self executeRefactoring: refactoring.
	self deny: (class definesInstanceVariable: 'foo1')! !
!Refactory.Browser.Tests.RemoveInstanceVariableRefactoringTest categoriesForMethods!
testModelRemoveInstanceVariable!public!tests! !
testNonExistantName!failure tests!public! !
testReferencedVariable!failure tests!public! !
testRemoveInstVar!public!tests! !
!

