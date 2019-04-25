"Filed out from Dolphin Smalltalk 7"!

UtfEncodedString variableByteSubclass: #Utf8String
	instanceVariableNames: ''
	classVariableNames: 'Bom LeadByteMask2 LeadByteMask3 LeadByteMask4 TrailByteMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Utf8String guid: (GUID fromString: '{c5ab1b05-241f-4955-8b44-0c80b93bafbb}')!
Utf8String isNullTerminated: true!
Utf8String addClassConstant: 'Bom' value: #[239 187 191 ]!
Utf8String addClassConstant: 'LeadByteMask2' value: 16rC0!
Utf8String addClassConstant: 'LeadByteMask3' value: 16rE0!
Utf8String addClassConstant: 'LeadByteMask4' value: 16rF0!
Utf8String addClassConstant: 'TrailByteMask' value: 16r80!
Utf8String comment: '`Utf8String` is the class of `Strings`s that use a the multi-byte UTF-8 encoding. UTF-8 is the defacto standard for text interchange, and is now the default representation in Dolphin.

The cautionary notes in the abstract superclass `UtfEncodedString` should be read carefully to understand the compromises made in introducing a variable width encoding into the `SequenceableCollection` hierarchy.'!
!Utf8String categoriesForClass!Collections-Text! !
!Utf8String methodsFor!

_beginsString: aString
	^(CRTLibrary default
		strncmp: aString asUtf8String
		string2: self
		count: self size) == 0!

asLowercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to lowercase."

	| utf16 |
	utf16 := self asUtf16String.
	UserLibrary default charLowerBuffW: utf16 cchLength: utf16 size.
	^utf16 asUtf8String!

asUppercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to uppercase."

	| utf16 |
	utf16 := self asUtf16String.
	UserLibrary default charUpperBuffW: utf16 cchLength: utf16 size.
	^utf16 asUtf8String!

asUtf8String
	"Answer a UTF-8 encoded string representation of the receiver."

	^self!

bom 
	^Bom!

copyToBuffer: anAddress ofSize: anInteger
	CRTLibrary default
		strncpy_s: anAddress
		bufferSize: anInteger
		strSource: self
		count: CRTConstants._TRUNCATE!

decodeNextFrom: aReadStream
	"Private - Read the next <Character> in the receiver's encoding from the <ReadStream> argument ."

	"0xxxxxxx	0x00..0x7F	1-byte character encoding for ASCII
	110xxxxx	0xC0..0xDF	Lead byte of a 2-byte character encoding
	1110xxxx	0xE0..0xEF	Lead byte of a 3-byte character encoding
	11110xxx	0xF0..0xF4	Lead byte of a 4-byte character encoding
	10xxxxxx	0x80..0xBF	Continuation bytes (x1, x2, or x3)"

	^aReadStream basicNextAvailable
		ifNotNil: 
			[:c |
			c < 16r80
				ifTrue: 
					["Ascii char"
					Character asciiValue: c]
				ifFalse: 
					["Lead byte?"
					c >= 16rC0
						ifTrue: 
							["At least 2 byte character"
							aReadStream basicNextAvailable
								ifNil: [^Character.Utf8Default]
								ifNotNil: 
									[:c2 |
									| codePoint |
									(c2 bitAnd: 16rC0) == 16r80
										ifTrue: [codePoint := (c bitAnd: 16r1F) << 6 bitOr: (c2 bitAnd: 16r3F)]
										ifFalse: 
											["Invalid1st continuation"
											aReadStream pop.
											^Character.Utf8Default].
									c >= 16rE0
										ifTrue: 
											["At least a 3-byte character"
											aReadStream basicNextAvailable
												ifNil: [^Character.Utf8Default]
												ifNotNil: 
													[:c3 |
													(c3 bitAnd: 16rC0) == 16r80
														ifTrue: [codePoint := (codePoint bitAnd: 16r3FF) << 6 bitOr: (c3 bitAnd: 16r3F)]
														ifFalse: 
															["Invalid 2nd continuation"
															aReadStream pop.
															^Character.Utf8Default].
													c >= 16rF0
														ifTrue: 
															["4-byte character"
															aReadStream basicNextAvailable
																ifNil: [^Character.Utf8Default]
																ifNotNil: 
																	[:c4 |
																	(c4 bitAnd: 16rC0) == 16r80
																		ifTrue: [codePoint := (codePoint bitAnd: 16r7FFF) << 6 bitOr: (c4 bitAnd: 16r3F)]
																		ifFalse: 
																			["Invalid 3rd continuation"
																			aReadStream pop.
																			^Character.Utf8Default]]]]].
									Character codePoint: codePoint ifInvalid: [Character.Utf8Default]]]
						ifFalse: 
							["On a continution byte so in the middle of a character, which is invalid"
							Character.Utf8Default]]]!

encodedAt: anInteger put: aCharacter
	"Private - Encode the specified <Character> beginning at the specified position in the receiver.
	Answer the <integer> index of the last code unit updated."

	| codePoint |
	codePoint := aCharacter codePoint.
	^codePoint < 16r80
		ifTrue: 
			[self basicAt: anInteger put: codePoint.
			anInteger]
		ifFalse: 
			[codePoint < 16r800
				ifTrue: 
					["2-byte encoding"
					self
						basicAt: anInteger put: (LeadByteMask2 bitOr: (codePoint bitShift: -6));
						basicAt: anInteger + 1 put: (TrailByteMask bitOr: (codePoint bitAnd: 16r3F)).
					anInteger + 1]
				ifFalse: 
					[codePoint < 16rFFFF
						ifTrue: 
							["3-byte encoding"
							self
								basicAt: anInteger put: (LeadByteMask3 bitOr: (codePoint bitShift: -12));
								basicAt: anInteger + 1 put: (TrailByteMask bitOr: ((codePoint bitShift: -6) bitAnd: 16r3F));
								basicAt: anInteger + 2 put: (TrailByteMask bitOr: (codePoint bitAnd: 16r3F)).
							anInteger + 2]
						ifFalse: 
							["4-byte encoding"
							codePoint <= Win32Constants.MAX_UCSCHAR
								ifTrue: 
									[self
										basicAt: anInteger put: (LeadByteMask4 bitOr: (codePoint bitShift: -18));
										basicAt: anInteger + 1 put: (TrailByteMask bitOr: ((codePoint bitShift: -12) bitAnd: 16r3F));
										basicAt: anInteger + 2 put: (TrailByteMask bitOr: ((codePoint bitShift: -6) bitAnd: 16r3F));
										basicAt: anInteger + 3 put: (TrailByteMask bitOr: (codePoint bitAnd: 16r3F)).
									anInteger + 3]
								ifFalse: [self class errorInvalidCodePoint: codePoint]]]]!

encodedSizeOf: aCharacter
	"Private - Answer the number of basic slots occupied by the argument when encoded in the receiver."

	^aCharacter isUtf8
		ifTrue: [1]
		ifFalse: 
			[| codePoint |
			codePoint := aCharacter codePoint.
			codePoint < 16r800 ifTrue: [2] ifFalse: [codePoint < 16rFFFF ifTrue: [3] ifFalse: [4]]]!

encodeOn: aPuttableStream put: aCharacter
	"Private - Encode the <Character> argument onto the <WriteStream> argument using the UTF-8 encoding.
	This requires between one and four byte code units to be written to the stream, depending on
	the magnitude of the code point. An error is raised if the <Character> has an invalid code
	point, or is a UTF-16 surrogate. If the <Character> is a UTF-8 surrogate, the surrogate code
	point emitted directly."

	^aCharacter isUtf8
		ifTrue: [aPuttableStream basicNextPut: aCharacter codeUnit]
		ifFalse: 
			[| codePoint |
			codePoint := aCharacter codePoint.
			codePoint < 16r800
				ifTrue: 
					["2-byte encoding"
					aPuttableStream
						basicNextPut: (16rC0 bitOr: (codePoint bitShift: -6));
						basicNextPut: (16r80 bitOr: (codePoint bitAnd: 16r3F))]
				ifFalse: 
					[codePoint < 16rFFFF
						ifTrue: 
							["3-byte encoding"
							(codePoint bitAnd: 16rF800) == 16rD800
								ifTrue: [self error: 'Cannot encode UTF-16 surrogate into UTF-8']
								ifFalse: 
									[aPuttableStream
										basicNextPut: (16rE0 bitOr: (codePoint bitShift: -12));
										basicNextPut: (16r80 bitOr: ((codePoint bitShift: -6) bitAnd: 16r3F));
										basicNextPut: (16r80 bitOr: (codePoint bitAnd: 16r3F))]]
						ifFalse: 
							["4-byte encoding"
							codePoint <= Win32Constants.MAX_UCSCHAR
								ifTrue: 
									[aPuttableStream
										basicNextPut: (16rF0 bitOr: (codePoint bitShift: -18));
										basicNextPut: (16r80 bitOr: ((codePoint bitShift: -12) bitAnd: 16r3F));
										basicNextPut: (16r80 bitOr: ((codePoint bitShift: -6) bitAnd: 16r3F));
										basicNextPut: (16r80 bitOr: (codePoint bitAnd: 16r3F))]
								ifFalse: [self class errorInvalidCodePoint: codePoint]]]]!

maxEncoding
	^4!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0."

	^anElement class == Character
		ifTrue: 
			[anElement isAscii
				ifTrue: 
					[self
						nextIdentityIndexOf: anElement
						from: start
						to: stop]
				ifFalse: 
					[| found |
					found := self indexOfSubCollection: (self class with: anElement) startingAt: start.
					found <= stop ifTrue: [found] ifFalse: [0]]]
		ifFalse: 
			["Strings can only contain Characters"
			0]!

reverse
	"Answer a copy of the receiver but with its elements in reverse order."

	| reversed i j size |
	j := size := self size.
	reversed := self species new: size.
	i := 1.
	[i <= size] whileTrue: 
			[| ch |
			ch := self basicAt: i.
			ch < TrailByteMask
				ifTrue: 
					[reversed basicAt: j put: ch.
					i := i + 1.
					j := j - 1]
				ifFalse: 
					["Now expect at least one trailing byte. The lead byte can tell us how many."
					ch < LeadByteMask3
						ifTrue: 
							[ch >= LeadByteMask2
								ifFalse: 
									["Trailing byte with no lead byte"
									^self error: 'Invalid UTF-8 string'].
							"2r110xxxxx  16rC0..16rDF   First byte of a 2-byte character encoding"
							reversed
								basicAt: j put: (self basicAt: i + 1);
								basicAt: j - 1 put: ch.
							i := i + 2.
							j := j - 2]
						ifFalse: 
							[ch < LeadByteMask4
								ifTrue: 
									["2r1110xxxx  16rE0..16rEF   First byte of a 3-byte character encoding"
									reversed
										basicAt: j put: (self basicAt: i + 2);
										basicAt: j - 1 put: (self basicAt: i + 1);
										basicAt: j - 2 put: ch.
									j := j - 3.
									i := i + 3]
								ifFalse: 
									["2r11110xxx  16rF0..16rF4   First byte of a 4-byte character encoding"
									reversed
										basicAt: j put: (self basicAt: i + 3);
										basicAt: j - 1 put: (self basicAt: i + 2);
										basicAt: j - 2 put: (self basicAt: i + 1);
										basicAt: j - 3 put: ch.
									j := j - 4.
									i := i + 4]]]].
	^reversed!

strlen
	"Private - Answer the length of the receiver (in characters) up to the first null terminator. This may
	be less than its size if it contains embedded nulls. It can never be greater than the
	receiver's size."

	^CRTLibrary default strlen: self! !
!Utf8String categoriesFor: #_beginsString:!comparing!double dispatch!private! !
!Utf8String categoriesFor: #asLowercase!converting!public! !
!Utf8String categoriesFor: #asUppercase!converting!public! !
!Utf8String categoriesFor: #asUtf8String!converting!public! !
!Utf8String categoriesFor: #bom!constants!encode/decode!private! !
!Utf8String categoriesFor: #copyToBuffer:ofSize:!copying!private! !
!Utf8String categoriesFor: #decodeNextFrom:!encode/decode!private! !
!Utf8String categoriesFor: #encodedAt:put:!accessing!encode/decode!private! !
!Utf8String categoriesFor: #encodedSizeOf:!encode/decode!private! !
!Utf8String categoriesFor: #encodeOn:put:!encode/decode!private! !
!Utf8String categoriesFor: #maxEncoding!constants!private! !
!Utf8String categoriesFor: #nextIndexOf:from:to:!public!searching! !
!Utf8String categoriesFor: #reverse!copying!public! !
!Utf8String categoriesFor: #strlen!accessing!private! !

!Utf8String class methodsFor!

codePage
	"Answer the Windows code page constants for the receiver's encoding."

	^Win32Constants.CP_UTF8!

elementSize
	"Answer the size of the elements of the receiver in bytes."

	^1!

fromAddress: anAddress
	"Answer a new String instantiated from the null terminated string at anAddress."

	^self fromAddress: anAddress length: (CRTLibrary default strlen: anAddress)!

initialize
	self extraInstanceSpec: EncodingUtf8.
	empty := self new
				isImmutable: true;
				yourself.
	VMLibrary default registryAt: #Utf8String put: self.
	self addClassConstant: 'LeadByteMask2' value: 16rC0.
	self addClassConstant: 'LeadByteMask3' value: 16rE0.
	self addClassConstant: 'LeadByteMask4' value: 16rF0.
	self addClassConstant: 'TrailByteMask' value: 16r80.
	self addClassConstant: 'Bom' value: #[16rEF 16rBB 16rBF]! !
!Utf8String class categoriesFor: #codePage!instance creation!public! !
!Utf8String class categoriesFor: #elementSize!constants!public! !
!Utf8String class categoriesFor: #fromAddress:!instance creation!public! !
!Utf8String class categoriesFor: #initialize!development!initializing!public! !

