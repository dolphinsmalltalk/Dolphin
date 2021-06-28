"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RenameMethodRefactoring subclass: #'Tools.RenameMethodReferencesRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Refactory.Browser})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.RenameMethodReferencesRefactoring guid: (Core.GUID fromString: '{721e4622-9483-4d18-a01f-8c2ae241b26b}')!
Tools.RenameMethodReferencesRefactoring comment: 'RenameMethodReferencesRefactoring is a specialisation of the <RenameMethodRefactoring> that does not rename any implementors. This can be useful when one wishes to adapt code using one selector to another, and occurrence one frequently encounters when porting code from one Smalltalk to another. Note that this may not be behaviour preserving.'!
!Tools.RenameMethodReferencesRefactoring categoriesForClass!Refactory-Refactorings! !
!Tools.RenameMethodReferencesRefactoring methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPutAll: 'Replace References to ';
		print: oldSelector;
		nextPutAll: ' with ';
		print: newSelector!

initialize
	implementors := #()!

preconditions
	^super preconditions 
		& (RBCondition hierarchyOf: class canUnderstand: newSelector) 
			& (RBCondition withBlock: 
						[self 
							refactoringWarning: 'Renaming method references may not preserve behaviour.'.
						true])! !
!Tools.RenameMethodReferencesRefactoring categoriesFor: #displayOn:!displaying!public! !
!Tools.RenameMethodReferencesRefactoring categoriesFor: #initialize!initializing!public! !
!Tools.RenameMethodReferencesRefactoring categoriesFor: #preconditions!preconditions!public! !

