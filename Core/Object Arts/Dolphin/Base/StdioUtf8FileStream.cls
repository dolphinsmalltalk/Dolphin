"Filed out from Dolphin Smalltalk 7"!

StdioUnicodeFileStream subclass: #StdioUtf8FileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioUtf8FileStream guid: (GUID fromString: '{c1c28046-101f-4bf6-92f9-e30cea1e8d82}')!
StdioUtf8FileStream comment: ''!
!StdioUtf8FileStream categoriesForClass!Collections-Streams! !
!StdioUtf8FileStream methodsFor!

contents
	"Answer a <Utf8String> containing the complete contents of the file accessed by the
	receiver."

	self reset.
	^self upToEnd!

contentsSpecies
	^Utf8String!

next: anInteger
	"Answer a <sequencedReadableCollection> of the receiver's content species containing the next anInteger number of objects
	accessible by the receiver."

	| out i |
	out := self contentsSpecies writeStream: anInteger.
	i := 1.
	[i > anInteger] whileFalse: [out nextPut: self next].
	^out contents!

next: countInteger into: aSequenceableCollection startingAt: startInteger
	"Destructively replace the elements of the argument, aSequenceableCollection,
	(which must be some sort of byte object or <ExternalStructure> type object
	which holds bytes) in the interval (startAt..startAt+count-1) with the next, count, 
	elements of the receiver. Answer aSequenceableCollection."

	"N.B. This will read countInteger Unicode characters from the stream, which may read between 1 and 4 bytes for
	each character."

	| last pos |
	last := startInteger + countInteger - 1.
	pos := startInteger.
	[pos >= last] whileFalse: [pos := aSequenceableCollection encodedAt: pos put: self next].
	^aSequenceableCollection!

nextAvailable: anInteger
	"Answer a <sequencedReadableCollection> of the receiver's content species containing the next anInteger number of objects
	accessible by the receiver."

	| out i next |
	out := self contentsSpecies writeStream: anInteger.
	i := 1.
	[i > anInteger or: [(next := self nextAvailable) isNil]] whileFalse: 
			[out nextPut: next.
			i := i + 1].
	^out contents!

position
	"Answer the absolute (zero-based) position of the file pointer."

	"Be aware that the positions are in terms of bytes, yet the stream is over a UTF-8 encoded
	file so a byte position is not necessarily the same as a character position. To complicate
	matters further the stdio Unicode streams implementation buffers the content as UTF-16, and
	the CRT apis it exposes operates in terms of wide characters. This means (among other things) that:

	- Attempting to fread() a block of content based on the byte positions may fail or give the
	wrong results (because the buffer actually contains UTF-16 encoded bytes) 
	- One cannot mix #basicNext of a StdioUtf8FileStream with basicNextPut: (or at:put:) onto 
	a Utf8String (because the integers returned may represent UTF-16 surrogates)."

	^super position - offset!

position: anInteger
	"Set the receiver's current position reference for accessing the collection to the the
	argument, anInteger. If the argument is not within the bounds of the receiver's collection,
	or if the associated stdio stream is not positionable, report an error."

	super position: anInteger + offset!

size
	"Answer the size of the file in byte characters, excluding the BOM."

	^super size - offset!

upToEnd
	"Answer a collection consisting of the future sequence values of the receiver (i.e. from 
	the current position to the end)."

	| remainder next |
	remainder := self contentsSpecies writeStream: 128.
	[(next := self nextAvailable) isNil] whileFalse: [remainder nextPut: next].
	^remainder contents! !
!StdioUtf8FileStream categoriesFor: #contents!public! !
!StdioUtf8FileStream categoriesFor: #contentsSpecies!accessing!private! !
!StdioUtf8FileStream categoriesFor: #next:!public! !
!StdioUtf8FileStream categoriesFor: #next:into:startingAt:!accessing!public! !
!StdioUtf8FileStream categoriesFor: #nextAvailable:!public! !
!StdioUtf8FileStream categoriesFor: #position!accessing!public! !
!StdioUtf8FileStream categoriesFor: #position:!positioning!public! !
!StdioUtf8FileStream categoriesFor: #size!accessing!public! !
!StdioUtf8FileStream categoriesFor: #upToEnd!public! !

