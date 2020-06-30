"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #RemoveClassVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RemoveClassVariableTest guid: (GUID fromString: '{0c64e4ad-979f-4e25-9c48-f1adeebc74b6}')!
RemoveClassVariableTest comment: ''!
!RemoveClassVariableTest categoriesForClass!Refactory-Testing! !
!RemoveClassVariableTest methodsFor!

testNonExistantName
	self 
		shouldFail: (RemoveClassVariableRefactoring variable: #RecursiveSelfRule1
				class: TransformationRuleTest)!

testReferencedVariable
	self 
		shouldFail: (RemoveClassVariableRefactoring variable: #RecursiveSelfRule
				class: TransformationRuleTest)!

testRemoveClassVar
	| refactoring class |
	refactoring := RemoveClassVariableRefactoring variable: 'Foo1'
				class: LintRuleTest.
	class := refactoring model classNamed: #LintRuleTest.
	self assert: (class definesClassVariable: 'Foo1').
	self executeRefactoring: refactoring.
	self deny: (class definesClassVariable: 'Foo1')! !
!RemoveClassVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!RemoveClassVariableTest categoriesFor: #testReferencedVariable!failure tests!public! !
!RemoveClassVariableTest categoriesFor: #testRemoveClassVar!public!tests! !

