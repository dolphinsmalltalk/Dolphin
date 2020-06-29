"Filed out from Dolphin Smalltalk 7"!

Warning subclass: #RefactoringWarning
	instanceVariableNames: 'refactoring'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!RefactoringWarning categoriesFor: #defaultAction!actions!private! !
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

