"Filed out from Dolphin Smalltalk 7"!

StdioTextFileStream subclass: #StdioAnsiFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioAnsiFileStream guid: (GUID fromString: '{37ed07fd-6fc6-41d9-aa82-7147a1af19fd}')!
StdioAnsiFileStream comment: ''!
!StdioAnsiFileStream categoriesForClass!Collections-Streams! !
!StdioAnsiFileStream methodsFor!

basicNextPut: anObject
	"Store the byte <Character> or <integer> (in the range 0..255) as the next element of the receiver."

	crtlib fputc: anObject stream: stream.
	^anObject!

contentsSpecies
	^AnsiString!

next
	"Answer a <Character> being the next of the receiver's future sequence values interpreted as
	an ANSI code point. Raise an error if at EOF."

	^Character ansiValue: self basicNext!

next: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	| bytes |
	bytes := aSequenceableCollection asAnsiString.
	crtlib
		fwrite: bytes yourAddress + startInteger - 1
		size: 1
		count: countInteger
		stream: stream.
	^aSequenceableCollection!

nextAvailable
	"Answer a <Character> being the next of the receiver's future sequence values interpreted as
	an ANSI code point. Answer nil if at EOF."

	^self basicNextAvailable ifNotNil: [:ch | Character ansiValue: ch]!

nextLine
	"Answer a Collection consisting of the receiver contents up to (but not including) the 
	next line delimiter. If there are no further line delimiters in the receiver, then the 
	rest of the receiver's contents are answered. If the receiver is at its end, then an empty 
	collection is answered."

	| buf answer len last blockSize |
	self atEnd ifTrue: [^''].
	answer := AnsiString writeStream.
	blockSize := 128.
	buf := AnsiString newFixed: blockSize.
	
	[| part |
	part := crtlib
				fgets: buf
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

nextPut: aCharacter
	"Store the ANSI <Character> as the next element of the receiver. An error will be raised if
	the <Character> is not a valid ANSI code point for the current code page."

	self basicNextPut: aCharacter ansiValue.
	^aCharacter!

nextPutAll: aCollection 
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"
	
	crtlib fputs: aCollection asAnsiString stream: stream.
	^aCollection! !
!StdioAnsiFileStream categoriesFor: #basicNextPut:!public! !
!StdioAnsiFileStream categoriesFor: #contentsSpecies!accessing!private! !
!StdioAnsiFileStream categoriesFor: #next!accessing!public! !
!StdioAnsiFileStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!StdioAnsiFileStream categoriesFor: #nextAvailable!accessing!public! !
!StdioAnsiFileStream categoriesFor: #nextLine!accessing!public! !
!StdioAnsiFileStream categoriesFor: #nextPut:!public! !
!StdioAnsiFileStream categoriesFor: #nextPutAll:!accessing!public! !

