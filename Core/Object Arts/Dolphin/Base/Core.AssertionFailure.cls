"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'Core.AssertionFailure'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.AssertionFailure guid: (Core.GUID fromString: '{1434af3c-bb17-479e-9835-a17782ba3fce}')!

Core.AssertionFailure comment: ''!

!Core.AssertionFailure methodsFor!

defaultMessageText
	^'Assertion Failure'!

isResumable
	"Answer whether the receiver represents a resumable error."

	^true! !

!Core.AssertionFailure categoriesForMethods!
defaultMessageText!accessing!private! !
isResumable!public!testing! !
!

