"Filed out from Dolphin Smalltalk 7"!

Error subclass: #RefactoringError
	instanceVariableNames: 'refactoring'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RefactoringError guid: (GUID fromString: '{fd7b54c9-922a-4cff-9037-b84f75478283}')!
RefactoringError comment: ''!
!RefactoringError categoriesForClass!Refactory-Support! !
!RefactoringError methodsFor!

refactoring
	^refactoring!

refactoring: anObject
	refactoring := anObject! !
!RefactoringError categoriesFor: #refactoring!accessing!public! !
!RefactoringError categoriesFor: #refactoring:!accessing!private! !

!RefactoringError class methodsFor!

refactoring: aRefactoring signal: messageText
	^(self new)
		refactoring: aRefactoring;
		signal: messageText!

refactoring: aRefactoring signal: messageText with: tag
	^(self new)
		refactoring: aRefactoring;
		signal: messageText with: tag! !
!RefactoringError class categoriesFor: #refactoring:signal:!public! !
!RefactoringError class categoriesFor: #refactoring:signal:with:!public! !

