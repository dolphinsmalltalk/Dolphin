"Filed out from Dolphin Smalltalk"!

Core.UtfEncodedString
	variableByteSubclass: #'Core.Utf8String'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'Bom' -> #[239 187 191].
			'LeadByteMask2' -> 16rC0.
			'LeadByteMask3' -> 16rE0.
			'LeadByteMask4' -> 16rF0.
			'SurrogateMask' -> 16rC0.
			'TrailByteMask' -> 16r80
		}!
Core.Utf8String guid: (Core.GUID fromString: '{c5ab1b05-241f-4955-8b44-0c80b93bafbb}')!
Core.Utf8String isNullTerminated: true!
Core.Utf8String comment: '`Utf8String` is the class of `Strings`s that use a the multi-byte UTF-8 encoding. UTF-8 is the defacto standard for text interchange, and is now the default representation in Dolphin (i.e. `String new` yields a new, empty, `Utf8String`).

When considering a `Utf8String` as a `SequenceableCollection`, its elements are `Character`s. However the `Character` elements represent UTF-8 code units, not Unicode code points. These code-unit characters can be "surrogate" characters representing part of the encoding of a full code-point. UTF-8 surrogate characters can be inserted into other Utf8Strings (although this must be done with care to avoid creating invalid encodings), but not mixed with characters from other encodings such as those from `Utf16String`s. To enumerate a `Utf8String` as `Character`s representing Unicode code points, a `ReadStream` should be attached to the string and the characters read from that. For example:
```
	''Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ'' readStream do: [:each | Transcript nextPut: each asUppercase]. Transcript cr; flush.
```
It should also be noted that the `size` of a `Utf8String` is a count of the number of code units (bytes), and not the number of whole Unicode characters. A single Unicode code point can require up to four UTF-8 code units, for example:
```
''🐬'' size "=> 4"
```
To better understand the full implications of the compromises made in introducing a variable width encoding into the `SequenceableCollection` hierarchy it is recommended to read the cautionary notes in the abstract superclass `UtfEncodedString`.'!
!Core.Utf8String categoriesForClass!Collections-Text! !
!Core.Utf8String methodsFor!

_beginsString: aString
	| size comparand |
	comparand := aString asUtf8String.
	size := self size.
	^size <= comparand size
		and: [(OS.Ucrt
				memcmp: comparand
				buf2: self
				count: size) == 0]!

asUtf8String
	"Answer a UTF-8 encoded string representation of the receiver."

	^self!

asUtf8StringCopy
	"Answer a UTF8-encoded copy of the receiver."

	<primitive: 155>
	^self shallowCopy!

before: aCharacter ifAbsent: aNiladicValuable
	"Answer the <Character> representing the code point before the <Character> argument, or if not present the result of evaluating the <niladicValuable> argument."

	| index |
	index := self indexOf: aCharacter.
	index == 0 ifTrue: [^aNiladicValuable value].
	index == 1 ifTrue: [^self errorFirstObject: aCharacter].
	
	[index := index - 1.
	((self basicAt: index) bitAnd: SurrogateMask) == TrailByteMask] whileTrue.
	^self decodeAt: index!

bom 
	^Bom!

countElements
	| i count last |
	count := 0.
	i := 1.
	last := self size.
	[i > last] whileFalse: 
			[count := count + 1.
			i := i + (self encodedSizeAt: i)].
	^count!

decodeAt: anInteger
	"Private - Read the <Character> with code point in the receiver's encoding starting with the code unit at the specified index. If the index does not identify the start of a character, or the encoding is invalid or incomplete, return the replacement character."

	"The decoding algorithm is essentially the same as #decodeNextFrom:, where it is explained in more detail."

	<primitive: 225>
	| len c c2 |
	c := self basicAt: anInteger.
	c <= 16r7F
		ifTrue: 
			["Ascii char"
			^Character.CharacterSet at: c + 1].
	len := self size.
	len > anInteger
		ifFalse: 
			["Truncated multi-byte sequence"
			^Character.Replacement].
	c2 := self basicAt: anInteger + 1.
	"Multi-byte encoding, requires at least one continuation byte, C2..F4"
	c < LeadByteMask3
		ifTrue: 
			["2-byte encoding: C2..DF 80..BF"
			^(c >= 16rC2 and: [(c2 bitAnd: SurrogateMask) == TrailByteMask])
				ifTrue: 
					[(Character.AnsiCharacters lookup: (c := ((c bitAnd: 16r1F) bitShift: 6) bitOr: (c2 bitAnd: 16r3F)))
						ifNil: [Character basicUtf32Value: c]]
				ifFalse: 
					["Invalid continuation"
					Character.Replacement]].
	c < LeadByteMask4
		ifTrue: 
			["3 byte encoding:
				E0 A0..BF 80..BF
				E1..EC 80..BF 80..BF
				ED 80..9F 80..BF
				EE..EF 80..BF 80..BF"
			c == LeadByteMask3
				ifTrue: 
					[(c2 < 16rA0 or: [c2 > 16rBF])
						ifTrue: 
							["Invalid first continuation"
							^Character.Replacement]]
				ifFalse: 
					[c == 16rED
						ifTrue: 
							[(c2 <= 16r7F or: [c2 > 16r9F])
								ifTrue: 
									["Invalid first continuation"
									^Character.Replacement]]
						ifFalse: 
							[(c2 bitAnd: SurrogateMask) == TrailByteMask
								ifFalse: 
									["Invalid first continuation"
									^Character.Replacement]]].
			anInteger + 1 < len
				ifFalse: 
					["Initially valid 3-byte sequence, truncated sequence after 2-bytes at end of string"
					^Character.Replacement].
			c := ((c bitAnd: 16rF) bitShift: 12) bitOr: ((c2 bitAnd: 16r3F) bitShift: 6).
			c2 := self basicAt: anInteger + 2.
			(c2 bitAnd: SurrogateMask) == TrailByteMask
				ifFalse: 
					["Initially valid 3-byte sequence, truncated sequence after 2-bytes, mid-string"
					^Character.Replacement].
			c := c bitOr: (c2 bitAnd: 16r3F).
			(c bitAnd: 16rF800) == Utf16String.LeadSurrogateMask
				ifTrue: 
					["UTF-16 Surrogate, so whole sequence is invalid"
					^Character.Replacement].
			^(Character.AnsiCharacters lookup: c)
				ifNil: 
					[(c >= 16rFDD0 and: [c <= 16rFDEF or: [c allMask: 16rFFFE]])
						ifTrue: 
							["Non-characters - valid sequence, but character needs replacing"
							Character.Replacement]
						ifFalse: [Character basicUtf32Value: c]]].
	"4-Byte encodings
		F0 90..BF 80..BF 80..BF
		F1..F3 80..BF 80..BF 80..BF
		F4 80..8F 80..BF 80..BF"
	c == LeadByteMask4
		ifTrue: 
			[(c2 < 16r90 or: [c2 > 16rBF])
				ifTrue: 
					["Invalid first continuation"
					^Character.Replacement]]
		ifFalse: 
			[c == 16rF4
				ifTrue: 
					[(c2 <= 16r7F or: [c2 > 16r8F])
						ifTrue: 
							["Invalid first continuation"
							^Character.Replacement]]
				ifFalse: 
					[c > 16rF4
						ifTrue: 
							["Invalid encoding - 5&6 byte encodings are not supported"
							^Character.Replacement].
					(c2 bitAnd: SurrogateMask) == TrailByteMask
						ifFalse: 
							["Invalid first continuation"
							^Character.Replacement]]].
	anInteger + 1 < len
		ifFalse: 
			["Initially valid 4-byte sequence, truncated after 2-bytes at end of string"
			^Character.Replacement].
	c := ((c bitAnd: 7) bitShift: 18) bitOr: ((c2 bitAnd: 16r3F) bitShift: 12).
	c2 := self basicAt: anInteger + 2.
	(c2 bitAnd: SurrogateMask) == TrailByteMask
		ifFalse: 
			["Initially valid 4-byte sequence, truncated after 2-bytes, mid string"
			^Character.Replacement].
	anInteger + 2 < len
		ifFalse: 
			["Initially valid 4-byte sequence, truncated after 3-bytes at end of string"
			^Character.Replacement].
	c := c bitOr: ((c2 bitAnd: 16r3F) bitShift: 6).
	c2 := self basicAt: anInteger + 3.
	(c2 bitAnd: SurrogateMask) == TrailByteMask
		ifFalse: 
			["Initially valid 4-byte sequence, truncated after 3-bytes, mid string"
			^Character.Replacement].
	c := c bitOr: (c2 bitAnd: 16r3F).
	"Minimum 4-byte char is F0 90 80 80, which is U+10000. Will never appear in ANSI code page."
	^(Character.AnsiCharacters lookup: c)
		ifNil: 
			[(c allMask: 16rFFFE)
				ifTrue: 
					["Non-characters - valid sequence, but character needs replacing"
					Character.Replacement]
				ifFalse: [Character basicUtf32Value: c]]!

decodeNextFrom: aReadStream
	"Private - Read the next <Character> in the receiver's encoding from the <ReadStream> argument ."

	"0xxxxxxx	0x00..0x7F	1-byte character encoding for ASCII
	110xxxxx	0xC0..0xDF	Lead byte of a 2-byte character encoding
	1110xxxx	0xE0..0xEF	Lead byte of a 3-byte character encoding
	11110xxx	0xF0..0xF4	Lead byte of a 4-byte character encoding
	10xxxxxx	0x80..0xBF	Continuation bytes (x1, x2, or x3)"

	"Invalid sequences are now generally handled by the replacement of each element of the sequence with the replacement character. This differs from the D7 implementation, where invalid sequences are replaced by a single replacement character. Multi-character replacement has become the dominant approach, and is implemented in ICU as well as other commonly encountered decoders such as the chromium UTF-8 decoder. The Unicode standard does not require this interpretation (in fact it says 'An ill-formed subsequence consisting of more than one code unit could be treated as a single error or as multiple errors'). However, it does go on to suggest that the W3C encoding standard be used as a best (but not required) practice in the section 'U+FFFD Substitution of Maximal Subparts'. This section shows a number of examples of different replacements, which in most cases results in a replacement per byte of the invalid sequence, the exception being truncated sequences that would form a valid sequence if any of the valid continuation byte(s) were present to complete the sequence.

	Although the UTF-8 encoding has 5 & 6 character forms, these cannot represent a valid Unicode character (at least not in minimal form). These are also translated to the equivalent number of replacement characters.

	Valid encodings that result in 'non-characters' (i.e. assigned code points that are specifically designated as non-characters) are replaced with a single replacement character. This complies with the Unicode 15.0 standard: 'If a noncharacter that does not have a specific internal use is unexpectedly encountered in processing, an implementation may signal an error or replace the noncharacter with U+FFFD replacement character.'

	Private-use code points are returned as these are considered to be valid assigned characters, at least at this level. Their later interpretation may vary."

	| c c2 |
	((c := aReadStream basicNextAvailable) ifNil: [^nil]) <= 16r7F
		ifTrue: 
			["Ascii char"
			^Character.CharacterSet at: c + 1].

	"Multi-byte encoding, requires at least one continuation byte, C2..F4"
	(c2 := aReadStream basicNextAvailable)
		ifNil: 
			["Truncated multi-byte sequence"
			^Character.Replacement].
	c < LeadByteMask3
		ifTrue: 
			["2-byte encoding: C2..DF 80..BF"
			^(c >= 16rC2 and: [(c2 bitAnd: SurrogateMask) == TrailByteMask])
				ifTrue: 
					[(Character.AnsiCharacters lookup: (c := ((c bitAnd: 16r1F) bitShift: 6) bitOr: (c2 bitAnd: 16r3F)))
						ifNil: [Character basicUtf32Value: c]]
				ifFalse: 
					["Invalid continuation"
					aReadStream pop.
					Character.Replacement]].
	c < LeadByteMask4
		ifTrue: 
			["3 byte encoding:
				E0 A0..BF 80..BF
				E1..EC 80..BF 80..BF
				ED 80..9F 80..BF
				EE..EF 80..BF 80..BF"
			c == LeadByteMask3
				ifTrue: 
					[(c2 < 16rA0 or: [c2 > 16rBF])
						ifTrue: 
							["Invalid first continuation"
							aReadStream pop.
							^Character.Replacement]]
				ifFalse: 
					[c == 16rED
						ifTrue: 
							[(c2 <= 16r7F or: [c2 > 16r9F])
								ifTrue: 
									["Invalid first continuation"
									aReadStream pop.
									^Character.Replacement]]
						ifFalse: 
							[(c2 bitAnd: SurrogateMask) == TrailByteMask
								ifFalse: 
									["Invalid cfirst ontinuation"
									aReadStream pop.
									^Character.Replacement]]].
			c := ((c bitAnd: 16rF) bitShift: 12) bitOr: ((c2 bitAnd: 16r3F) bitShift: 6).
			(c2 := aReadStream basicNextAvailable)
				ifNil: 
					["Initially valid 3-byte sequence, truncated sequence after 2-bytes at end of stream"
					^Character.Replacement].
			(c2 bitAnd: SurrogateMask) == TrailByteMask
				ifFalse: 
					["Initially valid 3-byte sequence, truncated sequence after 2-bytes, mid-stream"
					aReadStream pop.
					^Character.Replacement].
			c := c bitOr: (c2 bitAnd: 16r3F).
			(c bitAnd: 16rF800) == Utf16String.LeadSurrogateMask
				ifTrue: 
					["UTF-16 Surrogate, so whole sequence is invalid"
					aReadStream skip: -2.
					^Character.Replacement].
			^(Character.AnsiCharacters lookup: c)
				ifNil: 
					[(c >= 16rFDD0 and: [c <= 16rFDEF or: [c allMask: 16rFFFE]])
						ifTrue: 
							["Non-characters - valid sequence, but character needs replacing"
							Character.Replacement]
						ifFalse: [Character basicUtf32Value: c]]].
	"4-Byte encodings
		F0 90..BF 80..BF 80..BF
		F1..F3 80..BF 80..BF 80..BF
		F4 80..8F 80..BF 80..BF"
	c == LeadByteMask4
		ifTrue: 
			[(c2 < 16r90 or: [c2 > 16rBF])
				ifTrue: 
					["Invalid first continuation"
					aReadStream pop.
					^Character.Replacement]]
		ifFalse: 
			[c == 16rF4
				ifTrue: 
					[(c2 <= 16r7F or: [c2 > 16r8F])
						ifTrue: 
							["Invalid first continuation"
							aReadStream pop.
							^Character.Replacement]]
				ifFalse: 
					[c > 16rF4
						ifTrue: 
							["Invalid encoding - 5&6 byte encodings are not supported"
							aReadStream pop.
							^Character.Replacement].
					(c2 bitAnd: SurrogateMask) == TrailByteMask
						ifFalse: 
							["Invalid first continuation"
							aReadStream pop.
							^Character.Replacement]]].
	c := ((c bitAnd: 7) bitShift: 18) bitOr: ((c2 bitAnd: 16r3F) bitShift: 12).
	(c2 := aReadStream basicNextAvailable)
		ifNil: 
			["Initially valid 4-byte sequence, but truncated after 2nd byte at end of stream"
			^Character.Replacement].
	(c2 bitAnd: SurrogateMask) == TrailByteMask
		ifFalse: 
			["Initially valid 4-byte sequence, but truncated after 2nd byte, mid-stream"
			aReadStream pop.
			^Character.Replacement].
	c := c bitOr: ((c2 bitAnd: 16r3F) bitShift: 6).
	(c2 := aReadStream basicNextAvailable)
		ifNil: 
			["Initially valid 4-byte sequence, but truncated after 3rd byte at end of stream"
			^Character.Replacement].
	(c2 bitAnd: 16rC0) == TrailByteMask
		ifFalse: 
			["Initially valid 4-byte sequence, but truncated after 3rd byte, mid-stream"
			aReadStream pop.
			^Character.Replacement].
	c := c bitOr: (c2 bitAnd: 16r3F).
	"Minimum 4-byte char is F0 90 80 80, which is U+10000. Will never appear in ANSI code page."
	^(Character.AnsiCharacters lookup: c)
		ifNil: 
			[(c allMask: 16rFFFE)
				ifTrue: 
					["Non-characters - valid sequence, but character needs replacing"
					Character.Replacement]
				ifFalse: [Character basicUtf32Value: c]]!

encodedAt: anInteger put: aCharacter
	"Private - Encode the specified <Character> beginning at the specified position in the receiver.
	Answer the <integer> index of the last code unit updated."

	| codePoint |
	codePoint := aCharacter codePoint.
	^codePoint <= 16r7F
		ifTrue: 
			[self basicAt: anInteger put: codePoint.
			anInteger]
		ifFalse: 
			[codePoint <= 16r7FF
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
							codePoint <= UCHAR_MAX_VALUE
								ifTrue: 
									[self
										basicAt: anInteger put: (LeadByteMask4 bitOr: (codePoint bitShift: -18));
										basicAt: anInteger + 1 put: (TrailByteMask bitOr: ((codePoint bitShift: -12) bitAnd: 16r3F));
										basicAt: anInteger + 2 put: (TrailByteMask bitOr: ((codePoint bitShift: -6) bitAnd: 16r3F));
										basicAt: anInteger + 3 put: (TrailByteMask bitOr: (codePoint bitAnd: 16r3F)).
									anInteger + 3]
								ifFalse: [self class errorInvalidCodePoint: codePoint]]]]!

encodedSizeAt: anInteger
	"Private - Answer the <integer> number of code units occupied by the <Character> whose first code unit is at the specified index in the receiver."

	"If we could assume that the UTF-8 was well-formed, we could calculate the length from at most the first two bytes, as a UTF-8 encoded code point is either single-byte ASCII, or the first continuation encodes the length. Unfortunately we cannot assume it is well-formed, and it is a potential security issue to do so, depending on the use case. This is, therefore, little different from actually decoding the characters We employ basically the same decoding as #decodeNextFrom:, which unfortunately is quite complicated and (potentially) slow due to the nature of UTF-8. The primitive uses the ICU U8_NEXT_OR_FFFD macro, but yields the same result as the Smalltalk code here."

	<primitive: 226>
	| len c c2 |
	c := self basicAt: anInteger.
	c <= 16r7F
		ifTrue: 
			["Ascii char"
			^1].
	len := self size.
	len > anInteger
		ifFalse: 
			["Truncated multi-byte sequence"
			^1].
	c2 := self basicAt: anInteger + 1.
	"Multi-byte encoding, requires at least one continuation byte, C2..F4"
	c < LeadByteMask3
		ifTrue: 
			["2-byte encoding: C2..DF 80..BF"
			^(c >= 16rC2 and: [(c2 bitAnd: SurrogateMask) == TrailByteMask])
				ifTrue: [2]
				ifFalse: 
					["Invalid"
					1]].
	c < LeadByteMask4
		ifTrue: 
			["3 byte encoding:
				E0 A0..BF 80..BF
				E1..EC 80..BF 80..BF
				ED 80..9F 80..BF
				EE..EF 80..BF 80..BF"
			c == LeadByteMask3
				ifTrue: 
					[(c2 < 16rA0 or: [c2 > 16rBF])
						ifTrue: 
							["Invalid continuation"
							^1]]
				ifFalse: 
					[c == 16rED
						ifTrue: 
							[(c2 <= 16r7F or: [c2 > 16r9F])
								ifTrue: 
									["Invalid continuation"
									^1]]
						ifFalse: 
							[(c2 bitAnd: SurrogateMask) == TrailByteMask
								ifFalse: 
									["Invalid continuation"
									^1]]].
			anInteger + 1 < len
				ifFalse: 
					["Valid but truncated sequence"
					^2].
			c := ((c bitAnd: 16rF) bitShift: 12) bitOr: ((c2 bitAnd: 16r3F) bitShift: 6).
			c2 := self basicAt: anInteger + 2.
			(c2 bitAnd: SurrogateMask) == TrailByteMask
				ifFalse: 
					["Valid but truncated sequence, mid-stream"
					^2].
			((c bitOr: (c2 bitAnd: 16r3F)) bitAnd: 16rF800) == Utf16String.LeadSurrogateMask
				ifTrue: 
					["Surrogate, so whole sequence is invalid"
					^1].
			^3].
	"4-Byte encodings
		F0 90..BF 80..BF 80..BF
		F1..F3 80..BF 80..BF 80..BF
		F4 80..8F 80..BF 80..BF"
	c == LeadByteMask4
		ifTrue: 
			[(c2 < 16r90 or: [c2 > 16rBF])
				ifTrue: 
					["Invalid continuation"
					^1]]
		ifFalse: 
			[c == 16rF4
				ifTrue: 
					[(c2 <= 16r7F or: [c2 > 16r8F])
						ifTrue: 
							["Invalid continuation"
							^1]]
				ifFalse: 
					[c > 16rF4
						ifTrue: 
							["Invalid encoding - 5&6 byte encodings are not supported"
							^1].
					(c2 bitAnd: SurrogateMask) == TrailByteMask
						ifFalse: 
							["Invalid continuation"
							^1]]].
	(anInteger + 1 < len and: [((self basicAt: anInteger + 2) bitAnd: SurrogateMask) == TrailByteMask])
		ifFalse: 
			["Initially valid 4-byte sequence, truncated after 2-bytes"
			^2].
	(anInteger + 2 < len and: [((self basicAt: anInteger + 3) bitAnd: SurrogateMask) == TrailByteMask])
		ifFalse: 
			["Initially valid 4-byte sequence, truncated after 3-bytes"
			^3].
	^4!

encodedSizeOf: aCharacter
	"Private - Answer the number of basic slots (code units) occupied by the argument when encoded in the UTF-8 encoding."

	^aCharacter utf8Length!

encodeOn: aPuttableStream put: aCharacter
	"Private - Encode the <Character> argument onto the <WriteStream> argument using the UTF-8 encoding. This requires between one and four byte code units to be written to the stream, depending on the magnitude of the code point. An error is raised if the <Character> has an invalid code point, or is a UTF-16 surrogate. If the <Character> is a UTF-8 surrogate, the surrogate code point is emitted directly."

	^aCharacter isUtf8
		ifTrue: [aPuttableStream basicNextPut: aCharacter codeUnit]
		ifFalse: 
			[| codePoint |
			codePoint := aCharacter codePoint.
			codePoint <= 16r7FF
				ifTrue: 
					["2-byte encoding"
					aPuttableStream
						basicNextPut: (LeadByteMask2 bitOr: (codePoint bitShift: -6));
						basicNextPut: (TrailByteMask bitOr: (codePoint bitAnd: 16r3F))]
				ifFalse: 
					[codePoint < 16rFFFF
						ifTrue: 
							["3-byte encoding"
							(codePoint bitAnd: 16rF800) == 16rD800
								ifTrue: [self error: 'Cannot encode UTF-16 surrogate into UTF-8']
								ifFalse: 
									[aPuttableStream
										basicNextPut: (LeadByteMask3 bitOr: (codePoint bitShift: -12));
										basicNextPut: (TrailByteMask bitOr: ((codePoint bitShift: -6) bitAnd: 16r3F));
										basicNextPut: (TrailByteMask bitOr: (codePoint bitAnd: 16r3F))]]
						ifFalse: 
							["4-byte encoding"
							codePoint <= UCHAR_MAX_VALUE
								ifTrue: 
									[aPuttableStream
										basicNextPut: (LeadByteMask4 bitOr: (codePoint bitShift: -18));
										basicNextPut: (TrailByteMask bitOr: ((codePoint bitShift: -12) bitAnd: 16r3F));
										basicNextPut: (TrailByteMask bitOr: ((codePoint bitShift: -6) bitAnd: 16r3F));
										basicNextPut: (TrailByteMask bitOr: (codePoint bitAnd: 16r3F))]
								ifFalse: [self class errorInvalidCodePoint: codePoint]]]]!

isLeadCodeUnit: anInteger
	^anInteger <= 16r7F or: [anInteger >= LeadByteMask2]!

isTrailSurrogate: anInteger 
	^(anInteger bitAnd: 16rC0) == TrailByteMask!

matchPatternFrom: patternStart in: aUtf8String from: sourceStart
	"Private - Answer whether the receiver matches aString (starting at patternStart in the receiver and sourceStart in source).
	The receiver may contain wildcards; $* matches any sequence of characters (including none), and $# matches any one character."

	"This is based on the #startingAt:match:startingAt: method in Squeak. It's a little messy, particularly after adaptation for variable length encoding, but is faster than the simpler and more elegant method implemented in Dolphin originally (by Russ, IIRC)."

	| i j matchEnd anyMatch matchStart matchStr ii jj |
	i := patternStart.
	j := sourceStart.

	"Process consecutive *s and #s at the beginning."
	anyMatch := false.
	matchEnd := self size.
	jj := aUtf8String size.
	
	[i <= matchEnd and: 
			[| ch |
			((ch := self at: i) == $* and: 
					[anyMatch := true.
					i := i + 1.
					true]) or: 
					[ch == $# and: 
							[j > jj ifTrue: [^false].
							i := i + 1.
							j := j + (aUtf8String encodedSizeAt: j).
							true]]]]
			whileTrue.
	i > matchEnd
		ifTrue: 
			[^j - 1 == jj or: 
					["We reached the end by matching the character with a #."
					anyMatch and: [j <= jj]	"Or there was a * before the end."]].
	matchStart := i.

	"Now determine the match string"
	(ii := self
				nextIndexOf: $*
				from: matchStart
				to: matchEnd) > 0
		ifTrue: [matchEnd := ii - 1].
	(ii := self
				nextIndexOf: $#
				from: matchStart
				to: matchEnd) > 0
		ifTrue: [matchEnd := ii - 1].
	matchStr := self copyFrom: matchStart to: matchEnd.

	"Now look for the match string"
	
	[jj := aUtf8String findString: matchStr startingAt: j.
	anyMatch ifTrue: [jj > 0] ifFalse: [jj == j]]
			whileTrue: 
				["Found matchStr at jj.  See if the rest matches..."
				(self
					matchPatternFrom: matchEnd + 1
					in: aUtf8String
					from: jj + matchStr size) ifTrue: [^true	"the rest matches -- success"].
				"The rest did not match."
				anyMatch ifFalse: [^false].
				"Preceded by * -- try for a later match"
				j := j + (aUtf8String encodedSizeAt: j)].
	^false	"Failed to find the match string"!

maxEncoding
	^4!

nextIndexOfCharacter: aCharacter from: startInteger to: stopInteger
	| codePoint i |
	codePoint := aCharacter codePoint.
	(codePoint <= 16r7F or: [aCharacter isUtf8Surrogate])
		ifTrue: 
			[^self
				basicIdentityIndexOf: codePoint
				from: startInteger
				to: stopInteger].
	i := startInteger.
	[i > stopInteger] whileFalse: 
			[(self decodeAt: i) = aCharacter ifTrue: [^i].
			i := i + (self encodedSizeAt: i)].
	^0!

reversedFrom: startInteger to: stopInteger
	"Answer a new <sequencedReadableCollection> like the receiver containing those elements of the receiver between the <integer> indices startInteger and stopInteger, inclusive, but in reverse order."

	| reversed i j size |
	j := size := stopInteger - startInteger + 1.
	reversed := self copyingClass new: size.
	i := startInteger.
	[i <= stopInteger] whileTrue: 
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

urlEncoded
	"Percent encode the receiver as described in RFC 3986 (https://tools.ietf.org/html/rfc3986) Section 2.
	Not every part in a URI should be encoded as it is explained in section 2.4 so you should be cautious."

	| encodedStream |
	encodedStream := AnsiString writeStream: self size.
	self codeUnitsDo: 
			[:each |
			"Unreserved characters from RFC3986, section 2.3: Ascii letters and digits, hyphen, underscore, period and tilde"
			('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~' includes: each)
				ifTrue: [encodedStream nextPut: each]
				ifFalse: 
					[encodedStream nextPut: $%.
					each codeUnit
						printOn: encodedStream
						base: 16
						nDigits: 2]].
	^encodedStream grabContents! !
!Core.Utf8String categoriesForMethods!
_beginsString:!comparing!double dispatch!private! !
asUtf8String!converting!public! !
asUtf8StringCopy!converting!public! !
before:ifAbsent:!public!searching! !
bom!constants!encode/decode!private! !
countElements!accessing!public! !
decodeAt:!encode/decode!private! !
decodeNextFrom:!encode/decode!private! !
encodedAt:put:!accessing!encode/decode!private! !
encodedSizeAt:!encode/decode!private! !
encodedSizeOf:!encode/decode!private! !
encodeOn:put:!encode/decode!private! !
isLeadCodeUnit:!encode/decode!public!testing! !
isTrailSurrogate:!public! !
matchPatternFrom:in:from:!private!searching! !
maxEncoding!constants!private! !
nextIndexOfCharacter:from:to:!private!searching! !
reversedFrom:to:!copying!public! !
urlEncoded!public! !
!

!Core.Utf8String class methodsFor!

characterForCodeUnit: anInteger
	^Character utf8Value: anInteger!

codePage
	"Answer the Windows code page constants for the receiver's encoding."

	^CP_UTF8!

encoding
	"Answer a <Symbol> naming the encoding of instances of the receiver, which will be one of #ansi, #utf8, #utf16 or #utf32."

	^#utf8!

initialize
	self extraInstanceSpec: EncodingUtf8.
	empty := ''.
	VM registryAt: #Utf8String put: self!

with: aCharacter
	"Answer a new instance of the receiver containing the <Character> argument as its single code point element. Note that this does not mean the String will have a code-unit size of 1 - it may have to be larger, depending on the number of code units of the string encoding that are required to represent the code point."

	^(WriteStream on: (self new: 2))
		nextPut: aCharacter;
		grabContents! !
!Core.Utf8String class categoriesForMethods!
characterForCodeUnit:!enquiries!public! !
codePage!instance creation!public! !
encoding!constants!public! !
initialize!development!initializing!public! !
with:!instance creation!public! !
!

