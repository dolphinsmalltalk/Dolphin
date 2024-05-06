"Filed out from Dolphin Smalltalk"!

Error subclass: #BoundsError
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BoundsError guid: (GUID fromString: '{87b4c558-026e-11d3-9fd7-00a0cc3e4a32}')!

BoundsError comment: ''!

!BoundsError categoriesForClass!Kernel-Exception Handling! !

!BoundsError methodsFor!

_descriptionFormat
	"Answer the description format string for the receiver."

	^'Index %2 is out of bounds'!

receiver
	"Answer the object which generated the bounds error."
	
	^receiver!

receiver: anObject
	"Set the object which generated the bounds error to be anObject"
	
	receiver := anObject! !

!BoundsError categoriesForMethods!
_descriptionFormat!displaying!public! !
receiver!accessing!public! !
receiver:!accessing!public! !
!

