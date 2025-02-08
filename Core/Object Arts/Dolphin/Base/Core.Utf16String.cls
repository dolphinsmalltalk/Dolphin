"Filed out from Dolphin Smalltalk"!

Core.UtfEncodedString
	variableByteSubclass: #'Core.Utf16String'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'LeadOffset' -> 16rD7C0.
			'LeadSurrogateMask' -> 16rD800.
			'SurrogateMask' -> 16rFC00.
			'SurrogateOffset' -> 16r35FDC00.
			'TrailSurrogateMask' -> 16rDC00
		}!

Core.Utf16String guid: (Core.GUID fromString: '{87b4c51e-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.Utf16String isNullTerminated: true!

Core.Utf16String comment: 'Utf16String is the class of <Strings>s that use a the two or four byte UTF-16 LE encoding. UTF-16 is the standard encoding used for strings in the Windows APIs. Most of the time it is not necessary to worry about converting to UTF-16, however, since the class library and VM will normally be able to provide automatic conversions when required. However, it is recommended that Utf8String be used internally for all strings, and that conversion to/from UTF-16 be performed at interface boundaries where necessary.

When considering a `Utf16String` as a `SequenceableCollection`, its elements are `Character`s. However the `Character` elements represent UTF-16 code units, *not* Unicode code points. Most common code points for mainstream languages are represented by a single UTF-16 code unit, but it is unwise to ignore the code-point/code-unit distinction. Code-unit characters can be "surrogate" characters representing part of the encoding of a full code-point for those characters outside the Unicode basic plane. UTF-16 surrogate characters can be inserted into other `Utf16String`s (although this must be done with care to avoid creating invalid encodings), but not mixed with characters from other encodings such as those from `Utf8String`s. To enumerate a `Utf16String` as `Character`s representing Unicode code points, a `ReadStream` should be attached to the string and the characters read from that. For example:

```
	''Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ'' asUtf16String readStream do: [:each | Transcript nextPut: each asUppercase]. Transcript cr; flush.
```

It should also be noted that the `size` of a `Utf16String` is a count of the number of code units (16-bit words), and not the number of whole Unicode characters.  As mentioned most Unicode code points are encode by one UTF-16 code unit, but this is not always the case. For example:
```
''🐬'' asUtf16String size	"=> 2"
```
To better understand the full implications of the compromises made in introducing a variable width encoding into the `SequenceableCollection` hierarchy it is recommended to read the cautionary notes in the abstract superclass `UtfEncodedString`.'!

!Core.Utf16String categoriesForClass!Collections-Text! !

!Core.Utf16String methodsFor!

_beginsString: aString
	| size comparand |
	comparand := aString asUtf16String.
	size := self size.
	^size <= comparand size
		and: [(OS.Ucrt
				memcmp: comparand
				buf2: self
				count: size * 2) == 0]!

_endsString: aString
	| i size comparand |
	comparand := aString asUtf16String.
	size := comparand size.
	i := size - self size + 1.
	^self = (i <= 1 ifTrue: [comparand] ifFalse: [comparand copyFrom: i to: size])!

asUtf16String
	"Answer a UTF16-encoded equivalent of the receiver."

	^self!

asUtf16StringCopy
	"Answer a UTF16-encoded copy of the receiver."

	<primitive: 155>
	^self shallowCopy!

asUtf8String
	"Answer a <Utf8String> containing the same characters as the receiver."

	"In practice the primitive doesn't fail."

	<primitive: 216>
	| utf8 utf16 ch |
	utf8 := Utf8String writeStream: self size.
	utf16 := self readStream.
	[(ch := utf16 nextAvailable) isNil] whileFalse: [utf8 nextPut: ch].
	^utf8 grabContents!

at: anInteger
	"Answer the character at index, anInteger, in the receiver."

	<primitive: 63>
	^Character utf16Value: (self basicAt: anInteger) ifInvalid: Character.Replacement!

basicDecodeAt: anInteger
	"Private - Read the <Character> with code point in the receiver's encoding starting with the code unit at the specified index. If the index does not identify the start of a character, or the encoding is invalid or incomplete, return the replacement character."

	| surrogateBits leading |
	leading := self basicAt: anInteger.
	surrogateBits := leading bitAnd: SurrogateMask.
	^surrogateBits == LeadSurrogateMask
		ifTrue: 
			[| trailing |
			"Lead surrogate encountered"
			(anInteger < self size and: 
					[trailing := self basicAt: anInteger + 1.
					(trailing bitAnd: SurrogateMask) == TrailSurrogateMask])
				ifTrue: 
					["Valid surrogate pair"
					Character codePoint: (leading bitShift: 10) + trailing - SurrogateOffset
						ifInvalid: Character.Replacement]
				ifFalse: 
					["No trailing surrogate, answer the replacement character"
					Character.Replacement]]
		ifFalse: 
			[surrogateBits == TrailSurrogateMask
				ifTrue: [Character.Replacement]
				ifFalse: [Character utf16Value: leading ifInvalid: Character.Replacement]]!

before: aCharacter ifAbsent: aNiladicValuable
	"Answer the <Character> representing the code point before the <Character> argument, or if not present the result of evaluating the <niladicValuable> argument."

	| index ch |
	index := self indexOf: aCharacter.
	index == 0 ifTrue: [^aNiladicValuable value].
	index == 1 ifTrue: [^self errorFirstObject: aCharacter].
	ch := self at: index - 1.
	^ch isUtf16Trail ifTrue: [self decodeAt: index - 2] ifFalse: [ch]!

byteSize
	"Private - Answer the size in bytes of this object. For historical reasons this includes the null terminator (which is actually part of the memory allocated for the String by the Dolphin VM)."

	^self basicSize + 1 bitShift: 1!

countElements
	"Answer the number of Unicode code points in the receiver."

	^OS.ICU u_countChar32: self length: self size!

decodeNextFrom: aReadStream
	"Private - Read the next <Character> in the receiver's encoding from the <ReadStream> argument, which
	is assumed to be over a Utf16String (or a stream over a double-byte object) ."

	^aReadStream basicNextAvailable
		ifNotNil: 
			[:c |
			(c bitAnd: SurrogateMask) == LeadSurrogateMask
				ifTrue: 
					["Lead surrogate encountered"
					aReadStream basicNextAvailable
						ifNil: 
							["Lead surrogate but no trailing surrogate, answer the replacement character"
							Character.Replacement]
						ifNotNil: 
							[:c2 |
							(c2 bitAnd: SurrogateMask) == TrailSurrogateMask
								ifTrue: 
									["Valid surrogate pair"
									Character codePoint: (c bitShift: 10) + c2 - SurrogateOffset ifInvalid: Character.Replacement]
								ifFalse: 
									["No trailing surrogate, answer the replacement character"
									aReadStream pop.
									Character.Replacement]]]
				ifFalse: [Character utf16Value: c ifInvalid: Character.Replacement]]!

encodeAsBytesOn: aWriteStream from: startInteger count: sizeInteger
	"Private - Write <integer>, sizeInteger, code-units of the receiver starting with that at <integer>, startInteger, onto the binary <WriteStream>, aWriteStream. As the stream is binary, we just write the UTF-16 encoded bytes directly. We allow partial characters to be copied in this case. It is the responsibility of the application to either ensure that complete characters are eventually written, or that occurrences of the replacement character are acceptable."

	startInteger to: startInteger + sizeInteger - 1
		do: 
			[:i |
			| codeUnit |
			codeUnit := self basicAt: i.
			aWriteStream
				nextPut: (codeUnit bitAnd: 16rFF);
				nextPut: (codeUnit bitShift: -8)]!

encodeAsObjectsOn: aWriteStream from: fromInteger count: countInteger
	"Private - Encode <integer>, countInteger, code units of the receiver starting with that at <integer>, fromInteger, onto the <WriteStream>, aWriteStream. The code-units in the interval are decoded to codepoints, and whole Characters are written to the stream. It is an error to attempt to write partial characters from the receiver, so the interval must start on the first or only code unit of a code point, and end on the last or only code unit of a code point. Consequently it is an error to start on a trail-surrogate or finish on a lead-surrogate."

	| i to ch |
	countInteger <= 0 ifTrue: [^self].
	i := fromInteger.
	to := i + countInteger - 1.
	ch := self at: i.
	ch isUtf16Trail
		ifTrue: 
			["Starting on a trailing surrogate is an error"
			^InvalidArgumentError
				signal: 'Start position <1d> is in the middle of a UTF-16 encoded character' << { fromInteger }
				with: 'fromInteger'].
	
	[i := i + 1.
	"If we are on a surrogate pair, the interval must include the trailing surrogate so that we can write a complete code point to the UTF-8 stream, since UTF-8 has no representation for UTF-16 surrogates."
	ch isUtf16Lead
		ifTrue: 
			[i <= to
				ifTrue: 
					[ch := self decodeAt: i - 1.
					i := i + 1]
				ifFalse: 
					["Ending on a lead surrogate is an error"
					^InvalidArgumentError
						signal: 'End position <1d> is in the middle of a UTF-16 encoded character' << { i }
						with: 'countInteger']].
	aWriteStream nextPut: ch.
	i <= to]
			whileTrue: [ch := self at: i]!

encodeAsUtf16On: aWriteStream from: fromInteger count: countInteger
	"Private - Encode <integer>, countInteger, elements of the receiver starting with that at <integer>, fromInteger, onto the <WriteStream>, aWriteStream. The stream is known to be streaming out UTF-16 encoded text, and as this is the receiver's native encoding, we can just ask the stream to copy bytes directly from the receiver's binary representation. We allow partial characters to be copied in this case. It is the responsibility of the application to either ensure that complete characters are eventually written, or that occurrences of the replacement character are acceptable."

	aWriteStream
		basicNext: countInteger
		putAll: self
		startingAt: fromInteger!

encodedAt: anInteger put: aCharacter
	"Private - Encode the specified <Character> beginning at the specified position in the receiver.
	Answer the <integer> index of the last code unit updated."

	| codePoint |
	codePoint := aCharacter codePoint.
	^codePoint <= 16rFFFF
		ifTrue: 
			[self basicAt: anInteger put: codePoint.
			anInteger]
		ifFalse: 
			[codePoint <= OS.Win32Constants.MAX_UCSCHAR
				ifTrue: 
					[codePoint := codePoint - 16r10000.
					self
						basicAt: anInteger put: (codePoint bitShift: -10) + LeadSurrogateMask;
						basicAt: anInteger + 1 put: (codePoint bitAnd: 16r3FF) + TrailSurrogateMask.
					anInteger + 1]
				ifFalse: [self class errorInvalidCodePoint: codePoint]]!

encodedSizeAt: anInteger
	"Private - Answer the <integer> number of code units occupied by the <Character> whose first code unit is at the specified index in the receiver."

	<primitive: 226>
	^(((self basicAt: anInteger) bitAnd: SurrogateMask) == LeadSurrogateMask and: 
			[anInteger < self size
				and: [((self basicAt: anInteger + 1) bitAnd: SurrogateMask) == TrailSurrogateMask]])
		ifTrue: 
			["Valid surrogate pair"
			2]
		ifFalse: 
			["All other cases - single character, or invalid surrogate"
			1]!

encodedSizeOf: aCharacter
	"Private - Answer the number of basic slots occupied by the argument when encoded in the UTF-16 encoding."

	^aCharacter codePoint <= 16rFFFF ifTrue: [1] ifFalse: [2]!

encodeOn: aPuttableStream put: aCharacter
	"Private - Encode the <Character> argument onto the <WriteStream> argument using the UTF-16 encoding. This requires either one or two 2-byte code units be written to the stream, depending
	on whether the code point is in the basic multi-lingual plane (one code unit), or beyond the BMP (two code units). An error is raised if the <Character> has an invalid code point."

	| codePoint |
	codePoint := aCharacter codePoint.
	^codePoint <= 16rFFFF
		ifTrue: [aPuttableStream basicNextPut: codePoint]
		ifFalse: 
			[codePoint <= OS.Win32Constants.MAX_UCSCHAR
				ifTrue: 
					[#todo.	"http://www.unicode.org/faq/utf_bom.html suggests there might be a simpler (more efficient) calculation, but it looks incorrect to me"
					codePoint := codePoint - 16r10000.
					aPuttableStream
						basicNextPut: (codePoint bitShift: -10) + LeadSurrogateMask;
						basicNextPut: (codePoint bitAnd: 16r3FF) + TrailSurrogateMask]
				ifFalse: [self class errorInvalidCodePoint: codePoint]]!

isLeadCodeUnit: anInteger
	^(anInteger bitAnd: SurrogateMask) ~~ TrailSurrogateMask!

isTrailSurrogate: anInteger
	^(anInteger bitAnd: SurrogateMask) == TrailSurrogateMask!

maxEncoding
	^2!

nextIndexOfCharacter: aCharacter from: startInteger to: stopInteger
	| codePoint |
	codePoint := aCharacter codePoint.
	codePoint <= 16rFFFF
		ifTrue: 
			[aCharacter isUtf8Surrogate
				ifFalse: [startInteger to: stopInteger do: [:i | (self at: i) = aCharacter ifTrue: [^i]]].
			^0]
		ifFalse: 
			[| lead trail current |
			codePoint := codePoint - 16r10000.
			lead := Character utf16Value: (codePoint bitShift: -10) + LeadSurrogateMask.
			trail := Character utf16Value: (codePoint bitAnd: 16r3FF) + TrailSurrogateMask.
			current := self
						nextIndexOf: lead
						from: startInteger
						to: stopInteger - 1.
			[current ~~ 0 and: [current < stopInteger and: [(self at: current + 1) ~= trail]]] whileTrue: 
					[current := self
								nextIndexOf: lead
								from: current + 1
								to: stopInteger - 1].
			^current]!

replaceFrom: startInteger to: stopInteger with: aReadableString startingAt: startAtInteger
	"Replace the characters of the receiver at index positions startInteger through stopInteger
	inclusive with consecutive characters of the <readableString>, aReadableString, beginning at
	index position startAtInteger. Answer the receiver."

	| offset |
	#todo.	"Fix the block copy primitive to work with double-byte objects, then this can be removed."
	offset := startAtInteger - startInteger.
	"Perform overlapping moves backwards, otherwise forwards"
	(self == aReadableString and: [startAtInteger < startInteger])
		ifTrue: 
			[stopInteger to: startInteger
				by: -1
				do: [:i | self at: i put: (aReadableString at: offset + i)]]
		ifFalse: [startInteger to: stopInteger do: [:i | self at: i put: (aReadableString at: offset + i)]]!

resize: anInteger
	^super resize: anInteger * 2!

reversedFrom: startInteger to: stopInteger
	"Answer a copy of the receiver but with its elements in reverse order."

	| reversed i j size |
	j := size := stopInteger - startInteger + 1.
	reversed := self class new: size.
	i := startInteger.
	[i <= stopInteger] whileTrue: 
			[| ch |
			ch := self at: i.
			ch isSurrogate
				ifTrue: 
					[reversed
						at: j put: (self at: i + 1);
						at: j - 1 put: ch.
					j := j - 2.
					i := i + 2]
				ifFalse: 
					[reversed at: j put: ch.
					i := i + 1.
					j := j - 1]].
	^reversed!

skipEncodingMarkerFrom: aGettableStream
	"Private - Skip over any encoding marker used for the stream encoding this collection represents on the <gettableStream> argument, which 
	is assumed to be at the start of its sequence."

	^Error notYetImplemented!

strlen
	"Answer the length of the receiver (in code units) up to the first null terminator. This may be less than its size if it contains embedded nulls. It can never be greater than the receiver's size."

	^OS.Ucrt wcslen: self!

uint16AtOffset: anInteger
	"Private - Answer the unsigned 2 byte integer at offset (i.e. zero relative) anInteger in the receiver. 
	On iX86 the high and low order bytes are reversed; i.e. the bytes are ordered least significant first."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds		- anInteger is out of bounds"

	<primitive: 124>
	| answer |
	answer := 0.
	2 to: 1
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self basicAt: anInteger + i)].
	^answer!

uint16AtOffset: anInteger put: anObject
	"Private - Store an unsigned 16-bit value at byte offset anInteger within the receiver.
	If anObject is not representable as a 16-bit unsigned (Small)Integer, then 
	raise a 'cannot hold' error.

	Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 1..receiver's size - sizeof(WORD)).
		InvalidParameter2	- anObject is not a SmallInteger
		IntegerOutOfRange 	- anObject is not in the range 0..65535 (i.e. out of unsigned 16-bit range)."

	<primitive: 125>
	^self primitiveFailed: _failureCode! !

!Core.Utf16String categoriesForMethods!
_beginsString:!comparing!double dispatch!private! !
_endsString:!comparing!double dispatch!private! !
asUtf16String!converting!public! !
asUtf16StringCopy!converting!public! !
asUtf8String!converting!public! !
at:!accessing!public! !
basicDecodeAt:!encode/decode!private! !
before:ifAbsent:!public!searching! !
byteSize!accessing!private! !
countElements!accessing!public! !
decodeNextFrom:!encode/decode!private! !
encodeAsBytesOn:from:count:!encode/decode!private! !
encodeAsObjectsOn:from:count:!encode/decode!private! !
encodeAsUtf16On:from:count:!encode/decode!private! !
encodedAt:put:!accessing!encode/decode!private! !
encodedSizeAt:!encode/decode!private! !
encodedSizeOf:!encode/decode!private! !
encodeOn:put:!encode/decode!private! !
isLeadCodeUnit:!encode/decode!private!testing! !
isTrailSurrogate:!public! !
maxEncoding!constants!private! !
nextIndexOfCharacter:from:to:!private!searching! !
replaceFrom:to:with:startingAt:!public!replacing! !
resize:!mutating!public! !
reversedFrom:to:!copying!public! !
skipEncodingMarkerFrom:!encode/decode!private! !
strlen!accessing!private! !
uint16AtOffset:!accessing!primitives!private! !
uint16AtOffset:put:!accessing!primitives!private! !
!

!Core.Utf16String class methodsFor!

characterForCodeUnit: anInteger
	^Character utf16Value: anInteger!

codePage
	"Answer the Windows code page constant for the receiver's encoding."

	"Note: This is not a real code page, and cannot be used with most APIs expecting a code page
	identifier. It's main purpose is to distinguish UTF-16 in some circumstances."

	^CP_UNICODE!

coerceString: aString
	"Answer an instance of the receiver containing the same characters as the <String> argument."

	^aString asUtf16String!

elementSize
	"Answer the size of the elements of the receiver in bytes."

	^2!

encodeElementsOf: aSequenceableCollection from: fromInteger count: countInteger on: aWriteStream
	"Private - The <puttableStream> argument, aWriteStream, is asking the receiver, expected to be of it's underlying collection class, to encode data from <sequencedReadableCollection> argument, aSequenceableCollection, onto it. Since the receiver is UTF-16 encoded, we double-dispatch back to aSequenceableCollection to ask it to encode the interval of its elements starting at <integer> argument, fromInteger, and of <integer> size specified by the argument, countInteger, onto the stream. Note that the interval is specified in code units, so if aSequenceableCollection is some form of `UtfEncodedString`, then this will be a code-unit interval, not a code-point (Character) interval."

	aSequenceableCollection
		encodeAsUtf16On: aWriteStream
		from: fromInteger
		count: countInteger!

encoding
	"Answer a <Symbol> naming the encoding of instances of the receiver, which will be one of #ansi, #utf8, #utf16 or #utf32."

	^#utf16le!

fromAddress: anAddress
	"Answer a new String instantiated from the null terminated string at anAddress."

	^VM utf16StringFromAddress: anAddress!

fromAddress: anAddress length: anInteger
	"Answer a new <Utf16String>, of length anInteger, copied from the first anInteger code units pointed at by anAddress."

	anAddress isNull ifTrue: [^nil].
	^anAddress asExternalAddress
		replaceBytesOf: (self new: anInteger)
		from: 1
		to: anInteger * 2
		startingAt: 1!

fromBytes: aByteArray codePage: anInteger
	"Answer an instance of the receiver constructed from the specified byte-string assumed to be encoded per the specified code page."

	^anInteger == CP_UTF8
		ifTrue: [OS.ICU u_strFromUTF8WithSub: aByteArray]
		ifFalse: [OS.Kernel32 multiByteToWideChar: aByteArray codePage: anInteger]!

fromUtf16String: anAddressOrUtf16String
	"Answer a new instance of the receiver that is a copy of the UTF-16 string pointed at by the argument."

	^self fromAddress: anAddressOrUtf16String yourAddress!

initialize
	empty := self new
				beImmutableObject;
				yourself.
	VM registryAt: #Utf16String put: self.
	self extraInstanceSpec: EncodingUtf16.
	self addClassConstant: 'LeadOffset' value: LeadSurrogateMask - (16r10000 >> 10).
	self addClassConstant: 'SurrogateOffset'
		value: (LeadSurrogateMask bitShift: 10) + TrailSurrogateMask - 16r10000!

with: aCharacter
	"Answer a new instance of the receiver containing the single <Character> element,
	aCharacter."

	| cp |
	^(cp := aCharacter codePoint) <= 16rFFFF
		ifTrue: 
			[(self new: 1)
				basicAt: 1 put: cp;
				yourself]
		ifFalse: 
			[(self new: 2)
				encodedAt: 1 put: aCharacter;
				yourself]! !

!Core.Utf16String class categoriesForMethods!
characterForCodeUnit:!enquiries!public! !
codePage!constants!public! !
coerceString:!instance creation!public! !
elementSize!constants!encode/decode!public! !
encodeElementsOf:from:count:on:!encode/decode!private! !
encoding!constants!public! !
fromAddress:!instance creation!public! !
fromAddress:length:!instance creation!public! !
fromBytes:codePage:!instance creation!public! !
fromUtf16String:!instance creation!public! !
initialize!development!initializing!public! !
with:!instance creation!public! !
!

