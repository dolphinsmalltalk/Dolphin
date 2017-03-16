"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StsBase64EncoderDecoder
	instanceVariableNames: 'decodingTable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsBase64EncoderDecoder guid: (GUID fromString: '{d283869c-d796-4d33-9768-2ab1eb314ea8}')!
StsBase64EncoderDecoder comment: ''!
!StsBase64EncoderDecoder categoriesForClass!Unclassified! !
!StsBase64EncoderDecoder methodsFor!

alphabet
	^'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'!

decode: aString 
	| readStream writeStream b1 b2 b3 b4 bits |
	readStream := ReadStream on: aString.
	writeStream := WriteStream on: String new.
	[readStream atEnd] whileFalse: 
			[b1 := self decodeCharacter: readStream next.
			b2 := self decodeCharacter: readStream next.
			b3 := self decodeCharacter: readStream next.
			b4 := self decodeCharacter: readStream next.
			bits := b1 << 2 bitOr: b2 >> 4.
			writeStream nextPut: bits asCharacter.
			b3 isNil 
				ifFalse: 
					[bits := (b2 bitAnd: 15) << 4 bitOr: (b3 bitAnd: 60) >> 2.
					writeStream nextPut: bits asCharacter.
					b4 isNil 
						ifFalse: 
							[bits := (b3 bitAnd: 3) << 6 bitOr: b4.
							writeStream nextPut: bits asCharacter]]].
	^writeStream contents!

decodeCharacter: aCharacter 
	^self decodingTable at: aCharacter ifAbsent: []!

decodingTable
	| alphabet |
	decodingTable isNil 
		ifTrue: 
			[decodingTable := LookupTable new.
			alphabet := self alphabet asOrderedCollection.
			alphabet keysAndValuesDo: [:index :each | decodingTable at: each put: index - 1]].
	^decodingTable!

encode: aString 
	| readStream writeStream b1 b2 b3 bits |
	readStream := ReadStream on: aString.
	writeStream := WriteStream on: String new.
	[readStream atEnd] whileFalse: 
			[b1 := readStream next asInteger.
			b2 := readStream atEnd ifFalse: [readStream next asInteger].
			b3 := readStream atEnd ifFalse: [readStream next asInteger].
			bits := (b1 bitAnd: 252) >> 2.
			writeStream nextPut: (self encodeBits: bits).
			bits := b2 isNil 
						ifTrue: [(b1 bitAnd: 3) << 4]
						ifFalse: [(b1 bitAnd: 3) << 4 bitOr: (b2 bitAnd: 240) >> 4].
			writeStream nextPut: (self encodeBits: bits).
			b3 isNil 
				ifTrue: 
					[b2 isNil 
						ifTrue: [writeStream nextPutAll: '==']
						ifFalse: 
							[bits := (b2 bitAnd: 15) << 2.
							writeStream nextPut: (self encodeBits: bits).
							writeStream nextPut: $=]]
				ifFalse: 
					[bits := (b2 bitAnd: 15) << 2 bitOr: (b3 bitAnd: 192) >> 6.
					writeStream nextPut: (self encodeBits: bits).
					bits := b3 bitAnd: 63.
					writeStream nextPut: (self encodeBits: bits)]].
	^writeStream contents!

encodeBits: anInteger 
	^self alphabet at: anInteger + 1! !
!StsBase64EncoderDecoder categoriesFor: #alphabet!private! !
!StsBase64EncoderDecoder categoriesFor: #decode:!public! !
!StsBase64EncoderDecoder categoriesFor: #decodeCharacter:!private! !
!StsBase64EncoderDecoder categoriesFor: #decodingTable!private! !
!StsBase64EncoderDecoder categoriesFor: #encode:!public! !
!StsBase64EncoderDecoder categoriesFor: #encodeBits:!private! !

!StsBase64EncoderDecoder class methodsFor!

decode: aString 
	^self new decode: aString!

encode: aString 
	^self new encode: aString! !
!StsBase64EncoderDecoder class categoriesFor: #decode:!public! !
!StsBase64EncoderDecoder class categoriesFor: #encode:!public! !

