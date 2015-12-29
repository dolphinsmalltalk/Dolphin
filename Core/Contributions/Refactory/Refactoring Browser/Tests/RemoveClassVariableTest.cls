"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RefactoringTest subclass: #RemoveClassVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveClassVariableTest comment: ''!

RemoveClassVariableTest guid: (GUID fromString: '{0C64E4AD-979F-4E25-9C48-F1ADEEBC74B6}')!

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

