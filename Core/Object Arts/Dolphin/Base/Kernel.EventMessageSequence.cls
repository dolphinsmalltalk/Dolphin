"Filed out from Dolphin Smalltalk 7"!

Core.MessageSequenceAbstract subclass: #'Kernel.EventMessageSequence'
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

initialize
	"Private - Initialize the receiver.
	Implementation Note: The majority of instances only ever contain one message
	for the event against the receiver, so we use 1 as the initial capacity."

	receivers := (MourningWeakArray with: DeadObject current)
				pathologist: self;
				yourself.
	messages := Array new: 1.
	tally := 0!

messagesDo: operation
	"Private - Evaluates the <monadicValuable>, operation, for all non-dead elements of the receiver.
	An event message registration is considered dead if the target (receiver) of the message has been
	garbage collected."

	| corpse |
	corpse := DeadObject current.
	1 to: receivers basicSize
		do: 
			[:index |
			| receiver |
			"Assign the receiver into a temp to prevent it being GC'd before the message can be sent."
			receiver := receivers at: index.
			receiver == corpse ifFalse: [(messages at: index) ifNotNil: [:msg | operation value: msg]]]!

removeMessagesFor: anObject
	"Removes all the messages in this sequence that are destined for anObject. Answers the receiver."

	| corpse |
	corpse := DeadObject current.
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

	^tally! !
!Kernel.EventMessageSequence categoriesFor: #add:!adding!public! !
!Kernel.EventMessageSequence categoriesFor: #elementsExpired:of:!finalizing!private! !
!Kernel.EventMessageSequence categoriesFor: #initialize!initializing!private! !
!Kernel.EventMessageSequence categoriesFor: #messagesDo:!debugger-step through!enumerating!private! !
!Kernel.EventMessageSequence categoriesFor: #removeMessagesFor:!public!removing! !
!Kernel.EventMessageSequence categoriesFor: #size!accessing!public! !

