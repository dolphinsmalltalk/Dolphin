"Filed out from Dolphin Smalltalk"!

Warning subclass: #RefactoringWarning
	instanceVariableNames: 'refactoring'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RefactoringWarning guid: (GUID fromString: '{80575ec0-f0f1-47c6-a7d6-2cb4a3440aaa}')!
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
!RefactoringWarning categoriesForMethods!
defaultAction!actions!private! !
refactoring!accessing!public! !
refactoring:!accessing!private! !
!

!RefactoringWarning class methodsFor!

refactoring: aRefactoring signal: messageText
	^(self new)
		refactoring: aRefactoring;
		signal: messageText!

refactoring: aRefactoring signal: messageText with: tag
	^(self new)
		refactoring: aRefactoring;
		signal: messageText with: tag! !
!RefactoringWarning class categoriesForMethods!
refactoring:signal:!public! !
refactoring:signal:with:!public! !
!

