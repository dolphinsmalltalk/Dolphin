"Filed out from Dolphin Smalltalk 7"!

Core.UtfEncodedString variableByteSubclass: #'Core.Utf16String'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'Bom' -> #[255 254].
		'LeadOffset' -> 16rD7C0.
		'SurrogateOffset' -> 16r35FDC00
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
	| size comperand |
	comperand := aString asUtf16String.
	size := self size.
	^size <= comperand size
		and: [(OS.CRTLibrary default
				memcmp: comperand
				buf2: self
				count: size * 2) == 0]!

asByteString: aClass
	"Private - Answer a byte-string encoded <String> of the specified class containing the same characters as the receiver."

	| bytes buf size |
	(size := self size) == 0 ifTrue: [^aClass empty].	"Avoid 'The Parameter is Incorrect' error"
	buf := aClass new: size * 4.
	bytes := OS.KernelLibrary default
				wideCharToMultiByte: aClass codePage
				dwFlags: 0
				lpWideCharStr: self
				cchWideChar: size
				lpMultiByteStr: buf
				cchMultiByte: buf size
				lpDefaultChar: nil
				lpUsedDefaultChar: nil.
	bytes == 0 ifTrue: [^OS.KernelLibrary default systemError].
	buf resize: bytes.
	^buf!

asLowercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to lowercase."

	| copy |
	copy := self shallowCopy.
	OS.UserLibrary default charLowerBuffW: copy cchLength: copy size.
	^copy!

asUppercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to uppercase."

	| copy |
	copy := self shallowCopy.
	OS.UserLibrary default charUpperBuffW: copy cchLength: copy size.
	^copy!

asUtf16String
	"Answer a UTF16-encoded equivalent of the receiver."

	^self!

at: anInteger
	"Answer the character at index, anInteger, in the receiver."

	<primitive: 63>
	^Character utf16Value: (self basicAt: anInteger) ifInvalid: [Character.Utf8Default]!

before: aCharacter ifAbsent: aNiladicValuable
	"Answer the <Character> representing the code point before the <Character> argument, or if not present the result of evaluating the <niladicValuable> argument."

	| index ch |
	index := self indexOf: aCharacter.
	index == 0 ifTrue: [^aNiladicValuable value].
	index == 1 ifTrue: [^self errorFirstObject: aCharacter].
	ch := self at: index - 1.
	^ch isUtf16Trail ifTrue: [self decodeAt: index - 2] ifFalse: [ch]!

bom
	^Bom!

byteSize
	"Private - Answer the size in bytes of this object. For historical reasons this includes the null terminator (which is actually part of the memory allocated for the String by the Dolphin VM)."

	^self basicSize + 1 bitShift: 1!

copyToBuffer: anAddress ofSize: anInteger
	OS.CRTLibrary default
		wcsncpy_s: anAddress
		bufferSize: anInteger
		strSource: self
		count: OS.CRTConstants._TRUNCATE!

countElements
	| length |
	length := 0.
	"Count the code-units that are not trailing surrogates"
	1 to: self size
		do: 
			[:i |
			((self basicAt: i) bitAnd: Character.Utf16SurrogateMask) == Character.Utf16TrailMask
				ifFalse: [length := length + 1]].
	^length!

decodeAt: anInteger
	"Private - Answer the encoded object beginning at the specified position in the receiver."

	| leading surrogateBits |
	leading := self basicAt: anInteger.
	surrogateBits := leading bitAnd: Character.Utf16SurrogateMask.
	^surrogateBits == Character.Utf16LeadMask
		ifTrue: 
			[| trailing |
			"Lead surrogate encountered"
			(anInteger < self size and: 
					[trailing := self basicAt: anInteger + 1.
					(trailing bitAnd: Character.Utf16SurrogateMask) == Character.Utf16TrailMask])
				ifTrue: 
					["Valid surrogate pair"
					Character codePoint: (leading bitShift: 10) + trailing - SurrogateOffset
						ifInvalid: [Character.Utf8Default]]
				ifFalse: 
					["No trailing surrogate, answer the replacement character"
					Character.Utf8Default]]
		ifFalse: 
			[surrogateBits == Character.Utf16TrailMask
				ifTrue: [self errorIntraCharacterIndex: anInteger]
				ifFalse: [Character utf16Value: leading ifInvalid: [Character.Utf8Default]]]!

decodeNextFrom: aReadStream
	"Private - Read the next <Character> in the receiver's encoding from the <ReadStream> argument, which
	is assumed to be over a Utf16String (or a stream over a double-byte object) ."

	^aReadStream basicNextAvailable
		ifNotNil: 
			[:c |
			(c bitAnd: Character.Utf16SurrogateMask) == Character.Utf16LeadMask
				ifTrue: 
					["Lead surrogate encountered"
					aReadStream basicNextAvailable
						ifNil: 
							["Lead surrogate but no trailing surrogate, answer the replacement character"
							Character.Utf8Default]
						ifNotNil: 
							[:c2 |
							(c2 bitAnd: Character.Utf16SurrogateMask) == Character.Utf16TrailMask
								ifTrue: 
									["Valid surrogate pair"
									Character codePoint: (c bitShift: 10) + c2 - SurrogateOffset ifInvalid: [Character.Utf8Default]]
								ifFalse: 
									["No trailing surrogate, answer the replacement character"
									aReadStream pop.
									Character.Utf8Default]]]
				ifFalse: [Character utf16Value: c ifInvalid: [Character.Utf8Default]]]!

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
						basicAt: anInteger put: (codePoint bitShift: -10) + Character.Utf16LeadMask ;
						basicAt: anInteger + 1 put: (codePoint bitAnd: 16r3FF) + Character.Utf16TrailMask.
					anInteger + 1]
				ifFalse: [self class errorInvalidCodePoint: codePoint]]!

encodedSizeAt: anInteger
	"Private - Answer the <integer> number of code units occupied by the <Character> whose first code unit is at the specified index in the receiver. Throw an error if the code unit at anInteger is not either an ASCII code point or a UTF-8 lead surrogate"

	| surrogateBits |
	surrogateBits := (self basicAt: anInteger) bitAnd: Character.Utf16SurrogateMask.
	^surrogateBits == Character.Utf16LeadMask
		ifTrue: [2]
		ifFalse: 
			[surrogateBits == Character.Utf16TrailMask
				ifTrue: [self errorIntraCharacterIndex: anInteger]
				ifFalse: [1]]!

encodedSizeOf: aCharacter
	"Private - Answer the number of basic slots occupied by the argument when encoded in the UTF-16 encoding."

	^aCharacter codePoint <= 16rFFFF ifTrue: [1] ifFalse: [2]!

encodeOn: aPuttableStream put: aCharacter
	"Private - Encode the <Character> argument onto the <WriteStream> argument using the UTF-16
	encoding. This requires either one or two 2-byte code units be written to the stream, depending
	on whether the code point is in the basic multi-lingual plane (one code unit), or beyond the BMP
	(two code units). An error is raised if the <Character> has an invalid code point."

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
						basicNextPut: (codePoint bitShift: -10) + Character.Utf16LeadMask;
						basicNextPut: (codePoint bitAnd: 16r3FF) + Character.Utf16TrailMask]
				ifFalse: [self class errorInvalidCodePoint: codePoint]]!

findString: aString startingAt: anInteger
	"Answer the index of the <String> argument within the receiver, starting at the <integer>
	argument. If the receiver does not contain aString, answer 0."

	^self basicIndexOfSubCollection: aString asUtf16String startingAt: anInteger!

indexOfSubCollection: targetSequence startingAt: start
	"Answer the <integer> index of the next occurrence within the 
	receiver of the <sequencedReadableCollection> targetSequence,
	starting at the <integer> index start. If there are no such occurrences
	(or the search sequence is empty), answer 0."

	^self findString: targetSequence startingAt: start!

isLeadCodeUnit: anInteger
	^(anInteger bitAnd: Character.Utf16SurrogateMask) ~~ Character.Utf16TrailMask!

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
			lead := Character utf16Value: (codePoint bitShift: -10) + Character.Utf16LeadMask.
			trail := Character utf16Value: (codePoint bitAnd: 16r3FF) + Character.Utf16TrailMask.
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

stbSaveOn: anSTBOutFiler
	"At present this is needed because STB doesn't work correctly with double-byte objects. It
	is may be desirable, anyway, to save as UTF-8 to save space, and the intention is that
	Utf8String and Utf16String instances be largely interchangeable."

	^self asUtf8String stbSaveOn: anSTBOutFiler!

strcspn: aString start: anInteger
	^OS.CRTLibrary default wcscspn: self yourAddress + ((anInteger - 1) * 2)
		strCharSet: aString asUtf16String!

strlen
	"Answer the length of the receiver (in code units) up to the first null terminator. This may be less than its size if it contains embedded nulls. It can never be greater than the receiver's size."

	^OS.KernelLibrary default lstrlenW: self!

wordAtOffset: anInteger
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

wordAtOffset: anInteger put: anObject
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
!Core.Utf16String categoriesFor: #_beginsString:!comparing!double dispatch!private! !
!Core.Utf16String categoriesFor: #asByteString:!converting!private! !
!Core.Utf16String categoriesFor: #asLowercase!converting!public! !
!Core.Utf16String categoriesFor: #asUppercase!converting!public! !
!Core.Utf16String categoriesFor: #asUtf16String!converting!public! !
!Core.Utf16String categoriesFor: #at:!accessing!public! !
!Core.Utf16String categoriesFor: #before:ifAbsent:!public!searching! !
!Core.Utf16String categoriesFor: #bom!constants!encode/decode!private! !
!Core.Utf16String categoriesFor: #byteSize!accessing!private! !
!Core.Utf16String categoriesFor: #copyToBuffer:ofSize:!copying!private! !
!Core.Utf16String categoriesFor: #countElements!accessing!public! !
!Core.Utf16String categoriesFor: #decodeAt:!encode/decode!private! !
!Core.Utf16String categoriesFor: #decodeNextFrom:!encode/decode!private! !
!Core.Utf16String categoriesFor: #encodedAt:put:!accessing!encode/decode!private! !
!Core.Utf16String categoriesFor: #encodedSizeAt:!encode/decode!private! !
!Core.Utf16String categoriesFor: #encodedSizeOf:!encode/decode!private! !
!Core.Utf16String categoriesFor: #encodeOn:put:!encode/decode!private! !
!Core.Utf16String categoriesFor: #findString:startingAt:!public!searching! !
!Core.Utf16String categoriesFor: #indexOfSubCollection:startingAt:!public!searching! !
!Core.Utf16String categoriesFor: #isLeadCodeUnit:!encode/decode!private!testing! !
!Core.Utf16String categoriesFor: #maxEncoding!constants!private! !
!Core.Utf16String categoriesFor: #nextIndexOfCharacter:from:to:!private!searching! !
!Core.Utf16String categoriesFor: #replaceFrom:to:with:startingAt:!public!replacing! !
!Core.Utf16String categoriesFor: #resize:!mutating!public! !
!Core.Utf16String categoriesFor: #reversedFrom:to:!copying!public! !
!Core.Utf16String categoriesFor: #skipEncodingMarkerFrom:!encode/decode!private! !
!Core.Utf16String categoriesFor: #stbSaveOn:!binary filing!public! !
!Core.Utf16String categoriesFor: #strcspn:start:!private!searching! !
!Core.Utf16String categoriesFor: #strlen!accessing!private! !
!Core.Utf16String categoriesFor: #wordAtOffset:!accessing!primitives!private! !
!Core.Utf16String categoriesFor: #wordAtOffset:put:!accessing!primitives!private! !

!Core.Utf16String class methodsFor!

characterForCodeUnit: anInteger
	^Character utf16Value: anInteger!

codePage
	"Answer the Windows code page constant for the receiver's encoding."

	"Note: This is not a real code page, and cannot be used with most APIs expecting a code page
	identifier. It's main purpose is to distinguish UTF-16 in some circumstances."

	^OS.NlsConstants.CP_UNICODE!

coerceString: aString
	"Answer an instance of the receiver containing the same characters as the <String> argument."

	^aString asUtf16String!

elementSize
	"Answer the size of the elements of the receiver in bytes."

	^2!

fromAddress: anAddress
	"Answer a new String instantiated from the null terminated string at anAddress."

	| len |
	len := OS.KernelLibrary default lstrlenW: anAddress.
	^self fromAddress: anAddress length: len!

fromAddress: anAddress length: anInteger
	"Answer a new <Utf16String>, of length anInteger, copied from the first anInteger
	code units pointed at by anAddress."

	^anAddress isNull
		ifFalse: 
			[| answer |
			answer := self new: anInteger.
			anAddress asExternalAddress
				replaceBytesOf: answer
				from: 1
				to: anInteger * 2
				startingAt: 1.
			answer]!

fromAtomId: anInteger
	"Answer a new string which is a copy of the atom with id anInteger."

	| atomName |
	^(atomName := self new: 255) leftString: (OS.KernelLibrary default
				getAtomName: anInteger
				lpBuffer: atomName
				nSize: atomName size)!

fromBytes: aByteArray codePage: anInteger
	"Answer an instance of the receiver constructed from the specified byte-string assumed to be encoded per the specified code page."

	| kernel cch cb answer |
	kernel := OS.KernelLibrary default.
	cb := aByteArray size.
	cb = 0 ifTrue: [^self empty].
	cch := kernel
				multiByteToWideChar: anInteger
				dwFlags: 0
				lpMultiByteStr: aByteArray
				cchMultiByte: cb
				lpWideCharStr: nil
				cchWideChar: 0.
	cch <= 0 ifTrue: [^kernel systemError].
	answer := self new: cch.
	kernel
		multiByteToWideChar: anInteger
		dwFlags: 0
		lpMultiByteStr: aByteArray
		cchMultiByte: cb
		lpWideCharStr: answer
		cchWideChar: cch.
	^answer!

fromUtf16String: anAddressOrUtf16String
	"Answer a new instance of the receiver which is a copy of the the UTF-16 string pointed at by the argument."

	^self fromAddress: anAddressOrUtf16String yourAddress!

initialize
	empty := self new
				isImmutable: true;
				yourself.
	VMLibrary default registryAt: #Utf16String put: self.
	self extraInstanceSpec: EncodingUtf16.
	self addClassConstant: 'LeadOffset' value: Character.Utf16LeadMask - (16r10000 >> 10).
	self addClassConstant: 'SurrogateOffset'
		value: (Character.Utf16LeadMask bitShift: 10) + Character.Utf16TrailMask - 16r10000!

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
!Core.Utf16String class categoriesFor: #characterForCodeUnit:!enquiries!public! !
!Core.Utf16String class categoriesFor: #codePage!constants!public! !
!Core.Utf16String class categoriesFor: #coerceString:!instance creation!public! !
!Core.Utf16String class categoriesFor: #elementSize!constants!public! !
!Core.Utf16String class categoriesFor: #fromAddress:!instance creation!public! !
!Core.Utf16String class categoriesFor: #fromAddress:length:!instance creation!public! !
!Core.Utf16String class categoriesFor: #fromAtomId:!instance creation!public! !
!Core.Utf16String class categoriesFor: #fromBytes:codePage:!instance creation!public! !
!Core.Utf16String class categoriesFor: #fromUtf16String:!instance creation!public! !
!Core.Utf16String class categoriesFor: #initialize!development!initializing!public! !
!Core.Utf16String class categoriesFor: #with:!instance creation!public! !

