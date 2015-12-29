"Filed out from Dolphin Smalltalk 2000 release 5.00"!

VariableRefactoring subclass: #PullUpClassVariableRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PullUpClassVariableRefactoring guid: (GUID fromString: '{78A67E45-73E9-4F56-B6F1-38E6886593BF}')!
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
!PullUpClassVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!PullUpClassVariableRefactoring categoriesFor: #subclassDefiningVariable!private/accessing!public! !
!PullUpClassVariableRefactoring categoriesFor: #transform!public!transforming! !

