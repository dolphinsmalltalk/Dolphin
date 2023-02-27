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
	((self basicAt: index) bitAnd: Character.Utf8SurrogateMask) == 16r80]
			whileTrue.
	^self decodeAt: index!

bom 
	^Bom!

countElements
	| length |
	length := 0.
	"Count the code-units that are not trailing bytes"
	1 to: self size
		do: [:i | ((self basicAt: i) bitAnd: Character.Utf8SurrogateMask) == 16r80 ifFalse: [length := length + 1]].
	^length!

decodeAt: anInteger
	"Private - Read the <Character> with code point in the receiver's encoding starting with the code unit at the specified index. Raise an error if the indexed code unit is not the first in a character. If the character encoding is invalid or incomplete, return the replacement character. Intolerance of indexing errors is intended to help detect logic errors in algorithms working with multi-byte strings, although this may also occur in incorrectly encoded data which is otherwise tolerated by returning the replacement character."

	| c c2 size codePoint min |
	c := self basicAt: anInteger.
	c < 16r80
		ifTrue: 
			["Ascii char"
			^Character.CharacterSet at: c + 1].

	"Lead byte?"
	c < 16rC0
		ifTrue: 
			["On a continution byte so in the middle of a character, which is invalid"
			^self errorIntraCharacterIndex: anInteger].
	"At least 2 byte character"
	size := self size.
	anInteger < size ifFalse: [^Character.Replacement].
	c2 := self basicAt: anInteger + 1.
	(c2 bitAnd: 16rC0) == 16r80
		ifTrue: 
			[codePoint := ((c bitAnd: 16r1F) bitShift: 6) bitOr: (c2 bitAnd: 16r3F).
			min := 16r80]
		ifFalse: 
			["Invalid1st continuation"
			^Character.Replacement].
	c >= 16rE0
		ifTrue: 
			[| c3 |
			"At least a 3-byte character"
			anInteger + 2 > size ifTrue: [^Character.Replacement].
			c3 := self basicAt: anInteger + 2.
			(c3 bitAnd: 16rC0) == 16r80
				ifTrue: 
					[codePoint := ((codePoint bitAnd: 16r3FF) bitShift: 6) bitOr: (c3 bitAnd: 16r3F).
					min := 16r800]
				ifFalse: 
					["Invalid 2nd continuation"
					^Character.Replacement].
			c >= 16rF0
				ifTrue: 
					[| c4 |
					"4-byte character"
					anInteger + 3 > size ifTrue: [^Character.Replacement].
					c4 := self basicAt: anInteger + 3.
					(c4 bitAnd: 16rC0) == 16r80
						ifTrue: 
							[codePoint := ((codePoint bitAnd: 16r7FFF) bitShift: 6) bitOr: (c4 bitAnd: 16r3F).
							min := 16r10000]
						ifFalse: 
							["Invalid 3rd continuation"
							^Character.Replacement].
					c >= 16rF8
						ifTrue: 
							["5 or 6-byte character (not currently possible - only 4 bytes required for max Unicode char"
							^Character.Replacement]]].
	codePoint < min
		ifTrue: 
			["Overlong encoding"
			^Character.Replacement].
	^Character codePoint: codePoint ifInvalid: [Character.Replacement]!

decodeNextFrom: aReadStream
	"Private - Read the next <Character> in the receiver's encoding from the <ReadStream> argument ."

	"0xxxxxxx	0x00..0x7F	1-byte character encoding for ASCII
	110xxxxx	0xC0..0xDF	Lead byte of a 2-byte character encoding
	1110xxxx	0xE0..0xEF	Lead byte of a 3-byte character encoding
	11110xxx	0xF0..0xF4	Lead byte of a 4-byte character encoding
	10xxxxxx	0x80..0xBF	Continuation bytes (x1, x2, or x3)"

	| min |
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
								ifNil: [^Character.Replacement]
								ifNotNil: 
									[:c2 |
									| codePoint |
									(c2 bitAnd: 16rC0) == 16r80
										ifTrue: 
											[codePoint := ((c bitAnd: 16r1F) bitShift: 6) bitOr: (c2 bitAnd: 16r3F).
											min := 16r80]
										ifFalse: 
											["Invalid1st continuation"
											aReadStream pop.
											^Character.Replacement].
									c >= 16rE0
										ifTrue: 
											["At least a 3-byte character"
											aReadStream basicNextAvailable
												ifNil: [^Character.Replacement]
												ifNotNil: 
													[:c3 |
													(c3 bitAnd: 16rC0) == 16r80
														ifTrue: 
															[codePoint := ((codePoint bitAnd: 16r3FF) bitShift: 6) bitOr: (c3 bitAnd: 16r3F).
															min := 16r800]
														ifFalse: 
															["Invalid 2nd continuation"
															aReadStream pop.
															^Character.Replacement].
													c >= 16rF0
														ifTrue: 
															["4-byte character"
															aReadStream basicNextAvailable
																ifNil: [^Character.Replacement]
																ifNotNil: 
																	[:c4 |
																	(c4 bitAnd: 16rC0) == 16r80
																		ifTrue: 
																			[codePoint := ((codePoint bitAnd: 16r7FFF) bitShift: 6) bitOr: (c4 bitAnd: 16r3F).
																			min := 16r10000]
																		ifFalse: 
																			["Invalid 3rd continuation"
																			aReadStream pop.
																			^Character.Replacement]].
															c >= 16rF8
																ifTrue: 
																	["5-byte character (not currently possible - only 4 bytes required for max Unicode char"
																	aReadStream basicNextAvailable
																		ifNil: [^Character.Replacement]
																		ifNotNil: 
																			[:c5 |
																			(c5 bitAnd: 16rC0) == 16r80
																				ifTrue: 
																					[codePoint := ((codePoint bitAnd: 16rFFFFF) bitShift: 6) bitOr: (c5 bitAnd: 16r3F).
																					min := 16r200000]
																				ifFalse: 
																					["Invalid 4th continuation"
																					aReadStream pop.
																					^Character.Replacement]].
																	c >= 16rFC
																		ifTrue: 
																			["6-byte character (not currently possible)"
																			aReadStream basicNextAvailable
																				ifNil: [^Character.Replacement]
																				ifNotNil: 
																					[:c6 |
																					(c6 bitAnd: 16rC0) == 16r80
																						ifTrue: 
																							[codePoint := ((codePoint bitAnd: 16r1FFFFFF) bitShift: 6) bitOr: (c6 bitAnd: 16r3F).
																							min := 16r4000000]
																						ifFalse: 
																							["Invalid 5th continuation"
																							aReadStream pop.
																							^Character.Replacement]]]]]]].
									codePoint < min
										ifTrue: 
											["Overlong encoding"
											^Character.Replacement].
									Character codePoint: codePoint ifInvalid: [Character.Replacement]]]
						ifFalse: 
							["On a continution byte so in the middle of a character, which is invalid"
							Character.Replacement]]]!

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
							codePoint <= OS.Win32Constants.MAX_UCSCHAR
								ifTrue: 
									[self
										basicAt: anInteger put: (LeadByteMask4 bitOr: (codePoint bitShift: -18));
										basicAt: anInteger + 1 put: (TrailByteMask bitOr: ((codePoint bitShift: -12) bitAnd: 16r3F));
										basicAt: anInteger + 2 put: (TrailByteMask bitOr: ((codePoint bitShift: -6) bitAnd: 16r3F));
										basicAt: anInteger + 3 put: (TrailByteMask bitOr: (codePoint bitAnd: 16r3F)).
									anInteger + 3]
								ifFalse: [self class errorInvalidCodePoint: codePoint]]]]!

encodedSizeAt: anInteger
	"Private - Answer the <integer> number of code units occupied by the <Character> whose first code unit is at the specified index in the receiver. Throw an error if the code unit at anInteger is not either an ASCII code point or a UTF-8 lead surrogate"

	| c |
	c := self basicAt: anInteger.
	^c >= 16rC0
		ifTrue: [c >= 16rE0 ifTrue: [c >= 16rF0 ifTrue: [4] ifFalse: [3]] ifFalse: [2]]
		ifFalse: 
			[c < 16r80
				ifTrue: 
					["Ascii char"
					1]
				ifFalse: 
					["On a continution byte so in the middle of a character, which is invalid"
					self errorIntraCharacterIndex: anInteger]]!

encodedSizeOf: aCharacter
	"Private - Answer the number of basic slots occupied by the argument when encoded in the UTF-8 encoding."

	^aCharacter isUtf8
		ifTrue: [1]
		ifFalse: 
			[| codePoint |
			codePoint := aCharacter codePoint.
			codePoint <= 16r7FF
				ifTrue: [2]
				ifFalse: 
					[codePoint <= 16rFFFF
						ifTrue: [3]
						ifFalse: 
							[codePoint <= 16r1FFFFF
								ifTrue: [4]
								ifFalse: 
									["Theoretically this is not possible, as the current max Unicode char is 16r10FFFF, but UTF-8 allows for up to 6 bytes of encoding"
									codePoint <= 16r3FFFFFF ifTrue: [5] ifFalse: [6]]]]]!

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
							codePoint <= OS.Win32Constants.MAX_UCSCHAR
								ifTrue: 
									[aPuttableStream
										basicNextPut: (16rF0 bitOr: (codePoint bitShift: -18));
										basicNextPut: (16r80 bitOr: ((codePoint bitShift: -12) bitAnd: 16r3F));
										basicNextPut: (16r80 bitOr: ((codePoint bitShift: -6) bitAnd: 16r3F));
										basicNextPut: (16r80 bitOr: (codePoint bitAnd: 16r3F))]
								ifFalse: [self class errorInvalidCodePoint: codePoint]]]]!

isLeadCodeUnit: anInteger
	^anInteger < 16r80 or: [anInteger >= 16rC0]!

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
	| codePoint stream i |
	stopInteger > self size ifTrue: [self errorSubscriptBounds: stopInteger].
	codePoint := aCharacter codePoint.
	(codePoint < 16r80 or: [aCharacter isUtf8Surrogate])
		ifTrue: 
			[^self
				basicIdentityIndexOf: codePoint
				from: startInteger
				to: stopInteger].
	stream := self readStream.
	i := startInteger - 1.
	stream position: i.
	
	[stream next = aCharacter ifTrue: [^i + 1].
	i := stream position.
	i >= stopInteger] whileFalse.
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

