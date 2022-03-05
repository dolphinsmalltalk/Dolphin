"Filed out from Dolphin Smalltalk"!

MessageSequenceAbstract subclass: #MessageSequence
	instanceVariableNames: 'list'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MessageSequence guid: (GUID fromString: '{87b4c665-026e-11d3-9fd7-00a0cc3e4a32}')!
MessageSequence comment: ''!
!MessageSequence categoriesForClass!Kernel-Methods! !
!MessageSequence methodsFor!

add: aMessage
	"Adds aMessage to the end of this sequence. Answers aMessage"

	^list addLast: aMessage.
!

add: newElement afterIndex: index
	"Add newElement to the receiver immediately after the element currently at the
	specified <integer> index. index must be between 0 and the receiver's current 
	size (if not raise an exception). Answer newElement."

	^list add: newElement afterIndex: index!

addAll: newElements afterIndex: index
	"Add all of the elements in the <collection>, newElements, after the existing element of
	the receiver at the one-based <integer> index, index. Answer the newly added elements."

	^list addAll: newElements afterIndex: index!

initialize
	"Private - Initialize the receiver"

	super initialize.
	list := OrderedCollection new.!

list
	"Private - Answers the message list"

	^list!

messagesDo: aBlock
	"Private - Enumerates through the receiver"

	^list do: aBlock!

removeMessagesFor: anObject
	"Removes all the messages in this sequence that are destined for anObject.
	Answer the receiver."

	list := list reject: [ :each | each receiver == anObject]!

size
	"Answers the number of messages in the sequence"

	^list size! !
!MessageSequence categoriesForMethods!
add:!adding!public! !
add:afterIndex:!adding!public! !
addAll:afterIndex:!adding!public! !
initialize!initializing!private! !
list!accessing!private! !
messagesDo:!enumerating!private! !
removeMessagesFor:!public!removing! !
size!public!testing! !
!

!MessageSequence class methodsFor!

withMessages: aSequencedReadableCollection
	"Answer a new instance of the receiver with the specified sequence of <MessageSend>s."

	| answer |
	answer := self new.
	answer list addAll: aSequencedReadableCollection.
	^answer! !
!MessageSequence class categoriesForMethods!
withMessages:!instance creation!public! !
!

