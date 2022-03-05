"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #RemoveMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveMethodTest guid: (GUID fromString: '{c62df609-c02a-4070-ae2d-e28d2e5b1603}')!
RemoveMethodTest comment: ''!
!RemoveMethodTest categoriesForClass!Refactory-Testing! !
!RemoveMethodTest methodsFor!

testModelRecursiveMethodThatIsNotReferencedFromOtherMethods
	| class otherClass |
	class := model classNamed: #Object.
	class compile: 'someMethodThatIsNotReferenced ^2' classified: #(#accessing).
	self assert: (class definesMethod: #someMethodThatIsNotReferenced).
	otherClass := model metaclassNamed: self class superclass name.
	otherClass 
		compile: 'someMethodThatIsNotReferenced ^3 someMethodThatIsNotReferenced'
		classified: #(#accessing).
	model removeClassNamed: self class name.
	self executeRefactoring: (RemoveMethodRefactoring 
				model: model
				removeMethods: #(#someMethodThatIsNotReferenced)
				from: class).
	self deny: (class definesMethod: #someMethodThatIsNotReferenced)!

testRemoveMethod
	| refactoring selectors |
	selectors := Array with: ('selectorNot' , 'Referenced') asSymbol.
	refactoring := RemoveMethodRefactoring removeMethods: selectors
				from: RefactoryTestDataApp.
	self assert: ((refactoring model classNamed: #RefactoryTestDataApp) 
				directlyDefinesMethod: selectors first).
	self executeRefactoring: refactoring.
	self deny: ((refactoring model classNamed: #RefactoryTestDataApp) 
				directlyDefinesMethod: selectors first)!

testRemoveReferenced
	self shouldFail: (RemoveMethodRefactoring removeMethods: #(#checkClass:)
				from: BasicLintRuleTest)!

testRemoveSameMethodButSendsSuper
	self shouldWarn: (RemoveMethodRefactoring removeMethods: #(#new)
				from: BasicLintRuleTest class)! !
!RemoveMethodTest categoriesForMethods!
testModelRecursiveMethodThatIsNotReferencedFromOtherMethods!public!tests! !
testRemoveMethod!public!tests! !
testRemoveReferenced!failure tests!public! !
testRemoveSameMethodButSendsSuper!failure tests!public! !
!

