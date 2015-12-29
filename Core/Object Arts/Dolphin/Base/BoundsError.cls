"Filed out from Dolphin Smalltalk X6"!

Error subclass: #BoundsError
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BoundsError guid: (GUID fromString: '{87B4C558-026E-11D3-9FD7-00A0CC3E4A32}')!
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
!BoundsError categoriesFor: #_descriptionFormat!displaying!public! !
!BoundsError categoriesFor: #receiver!accessing!public! !
!BoundsError categoriesFor: #receiver:!accessing!public! !

