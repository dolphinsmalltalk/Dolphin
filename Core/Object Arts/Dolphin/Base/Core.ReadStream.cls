"Filed out from Dolphin Smalltalk 7"!

PositionableStream subclass: #ReadStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ReadStream guid: (GUID fromString: '{87b4c6fa-026e-11d3-9fd7-00a0cc3e4a32}')!
ReadStream comment: 'Class ReadStream is a concrete subclass of PositionableStream that represents
an accessor that can only read elements from a collection.'!
!ReadStream categoriesForClass!Collections-Streams! !
!ReadStream methodsFor!

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

isReadable
	"Answer whether the receiver can be read from (i.e. it implements the 
	gettableStream protocol)."

	^true!

next
	"Answer the next object accessible by the receiver. The primitive implementation works for Strings
	and Arrays only, and will otherwise fail if the receiver is at its end, or the index is outside
	the bounds of the collection.

	Primitive failure reasons:
		0 -	The receivers index or readLimit are not SmallInteger values
		1 -	The receiver's collection is not an Array, String or ByteArray.
		2 -	The receiver is at its end (index >= readLimit).
		3 -	The next index is beyond the end of the streamed over collection."

	<primitive: 65>
	^position >= readLimit
		ifTrue: [self errorEndOfStream]
		ifFalse: [collection decodeNextFrom: self]!

nextAvailable
	"Answer the next object accessible by the receiver, or nil if at the end of the stream.
	Note that if the stream can contain nils, then you will not be able to distinguish a nil element from the 
	end of stream, so this method is only useful for text and byte streams, or where the collection
	being streamed over is known not to contain nils."

	<primitive: 65>
	^position >= readLimit ifFalse: [collection decodeNextFrom: self]! !
!ReadStream categoriesFor: #basicNext!accessing!public! !
!ReadStream categoriesFor: #basicNext:into:startingAt:!accessing!public! !
!ReadStream categoriesFor: #basicNextAvailable!accessing!private! !
!ReadStream categoriesFor: #isReadable!public!testing! !
!ReadStream categoriesFor: #next!accessing!public! !
!ReadStream categoriesFor: #nextAvailable!accessing!public! !

ReadStream methodProtocol: #ReadStream attributes: #(#ansi #readOnly) selectors: #(#atEnd #close #contents #do: #isEmpty #next #next: #nextLine #nextMatchFor: #peek #peekFor: #position #position: #reset #setToEnd #skip: #skipTo: #upTo:)!

ReadStream class methodProtocol: #'ReadStream factory' attributes: #(#ansi #readOnly) selectors: #(#on:)!

