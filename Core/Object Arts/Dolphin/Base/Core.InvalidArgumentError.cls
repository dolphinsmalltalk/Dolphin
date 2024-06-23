"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'Core.InvalidArgumentError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.InvalidArgumentError guid: (Core.GUID fromString: '{6e162e48-3fc1-43e8-9b02-9520eb261731}')!

Core.InvalidArgumentError comment: '`InvalidArgumentError`, is an `Error` raised when an argument passed to a method is invalid in the called context.

'!

!Core.InvalidArgumentError categoriesForClass!Kernel-Exception Handling! !

!Core.InvalidArgumentError methodsFor!

_descriptionFormat
	"Answer the description format string for the receiver."

	^'Invalid argument ''%2'': %1'! !

!Core.InvalidArgumentError categoriesForMethods!
_descriptionFormat!displaying!public! !
!

