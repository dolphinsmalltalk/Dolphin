"Filed out from Dolphin Smalltalk 7"!

Core.Warning subclass: #'Refactory.Browser.RefactoringWarning'
	instanceVariableNames: 'refactoring'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RefactoringWarning guid: (Core.GUID fromString: '{80575ec0-f0f1-47c6-a7d6-2cb4a3440aaa}')!
Refactory.Browser.RefactoringWarning comment: ''!
!Refactory.Browser.RefactoringWarning categoriesForClass!Refactory-Support! !
!Refactory.Browser.RefactoringWarning methodsFor!

defaultAction
	"Proceed through warnings"

	^nil!

refactoring
	^refactoring!

refactoring: anObject
	refactoring := anObject! !
!Refactory.Browser.RefactoringWarning categoriesFor: #defaultAction!actions!private! !
!Refactory.Browser.RefactoringWarning categoriesFor: #refactoring!accessing!public! !
!Refactory.Browser.RefactoringWarning categoriesFor: #refactoring:!accessing!private! !

!Refactory.Browser.RefactoringWarning class methodsFor!

refactoring: aRefactoring signal: messageText
	^(self new)
		refactoring: aRefactoring;
		signal: messageText!

refactoring: aRefactoring signal: messageText with: tag
	^(self new)
		refactoring: aRefactoring;
		signal: messageText with: tag! !
!Refactory.Browser.RefactoringWarning class categoriesFor: #refactoring:signal:!public! !
!Refactory.Browser.RefactoringWarning class categoriesFor: #refactoring:signal:with:!public! !

