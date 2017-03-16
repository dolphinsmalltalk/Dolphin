"Filed out from Dolphin Smalltalk 7"!

ODBStream subclass: #ODBMemoryWriteStream
	instanceVariableNames: 'collections current readLimit lastSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBMemoryWriteStream guid: (GUID fromString: '{8162ee2a-0fb8-11d4-b091-000000000000}')!
ODBMemoryWriteStream comment: ''!
!ODBMemoryWriteStream categoriesForClass!No category! !
!ODBMemoryWriteStream methodsFor!

asByteArray
	"Answer receiver as byte array."

	| i bytes pos len coll bytesSize |
	bytes := ByteArray new: (bytesSize := self size).
	pos := 0.
	i := 1.
	
	[coll := collections at: i.
	len := coll size.
	pos + len < bytesSize] whileTrue: 
				[bytes 
					replaceFrom: pos + 1
					to: (pos := pos + len)
					with: coll
					startingAt: 1.
				i := i + 1].
	bytes 
		replaceFrom: pos + 1
		to: bytesSize
		with: coll
		startingAt: 1.
	^bytes!

asStringObject
	"Answer receiver as string
        (selector #asString is not used because of printing on screen)."

	| i string pos len coll bytesSize |
	string := String new: (bytesSize := self size).
	pos := 0.
	i := 1.
	
	[coll := collections at: i.
	len := coll size.
	pos + len < bytesSize] whileTrue: 
				[string 
					replaceFrom: pos + 1
					to: (pos := pos + len)
					with: coll
					startingAt: 1.
				i := i + 1].
	string 
		replaceFrom: pos + 1
		to: bytesSize
		with: coll
		startingAt: 1.
	^string!

initialize
	collections := OrderedCollection new.
	readLimit := 0.
	position := 0!

makeSpace
	"Private - Add space on end of stream (add new collection)."

	collections add: (current := ByteArray new: (readLimit := 1024)).
	position := 0.
	lastSize := 0!

moveToNext
	"Private - Move to next collection or
        add space on end of stream if at last collection."

	position := 0.
	(current isNil or: [current == collections last]) 
		ifTrue: 
			[collections add: (current := ByteArray new: (readLimit := 1024)).
			lastSize := 0]
		ifFalse: 
			[1 to: collections size
				do: [:i | (collections at: i) == current ifTrue: [^current := collections at: i + 1]]]!

position
	"Answer current position on stream."

	| i size coll |
	current isNil ifTrue: [^0].
	i := 1.
	size := 0.
	[(coll := collections at: i) == current] whileFalse: 
			[i := i + 1.
			size := size + coll size].
	^size + position!

position: anInteger 
	"Set current position on stream."

	collections last == current ifTrue: [lastSize < position ifTrue: [lastSize := position]].
	position := anInteger.
	1 to: collections size
		do: 
			[:i | 
			current := collections at: i.
			position <= (readLimit := current size) ifTrue: [^self].
			position := position - readLimit].
	^self error: 'Position outside of stream !!'!

putByte: aByte 
	position < readLimit ifFalse: [self moveToNext].
	current at: (position := position + 1) put: aByte!

putBytesFrom: aByteCollection len: len 
	"Write aByteCollection to stream."

	len > (readLimit - position) 
		ifTrue: 
			[(current notNil 
				and: [collections last == current and: [len > 64 and: [len <= aByteCollection size]]]) 
					ifTrue: 
						[collections at: collections size put: (current copyFrom: 1 to: position).
						aByteCollection size = len 
							ifTrue: [collections add: aByteCollection]
							ifFalse: [collections add: (aByteCollection copyFrom: 1 to: len)].
						self makeSpace]
					ifFalse: [1 to: len do: [:i | self putByte: (aByteCollection at: i) asInteger]]]
		ifFalse: 
			[current 
				replaceFrom: position + 1
				to: position + len
				with: aByteCollection
				startingAt: 1.
			position := position + len]!

size
	"Answer stream size."

	| size count |
	current isNil ifTrue: [^0].
	size := 0.
	count := collections size.
	1 to: count - 1 do: [:i | size := size + (collections at: i) size].
	current == (collections at: count) 
		ifTrue: [lastSize < position ifTrue: [lastSize := position]].
	^size + lastSize!

writeOn: aStream 
	"Write receivers contents on aStream."

	| count |
	aStream putLong: self size.
	(count := collections size) == 0 
		ifFalse: 
			[1 to: count - 1 do: [:i | aStream putBytesFrom: (collections at: i)].
			aStream putBytesFrom: (collections at: count) len: lastSize]! !
!ODBMemoryWriteStream categoriesFor: #asByteArray!public! !
!ODBMemoryWriteStream categoriesFor: #asStringObject!public! !
!ODBMemoryWriteStream categoriesFor: #initialize!private! !
!ODBMemoryWriteStream categoriesFor: #makeSpace!private! !
!ODBMemoryWriteStream categoriesFor: #moveToNext!private! !
!ODBMemoryWriteStream categoriesFor: #position!public! !
!ODBMemoryWriteStream categoriesFor: #position:!public! !
!ODBMemoryWriteStream categoriesFor: #putByte:!public! !
!ODBMemoryWriteStream categoriesFor: #putBytesFrom:len:!public! !
!ODBMemoryWriteStream categoriesFor: #size!public! !
!ODBMemoryWriteStream categoriesFor: #writeOn:!public! !

!ODBMemoryWriteStream class methodsFor!

new

    ^super new initialize! !
!ODBMemoryWriteStream class categoriesFor: #new!instance creation!public! !

