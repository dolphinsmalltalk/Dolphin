"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.MessageSequenceAbstract'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.MessageSequenceAbstract guid: (Core.GUID fromString: '{87b4c4a0-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.MessageSequenceAbstract isNonInstantiable: true!

Core.MessageSequenceAbstract comment: ''!

!Core.MessageSequenceAbstract categoriesForClass!Kernel-Objects! !

!Core.MessageSequenceAbstract methodsFor!

add: anEventMessageSend
	"Adds a <MessageSend> to this sequence."

	^self subclassResponsibility!

argumentCount
	"Actually the argument count might be variable, but this seems the only sensible 
	implementation for this part of the protocol <message>."

	^0!

asMinimumRepresentation
	"Attempts to fold the receiver to its minimum representation.
	If the receiver is empty return nil, otherwise return the receiver unchanged.
	Subclasses may re-implement this to compress dead space in themselves"
	
	^self size == 0 ifFalse: [self]
!

forwardTo: anObject
	"Forwards all the messages in this sequence to anObject. Answers the
	result of the last message in the sequence."

	^self subclassResponsibility!

includes: aMessage
	"Answer whether the argument, anObject, is equal to one of the receiver's elements."

	^self subclassResponsibility!

isEmpty
	"Answers true if there are no message in this sequence"

	^self size == 0!

messages
	"Answer a <collection> of all the messages in the sequence."

	^self subclassResponsibility!

notEmpty
	"Answers true if there are any messages in this sequence"

	^self isEmpty not!

removeMessagesFor: anObject
	"Removes all the messages in this sequence that are destined for anObject.
	Answer the receiver."

	self subclassResponsibility!

value
	"Plays all the messages in this sequence, which are assumed to be MessageSends
	that are fully qualified with their receivers. Answers the result of the last 
	message in the sequence."

	^self valueWithArguments: #()!

value: anObject
	"Plays all the messages in this sequence passing the <Object> argument as a parameter. 
	The messages are assumed to be <message>s that are fully qualified with their receivers. 
	Answers the result of the last message in the sequence."

	^self valueWithArguments: {anObject}!

value: arg1 value: arg2
	"Plays all the messages in this sequence passing the <Object>s arg1 and arg2 as parameters. 
	The messages are assumed to be <message>s that are fully qualified with their receivers. 
	Answers the result of the last message in the sequence."

	^self valueWithArguments: {arg1. arg2}!

valueWithArguments: anArray
	"Evaluate the receiver with the specified <Array> of arguments."

	^self subclassResponsibility! !

!Core.MessageSequenceAbstract categoriesForMethods!
add:!adding!public! !
argumentCount!accessing!public! !
asMinimumRepresentation!converting!public! !
forwardTo:!operations!public! !
includes:!public!searching! !
isEmpty!public!testing! !
messages!accessing!public! !
notEmpty!public!testing! !
removeMessagesFor:!public!removing! !
value!evaluating!public! !
value:!evaluating!public! !
value:value:!evaluating!public! !
valueWithArguments:!evaluating!public! !
!

Core.MessageSequenceAbstract methodProtocol: #message attributes: #() selectors: #(#argumentCount #forwardTo: #value: #value:value: #valueWithArguments:)!
Core.MessageSequenceAbstract methodProtocol: #messageSend attributes: #() selectors: #()!

!Core.MessageSequenceAbstract class methodsFor!

new
	"Answer an instance of the receiver; instance require initialization"

	^super new initialize! !

!Core.MessageSequenceAbstract class categoriesForMethods!
new!instance creation!public! !
!

