"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'Core.UserInterrupt'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.UserInterrupt guid: (Core.GUID fromString: '{5849154d-f230-48ea-bb88-085119c1d0e1}')!

Core.UserInterrupt comment: ''!

!Core.UserInterrupt methodsFor!

defaultMessageText
	^'User Interrupt'!

isResumable
	"Answer whether the receiver represents a resumable error."

	^true!

isUserResumable
	"Answer whether the user should be given the option of resuming when prompted with regard to this exception."

	^true! !

!Core.UserInterrupt categoriesForMethods!
defaultMessageText!accessing!private! !
isResumable!public!testing! !
isUserResumable!public!testing! !
!

