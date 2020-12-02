"Filed out from Dolphin Smalltalk 7"!

String variableByteSubclass: #AnsiString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AnsiString guid: (GUID fromString: '{5b59aa2a-fc01-4424-95aa-9ffb62e6af03}')!
AnsiString isNullTerminated: true!
AnsiString comment: '`AnsiString` is the class of `Strings`s that use a single-byte encoding based on the current ANSI code page (e.g. Windows 1252). "ANSI" is a bit of a misnomer, but is used because it is common parlance in the Windows API documentation for APIs that expect strings encoded with the "ANSI" code page. 

Note that Ansi code pages that require multiple bytes to represent each character are not supported properly in Dolphin.

In all but limited circumstances `Utf8String`s should be used in preference as these can contain any Unicode character and are independent of code page. Consequently the default string type in Dolphin as of 7.1 is `Utf8String` rather than `AnsiString`.'!
!AnsiString categoriesForClass!Collections-Text! !
!AnsiString methodsFor!

_beginsString: aString
	| size comperand |
	comperand := aString asAnsiString.
	size := self size.
	^size <= comperand size
		and: [(CRTLibrary default
				memcmp: comperand
				buf2: self
				count: size) == 0]!

asAnsiString
	"Answer an ANSI encoded string representation of the receiver."

	^self!

asLowercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to lowercase."

	"Implementation Note: The Win32 function converts in place, so we must first create a copy."

	| copy |
	copy := self shallowCopy.
	UserLibrary default charLowerBuffA: copy cchLength: copy size.
	^copy!

asUppercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to uppercase."

	"Implementation Note: The Win32 function converts in place, so we need to create a copy
	first."

	| copy |
	copy := self shallowCopy.
	UserLibrary default charUpperBuffA: copy cchLength: copy size.
	^copy!

codePointsDo: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the full code point <Character> elements of the receiver. Answers the receiver. The elements are evaluated in sequence."

	1 to: self size do: [:i | operation value: (self at: i)]!

copyToBuffer: anAddress ofSize: anInteger
	CRTLibrary default
		strncpy_s: anAddress
		bufferSize: anInteger
		strSource: self
		count: CRTConstants._TRUNCATE!

decodeAt: anInteger
	"Private - Answer the <Character> with code point beginning at the specified position in the receiver."

	<primitive: 63>
	^self _primitiveError: _failureCode at: anInteger!

decodeNextFrom: aReadStream
	"Private - Read the next <Character> in the receiver's encoding from the <ReadStream> argument ."

	^aReadStream basicNextAvailable ifNotNil: [:ch | Character ansiValue: ch]!

encodedSizeAt: anInteger
	"Private - Answer the <integer> number of code units occuppied by the <Character> whose first code unit is at the specified index in the receiver. Always 1 in the case of an ANSI string (multi-byte code pages are not supported)."

	^1!

encodeOn: aWriteStream put: aCharacter
	"Private - Encode the <Character> argument onto the <WriteStream> argument as a single byte ANSI code unit.
	 An error is raised if the <Character> has code point that is not representable in the ANSI encoding."

	^aWriteStream basicNextPut: aCharacter ansiValue!

first: anInteger
	"Answer a new string comprising the leftmost anInteger code units (ascii characters) of the receiver. "

	"Implementation Note: Rather than implement in terms of the generic #copyFrom:to: method, we
	can take advantage of the fact that this selector is specific to Strings, and implement more
	efficiently."

	^self
		replaceBytesOf: (self species new: anInteger)
		from: 1
		to: anInteger
		startingAt: 1!

nextIndexOfCharacter: aCharacter from: startInteger to: stopInteger
	aCharacter encoding ~~ #ansi ifTrue: [^0].
	^self
		basicIdentityIndexOf: aCharacter asInteger
		from: startInteger
		to: stopInteger!

reverse
	"Answer a copy of the receiver but with its elements in reverse order.
	Our Strings are null-terminated, so we can use the CRTLibrary (_strrev()
	works in place, so we must get a copy)."

	| copy |
	copy := self copy.
	CRTLibrary default _strrev: copy.
	^copy!

skipEncodingMarkerFrom: aGettableStream
	"Private - Skip over any encoding marker used for the stream encoding this collection represents on the <gettableStream> argument, which 
	is assumed to be at the start of its sequence."

	"Nothing to do for ANSI strings"

	!

strlen
	"Answer the length of the receiver (in code units) up to the first null terminator. This may be less than its size if it contains embedded nulls. It can never be greater than the receiver's size."

	^CRTLibrary default strlen: self!

trimNulls
	"Answer a copy of the receiver with trailing nulls removed.
	Take advantage of some private knowledge about the implementation of
	#fromAddress:"

	^self species fromAddress: self yourAddress!

urlDecoded
	"Asuming that receiver is a URI-encoded representation of a UTF-8 encoded original as
	specified in RFC3986, answer a <Utf8String> which has been unescaped to reveal the original
	text. If it is detected that the content is not URI-encoded (e.g. it contains %-prefixed
	character sequences where the next two characters are not hex digits) then the original
	string is answered."

	| unescaped escaped ch |
	unescaped := Utf8String writeStream: self size.
	escaped := self readStream.
	[(ch := escaped basicNextAvailable) isNil] whileFalse: 
			[ch == ##($+ asciiValue)
				ifTrue: [unescaped nextPut: $\x20]
				ifFalse: 
					[ch == ##($% asciiValue)
						ifTrue: 
							[| digit1 digit2 |
							"If not followed by two hex digits, then assume it is not really an escaped string and exit"
							digit1 := escaped nextAvailable ifNil: [-1] ifNotNil: [:ch1 | ch1 asUppercase digitValue].
							digit1 < 0 | (digit1 > 15) ifTrue: [^self].
							digit2 := escaped nextAvailable ifNil: [-1] ifNotNil: [:ch2 | ch2 asUppercase digitValue].
							digit2 < 0 | (digit2 > 15) ifTrue: [^self].
							unescaped basicNextPut: digit1 * 16 + digit2]
						ifFalse: 
							[ch > 16r7F
								ifTrue: 
									["Non-ascii character encountered "
									^self].
							unescaped basicNextPut: ch]]].
	^unescaped contents! !
!AnsiString categoriesFor: #_beginsString:!comparing!double dispatch!private! !
!AnsiString categoriesFor: #asAnsiString!converting!public! !
!AnsiString categoriesFor: #asLowercase!converting!public! !
!AnsiString categoriesFor: #asUppercase!converting!public! !
!AnsiString categoriesFor: #codePointsDo:!enumerating!public! !
!AnsiString categoriesFor: #copyToBuffer:ofSize:!copying!private! !
!AnsiString categoriesFor: #decodeAt:!encode/decode!private! !
!AnsiString categoriesFor: #decodeNextFrom:!encode/decode!private! !
!AnsiString categoriesFor: #encodedSizeAt:!encode/decode!private! !
!AnsiString categoriesFor: #encodeOn:put:!encode/decode!private! !
!AnsiString categoriesFor: #first:!copying!public! !
!AnsiString categoriesFor: #nextIndexOfCharacter:from:to:!private!searching! !
!AnsiString categoriesFor: #reverse!copying!public! !
!AnsiString categoriesFor: #skipEncodingMarkerFrom:!encode/decode!private! !
!AnsiString categoriesFor: #strlen!accessing!private! !
!AnsiString categoriesFor: #trimNulls!copying!public! !
!AnsiString categoriesFor: #urlDecoded!operations!public! !

!AnsiString class methodsFor!

characterForCodeUnit: anInteger
	^Character ansiValue: anInteger!

coerceString: aString
	"Answer an instance of the receiver containing the same characters as the <String> argument, aString.
	Any characters of aString that are not representable on the current ANSI code page are replaced with the ANSI replacement character, $?"

	^aString asAnsiString!

fromAddress: anAddress
	"Answer a new String instantiated from the null terminated string at anAddress.
	Implementation note: We can use the external library call primitive to do the 
	job for us by performing a simple nop which returns the original pointer (_strninc()
	has the useful property that it returns NULL for NULL argument too)."

	^VMLibrary default stringFromAddress: anAddress!

initialize
	empty := self new
				isImmutable: true;
				yourself.
	VMLibrary default registryAt: #AnsiString put: self.
	self extraInstanceSpec: EncodingAnsi!

with: aCharacter
	^(self new: 1)
		at: 1 put: aCharacter;
		yourself!

with: firstCharacter with: secondCharacter
	^(self new: 2)
		at: 1 put: firstCharacter;
		at: 2 put: secondCharacter;
		yourself!

with: firstCharacter with: secondCharacter with: thirdCharacter
	^(self new: 3)
		at: 1 put: firstCharacter;
		at: 2 put: secondCharacter;
		at: 3 put: thirdCharacter;
		yourself!

with: firstCharacter with: secondCharacter with: thirdCharacter with: fourthCharacter
	^(self new: 4)
		at: 1 put: firstCharacter;
		at: 2 put: secondCharacter;
		at: 3 put: thirdCharacter;
		at: 4 put: fourthCharacter;
		yourself!

with: firstCharacter with: secondCharacter with: thirdCharacter with: fourthCharacter with: fifthCharacter
	^(self new: 5)
		at: 1 put: firstCharacter;
		at: 2 put: secondCharacter;
		at: 3 put: thirdCharacter;
		at: 4 put: fourthCharacter;
		at: 5 put: fifthCharacter;
		yourself! !
!AnsiString class categoriesFor: #characterForCodeUnit:!enquiries!public! !
!AnsiString class categoriesFor: #coerceString:!instance creation!public! !
!AnsiString class categoriesFor: #fromAddress:!instance creation!public! !
!AnsiString class categoriesFor: #initialize!class initialization!development!public! !
!AnsiString class categoriesFor: #with:!instance creation!public! !
!AnsiString class categoriesFor: #with:with:!instance creation!public! !
!AnsiString class categoriesFor: #with:with:with:!instance creation!public! !
!AnsiString class categoriesFor: #with:with:with:with:!instance creation!public! !
!AnsiString class categoriesFor: #with:with:with:with:with:!instance creation!public! !

