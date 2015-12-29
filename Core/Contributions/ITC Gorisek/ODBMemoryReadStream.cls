"Filed out from Dolphin Smalltalk X6.2"!

ODBStream subclass: #ODBMemoryReadStream
	instanceVariableNames: 'current'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBMemoryReadStream guid: (GUID fromString: '{8162EE29-0FB8-11D4-B091-000000000000}')!
ODBMemoryReadStream comment: ''!
!ODBMemoryReadStream categoriesForClass!No category! !
!ODBMemoryReadStream methodsFor!

createOn: aByteArray 
	position := 0.
	current := aByteArray!

getByte
	^current at: (position := position + 1)!

getByteOr14forUndefinedObject
	^(position := position + 1) > current size ifFalse: [current at: position] ifTrue: [14]!

getBytesFor: aByteCollection len: len 
	current 
		replaceBytesOf: aByteCollection
		from: 1
		to: len
		startingAt: position + 1.
	position := position + len!

getChar
	^Character value: (current at: (position := position + 1))!

getLong
	position := position + 4.
	^current dwordAtOffset: position - 4!

getPositiveInteger
	"Answer the next Integer encoded in the receiver. 
	Works for one collection only."

	| answer |
	(answer := current at: (position := position + 1)) > 127 ifFalse: [^answer].
	^(self getPositiveInteger bitShift: 7) bitOr: (answer bitAnd: 127)!

getWord
	position := position + 2.
	^current wordAtOffset: position - 2!

position
	"Answer current position on stream."

	^position!

position: anInteger 
	position := anInteger!

readFrom: aStream 
	"Read receivers contents from aStream."

	| size |
	size := aStream getLong.
	aStream position + size > aStream size ifTrue: [^self error: 'Read beyond stream size !!'].
	current := ByteArray new: size.
	aStream getBytesFor: current len: size.
	position := 0!

size
	^current size! !
!ODBMemoryReadStream categoriesFor: #createOn:!initializing!public! !
!ODBMemoryReadStream categoriesFor: #getByte!public! !
!ODBMemoryReadStream categoriesFor: #getByteOr14forUndefinedObject!public! !
!ODBMemoryReadStream categoriesFor: #getBytesFor:len:!public! !
!ODBMemoryReadStream categoriesFor: #getChar!public! !
!ODBMemoryReadStream categoriesFor: #getLong!public! !
!ODBMemoryReadStream categoriesFor: #getPositiveInteger!public! !
!ODBMemoryReadStream categoriesFor: #getWord!public! !
!ODBMemoryReadStream categoriesFor: #position!public! !
!ODBMemoryReadStream categoriesFor: #position:!public! !
!ODBMemoryReadStream categoriesFor: #readFrom:!initializing!public! !
!ODBMemoryReadStream categoriesFor: #size!public! !

!ODBMemoryReadStream class methodsFor!

createOn: bytes

    ^self new createOn: bytes!

readFrom: aStream

    ^self new readFrom: aStream! !
!ODBMemoryReadStream class categoriesFor: #createOn:!public! !
!ODBMemoryReadStream class categoriesFor: #readFrom:!public! !

