"Filed out from Dolphin Smalltalk"!

VariableRefactoring subclass: #PullUpInstanceVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PullUpInstanceVariableRefactoring guid: (GUID fromString: '{7845ee3c-dfb0-412e-8fa3-318fdfdd63c2}')!

PullUpInstanceVariableRefactoring comment: ''!

!PullUpInstanceVariableRefactoring categoriesForClass!Refactory-Refactorings! !

!PullUpInstanceVariableRefactoring methodsFor!

preconditions
	^RBCondition withBlock: 
			[(class hierarchyDefinesInstanceVariable: variableName) 
				ifFalse: [self refactoringError: 'No subclass defines ' , variableName].
			(class subclasses 
				anySatisfy: [:each | (each directlyDefinesInstanceVariable: variableName) not]) 
					ifTrue: 
						[self 
							refactoringWarning: 'Not all subclasses have an instance variable named ' , variableName 
									, '.'].
			true]!

transform
	class allSubclasses do: 
			[:each | 
			(each directlyDefinesInstanceVariable: variableName) 
				ifTrue: [each removeInstanceVariable: variableName]].
	class addInstanceVariable: variableName! !

!PullUpInstanceVariableRefactoring categoriesForMethods!
preconditions!preconditions!public! !
transform!public!transforming! !
!

