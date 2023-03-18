"Filed out from Dolphin Smalltalk"!

Core.MessageSequenceAbstract
	subclass: #'Kernel.EventMessageSequence'
	instanceVariableNames: 'receivers messages tally'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.EventMessageSequence guid: (Core.GUID fromString: '{87b4c664-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.EventMessageSequence comment: ''!
!Kernel.EventMessageSequence categoriesForClass!System-Support! !
!Kernel.EventMessageSequence methodsFor!

add: aMessageSend
	"Adds a <MessageSend> to this sequence. Normally this would be an
	EventMessageSend, a special kind of message send that maintains only
	a weak reference to its receiver, and which merges trigger and registration
	arguments in a particular way. However, the argument can be any
	valuable that implements the #value[:] message appropriate for the number
	of arguments triggered with the event, and it must also implement #receiver.
	So, for example, blocks and normal MessageSends can be used.
	Note that we take an additional weak reference to the receiver for the sole
	purpose of being notified when the receiver has been garbage collected
	so that the message sequence can be updated."

	| receiver index |
	tally := tally + 1.
	receiver := aMessageSend receiver.
	index := receivers addAnsweringIndex: receiver.
	index > messages basicSize ifTrue: [messages resize: receivers basicSize].
	messages basicAt: index put: aMessageSend.
	^aMessageSend!

elementsExpired: count of: aWeakArray
	"Private - Handle the loss of <integer> count values from the receiver's receiver <Array> (
	which is also the argument, aWeakArray). We nil the message corresponding to each corpse
	(although we don't bother nilling the dead receivers to speed up the search for an empty slot)."

	tally := tally - count.
	receivers corpsesDo: [:deathAt | messages at: deathAt put: nil]!

forwardTo: anObject
	"Forwards all the messages in this sequence to anObject. Answers the result of the last message in the sequence."

	| last |
	last := nil.
	1 to: receivers basicSize
		do: 
			[:index |
			| receiver |
			"Assign the receiver into a temp to prevent it being GC'd before the message can be sent."
			receiver := receivers at: index.
			receiver == DeadObject.Current
				ifFalse: [(messages at: index) ifNotNil: [:msg | last := msg forwardTo: anObject]]].
	^last!

includes: aMessage
	"Answer whether the argument, anObject, is equal to one of the 
	receiver's elements."

	| corpse |
	corpse := DeadObject.Current.
	1 to: receivers basicSize
		do: 
			[:index |
			(receivers at: index) == corpse
				ifFalse: [(messages at: index) ifNotNil: [:msg | msg = aMessage ifTrue: [^true]]]].
	^false!

initialize
	"Private - Initialize the receiver.
	Implementation Note: The majority of instances only ever contain one message
	for the event against the receiver, so we use 1 as the initial capacity."

	receivers := (MourningWeakArray with: DeadObject.Current)
				pathologist: self;
				yourself.
	messages := Array new: 1.
	tally := 0!

messages
	| answer |
	answer := OrderedCollection new: receivers basicSize.
	1 to: receivers basicSize
		do: 
			[:index |
			(receivers at: index) == DeadObject.Current
				ifFalse: [(messages at: index) ifNotNil: [:msg | answer addLast: msg]]].
	^answer!

removeMessagesFor: anObject
	"Removes all the messages in this sequence that are destined for anObject. Answers the receiver."

	| corpse |
	corpse := DeadObject.Current.
	1 to: receivers basicSize
		do: 
			[:index |
			(receivers at: index) == anObject
				ifTrue: 
					[tally := tally - 1.
					receivers at: index put: corpse.	"corpse marks empty slots"
					messages at: index put: nil]]!

size
	"Answers the number of messages in the receiver"

	^tally!

value
	"Plays all the messages in this sequence, which are assumed to be MessageSends that are fully qualified with their receivers. Answers the result of the last message in the sequence."

	| last |
	last := nil.
	1 to: receivers basicSize
		do: 
			[:index |
			| receiver |
			"Assign the receiver into a temp to prevent it being GC'd before the message can be sent."
			receiver := receivers at: index.
			receiver == DeadObject.Current ifFalse: [(messages at: index) ifNotNil: [:msg | last := msg value]]].
	^last!

valueWithArguments: anArray
	"Evaluate the receiver with the specified <Array> of arguments."

	"Implementation Note: Inline the enumeration purely because it is performance critical - this is on one of the main paths for SASE event distribution."

	| last |
	last := nil.
	1 to: receivers basicSize
		do: 
			[:index |
			| receiver |
			"Assign the receiver into a temp to prevent it being GC'd before the message can be sent."
			receiver := receivers at: index.
			receiver == DeadObject.Current
				ifFalse: [(messages at: index) ifNotNil: [:msg | last := msg valueWithArguments: anArray]]].
	^last! !
!Kernel.EventMessageSequence categoriesForMethods!
add:!adding!public! !
elementsExpired:of:!finalizing!private! !
forwardTo:!operations!public! !
includes:!public!searching! !
initialize!initializing!private! !
messages!accessing!public! !
removeMessagesFor:!public!removing! !
size!accessing!public! !
value!evaluating!public! !
valueWithArguments:!evaluating!public! !
!

