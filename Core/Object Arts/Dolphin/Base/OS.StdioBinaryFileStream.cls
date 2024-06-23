"Filed out from Dolphin Smalltalk"!

OS.StdioFileStream
	subclass: #'OS.StdioBinaryFileStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.StdioBinaryFileStream guid: (Core.GUID fromString: '{70295d5a-b304-43e4-aa04-c800a93858d4}')!

OS.StdioBinaryFileStream comment: '`OS.StdioBinaryFileStream` is the concrete class of `StdioFileStream` for streaming over binary data.
'!

!OS.StdioBinaryFileStream categoriesForClass!Collections-Streams! !

!OS.StdioBinaryFileStream methodsFor!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements
	from the receiver."

	^ByteArray!

externalType
	"Answer a <symbol> which names the external stream type of the receiver."

	^#binary!

modeModifiers
	^'b'!

next
	"Answer an <integer> in the range 0..255, being the next of the receiver's future sequence values."

	^self basicNext!

next: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	| bytes |
	bytes := startInteger == 1
				ifTrue: [aSequenceableCollection]
				ifFalse: [aSequenceableCollection copyFrom: startInteger to: startInteger + countInteger - 1].
	self prepareToWrite.
	crtlib
		fwrite: bytes
		size: 1
		count: countInteger
		stream: stream.
	^aSequenceableCollection!

nextLine
	"Answer a Collection consisting of the receiver contents up to (but not including) the 
	next line delimiter. If there are no further line delimiters in the receiver, then the 
	rest of the receiver's contents are answered. If the receiver is at its end, then an empty 
	collection is answered."

	"Not valid for binary streams"

	^self shouldNotImplement!

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

!OS.StdioBinaryFileStream categoriesForMethods!
contentsSpecies!constants!private! !
externalType!accessing!public! !
modeModifiers!constants!private! !
next!accessing!public! !
next:putAll:startingAt:!accessing!public! !
nextLine!accessing!public! !
peek!accessing!public! !
peekFor:!accessing!public! !
upToEnd!accessing!public! !
!

!OS.StdioBinaryFileStream class methodsFor!

encodingMode
	^$b!

encodingType
	"Answer the standard encoding to use when attaching streams of this class. 
	Although this ought to be #binary at this level (untranslated binary being the most general), for historical compatibility it is not."

	^#binary!

translationMode
	^CRTConstants._O_BINARY! !

!OS.StdioBinaryFileStream class categoriesForMethods!
encodingMode!constants!private! !
encodingType!constants!public! !
translationMode!constants!private! !
!

