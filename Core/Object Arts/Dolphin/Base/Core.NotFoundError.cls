"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'Core.NotFoundError'
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.NotFoundError guid: (Core.GUID fromString: '{87b4c55e-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.NotFoundError comment: ''!
!Core.NotFoundError categoriesForClass!Kernel-Exception Handling! !
!Core.NotFoundError methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'Not found: %2'!

receiver
	"Answer the object which generated the error."
	
	^receiver!

receiver: anObject
	"Set the object which generated the error to be anObject"
	
	receiver := anObject! !
!Core.NotFoundError categoriesForMethods!
_descriptionFormat!displaying!public! !
receiver!accessing!public! !
receiver:!accessing!public! !
!

