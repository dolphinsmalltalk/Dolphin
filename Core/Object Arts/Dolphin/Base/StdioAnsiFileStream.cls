"Filed out from Dolphin Smalltalk"!

StdioTextFileStream subclass: #StdioAnsiFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StdioAnsiFileStream guid: (GUID fromString: '{37ed07fd-6fc6-41d9-aa82-7147a1af19fd}')!

StdioAnsiFileStream comment: ''!

!StdioAnsiFileStream categoriesForClass!Collections-Streams! !

!StdioAnsiFileStream methodsFor!

contentsSpecies
	^AnsiString!

getString: anAnsiString
	^crtlib
		fgets: anAnsiString
		n: anAnsiString size + 1
		stream: stream!

next
	"Answer a <Character> being the next of the receiver's future sequence values interpreted as
	an ANSI code point. Raise an error if at EOF."

	^Character ansiValue: self basicNext!

nextPutAll: aCollection 
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"
	
	crtlib fputs: aCollection asAnsiString stream: stream.
	^aCollection!

peek
	"Answer the next element in the collection, but do not change the position reference. 
	Answer nil if the receiver is at its end."

	^self basicNextAvailable
		ifNotNil: 
			[:ch |
			crtlib ungetc: ch stream: stream.
			Character ansiValue: ch]!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the
	argument, anObject, then increment the position reference and answer true.
	Otherwise answer false and do not change the position reference"

	| ch |
	^(ch := self basicNextAvailable) notNil
		and: [ch == anObject ansiValue or: 
					[crtlib ungetc: ch stream: stream.
					false]]! !

!StdioAnsiFileStream categoriesForMethods!
contentsSpecies!accessing!private! !
getString:!accessing!private! !
next!accessing!public! !
nextPutAll:!accessing!public! !
peek!accessing!public! !
peekFor:!accessing!public! !
!

