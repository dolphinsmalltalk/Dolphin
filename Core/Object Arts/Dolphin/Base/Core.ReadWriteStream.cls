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
	"Answer the next basic element accessible by the receiver. 'Basic' in this sense means the
	same type of object that would be returned from the collection if sent #basicAt:. For bytes
	and strings the basic elements are integers. For Arrays, the basic elements are whatever
	objects are stored in the array."

	"Fail if the receiver is at its end, or the index is outside the bounds of the collection."

	"Primitive failure reasons:
		AssertionFailure	- The receivers index or readLimit are not SmallInteger values
		OutOfBounds	- The next index is beyond the readLimit.
		OutOfBounds	- The next index is off the end of the stream buffer.
		NotSupported	- The buffer is not a supported type (i.e. ByteArray or String)."

	<primitive: 221>
	^position >= readLimit
		ifTrue: [self errorEndOfStream]
		ifFalse: [collection basicAt: (position := position + 1)]!

basicNext: count into: aSequenceableCollection startingAt: startAt
	"Destructively replace the elements of the argument, aSequenceableCollection,
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
	"Answer the next object accessible by the receiver. The primitive implementation works for Strings and Arrays only, and will otherwise fail if the receiver is at its end, or the index is outside the bounds of the collection. Duplicate the ReadStream method as we're not a subclass."

	"Primitive failure reasons:
		AssertionFailure	- The receivers index or readLimit are not SmallInteger values
		OutOfBounds	- The next index is beyond the readLimit.
		OutOfBounds	- The next index is off the end of the stream buffer.
		NotSupported	- The buffer is not a supported type (i.e. Array, ByteArray or String)."

	<primitive: 65>
	^position >= readLimit ifTrue: [self errorEndOfStream] ifFalse: [collection decodeNextFrom: self]!

nextAvailable
	"Answer the next object accessible by the receiver, or nil if at the end of the stream.
	Note that if the stream can contain nils, then you will not be able to distinguish a nil element from the 
	end of stream, so this method is only useful for text and byte streams, or where the collection
	being streamed over is known not to contain nils."

	<primitive: 65>
	^position >= readLimit ifFalse: [collection decodeNextFrom: self]!

readStream
	^self! !
!Core.ReadWriteStream categoriesForMethods!
basicNext!accessing!public! !
basicNext:into:startingAt:!accessing!public! !
contents!accessing!public! !
isReadable!public!testing! !
next!accessing!public! !
nextAvailable!accessing!public! !
readStream!accessing!public! !
!

Core.ReadWriteStream methodProtocol: #ReadWriteStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #close #contents #cr #do: #flush #isEmpty #next #next: #nextLine #nextMatchFor: #nextPut: #nextPutAll: #peek #peekFor: #position #position: #reset #setToEnd #skip: #skipTo: #space #tab #upTo:)!

Core.ReadWriteStream class methodProtocol: #'ReadWriteStream factory' attributes: #(#ansi #readOnly) selectors: #(#with:)!

