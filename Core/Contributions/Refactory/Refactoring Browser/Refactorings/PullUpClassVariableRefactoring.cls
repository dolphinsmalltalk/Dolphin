"Filed out from Dolphin Smalltalk"!

VariableRefactoring subclass: #PullUpClassVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PullUpClassVariableRefactoring guid: (GUID fromString: '{78a67e45-73e9-4f56-b6f1-38e6886593bf}')!

PullUpClassVariableRefactoring comment: ''!

!PullUpClassVariableRefactoring categoriesForClass!Refactory-Refactorings! !

!PullUpClassVariableRefactoring methodsFor!

preconditions
	^(RBCondition isMetaclass: class) not!

subclassDefiningVariable
	| subclasses |
	subclasses := class allSubclasses 
				select: [:each | each directlyDefinesClassVariable: variableName].
	subclasses isEmpty 
		ifTrue: 
			[self refactoringError: 'Could not find a class defining ' , variableName].
	subclasses size > 1 
		ifTrue: [self refactoringError: 'Multiple subclasses define ' , variableName].
	^subclasses asArray first!

transform
	| subclass |
	subclass := self subclassDefiningVariable.
	subclass removeClassVariable: variableName.
	class addClassVariable: variableName! !

!PullUpClassVariableRefactoring categoriesForMethods!
preconditions!preconditions!public! !
subclassDefiningVariable!accessing!private! !
transform!public!transforming! !
!

