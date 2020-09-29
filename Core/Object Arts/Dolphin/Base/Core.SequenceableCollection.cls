"Filed out from Dolphin Smalltalk 7"!

Core.Collection subclass: #'Core.SequenceableCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SequenceableCollection guid: (Core.GUID fromString: '{87b4c50a-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.SequenceableCollection isNonInstantiable: true!
Core.SequenceableCollection comment: 'SequenceableCollection is the class of Collections whose elements are ordered and which are externally named by integer indices.'!
!Core.SequenceableCollection categoriesForClass!Collections-Abstract! !
!Core.SequenceableCollection methodsFor!

, aSequencedReadableCollection
	"Answer a new <sequencedReadableCollection> like the receiver (i.e. of the receiver's copy-class but not necessarily the exact same class) containing the elementsof the receiver in their original order with those of the <sequencedReadableCollection> argument appended in their original order.
	Note: This is the concatenation operation, and is a simplified form of  #copyReplaceFrom:to:with:."

	| size newSize |
	size := self size.
	newSize := size + aSequencedReadableCollection size.
	^aSequencedReadableCollection maxEncoding == 1
		ifTrue: 
			[(self copyLikeOfSize: newSize)
				replaceFrom: 1
					to: size
					with: self
					startingAt: 1;
				replaceFrom: size + 1
					to: newSize
					with: aSequencedReadableCollection
					startingAt: 1;
				yourself]
		ifFalse: 
			[(self copyingClass writeStream: newSize)
				nextPutAll: self;
				nextPutAll: aSequencedReadableCollection;
				contents]!

_sameAsString: comparand
	"Private - Answer whether the receiver collates the same as <readableString>
	argument, comparand.
	This will only work if the receiver contains integers in the range of character
	values, if not an exception will be raised.
	Implementation Note: Double dispatched from String>>sameAs:."

	| string2 size |
	size := self size.
	string2 := String new: size.
	1 to: size do: [:i | string2 basicAt: i put: (self at: i)].
	^comparand <=> string2 == 0!

= comparand
	"Answer whether the receiver and the <Object> argument, comparand,
	are considered equivalent - that is they are of the same class and size, and
	contain eqivalent elements that are in the same sequence.
	Implementation Note: We perform a series of tests of increasing slowness, culminating
	in an element-by-element equality test."

	| size |
	self == comparand ifTrue: [^true].
	#todo "ANSI draft says must be same class, not just same species".
	(self species == comparand species) ifFalse: [^false].
	size := self size.
	size = comparand size ifFalse: [^false].
	1 to: size do: [ :i |
		(self at: i) = (comparand at: i)
			ifFalse: [^false]].
	^true!

after: anObject
	"Answer the element after the argument, anObject. Report an error if target is not in the receiver, or if there are no elements after it."

	^self after: anObject ifAbsent: [self errorNotFound: anObject]!

after: target ifAbsent: exceptionHandler
	"Answer the element after target, or if not present the result of evaluating the
	niladic valuable, exceptionHandler."

	| index |
	index := self indexOf: target.
	^index == 0
		ifTrue: [exceptionHandler value]
		ifFalse: [
			index = self size 
				ifTrue: [self errorLastObject: target]
				ifFalse: [self at: index + 1]]!

allButFirst
	"Answer a copy of the receiver containing all but the first
	element. Raise an error if there are not enough elements."

	^self allButFirst: 1!

allButFirst: n
	"Answer a copy of the receiver containing all but the first n
	elements. Raise an error if there are not enough elements."

	^ self copyFrom: n + 1 to: self size!

allButLast
	"Answer a copy of the receiver containing all but the last
	element. Raise an error if there are not enough elements."

	^ self allButLast: 1!

allButLast: anInteger
	"Answer a copy of the receiver containing all but the last anInteger elements. Raise an error if there are not enough elements."

	^self copyFrom: 1 to: self size - anInteger!

anyOne
	"Answer an arbitrary element of the collection.Raise an error if the collection is empty."

	^self first!

appendToStream: puttableStream
	"Private - Append the receiver's elements to the argument, puttableStream.
	We can be able to do a fast block copy. Answer the receiver.
	Implementation note: Double dispatched from puttableStream>>nextPutAll:."

	puttableStream next: self size putAll: self startingAt: 1!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: In general sequenceable collections keep a
	tally, so we can use the actual size."

	^self size!

asArray
	"Answer an <Array> whose elements are those of the receiver in the same sequence."

	| size |
	size := self size.
	^self
		replaceElementsOf: (Array new: size)
		from: 1
		to: size
		startingAt: 1!

asRunArray
	"Answer a <RunArray> whose elements are the same as those of the receiver. The order of
	elements will be the same, and there will be the same number when enumerated, but the
	identity of any duplicated elements in a run will be lost. This is useful for obtaining a
	compressed representation of a <sequencedReadableCollection> known to contain runs of equal
	elements."

	| runs values |
	runs := Array writeStream.
	values := Array writeStream.
	self runsAndValuesDo: 
			[:run :value |
			runs nextPut: run.
			values nextPut: value].
	^RunArray runs: runs contents values: values contents!

associations
	"Answer a <SequenceableCollection>, like the receiver, containing the receiver's associations."

	"Implementation Note: SequenceableCollections don't actually contain associations so the result 
	is built afresh each time and modifying its contents will not affect the original collection. However
	this is no different to the implementation for LookupTable/IdentityDictionary."

	| answer |
	answer := self copyLikeOfSize: self copySize.
	self keysAndValuesDo: [:i :each | answer at: i put: i -> each].
	^answer!

asString
	"Answer a <String> containing the same <Character>s as the receiver. This can be expected to fail if any of the elements of the receiver are not <Character>s."

	| stream |
	stream := String writeStream: self copySize.
	self do: [:each | stream nextPut: each].
	^stream grabContents!

at: index
	"Answer an <Object> which is the element of the receiver 
	at the specified index. If the index is out of bounds, raise an exception."

	^self subclassResponsibility!

at: index ifAbsent: exceptionBlock
	"Answer an <Object> which is the element of the receiver 
	at the specified index. If the index is out of bounds answer
	the result of evaluating the <niladicValuable> exceptionBlock."

	^(index > 0 and: [index <= self size])
		ifTrue: [self at: index]
		ifFalse: [exceptionBlock value]!

at: key ifPresent: operation 
	"Answer the result of evaluating the monadic valuable, operation, if
	the argument, key, is the key of an element in the receiver, with that
	element as its argument. If the key is not present, then answer nil."

	| value |
	value := self at: key ifAbsent: [AbsentCookie].
	^value == AbsentCookie ifFalse: [operation value: value]!

at: index put: newElement
	"Replace the element of the receiver at the specified <integer> index with 
	the <Object> argument, newElement. If the index is out of bounds, raise 
	a BoundsError."

	^self subclassResponsibility!

atAll: indices put: newElement
	"Replace the elements of the receiver at each <integer> element of the <collection> 
	argument, indices, with the <Object> argument, newElement."

	indices do: [:index | self at: index put: newElement]!

atAllPut: newElement
	"Replace all the elements of the receiver with the <Object> argument, newElement."

	self from: 1 to: self size put: newElement!

basicBeginsWith: aCollection
	"Answer whether the receiver begins with the sequence
	of objects in the <Collection> argument.
	Should not be overridden (but see #beginsWith:)"

	| i |
	self size < aCollection size ifTrue: [^false].
	i := 1.
	aCollection do: 
			[:each | 
			(self at: i) = each ifFalse: [^false].
			i := i + 1].
	^true!

basicIndexOfSubCollection: targetSequence startingAt: start
	| firstElement subSize size |
	subSize := targetSequence size.
	subSize == 0 ifTrue: [^0].
	firstElement := targetSequence at: 1.
	size := self size.
	subSize == 1
		ifTrue: 
			[^self
				nextIndexOf: firstElement
				from: start
				to: size].
	start to: size - subSize + 1
		do: 
			[:i |
			(self at: i) = firstElement
				ifTrue: 
					[| j |
					j := 2.
					[(self at: i + j - 1) = (targetSequence at: j)] whileTrue: 
							[j = subSize ifTrue: [^i].
							j := j + 1]]].
	^0!

before: target
	"Answer the receiver's element immediately before the argument, target. 
	Raise an exception if target is not an element of the receiver, or if 
	there are no elements before it (i.e. it is the first element)."

	^self before: target ifAbsent: [self errorNotFound: target]!

before: anObject ifAbsent: exceptionHandler
	"Answer the element before the argument, anObject, or if not present the result of evaluating the niladic valuable, exceptionHandler."

	| index |
	index := self indexOf: anObject.
	^index == 0
		ifTrue: [exceptionHandler value]
		ifFalse: [index == 1 ifTrue: [self errorFirstObject: anObject] ifFalse: [self at: index - 1]]!

beginsWith: aCollection
	"Answer whether the receiver begins with the sequence
	of objects in the <Collection> argument."

	^self basicBeginsWith: aCollection!

binarySearchFor: anObject using: searchBlock 
	"Answer the index at which anObject would have to be inserted into this collection in order to maintain its sort order. The <dyadicValuble> search block must express the same ordering."

	^self class 
		binarySearch: self
		for: anObject
		using: searchBlock!

collect: transformer 
	"Evaluate the <monadicValuable> argument, transformer, for each of the 
	receiver's elements in the order defined by the receiver's implementation of #do:.
	Answer a new collection like the receiver (i.e. of the same species but not
	necessarily the exact same class) containing the values returned by transformation
	block."

	"Implementation Note: By making use of the special instance creation method 
	#copyLikeOfSize: we can avoid using a WriteStream here."

	| answer |
	answer := self copyLikeOfSize: self copySize.
	self keysAndValuesDo: [:i :each | answer at: i put: (transformer value: each)].
	^answer!

copyFrom: start
	"Answer a copy of a subset of the receiver which starts with its element at Integer 
	index start."

	^self copyFrom: start to: self size!

copyFrom: startInteger to: stopInteger
	"Answer a new <sequencedReadableCollection> like the receiver containing those elements of the receiver between the <integer> indices startInteger and stopInteger, inclusive, and in the same order."

	| len |
	len := stopInteger - startInteger + 1.
	^(self copyLikeOfSize: len)
		replaceFrom: 1
		to: len
		with: self
		startingAt: startInteger!

copyLikeOfSize: anInteger
	"Private - Answer a new collection of the receiver's copying class but with the number of nil or zero elements specified by the <integer> agument.
	N.B. Subclasses must override to preserve additional instance variables."

	"Note: This message differs from #copyEmpty: in two ways:
	1) an instance of the receivers #copyClass, rather than exact class (although this is usually the same) is answered; and
	2) the answer doesn't just have sufficient capacity for anInteger elements, but actually has that many nil or zero elements."

	^self copyingClass ofSize: anInteger!

copyReplaceAll: oldSequencedReadableCollection with: newSequencedReadableCollection
	"Answer a new <sequencedReadableCollection> which is a copy of the receiver but in which all occurrences of an old element sequence have been replaced by a new element sequence."

	| target matchSize replaceSize index sourcePos targetPos indices occurrences |
	(index := self indexOfSubCollection: oldSequencedReadableCollection startingAt: 1) == 0
		ifTrue: [^self mutableCopy].
	matchSize := oldSequencedReadableCollection size.
	indices := OrderedCollection new: 5.
	
	[indices addLast: index.
	(index := self indexOfSubCollection: oldSequencedReadableCollection startingAt: index + matchSize)
		== 0]
			whileFalse.
	replaceSize := newSequencedReadableCollection size.
	occurrences := indices size.
	target := self copyLikeOfSize: self size + ((replaceSize - matchSize) * occurrences).
	sourcePos := 1.
	targetPos := 1.
	1 to: occurrences
		do: 
			[:i |
			| next |
			index := indices at: i.
			next := targetPos + index - sourcePos.
			"Copy the elements before the match."
			target
				replaceFrom: targetPos
				to: next - 1
				with: self
				startingAt: sourcePos.
			sourcePos := index + matchSize.
			"Copy the replacement collection."
			targetPos := next + replaceSize.
			target
				replaceFrom: next
				to: targetPos - 1
				with: newSequencedReadableCollection
				startingAt: 1].

	"Copy any remaining elements"
	target
		replaceFrom: targetPos
		to: target size
		with: self
		startingAt: sourcePos.
	^target!

copyReplaceFrom: start to: stop with: replacementElements
	"Answer a new <sequencedReadableCollection> which is a copy of the receiver
	but in which all elements of the receiver between the <integer> indices
	start and stop (inclusive) have been replaced by the elements of the
	<sequencedReadableCollection> replacementElements. The latter need not 
	be the same size as the range of elements being replaced.

	This message can be used to insert, append, or replace, so the rules are quite complicated!!
		If stop is less than start, then replacementElements is inserted in the receiver:
		If start = 1, then prepend
		If start = size+1 then append
		stop must = start-1
		Else treat as replacement"

	| newSize repSize |
	repSize := replacementElements size.
	newSize := self size + repSize - (stop - start + 1).
	^(self copyLikeOfSize: newSize)
		replaceFrom: 1
			to: start - 1
			with: self
			startingAt: 1;
		replaceFrom: start
			to: start + repSize - 1
			with: replacementElements
			startingAt: 1;
		replaceFrom: start + repSize
			to: newSize
			with: self
			startingAt: stop + 1!

copyReplaceFrom: start to: stop withObject: replacementElement
	"Answer a new <sequencedReadableCollection> which is a copy of 
	the receiver, but with the elements between the <integer> indices start
	to stop (inclusive) replaced with the <Object> replacementElement.

	This message can be used to insert, append, or replace:
	1) stop = start - 1, and start <= receiver size. This is the insert operation:
	The Replacement element is inserted between the elements at stop and 
	start. No elements are actually replaced.
	2) stop = receiver size, and start = stop + 1. This is the append operation:
	replacementElement is appended to the new collection.
	3) Otherwise the operation is a replacement and each of the elements
	in the specified range is replaced in the copy with replacementElement."

	| answer size |
	size := self size.
	(start < 1 or: [start > (size + 1)]) 
		ifTrue: [^self errorSubscriptBounds: start].
	(stop > size or: [stop < (start - 1)]) 
		ifTrue: [^self errorSubscriptBounds: stop].
	(stop = (start - 1) and: [start <= size]) 
		ifTrue: 
			["Insert"

			^(self copyLikeOfSize: size + 1)
				replaceFrom: 1
					to: stop
					with: self
					startingAt: 1;
				at: start put: replacementElement;
				replaceFrom: start + 1
					to: size + 1
					with: self
					startingAt: start;
				yourself].
	(stop = size and: [start = (stop + 1)]) 
		ifTrue: 
			["Append"

			^self copyWith: replacementElement].

	"Replace"
	answer := self copyLikeOfSize: size.
	answer 
		replaceFrom: 1
		to: start - 1
		with: self
		startingAt: 1.
	start to: stop do: [:i | answer at: i put: replacementElement].
	answer 
		replaceFrom: stop + 1
		to: size
		with: self
		startingAt: stop + 1.
	^answer!

copyReplacing: targetElement withObject: replacementElement
	"Answer a new <sequencedReadableCollection> which is a copy 
	of the receiver, but in which any occurrences of the <Object> targetElement
	are replaced with the <Object> replacementElement."

	^self collect: [:each | each = targetElement 
		ifTrue: [replacementElement] 
		ifFalse: [each]].!

copyWith: newElement
	"Answer a <sequencedReadableCollection> which is a copy of 
	the receiver that has newElement concatenated to its end."

	| size |
	size := self size.
	^(self copyLikeOfSize: size + 1)
		at: size + 1 put: newElement;
		replaceFrom: 1
			to: size
			with: self
			startingAt: 1!

copyWith: anObject atIndex: anInteger
	"Answer a <SequenceableCollection> which is a copy of the receiver that has anObject inserted at the index, anInteger."

	| size |
	size := self size + 1.
	^(self copyLikeOfSize: size)
		replaceFrom: 1
			to: anInteger - 1
			with: self
			startingAt: 1;
		at: anInteger put: anObject;
		replaceFrom: anInteger + 1
			to: size
			with: self
			startingAt: anInteger;
		yourself!

copyWithout: oldElement
	"Answer a <sequencedReadableCollection> which is a copy of the receiver, but in
	which all occurrences of the <Object> oldElement have been removed."

	| aStream |
	aStream := (self copyLikeOfSize: self copySize) writeStream.
	self 
		do: [:element | element = oldElement ifFalse: [aStream nextPut: element]].
	^aStream contents!

copyWithoutAll: oldElements
	"Answer a <sequencedReadableCollection> which is a copy of the receiver, but in
	which all occurrences of the elements of the <Collection> oldElements have been removed."

	| aStream |
	aStream := (self copyLikeOfSize: self copySize) writeStream.
	self 
		do: [:element | (oldElements includes: element) ifFalse: [aStream nextPut: element]].
	^aStream contents!

copyWithoutIndex: anInteger
	"Answer a <SequenceableCollection> which is a copy of the receiver but without the element with the specified index."

	| size |
	size := self size - 1.
	^(self copyLikeOfSize: size)
		replaceFrom: 1
			to: anInteger - 1
			with: self
			startingAt: 1;
		replaceFrom: anInteger
			to: size
			with: self
			startingAt: anInteger + 1;
		yourself!

decodeAt: anInteger
	"Private - Answer the encoded object beginning at the specified position in the receiver."

	^self at: anInteger!

decodeFrom: aReadStream upTo: anObject
	"Private - Answer the future sequence values of the <ReadStream>, aReadStream, up to but not including, the <Object>, anObject.
	The stream is left positioned after anObject. If there are no occurrences of anObject in the future sequence values of the
	stream, then the remainder of the future sequence is answered and the stream is left at end."

	^aReadStream basicUpTo: anObject!

decodeNextAvailable: anInteger from: aReadStream
	"Private - Answer the next anInteger future sequence values of the <ReadStream>, aReadStream, or as
	many as are available before the end of stream."

	^aReadStream basicNextAvailable: anInteger!

decodeNextFrom: aReadStream
	"Private - Answer the next <Object> in the receiver's encoding from the <ReadStream> argument ."

	^self at: aReadStream advancePosition!

do: operation 
	"Evaluate the <monadicValuable> argument, operation, for each of the receiver's elements.
	Answers the receiver. The elements are enumerated in index order."

	"Implementation Note: Implemented in terms of #keysAndValuesDo: to reduce the burden of
	subclassing SequenceableCollection. Where performance is an issue subclasses may want to
	override."

	self keysAndValuesDo: [:i :elem | operation value: elem]!

emitEncodingMarkerOn: aPositionableStream
	"Private - Emit any encoding marker used for the stream encoding this collection represents onto the
	<PositionableStream> argument, which is assumed to be at the start of its sequence. This
	typically only relevant to string encodings, so there is nothing to do by default."

	!

encodedAt: anInteger put: anObject
	"Private - Encoded the specified object beginning at the specified position in the receiver. Answer
	the <integer> index of the last element updated."

	self at: anInteger put: anObject.
	^anInteger!

encodedSizeOf: anObject
	"Private - Answer the number of basic slots occupied by the argument when encoded in the receiver's encoding."

	^1!

encodeOn: aWriteStream next: sizeInteger putAll: aSequenceableCollection startingAt: startInteger
	^aWriteStream
		basicNext: sizeInteger
		putAll: aSequenceableCollection
		startingAt: startInteger!

encodeOn: aWriteStream nextPutAll: aSequenceableCollection
	^aWriteStream basicNextPutAll: aSequenceableCollection!

encodeOn: aPuttableStream put: anObject
	^aPuttableStream basicNextPut: anObject!

encoding
	^self class encoding!

endsWith: aCollection
	"Answer whether the receiver ends with the sequence of objects in the <Collection> argument"

	| i |
	(i := self size - aCollection size + 1) < 1 ifTrue: [^false].
	aCollection do: 
			[:each |
			(self at: i) = each ifFalse: [^false].
			i := i + 1].
	^true!

errorCollectionsOfDifferentSizes
	^self error: 'collections are of different sizes'!

errorFirstObject: target
	"Private - Report an error to the effect that an attempt was made to access the object
	before the argument, target, where the latter is the last element of the receiver."

	^self error: ('<1p> is my first object' expandMacrosWith: target)!

errorLastObject: target
	"Private - Report an error to the effect that an attempt was made to access the object
	after the argument, target, where the latter is the last element of the receiver."

	^self error: ('<1p> is my last object' expandMacrosWith: target)!

expandMacrosIn: aString
	"Private - Expand aString with the collection of replaceable arguments represented by the receiver."

	^aString expandMacrosWithArguments: self!

fifth
	"Answer an <Object> which is the fifth element of the receiver. 
	Raise an exception if the element does not exist."

	^self at: 5!

findFirst: discriminator
	"Answer the <integer> index of the first element of the receiver for which the 
	<monadicValuable> argument, discriminator, evaluates to true. If there are 
	no such elements, answer 0.
	Implementation Note: We use #keysAndValuesDo: because subclass' implementations of
	#at: may be quite slow (e.g. LinkedList)."

	self keysAndValuesDo: [:i :elem | (discriminator value: elem) ifTrue: [^i]].
	^0!

findLast: discriminator
	"Answer the <integer> index of the last element of the receiver for which the 
	<monadicValuable> argument, discriminator, evaluates to true. If there are 
	If there are no such elements, answer 0."

	self size to: 1 by: -1 do: [:i | (discriminator value: (self at: i)) ifTrue: [^i]].
	^0!

first
	"Answer an <Object> which is the first element of the receiver. 
	Raise an exception if the receiver contains no elements."

	^self at: 1!

first: anInteger
	"Answer a copy of the receiver comprising the leftmost anInteger elements."

	^self copyFrom: 1 to: anInteger!

fourth
	"Answer an <Object> which is the fourth element of the receiver. 
	Raise an exception if the element does not exist."

	^self at: 4!

from: anInteger do: operation 
	"Evaluate the <monadicValuable>, operation, for each element of the receiver from start,
	inclusive. <BoundsError> will be raised if either start or stop is out of bounds."

	self from: anInteger keysAndValuesDo: [:i :each | operation value: each]!

from: anInteger keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver starting with
	the element at the specified <integer> index. A <BoundsError> will be raised if either the
	starting index is out of bounds."

	self 
		from: anInteger
		to: self size
		keysAndValuesDo: operation!

from: startInteger to: stopInteger do: operation 
	"Evaluate the <monadicValuable>, operation, for each element of the receiver in the
	specified (inclusive) range. A <BoundsError> will be raised if either start or stop index is
	out of bounds."

	"Implementation Note: Implemented in terms of #from:to:keysAndValuesDo: to reduce the burden
	of subclassing SequenceableCollection."

	self 
		from: startInteger
		to: stopInteger
		keysAndValuesDo: [:i :each | operation value: each]!

from: startInteger to: stopInteger keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the <integer> indices, start and stop, inclusive with the element and its
	index as respectively the second and first arguments."

	"Implementation Note: Do the bounds check up front to avoid the need to check
	on each access."

	startInteger < 1 ifTrue: [self errorSubscriptBounds: startInteger].
	stopInteger > self size ifTrue: [self errorSubscriptBounds: stopInteger].
	self 
		uncheckedFrom: startInteger
		to: stopInteger
		keysAndValuesDo: operation!

from: startInteger to: stopInteger put: anObject
	"Replace the elements of the receiver between the <integer> indices, startInteger and stopInteger, inclusive, with the <Object>, anObject."

	| size written |
	size := stopInteger - startInteger + 1.
	written := size min: 8.
	startInteger to: startInteger + written - 1 do: [:i | self at: i put: anObject].
	[written < size] whileTrue: 
			[| thisWrite remaining |
			remaining := size - written.
			thisWrite := written < remaining ifTrue: [written] ifFalse: [remaining].
			self
				replaceFrom: startInteger + written
				to: startInteger + written + thisWrite - 1
				with: self
				startingAt: startInteger.
			written := written + thisWrite].
	^anObject!

grow
	"Private - Increase the capacity of the receiver. Answer the receiver."

	self resize: self size + self growSize!

hash
	"Answer the <integer> hash value for the receiver.
	Implementation Note: This is not a terribly good hash function (in particular it
	exhibits very poor temporal stability), but it is quick, and alternatives involve expensive 
	iteration through the receiver's elements."

	| size |
	(size := self size) == 0 ifTrue: [^17171].
	^size + (self at: 1) hash + (self at: size) hash!

identityIndexOf: anElement
	"Answer the index of the first occurrence of the object which is the argument 
	anElement, within the receiver. If the receiver does not contain anElement, 
	answer 0. This method is the same as #indexOf:, but uses #== for comparison."

	^self nextIdentityIndexOf: anElement from: 1 to: self size!

identityIndexOf: anElement ifAbsent: exceptionBlock
	"Answer the index of the first occurrence of the object which is the argument 
	anElement, within the receiver. If the receiver does not contain anElement, answer 
	the result of evaluating the argument, exceptionBlock. This method is the same
	as #indexOf:ifAbsent:, but uses #== for comparison."

	| index |
	index := self identityIndexOf: anElement.
	^index == 0
		ifTrue: [exceptionBlock value]
		ifFalse: [index]!

includesAnyOf: aCollection 
	"Answer whether the receiver includes any of the elements in the <collection> argument."

	^(self indexOfAnyOf: aCollection startingAt: 1) ~~ 0!

includesKey: anInteger
	^anInteger between: 1 and: self size!

indexOf: target
	"Answer the <integer> index of the first element of the receiver which is 
	equal to the <Object> argument, target, within the receiver. If the receiver 
	does not contain any elements equal to target, answer 0."

	^self nextIndexOf: target from: 1 to: self size!

indexOf: target ifAbsent: exceptionHandler
	"Answer the <integer> index of the first element of the receiver which is 
	equal to the <Object> argument, target, within the receiver. If the receiver 
	does not contain any elements equal to target, answer the result of evaluating 
	the <niladicValuable>, exceptionHandler."

	| index |
	index := self indexOf: target.
	^index == 0
		ifTrue: [exceptionHandler value]
		ifFalse: [index]!

indexOf: target startingAt: start
	"Answer the <integer> index of the first element of the receiver which is 
	equal to the <Object> argument, target, within the receiver. If the receiver 
	does not contain any elements equal to target, answer 0."

	^self nextIndexOf: target from: start to: self size!

indexOfAnyOf: aCollection startingAt: anInteger 
	"Answer the one-based integer index of the first encountered element of the receiver which 
	is equal to one of the elements of the <Collection> argument, starting from the specified
	one-based <integer> index. If no occurrences are found, then answer 0."

	self from: anInteger
		keysAndValuesDo: [:i :elem | (aCollection includes: elem) ifTrue: [^i]].
	^0!

indexOfSubCollection: aSequenceableCollection
	"Answer the index of the first occurrence within the receiver of aSequenceableCollection,
	starting at index anInteger. If there are no such occurrences, answer 0."

	^self indexOfSubCollection: aSequenceableCollection startingAt: 1!

indexOfSubCollection: aSequencedReadableCollection startingAt: startInteger
	"Answer the <integer> index of the next occurrence within the receiver of the <sequencedReadableCollection> sub-sequence, starting at the specified <integer> index. If there are no such occurrences (or the search sequence is empty), answer 0."

	^self basicIndexOfSubCollection: aSequencedReadableCollection startingAt: startInteger!

indexOfSubCollection: targetSequence startingAt: start ifAbsent: exceptionHandler
	"Answer the <integer> index of the next occurrence within the 
	receiver of the <sequencedReadableCollection> targetSequence,
	starting at the <integer> index start.
	If no such match is found, answer the result of evaluating the 
	<niladicValuable>, exceptionHandler."

	| index |
	index := self indexOfSubCollection: targetSequence startingAt: start.
	^index == 0
		ifTrue: [exceptionHandler value]
		ifFalse: [index]!

keyAtEqualValue: value ifAbsent: exceptionHandler
	"Answer the <integer> key of the <object> argument, value. 
	If there is no such element, answer the result of evaluating the 
	niladic valuable, exceptionHandler.
	N.B. Equality is used for comparison of the values (this increases the chances of 
	returning any duplicates the collection might contain)."

	^self indexOf: value ifAbsent: exceptionHandler!

keyAtValue: value 
	"Answer the <integer> key of the <Object> argument, value. 
	If there is no such value, send #errorNotFound: to the receiver with 
	value as its argument.
	N.B. Since elements are not necessarily unique, answer the index of the 
	first one encountered in a serial search."

	| index |
	index := self keyAtValue: value ifAbsent: [AbsentCookie].
	^index == AbsentCookie ifTrue: [self errorValueNotFound: value] ifFalse: [index]!

keyAtValue: value ifAbsent: operation
	"Answer the <integer> key of the <Object> argument, value. 
	If there is no such value, answer the result of evaluating the 
	<niladicValuable>, operation. Identity is used for comparison of the values."

	^self identityIndexOf: value ifAbsent: operation!

keys
	"Answer a <collection> containing the receiver's keys."

	^1 to: self size!

keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	with the <integer> index of that element and the element itself as the arguments."

	"Implementation Note: Subclasses should override #from:to:keysAndValuesDo: rather 
	than this method, unless they have a slow implementation of #size, or one that 
	relies on #countElements (since that uses #do: to calculate the size and may
	therefore go infinitely recursive)."

	self 
		uncheckedFrom: 1
		to: self size
		keysAndValuesDo: operation!

last
	"Answer the <Object> which is the last element of the receiver. 
	Raise an exception if the receiver contains no elements."

	^self at: self size!

last: anInteger
	"Answer a copy of the receiver comprising the rightmost anInteger elements."

	| size |
	size := self size.
	^self copyFrom: (size + 1 - anInteger) to: size!

lastIndexOf: target
	"Answer the <integer> index of the last element of the receiver which is 
	equal to the <Object> argument, target, within the receiver. If the receiver 
	does not contain any elements equal to target, answer 0."

	^self prevIndexOf: target from: self size to: 1!

lastIndexOf: anObject ifAbsent: exceptionHandler 
	"Answer the <integer> index of the last element of the receiver which is 
	equal to the <Object> first argument within the receiver. If the receiver 
	does not contain any elements equal to target, answer the result of 
	evaluating the <niladicValuable>, exceptionHandler."

	"Included for compatibility with Visual Works"

	| index |
	^(index := self lastIndexOf: anObject) == 0 
		ifTrue: [exceptionHandler value]
		ifFalse: [index]!

lookup: keyInteger
	"Answer the value named by the <Integer> argument, keyInteger, or nil if there is no such key in the receiver.
	Clearly if the receiver can contain nil values then it will not be possible to distinguish between the absence
	of the key and the key being associated with a nil value. However, this method expresses the
	very common pattern of passing an empty block as absent handler to #at:ifAbsent:"

	^self at: keyInteger ifAbsent: []!

maxEncoding
	^1!

mutableCopy
	"Answer a <sequencedReadableCollection> like the receiver, but which is a mutable copy with the same elements."

	^self copy!

nextIdentityIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver's indexable
	variables between startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Subclasses may be able to provide a more efficient implementation using 
	#primIdentityIndexOf:from:to:."

	self from: start to: stop keysAndValuesDo: [:i :elem | elem == anElement ifTrue: [^i]].
	^0!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0."

	self from: start to: stop keysAndValuesDo: [:i :elem | elem = anElement ifTrue: [^i]].
	^0!

occurrencesOfSubCollection: aSubCollection
	"Private - Answer the number of occurrences of aSubCollection in the receiver."

	| index count size |
	index := 1.
	count := 0.
	size := aSubCollection size.
	[(index := self indexOfSubCollection: aSubCollection startingAt: index) > 0] whileTrue: [ 
		count := count + 1.
		index := index + size].
	^count!

pairsDo: aDyadicValuable 
	1 to: self size by: 2 do: [ :i | aDyadicValuable value: (self at: i) value: (self at: i + 1) ]!

prevIndexOf: anElement from: start to: stop
	"Answer the index of the occurrence of anElement in the receiver between previous
	to start, but after stop. If there are no such occurrences, answer 0."

	start to: stop by: -1 do: [ :i | (self at: i) = anElement ifTrue: [ ^i ]].
	^0!

prevIndexOfSubCollection: aSequenceableCollection startingAt: anInteger 
	"Answer the index of the previous occurrence within the receiver between startIndex and stopIndex
	of aSequenceableCollection, before the element with index, anInteger. If there are no previous
	occurrences of aSequenceableCollection, answer 0."

	| subSize firstElement |
	(subSize := aSequenceableCollection size) == 0 ifTrue: [^0].
	firstElement := aSequenceableCollection at: 1.
	subSize == 1 
		ifTrue: 
			[^self 
				prevIndexOf: firstElement
				from: anInteger
				to: 0].
	anInteger to: 1
		by: -1
		do: 
			[:i | 
			(self at: i) = firstElement 
				ifTrue: 
					[| j |
					j := 2.
					[(self at: i + j - 1) = (aSequenceableCollection at: j)] whileTrue: 
							[j = subSize ifTrue: [^i].
							j := j + 1]]].
	^0!

prevIndexOfSubCollection: aSequenceableCollection startingAt: anInteger ifAbsent: exceptionBlock
	"Answer the index of the previous occurrence within the receiver between startIndex and stopIndex
	of aSequenceableCollection, before the element with index, anInteger. If there are no previous
	occurrences of aSequenceableCollection, answer the result of evaluating exceptionBlock."

	| index |
	index := self prevIndexOfSubCollection: aSequenceableCollection startingAt: anInteger.
	^index == 0
		ifTrue: [exceptionBlock value]
		ifFalse: [index]
!

randomizeUsing: aRandom 
	| order |
	3 timesRepeat: [aRandom next].
	order := self collect: [:each | aRandom next -> each].
	order := order asSortedCollection: [:a :b | a key <= b key].
	^order collect: [:each | each value]!

readStream
	"Answer a ReadStream on the receiver."

	^ReadStream on: self!

remove: oldElement ifAbsent: exceptionHandler
	"Remove the <Object> oldElement from the receiver's elements.
	Raise an exception, as SequenceableCollections are not (in general) 
	contractible."

	^self shouldNotImplement!

replaceAll: oldObject with: newObject
	"Replace all occurences of oldObject with newObject"

	| index last |
	last := self size.
	index := self
				nextIndexOf: oldObject
				from: 1
				to: last.
	[index == 0] whileFalse: 
			[self at: index put: newObject.
			index := self
						nextIndexOf: oldObject
						from: index + 1
						to: last]!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart
	"Private - Standard method for transfering bytes from one sequence of bytes (or characters)
	to another, normally double dispatched from #replaceFrom:to:with:startingAt:
	by byte subclasses. Implementing this message at this level allows for the concatenation
	of character arrays to strings, for example.
	Implementation Note: It is assumed that the receiver and the argument,
	cannot be the same object, which will be the case for correctly defined subclasses
	which must override this implementation.."

	| fromOffset |
	fromOffset := fromStart - start.
	start to: stop do: [:i | aByteObject basicAt: i put: (self at: i + fromOffset) asInteger].
	^aByteObject!

replaceElementsOf: anIndexableObject from: startInteger to: stopInteger startingAt: startAtInteger
	"Private - Replace the indexable instance variables of the variable pointer object,
	anIndexableObject, between startInteger and stopInteger inclusive with elements of the
	receiver starting from startAtInteger. Answers anIndexableObject."

	| offset |
	offset := startAtInteger - startInteger.
	(anIndexableObject == self and: [startAtInteger < startInteger])
		ifTrue: 
			[stopInteger to: startInteger
				by: -1
				do: [:i | anIndexableObject basicAt: i put: (self at: offset + i)]]
		ifFalse: 
			[startInteger to: stopInteger do: [:i | anIndexableObject basicAt: i put: (self at: offset + i)]].
	^anIndexableObject!

replaceFrom: start to: stop with: replacementElements
	"Destructively replace the elements of the receiver between the <integer> arguments
	start and stop with the <Object> elements of the <sequencedReadableCollection> argument, 
	replacementElements. Answer the receiver. Raise an Exception if  replacementElements does 
	not contain the number of elements required to exactly fill the replacement interval in the receiver."

	replacementElements size = (stop - start + 1)
		ifFalse: [^self error: 'size of replacement incorrect'].
	^self replaceFrom: start to: stop with: replacementElements startingAt: 1!

replaceFrom: startInteger to: stopInteger with: aSequencedReadableCollection startingAt: startAtInteger 
	"Destructively replace the elements of the receiver between the <integer> arguments
	startInteger and stopInteger inclusive with the <Object> elements of the
	<sequencedReadableCollection> argument, aSequencedReadableCollection, beginning with its
	element with <integer> index startAtInteger. Answer the receiver. Overlapping moves are
	correctly handled. Unlike #replaceFrom:to:with:, the size of aSequenceableCollection is not
	checked directly (X3J20 does not specify that this should be an error), but an error will be
	raised when an attempt is made to access an out-of-bounds element in replacementElements. It
	is not an error to specify an empty replacement interval, even if startInteger, stopInteger,
	and/or startAtInteger are out-of-bounds (this is compatible with the major
	implementations)."

	"Implementation Note: The performance of this method is very important to overall 
	system performance. This implementation is mostly inlined by the compiler."

	| offset |
	offset := startAtInteger - startInteger.
	"Perform overlapping moves backwards, otherwise forwards"
	(self == aSequencedReadableCollection and: [startAtInteger < startInteger]) 
		ifTrue: 
			[stopInteger to: startInteger
				by: -1
				do: [:i | self at: i put: (aSequencedReadableCollection at: offset + i)]]
		ifFalse: 
			[startInteger to: stopInteger
				do: [:i | self at: i put: (aSequencedReadableCollection at: offset + i)]]!

replaceFrom: start to: stop withObject: replacementElement
	"Destructively replace the elements of the receiver between the
	<integer> indices start and stop with the <Object> argument,
	replacementElement. Answer replacementElement."

	start to: stop do: [:i | self at: i put: replacementElement].
	^replacementElement!

resize: anInteger
	"Private - Resize the receiver to accomodate anInteger elements.
	Answer the receiver."

	self isImmutable ifTrue: [Processor constWriteSignal signalWith: self].
	(self copyEmpty: anInteger)
		replaceFrom: 1 to: self size with: self startingAt: 1;
		become: self!

reverse
	"Answer a new <sequencedReadableCollection> which contains the same elements as the receiver, but in reverse order."

	^self reversedFrom: 1 to: self size!

reversedFrom: startInteger to: stopInteger
	"Answer a new <sequencedReadableCollection> like the receiver containing those elements of the receiver between the <integer> indices startInteger and stopInteger, inclusive, but in reverse order."

	| answer offset len |
	len := stopInteger - startInteger + 1.
	answer := self copyLikeOfSize: len.
	offset := len + startInteger.
	startInteger to: stopInteger do: [:i | answer at: offset - i put: (self at: i)].
	^answer!

reverseDo: operation
	"Evaluate the <monadicValuable> argument, operation, against each 
	element of the receiver in reverse order, from end to start."

	self size to: 1 by: -1 do: [:i | operation value: (self at: i)]!

runsAndValuesDo: aDyadicValuable 
	"Evaluate the <dyadicValuable> argument passing it the length of each run of equal values in
	the receiver, and the corresponding value. This is obviously most efficient with a <RunArray>."

	| runLength current |
	runLength := 0.
	self do: 
			[:each | 
			runLength == 0 
				ifTrue: 
					[runLength := 1.
					current := each]
				ifFalse: 
					[each = current 
						ifTrue: [runLength := runLength + 1]
						ifFalse: 
							[aDyadicValuable value: runLength value: current.
							current := each.
							runLength := 1]]].
	runLength > 0 ifTrue: [aDyadicValuable value: runLength value: current]!

second
	"Answer an <Object> which is the second element of the receiver. 
	Raise an exception if the element does not exist."

	^self at: 2!

select: discriminator
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's elements.
	Answer a new <collection> like the receiver containing only those elements for which 
	the discriminator evaluates to true."

	| aStream |
	aStream := self copyingClass writeStream: self copySize.
	self keysAndValuesDo: [:i :elem | (discriminator value: elem) ifTrue: [aStream nextPut: elem]].
	^aStream contents!

sixth
	"Answer an <Object> which is the sixth element of the receiver. 
	Raise an exception if the element does not exist."

	^self at: 6!

skipEncodingMarkerFrom: aPositionableStream
	"Private - Skip over any encoding marker used for the stream encoding this collection represents on
	the <PositionableStream> argument, which is assumed to be at the start of its sequence. This
	typically only relevant to string encodings, so there is nothing to do by default."

	!

skipOver: stream
	"Private - Answer whether the receiver matches the contents of <sequencedStream> stream
	taking account of any case differences. Answers true if a complete match is
	found, false otherwise. If a match is found then the stream is left pointing to the next character
	following the match. If not, the stream position is left unchanged."

	| originalPosition |
	originalPosition := stream position.
	self do: [ :each | 
		(stream atEnd or: [stream next~=each]) ifTrue: [ 
			stream position: originalPosition. ^false]].
	^true
!

swap: integerIndex1 with: integerIndex2
	"Swap the elements of the receiver at the specified indices"

	| element |
	element := self at: integerIndex1.
	self at: integerIndex1 put: (self at: integerIndex2).
	self at: integerIndex2 put: element!

third
	"Answer an <Object> which is the third element of the receiver. 
	Raise an exception if the element does not exist."

	^self at: 3!

uncheckedFrom: startInteger to: stopInteger keysAndValuesDo: aDyadicValuable 
	"Private - Evaluate the <dyadicValuable> argument for each element of the receiver in the
	specified inclusive range, with the element and its index as respectively the second and
	first arguments. No bounds checks need be performed since the caller has established that
	the start and stop indices are in bounds."

	"Implementation Note: Subclasses should override this method in order to replace all #do:
	family enumerators (#do:, #keysAndValuesDo:, #from:to:do:, and, of course,
	#from:to:keysAndValuesDo:). Subclasses may also want to override this if they have a slow
	implementation of the random accessor method #at:, but can be more efficiently accessed
	serially (e.g. a singly Linked List), or if they have to calculate their size using
	#countElements (which would cause an infinite recursion as it uses #do:, which uses #size,
	...)."

	startInteger to: stopInteger do: [:i | aDyadicValuable value: i value: (self at: i)]!

upTo: target
	"Answer a new <sequencedReadableCollection> containing the elements of 
	the receiver up to the specified target, or if the target is not present in the receiver, 
	the rest of the receiver.

	Implementation Note: This is a convenient shortcut method for:
		self readStream upTo: target
	And is usually faster since the Streams implementation is generic."

	^self copyFrom: 1 to: (self indexOf: target ifAbsent: [self size+1])-1!

with: otherCollection do: operation
	"Evaluate the <dyadicValuable> argument, operation, with each of 
	the receiver's elements along with the corresponding element from the 
	<sequencedReadableCollection> argument, otherCollection. 
	Raise an exception if otherCollection is not the same size as the receiver."

	self size = otherCollection size ifFalse: [^self errorCollectionsOfDifferentSizes].
	self keysAndValuesDo: [:i :elem | operation value: elem value: (otherCollection at: i)]!

writeStream
	"Answer a WriteStream on the receiver."

	^WriteStream on: self! !
!Core.SequenceableCollection categoriesFor: #,!copying!public! !
!Core.SequenceableCollection categoriesFor: #_sameAsString:!comparing!private! !
!Core.SequenceableCollection categoriesFor: #=!comparing!public! !
!Core.SequenceableCollection categoriesFor: #after:!public!searching! !
!Core.SequenceableCollection categoriesFor: #after:ifAbsent:!public!searching! !
!Core.SequenceableCollection categoriesFor: #allButFirst!copying!public! !
!Core.SequenceableCollection categoriesFor: #allButFirst:!copying!public! !
!Core.SequenceableCollection categoriesFor: #allButLast!copying!public! !
!Core.SequenceableCollection categoriesFor: #allButLast:!copying!public! !
!Core.SequenceableCollection categoriesFor: #anyOne!accessing!public! !
!Core.SequenceableCollection categoriesFor: #appendToStream:!double dispatch!private! !
!Core.SequenceableCollection categoriesFor: #approxSize!accessing!private! !
!Core.SequenceableCollection categoriesFor: #asArray!converting!public! !
!Core.SequenceableCollection categoriesFor: #asRunArray!converting!public! !
!Core.SequenceableCollection categoriesFor: #associations!accessing!public! !
!Core.SequenceableCollection categoriesFor: #asString!public! !
!Core.SequenceableCollection categoriesFor: #at:!accessing!public!testing! !
!Core.SequenceableCollection categoriesFor: #at:ifAbsent:!accessing!public! !
!Core.SequenceableCollection categoriesFor: #at:ifPresent:!accessing!public! !
!Core.SequenceableCollection categoriesFor: #at:put:!accessing!public! !
!Core.SequenceableCollection categoriesFor: #atAll:put:!accessing!public! !
!Core.SequenceableCollection categoriesFor: #atAllPut:!accessing!public! !
!Core.SequenceableCollection categoriesFor: #basicBeginsWith:!comparing!public! !
!Core.SequenceableCollection categoriesFor: #basicIndexOfSubCollection:startingAt:!private!searching! !
!Core.SequenceableCollection categoriesFor: #before:!public!searching! !
!Core.SequenceableCollection categoriesFor: #before:ifAbsent:!public!searching! !
!Core.SequenceableCollection categoriesFor: #beginsWith:!comparing!public! !
!Core.SequenceableCollection categoriesFor: #binarySearchFor:using:!public!searching! !
!Core.SequenceableCollection categoriesFor: #collect:!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #copyFrom:!copying!public! !
!Core.SequenceableCollection categoriesFor: #copyFrom:to:!copying!public! !
!Core.SequenceableCollection categoriesFor: #copyLikeOfSize:!copying!private! !
!Core.SequenceableCollection categoriesFor: #copyReplaceAll:with:!copying!public! !
!Core.SequenceableCollection categoriesFor: #copyReplaceFrom:to:with:!copying!public! !
!Core.SequenceableCollection categoriesFor: #copyReplaceFrom:to:withObject:!copying!public! !
!Core.SequenceableCollection categoriesFor: #copyReplacing:withObject:!copying!public! !
!Core.SequenceableCollection categoriesFor: #copyWith:!copying!public! !
!Core.SequenceableCollection categoriesFor: #copyWith:atIndex:!copying!public! !
!Core.SequenceableCollection categoriesFor: #copyWithout:!copying!public! !
!Core.SequenceableCollection categoriesFor: #copyWithoutAll:!copying!public! !
!Core.SequenceableCollection categoriesFor: #copyWithoutIndex:!copying!public! !
!Core.SequenceableCollection categoriesFor: #decodeAt:!encode/decode!private! !
!Core.SequenceableCollection categoriesFor: #decodeFrom:upTo:!encode/decode!private! !
!Core.SequenceableCollection categoriesFor: #decodeNextAvailable:from:!encode/decode!private! !
!Core.SequenceableCollection categoriesFor: #decodeNextFrom:!encode/decode!private! !
!Core.SequenceableCollection categoriesFor: #do:!debugger-step through!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #emitEncodingMarkerOn:!encode/decode!private! !
!Core.SequenceableCollection categoriesFor: #encodedAt:put:!accessing!encode/decode!private! !
!Core.SequenceableCollection categoriesFor: #encodedSizeOf:!encode/decode!private! !
!Core.SequenceableCollection categoriesFor: #encodeOn:next:putAll:startingAt:!encode/decode!private! !
!Core.SequenceableCollection categoriesFor: #encodeOn:nextPutAll:!encode/decode!private! !
!Core.SequenceableCollection categoriesFor: #encodeOn:put:!encode/decode!private! !
!Core.SequenceableCollection categoriesFor: #encoding!constants!public! !
!Core.SequenceableCollection categoriesFor: #endsWith:!comparing!public! !
!Core.SequenceableCollection categoriesFor: #errorCollectionsOfDifferentSizes!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #errorFirstObject:!exceptions!private! !
!Core.SequenceableCollection categoriesFor: #errorLastObject:!exceptions!private! !
!Core.SequenceableCollection categoriesFor: #expandMacrosIn:!double dispatch!private! !
!Core.SequenceableCollection categoriesFor: #fifth!accessing!public! !
!Core.SequenceableCollection categoriesFor: #findFirst:!public!searching! !
!Core.SequenceableCollection categoriesFor: #findLast:!public!searching! !
!Core.SequenceableCollection categoriesFor: #first!accessing!public! !
!Core.SequenceableCollection categoriesFor: #first:!copying!public! !
!Core.SequenceableCollection categoriesFor: #fourth!accessing!public! !
!Core.SequenceableCollection categoriesFor: #from:do:!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #from:keysAndValuesDo:!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #from:to:do:!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #from:to:keysAndValuesDo:!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #from:to:put:!accessing!public! !
!Core.SequenceableCollection categoriesFor: #grow!mutating!private! !
!Core.SequenceableCollection categoriesFor: #hash!comparing!public! !
!Core.SequenceableCollection categoriesFor: #identityIndexOf:!public!searching! !
!Core.SequenceableCollection categoriesFor: #identityIndexOf:ifAbsent:!public!searching! !
!Core.SequenceableCollection categoriesFor: #includesAnyOf:!public!searching! !
!Core.SequenceableCollection categoriesFor: #includesKey:!public!testing! !
!Core.SequenceableCollection categoriesFor: #indexOf:!public!searching! !
!Core.SequenceableCollection categoriesFor: #indexOf:ifAbsent:!public!searching! !
!Core.SequenceableCollection categoriesFor: #indexOf:startingAt:!public!searching! !
!Core.SequenceableCollection categoriesFor: #indexOfAnyOf:startingAt:!public!searching! !
!Core.SequenceableCollection categoriesFor: #indexOfSubCollection:!public!searching! !
!Core.SequenceableCollection categoriesFor: #indexOfSubCollection:startingAt:!public!searching! !
!Core.SequenceableCollection categoriesFor: #indexOfSubCollection:startingAt:ifAbsent:!public!searching! !
!Core.SequenceableCollection categoriesFor: #keyAtEqualValue:ifAbsent:!accessing!public! !
!Core.SequenceableCollection categoriesFor: #keyAtValue:!accessing!public! !
!Core.SequenceableCollection categoriesFor: #keyAtValue:ifAbsent:!accessing!public! !
!Core.SequenceableCollection categoriesFor: #keys!accessing!public! !
!Core.SequenceableCollection categoriesFor: #keysAndValuesDo:!debugger-step through!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #last!accessing!public! !
!Core.SequenceableCollection categoriesFor: #last:!copying!public! !
!Core.SequenceableCollection categoriesFor: #lastIndexOf:!public!searching! !
!Core.SequenceableCollection categoriesFor: #lastIndexOf:ifAbsent:!public!searching! !
!Core.SequenceableCollection categoriesFor: #lookup:!accessing!public! !
!Core.SequenceableCollection categoriesFor: #maxEncoding!constants!private! !
!Core.SequenceableCollection categoriesFor: #mutableCopy!copying!public! !
!Core.SequenceableCollection categoriesFor: #nextIdentityIndexOf:from:to:!public!searching! !
!Core.SequenceableCollection categoriesFor: #nextIndexOf:from:to:!public!searching! !
!Core.SequenceableCollection categoriesFor: #occurrencesOfSubCollection:!private!searching! !
!Core.SequenceableCollection categoriesFor: #pairsDo:!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #prevIndexOf:from:to:!public!searching! !
!Core.SequenceableCollection categoriesFor: #prevIndexOfSubCollection:startingAt:!public!searching! !
!Core.SequenceableCollection categoriesFor: #prevIndexOfSubCollection:startingAt:ifAbsent:!public!searching! !
!Core.SequenceableCollection categoriesFor: #randomizeUsing:!operations!public! !
!Core.SequenceableCollection categoriesFor: #readStream!public!streaming! !
!Core.SequenceableCollection categoriesFor: #remove:ifAbsent:!public!removing! !
!Core.SequenceableCollection categoriesFor: #replaceAll:with:!public! !
!Core.SequenceableCollection categoriesFor: #replaceBytesOf:from:to:startingAt:!double dispatch!primitives!private! !
!Core.SequenceableCollection categoriesFor: #replaceElementsOf:from:to:startingAt:!private!replacing! !
!Core.SequenceableCollection categoriesFor: #replaceFrom:to:with:!public!replacing! !
!Core.SequenceableCollection categoriesFor: #replaceFrom:to:with:startingAt:!public!replacing! !
!Core.SequenceableCollection categoriesFor: #replaceFrom:to:withObject:!public!replacing! !
!Core.SequenceableCollection categoriesFor: #resize:!mutating!private! !
!Core.SequenceableCollection categoriesFor: #reverse!copying!public! !
!Core.SequenceableCollection categoriesFor: #reversedFrom:to:!copying!public! !
!Core.SequenceableCollection categoriesFor: #reverseDo:!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #runsAndValuesDo:!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #second!accessing!public! !
!Core.SequenceableCollection categoriesFor: #select:!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #sixth!accessing!public! !
!Core.SequenceableCollection categoriesFor: #skipEncodingMarkerFrom:!encode/decode!private! !
!Core.SequenceableCollection categoriesFor: #skipOver:!private!searching! !
!Core.SequenceableCollection categoriesFor: #swap:with:!operations!public! !
!Core.SequenceableCollection categoriesFor: #third!accessing!public! !
!Core.SequenceableCollection categoriesFor: #uncheckedFrom:to:keysAndValuesDo:!debugger-step through!enumerating!private! !
!Core.SequenceableCollection categoriesFor: #upTo:!copying!public!searching! !
!Core.SequenceableCollection categoriesFor: #with:do:!enumerating!public! !
!Core.SequenceableCollection categoriesFor: #writeStream!public!streaming! !

Core.SequenceableCollection methodProtocol: #sequencedCollection attributes: #(#ansi #readOnly) selectors: #(#, #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #at:put: #atAll:put: #atAllPut: #before: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #notEmpty #occurrencesOf: #rehash #reject: #replaceFrom:to:with: #replaceFrom:to:with:startingAt: #replaceFrom:to:withObject: #reverse #reverseDo: #select: #size #with:do:)!
Core.SequenceableCollection methodProtocol: #sequencedReadableCollection attributes: #(#ansi #readOnly) selectors: #(#, #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #before: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #notEmpty #occurrencesOf: #rehash #reject: #reverse #reverseDo: #select: #size #with:do:)!

!Core.SequenceableCollection class methodsFor!

binarySearch: aSequenceableCollection for: anObject using: searchBlock 
	"Search aSequenceableCollection, which must be sorted, for anObject using a binary chop search based on the <dyadicValuable>, searchBlock. The search block needs to express the same sort order as that used to sort the collection or the result will be incorrect. If the collection is ordered in ascending order, then use #<= comparison, or #>= for descending order. If anObject is in the collection, then the answer will be the index of the last occurrence of anObject + 1. If anObject is not in the collection, then the answer will be 1. This is most useful to find an insertion point."

	| index low high |
	low := 1.
	high := aSequenceableCollection size.
	
	[index := (high + low) // 2.
	low > high] whileFalse: 
				[(searchBlock value: (aSequenceableCollection at: index) value: anObject) 
					ifTrue: [low := index + 1]
					ifFalse: [high := index - 1]].
	^low!

defaultSortAlgorithm
	"Answer an instance of the default <SortAlgorithm>."

	^DefaultSortAlgorithm current!

emitEncodingMarkerOn: aPositionableStream
	"Private - Emit any encoding marker used for the stream encoding this collection represents onto the
	<PositionableStream> argument, which is assumed to be at the start of its sequence. This
	typically only relevant to string encodings, so there is nothing to do by default."

	!

encoding
	"Answer a <Symbol> naming the encoding of instances of the receiver, which will be one of #binary, #pointers, #ansi, #utf8, #utf16le or #utf32."

	^#pointers!

new: anInteger streamContents: aMonadicValuable
	| stream |
	stream := self writeStream: anInteger.
	aMonadicValuable value: stream.
	^stream grabContents!

ofSize: anInteger
	"Private - Answer a new instance of the receiver with anInteger nil elements.
	This method is subtly different from #new: because that, as defined for 
	SequenceableCollections, answers a Collection with sufficient space for 
	anInteger elements, but which, in the case of some subclasses, may be considered 
	empty - i.e. containing no elements. If we attempt to perform a #replaceFrom:to:with:startingAt:
	on an empty SequenceableCollection, then a bounds error will result. This protocol 
	enables SequenceableCollection's implementation of copy replacement to work for most 
	subclasses."

	^self new: anInteger!

streamContents: aMonadicValuable
	^self new: 64 streamContents: aMonadicValuable!

writeStream
	"Answer a WriteStream on the a new empty instance of the receiver."

	^self new writeStream!

writeStream: anInteger
	"Answer a WriteStream on the a new instance of the receiver with
	initialize size, anInteger."

	^WriteStream on: (self new: anInteger)! !
!Core.SequenceableCollection class categoriesFor: #binarySearch:for:using:!public!searching! !
!Core.SequenceableCollection class categoriesFor: #defaultSortAlgorithm!instance creation!public! !
!Core.SequenceableCollection class categoriesFor: #emitEncodingMarkerOn:!encode/decode!private! !
!Core.SequenceableCollection class categoriesFor: #encoding!constants!public! !
!Core.SequenceableCollection class categoriesFor: #new:streamContents:!public!stream creation! !
!Core.SequenceableCollection class categoriesFor: #ofSize:!instance creation!private! !
!Core.SequenceableCollection class categoriesFor: #streamContents:!public!stream creation! !
!Core.SequenceableCollection class categoriesFor: #writeStream!instance creation!public!streaming! !
!Core.SequenceableCollection class categoriesFor: #writeStream:!instance creation!public!streaming! !

