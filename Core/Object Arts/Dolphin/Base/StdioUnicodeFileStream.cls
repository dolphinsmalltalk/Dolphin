"Filed out from Dolphin Smalltalk 7"!

StdioTextFileStream subclass: #StdioUnicodeFileStream
	instanceVariableNames: 'offset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioUnicodeFileStream guid: (GUID fromString: '{a1e19207-b693-4313-ad8d-1f288be1a89e}')!
StdioUnicodeFileStream isAbstract: true!
StdioUnicodeFileStream comment: ''!
!StdioUnicodeFileStream categoriesForClass!Collections-Streams! !
!StdioUnicodeFileStream methodsFor!

attach: anExternalHandle toFd: fdInteger mode: aString
	"Private - Attach the stdio descriptor identified by fdInteger (usually one of 0=stdin,
	1=stdout, or 2-stderr) to the specified OS file, and open a stdio stream onto it in the
	specified stdio mode."

	super attach: anExternalHandle toFd: fdInteger mode: aString.
	crtlib _setmode: fd mode: CRTConstants._O_U16TEXT!

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

setStream: anExternalAddress name: aString mode: modeString
	offset := 0.
	super
		setStream: anExternalAddress
		name: aString
		mode: modeString! !
!StdioUnicodeFileStream categoriesFor: #attach:toFd:mode:!initializing!private! !
!StdioUnicodeFileStream categoriesFor: #basicNextAvailable!accessing!private! !
!StdioUnicodeFileStream categoriesFor: #basicNextPut:!accessing!private! !
!StdioUnicodeFileStream categoriesFor: #basicPeek!accessing!private! !
!StdioUnicodeFileStream categoriesFor: #bufferClass!constants!private! !
!StdioUnicodeFileStream categoriesFor: #getString:!accessing!private! !
!StdioUnicodeFileStream categoriesFor: #nextPutAll:!accessing!public! !
!StdioUnicodeFileStream categoriesFor: #open:mode:!instance creation!private! !
!StdioUnicodeFileStream categoriesFor: #setStream:name:mode:!initializing!private! !

