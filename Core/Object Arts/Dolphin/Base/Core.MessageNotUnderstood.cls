"Filed out from Dolphin Smalltalk 7"!

Core.Error subclass: #'Core.MessageNotUnderstood'
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.MessageNotUnderstood guid: (Core.GUID fromString: '{87b4c55d-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.MessageNotUnderstood comment: ''!
!Core.MessageNotUnderstood categoriesForClass!Kernel-Exception Handling! !
!Core.MessageNotUnderstood methodsFor!

_descriptionArguments
	"Answer an string describing the extra information supplied when the receiver
	was raised. Here we answer the classic does not understand error."

	^{self receiver basicClass name. self selector printString}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver.
	We answer the classic does not understand error format."

	^'%1 does not understand %2'!

isResumable
	"Answer whether the receiver represents a resumable error. Message not understood errors are
	considered resumable, as there are a number of circumstances in which we might want to
	perform #doesNotUnderstand: handling and continue."

	^true!

message
	"Answer the <failedMessage> associated with the receiver."

	^self tag!

receiver
	"Answer the object which did not understand the receiver's
	<failedMessage>."
	
	^receiver!

receiver: anObject
	"Set the object which did not understand the message to be anObject"
	
	receiver := anObject!

selector
	"Answer the selector that was not understood from the receiver's
	<failedMessage>."

	^self message selector! !
!Core.MessageNotUnderstood categoriesFor: #_descriptionArguments!displaying!public! !
!Core.MessageNotUnderstood categoriesFor: #_descriptionFormat!displaying!public! !
!Core.MessageNotUnderstood categoriesFor: #isResumable!public!testing! !
!Core.MessageNotUnderstood categoriesFor: #message!accessing!public! !
!Core.MessageNotUnderstood categoriesFor: #receiver!accessing!public! !
!Core.MessageNotUnderstood categoriesFor: #receiver:!accessing!public! !
!Core.MessageNotUnderstood categoriesFor: #selector!accessing!public! !

Core.MessageNotUnderstood methodProtocol: #MessageNotUnderstood attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isNested #isResumable #message #messageText #messageText: #outer #pass #receiver #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!

!Core.MessageNotUnderstood class methodsFor!

receiver: anObject message: aMessage
	"Raise a new instance of the receiver reporting that the <object>, anObject, did not understand
	the <failedMessage>, aMessage."

	^super new
		receiver: anObject;
		tag: aMessage;
		signal! !
!Core.MessageNotUnderstood class categoriesFor: #receiver:message:!instance creation!public! !

Core.MessageNotUnderstood class methodProtocol: #MessageNotUnderstoodSelector attributes: #(#ansi #readOnly) selectors: #(#, #handles:)!

