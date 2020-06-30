"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #RemoveClassTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RemoveClassTest guid: (GUID fromString: '{32d88853-b152-4b03-9590-22d6b1be0d4d}')!
RemoveClassTest comment: ''!
!RemoveClassTest categoriesForClass!Refactory-Testing! !
!RemoveClassTest methodsFor!

testBadName
	self 
		shouldFail: (RemoveClassRefactoring classNames: #(#RecursiveSelfRule))!

testRemoveClass
	| refactoring |
	refactoring := RemoveClassRefactoring classNames: (Array with: ('Foo' , 'LintRuleTest') asSymbol).
	self executeRefactoring: refactoring.
	self assertIsNil: (refactoring model classNamed: ('Foo' , 'LintRuleTest') asSymbol).
	self assert: (refactoring model classNamed: #TransformationRuleTest) superclass
		equals: (refactoring model classNamed: #LintRuleTest)!

testRemoveReferenced
	self 
		shouldFail: (RemoveClassRefactoring classNames: #(#BasicLintRuleTest))! !
!RemoveClassTest categoriesFor: #testBadName!failure tests!public! !
!RemoveClassTest categoriesFor: #testRemoveClass!public!tests! !
!RemoveClassTest categoriesFor: #testRemoveReferenced!failure tests!public! !

