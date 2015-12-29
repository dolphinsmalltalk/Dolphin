"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ItcBase64EncoderDecoder
	instanceVariableNames: 'decodingTable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcBase64EncoderDecoder guid: (GUID fromString: '{CCFDF832-98B5-4D7D-A6AF-DD98C66196CC}')!
ItcBase64EncoderDecoder comment: ''!
!ItcBase64EncoderDecoder categoriesForClass!Unclassified! !
!ItcBase64EncoderDecoder methodsFor!

alphabet
	^'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'!

decode: aString 
	| readStream writeStream b1 b2 b3 b4 bits |
	readStream := ReadStream on: aString.
	writeStream := WriteStream on: String new.
	[readStream atEnd] whileFalse: 
			[b1 := self decodeCharacter: (self getNextCharacterFrom: readStream).
			b2 := self decodeCharacter: (self getNextCharacterFrom: readStream).
			b3 := self decodeCharacter: (self getNextCharacterFrom: readStream).
			b4 := self decodeCharacter: (self getNextCharacterFrom: readStream).
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

decode: aString ignoreInvalidCharacters: aBoolean 
	| validCharSet |
	aString isNilOrEmpty ifTrue: [^aString].
	aBoolean == true ifFalse: [^self decode: aString].
	validCharSet := self alphabet asSet.
	^self decode: (aString select: [:each | validCharSet includes: each])!

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
	^self alphabet at: anInteger + 1!

getNextCharacterFrom: readStream 
	| ch |
	
	[readStream atEnd ifTrue: [^$=].
	ch := readStream next.
	ch asInteger < 32] whileTrue.
	^ch! !
!ItcBase64EncoderDecoder categoriesFor: #alphabet!private! !
!ItcBase64EncoderDecoder categoriesFor: #decode:!public! !
!ItcBase64EncoderDecoder categoriesFor: #decode:ignoreInvalidCharacters:!public! !
!ItcBase64EncoderDecoder categoriesFor: #decodeCharacter:!private! !
!ItcBase64EncoderDecoder categoriesFor: #decodingTable!private! !
!ItcBase64EncoderDecoder categoriesFor: #encode:!public! !
!ItcBase64EncoderDecoder categoriesFor: #encodeBits:!private! !
!ItcBase64EncoderDecoder categoriesFor: #getNextCharacterFrom:!public! !

!ItcBase64EncoderDecoder class methodsFor!

decode: aString 
	^self new decode: aString!

decode: aString ignoreInvalidCharacters: aBoolean 
	^self new decode: aString ignoreInvalidCharacters: aBoolean!

encode: aString 
	^self new encode: aString! !
!ItcBase64EncoderDecoder class categoriesFor: #decode:!public! !
!ItcBase64EncoderDecoder class categoriesFor: #decode:ignoreInvalidCharacters:!public! !
!ItcBase64EncoderDecoder class categoriesFor: #encode:!public! !

