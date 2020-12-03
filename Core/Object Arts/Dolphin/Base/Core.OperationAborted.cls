"Filed out from Dolphin Smalltalk 7"!

Core.Error subclass: #'Core.OperationAborted'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.OperationAborted guid: (Core.GUID fromString: '{dca7ee5f-8ba7-46dc-841c-4da7bd3bad97}')!
Core.OperationAborted comment: 'Generic exception that can be signalled when the user aborts an operation, for example in response to pressing the cancel button in a dialog.'!
!Core.OperationAborted categoriesForClass!Kernel-Exception Handling! !
!Core.OperationAborted methodsFor!

messageText
	"Answer the <readableString> message text for the receiver."

	^messageText ?? 'Operation aborted'! !
!Core.OperationAborted categoriesFor: #messageText!accessing!public! !

