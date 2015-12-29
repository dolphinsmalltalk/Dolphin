"Filed out from Dolphin Smalltalk XP"!

Warning subclass: #RefactoringWarning
	instanceVariableNames: 'refactoring'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RefactoringWarning guid: (GUID fromString: '{80575EC0-F0F1-47C6-A7D6-2CB4A3440AAA}')!
RefactoringWarning comment: ''!
!RefactoringWarning categoriesForClass!Refactory-Support! !
!RefactoringWarning methodsFor!

defaultAction
	"Proceed through warnings"

	^nil!

refactoring
	^refactoring!

refactoring: anObject
	refactoring := anObject! !
!RefactoringWarning categoriesFor: #defaultAction!private / actions!public! !
!RefactoringWarning categoriesFor: #refactoring!accessing!public! !
!RefactoringWarning categoriesFor: #refactoring:!accessing!private! !

!RefactoringWarning class methodsFor!

refactoring: aRefactoring signal: messageText
	^(self new)
		refactoring: aRefactoring;
		signal: messageText!

refactoring: aRefactoring signal: messageText with: tag
	^(self new)
		refactoring: aRefactoring;
		signal: messageText with: tag! !
!RefactoringWarning class categoriesFor: #refactoring:signal:!public! !
!RefactoringWarning class categoriesFor: #refactoring:signal:with:!public! !

