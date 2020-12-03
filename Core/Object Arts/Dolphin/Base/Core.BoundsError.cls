"Filed out from Dolphin Smalltalk 7"!

Core.Error subclass: #'Core.BoundsError'
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.BoundsError guid: (Core.GUID fromString: '{87b4c558-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.BoundsError comment: ''!
!Core.BoundsError categoriesForClass!Kernel-Exception Handling! !
!Core.BoundsError methodsFor!

_descriptionFormat
	"Answer the description format string for the receiver."

	^'Index %2 is out of bounds'!

receiver
	"Answer the object which generated the bounds error."
	
	^receiver!

receiver: anObject
	"Set the object which generated the bounds error to be anObject"
	
	receiver := anObject! !
!Core.BoundsError categoriesFor: #_descriptionFormat!displaying!public! !
!Core.BoundsError categoriesFor: #receiver!accessing!public! !
!Core.BoundsError categoriesFor: #receiver:!accessing!public! !

