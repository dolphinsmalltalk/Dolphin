"Filed out from Dolphin Smalltalk 7"!

Core.String variableByteSubclass: #'Core.UtfEncodedString'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.UtfEncodedString guid: (Core.GUID fromString: '{f19f0843-d636-4c39-8815-afe452d16cb0}')!
Core.UtfEncodedString isNullTerminated: true!
Core.UtfEncodedString isNonInstantiable: true!
Core.UtfEncodedString comment: '`UtfEncodedString` is the abstract class of variable-width UTF-encoded strings. It has specialised subclasses for UTF-8, and UTF-16.

Like `AnsiString` and (as yet hypothetical) `Utf32String`, the elements of a `UtfEncodedString` are represented by `Character` instances when enumerating or accessing _by index_, but unlike those fixed-width encodings the values of the underlying elements are really code units rather than whole code points. Consequently the `Character` instances may represent surrogate (partial) characters from the encoding. This is a compromise required to represent the variable-width UTF encodings within the Smalltalk `SequenceableCollection` hierarchy, which was designed for fixed-width elements long before UTF-8 and UTF-16 were imagined, yet which also requires that the elements of `String`s be `Character`s. ANSI Smalltalk did nothing to address this issue; the `<readableString>` protocol is a sub-protocol of `<sequencedReadableCollection>` and contains many indexed access messages that cannot really be implemented efficiently against a variable width string. Even calculating the result for `#size` would require counting the characters and the count could be invalidated by any `#at:put:` operation, which might also require the string to be resized and its contents shuffled. Given the difficulty of squaring this circle, and the limited scenarios that really require direct indexing into strings, we have opted to interpret the requirement that the elements of strings be `Character`s by including surrogate characters as valid elements.

In practice, therefore, the implementation of `<readableString>` on `UtfEncodeString`s may return surrogate (partial) characters, for example:
```
	(Character dolphin asUtf16String at: 1) isSurrogate "true"
```
When working with compatible encodings (e.g. two `Utf16String`s), the fact that some standard collection protocols will return multi-part `Character`s as the individual surrogates often does not matter. With mixed encodings you will run into difficulties if trying to use the sequenceable collection block-copy and replace operations, since the number of code units required to represent the same characters may vary between encodings.  Issues may also arise when attempting to perform random access into the string without due regard to the actual character start position. For example the following expression loses the lead byte, resulting in an invalid string:
```
	(Character dolphin asUtf8String copyFrom: 2)
```

In general it is easier and often more efficient to work with streams when enumerating over Strings. When streaming over a `UtfEncodedString`, the `#next` and `#nextPut:` messages will return a `Character` representing a whole code point, or store one, respectively. As an example:
```
	multi := Character dolphin asUtf8String.
	multi size. "4"
	stream := multi readStream.
	stream next "$\x1F42C"
	stream position "4"
```
And an example of writing into a `UtfEncodedString`:
```
	stream := Utf8String writeStream.
	stream nextPut: Character dolphin.
	stream position. "4"
	stream contents. 
```
The fact that `Character`s may actually occupy more than one code unit element of a `UtfEncodeString` does give rise to some inconsistencies in both the `Stream` and `String` hierarchies.
 - `size` returns the number of code units, not code points (but see `length`).
 - Sequenceable collection operations that work with indices, .e.g. `copyFrom:to:` are expecting code unit indices, not code point indices. This doesn''t mean that these operations cannot be used successfully with strings e.g. `copyFrom:to:` can still be used for string slicing as long as the indices passed to it are in terms of code units and not code points. 
 - Searching operations that return indices will return the code unit index, so these are consistent with the expectations of the copying and replacing operations.
 - Random access into a string with `at:` may return surrogate characters representing code units (although see `decodeAt:` and `codePointAt:`).
 - Higher level collection operations that do not depend on indexing into the string (or on its size) can be expected to operate on code points, e.g. `copyWithout:`
 - Enumerations passed an index (e.g. `from:do:`) or a range of indices (e.g. `from:to:do:`) are expecting code unit indices, but will enumerate code points between those indices. In other words it cannot be relied upon that number of elements enumerated will be `stop - start + 1`, although it will always be less than or equal to that.
 - Sequenceable collection operations that are passed an element count are expecting a code point count, not a code unit count. This is deliberately not consistent with indices being code unit indices.
 - When working with the `PositionableStream` hierarchy one must be careful when recording or adjusting the position, and remember that relative positioning (e.g. with `#skip:`) always works in terms of the code-unit elements of the streamed over collection, not necessarily whole characters. In the case of `UtfEncodeString`s the underlying elements are code unit integers of 8 or 16 bits for UTF-8 and UTF-16 respectively. The position of a stream over a UtfEncodedString is the position in terms of code units, not Characters. The use of relative positioning either through `#skip:` or by directly adjusting the position to a point calculated without regard to the encoding is likely to lead to positioning errors. It is safe to reset the position to step back (for example) by using a previously recorded position. To advance the stream the next and peek family of messagess should be used unless to a previously recorded position at the start of an encoded character. It is generally not a good idea to mix position or size calculations based on the fixed width code units used as indices and sizes for the collection itself and for the stream position with the variable width code points read and written by the streams. '!
!Core.UtfEncodedString categoriesForClass!Collections-Text! !
!Core.UtfEncodedString methodsFor!

after: aCharacter ifAbsent: aNiladicValuable
	"Answer the <Character> after the <Character> argument or if not present the result of evaluating the <niladicValuable>."

	| index |
	index := self indexOf: aCharacter.
	^index == 0
		ifTrue: [aNiladicValuable value]
		ifFalse: 
			[| len |
			len := self encodedSizeOf: aCharacter.
			index + len > self size
				ifTrue: [self errorLastObject: aCharacter]
				ifFalse: [self decodeAt: index + len]]!

allButFirst: anInteger
	"Answer a copy of the receiver containing all but the first anInteger code points. Raise an error if there are not enough elements."

	| stream |
	stream := self readStream.
	anInteger timesRepeat: [stream next].
	^stream upToEnd!

allButLast: anInteger
	"Answer a copy of the receiver containing all but the last anInteger elements. Raise an error if there are not enough elements."

	^self copyFrom: 1 to: (self indexOfLast: anInteger) - 1!

allSatisfy: aMonadicValuable
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for every code point in the receiver."

	| stream ch |
	stream := self readStream.
	[(ch := stream nextAvailable) isNil] whileFalse: [(aMonadicValuable value: ch) ifFalse: [^false]].
	^true!

anySatisfy: aMonadicValuable
	"Answer whether the <monadicValuable> argument evaluates to true for any of the code points of the receiver."

	| stream ch |
	stream := self readStream.
	[(ch := stream nextAvailable) isNil] whileFalse: [(aMonadicValuable value: ch) ifTrue: [^true]].
	^false!

asArray
	"Answer an <Array> whose elements are <Character>s representing the code point sequence of the receiver.
	Note that this may not be of the same `size` as the receiver as any Characters of the receiver represented by multiple code-unit elements of the receiver will be decoded."

	| chars |
	chars := Array writeStream: self size.
	self codePointsDo: [:each | chars nextPut: each].
	^chars grabContents!

before: aCharacter ifAbsent: aNiladicValuable
	"Answer the <Character> representing the code point before the <Character> argument, or if not present the result of evaluating the <niladicValuable> argument."

	^self subclassResponsibility!

bom
	"Answer a <ByteArray> which is the byte-order mark for the receiver's encoding."

	^self subclassResponsibility!

codePointAt: anInteger
	"Answer the the full code point <Character> which would be that indexed by the argument if the receiver is considered as an <Array> of complete <Character>s."

	^self decodeAt: (self indexOfNth: anInteger)!

codePointsDo: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the full code point <Character> elements of the receiver. Answers the receiver. The elements are evaluated in sequence."

	| stream ch |
	stream := self readStream.
	[(ch := stream nextAvailable) isNil] whileFalse: [operation value: ch]!

codeUnitsDo: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the code unit <Character> elements of the receiver - note that these may be partial/surrogate characters. Answers the receiver. The elements are evaluated in sequence."

	super do: operation!

collect: aMonadicValuable
	"Evaluate the <monadicValuable> argument, transformer, for each of <Character> elements of the receiver, answering a new <String> consisting of the <Character>s returned by the transformation."

	| stream |
	stream := self copyingClass writeStream: self size.
	self codePointsDo: [:each | stream nextPut: (aMonadicValuable value: each)].
	^stream grabContents!

copyWith: aCharacter
	"Answer a <String> which is a copy of the receiver that has the specified <Character> concatenated to its end."

	^self , (self class with: aCharacter)!

copyWith: anObject atIndex: anInteger
	"Answer a <String> which is a copy of the receiver that has anObject inserted at the index, anInteger."

	| size extra |
	extra := self encodedSizeOf: anObject.
	"Verify that the specified index is not in the middle of a Character"
	self encodedSizeAt: anInteger.
	size := self size + extra.
	^(self copyLikeOfSize: size)
		replaceFrom: 1
			to: anInteger - 1
			with: self
			startingAt: 1;
		encodedAt: anInteger put: anObject;
		replaceFrom: anInteger + extra
			to: size
			with: self
			startingAt: anInteger;
		yourself!

copyWithoutIndex: anInteger
	"Answer a <String> which is a copy of the receiver but without the element with the specified index."

	| size len |
	len := self encodedSizeAt: anInteger.
	size := self size - len.
	^(self copyLikeOfSize: size)
		replaceFrom: 1
			to: anInteger - 1
			with: self
			startingAt: 1;
		replaceFrom: anInteger
			to: size
			with: self
			startingAt: anInteger + len;
		yourself!

decodeFrom: aReadStream upTo: anObject
	"Private - Answer the future sequence values of the <ReadStream>, aReadStream, up to but not including, the <Object>, anObject.
	The stream is left positioned after anObject. If there are no occurrences of anObject in the future sequence values of the
	stream, then the remainder of the future sequence is answered and the stream is left at end."

	^anObject isCharacter
		ifTrue: 
			[anObject isAscii
				ifTrue: [aReadStream basicUpTo: anObject]
				ifFalse: 
					[| newStream ch |
					newStream := self class writeStream: 128.
					[(ch := aReadStream nextAvailable) isNil or: [ch = anObject]] whileFalse: [newStream nextPut: ch].
					^newStream contents]]
		ifFalse: [aReadStream upToEnd]!

do: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the <Characters> of the receiver. Answers the receiver. The elements are evaluated in sequence."

	self codePointsDo: operation!

emitEncodingMarkerOn: aPositionableStream
	"Emit any encoding marker used for the stream encoding this collection represents onto the
	<PositionableStream> argument, which is assumed to be at the start of its sequence. This
	typically only relevant to string encodings, so there is nothing to do by default."

	self bom do: [:each | aPositionableStream basicNextPut: each]!

encodedAt: anInteger put: aCharacter
	"Private - Encode the specified <Character> beginning at the specified position in the receiver.
	Answer the <integer> index of the last code unit updated."

	^self subclassResponsibility!

encodedSizeOf: aCharacter
	"Private - Answer the number of basic slots occupied by the argument when encoded in the receiver's encoding."

	^self subclassResponsibility!

encodeOn: aWriteStream next: sizeInteger putAll: aSequenceableCollection startingAt: startInteger
	aSequenceableCollection class == self class
		ifTrue: 
			[aWriteStream
				basicNext: sizeInteger
				putAll: aSequenceableCollection
				startingAt: startInteger]
		ifFalse: 
			[startInteger to: startInteger + sizeInteger - 1
				do: [:i | self encodeOn: aWriteStream put: (aSequenceableCollection at: i)]].
	^aSequenceableCollection!

errorIntraCharacterIndex: anInteger
	^self error: 'The specified index is not for the first code unit of a character: '
				, anInteger displayString!

fifth
	"Answer a <Character> which is the fifth code point in the receiver. Raise an exception if there are fewer than five code points in the receiver."

	^self codePointAt: 5!

findFirst: aMonadicValuable
	"Answer the index of the first element of the receiver for which the monadic valuable argument evaluates to true. If there are no such elements, answer 0."

	| index stream ch |
	index := 1.
	stream := self readStream.
	[(ch := stream nextAvailable) isNil] whileFalse: 
			[(aMonadicValuable value: ch) ifTrue: [^index].
			index := stream position + 1].
	^0!

findLast: discriminator
	"Answer the <integer> index of the last element of the receiver for which the <monadicValuable> argument evaluates to true. If there are no such elements, answer 0."

	| index stream ch last |
	index := 1.
	stream := self readStream.
	last := 0.
	[(ch := stream nextAvailable) isNil] whileFalse: 
			[(discriminator value: ch) ifTrue: [last := index].
			index := stream position + 1].
	^last!

first
	"Answer an <Character> representing the first code point in the receiver. Raise an exception if the receiver is empty."

	^self decodeAt: 1!

first: anInteger
	"Answer a copy of the receiver comprising the leftmost anInteger elements."

	^self readStream next: anInteger!

fourth
	"Answer a <Character> representing the fourth code point of the receiver. Raise an exception if there are fewer than four code points in the receiver."

	^self codePointAt: 4!

growSize
	"Private - Answer the number of elements by which the receiver should grow, when growing!!
	(at least 2, in case the receiver is currently empty)"

	^self size max: self maxEncoding!

indexOfLast: anInteger
	"Private - Answer the <integer> index of the first code unit of the <Character> of the receiver that is (anInteger - 1) positions before the receiver's end. For example if the argument is one, then the code unit index of the last <Character> is returned. If two, then the code unit index of the penultimate <Character> is returned, and so on."

	| index count |
	count := anInteger.
	index := self size + 1.
	[count ~~ 0] whileTrue: 
			[index := index - 1.
			(self isLeadCodeUnit: (self basicAt: index)) ifTrue: [count := count - 1]].
	^index!

indexOfNth: anInteger
	"Private - Answer the <integer> index of the first code unit of the Nth element of the receiver if it were treated as an <Array> of <Character>"

	| index |
	index := 1.
	anInteger - 1 timesRepeat: [index := index + (self encodedSizeAt: index)].
	^index!

inject: anObject into: aDyadicValuable
	"Evaluate the <dyadicValuable> argument, aDyadicValuable, once for each <Character> in the receiver, passing the elements as the second argument, and passing the value of the previous evaluation as the first argument, starting with the <Object> argument, initialValue. The operation must answer the value it wishes to have passed as its first argument the next time
	it is evaluated. Answer the final value of the operation. This enumeration is particularly useful for performing summations and other statistical operations."

	| nextValue stream ch |
	nextValue := anObject.
	stream := self readStream.
	[(ch := stream nextAvailable) isNil]
		whileFalse: [nextValue := aDyadicValuable value: nextValue value: ch].
	^nextValue!

isLeadCodeUnit: anInteger
	"Private - Answer whether the <integer> argument is a valid lead code unit in the receiver's encoding (i.e. the first code unit in a variable length sequence of one to N that represents a complete code point)."

	^self subclassResponsibility!

keys
	"Answer a <collection> containing the receiver's keys. These are the starting indices for each of the <Character>s in the receiver."

	| keys |
	keys := Array writeStream: self size.
	self keysAndValuesDo: [:eachKey :eachValue | keys nextPut: eachKey].
	^keys grabContents!

keysAndValuesDo: aDyadicValuable
	"Evaluate the <dyadicValuable> argument for each <Character> element of the receiver with the <integer> index of that element and the element itself as the arguments."

	| index stream ch |
	index := 1.
	stream := self readStream.
	[(ch := stream nextAvailable) isNil] whileFalse: 
			[aDyadicValuable value: index value: ch.
			index := stream position + 1]!

last
	"Answer an <Character> representing the last code point in the receiver. Raise an exception if the receiver is empty."

	^self decodeAt: (self indexOfLast: 1)!

last: anInteger
	"Answer a copy of the receiver comprising the rightmost anInteger code points."

	^self copyFrom: (self indexOfLast: anInteger) to: self size!

leftString: anInteger
	"Answer a new string comprising up to the leftmost anInteger <Characters> of the receiver. 
	If the receiver has less than anInteger characters, then copy only those characters in the receiver."

	^self readStream nextAvailable: anInteger!

length
	"Answer the number of Unicode code-points in the receiver."

	^self countElements!

maxEncoding
	^self subclassResponsibility!

midString: anIntegerLength from: anIntegerStart
	"Answer a new string comprising the anIntegerLength <Characters> starting at anIntegerStart in the receiver."

	| stream |
	stream := self readStream.
	stream position: anIntegerStart - 1.
	^stream next: anIntegerLength!

pairsDo: aDyadicValuable
	| stream |
	stream := self readStream.
	[stream atEnd] whileFalse: [aDyadicValuable value: stream next value: stream next]!

reverseDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument, operation, against each element of the receiver in reverse order, from end to start."

	^self asArray reverseDo: aMonadicValuable!

second
	"Answer a <Character> representing the second code point in the receiver. Raise an exception if there are fewer than two code points in the receiver."

	^self codePointAt: 2!

select: aMonadicValuable
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's <Character> elements.
	Answer a new <String> containing only those <Character>s for which the discriminator evaluates to true."

	| stream |
	stream := self copyingClass writeStream: self size.
	self codePointsDo: [:each | (aMonadicValuable value: each) ifTrue: [stream nextPut: each]].
	^stream grabContents!

sixth
	"Answer a <Character> representing the sixth code point of the receiver. Raise an exception if there are fewer than six code points in the receiver."

	^self codePointAt: 6!

skipEncodingMarkerFrom: aPositionableStream
	"Private - Skip over any encoding marker used for the stream encoding this collection represents on the <PositionableStream> argument, which 
	is assumed to be at the start of its sequence."

	"For UTF-8, we advance over the BOM, if present"

	| anInteger bom |
	bom := self bom.
	anInteger := bom size.
	aPositionableStream size >= bom size
		ifTrue: 
			[| preamble |
			preamble := bom class new: anInteger.
			aPositionableStream
				basicNext: anInteger
				into: preamble
				startingAt: 1.
			preamble = bom ifFalse: [aPositionableStream position: 0]]!

strlen
	"Answer the length of the receiver (in code units) up to the first null terminator. This may be less than its size if it contains embedded nulls. It can never be greater than the receiver's size."

	^self subclassResponsibility!

third
	"Answer a <Character> representing the third code point of the receiver. Raise an exception if there are fewer than three code points in the receiver."

	^self codePointAt: 3!

uncheckedFrom: startInteger to: stopInteger keysAndValuesDo: aDyadicValuable
	"Private - Evaluate the <dyadicValuable> argument for each code point element of the receiver in the specified inclusive range, with the element and its index as respectively the second and first arguments. 
	Note that the indices are code unit positions, but the valuable will be evaluated only for the code points (and the index of their first code point as the key) between the specified code units.
	It is an error to specify a start position that is not the position of the lead code unit of a code point."

	| i |
	i := startInteger.
	[i <= stopInteger] whileTrue: 
			[aDyadicValuable value: i value: (self decodeAt: i).
			i := i + (self encodedSizeAt: i)]!

with: otherCollection do: aDyadicValuable
	"Evaluate the <dyadicValuable> argument with each of the receiver's elements along with the corresponding element from the <sequencedReadableCollection> argument, otherCollection. 
	Raise an exception if otherCollection is not the same size as the receiver."

	| stream |
	stream := self readStream.
	otherCollection do: 
			[:each |
			stream nextAvailable
				ifNil: [self errorCollectionsOfDifferentSizes]
				ifNotNil: [:ch | aDyadicValuable value: ch value: each]].
	stream atEnd ifFalse: [^self errorCollectionsOfDifferentSizes]! !
!Core.UtfEncodedString categoriesFor: #after:ifAbsent:!public!searching! !
!Core.UtfEncodedString categoriesFor: #allButFirst:!copying!public! !
!Core.UtfEncodedString categoriesFor: #allButLast:!copying!public! !
!Core.UtfEncodedString categoriesFor: #allSatisfy:!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #anySatisfy:!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #asArray!converting!public! !
!Core.UtfEncodedString categoriesFor: #before:ifAbsent:!public!searching! !
!Core.UtfEncodedString categoriesFor: #bom!constants!encode/decode!private! !
!Core.UtfEncodedString categoriesFor: #codePointAt:!debugger-step through!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #codePointsDo:!debugger-step through!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #codeUnitsDo:!debugger-step through!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #collect:!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #copyWith:!copying!public! !
!Core.UtfEncodedString categoriesFor: #copyWith:atIndex:!copying!public! !
!Core.UtfEncodedString categoriesFor: #copyWithoutIndex:!copying!public! !
!Core.UtfEncodedString categoriesFor: #decodeFrom:upTo:!encode/decode!private! !
!Core.UtfEncodedString categoriesFor: #do:!debugger-step through!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #emitEncodingMarkerOn:!accessing!public! !
!Core.UtfEncodedString categoriesFor: #encodedAt:put:!accessing!encode/decode!private! !
!Core.UtfEncodedString categoriesFor: #encodedSizeOf:!encode/decode!private! !
!Core.UtfEncodedString categoriesFor: #encodeOn:next:putAll:startingAt:!encode/decode!private! !
!Core.UtfEncodedString categoriesFor: #errorIntraCharacterIndex:!encode/decode!private! !
!Core.UtfEncodedString categoriesFor: #fifth!accessing!public! !
!Core.UtfEncodedString categoriesFor: #findFirst:!public!searching! !
!Core.UtfEncodedString categoriesFor: #findLast:!public!searching! !
!Core.UtfEncodedString categoriesFor: #first!accessing!public! !
!Core.UtfEncodedString categoriesFor: #first:!copying!public! !
!Core.UtfEncodedString categoriesFor: #fourth!accessing!public! !
!Core.UtfEncodedString categoriesFor: #growSize!accessing!private! !
!Core.UtfEncodedString categoriesFor: #indexOfLast:!accessing!encode/decode!private! !
!Core.UtfEncodedString categoriesFor: #indexOfNth:!accessing!encode/decode!private! !
!Core.UtfEncodedString categoriesFor: #inject:into:!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #isLeadCodeUnit:!encode/decode!public!testing! !
!Core.UtfEncodedString categoriesFor: #keys!accessing!public! !
!Core.UtfEncodedString categoriesFor: #keysAndValuesDo:!debugger-step through!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #last!accessing!public! !
!Core.UtfEncodedString categoriesFor: #last:!copying!public! !
!Core.UtfEncodedString categoriesFor: #leftString:!copying!public! !
!Core.UtfEncodedString categoriesFor: #length!accessing!public! !
!Core.UtfEncodedString categoriesFor: #maxEncoding!constants!private! !
!Core.UtfEncodedString categoriesFor: #midString:from:!copying!public! !
!Core.UtfEncodedString categoriesFor: #pairsDo:!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #reverseDo:!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #second!accessing!public! !
!Core.UtfEncodedString categoriesFor: #select:!enumerating!public! !
!Core.UtfEncodedString categoriesFor: #sixth!accessing!public! !
!Core.UtfEncodedString categoriesFor: #skipEncodingMarkerFrom:!encode/decode!private! !
!Core.UtfEncodedString categoriesFor: #strlen!accessing!private! !
!Core.UtfEncodedString categoriesFor: #third!accessing!public! !
!Core.UtfEncodedString categoriesFor: #uncheckedFrom:to:keysAndValuesDo:!debugger-step through!enumerating!private! !
!Core.UtfEncodedString categoriesFor: #with:do:!enumerating!public! !

!Core.UtfEncodedString class methodsFor!

codePage
	"Answer the Windows code page constant for the receiver's encoding."

	^self subclassResponsibility!

new: anInteger withAll: aCharacter
	"Answer a new instance of the receiver with <integer>, anInteger, elements, each of which is initialized to the <Character>, aCharacter.
	Note that the result will be of size elementCount * codeUnitsFor(elementValue)."

	| stream |
	stream := self writeStream: anInteger.
	anInteger timesRepeat: [stream nextPut: aCharacter].
	^stream contents! !
!Core.UtfEncodedString class categoriesFor: #codePage!constants!public! !
!Core.UtfEncodedString class categoriesFor: #new:withAll:!instance creation!public! !

