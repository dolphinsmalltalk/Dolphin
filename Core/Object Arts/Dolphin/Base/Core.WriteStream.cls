"Filed out from Dolphin Smalltalk"!

Core.AbstractWriteStream
	subclass: #'Core.WriteStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.WriteStream guid: (Core.GUID fromString: '{87b4c6fb-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.WriteStream comment: '`WriteStream` is a concrete subclass of `PositionableStream` providing a streaming interface for writing elements into a `<sequenceableCollection>`. None of the `next`, `next:`, nor `do:` messages can be successfully sent to a `WriteStream`.

`WriteStream` conforms to the ANSI protocol `<WriteStream>`, and therefore to the protocols `<collectionStream>`, `<puttableStream>`, and `<sequencedStream`.'!

!Core.WriteStream categoriesForClass!Collections-Streams! !

!Core.WriteStream methodsFor!

contents
	"Answer the contents of the streamed over collection up to the current position. At the same time adjust the readLimit to include that position if it doesn't already. I.E. By accessing the contents we have 'read' all the elements in the receiver. The readLimit is mostly of use to readable subclasses."

	readLimit < position ifTrue: [readLimit := position].
	^collection copyFrom: 1 to: position!

grabContents
	"Destructively answer the contents of the streamed over collection up to the current position. It is assumed the stream will no longer be used after this, so the message should only be sent to owned streams that are going out of scope."

	^collection resize: position!

moveToEnd
	"Private - Position the receiver to the end of its underlying collection."

	readLimit := collection size.
	self setToEnd!

overflow: anInteger
	"Private - Output has overflowed the buffer. Increase the size of the streamed over collection to accommodate more elements."

	collection growToAtLeast: collection size + anInteger.
	writeLimit := collection size!

overflowBasicNextPut: anObject
	self
		overflow: 1;
		primitiveBasicNextPut: anObject!

overflowNextPut: anObject
	"Private - A #nextPut: operation would exceed the current write limit. Grow the target collection sufficiently to accommodate the encoded form of the argument, and try again."

	self
		overflow: (self encodedSizeOf: anObject);
		primitiveNextPut: anObject!

overflowNextPutAll: aCollection
	"Private - A #nextPutAll: operation would exceed the current write limit. Grow the target collection to increase the write limit before trying again."

	self
		overflow: aCollection size;
		primitiveNextPutAll: aCollection!

setToEnd
	"Set the receiver's position reference to the end of the collection,
	updating the readLimit if necessary."

	position := self size! !

!Core.WriteStream categoriesForMethods!
contents!public!reading! !
grabContents!public!reading! !
moveToEnd!positioning!private! !
overflow:!private!writing! !
overflowBasicNextPut:!private!writing! !
overflowNextPut:!private!writing! !
overflowNextPutAll:!private!writing! !
setToEnd!positioning!public! !
!

Core.WriteStream methodProtocol: #collectionStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #isEmpty #position #position: #reset #setToEnd)!
Core.WriteStream methodProtocol: #sequencedStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #isEmpty #position #position: #reset #setToEnd)!
Core.WriteStream methodProtocol: #WriteStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #cr #flush #isEmpty #nextPut: #nextPutAll: #position #position: #reset #setToEnd #space #tab)!

!Core.WriteStream class methodsFor!

with: aCollection
	"Answer a new instance of the receiver accessing the <collection>, aCollection,
	but positioned to store the next element at the end of it, i.e. an APPEND stream."

	^(self on: aCollection)
		moveToEnd;
		yourself

!

with: aCollection from: firstIndex to: lastIndex
	"Answer an instance of WriteStream accessing the subcollection of argument, 
	aCollection, from location firstIndex to lastIndex, but positioned to store
	the next element at the end of the subcollection, i.e. an APPEND stream."

	^(self on: aCollection from: firstIndex to: lastIndex)
		moveToEnd;
		yourself! !

!Core.WriteStream class categoriesForMethods!
with:!instance creation!public! !
with:from:to:!instance creation!public! !
!

Core.WriteStream class methodProtocol: #'WriteStream factory' attributes: #(#ansi #readOnly) selectors: #(#with:)!

