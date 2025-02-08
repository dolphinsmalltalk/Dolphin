"Filed out from Dolphin Smalltalk"!

Core.AbstractReadStream
	subclass: #'Core.ReadStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.ReadStream guid: (Core.GUID fromString: '{87b4c6fa-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.ReadStream comment: 'Class `ReadStream` is a concrete subclass of `PositionableStream` that represents an accessor that can only read elements from a collection.

`ReadStream` conforms to the ANSI protocol `<ReadStream>`, and therefore to the protocols `<collectionStream>`, `<gettableStream>`, and `<sequencedStream`.'!

!Core.ReadStream categoriesForClass!Collections-Streams! !

!Core.ReadStream methodsFor!

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

basicNextAvailable
	"Private - Answer the next basic element accessible by the receiver. 'Basic' in this sense means the
	same type of object that would be returned from the collection if sent #basicAt:. For bytes
	and strings the basic elements are integers. For Arrays, the basic elements are whatever
	objects are stored in the array."

	"Fail if the receiver is at its end, or the index is outside the bounds of the collection.

	Primitive failure reasons:
		0 -	The receivers index or readLimit are not SmallInteger values
		1 -	The receiver's collection is not a byte object
		2 -	The receiver is at its end (index >= readLimit).
		3 -	The next index is beyond the end of the streamed over collection."

	<primitive: 221>
	^position >= readLimit ifFalse: [collection basicAt: (position := position + 1)]!

nextAvailable
	"Answer the next object accessible by the receiver, or nil if at the end of the stream.
	Note that if the stream can contain nils, then you will not be able to distinguish a nil element from the 
	end of stream, so this method is only useful for text and byte streams, or where the collection
	being streamed over is known not to contain nils."

	<primitive: 65>
	^position >= readLimit ifFalse: [self decodeNext]!

positionAfterNext: anInteger 
	"Private - Answer the new position which the receiver would be in if a further anInteger are
	read from the receiver."

	| stop |
	stop := position + anInteger.
	stop > self lastPosition ifTrue: [^self errorEndOfStream].
	^stop!

reverseContents
	"Answer a <sequencedReadableCollection> that contains the complete contents of the stream, but in reverse order."

	^collection reversedFrom: 1 to: self size!

setToEnd
	"Set the position of the receiver to be past the last value in the stream."

	position := readLimit!

upTo: anObject
	"Answer a collection of elements starting with the next element accessed by the receiver,
	and up to, not inclusive of, the next element that is equal to anObject. Positions the
	stream after anObject if found. If anObject is not in the collection, answer the entire rest
	of the collection. If the receiver is at its end, answer an empty Collection."

	^collection class decodeFrom: self upTo: anObject!

upToEnd
	"Answer a collection consisting of the future sequence values of the receiver (i.e. from 
	the current position to the end)."

	"Implementation Note: We implement this in terms of #basicNext:, which is optimized for
	 particular streams, and which counts by raw elements regardless of encoding."

	^self basicNext: self lastPosition - self position! !

!Core.ReadStream categoriesForMethods!
basicNext:into:startingAt:!private!reading! !
basicNextAvailable!private!reading! !
nextAvailable!public!reading! !
positionAfterNext:!positioning!private! !
reverseContents!public!reading! !
setToEnd!positioning!public! !
upTo:!public!reading! !
upToEnd!public!reading! !
!

Core.ReadStream methodProtocol: #collectionStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #isEmpty #position #position: #reset #setToEnd)!
Core.ReadStream methodProtocol: #ReadStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #close #contents #do: #isEmpty #next #next: #nextLine #nextMatchFor: #peek #peekFor: #position #position: #reset #setToEnd #skip: #skipTo: #upTo:)!
Core.ReadStream methodProtocol: #sequencedStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #isEmpty #position #position: #reset #setToEnd)!

Core.ReadStream class methodProtocol: #'ReadStream factory' attributes: #(#ansi #readOnly) selectors: #(#on:)!

