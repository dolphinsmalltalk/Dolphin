"Filed out from Dolphin Smalltalk"!

OS.StdioTextFileStream
	subclass: #'OS.StdioUnicodeFileStream'
	instanceVariableNames: 'offset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.StdioUnicodeFileStream guid: (Core.GUID fromString: '{a1e19207-b693-4313-ad8d-1f288be1a89e}')!

OS.StdioUnicodeFileStream isNonInstantiable: true!

OS.StdioUnicodeFileStream comment: '`OS.StdioUnicodeFileStream` is the abstract class of `StdioFileStream`s for streaming Unicode string data.'!

!OS.StdioUnicodeFileStream categoriesForClass!Collections-Streams! !

!OS.StdioUnicodeFileStream methodsFor!

basicNextPut: anInteger
	"Private - Store the byte <integer> (in the range 0..65535) as the next element of the receiver."

	self prepareToWrite.
	crtlib fputwc: anInteger stream: stream.
	^anInteger!

bufferClass
	"Private - The stdio buffer is always UTF-16 encoded, and the API calls always in terms of
	UTF-16 chars, regardless of the underlying file encoding."

	^Utf16String!

getchar
	| ch |
	self prepareToRead.
	ch := crtlib fgetwc: stream.
	^ch == 16rFFFF ifFalse: [ch]!

getString: aUtf16String
	^crtlib
		fgetws: aUtf16String
		n: aUtf16String size + 1
		stream: stream!

modeModifiers
	^'t'!

nextPutAll: aCollection
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	self prepareToWrite.
	crtlib fputws: aCollection asUtf16String stream: stream.
	^aCollection!

open: pathString mode: modeString flags: anInteger
	super
		open: pathString
		mode: modeString
		flags: anInteger.
	offset := crtlib _ftelli64: stream!

peek
	"Answer the next element in the collection, but do not change the position reference. 
	Answer nil if the receiver is at its end."

	| pos ch |
	pos := self position.
	ch := self nextAvailable.
	ch notNil ifTrue: [self position: pos].
	^ch!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the argument, anObject,
	then advance the current position and answer true. Otherwise answer false and do not change
	the current position."

	| pos next |
	pos := self position.
	^(next := self nextAvailable) notNil
		and: [next = anObject or: 
					[self position: pos.
					false]]!

setStream: anExternalAddress name: aString flags: anInteger
	offset := 0.
	^super
		setStream: anExternalAddress
		name: aString
		flags: anInteger!

ungetchar: aCodeUnit
	crtlib ungetwc: aCodeUnit stream: stream.
	^aCodeUnit! !

!OS.StdioUnicodeFileStream categoriesForMethods!
basicNextPut:!private!writing! !
bufferClass!constants!private! !
getchar!private!reading! !
getString:!private!reading! !
modeModifiers!constants!private! !
nextPutAll:!public!writing! !
open:mode:flags:!instance creation!private! !
peek!public!reading! !
peekFor:!public!reading! !
setStream:name:flags:!initializing!private! !
ungetchar:!private!reading! !
!

!OS.StdioUnicodeFileStream class methodsFor!

encodingType
	^#utf16le! !

!OS.StdioUnicodeFileStream class categoriesForMethods!
encodingType!constants!public! !
!

