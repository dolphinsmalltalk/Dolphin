"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RemoveClassTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveClassTest guid: (Core.GUID fromString: '{32d88853-b152-4b03-9590-22d6b1be0d4d}')!
Refactory.Browser.Tests.RemoveClassTest comment: ''!
!Refactory.Browser.Tests.RemoveClassTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveClassTest methodsFor!

testBadName
	self shouldFail: (RemoveClassRefactoring classNames: #(#RecursiveSelfRule))!

testRemoveClass
	| refactoring |
	refactoring := RemoveClassRefactoring classNames: {FooLintRuleTest fullName}.
	self executeRefactoring: refactoring.
	self assertIsNil: (refactoring model classNamed: FooLintRuleTest fullName).
	self assert: (refactoring model classNamed: TransformationRuleTest fullName) superclass
		equals: (refactoring model classNamed: LintRuleTest fullName)!

testRemoveReferenced
	self
		shouldFail: (RemoveClassRefactoring classNames: #(#'Refactory.Browser.Tests.BasicLintRuleTest'))! !
!Refactory.Browser.Tests.RemoveClassTest categoriesFor: #testBadName!failure tests!public! !
!Refactory.Browser.Tests.RemoveClassTest categoriesFor: #testRemoveClass!public!tests! !
!Refactory.Browser.Tests.RemoveClassTest categoriesFor: #testRemoveReferenced!failure tests!public! !

