"Filed out from Dolphin Smalltalk X6"!

Error subclass: #NotFoundError
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NotFoundError guid: (GUID fromString: '{87B4C55E-026E-11D3-9FD7-00A0CC3E4A32}')!
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
!NotFoundError categoriesFor: #_descriptionFormat!displaying!public! !
!NotFoundError categoriesFor: #receiver!accessing!public! !
!NotFoundError categoriesFor: #receiver:!accessing!public! !

