"Filed out from Dolphin Smalltalk 7"!

Core.MessageSequenceAbstract subclass: #'Core.MessageSequence'
	instanceVariableNames: 'list'
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
!Core.MessageSequence categoriesFor: #add:!adding!public! !
!Core.MessageSequence categoriesFor: #add:afterIndex:!adding!public! !
!Core.MessageSequence categoriesFor: #addAll:afterIndex:!adding!public! !
!Core.MessageSequence categoriesFor: #initialize!initializing!private! !
!Core.MessageSequence categoriesFor: #list!accessing!private! !
!Core.MessageSequence categoriesFor: #messagesDo:!enumerating!private! !
!Core.MessageSequence categoriesFor: #removeMessagesFor:!public!removing! !
!Core.MessageSequence categoriesFor: #size!public!testing! !

!Core.MessageSequence class methodsFor!

withMessages: aSequencedReadableCollection
	"Answer a new instance of the receiver with the specified sequence of <MessageSend>s."

	| answer |
	answer := self new.
	answer list addAll: aSequencedReadableCollection.
	^answer! !
!Core.MessageSequence class categoriesFor: #withMessages:!instance creation!public! !

