"Filed out from Dolphin Smalltalk 7"!

WriteStream subclass: #ReadWriteStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ReadWriteStream guid: (GUID fromString: '{87b4c6fd-026e-11d3-9fd7-00a0cc3e4a32}')!
ReadWriteStream comment: 'Class ReadWriteStream is a subclass of WriteStream that represents an accessor that can both read and write elements into its collection. It supports all the protocol of both ReadStream and WriteStream.
'!
!ReadWriteStream categoriesForClass!Collections-Streams! !
!ReadWriteStream methodsFor!

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
	"Answer the next object accessible by the receiver. The primitive implementation works for Strings
	and Arrays only, and will otherwise fail if the receiver is at its end, or the index is outside
	the bounds of the collection. Duplicate the ReadStream method as we're not a subclass.

	Primitive failure reasons:
		0 -	The receivers index or readLimit are not SmallInteger values
		1 -	The receiver's collection is not an Array, String or ByteArray.
		2 -	The receiver is at its end (index >= readLimit).
		3 -	The next index is beyond the end of the streamed over collection."

	<primitive: 65>
	^position >= readLimit
		ifTrue: [self errorEndOfStream]
		ifFalse: [collection at: (position := position + 1)]!

next: count into: aSequenceableCollection startingAt: startAt
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

nextByte
	"Answer the next byte accessible by the receiver. Fail if not streaming over a byte object.
	Fail if the receiver is at its end, or the index is outside the bounds of the collection.

	Primitive failure reasons:
		0 -	The receivers index or readLimit are not SmallInteger values
		1 -	The receiver's collection is not a byte object
		2 -	The receiver is at its end (index >= readLimit).
		3 -	The next index is beyond the end of the streamed over collection."

	<primitive: 221>
	^position >= readLimit
		ifTrue: [self errorEndOfStream]
		ifFalse: [collection byteAt: (position := position + 1)]!

nextOrNil
	"Answer a <Character>, or <integer> in the range 0..255, being the next of the 
	receiver's future sequence values. Answer nil if at EOF."

	<primitive: 65>
	^position >= readLimit
		ifFalse: [collection at: (position := position + 1)]! !
!ReadWriteStream categoriesFor: #contents!accessing!public! !
!ReadWriteStream categoriesFor: #isReadable!public!testing! !
!ReadWriteStream categoriesFor: #next!accessing!public! !
!ReadWriteStream categoriesFor: #next:into:startingAt:!accessing!public! !
!ReadWriteStream categoriesFor: #nextByte!accessing!public! !
!ReadWriteStream categoriesFor: #nextOrNil!accessing!public! !

ReadWriteStream methodProtocol: #ReadWriteStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #close #contents #cr #do: #flush #isEmpty #next #next: #nextLine #nextMatchFor: #nextPut: #nextPutAll: #peek #peekFor: #position #position: #reset #setToEnd #skip: #skipTo: #space #tab #upTo:)!

ReadWriteStream class methodProtocol: #'ReadWriteStream factory' attributes: #(#ansi #readOnly) selectors: #(#with:)!

