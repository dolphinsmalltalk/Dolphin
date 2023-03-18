"Filed out from Dolphin Smalltalk"!

Core.MessageSequenceAbstract
	subclass: #'Core.MessageSequence'
	instanceVariableNames: 'messages'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.MessageSequence guid: (Core.GUID fromString: '{87b4c665-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.MessageSequence comment: ''!
!Core.MessageSequence categoriesForClass!Kernel-Methods! !
!Core.MessageSequence methodsFor!

add: aMessage
	"Adds aMessage to the end of this sequence. Answers aMessage"

	^messages addLast: aMessage!

add: newElement afterIndex: index
	"Add newElement to the receiver immediately after the element currently at the
	specified <integer> index. index must be between 0 and the receiver's current 
	size (if not raise an exception). Answer newElement."

	^messages add: newElement afterIndex: index!

addAll: newElements afterIndex: index
	"Add all of the elements in the <collection>, newElements, after the existing element of
	the receiver at the one-based <integer> index, index. Answer the newly added elements."

	^messages addAll: newElements afterIndex: index!

forwardTo: anObject
	"Forwards all the messages in this sequence to anObject. Answers the
	result of the last message in the sequence."

	^messages inject: nil into: [:answer :each | each forwardTo: anObject]!

freeze
	"The sequence is complete; freeze it so that further messages cannot be added."

	messages := messages asArray.
	^self!

includes: aMessage
	"Answer whether the argument, anObject, is equal to one of the receiver's elements."

	^messages includes: aMessage!

initialize
	"Private - Initialize the receiver"

	messages := OrderedCollection new!

messages
	"Answer a <collection> of all the messages in the sequence."

	^messages!

messages: aSequenceableCollection
	messages := aSequenceableCollection!

removeMessagesFor: anObject
	"Removes all the messages in this sequence that are destined for anObject.
	Answer the receiver."

	messages := messages reject: [:each | each receiver == anObject]!

size
	"Answers the number of messages in the sequence"

	^messages size!

value
	"Plays all the messages in this sequence, which are assumed to be `MessageSend`s that are fully qualified with their receivers. Answers the result of the last message in the sequence."

	| answer |
	1 to: messages size do: [:i | answer := (messages at: i) value].
	^answer!

valueWithArguments: anArray
	"Plays all the messages in this sequence, which are assumed to be `MessageSend`s that are fully qualified when provided with the specified arguments. Answers the result of the last message in the sequence."

	| answer |
	1 to: messages size do: [:i | answer := (messages at: i) valueWithArguments: anArray].
	^answer! !
!Core.MessageSequence categoriesForMethods!
add:!adding!public! !
add:afterIndex:!adding!public! !
addAll:afterIndex:!adding!public! !
forwardTo:!operations!public! !
freeze!operations!public! !
includes:!public!searching! !
initialize!initializing!private! !
messages!accessing!public! !
messages:!initializing!public! !
removeMessagesFor:!public!removing! !
size!public!testing! !
value!evaluating!public! !
valueWithArguments:!evaluating!public! !
!

!Core.MessageSequence class methodsFor!

withMessages: aSequencedReadableCollection
	"Answer a new instance of the receiver with the specified sequence of <MessageSend>s."

	^self new
		messages: aSequencedReadableCollection asOrderedCollection;
		yourself! !
!Core.MessageSequence class categoriesForMethods!
withMessages:!instance creation!public! !
!

