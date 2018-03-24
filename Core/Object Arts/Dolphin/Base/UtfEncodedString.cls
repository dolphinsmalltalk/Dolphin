"Filed out from Dolphin Smalltalk 7"!

String variableByteSubclass: #UtfEncodedString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UtfEncodedString guid: (GUID fromString: '{f19f0843-d636-4c39-8815-afe452d16cb0}')!
UtfEncodedString isNullTerminated: true!
UtfEncodedString isAbstract: true!
UtfEncodedString comment: 'UtfEncodedString is the abstract class of variable-width UTF-encoded strings. It has specialised subclasses for UTF-8, and UTF-16.

Like AnsiString and Utf32String, the elements of a UtfEncodedString are represented by Character instances when enumerating or accessing by index, but unlike those fixed-width encodings the values of the elements are really code units rather than whole code points. Consequently the Character instances may represent surrogate (partial) characters from the encoding. This is a compromise required to represent the variable-width UTF encodings within the Smalltalk SequenceableCollection hierarchy, which was designed  for fixed-width elements long before UTF-8 and UTF-16 were imagined, yet which also requires that the elements of Strings be Characters. ANSI Smalltalk did nothing to address this issue; the <readableString> protocol is a sub-protocol of <sequencedReadableCollection> and contains many indexed access messages that cannot really be implemented efficiently against a variable width string. Even calculating the result for #size would require counting the characters and the count could be invalidated by any #at:put: operation, which might also require the string to be resized and its contents shuffled. Given the difficulty of squaring this circle, and the limited scenarios that really require direct indexing into strings, we have opted to interpret the requirement that the elements of strings be Characters by including surrogate Characters as valid elements. 

In practice, therefore, the implementation of <readableString> on UtfEncodeStrings may return surrogate (partial) characters, for example:

	(Character dolphin asUtf16String at: 1) isSurrogate "true"

When working with compatible encodings (e.g. two Utf16Strings), the fact that the standard collection protocols will enumerate multi-part Characters as the individual surrogates often does not matter. Issues may arise when attempting to perform random access into the String without due regard to the actual Character start position. For example the following expression loses the lead byte, resulting in an invalid string:

	(Character dolphin asUtf8String copyFrom: 2)

In order to enumerate the actual Unicode code points of a UtfEncodedString it is necessary to either be prepared to assemble complete code points from surrogate code units, or Streams should be used. When streaming over a UtfEncodedString, the #next and #nextPut: messages will return a Character representing a whole code point, or store one, respectively. As an example:

	multi := Character dolphin asUtf8String.
	multi size. "4"
	stream := multi readStream.
	stream next "$\x1F42C"
	stream position "4"

And an example of writing into a UtfEncodedString:

	stream := Utf8String writeStream.
	stream nextPut: Character dolphin.
	stream position. "4"
	stream contents. 

The fact that Characters may actually occupy more than one code unit element of a UtfEncodeString does give rise to some inconsistencies in both the Stream and String hierarchies. When working with the PositionableStream hierarchy one must be careful when recording or adjusting the position, and remember that relative positioning (e.g. with #skip:) always works in terms of the code-unit elements of the streamed over collection, not necessarily whole characters. In the case of UtfEncodeStrings the underlying elements are code unit integers of 8 or 16 bits for UTF-8 and UTF-16 respectively. The position of a stream over a UtfEncodedString is the position in terms of code units, not Characters. The use of relative positioning either through #skip: or by directly adjusting the position to a point calculated without regard to the encoding is likely to lead to positioning errors. It is safe to reset the position to step back (for example) by using a previously recorded position. To advance the stream next and peek family should be used unless to a previously recorded position at the start of an encoded character. It is generally not a good idea to mix position or size calculations based on the fixed width code units used as indices and sizes for the collection itself and for the stream position with the variable width code points read and written by the streams. '!
!UtfEncodedString categoriesForClass!Collections-Text! !
!UtfEncodedString methodsFor!

asArray
	"Answer an <Array> whose elements are the Characters of the receiver in the same sequence.
	Note that this may not be of the same size as the receiver as any Characters of the receiver
	represented by multiple code-unit elements of the receiver will be decoded."

	| chars stream ch |
	chars := Array writeStream: self size.
	stream := self readStream.
	[(ch := stream nextAvailable) isNil] whileFalse: [chars nextPut: ch].
	^chars contents!

copyWith: newElement
	"Answer a <sequencedReadableCollection> which is a copy of 
	the receiver that has newElement concatenated to its end."

	^self, (self class with: newElement)!

encodedAt: anInteger put: aCharacter
	"Private - Encode the specified <Character> beginning at the specified position in the receiver.
	Answer the <integer> index of the last code unit updated."

	^self subclassResponsibility!

growSize
	"Private - Answer the number of elements by which the receiver should grow, when growing!!
	(at least 2, in case the receiver is currently empty)"

	^self size max: self maxEncoding!

maxEncoding
	^self subclassResponsibility!

reverse
	"Answer a copy of the receiver but with its elements in reverse order."

	^self subclassResponsibility! !
!UtfEncodedString categoriesFor: #asArray!public! !
!UtfEncodedString categoriesFor: #copyWith:!copying!public! !
!UtfEncodedString categoriesFor: #encodedAt:put:!accessing!encode/decode!private! !
!UtfEncodedString categoriesFor: #growSize!accessing!private! !
!UtfEncodedString categoriesFor: #maxEncoding!constants!private! !
!UtfEncodedString categoriesFor: #reverse!copying!public! !

UtfEncodedString methodProtocol: #readableString attributes: #(#ansi #readOnly) selectors: #(#, #< #<= #> #>= #after: #asLowercase #asString #asSymbol #asUppercase #at: #at:ifAbsent: #before: #between:and: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #do: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #keysAndValuesDo: #last #max: #min: #reverse #reverseDo: #sameAs: #subStrings: #with:do:)!
UtfEncodedString methodProtocol: #String attributes: #(#ansi #readOnly) selectors: #(#, #< #<= #> #>= #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asLowercase #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #asString #asSymbol #asUppercase #at: #at:ifAbsent: #at:put: #atAll:put: #atAllPut: #before: #between:and: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #max: #min: #notEmpty #occurrencesOf: #rehash #reject: #replaceFrom:to:with: #replaceFrom:to:with:startingAt: #replaceFrom:to:withObject: #reverse #reverseDo: #sameAs: #select: #size #subStrings: #with:do:)!

!UtfEncodedString class methodsFor!

codePage
	^self subclassResponsibility!

	^self subclassResponsibility!

decodeFrom: aReadStream upTo: aCharacter
	"Answer the future sequence values of the <ReadStream>, aReadStream, up to but not including, the <Object>, anObject.
	The stream is left positioned after anObject. If there are no occurrences of anObject in the future sequence values of the
	stream, then the remainder of the future sequence is answered and the stream is left at end."

	^aCharacter isAscii
		ifTrue: [aReadStream basicUpTo: aCharacter]
		ifFalse: 
			[| newStream ch |
			newStream := self writeStream: 128.
			[(ch := aReadStream nextAvailable) isNil or: [ch = aCharacter]] whileFalse: [newStream nextPut: ch].
			^newStream contents]!

decodeNextFrom: aReadStream
	"Answer the next <Object> in the receiver's encoding from the <ReadStream> argument ."

	^aReadStream basicNextAvailable!

emitEncodingMarkerOn: aPositionableStream
	"Emit any encoding marker used for the stream encoding this collection represents onto the
	<PositionableStream> argument, which is assumed to be at the start of its sequence. This
	typically only relevant to string encodings, so there is nothing to do by default."

	bom do: [:each | aPositionableStream basicNextPut: each]!

encodedSizeOf: anObject
	"Answer the number of basic slots occupied by the argument when encoded in the receiver."

	^self subclassResponsibility!

encodeOn: aWriteStream next: sizeInteger putAll: aSequenceableCollection startingAt: startInteger
	startInteger to: startInteger + sizeInteger - 1
		do: [:i | self encodeOn: aWriteStream put: (aSequenceableCollection at: i)].
	^aSequenceableCollection!

new: elementCount withAll: elementValue
	"Answer a new instance of the receiver with <integer>, elementCount, 
	elements, each of which is initialized to the <Object>, elementValue.
	Note that the result will be of size elementCount * codeUnitsFor(elementValue)."

	| stream |
	stream := self writeStream: elementCount.
	elementCount timesRepeat: [stream nextPut: elementValue].
	^stream contents!

skipEncodingMarkerFrom: aPositionableStream
	"Skip over any encoding marker used for the stream encoding this collection represents on the <PositionableStream> argument, which 
	is assumed to be at the start of its sequence."

	"For UTF-8, we advance over the BOM, if present"

	| anInteger |
	anInteger := bom size.
	aPositionableStream size >= bom size
		ifTrue: 
			[| preamble |
			preamble := bom class new: anInteger.
			aPositionableStream
				basicNext: anInteger
				into: preamble
				startingAt: 1.
			preamble = bom ifFalse: [aPositionableStream position: 0]]! !
!UtfEncodedString class categoriesFor: #bom!accessing!private! !
!UtfEncodedString class categoriesFor: #codePage!constants!public! !
!UtfEncodedString class categoriesFor: #decodeFrom:upTo:!encode/decode!public! !
!UtfEncodedString class categoriesFor: #decodeNextFrom:!encode/decode!public! !
!UtfEncodedString class categoriesFor: #emitEncodingMarkerOn:!accessing!public! !
!UtfEncodedString class categoriesFor: #encodedSizeOf:!encode/decode!public! !
!UtfEncodedString class categoriesFor: #encodeOn:next:putAll:startingAt:!encode/decode!public! !
!UtfEncodedString class categoriesFor: #new:withAll:!instance creation!public! !
!UtfEncodedString class categoriesFor: #skipEncodingMarkerFrom:!encode/decode!public! !

