"Filed out from Dolphin Smalltalk 7"!

String variableByteSubclass: #Utf16String
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Utf16String guid: (GUID fromString: '{87b4c51e-026e-11d3-9fd7-00a0cc3e4a32}')!
Utf16String isNullTerminated: true!
Utf16String comment: 'Utf16String is a minimal class to support UTF16 encoded wide character strings. Natively Dolphin uses byte-character strings at present.

Utf16Strings can be constructed from <String>s when needed by sending the #asUtf16String message, and converted back again by sending the #asString message.'!
!Utf16String categoriesForClass!Collections-Text! !
!Utf16String methodsFor!

, aSequencedReadableCollection
	"Answer a new <sequencedReadableCollection> like the receiver (i.e. of the receiver's
	species but not necessarily the exact same class) containing the elements	of the receiver 
	in their original order with those of the <sequencedReadableCollection> argument
	appended in their original order.
	Note: This is the concatenation operation, and is a simplified form of 
	#copyReplaceFrom:to:with:."

	| size newSize |
	size := self size.
	newSize := size + aSequencedReadableCollection size.
	^(self copyLikeOfSize: newSize)
		replaceFrom: 1
			to: size
			with: self
			startingAt: 1;
		replaceFrom: size + 1
			to: newSize
			with: aSequencedReadableCollection
			startingAt: 1;
		yourself!

_appendToString: aString
	^self asString _appendToString: aString!

_equalsByteString: aString
	"Private - Answer whether the receiver is equivalent to the byte string, aString. 
	Double-dispatched from String>>=."

	^aString asUtf16String = self!

_equalsUtf16String: aUtf16String
	"Private - Answer whether the receiver is equivalent to the <Utf16String> argument.
	Double-dispatched from Utf16String>>=."

	"We should only get here if the byte comparison primitive failed unexpected."

	^Utf16String primitiveFailed!

= comparand
	"Answer whether the receiver and the <Object> argument, comparand, 
	are both Strings containing identical characters (i.e. case sensitive).

	Primitive failure results:
		0 -	aString is not a byte object of the same class as the receiver."

	<primitive: 55>
	^comparand isString and: [comparand _equalsUtf16String: self]!

asAnsiString
	"Answer an ANSI encoded string representation of the receiver."

	^self asByteString: String!

asByteString: aClass
	"Private - Answer a byte-string encoded <String> of the specified class containing the same characters as the receiver."

	| bytes buf size |
	(size := self size) == 0 ifTrue: [^aClass empty].	"Avoid 'The Parameter is Incorrect' error"
	buf := aClass new: size * 4.
	bytes := KernelLibrary default
				wideCharToMultiByte: aClass codePage
				dwFlags: 0
				lpWideCharStr: self
				cchWideChar: -1
				lpMultiByteStr: buf
				cchMultiByte: buf size + 1
				lpDefaultChar: nil
				lpUsedDefaultChar: nil.
	bytes == 0 ifTrue: [^KernelLibrary default systemError].
	buf resize: bytes - 1.
	^buf!

asLowercase
	| copy |
	copy := self basicCopy.
	UserLibrary default stringLowerW: copy.
	^copy!

asString
	"Answer an byte encoded string representation of the receiver."

	#todo.	"Maybe return a Utf8String as the default byte encoding when converting from a wide string as otherwise the conversion is lossy?"
	^self asByteString: String!

asUppercase
	| copy |
	copy := self basicCopy.
	UserLibrary default stringUpperW: copy.
	^copy!

asUtf16String
	"Answer a UTF16-encoded equivalent of the receiver (i.e. the receiver)."

	^self!

asUtf8String
	"Answer a UTF8 encoded string representation of the receiver."

	^self asByteString: Utf8String!

at: anInteger
	"Answer the character at index, anInteger, in the receiver."

	^Character value: (self wordAtOffset: anInteger + anInteger - 2)!

at: anInteger put: aCharacter
	"Replace the character at index, anInteger, in the receiver with aCharacter."

	^self wordAtOffset: anInteger + anInteger - 2 put: aCharacter asInteger!

beginsWith: aCollection
	"Answer whether the receiver begins with the sequence
	of objects in the <Collection> argument."

	^self basicBeginsWith: aCollection!

byteSize
	"Private - Answer the size in bytes of this object, including the null terminator."

	^self basicSize + 2!

displayOn: aStream
	"Append the receiver in end-user form to aStream.
	We must convert to mbcs for display."

	aStream nextPutAll: self asString!

findString: aString startingAt: anInteger 
	"Answer the index of the <String> argument within the receiver, starting at the <integer>
	argument. If the receiver does not contain aString, answer 0."

	| size subSize firstElement |
	subSize := aString size.
	subSize == 0 ifTrue: [^0].
	firstElement := aString at: 1.
	size := self size.
	subSize == 1 
		ifTrue: 
			[^self 
				nextIndexOf: firstElement
				from: anInteger
				to: size].
	anInteger to: size - subSize + 1
		do: 
			[:i | 
			(self at: i) = firstElement 
				ifTrue: 
					[| j |
					j := 2.
					[(self at: i + j - 1) = (aString at: j)] whileTrue: 
							[j = subSize ifTrue: [^i].
							j := j + 1]]].
	^0!

first: anInteger
	"Answer a copy of the receiver comprising the leftmost anInteger elements."

	^self copyFrom: 1 to: anInteger!

indexOfSubCollection: targetSequence startingAt: start 
	"Answer the <integer> index of the next occurrence within the 
	receiver of the <sequencedReadableCollection> targetSequence,
	starting at the <integer> index start. If there are no such occurrences
	(or the search sequence is empty), answer 0."

	^self findString: targetSequence startingAt: start!

nextIdentityIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver's indexable
	variables between startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Implementation Note: Override the inherited implementation because the byte-character search
	primitives won't work."

	^anElement class == Character 
		ifTrue: [self nextIndexOf: anElement from: start to: stop]
		ifFalse: [0 "Can only contain characters"]!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0."

	self from: start to: stop keysAndValuesDo: [:i :elem | elem = anElement ifTrue: [^i]].
	^0!

printOn: aStream
	self asString printOn: aStream!

replaceFrom: startInteger to: stopInteger with: aReadableString startingAt: startAtInteger 
	"Replace the characters of the receiver at index positions startInteger through stopInteger
	inclusive with consecutive characters of the <readableString>, aReadableString, beginning at
	index position startAtInteger. Answer the receiver."

	| offset |
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

shallowCopy
	"Implemented here to ensure that copied Utf16Strings are correctly terminated with a double null"

	^self class fromAddress: self yourAddress length: self size!

size
	"Answer the number of characters in the receiver."

	^self basicSize bitShift: -1!

strcspn: aString start: anInteger
	^CRTLibrary default wcscspn: self yourAddress + ((anInteger - 1) * 2)
		strCharSet: aString asUtf16String!

wordAtOffset: anInteger
	"Private - Answer the unsigned 2 byte integer at offset (i.e. zero relative) anInteger in the receiver. 
	On iX86 the high and low order bytes are reversed; i.e. the bytes are ordered least 
	significant first.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger.
		1 -	anInteger is out of bounds."

	| answer |
	<primitive: 124>
	answer := 0.
	2 to: 1 by: -1 do: [:i |
		answer := (answer bitShift: 8) + (self basicAt: anInteger + i)].
	^answer!

wordAtOffset: anInteger put: anObject
	"Private - Store an unsigned 16-bit value at byte offset anInteger within the receiver.
	If anObject is not representable as a 16-bit unsigned (Small)Integer, then 
	raise a 'cannot hold' error.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger.
		1 -	anInteger is out of bounds.
		2 -	anObject is not a SmallInteger
		3 -	anObject is not in the range -32768..32767 (i.e. out of signed 16-bit range)."

	<primitive: 125>
	^self primitiveFailed! !
!Utf16String categoriesFor: #,!copying!public! !
!Utf16String categoriesFor: #_appendToString:!comparing!double dispatch!private! !
!Utf16String categoriesFor: #_equalsByteString:!comparing!private! !
!Utf16String categoriesFor: #_equalsUtf16String:!comparing!private! !
!Utf16String categoriesFor: #=!comparing!public! !
!Utf16String categoriesFor: #asAnsiString!converting!public! !
!Utf16String categoriesFor: #asByteString:!converting!private! !
!Utf16String categoriesFor: #asLowercase!converting!public! !
!Utf16String categoriesFor: #asString!converting!public! !
!Utf16String categoriesFor: #asUppercase!converting!public! !
!Utf16String categoriesFor: #asUtf16String!converting!public! !
!Utf16String categoriesFor: #asUtf8String!converting!public! !
!Utf16String categoriesFor: #at:!accessing!public! !
!Utf16String categoriesFor: #at:put:!accessing!public! !
!Utf16String categoriesFor: #beginsWith:!comparing!public! !
!Utf16String categoriesFor: #byteSize!accessing!private! !
!Utf16String categoriesFor: #displayOn:!printing!public! !
!Utf16String categoriesFor: #findString:startingAt:!public!searching! !
!Utf16String categoriesFor: #first:!copying!public! !
!Utf16String categoriesFor: #indexOfSubCollection:startingAt:!public!searching! !
!Utf16String categoriesFor: #nextIdentityIndexOf:from:to:!public!searching! !
!Utf16String categoriesFor: #nextIndexOf:from:to:!public!searching! !
!Utf16String categoriesFor: #printOn:!printing!public! !
!Utf16String categoriesFor: #replaceFrom:to:with:startingAt:!public!replacing! !
!Utf16String categoriesFor: #resize:!mutating!public! !
!Utf16String categoriesFor: #shallowCopy!public! !
!Utf16String categoriesFor: #size!accessing!public! !
!Utf16String categoriesFor: #strcspn:start:!private!searching! !
!Utf16String categoriesFor: #wordAtOffset:!accessing!primitives!private! !
!Utf16String categoriesFor: #wordAtOffset:put:!accessing!primitives!private! !

!Utf16String class methodsFor!

codePage
	^self shouldNotImplement!

elementSize
	"Answer the size of the elements of the receiver in bytes."

	^2!

fromAddress: anAddress
	"Answer a new String instantiated from the null terminated string at anAddress."

	| len |
	len := KernelLibrary default lstrlenW: anAddress.
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

fromString: aString
	"Answer a new instance of the receiver containing the same characters as the <String>
	argument."

	| answer cch |
	cch := aString size.
	"The result will have at most the number of code points as are present in the input, probably fewer if the input is UTF8"
	answer := self new: cch.
	^(cch := KernelLibrary default
				multiByteToWideChar: aString codePage
				dwFlags: 0
				lpMultiByteStr: aString
				cchMultiByte: -1
				lpWideCharStr: answer
				cchWideChar: cch + 1) == 0
		ifTrue: [KernelLibrary default systemError]
		ifFalse: [answer resize: cch - 1]	"MB_ERR_INVALID_CHARS"!

initialize
	empty := self new
				isImmutable: true;
				yourself.
	VMLibrary default registryAt: #Utf16String put: self!

new: anInteger
	"Answer an instance of the receiver to accomodate exactly
	anInteger characters (plus a null-term)."

	^super new: anInteger*2!

newFixed: aSmallInteger 
	"Answer an instance of the receiver of size aSmallInteger bytes (this method is 
	only valid for byte objects). The object is allocated from the fixed memory heap
	and will not move in memory (objects allocated with primitive 71 are free to 
	move to assist garbage collection, whereas those allocated with primitive 76 
	are in a traditional fixed heap)."

	^super newFixed: aSmallInteger * 2! !
!Utf16String class categoriesFor: #codePage!constants!public! !
!Utf16String class categoriesFor: #elementSize!constants!public! !
!Utf16String class categoriesFor: #fromAddress:!instance creation!public! !
!Utf16String class categoriesFor: #fromAddress:length:!instance creation!public! !
!Utf16String class categoriesFor: #fromString:!instance creation!public! !
!Utf16String class categoriesFor: #initialize!development!initializing!public! !
!Utf16String class categoriesFor: #new:!instance creation!public! !
!Utf16String class categoriesFor: #newFixed:!instance creation!public! !

