"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.RemoveMethodRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveMethodRefactoringTest guid: (Core.GUID fromString: '{c62df609-c02a-4070-ae2d-e28d2e5b1603}')!
Refactory.Browser.Tests.RemoveMethodRefactoringTest comment: ''!
!Refactory.Browser.Tests.RemoveMethodRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveMethodRefactoringTest methodsFor!

testModelRecursiveMethodThatIsNotReferencedFromOtherMethods
	| class otherClass |
	class := model classNamed: #'Core.Object'.
	class compile: 'someMethodThatIsNotReferenced ^2' classified: #accessing.
	self assert: (class definesMethod: #someMethodThatIsNotReferenced).
	otherClass := model metaclassNamed: self class superclass fullName.
	otherClass compile: 'someMethodThatIsNotReferenced ^3 someMethodThatIsNotReferenced'
		classified: #accessing.
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
	self
		assert: ((refactoring model classFor: RefactoryTestDataApp) directlyDefinesMethod: selectors first).
	self executeRefactoring: refactoring.
	self
		deny: ((refactoring model classFor: RefactoryTestDataApp) directlyDefinesMethod: selectors first)!

testRemoveReferenced
	| subject |
	model := RBModel
				onEnvironment: (BrowserEnvironment new forClasses: {SmalllintChecker. BasicLintRuleTestData}).
	subject := RemoveMethodRefactoring
				model: model
				removeMethods: #(#checkClass:)
				from: BasicLintRuleTestData.
	subject setOption: #removeReferencedSelector
		toUse: 
			[:ref :symbol :references |
			self assert: references single printString equals: SmalllintChecker shortName , '>>#run'.
			self assert: symbol equals: #checkClass:.
			false].
	self shouldAbort: subject!

testRemoveSameMethodButSendsSuper
	| refactoring |
	refactoring := RemoveMethodRefactoring removeMethods: #(#new) from: BasicLintRuleTestData class.
	refactoring setOption: #removeDuplicatesWithSupersends
		toUse: 
			[:ref :selectors |
			self assert: selectors asArray equals: #(#new).
			true].
	self executeRefactoring: refactoring! !
!Refactory.Browser.Tests.RemoveMethodRefactoringTest categoriesForMethods!
testModelRecursiveMethodThatIsNotReferencedFromOtherMethods!public!tests! !
testRemoveMethod!public!tests! !
testRemoveReferenced!failure tests!public! !
testRemoveSameMethodButSendsSuper!failure tests!public! !
!

