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

basicNextAvailable
	"Private - Answer an <integer> in the range 0..65535, being the next of the receiver's future sequence
	values. Answer nil if at EOF."

	| ch |
	ch := crtlib fgetwc: stream.
	^ch == 16rFFFF ifFalse: [ch]!

basicNextPut: anInteger
	"Private - Store the byte <integer> (in the range 0..65535) as the next element of the receiver."

	crtlib fputwc: anInteger stream: stream.
	^anInteger!

encodingClass
	"Private - The stdio buffer is always UTF-16 encoded, and the API calls always in terms of UTF-16 chars, regardless of the underlying file encoding."

	^Utf16String!

getString: aUtf16String
	^crtlib
		fgetws: aUtf16String
		n: aUtf16String size + 1
		stream: stream!

nextAvailable: anInteger
	"Answer up to anInteger elements of the receiver's collection. Generally, the answer will be
	a collection of the same class as the one accessed by the receiver (though this is
	determined by the receiver), and will contain anInteger elements, or as many as are left in
	the receiver's collection."

	"Implementation Note: #atEnd test is very slow on StdioFileStreams, so to be avoided."

	| newStream count next |
	newStream := self contentsSpecies writeStream: (count := anInteger).
	[count == 0 or: [(next := self nextAvailable) isNil]] whileFalse: 
			[newStream nextPut: next.
			count := count - 1].
	^newStream contents!

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
!StdioUnicodeFileStream categoriesFor: #basicNextAvailable!accessing!private! !
!StdioUnicodeFileStream categoriesFor: #basicNextPut:!accessing!private! !
!StdioUnicodeFileStream categoriesFor: #encodingClass!accessing!constants!private! !
!StdioUnicodeFileStream categoriesFor: #getString:!accessing!private! !
!StdioUnicodeFileStream categoriesFor: #nextAvailable:!accessing!public! !
!StdioUnicodeFileStream categoriesFor: #nextPutAll:!accessing!public! !
!StdioUnicodeFileStream categoriesFor: #open:mode:!instance creation!private! !
!StdioUnicodeFileStream categoriesFor: #setStream:name:mode:!initializing!private! !

