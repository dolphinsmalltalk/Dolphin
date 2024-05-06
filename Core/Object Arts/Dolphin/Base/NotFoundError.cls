"Filed out from Dolphin Smalltalk"!

Error subclass: #NotFoundError
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NotFoundError guid: (GUID fromString: '{87b4c55e-026e-11d3-9fd7-00a0cc3e4a32}')!

NotFoundError comment: ''!

!NotFoundError categoriesForClass!Kernel-Exception Handling! !

!NotFoundError methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'Not found: %2'!

receiver
	"Answer the object which generated the error."
	
	^receiver!

receiver: anObject
	"Set the object which generated the error to be anObject"
	
	receiver := anObject! !

!NotFoundError categoriesForMethods!
_descriptionFormat!displaying!public! !
receiver!accessing!public! !
receiver:!accessing!public! !
!

