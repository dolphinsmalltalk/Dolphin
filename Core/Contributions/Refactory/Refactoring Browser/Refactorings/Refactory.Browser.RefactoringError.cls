"Filed out from Dolphin Smalltalk 7"!

Core.Error subclass: #'Refactory.Browser.RefactoringError'
	instanceVariableNames: 'refactoring'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RefactoringError guid: (Core.GUID fromString: '{fd7b54c9-922a-4cff-9037-b84f75478283}')!
Refactory.Browser.RefactoringError comment: ''!
!Refactory.Browser.RefactoringError categoriesForClass!Refactory-Support! !
!Refactory.Browser.RefactoringError methodsFor!

refactoring
	^refactoring!

refactoring: anObject
	refactoring := anObject! !
!Refactory.Browser.RefactoringError categoriesFor: #refactoring!accessing!public! !
!Refactory.Browser.RefactoringError categoriesFor: #refactoring:!accessing!private! !

!Refactory.Browser.RefactoringError class methodsFor!

refactoring: aRefactoring signal: messageText
	^(self new)
		refactoring: aRefactoring;
		signal: messageText!

refactoring: aRefactoring signal: messageText with: tag
	^(self new)
		refactoring: aRefactoring;
		signal: messageText with: tag! !
!Refactory.Browser.RefactoringError class categoriesFor: #refactoring:signal:!public! !
!Refactory.Browser.RefactoringError class categoriesFor: #refactoring:signal:with:!public! !

