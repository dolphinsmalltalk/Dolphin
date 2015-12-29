"Filed out from Dolphin Smalltalk XP 2002 release 5.05"!

VariableRefactoring subclass: #PullUpInstanceVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PullUpInstanceVariableRefactoring guid: (GUID fromString: '{7845EE3C-DFB0-412E-8FA3-318FDFDD63C2}')!
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
!PullUpInstanceVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!PullUpInstanceVariableRefactoring categoriesFor: #transform!public!transforming! !

