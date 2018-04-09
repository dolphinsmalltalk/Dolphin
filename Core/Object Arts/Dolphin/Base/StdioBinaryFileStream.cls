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

	| bytes |
	bytes := aSequenceableCollection asByteArray.
	crtlib
		fwrite: bytes yourAddress + startInteger - 1
		size: 1
		count: countInteger
		stream: stream.
	^aSequenceableCollection!

nextAvailable
	"Answer a <Character>, or <integer> in the range 0..255, being the next of the 
	receiver's future sequence values. Answer nil if at EOF."

	^self basicNextAvailable!

nextPut: anObject
	"Store the <Character> or <integer> (in the range 0..255) as the next element of the receiver."

	^self basicNextPut: anObject! !
!StdioBinaryFileStream categoriesFor: #contentsSpecies!accessing!private! !
!StdioBinaryFileStream categoriesFor: #externalType!accessing!public! !
!StdioBinaryFileStream categoriesFor: #next!accessing!public! !
!StdioBinaryFileStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!StdioBinaryFileStream categoriesFor: #nextAvailable!accessing!public! !
!StdioBinaryFileStream categoriesFor: #nextPut:!accessing!public! !

