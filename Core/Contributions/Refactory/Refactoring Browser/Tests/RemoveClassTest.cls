"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #RemoveClassTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveClassTest guid: (GUID fromString: '{32D88853-B152-4B03-9590-22D6B1BE0D4D}')!
RemoveClassTest comment: ''!
!RemoveClassTest categoriesForClass!Refactory-Testing! !
!RemoveClassTest methodsFor!

testBadName
	self 
		shouldFail: (RemoveClassRefactoring classNames: #(#RecursiveSelfRule))!

testRemoveClass
	| refactoring |
	refactoring := RemoveClassRefactoring 
				classNames: (Array with: ('Foo' , 'LintRuleTest') asSymbol).
	self executeRefactoring: refactoring.
	self 
		assert: (refactoring model classNamed: ('Foo' , 'LintRuleTest') asSymbol) 
				isNil.
	self 
		assert: (refactoring model classNamed: #TransformationRuleTest) superclass 
				= (refactoring model classNamed: #LintRuleTest)!

testRemoveReferenced
	self 
		shouldFail: (RemoveClassRefactoring classNames: #(#BasicLintRuleTest))! !
!RemoveClassTest categoriesFor: #testBadName!failure tests!public! !
!RemoveClassTest categoriesFor: #testRemoveClass!public!tests! !
!RemoveClassTest categoriesFor: #testRemoveReferenced!failure tests!public! !

