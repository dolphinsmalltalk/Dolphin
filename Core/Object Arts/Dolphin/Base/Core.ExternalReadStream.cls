"Filed out from Dolphin Smalltalk"!

Core.AbstractReadStream
	subclass: #'Core.ExternalReadStream'
	instanceVariableNames: 'medium fallback'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'BufferSize' -> 16r1000 }!

Core.ExternalReadStream guid: (Core.GUID fromString: '{87b4c6fc-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.ExternalReadStream comment: '`ExternalReadStream` represents a buffered read stream for reading data from some external medium. Depending on the medium, reading from the stream, e.g. with `#next`, may block until there is data available. In order to avoid blocking (when executing on the user interface thread, for example) the `#hasInput` method may be used to check for the presence of available input before calling `#next`.

## Instance Variables:
  `medium`		`<readableMedium>` that is the underlying data source.
  `fallback`		`SmallInteger` fallback anchor position used to preserve data in the current buffer when reading ahead

'!

!Core.ExternalReadStream categoriesForClass!Collections-Streams!Windows Sockets! !

!Core.ExternalReadStream methodsFor!

anchor
	"Set the fallback anchor position to preserve any data after the current position should a further block of data need to be read (see #readPage)."

	fallback := position!

atEnd
	"Answer whether the receiver cannot access any more objects."

	"Implementation Note: If there is any input available in the buffer, then we know we are not at end. Otherwise we need to attempt to read some more input from the socket to find out whether it has been closed or not. This could, of course, cause the stream to block, but this is correct since we can't truthfully answer whether we are at end until either more input arrives, or the socket is closed."

	self isBufferEmpty ifFalse: [^false].
	^medium isOpen not or: 
			[self
				readPage;
				isBufferEmpty]!

basicContentsSpecies
	"Private - Answer the class of Object to be used when answering collections of undecoded elements from the receiver."

	^ByteArray!

basicNextAvailable: anInteger
	"Private - Answer up to anInteger undecoded elements of the receiver's collection. Generally, the
	answer will be a collection of the same class as the one accessed by the receiver (though
	this is determined by the receiver), and will contain anInteger undecoded elements, or as
	many as are left in the receiver's collection."

	| writeStream count |
	count := 0.
	writeStream := self basicContentsSpecies writeStream: anInteger.
	[count == anInteger or: [self atEnd]] whileFalse: 
			[writeStream basicNextPut: self basicNext.
			count := count + 1].
	^writeStream grabContents!

contents
	"We don't maintain past history, so we cannot implement this correctly."

	^self errorNotPositionable!

encoding: aSymbol
	"Set the receiver's encoding."

	| newBuffer |
	aSymbol == self encoding ifTrue: [^self].
	newBuffer := (ByteBufferClasses at: aSymbol) newFixed: BufferSize.
	collection
		replaceBytesOf: newBuffer
		from: 1
		to: position
		startingAt: 1.
	position := position * collection class elementSize // newBuffer class elementSize.
	collection := newBuffer!

hasInput
	"Answer true if there is data available on the receiver without blocking"

	^self isBufferEmpty not or: [medium hasInput]!

isBinary
	"Answer whether the receiver's data is binary (i.e. consisting of Integers in the range 0..255)."

	^self encoding == #binary!

isBufferEmpty
	<primitive: 67>
	^position >= readLimit!

isText
	"Answer whether if the receiver's data is characters"

	^self encoding ~~ #binary!

isText: aBoolean
	"Set whether the elements of the receiver should be treated as bytes (Integers) or characters.."

	self encoding: (aBoolean ifTrue: [#text] ifFalse: [#binary])!

medium
	^medium!

medium: aReadableMedium buffer: byteCollection
	"Private - Initialize the receiver."

	medium := aReadableMedium.
	collection := byteCollection.
	position := readLimit := 0.
	locale := Locale.UserDefault!

on: aCollection
	collection := aCollection.
	position := readLimit := 0!

readPage
	"Private - Read ahead, a whole page or as much input as is available from the medium, into the buffer."

	| received |
	fallback
		ifNil: [position := 0]
		ifNotNil: 
			["If the anchor has been dropped to indicate stream read-ahead, then copy the remaining buffer content to the start of the buffer so that it can be preserved."
			position := readLimit - fallback.
			collection
				replaceFrom: 1
				to: position
				with: collection
				startingAt: fallback + 1.
			"The preserved data has been moved to the start of the buffer"
			fallback := 0].
	received := medium read: collection yourAddress + position count: collection size - position.
	readLimit := position + received!

resetToAnchor: anInteger
	"Revert to the fallback position that must have previously been established by #anchor."

	position := fallback.
	fallback := nil!

size
	"We don't know the number of elements in the past sequence values, only the number
	currently in the buffer, so cannot provide a sensible implementation of this message."

	^self errorNotPositionable!

unanchor
	"Abandon the fallback anchor position. After this it is no longer possible to #revert."

	fallback := nil!

underflow
	"Private - An attempt has been made to read off the end of data in the stream buffer. This is an opportunity to read the next block of data so that the stream read can be retried. Reading from the socket will block until further data is available, or the socket is closed. If the socket is closed, then we are at end of stream."

	self readPage.
	readLimit == 0 ifTrue: [self errorEndOfStream]!

upTo: anObject 
	"Answer a collection of elements starting with the next element accessed by the receiver,
	and up to, not inclusive of, the next element that is equal to anObject. Positions the
	stream after anObject if found. If anObject is not in the collection, answer the entire rest
	of the collection. If the receiver is at its end, answer an empty Collection."

	| newStream nextObject |
	newStream := self contentsSpecies writeStream: 128.
	[(nextObject := self nextAvailable) isNil or: [nextObject = anObject]] 
		whileFalse: [newStream nextPut: nextObject].
	^newStream contents!

upToEnd
	"Answer a collection consisting of the remaining elements in the receiver (i.e. from the current
	position to the end)."

	| remainder |
	remainder := self contentsSpecies writeStream: 128.
	[self atEnd] whileFalse: [remainder nextPut: self next].
	^remainder contents! !

!Core.ExternalReadStream categoriesForMethods!
anchor!anchoring!public! !
atEnd!public!testing! !
basicContentsSpecies!accessing!private! !
basicNextAvailable:!private!reading! !
contents!public!reading! !
encoding:!modes!public! !
hasInput!public!testing! !
isBinary!public!testing! !
isBufferEmpty!private!testing! !
isText!public!testing! !
isText:!modes!public! !
medium!accessing!private! !
medium:buffer:!initializing!private! !
on:!initializing!private! !
readPage!operations!private! !
resetToAnchor:!anchoring!public! !
size!accessing!public! !
unanchor!anchoring!public! !
underflow!private!reading! !
upTo:!public!reading! !
upToEnd!public!reading! !
!

!Core.ExternalReadStream class methodsFor!

bufferSize
	"Private - Answer the size of the buffer to be used."

	^4096!

on: aSocket
	"Answers a new instance of the receiver for buffered reading of binary data from the <Socket> argument."

	^self on: aSocket type: #binary!

on: aSocket text: aBoolean
	"Answer a new instance of the receiver on the specified <Socket>, to be used for buffered writing of text (UTF-8) or binary data to that socket depending on the value of <boolean> argument."

	^self on: aSocket type: (aBoolean ifTrue: [#text] ifFalse: [#binary])!

on: aSocket type: aSymbol
	"Answer a new instance of the receiver on the specified <Socket>, to be used for buffered writing of data in the encoding specified by the <Symbol> argument. See the class comment for more details on
	possible the encodings."

	^self basicNew
		medium: aSocket buffer: ((ByteBufferClasses at: aSymbol) newFixed: BufferSize);
		yourself! !

!Core.ExternalReadStream class categoriesForMethods!
bufferSize!constants!private! !
on:!instance creation!public! !
on:text:!instance creation!public! !
on:type:!instance creation!public! !
!

