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

, aSequencedReadableCollection
	"Answer a new <sequencedReadableCollection> like the receiver (i.e. of the receiver's
	species but not necessarily the exact same class) containing the elements	of the receiver 
	in their original order with those of the <sequencedReadableCollection> argument
	appended in their original order.
	Note: This is the concatenation operation, and is a simplified form of 
	#copyReplaceFrom:to:with:."

	| size newSize other|
	size := self size.
	other := aSequencedReadableCollection asUtf8String.
	newSize := size + other size.
	^(self copyLikeOfSize: newSize)
		replaceFrom: 1
			to: size
			with: self
			startingAt: 1;
		replaceFrom: size + 1
			to: newSize
			with: other
			startingAt: 1;
		yourself!

_appendToString: aString
	^aString asUtf8String , self!

_equalsByteString: aString
	"Private - Answer whether the receiver is equivalent to the byte <String>, aString. 
	Double-dispatched from String>>=."

	"We should only get here the comparand is an ANSI string"
	^aString asUtf8String = self!

asAnsiString
	"Answer an ANSI encoded string representation of the receiver. Any of the receiver's code
	points that cannot be represented as ANSI characters will be translated to an error
	character."

	<primitive: 217>
	^self asUtf16String asAnsiString!

asLowercase
	#todo.	"Provide a more efficient implementation"
	^self asUtf16String asLowercase asUtf8String!

asString
	"Answer a <readableString> containing the same characters as the receiver,
	i.e. the receiver."

	"For historical reasons, this is always an ANSI-encoded byte string."

	| utf16 bytes buf size kernel |
	#todo.	"Provide a more efficient implementation that does not have to convert to utf16 first"
	(size := self size) == 0 ifTrue: [^String empty].	"Avoid 'The Parameter is Incorrect' error"
	utf16 := self class utf16Class new: size.
	((kernel := KernelLibrary default)
		multiByteToWideChar: self codePage
		dwFlags: 0
		lpMultiByteStr: self
		cchMultiByte: -1
		lpWideCharStr: utf16
		cchWideChar: size + 1) == 0
		ifTrue: [kernel systemError].
	buf := self class ansiClass new: size * 4.
	(bytes := kernel
				wideCharToMultiByte: buf codePage
				dwFlags: 0
				lpWideCharStr: utf16
				cchWideChar: -1
				lpMultiByteStr: buf
				cchMultiByte: buf size + 1
				lpDefaultChar: nil
				lpUsedDefaultChar: nil) == 0
		ifTrue: [^kernel systemError].
	buf resize: bytes - 1.
	^buf!

asUppercase
	#todo.	"Provide a more efficient implementation"
	^self asUtf16String asUppercase asUtf8String!

asUtf8String
	"Answer a UTF8 encoded string representation of the receiver."

	^self! !
!Utf8String categoriesFor: #,!copying!public! !
!Utf8String categoriesFor: #_appendToString:!comparing!double dispatch!private! !
!Utf8String categoriesFor: #_equalsByteString:!comparing!private! !
!Utf8String categoriesFor: #asAnsiString!converting!public! !
!Utf8String categoriesFor: #asLowercase!converting!public! !
!Utf8String categoriesFor: #asString!converting!public! !
!Utf8String categoriesFor: #asUppercase!converting!public! !
!Utf8String categoriesFor: #asUtf8String!converting!public! !

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
	empty := self new
				isImmutable: true;
				yourself.
	VMLibrary default registryAt: #Utf8String put: self! !
!Utf8String class categoriesFor: #codePage!instance creation!public! !
!Utf8String class categoriesFor: #encode:on:!helpers!private! !
!Utf8String class categoriesFor: #fromString:!instance creation!public! !
!Utf8String class categoriesFor: #initialize!development!initializing!public! !

