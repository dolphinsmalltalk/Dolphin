"Filed out from Dolphin Smalltalk"!

Core.AbstractWriteStream
	subclass: #'Core.ExternalWriteStream'
	instanceVariableNames: 'medium flags elementSize'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'bufferSize'
	classConstants: { 'OwnsMedium' -> 16r100 }!

Core.ExternalWriteStream guid: (Core.GUID fromString: '{f3d47d4d-7cc0-411d-b4fb-6e05abf89eaa}')!

Core.ExternalWriteStream comment: '`ExternalWriteStream` is a class of `<puttableStream>`s where output is held in an in-memory buffer of limited size that is flushed on overflow to some underlying medium that implements a simple writeable media protocol limited to the following messages:

	`#write: <byteObject> count: <integer>`	- Write data from the buffer to the underlying store
	`#close`								- Close the underlying store

The buffer is implemented by the collection inherited from `PositionableStream` (although note that `ExternalWriteStream`s do not support the `<positionableStream>`s protocol).  This design benefits from the collection stream primitives and consequently is very efficient.

## Instance Variables:
  `medium`	`<writeableMedium>`, e.g. `File`, `Socket`, `IStream`.
  `flags`		`<integer>`. Various boolean attributes.

## Class Instance Variables:
  `bufferSize`		`<integer>`. Default size of buffers.

## Class Constants:
  `OwnsMedium`	`<integer>` flag indicating whether the `medium` is considered owned by the stream, and so is closed when the stream is closed.


'!

!Core.ExternalWriteStream methodsFor!

absolutePosition
	"Private - Answer the absolute (zero-based) position of the stream."

	^medium position // elementSize + position!

basicFree
	medium isOpen
		ifTrue: 
			[self flush.
			self ownsMedium ifTrue: [medium close]].
	medium := nil!

close
	"Write any outstanding changes to the underlying medium and, if the medium is owned by this stream, close it."

	self free!

contents
	"Generally not readable."

	^self shouldNotImplement!

elementSize
	"Answer the size in bytes of the streamed over elements. It is an error if the stream has #pointers encoding. For example this is 1 for a #utf8 stream because each UTF-8 code unit requires one byte (and each UTF-8 code point may requried between 1 and 4 code units)."

	^elementSize!

encoding: aSymbol
	"Set the receiver's encoding. If the encoding is being changed, any buffered data is first flushed."

	aSymbol == self encoding ifTrue: [^self].
	self flush.
	collection := self class newBuffer: collection size encoding: aSymbol.
	elementSize := super elementSize!

externalType
	"Answer a <symbol> which represents the external stream type of the receiver, either #binary or #text. This is an ANSI method and deliberately limited to the defined values (although the standard allows additional ones), but see also #encoding."

	^self isBinary ifTrue: [#binary] ifFalse: [#text]!

flush
	"Flush any buffered output to the medium, e.g. socket or file."
	
	readLimit < position ifTrue: [readLimit := position].
	readLimit == 0 ifTrue: [^self].
	medium write: collection count: readLimit * elementSize.
	readLimit := position := 0!

free
	"Free any external resources associated with the receiver."

	medium isNil ifTrue: [^self].
	self beUnfinalizable.
	self basicFree!

isBinary
	"Answer whether the receiver's data is binary (i.e. consisting of Integers in the range 0..255)."

	^self encoding == #binary!

isBufferDirty
	"Private - Answer whether there is buffered output not yet written to the medium."
	
	readLimit < position ifTrue: [readLimit := position].
	^readLimit ~~ 0!

isText
	"Answer whether if the receiver's data is characters"

	^self encoding ~~ #binary!

isText: aBoolean
	"Set whether the elements of the receiver should be treated as bytes (Integers) or characters."

	self encoding: (aBoolean ifTrue: [#text] ifFalse: [#binary])!

medium
	^medium!

medium: anExternalMedium buffer: byteCollection flags: anInteger
	"Private - Initialize the receiver."

	medium := anExternalMedium.
	flags := anInteger.
	self beFinalizable.
	self on: byteCollection.
	elementSize := super elementSize
!

mediumPosition
	^medium position // elementSize!

mediumPosition: anInteger
	medium position: anInteger * elementSize!

overflowBasicNext: countInteger putAll: aSequenceableCollection startingAt: startInteger
	| remaining next written |
	collection
		replaceFrom: position + 1
		to: (writeLimit min: position + countInteger)
		with: aSequenceableCollection
		startingAt: startInteger.
	next := startInteger.
	written := writeLimit - position.
	remaining := countInteger - written.
	position := writeLimit.
	[remaining > 0] whileTrue: 
			[self flush.
			collection
				replaceFrom: 1
				to: (position := writeLimit min: remaining)
				with: aSequenceableCollection
				startingAt: (next := next + written).
			remaining := remaining - (written := position)]!

overflowBasicNextPut: anObject
	self
		flush;
		primitiveBasicNextPut: anObject!

ownsMedium
	"Answer whether the receiver is considered to own the underlying media and will close it when itself closed."

	^flags anyMask: OwnsMedium!

ownsMedium: aBoolean
	"Set whether the receiver is considered to own the underlying media and will close it when itself closed."

	flags := flags mask: OwnsMedium set: aBoolean!

position
	"Answer the current <integer> position in the stream of  values. If the the underlying medium is not positionable (e.g. it is a console output stream), the result is undefined. The position is specified in code units, e.g. for UTF-16, the byte position is twice this position."

	^self mediumPosition + position!

position: anInteger
	"Set the receiver's current position reference for accessing the collection to the argument, anInteger. Exceptions will be raised if the argument is out of bounds or the underlying medium is not positionable."

	self flush.
"	(anInteger >= 0 and: [anInteger <= readLimit]) 
		ifFalse: [^self errorSubscriptBounds: anInteger]."
	self mediumPosition: anInteger.
	position := readLimit := 0! !

!Core.ExternalWriteStream categoriesForMethods!
absolutePosition!accessing!private! !
basicFree!private!realizing/unrealizing! !
close!operations!public! !
contents!public!reading! !
elementSize!accessing!public! !
encoding:!modes!public! !
externalType!accessing!public! !
flush!public!writing! !
free!public!realizing/unrealizing! !
isBinary!public!testing! !
isBufferDirty!operations!private!testing! !
isText!public!testing! !
isText:!modes!public! !
medium!accessing!private! !
medium:buffer:flags:!initializing!private! !
mediumPosition!positioning!private! !
mediumPosition:!positioning!private! !
overflowBasicNext:putAll:startingAt:!private!writing! !
overflowBasicNextPut:!private!writing! !
ownsMedium!public!testing! !
ownsMedium:!accessing!public! !
position!positioning!public! !
position:!positioning!public! !
!

!Core.ExternalWriteStream class methodsFor!

bufferSize
	^bufferSize!

bufferSize: anInteger
	bufferSize := anInteger!

defaultEncoding
	^#binary!

initialize
	bufferSize := 16r1000!

newBuffer: anInteger encoding: aSymbol
	^(ByteBufferClasses at: aSymbol) newFixed: anInteger!

newBufferForEncoding: aSymbol
	^self newBuffer: self bufferSize encoding: aSymbol!

on: anExternalMedia
	"Answers a new instance of the receiver for buffered writing of binary data to the argument."

	^self on: anExternalMedia type: self defaultEncoding!

on: anExternalMedium buffer: aClass flags: anInteger
	"Private - Answer an instance of the receiver attached to the open `<writeable Medium>`, anExternalMedium, configured to buffer and write in the encoding of the byte-object class, aClass."

	^self basicNew
		medium: anExternalMedium
		buffer: aClass
		flags: anInteger!

on: anExternalMedium text: aBoolean
	"Answer a new instance of the receiver on the specified `<writeableMedium>`, to be used for buffered writing of text (UTF-8) or binary data to that medium depending on the value of <boolean> argument."

	^self on: anExternalMedium type: (aBoolean ifTrue: [#text] ifFalse: [#binary])!

on: anExternalMedium type: aSymbol
	"Answer an instance of the receiver attached to the open `<writeableMedium>`, anExternalMedium, configured to write in the encoding specified by the <Symbol> argument.
	The new instance will not own the medium, and so will not close it when it itself is closed. See #on:type:flags: for an explanation of the type symbol."

	^self
		on: anExternalMedium
		type: aSymbol
		flags: 0!

on: anExternalMedium type: aSymbol flags: anInteger
	"Answer an instance of the receiver attached to the open `<writeableMedium>` 1st argument, configured to write in the encoding specified by the <Symbol> 2nd argument, and special flags from the <integer> 3rd argument.
	The symbolic type is interpreted as follows:
		- #ansi	Buffers into an AnsiString and writes character output assuming the default code page. #utf8 should be preferred.
		- #binary	Buffers into a ByteArray and writes binary output
		- #text	Synonym for #utf8
		- #utf8	Buffers into a Utf8String and writes UTF-8 encoded character output
	As with FileStream, UTF-16 encoded output is not supported. This would be possible, but there seems no demand for this so the additional complexity and cost of adjusting for encoding size is avoided.
	The flags argument can be used to control whether the new instance is considered to own the medium (and will therefore close it when it is closed, false by default), and whether a BoM is written when writing to a text file (true by default)."

	^self
		on: anExternalMedium
		buffer: (self newBufferForEncoding: aSymbol)
		flags: anInteger! !

!Core.ExternalWriteStream class categoriesForMethods!
bufferSize!accessing!public! !
bufferSize:!accessing!public! !
defaultEncoding!constants!public! !
initialize!public! !
newBuffer:encoding:!private! !
newBufferForEncoding:!private! !
on:!instance creation!public! !
on:buffer:flags:!private! !
on:text:!instance creation!public! !
on:type:!instance creation!public! !
on:type:flags:!instance creation!public! !
!

