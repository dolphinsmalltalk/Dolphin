"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RemoveMethodTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveMethodTest guid: (Core.GUID fromString: '{c62df609-c02a-4070-ae2d-e28d2e5b1603}')!
Refactory.Browser.Tests.RemoveMethodTest comment: ''!
!Refactory.Browser.Tests.RemoveMethodTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveMethodTest methodsFor!

testModelRecursiveMethodThatIsNotReferencedFromOtherMethods
	| class otherClass |
	class := model classNamed: #'Core.Object'.
	class compile: 'someMethodThatIsNotReferenced ^2' classified: #(#accessing).
	self assert: (class definesMethod: #someMethodThatIsNotReferenced).
	otherClass := model metaclassNamed: self class superclass fullName.
	otherClass compile: 'someMethodThatIsNotReferenced ^3 someMethodThatIsNotReferenced'
		classified: #(#accessing).
	model removeClassNamed: self class fullName.
	self executeRefactoring: (RemoveMethodRefactoring
				model: model
				removeMethods: #(#someMethodThatIsNotReferenced)
				from: class).
	self deny: (class definesMethod: #someMethodThatIsNotReferenced)!

testRemoveMethod
	| refactoring selectors |
	selectors := {('selectorNot' , 'Referenced') asSymbol}.
	refactoring := RemoveMethodRefactoring removeMethods: selectors from: RefactoryTestDataApp.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp')
				directlyDefinesMethod: selectors first).
	self executeRefactoring: refactoring.
	self deny: ((refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp')
				directlyDefinesMethod: selectors first)!

testRemoveReferenced
	self shouldFail: (RemoveMethodRefactoring removeMethods: #(#checkClass:) from: BasicLintRuleTest)!

testRemoveSameMethodButSendsSuper
	self shouldWarn: (RemoveMethodRefactoring removeMethods: #(#new) from: BasicLintRuleTest class)! !
!Refactory.Browser.Tests.RemoveMethodTest categoriesFor: #testModelRecursiveMethodThatIsNotReferencedFromOtherMethods!public!tests! !
!Refactory.Browser.Tests.RemoveMethodTest categoriesFor: #testRemoveMethod!public!tests! !
!Refactory.Browser.Tests.RemoveMethodTest categoriesFor: #testRemoveReferenced!failure tests!public! !
!Refactory.Browser.Tests.RemoveMethodTest categoriesFor: #testRemoveSameMethodButSendsSuper!failure tests!public! !

