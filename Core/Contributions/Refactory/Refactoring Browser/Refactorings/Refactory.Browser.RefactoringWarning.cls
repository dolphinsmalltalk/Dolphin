"Filed out from Dolphin Smalltalk"!

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
!Refactory.Browser.RefactoringWarning categoriesForMethods!
defaultAction!actions!private! !
refactoring!accessing!public! !
refactoring:!accessing!private! !
!

!Refactory.Browser.RefactoringWarning class methodsFor!

refactoring: aRefactoring signal: messageText
	^(self new)
		refactoring: aRefactoring;
		signal: messageText!

refactoring: aRefactoring signal: messageText with: tag
	^(self new)
		refactoring: aRefactoring;
		signal: messageText with: tag! !
!Refactory.Browser.RefactoringWarning class categoriesForMethods!
refactoring:signal:!public! !
refactoring:signal:with:!public! !
!

