"Filed out from Dolphin Smalltalk"!

Error subclass: #OperationAborted
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

OperationAborted guid: (GUID fromString: '{dca7ee5f-8ba7-46dc-841c-4da7bd3bad97}')!

OperationAborted comment: 'Generic exception that can be signalled when the user aborts an operation, for example in response to pressing the cancel button in a dialog.'!

!OperationAborted categoriesForClass!Kernel-Exception Handling! !

!OperationAborted methodsFor!

messageText
	"Answer the <readableString> message text for the receiver."

	^messageText ?? 'Operation aborted'! !

!OperationAborted categoriesForMethods!
messageText!accessing!public! !
!

