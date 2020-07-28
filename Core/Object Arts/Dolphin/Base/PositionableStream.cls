"Filed out from Dolphin Smalltalk 7"!

SequencedStream subclass: #PositionableStream
	instanceVariableNames: 'collection position readLimit locale'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PositionableStream guid: (GUID fromString: '{87b4c6f8-026e-11d3-9fd7-00a0cc3e4a32}')!
PositionableStream comment: 'PositionableStream is the abstract class of <SequencedStream>s for which stream over sequence values from a Smalltalk sequenceable collection. Sub-instances of PositionableStream conform to the ANSI <collectionStream> protocol.

Note that some inconsistencies arise when streaming over multi-byte string encodings, such as UTF-8. The position reported by the stream, and that to which it can be set, is always expressed as a code unit position. This has a number of consequences to be aware of:
- Reading a single character may advance the position by more than one code unit position. In the case of UTF-8 characters are represented by 1 to 4 code units, so ReadStream>>next will increment the position between 1 and 4 bytes.
- The stream position can be set to be in the middle of a character if chosen without consideration. For example adjusting the position by using #skip: should generally be avoided - it is better to remember a position, and reset to that. 

Instance Variables
	position		<Integer> 0 based offset of the current code unit position in the stream
	readLimit		<Integer> Either the maximum read position in the stream, or the position up to which the stream has previously been read (depends on subclass).'!
!PositionableStream categoriesForClass!Collections-Streams! !
!PositionableStream methodsFor!

advancePosition
	^position := position + 1!

atEnd
	"Answer whether the receiver cannot access any more objects."

	"The stream primitives work only for Arrays and Strings, and will fail and fall back on the
	Smalltalk code for other types of collection.

	Primitive failure reasons: 
		AssertionFailure	- The receivers position or readLimit are not SmallInteger values 
		NotSupported	- The receiver's collection is not an Array, String or ByteArray."

	<primitive: 67>
	^position >= readLimit!

basicNext: anInteger
	"Private - Answer a <sequencedReadableCollection> containing the next anInteger number of objects
	accessible by the receiver."

	"Implementation Note: Subclasses should not generally override this method, but the more
	flexible #basicNext:into:startingAt: message which this uses."

	^self
		basicNext: anInteger
		into: (collection copyLikeOfSize: anInteger)
		startingAt: 1!

basicNextAvailable
	"Private - Answer the next raw element accessible by the receiver, or nil if at the end of the stream.
	Note that if the stream can contain nils, then you will not be able to distinguish a nil element from the 
	end of stream, so this method is only useful for text and byte streams, or where the collection
	being streamed over is known not to contain nils."

	^self atEnd ifFalse: [self basicNext]!

basicNextAvailable: anInteger
	^self basicNext: (self lastPosition - self position min: anInteger)!

basicUpTo: anObject
	"Private - Answer a collection of elements starting with the next element accessed by the receiver,
	and up to, not inclusive of, the next element that is equal to anObject. Positions the
	stream after anObject if found. If anObject is not in the collection, answer the entire rest
	of the collection. If the receiver is at its end, answer an empty Collection."

	| startIndex endIndex |
	self isReadable ifFalse: [^self errorNotReadable].
	startIndex := position + 1.
	"We can perform a fast scan for anObject in the collection. Most streamed over
	SequenceableCollections have a primitive implementation of #nextIdentityIndexOf:from:to:"
	position := collection
				nextIdentityIndexOf: anObject
				from: startIndex
				to: readLimit.
	position == 0
		ifTrue: 
			["Not found. Result is equivalent of #upToEnd"
			endIndex := position := readLimit]
		ifFalse: 
			["Found. Answer the elements before anObject, and leave the stream positioned immediately after it."
			endIndex := position - 1].
	^collection copyFrom: startIndex to: endIndex!

collection
	"Private - Answer the collection over which the receiver is streaming."

	^collection
!

contents
	"Answer a <sequencedReadableCollection> that contains the complete contents of the stream."

	^collection copyFrom: 1 to: self size!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements from
	the receiver."

	^collection species
!

encodedSizeOf: anObject
	"Answer the number of units that would be occupied by anObject if it were present in this stream."

	^collection encodedSizeOf: anObject!

lastPosition
	"Private - Answer the last position in the receiver (for the purposes of determining
	attempts to read off the end, etc)."

	^readLimit!

locale
"Answer the <Locale> to be used when emitting or reaading localisable data to/from this stream."

	^locale ?? Locale.UserDefault!

locale: aLocale
"Set the <Locale> to be used when emitting or reaading localisable data to/from this stream."

	locale := aLocale!

nextAvailable: anInteger
	"Answer up to anInteger elements of the receiver's collection. The answer will be a
	collection of the same species as the one accessed by the receiver, and will contain anInteger
	elements, or as many as are left in the receiver's collection."

	"Implementation Note: Override superclass as in many cases we can implement this as a block copy."

	^collection decodeNextAvailable: anInteger from: self!

nextDOUBLE
	"Answer a <Float> constructed from the next 8 bytes on the receiver, which are assumed to
	represent an IEEE double precision floating point number."

	"N.B. This will fail if the receiver is not a byte stream."

	^(self basicNext: 8) doubleAtOffset: 0!

nextDWORD
	"Answer a 32-bit unsigned integer constructed from the host system representation contained
	in the next 4 bytes on the receiver."

	"N.B. This will fail if the receiver is not a byte stream."

	^(self basicNext: 4) dwordAtOffset: 0!

nextFLOAT
	"Answer a <Float> constructed from the next 4 bytes on the receiver, which are assumed to
	represent an IEEE single precision floating point number."

	"N.B. This will fail if the receiver is not a byte stream."

	^(self basicNext: VMConstants.FloatSize) floatAtOffset: 0!

nextSDWORD
	"Answer a 32-bit signed integer constructed from the host system representation contained in
	the next 4 bytes on the receiver."

	"N.B. This will fail if not streaming over a byte collection.

	Primitive failure reasons:
		0 -	The receivers position or readLimit are not SmallInteger values
		1 -	The receiver's collection is not a ByteArray.
		2 -	The receiver is at its end (position >= readLimit).
		3 -	The next 32-bit Integer would run off the end of the streamed over collection.
		4 - 	The receiver's new position would overflow the SmallInteger range."

	<primitive: 144>
	^(self basicNext: 4) sdwordAtOffset: 0!

nextSWORD
	"Answer a 16-bit signed integer constructed from the host system representation contained in
	the next 2 bytes on the receiver."

	"N.B. This will fail if the receiver is not a byte stream."

	^(self basicNext: 2) swordAtOffset: 0!

nextWORD
	"Answer a 16-bit unsigned integer constructed from the host system representation contained
	in the next 2 bytes on the receiver."

	"N.B. This will fail if the receiver is not a byte stream."

	^(self basicNext: 2) wordAtOffset: 0!

on: aCollection
	"Private - Set the <collection> over which the receiver will stream and initialize the receiver."

	collection := aCollection.
	readLimit := collection size.
	position := 0.
!

originalContents
	^collection!

position
	"Answer the current <integer> position in the stream of  values."

	^position!

position: anInteger 
	"Set the current position in the stream of values to the <integer> argument. If the argument
	is not within the bounds of the receiver's collection, report an error."

	(anInteger >= 0 and: [anInteger <= readLimit]) 
		ifTrue: [position := anInteger]
		ifFalse: [^self errorSubscriptBounds: anInteger]!

positionAfterNext: anInteger 
	"Private - Answer the new position which the receiver would be in if a further anInteger are
	read from the receiver."

	| stop |
	stop := position + anInteger.
	stop > self lastPosition ifTrue: [^self errorEndOfStream].
	^stop!

reset
	position := 0!

setToEnd
	"Set the position of the receiver to be past the last value in the stream."

	position := readLimit!

size
	"Answer the number of values in the stream."

	"Implementation Note: Take the opportunity to update the read limit."

	readLimit < position ifTrue: [readLimit := position].
	^self lastPosition!

upTo: anObject
	"Answer a collection of elements starting with the next element accessed by the receiver,
	and up to, not inclusive of, the next element that is equal to anObject. Positions the
	stream after anObject if found. If anObject is not in the collection, answer the entire rest
	of the collection. If the receiver is at its end, answer an empty Collection."

	^collection decodeFrom: self upTo: anObject!

upToEnd
	"Answer a collection consisting of the future sequence values of the receiver (i.e. from 
	the current position to the end)."

	"Implementation Note: We implement this in terms of #basicNext:, which is optimized for
	 particular streams, and which counts by raw elements regardless of encoding."

	^self basicNext: self lastPosition - self position! !
!PositionableStream categoriesFor: #advancePosition!positioning!private! !
!PositionableStream categoriesFor: #atEnd!public!testing! !
!PositionableStream categoriesFor: #basicNext:!accessing!private! !
!PositionableStream categoriesFor: #basicNextAvailable!accessing!private! !
!PositionableStream categoriesFor: #basicNextAvailable:!private! !
!PositionableStream categoriesFor: #basicUpTo:!accessing!private! !
!PositionableStream categoriesFor: #collection!accessing!private! !
!PositionableStream categoriesFor: #contents!accessing!public! !
!PositionableStream categoriesFor: #contentsSpecies!accessing!private! !
!PositionableStream categoriesFor: #encodedSizeOf:!encode/decode!public! !
!PositionableStream categoriesFor: #lastPosition!accessing!private! !
!PositionableStream categoriesFor: #locale!accessing!public! !
!PositionableStream categoriesFor: #locale:!accessing!public! !
!PositionableStream categoriesFor: #nextAvailable:!accessing!public! !
!PositionableStream categoriesFor: #nextDOUBLE!binary filing!public! !
!PositionableStream categoriesFor: #nextDWORD!binary filing!public! !
!PositionableStream categoriesFor: #nextFLOAT!binary filing!public! !
!PositionableStream categoriesFor: #nextSDWORD!binary filing!public! !
!PositionableStream categoriesFor: #nextSWORD!binary filing!public! !
!PositionableStream categoriesFor: #nextWORD!binary filing!public! !
!PositionableStream categoriesFor: #on:!initializing!private! !
!PositionableStream categoriesFor: #originalContents!accessing!public! !
!PositionableStream categoriesFor: #position!positioning!public! !
!PositionableStream categoriesFor: #position:!positioning!public! !
!PositionableStream categoriesFor: #positionAfterNext:!positioning!private! !
!PositionableStream categoriesFor: #reset!positioning!public! !
!PositionableStream categoriesFor: #setToEnd!positioning!public! !
!PositionableStream categoriesFor: #size!accessing!public! !
!PositionableStream categoriesFor: #upTo:!accessing!public! !
!PositionableStream categoriesFor: #upToEnd!accessing!public! !

PositionableStream methodProtocol: #collectionStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #isEmpty #position #position: #reset #setToEnd)!

!PositionableStream class methodsFor!

on: aCollection
	"Answer an instance of a kind of the receiver that streams over the 
	argument aCollection. If the new stream is writeable, the initial position
	is at the beginning of the collection (i.e. overwrite). See also 
	WriteStream>>#with:"

	^self basicNew on: aCollection!

on: aCollection from: firstIndex to: lastIndex
	"Answer an instance of a kind of the receiver that streams over a
	copy of a subcollection of the argument, aCollectionm from firstIndex to
	lastIndex. If the new stream is writeable, the initial position
	is at the beginning of the collection (i.e. overwrite). See also 
	WriteStream>>#with:from:to:"

	^self on: (aCollection copyFrom: firstIndex to: lastIndex)
! !
!PositionableStream class categoriesFor: #on:!instance creation!public! !
!PositionableStream class categoriesFor: #on:from:to:!instance creation!public! !

