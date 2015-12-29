"Filed out from Dolphin Smalltalk X6"!

Exception subclass: #ProcessTermination
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProcessTermination guid: (GUID fromString: '{87B4C570-026E-11D3-9FD7-00A0CC3E4A32}')!
ProcessTermination comment: ''!
!ProcessTermination categoriesForClass!Kernel-Exception Handling! !
!ProcessTermination methodsFor!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."
	
	^'Terminating %2'!

defaultAction
	"The receiver is an unhandled notification, perform the default action.
	In the case of ProcessTermination signals, we'll only get here on attempts to
	terminate processes which have no base handler, which will only happen if
	the process has not yet completed its initialization, or if it has been
	incompletely terminated. The defaultAction here is to do nothing, and
	if the process is still running, it will shut itself down."
! !
!ProcessTermination categoriesFor: #_descriptionFormat!displaying!public! !
!ProcessTermination categoriesFor: #defaultAction!handling!public! !

