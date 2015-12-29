"Filed out from Dolphin Smalltalk XP"!

RefactoringTest subclass: #RemoveMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveMethodTest guid: (GUID fromString: '{C62DF609-C02A-4070-AE2D-E28D2E5B1603}')!
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
!RemoveMethodTest categoriesFor: #testModelRecursiveMethodThatIsNotReferencedFromOtherMethods!public!tests! !
!RemoveMethodTest categoriesFor: #testRemoveMethod!public!tests! !
!RemoveMethodTest categoriesFor: #testRemoveReferenced!failure tests!public! !
!RemoveMethodTest categoriesFor: #testRemoveSameMethodButSendsSuper!failure tests!public! !

