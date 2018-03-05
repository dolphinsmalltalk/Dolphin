"Filed out from Dolphin Smalltalk 7"!

UtfEncodedString variableByteSubclass: #Utf8String
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Utf8String guid: (GUID fromString: '{c5ab1b05-241f-4955-8b44-0c80b93bafbb}')!
Utf8String isNullTerminated: true!
Utf8String comment: 'Utf8String is a nascent class to support UTF8 encoded byte character strings.'!
!Utf8String categoriesForClass!Collections-Text! !
!Utf8String methodsFor!

asLowercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to lowercase."

	#todo.	"Provide a more efficient implementation"
	^self asUtf16String asLowercase asUtf8String!

asUppercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to uppercase."

	#todo.	"Provide a more efficient implementation"
	^self asUtf16String asUppercase asUtf8String! !
!Utf8String categoriesFor: #asLowercase!converting!public! !
!Utf8String categoriesFor: #asUppercase!converting!public! !

!Utf8String class methodsFor!

codePage
	^Win32Constants.CP_UTF8!

encode: aCharacter on: aPuttableStream
	| codePoint |
	codePoint := aCharacter codePoint.
	^codePoint < 2r10000000
		ifTrue: [aPuttableStream nextPut: codePoint]
		ifFalse: 
			[codePoint < 16r800
				ifTrue: 
					["2-byte encoding"
					aPuttableStream
						nextPut: (2r11000000 bitOr: (codePoint bitShift: -6));
						nextPut: (2r10000000 bitOr: (codePoint bitAnd: 16r3F))]
				ifFalse: 
					[codePoint < 16rFFFF
						ifTrue: 
							["3-byte encoding"
							aPuttableStream
								nextPut: (2r11100000 bitOr: (codePoint bitShift: -12));
								nextPut: (2r10000000 bitOr: ((codePoint bitShift: -6) bitAnd: 16r3F));
								nextPut: (2r10000000 bitOr: (codePoint bitAnd: 16r3F))]
						ifFalse: 
							["4-byte encoding"
							codePoint < 16r110000
								ifTrue: 
									[aPuttableStream
										nextPut: (2r11110000 bitOr: (codePoint bitShift: -18));
										nextPut: (2r10000000 bitOr: ((codePoint bitShift: -12) bitAnd: 16r3F));
										nextPut: (2r10000000 bitOr: ((codePoint bitShift: -6) bitAnd: 16r3F));
										nextPut: (2r10000000 bitOr: (codePoint bitAnd: 16r3F))]
								ifFalse: [self error: 'Invalid code point ' , codePoint hex]]]]!

fromString: aString
	"Answer an instance of the receiver containing the same characters as the argument, aString."

	^aString asUtf8String!

initialize
	encoding := EncodingUtf8.
	empty := self new
				isImmutable: true;
				yourself.
	VMLibrary default registryAt: #Utf8String put: self! !
!Utf8String class categoriesFor: #codePage!instance creation!public! !
!Utf8String class categoriesFor: #encode:on:!helpers!private! !
!Utf8String class categoriesFor: #fromString:!instance creation!public! !
!Utf8String class categoriesFor: #initialize!development!initializing!public! !

