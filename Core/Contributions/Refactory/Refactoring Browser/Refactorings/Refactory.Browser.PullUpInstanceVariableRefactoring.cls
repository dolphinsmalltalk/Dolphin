"Filed out from Dolphin Smalltalk"!

Refactory.Browser.VariableRefactoring
	subclass: #'Refactory.Browser.PullUpInstanceVariableRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.PullUpInstanceVariableRefactoring guid: (Core.GUID fromString: '{7845ee3c-dfb0-412e-8fa3-318fdfdd63c2}')!
Refactory.Browser.PullUpInstanceVariableRefactoring comment: ''!
!Refactory.Browser.PullUpInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.PullUpInstanceVariableRefactoring methodsFor!

preconditions
	^RBCondition withBlock: 
			[(class hierarchyDefinesInstanceVariable: variableName)
				ifFalse: [self refactoringError: 'No subclass defines ' , variableName].
			(class subclasses anySatisfy: [:each | (each directlyDefinesInstanceVariable: variableName) not])
				ifTrue: [(self shouldPullUpNonSharedInstanceVariable: variableName) ifFalse: [self refactoringAborted]].
			true]!

transform
	class allSubclasses do: 
			[:each | 
			(each directlyDefinesInstanceVariable: variableName) 
				ifTrue: [each removeInstanceVariable: variableName]].
	class addInstanceVariable: variableName! !
!Refactory.Browser.PullUpInstanceVariableRefactoring categoriesForMethods!
preconditions!preconditions!public! !
transform!public!transforming! !
!

