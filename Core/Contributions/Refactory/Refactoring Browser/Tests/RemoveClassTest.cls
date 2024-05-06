"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #RemoveClassTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!RemoveClassTest categoriesForMethods!
testBadName!failure tests!public! !
testRemoveClass!public!tests! !
testRemoveReferenced!failure tests!public! !
!

