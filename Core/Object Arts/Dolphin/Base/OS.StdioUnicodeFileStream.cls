"Filed out from Dolphin Smalltalk 7"!

OS.StdioTextFileStream subclass: #'OS.StdioUnicodeFileStream'
	instanceVariableNames: 'offset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.StdioUnicodeFileStream guid: (Core.GUID fromString: '{a1e19207-b693-4313-ad8d-1f288be1a89e}')!
OS.StdioUnicodeFileStream isNonInstantiable: true!
OS.StdioUnicodeFileStream comment: ''!
!OS.StdioUnicodeFileStream categoriesForClass!Collections-Streams! !
!OS.StdioUnicodeFileStream methodsFor!

basicNextAvailable
	"Private - Answer an <integer> in the range 0..65535, being the next of the receiver's future sequence
	values. Answer nil if at EOF."

	^(crtlib feof: stream)
		ifFalse: 
			[| ch |
			ch := crtlib fgetwc: stream.
			ch == 16rFFFF ifFalse: [ch]]!

basicNextPut: anInteger
	"Private - Store the byte <integer> (in the range 0..65535) as the next element of the receiver."

	crtlib fputwc: anInteger stream: stream.
	^anInteger!

basicPeek
	| ch |
	ch := crtlib fgetwc: stream.
	^ch == 16rFFFF
		ifFalse: 
			[crtlib ungetwc: ch stream: stream.
			ch]!

bufferClass
	"Private - The stdio buffer is always UTF-16 encoded, and the API calls always in terms of
	UTF-16 chars, regardless of the underlying file encoding."

	^Utf16String!

getString: aUtf16String
	^crtlib
		fgetws: aUtf16String
		n: aUtf16String size + 1
		stream: stream!

nextPutAll: aCollection
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	crtlib fputws: aCollection asUtf16String stream: stream.
	^aCollection!

open: fileId mode: modeSymbol
	super
		open: fileId
		mode: modeSymbol.
	offset := crtlib _ftelli64: stream!

setStream: anExternalAddress name: aString flags: anInteger
	offset := 0.
	^super
		setStream: anExternalAddress
		name: aString
		flags: anInteger!

translationMode
	^CRTConstants._O_U16TEXT! !
!OS.StdioUnicodeFileStream categoriesFor: #basicNextAvailable!accessing!private! !
!OS.StdioUnicodeFileStream categoriesFor: #basicNextPut:!accessing!private! !
!OS.StdioUnicodeFileStream categoriesFor: #basicPeek!accessing!private! !
!OS.StdioUnicodeFileStream categoriesFor: #bufferClass!constants!private! !
!OS.StdioUnicodeFileStream categoriesFor: #getString:!accessing!private! !
!OS.StdioUnicodeFileStream categoriesFor: #nextPutAll:!accessing!public! !
!OS.StdioUnicodeFileStream categoriesFor: #open:mode:!instance creation!private! !
!OS.StdioUnicodeFileStream categoriesFor: #setStream:name:flags:!initializing!private! !
!OS.StdioUnicodeFileStream categoriesFor: #translationMode!constants!private! !

!OS.StdioUnicodeFileStream class methodsFor!

encodingType
	^#utf16le! !
!OS.StdioUnicodeFileStream class categoriesFor: #encodingType!constants!public! !

