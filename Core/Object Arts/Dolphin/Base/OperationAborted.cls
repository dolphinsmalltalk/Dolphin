"Filed out from Dolphin Smalltalk X6"!

Error subclass: #OperationAborted
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OperationAborted guid: (GUID fromString: '{DCA7EE5F-8BA7-46DC-841C-4DA7BD3BAD97}')!
OperationAborted comment: 'Generic exception that can be signalled when the user aborts an operation, for example in response to pressing the cancel button in a dialog.'!
!OperationAborted categoriesForClass!Kernel-Exception Handling! !
!OperationAborted methodsFor!

messageText
	"Answer the <readableString> message text for the receiver."

	^messageText ifNil: ['Operation aborted']! !
!OperationAborted categoriesFor: #messageText!accessing!public! !

