"Filed out from Dolphin Smalltalk 7"!

StdioUnicodeFileStream subclass: #StdioUtf8FileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StdioUtf8FileStream guid: (GUID fromString: '{c1c28046-101f-4bf6-92f9-e30cea1e8d82}')!
StdioUtf8FileStream comment: ''!
!StdioUtf8FileStream categoriesForClass!Collections-Streams! !
!StdioUtf8FileStream methodsFor!

basicNext: anInteger
	^(super basicNext: anInteger) asUtf8String!

contents
	"Answer a <Utf8String> containing the complete contents of the file accessed by the
	receiver."

	self reset.
	^self upToEnd!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements
	from the receiver."

	^Utf8String!

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

translationMode
	^CRTConstants._O_U8TEXT!

upToEnd
	"Answer a collection consisting of the future sequence values of the receiver (i.e. from 
	the current position to the end)."

	^super upToEnd asUtf8String! !
!StdioUtf8FileStream categoriesFor: #basicNext:!accessing!private! !
!StdioUtf8FileStream categoriesFor: #contents!accessing!public! !
!StdioUtf8FileStream categoriesFor: #contentsSpecies!constants!private! !
!StdioUtf8FileStream categoriesFor: #position!accessing!public! !
!StdioUtf8FileStream categoriesFor: #position:!positioning!public! !
!StdioUtf8FileStream categoriesFor: #size!accessing!public! !
!StdioUtf8FileStream categoriesFor: #translationMode!constants!private! !
!StdioUtf8FileStream categoriesFor: #upToEnd!accessing!public! !

!StdioUtf8FileStream class methodsFor!

encodingType
	^#utf8! !
!StdioUtf8FileStream class categoriesFor: #encodingType!constants!public! !

