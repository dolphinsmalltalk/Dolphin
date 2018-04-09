"Filed out from Dolphin Smalltalk 7"!

StdioFileStream subclass: #StdioBinaryFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioBinaryFileStream guid: (GUID fromString: '{70295d5a-b304-43e4-aa04-c800a93858d4}')!
StdioBinaryFileStream comment: ''!
!StdioBinaryFileStream categoriesForClass!Collections-Streams! !
!StdioBinaryFileStream methodsFor!

contentsSpecies
	^ByteArray!

externalType
	"Answer a <symbol> which names the external stream type of the receiver."

	^#binary!

next
	"Answer an <integer> in the range 0..255, being the next of the receiver's future sequence values."

	^self basicNext!

next: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	| end bytes |
	end := startInteger + countInteger - 1.
	bytes := ((startInteger == 1 and: [end == aSequenceableCollection size])
			ifTrue: [aSequenceableCollection] 
			ifFalse: [aSequenceableCollection copyFrom: startInteger to: end]) asByteArray.
	crtlib
		fwrite: bytes
		size: 1
		count: countInteger
		stream: stream.
	^aSequenceableCollection!

nextAvailable
	"Answer a <Character>, or <integer> in the range 0..255, being the next of the 
	receiver's future sequence values. Answer nil if at EOF."

	^self basicNextAvailable!

nextAvailable: anInteger
	"Answer up to anInteger elements of the receiver's collection. The answer will be a
	collection of the same species as the one accessed by the receiver, and will contain anInteger
	elements, or as many as are left in the receiver's collection."

	^self basicNextAvailable: anInteger!

nextLine
	"Answer a Collection consisting of the receiver contents up to (but not including) the 
	next line delimiter. If there are no further line delimiters in the receiver, then the 
	rest of the receiver's contents are answered. If the receiver is at its end, then an empty 
	collection is answered."

	"Not valid for binary streams"

	^self shouldNotImplement!

nextPut: anObject
	"Store the <Character> or <integer> (in the range 0..255) as the next element of the receiver."

	^self basicNextPut: anObject!

peek
	"Answer the next element in the collection, but do not change the position reference. 
	Answer nil if the receiver is at its end."

	^self basicNextAvailable
		ifNotNil: 
			[:byte |
			crtlib ungetc: byte stream: stream.
			byte]!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the
	argument, anObject, then increment the position reference and answer true.
	Otherwise answer false and do not change the position reference"

	| ch |
	^(ch := self basicNextAvailable) notNil
		and: [ch == anObject or: 
					[crtlib ungetc: ch stream: stream.
					false]]!

upToEnd
	"Answer a collection consisting of the future sequence values of the receiver (i.e. from 
	the current position to the end)."

	"Implementation Note: Override to provide a more efficient implementation by reading the bytes as a block."

	^self basicNext: self size - self position! !
!StdioBinaryFileStream categoriesFor: #contentsSpecies!accessing!private! !
!StdioBinaryFileStream categoriesFor: #externalType!accessing!public! !
!StdioBinaryFileStream categoriesFor: #next!accessing!public! !
!StdioBinaryFileStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!StdioBinaryFileStream categoriesFor: #nextAvailable!accessing!public! !
!StdioBinaryFileStream categoriesFor: #nextAvailable:!accessing!public! !
!StdioBinaryFileStream categoriesFor: #nextLine!accessing!public! !
!StdioBinaryFileStream categoriesFor: #nextPut:!accessing!public! !
!StdioBinaryFileStream categoriesFor: #peek!accessing!public! !
!StdioBinaryFileStream categoriesFor: #peekFor:!accessing!public! !
!StdioBinaryFileStream categoriesFor: #upToEnd!accessing!public! !

