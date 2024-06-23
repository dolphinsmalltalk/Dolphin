"Filed out from Dolphin Smalltalk"!

OS.StdioUnicodeFileStream
	subclass: #'OS.StdioUtf8FileStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.StdioUtf8FileStream guid: (Core.GUID fromString: '{c1c28046-101f-4bf6-92f9-e30cea1e8d82}')!

OS.StdioUtf8FileStream comment: '`OS.StdioUtf16FileStream` is the concrete class of `StdioFileStream` for streaming over UTF-8 encoded data.'!

!OS.StdioUtf8FileStream categoriesForClass!Collections-Streams! !

!OS.StdioUtf8FileStream methodsFor!

basicNext: anInteger
	^(super basicNext: anInteger) asUtf8String!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements
	from the receiver."

	^Utf8String!

modeModifiers
	^'t, ccs=UTF-8'!

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

	^super upToEnd asUtf8String! !

!OS.StdioUtf8FileStream categoriesForMethods!
basicNext:!accessing!private! !
contentsSpecies!constants!private! !
modeModifiers!constants!private! !
position!accessing!public! !
position:!positioning!public! !
size!accessing!public! !
upToEnd!accessing!public! !
!

!OS.StdioUtf8FileStream class methodsFor!

encodingType
	^#utf8!

translationMode
	^CRTConstants._O_U8TEXT! !

!OS.StdioUtf8FileStream class categoriesForMethods!
encodingType!constants!public! !
translationMode!constants!private! !
!

