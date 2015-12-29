"Filed out from Dolphin Smalltalk 2000 release 5.00"!

Error subclass: #RefactoringError
	instanceVariableNames: 'refactoring'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RefactoringError guid: (GUID fromString: '{FD7B54C9-922A-4CFF-9037-B84F75478283}')!
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
!RefactoringError class categoriesFor: #refactoring:signal:!*-unclassified!public! !
!RefactoringError class categoriesFor: #refactoring:signal:with:!*-unclassified!public! !

