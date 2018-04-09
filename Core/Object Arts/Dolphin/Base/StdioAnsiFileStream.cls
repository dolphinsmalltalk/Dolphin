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

nextAvailable
	"Answer a <Character> being the next of the receiver's future sequence values interpreted as
	an ANSI code point. Answer nil if at EOF."

	^self basicNextAvailable ifNotNil: [:ch | Character ansiValue: ch]!

nextAvailable: anInteger
	"Answer up to anInteger elements of the receiver's collection. The answer will be a
	collection of the same species as the one accessed by the receiver, and will contain anInteger
	elements, or as many as are left in the receiver's collection."

	^self basicNextAvailable: anInteger!

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
					false]]!

upToEnd
	"Answer a collection consisting of the future sequence values of the receiver (i.e. from 
	the current position to the end)."

	"Implementation Note: Override to provide a more efficient implementation by reading the bytes as a block.
	Note however that due to line end translations, the number of characters read will probably be significantly 
	fewer than the remaining size of the file."

	^self basicNextAvailable: self size - self position! !
!StdioAnsiFileStream categoriesFor: #contentsSpecies!accessing!private! !
!StdioAnsiFileStream categoriesFor: #getString:!accessing!private! !
!StdioAnsiFileStream categoriesFor: #next!accessing!public! !
!StdioAnsiFileStream categoriesFor: #nextAvailable!accessing!public! !
!StdioAnsiFileStream categoriesFor: #nextAvailable:!accessing!public! !
!StdioAnsiFileStream categoriesFor: #nextPutAll:!accessing!public! !
!StdioAnsiFileStream categoriesFor: #peek!accessing!public! !
!StdioAnsiFileStream categoriesFor: #peekFor:!accessing!public! !
!StdioAnsiFileStream categoriesFor: #upToEnd!accessing!public! !

