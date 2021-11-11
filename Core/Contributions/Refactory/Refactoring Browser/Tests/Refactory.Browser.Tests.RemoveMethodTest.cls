"Filed out from Dolphin Smalltalk"!

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
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp')
				directlyDefinesMethod: selectors first).
	self executeRefactoring: refactoring.
	self deny: ((refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp')
				directlyDefinesMethod: selectors first)!

testRemoveReferenced
	| subject senders selector |
	model := RBNamespace
				onEnvironment: (BrowserEnvironment new forClasses: {SmalllintChecker. BasicLintRuleTestData}).
	subject := RemoveMethodRefactoring
				model: model
				removeMethods: #(#checkClass:)
				from: BasicLintRuleTestData.
	subject setOption: #removeReferencedSelector
		toUse: 
			[:ref :symbol :references |
			senders := references.
			selector := symbol.
			false].
	self shouldAbort: subject.
	self assert: selector equals: #checkClass:.
	self assert: senders single printString equals: 'Refactory.Browser.SmalllintChecker>>#run'!

testRemoveSameMethodButSendsSuper
	self shouldWarn: (RemoveMethodRefactoring removeMethods: #(#new) from: BasicLintRuleTestData class)! !
!Refactory.Browser.Tests.RemoveMethodTest categoriesForMethods!
testModelRecursiveMethodThatIsNotReferencedFromOtherMethods!public!tests! !
testRemoveMethod!public!tests! !
testRemoveReferenced!failure tests!public! !
testRemoveSameMethodButSendsSuper!failure tests!public! !
!

