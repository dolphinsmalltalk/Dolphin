"Filed out from Dolphin Smalltalk"!

Magnitude subclass: #Character
	instanceVariableNames: 'code'
	classVariableNames: 'AnsiCharacters AnsiCodePage AnsiCodePoints CharacterSet EncodingMask EscapeChars Utf16LeadMask Utf16Mask Utf16SurrogateMask Utf16TrailMask Utf32Mask Utf8Default Utf8Mask Utf8SurrogateMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Character guid: (GUID fromString: '{87b4c651-026e-11d3-9fd7-00a0cc3e4a32}')!

Character addClassConstant: 'EncodingMask' value: 16r3F000000!
Character addClassConstant: 'EscapeChars' value: #($0 nil nil nil nil nil nil $a $b $t $n $v $f $r)!
Character addClassConstant: 'Utf16LeadMask' value: 16rD800!
Character addClassConstant: 'Utf16Mask' value: 16r2000000!
Character addClassConstant: 'Utf16SurrogateMask' value: 16rFC00!
Character addClassConstant: 'Utf16TrailMask' value: 16rDC00!
Character addClassConstant: 'Utf32Mask' value: 16r3000000!
Character addClassConstant: 'Utf8Mask' value: 16r1000000!
Character addClassConstant: 'Utf8SurrogateMask' value: 16rC0!

Character comment: '`Character` is the class of objects which serve as the elemental values of Smalltalk `Strings`.

Each `Character` instance generally represents a specific Unicode [code point](https://en.wikipedia.org/wiki/Code_point). Note that this does not necessarily mean that each `Character` corresponds to a single user-perceived, visually distinct, character (aka grapheme cluster). Multiple `Character`s may compose into a single grapheme cluster when displayed, some examples of different types being `👨🏻‍🍳`, `ö`, and `กำ`. The 2nd example has more than one valid representation and can have either one or two code-points.

 `Character` instances may also represent partial or surrogate character code-units that are part of a multi-code-unit code-point. Such surrogate instances may result from indexed access into `UTFEncodedStrings` such as `Utf8String` or `Utf16String`, and can be distinguished through the use of the `isSurrogate`, `isUtf8Surrogate`, `isUtf16Surrogate` family of testing messages. For example:

```
(Character dolphin asUtf8String at: 1) isUtf8Surrogate	"true"
```

A surrogate can be written into a `String` of the same encoding, e.g. a UTF-8 surrogate into a `Utf8String`, but not into a string with a different UTF encoding. Care is also needed to avoid constructing strings with partial characters by writing an incomplete, or misordered, set of surrogate code-unit characters into the string. It is also possible to work with surrogates and streams of the correct underlying encoding, for example:

```
i := 0. Character dolphin asUtf8String do: [:each | i := i + 1. Transcript nextPut: each]. Transcript nextPutAll: '' has ''; print: i; nextPutAll: '' UTF-8 code units''; cr; flush
```

However, in general it is recommended to stream over strings, rather than treating them as arrays of characters, in which case surrogates will not be encountered.

```
i := 0. Character dolphin asUtf8String readStream do: [:each | i := i + 1. Transcript nextPut: each]. Transcript nextPutAll: '' has ''; print: i; nextPutAll: '' codepoint(s)''; cr; flush
```

The instances for the first 256 code points are unique. Smalltalk characters have a literal syntax which is the ''$'' symbol followed by the normal printed representation of the character. 
At present only byte characters (that are not control characters) have a printable literal representation. Dolphin also supports the following escaped literal formats to provide a literal representation of any character:
  `$\0`		- Null
  `$\a`		- Bell
  `$\b`		- Backspace
  `$\t`		- Tab
  `$\n`		- Newline
  `$\v`		- Vertical tab
  `$\f`		- Form Feed
  `$\r`		- Carriage return
  `$\x<HHHH>` - where <HHHH> is the hex representation of the character''s code point - can be used to represent any valid code point.
'!

!Character categoriesForClass!Magnitude-General! !

!Character methodsFor!

_beginsString: aString
	^aString first = self!

_endsString: aString
	| i |
	i := aString size - (aString encodedSizeOf: self) + 1.
	i < 1 ifTrue: [^false].
	^(aString decodeAt: i) = self!

_separateSubStringsIn: tokens
	| start answer size end codeUnits |
	size := tokens size.
	size == 0 ifTrue: [^{}].
	end := tokens
				nextIndexOf: self
				from: 1
				to: size.
	end == 0 ifTrue: [^{tokens}].
	answer := Array writeStream: 5.
	start := 1.
	codeUnits := tokens encodedSizeOf: self.

	[answer nextPut: (tokens copyFrom: start to: end - 1).
	start := end + codeUnits.
	end := tokens
				nextIndexOf: self
				from: start
				to: size.
	end == 0]
			whileFalse.
	"Copy any remaining chars after the last separator"
	start <= size ifTrue: [answer nextPut: (tokens copyFrom: start to: size)].
	^answer contents!

< aCharacter
	"Answer whether the receiver is less than the parameter aCharacter."

	^self codePoint < aCharacter asInteger
!

= comperand
	"Answer whether the receiver is the sames as the parameter, comperand.
	There is a unique Character instance for each possible byte-character value,
	but the instances are not unique for codepoints > 255."

	^self == comperand or: [comperand class == Character and: [comperand code == code]]!

> aCharacter
	"Answer whether the receiver is greater than the parameter aCharacter."

	^self codePoint > aCharacter asInteger
!

ansiValue
	"Answers the ansi character value of the receiver."

	^code <= 16rFF ifTrue: [code] ifFalse: [self error: 'Non-ansi code point']!

asAnsiString
	"Answer a new ANSI-encoded <String> whose sole element is the receiver. It is an error if
	the receiver's code point cannot be represented in ANSI encoding."

	^AnsiString with: self!

asciiValue
	"Answers the ascii character value of the receiver."

	^code < 128 ifTrue: [code] ifFalse: [self error: 'Non-ascii code point']!

asInteger
	"Answer the <integer> character encoding (i.e. the Unicode code point) that the receiver
	represents."

	^self codePoint!

asLowercase
	"Answer a <Character> which is the lowercase equivalent of the receiver."

	"Implementation Note: Apart from the ANSI asLowercase character mappings (basically all the
	uppercase letters are mapped to lowercase letters), this implementation will map other
	characters, depending on the configured locale of the host OS."

	| ucp |
	^(ucp := self codePoint) <= 16rFFFF
		ifTrue: [self class codePoint: (UserLibrary default charLower: ucp)]
		ifFalse: [self]!

asString
	"Answer a new <String> whose sole element is the receiver."

	^Utf8String with: self!

asSymbol
	"Answer the Symbol representation of the receiver."

	^Symbol internCharacter: self!

asUppercase
	"Answer a <Character> which is the uppercase equivalent of the receiver."

	"Implementation Note: Apart from the ASCII asUppercase character mappings (basically all the
	lowercase letters are mapped to uppercase letters), this implementation will map other
	characters, depending on the configured locale of the host OS."

	| ucp |
	^(ucp := self codePoint) <= 16rFFFF
		ifTrue: [self class codePoint: (UserLibrary default charUpper: ucp)]
		ifFalse: [self]!

asUtf16String
	"Answer a new UTF-16 encoded <String> whose sole element is the receiver."

	^Utf16String with: self!

asUtf8String
	"Answer a new <Utf8String> encoding the receiver's code point."

	^Utf8String with: self!

basicEncoding
	"Private - Answer the <integer> encoding of the character, which will be one of the String encoding constants."

	^code bitShift: -24!

basicShallowCopy
	"Answer the receiver as Characters are immutable."

	^self!

code
	^code!

codePoint
	"Answer the <integer> Unicode code point that the receiver represents. If the receiver is a 
	UTF-8 or UTF-16 surrogate (partial character) this may not be a valid Unicode code point."

	"Note that Dolphin will prefer to return an ANSI encoded character from the pre-allocated
	set of 256 ANSI characters, or a UTF-32 encoded character for code points outside the ANSI
	character set. Characters encounted when streaming or enumerating over any type of string
	(including Utf8String and Utf16String) will always be either be either ANSI encoded or
	UTF-32 encoded. UTF-32 encoded characters represent a full code point. However, in the case
	of code that directly performs indexed access into a Utf8String or Utf16String, the VM may
	return UTF-8 or UTF16- surrogates (respectively). These surrogates are really only valid for
	use with further strings of their native encoding, as they do not represent a complete code
	point and cannot be translated to another encoding without their companion surrogates."

	^code <= 16rFF
		ifTrue: [AnsiCodePoints at: code +1]
		ifFalse: 
			["If this is a UTF-8 or UTF-16 surrogate, the code point will be invalid"
			code bitAnd: 16rFFFFFF]!

codeUnit
	"Answer the <integer> character code for the character in its native encoding. This can
	never be greater than 16r10FFFF, which is the maximum Unicode code point."

	^code bitAnd: 16r1FFFFF!

deepCopy
	"Answer the receiver, as Characters are immutable"

	^self!

digitValue
	"Answer the digit representation of the receiver. 'digit' is defined as either 0-9, or
	uppercase A-Z (for 10-35)."

	"Note: In versions of Dolphin prior to 3.0 this raised an error if the character was not a
	valid digit character, but for compatibility with VW it now returns -1. The method is now
	optimized for improved performance too."

	^code > ##($Z codePoint)
		ifTrue: [-1]
		ifFalse: 
			[(#[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 9 10 0 0 0 0 0 0 0 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36]
				at: code + 1) - 1]!

displayOn: aStream
	"Append the end-user display representation of the receiver to aStream."

	aStream nextPut: self!

encoding
	"Answer a <Symbol> naming the encoding of the character, which will be one of #ansi, #utf8, #utf16 or #utf32."

	^String encodingName: self basicEncoding!

greaterOrEqualToInteger: anInteger
	"Private - Answer whether the receiver is greater than or equal to the known <integer> argument."

	^self codePoint >= anInteger!

hash
	"Answer the <SmallInteger> hash value for the receiver."

	^self codePoint!

isAlphaNumeric
	"Answer whether the receiver is a letter or a digit."

	^UserLibrary default isCharAlphaNumeric: self!

isAscii
	"Answer whether the receiver is an ascii character"

	^(code bitAnd: 16r1FFFFF) < 16r80!

isAtomic
	"Answer whether or not the receiver is the single unique instance of its class that
	represents its value."

	"Byte characters are atomic"

	^code <= 255!

isCharacter
	"Answer whether the receiver conforms to the <Character> protocol."

	^true!

isControl
	"Answer whether the receiver is a control character."

	^CRTLibrary default iswcntrl: self!

isDigit
	"Answer whether the receiver is a representation of a decimal-digit character
	(i.e. it is one of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9)."

	^code >= ##($0 codePoint) and: [code <= ##($9 codePoint)]!

isEnglishLetter
	"Answer whether the receiver is a letter from the English alphabet."

	| codePoint |
	^(codePoint := self codePoint) <= ##($z codePoint) and: 
			[codePoint >= ##($A codePoint)
				and: [codePoint >= ##($a codePoint) or: [codePoint <= ##($Z codePoint)]]]!

isGraph
	"Answer whether the receiver is a printable character other than a space."

	#todo. "The CRT functions for character classificiation don't work correctly for characters outside the BMP"
	^CRTLibrary default iswgraph: self!

isHexDigit
	"Answer whether the receiver is a valid Smalltalk hexadecimal digit (i.e. digits and the
	uppercase characters A through F)."

	^self isDigit or: [code >= ##($A codePoint) and: [code <= ##($F codePoint)]]!

isLetter
	"Answer whether the receiver is an alphabetic character."

	^UserLibrary default isCharAlpha: self
!

isLinefeed
	"Answer whether the receiver is the line-feed character."

	^self == $\n!

isLiteral
	"Answer whether the receiver has a literal representation which is directly recognised by
	the Compiler."

	"In Dolphin this is always true because we have an escaped code point literal form."

	^true!

isLowercase
	"Answer whether the receiver is a lowercase letter."

	^UserLibrary default isCharLower: self!

isLowerCase
	"Answer whether the receiver is a lowercase letter."

	^self isLowercase!

isPrintable
	"Answer whether the receiver is a printable character."

	#todo. "The CRT functions for character classificiation don't work correctly for characters outside the BMP"
	^CRTLibrary default iswprint: self!

isPunctuation
	"Answer whether the receiver is a punctuation character."

	#todo. "The CRT functions for character classificiation don't work correctly for characters outside the BMP"
	^CRTLibrary default iswpunct: self!

isSeparator
	"Answer whether the receiver is an ASCII separator character (i.e. whitespace)."

	^code == 32 or: [code >= 9 and: [code <= 13]]!

isSurrogate
	"Answer whether the receiver is a leading or trailing code unit of a multi-code unit code-point in it's encoding."

	^self isUtf16Surrogate or: [self isUtf8Surrogate]!

isUppercase
	"Answer whether the receiver is an uppercase letter."

	^UserLibrary default isCharUpper: self!

isUpperCase
	"Answer whether the receiver is an uppercase letter."

	^self isUppercase
!

isUtf16Lead
	"Answer whether the receiver is a UTF-16 lead surrogate (leading code unit of two part character)."

	^(code bitAnd: ##(EncodingMask | Utf16SurrogateMask)) == ##(Utf16Mask | Utf16LeadMask)!

isUtf16Surrogate
	"Answer whether the receiver is a UTF-16 surrogate (partial character)."

	^(code bitAnd: ##(EncodingMask | 16rF800)) == ##(Utf16Mask | Utf16LeadMask)!

isUtf16Trail
	"Answer whether the receiver is a UTF-16 trail surrogate (trailing code-unit of two-part code point)."

	^(code bitAnd: ##(EncodingMask | Utf16SurrogateMask)) == ##(Utf16Mask | Utf16TrailMask)!

isUtf8
	"Answer whether the receiver is a valid UTF-8 code unit. This is true for any ASCII character, or any UTF-8 surrogate."

	^code < 16r80 or: [(code bitAnd: EncodingMask) == Utf8Mask]!

isUtf8Lead
	"Answer whether the receiver represents a UTF-8 leading byte."

	^(code bitAnd: ##(EncodingMask | Utf8SurrogateMask)) == ##(Utf8Mask | 16rC0)!

isUtf8Surrogate
	"Answer whether the receiver represents a UTF-8 surrogate (partial character)."

	^(code bitAnd: ##(EncodingMask | 16r80)) == ##(Utf8Mask | 16r80)!

isUtf8Trail
	"Answer whether the receiver represents a UTF-8 trailing byte."

	^(code bitAnd: ##(EncodingMask | Utf8SurrogateMask)) == ##(Utf8Mask | 16r80)!

isVowel
	"Answer whether the receiver is an English vowel (a, e, i, o, or u).
	This test is case insensitive."

	^'aAeEiIoOuU' identityIncludes: self!

isWhitespace
	"Answer whether the receiver is a white space character.
	This is a synonym for #isSeparator as currently defined."

	^self isSeparator!

join: aCollection
	"Answer a new <String> composed from the elements of the <collection> argument separated by the instances of the receiver."

	| stream |
	stream := String writeStream: aCollection size * 6.
	aCollection do: [:each | each displayOn: stream] separatedBy: [stream nextPut: self].
	^stream contents!

printEscapedOn: aStream
	"Append the escaped literal representation of the receiver to the <puttableStream> argument."

	| codePoint |
	aStream nextPutAll: '$\'.
	(EscapeChars lookup: (codePoint := self codePoint) + 1)
		ifNil: 
			[aStream nextPut: $x.
			codePoint
				printOn: aStream
				base: 16
				showRadix: false]
		ifNotNil: [:char | aStream nextPut: char]!

printOn: aStream
	"Append the literal representation of the receiver to the <puttableStream> argument."

	(code > 32 and: [code < 127 or: [code <= 255 and: [self isGraph]]])
		ifTrue: 
			[aStream
				nextPut: $$;
				nextPut: self]
		ifFalse: [self printEscapedOn: aStream]!

setCode: anInteger
	code := anInteger!

shallowCopy
	"Answer the receiver, as Characters are immutable."

	^self!

split: aReadableString
	"Answer the sub-strings of the <readableString> argument separated by the receiver."

	"Implementation Note: Although this routine is rather more complex than it need be, the performance of #subStrings(:) is important, so it pays to optimize this routine. In particular we try to avoid performing any work in the common cases where the string is either empty, or does not contain the separator at all. However, we must be careful not to over optimize and prevent correct operation for wide (Unicode) strings."

	| start answer size end codeUnits |
	size := aReadableString size.
	size == 0 ifTrue: [^{}].
	end := aReadableString
				nextIndexOf: self
				from: 1
				to: size.
	end == 0 ifTrue: [^{aReadableString}].
	answer := Array writeStream: 5.
	start := 1.
	codeUnits := aReadableString encodedSizeOf: self.
	
	[answer nextPut: (aReadableString copyFrom: start to: end - 1).
	start := end + codeUnits.
	end := aReadableString
				nextIndexOf: self
				from: start
				to: size.
	end == 0]
			whileFalse.
	"Copy any remaining chars after the last separator"
	answer nextPut: (aReadableString copyFrom: start to: size).
	^answer contents!

split: aReadableString do: aMonadicValuable
	"Evaluate the <monadicValuable> 2nd argument for each of the sub-strings of the <readableString> 1st argument that are separated by the receiver."

	| start size end codeUnits |
	size := aReadableString size.
	end := aReadableString
				nextIndexOf: self
				from: 1
				to: size.
	end == 0
		ifTrue: 
			[aMonadicValuable value: aReadableString.
			^self].
	start := 1.
	codeUnits := aReadableString encodedSizeOf: self.
	
	[aMonadicValuable value: (aReadableString copyFrom: start to: end - 1).
	start := end + codeUnits.
	end := aReadableString
				nextIndexOf: self
				from: start
				to: size.
	end == 0]
			whileFalse.
	"Evaluate for any remaining chars after the last separator"
	aMonadicValuable value: (aReadableString copyFrom: start to: size)!

to: aCharacter
	"Answer a <sequencedReadableCollection> of <Character>s for each of the Unicode code points between the receiver's code point and that of the <Character> argument, aCharacter."

	^(self codePoint to: aCharacter codePoint) collect: [:each | Character codePoint: each]! !

!Character categoriesForMethods!
_beginsString:!comparing!double dispatch!private! !
_endsString:!comparing!double dispatch!private! !
_separateSubStringsIn:!private!tokenizing! !
<!comparing!public! !
=!comparing!public! !
>!comparing!public! !
ansiValue!accessing!public! !
asAnsiString!converting!public! !
asciiValue!accessing!public! !
asInteger!converting!public! !
asLowercase!converting!public! !
asString!converting!public! !
asSymbol!converting!public! !
asUppercase!converting!public! !
asUtf16String!converting!public! !
asUtf8String!converting!public! !
basicEncoding!accessing!private! !
basicShallowCopy!copying!public! !
code!accessing!private! !
codePoint!accessing!public! !
codeUnit!accessing!public! !
deepCopy!copying!public! !
digitValue!accessing!public! !
displayOn:!printing!public! !
encoding!accessing!public! !
greaterOrEqualToInteger:!double dispatch!private! !
hash!comparing!public! !
isAlphaNumeric!public!testing! !
isAscii!public!testing! !
isAtomic!public!testing! !
isCharacter!public!testing! !
isControl!public!testing! !
isDigit!public!testing! !
isEnglishLetter!public!testing! !
isGraph!public!testing! !
isHexDigit!public!testing! !
isLetter!public!testing! !
isLinefeed!public!testing! !
isLiteral!public!testing! !
isLowercase!public!testing! !
isLowerCase!public!testing! !
isPrintable!public!testing! !
isPunctuation!public!testing! !
isSeparator!public!testing! !
isSurrogate!public!testing! !
isUppercase!public!testing! !
isUpperCase!public!testing! !
isUtf16Lead!public!testing! !
isUtf16Surrogate!public!testing! !
isUtf16Trail!public!testing! !
isUtf8!public!testing! !
isUtf8Lead!public!testing! !
isUtf8Surrogate!public!testing! !
isUtf8Trail!public!testing! !
isVowel!public!testing! !
isWhitespace!public!testing! !
join:!public!tokenizing! !
printEscapedOn:!printing!public! !
printOn:!printing!public! !
setCode:!accessing!initializing!private! !
shallowCopy!copying!public! !
split:!public!tokenizing! !
split:do:!public!tokenizing! !
to:!converting!public! !
!

Character methodProtocol: #Character attributes: #(#ansi #readOnly) selectors: #(#asLowercase #asString #asUppercase #codePoint #isAlphaNumeric #isDigit #isLetter #isLowercase #isUppercase)!

!Character class methodsFor!

ansiValue: anInteger
	^(CharacterSet lookup: anInteger + 1)
		ifNil: [self error: 'Invalid ANSI code unit: ' , anInteger printString]!

asciiValue: anInteger
	^(anInteger >= 0 and: [anInteger <= 127])
		ifTrue: [CharacterSet at: anInteger + 1]
		ifFalse: [self error: 'Invalid ASCII code point: ' , anInteger printString]!

backspace
	"Answer the backspace control <Character>."

	^$\b
!

byteCharacterSet
	"Answer the ANSI character set, i.e. the complete set of Characters that can be encoded in an <AnsiString>."

	^CharacterSet!

codePoint: anInteger
	"Answer a <Character> representing the specified <integer> Unicode code point.
	Raise an error if the argument is not a valid Unicode code point."

	^self codePoint: anInteger
		ifInvalid: 
			["This block is deliberately clean to avoid block copy overhead"
			InvalidArgumentError signal: 'Unicode character code point expected' with: 'anInteger']!

codePoint: anInteger ifInvalid: exceptionHandler
	"Answer a <Character> representing the specified <integer> Unicode code point, or the result of evaluating the <niladicValuable>, exceptionHandler, if the code point is not the code point of a valid Unicode character."

	^anInteger < 16r80
		ifTrue: [CharacterSet at: anInteger + 1]
		ifFalse: 
			[(AnsiCharacters lookup: anInteger)
				ifNil: 
					[(self isValidCodePoint: anInteger)
						ifTrue: [(self newCode: (Utf32Mask bitOr: anInteger)) isImmutable: true]
						ifFalse: [exceptionHandler value]]]!

cr
	"Answer the carriage return control <Character>."

	^$\r!

digitValue: anInteger
	"Answer the <Character> that represents the specified digit. 0-9 map to $0-$9, 10-35 map to
	$A-$Z. If anInteger is not in the range 0..35, then the String #at: will fail with a bounds
	error."

	^'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: anInteger+1!

dolphin
	"Answer a <Character> representing the Dolphin symbol, i.e. Unicode code point U+1F42C."

	"Like most symbolic code points, this is outside the basic multi-lingual plane, and so requires
	multi-part UTF encodings (4x 8-bit code units in UTF-8 and 2x 16-bit code units in UTF-16),
	making it useful for testing."

	^$\x1F42C!

eof
	"Answer the EOF (Ctrl+Z) control <Character>.
	DOS interprets this character as marking the end of a file."

	^$\x1A!

esc
	"Answer the escape control <Character>."

	^$\x1B!

euro
	"Answer a <Character> representing the Euro currency symbol, €"

	^$\x20AC!

initialize
	self addClassConstant: 'CharacterSet'
		value: ((AnsiString fromByteArray: (0 to: 255) asByteArray)
				isImmutable: true;
				yourself).
	self addClassConstant: 'EscapeChars'
		value: ((Array new: 14)
				at: 0 + 1 put: $0;
				at: 7 + 1 put: $a;
				at: 8 + 1 put: $b;
				at: 9 + 1 put: $t;
				at: 10 + 1 put: $n;
				at: 11 + 1 put: $v;
				at: 12 + 1 put: $f;
				at: 13 + 1 put: $r;
				yourself).
	self addClassConstant: 'Utf8Mask' value: String.EncodingUtf8 << 24.
	self addClassConstant: 'Utf16Mask' value: String.EncodingUtf16 << 24.
	self addClassConstant: 'Utf32Mask' value: String.EncodingUtf32 << 24.
	self addClassConstant: 'EncodingMask' value: 2r111111 << 24.
	self addClassConstant: 'Utf8SurrogateMask' value: 16rC0.
	self addClassConstant: 'Utf16SurrogateMask' value: 16rFC00!

isValidCodePoint: anInteger
	"Answer whether the <integer> argument represents a valid Unicode code point AND is not a code point reserved for surrogate code units AND is not a 'non-character' (i.e. non-characters are valid code points, but 'reserved for internal use')."

	^anInteger >= 0 and: 
			[anInteger < Character.Utf16LeadMask or: 
					[anInteger > 16rDFFF and: 
							[anInteger <= Win32Constants.MAX_UCSCHAR and: 
									[(anInteger >= 16rFDD0 and: [anInteger <= 16rFDEF or: [(anInteger bitAnd: 16rFFFE) == 16rFFFE]]) not]]]]!

isValidUtf16CodeUnit: anInteger
	"Answer whether the <integer> argument is a valid as a code unit in the UTF-16 encoding."

	^anInteger >= 0 and: 
			[anInteger < Character.Utf16LeadMask or: 
					[(anInteger bitAnd: 16rF800) == Character.Utf16LeadMask or: 
							[anInteger < 16rFDD0 or: 
									[anInteger > 16rFDEF
										and: [anInteger <= Win32Constants.MAX_UCSCHAR and: [(anInteger allMask: 16rFFFE) not]]]]]]!

lf
	"Answer the linefeed control <Character>."

	^$\n!

new
	"Characters should not be instantiated directly; they can be created by literal references,
	by extraction from Strings, or from an <integer> code point."

	^self shouldNotImplement!

newCode: anInteger
	"Private - Answer a new instance of the receiver with the specified code. This should only be used for code points > 128."

	<primitive: 157>
	^self basicNew setCode: anInteger!

newPage
	"Answer the new page control <Character>."

	^$\f!

nl
	"Answer the new line control <Character> (synonym for lf)"

	^$\n!

null
	"Answer the NULL control character"

	^$\0!

onStartup
	| utf ansiCharacters |
	AnsiCodePage := (VMLibrary default getProcAddress: 'AnsiCodePage' ifAbsent: [#[0 0 0 0]])
				dwordAtOffset: 0.
	utf := self byteCharacterSet asUtf16String.
	AnsiCodePoints := ((0 to: utf size * 2 - 1 by: 2) collect: [:each | utf wordAtOffset: each])
				isImmutable: true;
				yourself.
	#todo. "Integers from 0 to 255 with a few gaps substituted by large values do not make for good hash distribution, so make the table larger than normal until #766 is fixed."
	ansiCharacters := IdentityDictionary new: 513.
	Character byteCharacterSet do: [:each | ansiCharacters at: each codePoint put: each].
	ansiCharacters isImmutable: true.
	AnsiCharacters := ansiCharacters.
	"In practice the replacement character is always $\xFFFD, but we fetch it from the VM (which in turn has retrieved it from Windows) just in case"
	Utf8Default := Character
				codePoint: ((VMLibrary default getProcAddress: 'UnicodeDefaultChar' ifAbsent: [#[16rFD 16rFF]])
						wordAtOffset: 0)!

replacement
	"Answer the Unicode replacement <Character>, used to substitute for invalid code points and encodings."

	^Utf8Default!

space
	"Answer the space <Character>."

	^$\x20!

tab
	"Answer the tab control <Character>."

	^$\t!

utf16Value: anInteger
	"Answer a <Character> (which may be a surrogate) representing the <integer> UTF-16 code unit, anInteger.
	If the argument is not a valid UTF-16 code unit then an error is raised."

	^self utf16Value: anInteger
		ifInvalid: [InvalidArgumentError signal: 'UTF-16 code unit expected' with: 'anInteger']!

utf16Value: anInteger ifInvalid: exceptionHandler
	"Answer a <Character> (which may be a surrogate) representing the <integer> UTF-16 code unit, anInteger, or the result of evaluating the <monadicBlock>, exceptionHandler, if the code unit is not valid."

	^anInteger < 16r80
		ifTrue: 
			[anInteger < 0
				ifTrue: [exceptionHandler value]
				ifFalse: 
					["Ascii"
					CharacterSet at: anInteger + 1]]
		ifFalse: 
			[(AnsiCharacters lookup: anInteger)
				ifNil: 
					[(anInteger bitAnd: 16rF800) == Character.Utf16LeadMask
						ifTrue: 
							["Surrogate"
							self newCode: (Utf16Mask bitOr: anInteger)]
						ifFalse: 
							[(anInteger <= Win32Constants.MAX_UCSCHAR
								and: [anInteger < 16rFDD0 or: [anInteger > 16rFDEF and: [(anInteger allMask: 16rFFFE) not]]])
									ifTrue: 
										["Valid non-ascii/non-ansi code point"
										self newCode: (Utf32Mask bitOr: anInteger)]
									ifFalse: [exceptionHandler value]]]]!

utf8Value: anInteger
	"Answer a <Character> representing the <integer> UTF-8 code unit, anInteger.
	Note that the resulting Character may not represent a valid Unicode code point."

	^anInteger < 16r80
		ifTrue: 
			["Ascii"
			CharacterSet at: anInteger + 1]
		ifFalse: 
			[anInteger <= 16rFF
				ifTrue: 
					["Some kind of surrogate"
					self newCode: (Utf8Mask bitOr: anInteger)]
				ifFalse: [self error: 'Invalid UTF-8 code unit: ' , anInteger printString]]!

value: anInteger
	"Answer a <Character> representing the specified <integer> Unicode code point.
	Raise an error if the argument is not a valid Unicode character code point."

	^self codePoint: anInteger! !

!Character class categoriesForMethods!
ansiValue:!instance creation!public! !
asciiValue:!instance creation!public! !
backspace!constants!public! !
byteCharacterSet!constants!public! !
codePoint:!instance creation!public! !
codePoint:ifInvalid:!instance creation!public! !
cr!constants!public! !
digitValue:!instance creation!public! !
dolphin!constants!public! !
eof!constants!public! !
esc!constants!public! !
euro!constants!public! !
initialize!development!initializing!public! !
isValidCodePoint:!enquiries!public! !
isValidUtf16CodeUnit:!enquiries!public! !
lf!constants!public! !
new!instance creation!public! !
newCode:!instance creation!private! !
newPage!constants!public! !
nl!constants!public! !
null!constants!public! !
onStartup!event handling!public! !
replacement!constants!public! !
space!constants!public! !
tab!constants!public! !
utf16Value:!instance creation!public! !
utf16Value:ifInvalid:!instance creation!public! !
utf8Value:!instance creation!public! !
value:!instance creation!public! !
!

Character class methodProtocol: #'Character factory' attributes: #(#ansi #readOnly) selectors: #(#codePoint: #cr #lf #space #tab)!

