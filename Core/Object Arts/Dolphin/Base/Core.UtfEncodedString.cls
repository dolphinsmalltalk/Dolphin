"Filed out from Dolphin Smalltalk"!

Core.String
	variableByteSubclass: #'Core.UtfEncodedString'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ICUConstants})
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
	Note that this may not be of the same `size` as the receiver as any Characters of the receiver represented by multiple code-unit elements of the receiver will be decoded, including replacing invalid sequences with one or more replacement characters."

	| ch stream chars |
	chars := Array writeStream: self size.
	stream := ReadStream on: self.
	[(ch := stream nextAvailable) isNil] whileFalse: [chars nextPut: ch].
	^chars grabContents!

basicDecodeAt: anInteger 
	^self subclassResponsibility!

before: aCharacter ifAbsent: aNiladicValuable
	"Answer the <Character> representing the code point before the <Character> argument, or if not present the result of evaluating the <niladicValuable> argument."

	^self subclassResponsibility!

codePointAt: anInteger
	"Answer the full code point <Character> which would be that indexed by the argument if the receiver is considered as an <Array> of complete <Character>s."

	^self decodeAt: (self indexOfNth: anInteger)!

codePointsDo: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the full code point <Character> elements of the receiver. Answers the receiver. The elements are evaluated in sequence."

	| i last |
	i := 1.
	last := self size.
	[i > last] whileFalse: 
			[operation value: (self decodeAt: i).
			i := i + (self encodedSizeAt: i)]!

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

	^self , (self copyingClass with: aCharacter)!

copyWith: anObject atIndex: anInteger
	"Answer a <String> which is a copy of the receiver that has anObject inserted at the index, anInteger."

	| size extra |
	extra := self encodedSizeOf: anObject.
	"Verify that the specified index is not in the middle of a Character"
	(self isLeadCodeUnit: (self basicAt: anInteger))
		ifFalse: [self errorIntraCharacterIndex: anInteger].
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
	(self isTrailSurrogate: (self basicAt: anInteger))
		ifTrue: [self errorIntraCharacterIndex: anInteger].
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

decodeAt: anInteger
	"Private - Read the <Character> with code point in the receiver's encoding starting with the code unit at the specified index. If the index does not identify the start of a character, or the encoding is invalid or incomplete, return the replacement character."

	"The primitive uses the ICU macros, e.g. U8_NEXT, and is purely for speed of what is a low-level but (for UTF-8 at least) surprisingly complex operation."

	<primitive: 225>
	^self basicDecodeAt: anInteger!

detect: discriminator ifNone: exceptionHandler
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's 
	elements.  Answer the first element (in the #do: order) for which discriminator evaluates 
	to true. If none evaluates to true answer the result of evaluating the <niladicValuable> 
	argument, exceptionHandler."

	"Implementation note: Override to enumerate code points, not code units."

	| stream ch |
	stream := self readStream.
	[(ch := stream nextAvailable) isNil] whileFalse: [(discriminator value: ch) ifTrue: [^ch]].
	^exceptionHandler value!

do: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the <Characters> of the receiver. Answers the receiver. The elements are evaluated in sequence."

	self codePointsDo: operation!

do: aMonadicValuable separatedBy: aNiladicValuable
	"Evaluate the <monadicValuable> first argument for each of the receiver's elements, interspersed with evaluations of the <niladicValuable> second argument. The separator argument is first evaluated after the first element, and is not evaluated after the last element (i.e. it is not evaluated at all if there are less than two elements)."

	"Implementation Note: We have to override the superclass in order to enumerate code points rather than code units."

	| stream ch |
	stream := ReadStream on: self.
	(ch := stream nextAvailable) ifNil: [^self].
	
	[aMonadicValuable value: ch.
	(ch := stream nextAvailable) isNil]
			whileFalse: [aNiladicValuable value]!

emitEncodingMarkerOn: aWriteStream 
	"Private - Emit any encoding marker used for the stream encoding this collection represents onto the `<positionableStream>` argument, which is assumed to be at the start of its sequence."

	"For all UTF-encoded streams, codepoint U+FEFF, the Zero-Width No Break Space character, is used."
	aWriteStream nextPut: $\xFEFF!

encodeAsObjectsOn: aWriteStream from: fromInteger count: countInteger
	"Private - Encode <integer>, countInteger, code units of the receiver starting with that at <integer>, fromInteger, onto the <WriteStream>, aWriteStream. The code-units in the interval are decoded to codepoints, and whole Characters are written to the output stream. It is an error to attempt to write partial characters from the receiver, so the interval must start on the first or only code-unit of a codepoint, and end on the last or only code-unit of a codepoint."

	self subclassResponsibility!

encodedAt: anInteger put: aCharacter
	"Private - Encode the specified <Character> beginning at the specified position in the receiver.
	Answer the <integer> index of the last code unit updated."

	^self subclassResponsibility!

encodedSizeAt: anInteger
	"Private - Answer the <integer> number of code units occupied by the <Character> whose first code unit is at the specified index in the receiver."

	^self subclassResponsibility!

encodedSizeOf: aCharacter
	"Private - Answer the number of basic slots occupied by the argument when encoded in the receiver's encoding."

	^self subclassResponsibility!

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

	| stream ch index last |
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
	[count ~~ 0]
		whileTrue: [(self isLeadCodeUnit: (self basicAt: (index := index - 1))) ifTrue: [count := count - 1]].
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

	| nextValue ch stream |
	nextValue := anObject.
	stream := self readStream.
	[(ch := stream nextAvailable) isNil]
		whileFalse: [nextValue := aDyadicValuable value: nextValue value: ch].
	^nextValue!

isLeadCodeUnit: anInteger
	"Private - Answer whether the <integer> argument is a valid lead code unit in the receiver's encoding (i.e. the first code unit in a variable length sequence of one to N that represents a complete code point)."

	^self subclassResponsibility!

isTrailSurrogate: anInteger 
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

	"This is relatively a lot more costly than `(self at: self size)` for a UtfEncodedString because the final code unit may not be a whole code point, in which case we will need to step back to find the leading surrogate, and then decode forwards from there. See also #lastCodeUnit."

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

	"Implementation Note: Overridden for performance reasons only. It's typically faster to use a ReadStream when enumerating over a UTF encoded string because of the cost of the decoding, which is implemented very efficiently in the stream reading primitive."

	| read ch write |
	write := WriteStream on: (self copyingClass new: self size).
	read := ReadStream on: self.
	[read atEnd] whileFalse: [(aMonadicValuable value: (ch := read next)) ifTrue: [write nextPut: ch]].
	^write grabContents!

single
	"Answer the <Character> which is the only element of the receiver. 
	Raise an exception if the receiver does not contain exactly one character."

	(self encodedSizeAt: 1) == self size ifFalse: [self error: 'String is not of a single Character'].
	^self decodeAt: 1!

sixth
	"Answer a <Character> representing the sixth code point of the receiver. Raise an exception if there are fewer than six code points in the receiver."

	^self codePointAt: 6!

skipEncodingMarkerFrom: aPositionableStream
	"Private - Skip over any encoding marker in this collection which is that of the <PositionableStream> argument."

	"For UTF encoded strings we advance over the BOM, if present"

	aPositionableStream peekFor: $\xFEFF!

third
	"Answer a <Character> representing the third code point of the receiver. Raise an exception if there are fewer than three code points in the receiver."

	^self codePointAt: 3!

uncheckedFrom: startInteger to: stopInteger keysAndValuesDo: aDyadicValuable
	"Private - Evaluate the <dyadicValuable> argument for each code point element of the receiver in the specified inclusive range, with the element and its index as respectively the second and first arguments. 
	Note that the indices are code unit positions, but the valuable will be evaluated only for the code points (and the index of their first code point as the key) between the specified code units. Specifying an intra-character position will result in one or more replacement characters being enumerated, which is probably not what you want. Generally speaking it is safer (and more efficient in most cases) to stream over UtfEncodedStrings, because the code-point elements are not of fixed length (except for Utf32String), and the indices are expressed as code-unit positions (i.e. the bytes of a Utf8 string, or words of a Utf16String)"

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

!Core.UtfEncodedString categoriesForMethods!
after:ifAbsent:!public!searching! !
allButFirst:!copying!public! !
allButLast:!copying!public! !
allSatisfy:!enumerating!public! !
anySatisfy:!enumerating!public! !
asArray!converting!public! !
basicDecodeAt:!encode/decode!private! !
before:ifAbsent:!public!searching! !
codePointAt:!debugger-step through!enumerating!public! !
codePointsDo:!enumerating!public! !
codeUnitsDo:!debugger-step through!enumerating!public! !
collect:!enumerating!public! !
copyWith:!copying!public! !
copyWith:atIndex:!copying!public! !
copyWithoutIndex:!copying!public! !
decodeAt:!encode/decode!private! !
detect:ifNone:!public!searching! !
do:!debugger-step through!enumerating!public! !
do:separatedBy:!enumerating!public! !
emitEncodingMarkerOn:!encode/decode!private! !
encodeAsObjectsOn:from:count:!encode/decode!private! !
encodedAt:put:!accessing!encode/decode!private! !
encodedSizeAt:!encode/decode!private! !
encodedSizeOf:!encode/decode!private! !
errorIntraCharacterIndex:!encode/decode!private! !
fifth!accessing!public! !
findFirst:!public!searching! !
findLast:!public!searching! !
first!accessing!public! !
first:!copying!public! !
fourth!accessing!public! !
growSize!accessing!private! !
indexOfLast:!accessing!encode/decode!private! !
indexOfNth:!accessing!encode/decode!private! !
inject:into:!enumerating!public! !
isLeadCodeUnit:!encode/decode!public!testing! !
isTrailSurrogate:!public! !
keys!accessing!public! !
keysAndValuesDo:!debugger-step through!enumerating!public! !
last!accessing!public! !
last:!copying!public! !
leftString:!copying!public! !
length!accessing!public! !
maxEncoding!constants!private! !
midString:from:!copying!public! !
pairsDo:!enumerating!public! !
reverseDo:!enumerating!public! !
second!accessing!public! !
select:!enumerating!public! !
single!accessing!public! !
sixth!accessing!public! !
skipEncodingMarkerFrom:!encode/decode!private! !
third!accessing!public! !
uncheckedFrom:to:keysAndValuesDo:!debugger-step through!enumerating!private! !
with:do:!enumerating!public! !
!

!Core.UtfEncodedString class methodsFor!

codePage
	"Answer the Windows code page constant for the receiver's encoding."

	^self subclassResponsibility!

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
					newStream := self writeStream: 128.
					[(ch := aReadStream nextAvailable) isNil or: [ch = anObject]] whileFalse: [newStream nextPut: ch].
					^newStream contents]]
		ifFalse: [aReadStream upToEnd]! !

!Core.UtfEncodedString class categoriesForMethods!
codePage!constants!public! !
decodeFrom:upTo:!private! !
!

