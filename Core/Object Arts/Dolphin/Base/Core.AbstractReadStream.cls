"Filed out from Dolphin Smalltalk"!

Core.PositionableStream
	subclass: #'Core.AbstractReadStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.AbstractReadStream guid: (Core.GUID fromString: '{78f96732-07ff-4dd3-af50-891d1b0e4d63}')!

Core.AbstractReadStream isNonInstantiable: true!

Core.AbstractReadStream comment: '`AbstractReadStream` is an abstract class of readable `PositionableStream`s. Subclasses conform to at least the ANSI `<gettableStream>` protocol.'!

!Core.AbstractReadStream methodsFor!

anchor
	"Set and answer the fallback anchor position to preserve any data after the current position should a further block of data need to be read (see #readPage)."

	^position!

basicNext
	"Answer the next basic element accessible by the receiver. 'Basic' in this sense means the
	same type of object that would be returned from the collection if sent #basicAt:. For bytes
	and strings the basic elements are integers. For Arrays, the basic elements are whatever
	objects are stored in the array."

	"Fail if the receiver is at its end, or the index is outside the bounds of the collection."

	"Primitive failure reasons:
		AssertionFailure	- The receivers index or readLimit are not SmallInteger values
		OutOfBounds	- The next index is beyond the readLimit.
		OutOfBounds	- The next index is off the end of the stream buffer.
		NotSupported	- The buffer is not a supported type (i.e. Array, ByteArray or String)."

	<primitive: 221>
	^position >= readLimit
		ifTrue: [self underflow]
		ifFalse: [collection basicAt: (position := position + 1)]!

contents
	"Answer a <sequencedReadableCollection> that contains the complete contents of the stream."

	^collection copyFrom: 1 to: self size!

isReadable
	"Answer whether the receiver can be read from (i.e. it implements the 
	gettableStream protocol)."

	^true!

next
	"Answer the next object accessible by the receiver. The primitive implementation works for Strings and Arrays only, and will otherwise fail if the receiver is at its end, or the position is outside the bounds of the collection."

	"Primitive failure codes:
		AssertionFailure		The receiver' position or readLimit are not SmallInteger values
		NotSupported			The receiver's collection is not an Array, String or ByteArray.
		OutOfBounds			position not in range 0<position<readLimit, or
							the next position is beyond the end of the streamed over collection.
		IllegalCharacter		When streaming over UTF encoded data, and invalid or incomplete encoding is encountered."

	<primitive: 65>
	position >= readLimit ifTrue: [self underflow].
	^self decodeNext!

peek
	"Answer the next element in the collection, but do not change the current position. Answer nil if the receiver is at its end."

	| anObject pos |
	self atEnd ifTrue: [^nil].
	"Drop anchor in case of buffer underflow mid-character, as we need to retain all code-units of a peeked character"
	pos := self anchor.
	anObject := self next.
	self resetToAnchor: pos.
	^anObject!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the argument, anObject, then advance the current position and answer true. Otherwise answer false and do not change the current position."

	| pos |
	self atEnd ifTrue: [^false].
	"Drop anchor in case of buffer underflow mid-element, as we need to retain all code-units of a peeked character in text streams."
	pos := self anchor.
	^self next = anObject
		ifTrue: 
			[self unanchor.
			true]
		ifFalse: 
			["Step back to start of mismatched stream element"
			self resetToAnchor: pos.
			false]!

readStream
	^self!

resetToAnchor: anInteger
	"Revert to the fallback position that must have previously been established by #anchor."

	position := anInteger!

unanchor
	"Abandon the fallback anchor position. After this it is no longer possible to #revert."

	"Nothing to do here - override point for subclasses that may need to store an anchor fallback"!

underflow
	"Private - An attempt has been made to read off the end of the current stream buffer. If reading from a collection, then this is an error. If the collection is a 'page' of data from some backing store, then this is an opportunity to read the next page so that the stream read can be retried."

	^self errorEndOfStream!

upTo: anObject
	"Answer a collection of elements starting with the next element accessed by the receiver,
	and up to, not inclusive of, the next element that is equal to anObject. Positions the
	stream after anObject if found. If anObject is not in the collection, answer the entire rest
	of the collection. If the receiver is at its end, answer an empty Collection."

	^self subclassResponsibility!

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

	^self subclassResponsibility! !

!Core.AbstractReadStream categoriesForMethods!
anchor!anchoring!public! !
basicNext!public!reading! !
contents!public!reading! !
isReadable!public!testing! !
next!public!reading! !
peek!public!reading! !
peekFor:!public!reading! !
readStream!accessing!public! !
resetToAnchor:!anchoring!public! !
unanchor!anchoring!public! !
underflow!private!reading! !
upTo:!public!reading! !
upToAll:!public!reading! !
upToEnd!public!reading! !
!

Core.AbstractReadStream methodProtocol: #gettableStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #do: #next #next: #nextLine #nextMatchFor: #peek #peekFor: #skip: #skipTo: #upTo:)!

