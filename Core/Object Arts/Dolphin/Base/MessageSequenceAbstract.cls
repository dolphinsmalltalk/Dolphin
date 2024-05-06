"Filed out from Dolphin Smalltalk"!

Object subclass: #MessageSequenceAbstract
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MessageSequenceAbstract guid: (GUID fromString: '{87b4c4a0-026e-11d3-9fd7-00a0cc3e4a32}')!

MessageSequenceAbstract isAbstract: true!

MessageSequenceAbstract comment: ''!

!MessageSequenceAbstract categoriesForClass!Kernel-Objects! !

!MessageSequenceAbstract methodsFor!

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

	| answer |
	self messagesDo: [:each | answer := each forwardTo: anObject].
	^answer!

includes: aMessage
	"Answer whether the argument, anObject, is equal to one of the 
	receiver's elements."

	self messagesDo: [:each | aMessage = each ifTrue: [^true]].
	^false!

isEmpty
	"Answers true if there are no message in this sequence"

	^self size == 0!

messagesDo: aBlock
	"Private - Enumerates through the receiver"

	^self subclassResponsibility!

notEmpty
	"Answers true if there are any messages in this sequence"

	^self isEmpty not!

value
	"Plays all the messages in this sequence. They are assumed to be MessageSends
	that are fully qualified with their receivers. Answers the result of the last 
	message in the sequence."

	| answer |
	self messagesDo: [:each | answer := each value].
	^answer!

value: arg1
	"Plays all the messages in this sequence passing the <Object> arg1 as a parameter. 
	They are assumed to be <message>s that are fully qualified with their receivers. 
	Answers the result of the last message in the sequence."

	| answer |
	self messagesDo: [:each | answer := each value: arg1].
	^answer!

value: arg1 value: arg2
	"Plays all the messages in this sequence passing the <Object>s arg1 and arg2 as parameters. 
	They are assumed to be <message>s that are fully qualified with their receivers. 
	Answers the result of the last message in the sequence."

	| answer |
	self messagesDo: [:each | answer := each value: arg1 value: arg2].
	^answer!

valueWithArguments: argArray
	"Evaluate the receiver with an <Array> of arguments in argArray"

	| answer |
	self messagesDo: [:each | answer := each valueWithArguments: argArray].
	^answer! !

!MessageSequenceAbstract categoriesForMethods!
add:!adding!public! !
argumentCount!accessing!public! !
asMinimumRepresentation!converting!public! !
forwardTo:!operations!public! !
includes:!public!searching! !
isEmpty!public!testing! !
messagesDo:!enumerating!private! !
notEmpty!public!testing! !
value!evaluating!public! !
value:!evaluating!public! !
value:value:!evaluating!public! !
valueWithArguments:!evaluating!public! !
!

MessageSequenceAbstract methodProtocol: #message attributes: #() selectors: #(#argumentCount #forwardTo: #value: #value:value: #valueWithArguments:)!
MessageSequenceAbstract methodProtocol: #messageSend attributes: #() selectors: #()!

!MessageSequenceAbstract class methodsFor!

new
	"Answer an instance of the receiver; instance require initialization"

	^super new initialize! !

!MessageSequenceAbstract class categoriesForMethods!
new!instance creation!public! !
!

