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
	"Answer an <integer> in the range 0..65535, being the next of the receiver's future sequence
	values. Answer nil if at EOF."

	| ch |
	ch := crtlib fgetwc: stream.
	^ch == 16rFFFF ifFalse: [ch]!

basicNextPut: anInteger
	"Store the byte <integer> (in the range 0..65535) as the next element of the receiver."

	crtlib fputwc: anInteger stream: stream.
	^anInteger!

next
	"Answer a <Character> being the next of the receiver's future sequence values interpreted as
	a Unicode code point. Raise an error if at EOF."

	"The stdio API is always working in UTF-16, regardless of the underlying encoding of the stream."

	^(Utf16String decodeNextFrom: self) ifNil: [self errorEndOfStream]!

next: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	| end utf16 |
	end := startInteger + countInteger - 1.
	utf16 := (startInteger == 1 and: [end == aSequenceableCollection size])
				ifTrue: [aSequenceableCollection asUtf16String]
				ifFalse: [(aSequenceableCollection copyFrom: startInteger to: end) asUtf16String].
	crtlib fputws: utf16 stream: stream.
	^aSequenceableCollection!

nextAvailable
	"Answer a <Character> being the next of the receiver's future sequence values interpreted as
	an ANSI code point. Answer nil if at EOF."

	^Utf16String decodeNextFrom: self!

nextLine
	"Answer a Collection consisting of the receiver contents up to (but not including) the 
	next line delimiter. If there are no further line delimiters in the receiver, then the 
	rest of the receiver's contents are answered. If the receiver is at its end, then an empty 
	collection is answered."

	| buf answer len last blockSize |
	self atEnd ifTrue: [^''].
	answer := Utf16String writeStream.
	blockSize := 128.
	buf := Utf16String newFixed: blockSize.
	
	[| part |
	part := crtlib
				fgetws: buf
				n: buf byteSize
				stream: stream.
	part isNil
		ifTrue: 
			["Hit eof"
			^answer contents].
	answer nextPutAll: part.
	part size == blockSize]
			whileTrue.
	answer := answer contents.
	len := answer size.
	"Strip off the line terminator, allowing for binary or text mode"
	last := answer at: len.
	^last == $\n
		ifTrue: 
			[(len > 1 and: [(answer at: len - 1) == $\r])
				ifTrue: [answer copyFrom: 1 to: len - 2]
				ifFalse: [answer copyFrom: 1 to: len - 1]]
		ifFalse: [last == $\r ifTrue: [answer copyFrom: 1 to: len - 1] ifFalse: [answer]]!

nextPut: anObject
	"Store the <Character> as the next element of the receiver."

	"Implementation Note: Although the underlying encoding may be UTF-8, we have to work through an API that expects UTF-16"

	^Utf16String encodeOn: self put: anObject!

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
!StdioUnicodeFileStream categoriesFor: #basicNextAvailable!accessing!public! !
!StdioUnicodeFileStream categoriesFor: #basicNextPut:!public! !
!StdioUnicodeFileStream categoriesFor: #next!accessing!public! !
!StdioUnicodeFileStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!StdioUnicodeFileStream categoriesFor: #nextAvailable!accessing!public! !
!StdioUnicodeFileStream categoriesFor: #nextLine!accessing!public! !
!StdioUnicodeFileStream categoriesFor: #nextPut:!accessing!public! !
!StdioUnicodeFileStream categoriesFor: #nextPutAll:!accessing!public! !
!StdioUnicodeFileStream categoriesFor: #open:mode:!instance creation!private! !
!StdioUnicodeFileStream categoriesFor: #setStream:name:mode:!initializing!private! !

