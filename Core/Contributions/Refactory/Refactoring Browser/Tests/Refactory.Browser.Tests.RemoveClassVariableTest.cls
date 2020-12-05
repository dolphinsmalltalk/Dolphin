"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RemoveClassVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveClassVariableTest guid: (Core.GUID fromString: '{0c64e4ad-979f-4e25-9c48-f1adeebc74b6}')!
Refactory.Browser.Tests.RemoveClassVariableTest comment: ''!
!Refactory.Browser.Tests.RemoveClassVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveClassVariableTest methodsFor!

testNonExistantName
	self shouldFail: (RemoveClassVariableRefactoring variable: #RecursiveSelfRule1
				class: TransformationRuleTest)!

testReferencedVariable
	self shouldFail: (RemoveClassVariableRefactoring variable: #RecursiveSelfRule
				class: TransformationRuleTest)!

testRemoveClassVar
	| refactoring class |
	refactoring := RemoveClassVariableRefactoring variable: 'Foo1' class: LintRuleTest.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest'.
	self assert: (class definesClassVariable: 'Foo1').
	self executeRefactoring: refactoring.
	self deny: (class definesClassVariable: 'Foo1')! !
!Refactory.Browser.Tests.RemoveClassVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.RemoveClassVariableTest categoriesFor: #testReferencedVariable!failure tests!public! !
!Refactory.Browser.Tests.RemoveClassVariableTest categoriesFor: #testRemoveClassVar!public!tests! !

