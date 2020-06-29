"Filed out from Dolphin Smalltalk 7"!

RenameMethodRefactoring subclass: #RenameMethodReferencesRefactoring
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RenameMethodReferencesRefactoring guid: (GUID fromString: '{721e4622-9483-4d18-a01f-8c2ae241b26b}')!
RenameMethodReferencesRefactoring comment: 'RenameMethodReferencesRefactoring is a specialisation of the <RenameMethodRefactoring> that does not rename any implementors. This can be useful when one wishes to adapt code using one selector to another, and occurrence one frequently encounters when porting code from one Smalltalk to another. Note that this may not be behaviour preserving.'!
!RenameMethodReferencesRefactoring categoriesForClass!Refactory-Refactorings! !
!RenameMethodReferencesRefactoring methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream 
		nextPutAll: 'Replace References to ';
		print: oldSelector;
		nextPutAll: ' with ';
		print: newSelector
!

initialize
	implementors := #()!

preconditions
	^super preconditions 
		& (RBCondition hierarchyOf: class canUnderstand: newSelector) 
			& (RBCondition withBlock: 
						[self 
							refactoringWarning: 'Renaming method references may not preserve behaviour.'.
						true])! !
!RenameMethodReferencesRefactoring categoriesFor: #displayOn:!displaying!public! !
!RenameMethodReferencesRefactoring categoriesFor: #initialize!initializing!public! !
!RenameMethodReferencesRefactoring categoriesFor: #preconditions!preconditions!public! !

