"Filed out from Dolphin Smalltalk"!

Core.String
	variableByteSubclass: #'Core.AnsiString'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.AnsiString guid: (Core.GUID fromString: '{5b59aa2a-fc01-4424-95aa-9ffb62e6af03}')!

Core.AnsiString isNullTerminated: true!

Core.AnsiString comment: '`AnsiString` is the class of `Strings`s that use a single-byte encoding based on the current ANSI code page (e.g. Windows 1252). "ANSI" is a bit of a misnomer, but is used because it is common parlance in the Windows API documentation for APIs that expect strings encoded with the "ANSI" code page. 

Note that Ansi code pages that require multiple bytes to represent each character are not supported properly in Dolphin.

In all but limited circumstances `Utf8String`s should be used in preference as these can contain any Unicode character and are independent of code page. Consequently the default string type in Dolphin as of 7.1 is `Utf8String` rather than `AnsiString`.'!

!Core.AnsiString categoriesForClass!Collections-Text! !

!Core.AnsiString methodsFor!

_beginsString: aString
	| size comparand |
	comparand := aString asAnsiString.
	size := self size.
	^size <= comparand size
		and: [(OS.Ucrt
				memcmp: comparand
				buf2: self
				count: size) == 0]!

_endsString: aString
	^self asUtf8String _endsString: aString!

asAnsiString
	"Answer an ANSI encoded string representation of the receiver."

	^self!

codePointsDo: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the full code point <Character> elements of the receiver. Answers the receiver. The elements are evaluated in sequence."

	1 to: self size do: [:i | operation value: (self at: i)]!

decodeAt: anInteger
	"Private - Answer the <Character> with code point beginning at the specified position in the receiver."

	<primitive: 63>
	^self _primitiveError: _failureCode at: anInteger!

decodeNextFrom: aReadStream
	"Private - Read the next <Character> in the receiver's encoding from the <ReadStream> argument ."

	^aReadStream basicNextAvailable ifNotNil: [:ch | Character ansiValue: ch]!

encodedSizeAt: anInteger
	"Private - Answer the <integer> number of code units occupied by the <Character> whose first code unit is at the specified index in the receiver. Always 1 in the case of an ANSI string (multi-byte code pages are not supported)."

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
		replaceBytesOf: (self class new: anInteger)
		from: 1
		to: anInteger
		startingAt: 1!

nextIndexOfCharacter: aCharacter from: startInteger to: stopInteger
	aCharacter encoding ~~ #ansi ifTrue: [^0].
	^self
		basicIdentityIndexOf: aCharacter asInteger
		from: startInteger
		to: stopInteger!

trimNulls
	"Answer a copy of the receiver with trailing nulls removed."
	
	"Take advantage of some private knowledge about the implementation of #fromAddress:"

	^self class fromAddress: self yourAddress!

urlDecoded
	"Asuming that receiver is a URI-encoded representation of a UTF-8 encoded original as
	specified in RFC3986, answer a <Utf8String> which has been unescaped to reveal the original
	text. If it is detected that the content is not URI-encoded (e.g. it contains %-prefixed
	character sequences where the next two characters are not hex digits) then the original
	string is answered."

	| unescaped escaped ch |
	unescaped := Utf8String writeStream: self size.
	escaped := self readStream.
	[(ch := escaped nextAvailable) isNil] whileFalse: 
			[ch == $+
				ifTrue: [unescaped nextPut: $\x20]
				ifFalse: 
					[ch == $%
						ifTrue: 
							[| digit1 digit2 |
							"If not followed by two hex digits, then assume it is not really an escaped string and exit"
							digit1 := escaped nextAvailable ifNil: [-1] ifNotNil: [:ch1 | ch1 asUppercase digitValue].
							(digit1 < 0 or: [digit1 > 15]) ifTrue: [^self].
							digit2 := escaped nextAvailable ifNil: [-1] ifNotNil: [:ch2 | ch2 asUppercase digitValue].
							(digit2 < 0 or: [digit2 > 15]) ifTrue: [^self].
							unescaped basicNextPut: digit1 * 16 + digit2]
						ifFalse: 
							[ch > $\x7F
								ifTrue: 
									["Non-ascii character encountered "
									^self].
							unescaped nextPut: ch]]].
	^unescaped contents! !

!Core.AnsiString categoriesForMethods!
_beginsString:!comparing!double dispatch!private! !
_endsString:!comparing!double dispatch!private! !
asAnsiString!converting!public! !
codePointsDo:!enumerating!public! !
decodeAt:!encode/decode!private! !
decodeNextFrom:!encode/decode!private! !
encodedSizeAt:!encode/decode!private! !
encodeOn:put:!encode/decode!private! !
first:!copying!public! !
nextIndexOfCharacter:from:to:!private!searching! !
trimNulls!copying!public! !
urlDecoded!operations!public! !
!

!Core.AnsiString class methodsFor!

characterForCodeUnit: anInteger
	^Character ansiValue: anInteger!

coerceString: aString
	"Answer an instance of the receiver containing the same characters as the <String> argument, aString.
	Any characters of aString that are not representable on the current ANSI code page are replaced with the ANSI replacement character, $?"

	^aString asAnsiString!

encoding
	"Answer a <Symbol> naming the encoding of instances of the receiver, which will be one of #ansi, #utf8, #utf16 or #utf32."

	^#ansi!

initialize
	empty := self new
				beImmutableObject;
				yourself.
	VM registryAt: #AnsiString put: self.
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

!Core.AnsiString class categoriesForMethods!
characterForCodeUnit:!enquiries!public! !
coerceString:!instance creation!public! !
encoding!constants!public! !
initialize!class initialization!development!public! !
with:!instance creation!public! !
with:with:!instance creation!public! !
with:with:with:!instance creation!public! !
with:with:with:with:!instance creation!public! !
with:with:with:with:with:!instance creation!public! !
!

