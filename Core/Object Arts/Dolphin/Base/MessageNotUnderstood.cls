"Filed out from Dolphin Smalltalk"!

Error subclass: #MessageNotUnderstood
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MessageNotUnderstood guid: (GUID fromString: '{87b4c55d-026e-11d3-9fd7-00a0cc3e4a32}')!

MessageNotUnderstood comment: ''!

!MessageNotUnderstood categoriesForClass!Kernel-Exception Handling! !

!MessageNotUnderstood methodsFor!

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

!MessageNotUnderstood categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
isResumable!public!testing! !
message!accessing!public! !
receiver!accessing!public! !
receiver:!accessing!public! !
selector!accessing!public! !
!

MessageNotUnderstood methodProtocol: #MessageNotUnderstood attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isNested #isResumable #message #messageText #messageText: #outer #pass #receiver #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!

!MessageNotUnderstood class methodsFor!

receiver: anObject message: aMessage
	"Raise a new instance of the receiver reporting that the <object>, anObject, did not understand
	the <failedMessage>, aMessage."

	^super new
		receiver: anObject;
		tag: aMessage;
		signal! !

!MessageNotUnderstood class categoriesForMethods!
receiver:message:!instance creation!public! !
!

MessageNotUnderstood class methodProtocol: #MessageNotUnderstoodSelector attributes: #(#ansi #readOnly) selectors: #(#, #handles:)!

