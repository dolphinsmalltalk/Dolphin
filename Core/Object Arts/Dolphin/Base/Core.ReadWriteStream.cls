"Filed out from Dolphin Smalltalk"!

Core.WriteStream
	subclass: #'Core.ReadWriteStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.ReadWriteStream guid: (Core.GUID fromString: '{87b4c6fd-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.ReadWriteStream comment: 'Class ReadWriteStream is a subclass of WriteStream that represents an accessor that can both read and write elements into its collection. It supports all the protocol of both ReadStream and WriteStream.
'!

!Core.ReadWriteStream categoriesForClass!Collections-Streams! !

!Core.ReadWriteStream methodsFor!

basicNext
	"Answer the next basic element accessible by the receiver. 'Basic' in this sense means the same type of object that would be returned from the collection if sent #basicAt:. For bytes and strings the basic elements are integers in the range 0..255. For Arrays, the basic elements are whatever objects are stored in the array. Fail if the receiver is at its end, or the index is outside the bounds of the collection."

	"Primitive failure codes:
		AssertionFailure		The receivers position or readLimit are not SmallInteger values
		NotSupported			The receiver's collection is not an Array, String or ByteArray.
		OutOfBounds			position not in range 0<position<readLimit, or
							the next position is beyond the end of the streamed over collection."

	<primitive: 221>
	^position >= readLimit
		ifTrue: [self errorEndOfStream]
		ifFalse: [collection basicAt: (position := position + 1)]!

basicNext: count into: aSequenceableCollection startingAt: startAt
	"Private - Destructively replace the elements of the argument, aSequenceableCollection,
	in the interval (startAt..startAt+count-1) with the next, count, elements of
	the receiver. Answer aSequenceableCollection."

	| stop |
	stop := self positionAfterNext: count.
	aSequenceableCollection
		replaceFrom: startAt
		to: startAt+count-1
		with: collection
		startingAt: position+1.
	self position: stop.
	^aSequenceableCollection!

contents
	"Answer a collection of the same type that the stream is accessing, 
	up to the current readLimit (adjusted to include the current position
	if it does not already). i.e.. This will answer the contents of
	the stream up to the high water mark. This also updates the read limit
	(high water mark) to include any elements written but not read."

	^collection copyFrom: 1 to: self size!

isReadable
	"Answer whether the receiver can be read from (i.e. it implements the 
	gettableStream protocol)."

	^true!

next
	"Answer the next object accessible by the receiver.

	Primitive failure codes:
		AssertionFailure		The receiver's position or readLimit are not SmallInteger values
		NotSupported			The receiver's collection is not an Array, String or ByteArray.
		OutOfBounds			position not in range 0<position<readLimit, or
							the next position is beyond the end of the streamed over collection.
		IllegalCharacter		When streaming over UTF encoded data, and invalid or incomplete encoding is encountered."

	<primitive: 65>
	position >= readLimit ifTrue: [self underflow].
	^self decodeNext!

nextAvailable
	"Answer the next object accessible by the receiver, or nil if at the end of the stream.
	Note that if the stream can contain nils, then you will not be able to distinguish a nil element from the end of stream, so this method is only useful for text and byte streams, or where the collection being streamed over is known not to contain nils."

	<primitive: 65>
	^position >= readLimit ifFalse: [self decodeNext]!

peek
	"Answer the next element in the collection, but do not change the current position. Answer
	nil if the receiver is at its end."

	^self atEnd
		ifFalse: 
			[| anObject pos |
			pos := self position.
			anObject := self next.
			self position: pos.
			anObject]!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the argument, anObject, then advance the current position and answer true. Otherwise answer false and do not change the current position."

	| pos next |
	pos := self position.
	^(next := self nextAvailable) notNil
		and: [next = anObject or: 
					[self position: pos.
					false]]!

positionAfterNext: anInteger 
	"Private - Answer the new position which the receiver would be in if a further anInteger are
	read from the receiver."

	| stop |
	stop := position + anInteger.
	stop > self lastPosition ifTrue: [^self errorEndOfStream].
	^stop!

readStream
	^self!

underflow
	"Private - An attempt has been made to read off the end of the current stream buffer. If reading from a collection, then this is an error. If the collection is a 'page' of data from some backing store, then this is an opportunity to read the next page so that the stream read can be retried."

	^self errorEndOfStream!

upTo: anObject
	"Answer a collection of elements starting with the next element accessed by the receiver,
	and up to, not inclusive of, the next element that is equal to anObject. Positions the
	stream after anObject if found. If anObject is not in the collection, answer the entire rest
	of the collection. If the receiver is at its end, answer an empty Collection."

	^collection class decodeFrom: self upTo: anObject!

upToAll: aCollection 
	"Answer a collection of the receiver's future sequence values starting with the next value
	accessed by the receiver, and up to, not inclusive of, the sequence of values that match the
	elements of the <collection> argument, or the remaining contents of the stream up to its end
	if the sequence is not found. The stream is left positioned after the last matching element,
	or at the end if the sequence is not found."

	| start |
	start := self position.
	^(self skipToAll: aCollection) 
		ifTrue: 
			[| end answer |
			end := self position.
			self position: start.
			answer := self basicNext: end - start - aCollection size.
			self position: end.
			answer]
		ifFalse: 
			[self position: start.
			self upToEnd]!

upToEnd
	"Answer a collection consisting of the future sequence values of the receiver (i.e. from 
	the current position to the end)."

	"Implementation Note: We implement this in terms of #basicNext:, which is optimized for
	 particular streams, and which counts by raw elements regardless of encoding."

	^self basicNext: self lastPosition - self position! !

!Core.ReadWriteStream categoriesForMethods!
basicNext!public!reading! !
basicNext:into:startingAt:!private!reading! !
contents!public!reading! !
isReadable!public!testing! !
next!public!reading! !
nextAvailable!public!reading! !
peek!public!reading! !
peekFor:!public!reading! !
positionAfterNext:!positioning!private! !
readStream!accessing!public! !
underflow!private!reading! !
upTo:!public!reading! !
upToAll:!public!reading! !
upToEnd!public!reading! !
!

Core.ReadWriteStream methodProtocol: #gettableStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #do: #next #next: #nextLine #nextMatchFor: #peek #peekFor: #skip: #skipTo: #upTo:)!
Core.ReadWriteStream methodProtocol: #ReadWriteStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #close #contents #cr #do: #flush #isEmpty #next #next: #nextLine #nextMatchFor: #nextPut: #nextPutAll: #peek #peekFor: #position #position: #reset #setToEnd #skip: #skipTo: #space #tab #upTo:)!

Core.ReadWriteStream class methodProtocol: #'ReadWriteStream factory' attributes: #(#ansi #readOnly) selectors: #(#with:)!

