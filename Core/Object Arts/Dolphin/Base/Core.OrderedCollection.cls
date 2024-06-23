"Filed out from Dolphin Smalltalk"!

Core.SequencedGrowableCollection
	variableSubclass: #'Core.OrderedCollection'
	instanceVariableNames: 'firstIndex lastIndex'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.OrderedCollection guid: (Core.GUID fromString: '{87b4c523-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.OrderedCollection comment: 'OrderedCollections store an ordered, contiguous sequence of elements. They are much like resizable arrays'!

!Core.OrderedCollection categoriesForClass!Collections-Sequenceable! !

!Core.OrderedCollection methodsFor!

add: anObject afterIndex: anInteger
	"Add the <Object> first argument to the receiver immediately after the element currently at the specified <integer> index. The index must be between 0 and the receiver's current size (if not raise an exception). Answer the new element."

	| basicIndex |
	basicIndex := anInteger + firstIndex.
	(basicIndex > (lastIndex + 1) or: [basicIndex < firstIndex])
		ifTrue: [^self errorSubscriptBounds: anInteger].
	lastIndex == self basicSize
		ifTrue: 
			[self makeRoomAtEndFor: 1.
			basicIndex := anInteger + firstIndex].
	"Slide the elements down the collection toward the new end to make room for the insertion. The primitive is able to handle an overlapping upwards move."
	self
		basicReplaceElementsOf: self
		from: basicIndex + 1
		to: (lastIndex := lastIndex + 1)
		startingAt: basicIndex.
	^self basicAt: basicIndex put: anObject!

addAllFirst: aCollection
	"Prepend all elements of the <collection> argument to the receiver, in the order that they appear in the argument, as determined by its implementation of #do:. Answer the new elements."

	"Implementation Note: Override for better performance by opening up a space at the front in one operation."

	| extra |
	extra := aCollection size.
	firstIndex <= extra ifTrue: [self makeRoomAtFirstFor: extra - firstIndex + 1].
	firstIndex := firstIndex - extra.
	aCollection inject: firstIndex
		into: 
			[:i :e |
			self basicAt: i put: e.
			i + 1].
	^aCollection!

addAllLast: aCollection
	"Append the elements of the <collection> argument to the receiver, in the order that they appear in that collection (as defined by its implementation of #do:). Answer the collection."

	^self basicAddAll: aCollection!

addAnsweringIndex: anObject
	"Append the argument as the last element of the receiver. Answer the index at which the object was added."

	lastIndex == self basicSize ifTrue: [self makeRoomAtEndFor: 1].
	self basicAt: (lastIndex := lastIndex + 1) put: anObject.
	^lastIndex - firstIndex + 1!

addFirst: anObject
	"Insert the argument as the first element of the receiver. Answer the argument."

	"Implementation Note: Override for performance."

	firstIndex == 1 ifTrue: [self makeRoomAtFirstFor: self growSize].
	^self basicAt: (firstIndex := firstIndex - 1) put: anObject!

addLast: anObject
	"Append the argument as the last element of the receiver. Answer the argument."

	"Implementation Note: Override for performance."

	lastIndex == self basicSize ifTrue: [self makeRoomAtEndFor: 1].
	^self basicAt: (lastIndex := lastIndex + 1) put: anObject!

allSatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for
	every element of the receiver."

	"Implementation Note: Override in order to provide an optimized implementation that requires
	neither a full block nor bounds checks."

	firstIndex to: lastIndex do: [:i | (discriminator value: (self basicAt: i)) ifFalse: [^false]].
	^true!

anySatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for
	any element of the receiver."

	"Implementation Note: Override in order to provide an optimized implementation that requires
	neither a full block nor bounds checks."

	firstIndex to: lastIndex do: [:i | (discriminator value: (self basicAt: i)) ifTrue: [^true]].
	^false!

asOrderedCollection
	"Answer an OrderedCollection containing the same elements as the receiver.
	No conversion is required in this case."

	^self!

at: index
	"Answer the element at the specified <integer> index of the receiver."

	| basicIndex |
	^(index < 1 or: [ (basicIndex := index + firstIndex - 1) > lastIndex ])
		ifTrue: [self errorSubscriptBounds: index]
		ifFalse: [self basicAt: basicIndex]!

at: index ifAbsent: exceptionBlock
	"Answer an <Object> which is the element of the receiver 
	at the specified index. If the index is out of bounds answer
	the result of evaluating the <niladicValuable> exceptionBlock."

	| basicIndex |
	^(index < 1 or: [ (basicIndex := index + firstIndex - 1) > lastIndex ])
		ifTrue: [exceptionBlock value]
		ifFalse: [self basicAt: basicIndex]!

at: index put: storee
	"Replace the element at the <integer> index of the receiver with
	the <Object> argument, storee.
	Report an error if there is no such element."

	| basicIndex |
	^(index < 1 or: [(basicIndex := index + firstIndex - 1) > lastIndex])
		ifTrue: [self errorSubscriptBounds: index]
		ifFalse: [self basicAt: basicIndex put: storee]!

basicAddAll: aCollection
	| size |
	size := aCollection size.
	self basicSize - lastIndex < size ifTrue: [self makeRoomAtEndFor: size].
	aCollection do: [:each | self basicAt: (lastIndex := lastIndex + 1) put: each].
	^aCollection!

basicNextIdentityIndexOf: anElement from: start to: stop
	"Private - Answer the index of the next occurrence of anElement in the receiver's indexable
	variables between startIndex and stopIndex inclusive. If there are no such occurrences, answer 0."

	<primitive: 59>
	start to: stop do: [:i | (self basicAt: i) == anElement ifTrue: [^i]].
	^0!

basicReplaceElementsOf: anIndexableObject from: startInteger to: stopInteger startingAt: startAtInteger
	"Private - Replace the indexable instance variables of the variable pointer object, anIndexableObject, between
	startInteger and stopInteger inclusive with elements of the receiver starting from startAtInteger. Answers
	anIndexableObject."

	<primitive: 188>
	| offset |
	offset := startAtInteger - startInteger.
	(anIndexableObject == self and: [startAtInteger < startInteger])
		ifTrue: 
			[stopInteger to: startInteger
				by: -1
				do: [:i | anIndexableObject basicAt: i put: (self basicAt: offset + i)]]
		ifFalse: 
			[startInteger to: stopInteger do: [:i | anIndexableObject basicAt: i put: (self basicAt: offset + i)]].
	^anIndexableObject!

copyWith: newElement
	"Answer a <sequencedReadableCollection> which is a copy of 
	the receiver that has newElement added in the correct position
	as defined by the receiver's sort order."

	^self copy
		add: newElement;
		yourself!

copyWithoutIndex: anInteger
	"Answer a <SequenceableCollection> which is a copy of the receiver but without the element with the specified index.
	Implementation Note: This implementation is more efficient for OrderedCollection, and necessary for SortedCollection."

	| size copy |
	size := self size - 1.
	copy := self copyLikeOfSize: size.
	self
		basicReplaceElementsOf: copy
		from: 1
		to: anInteger - 1
		startingAt: firstIndex.
	self
		basicReplaceElementsOf: copy
		from: anInteger
		to: size
		startingAt: firstIndex + anInteger.
	^copy!

detect: discriminator ifNone: exceptionHandler
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's 
	elements.  Answer the first element (in the #do: order) for which discriminator evaluates 
	to true. If none evaluates to true answer the result of evaluating the <niladicValuable> 
	argument, exceptionHandler."

	"Implementation Note: Override to provide a more efficient implementation that avoids the
	full block."

	firstIndex to: lastIndex
		do: [:i | (discriminator value: (self basicAt: i)) ifTrue: [^self basicAt: i]].
	^exceptionHandler value!

do: operation 
	"Evaluate monadic value argument, operation, for each of the element of the 
	receiver. Answers the receiver."

	"Implementation Note: Override to avoid bounds checking in #at: for better performance."

	firstIndex to: lastIndex do: [:i | operation value: (self basicAt: i)]!

do: aMonadicValuable separatedBy: aNiladicValuable
	"Evaluate the <monadicValuable> first argument for each of the receiver's elements, interspersed with evaluations of the <niladicValuable> second argument. The separator argument is first evaluated after the first element, and is not evaluated after the last element (i.e. it is not evaluated at all if there are less than two elements)."

	"Implementation Note: As elegant as the <Collection> implementation is, it is not particularly efficient as it requires two full blocks. Therefore we override here for efficiency, as this is a very useful operation for printing and joining."

	self size == 0 ifTrue: [^self].
	aMonadicValuable value: (self basicAt: firstIndex).
	firstIndex + 1 to: lastIndex
		do: 
			[:i |
			aNiladicValuable value.
			aMonadicValuable value: (self basicAt: i)]!

findFirst: discriminator
	"Answer the <integer> index of the first element of the receiver for which the 
	<monadicValuable> argument, discriminator, evaluates to true. If there are 
	no such elements, answer 0."

	"Implementation Note: Override superclass to provide a more efficient implementation."

	firstIndex to: lastIndex
		do: [:i | (discriminator value: (self basicAt: i)) ifTrue: [^i - firstIndex + 1]].
	^0!

first
	"Answer an <Object> which is the first element of the receiver. Raise an exception if the
	receiver contains no elements."

	"Implementation Note: Override to provide an optimized implementation."

	^firstIndex <= lastIndex ifTrue: [self basicAt: firstIndex] ifFalse: [self errorSubscriptBounds: 1]!

firstIndex: first lastIndex: last
	"Private - Initialize the receiver's first and last indices."

	firstIndex := first.
	lastIndex := last
!

identityIncludes: anObject
	"Answer whether the argument, anObject, is one of the receiver's elements."

	"Implementation Note: Override superclass to provide a more efficient implementation using the identity search primitive."

	^(self
		basicIdentityIndexOf: anObject
		from: firstIndex
		to: lastIndex) ~~ 0!

includes: target
	"Answer whether the argument, target, is one of the elements of the receiver.
	Implementation Note: Override superclass to provide a more efficient implementation."

	firstIndex to: lastIndex do: [:i | (self basicAt: i) = target ifTrue: [^true]].
	^false!

initialize
	"Initialize the receiver after creation"

	firstIndex := 1.
	lastIndex := 0
!

inject: anObject into: aDyadicValuable
	"Evaluate the <dyadicValuable> argument, aDyadicValuable, once for each element in the
	receiver, passing the elements as the second argument, and passing the value of the previous
	evaluation as the first argument, starting with the <Object> argument, initialValue. The
	operation must answer the value it wishes to have passed as its first argument the next time
	it is evaluated. The traversal is in the #do: order. Answer the final value of the
	operation. This enumeration is particularly useful for performing summations and other
	statistical operations."

	"Implementation Note: Override superclass implementation for efficiency. By inlining the do:
	implementation we can avoid requiring a full block."

	| nextValue |
	nextValue := anObject.
	firstIndex to: lastIndex
		do: [:i | nextValue := aDyadicValuable value: nextValue value: (self basicAt: i)].
	^nextValue!

isEmpty
	"Answer whether the receiver contains no elements. 
	Implementation Note: Override superclass to provide a more efficient implementation."

	^firstIndex > lastIndex!

last
	"Answer the <Object> which is the last element of the receiver. Raise an exception if the
	receiver contains no elements."

	"Implementation Note: Override to provide an optimized implementation."

	^firstIndex <= lastIndex ifTrue: [self basicAt: lastIndex] ifFalse: [self errorSubscriptBounds: 0]!

lookup: keyInteger
	"Answer the value named by the <Integer> argument, keyInteger, or nil if there is no such key in the receiver."

	| basicIndex |
	^(keyInteger < 1 or: [(basicIndex := keyInteger + firstIndex - 1) > lastIndex])
		ifFalse: [self basicAt: basicIndex]!

makeRoomAtEndFor: anInteger
	"Private - Make room at the end of the receiver to accommodate at least anInteger more elements. If there is insufficient free space in the receiver, then it is expanded to accommodate more elements."

	| shift capacity |
	capacity := self basicSize.
	capacity - self size < anInteger
		ifTrue: 
			[| g n |
			"Too full, increase the receiver's capacity to the requested size, rounded up to a multiple of the growSize"
			g := self growSize.
			n := anInteger + g - 1.
			^self basicResize: capacity + (n - (n \\ g))].
	shift := 1 - firstIndex.	"N.B. shift < 0"

	"Move tail of collection towards head"
	self basicReplaceElementsOf: self from: firstIndex + shift to: lastIndex+shift startingAt: firstIndex.
	"Nil out old slots"
	lastIndex + shift + 1 to: lastIndex do: [:i | self basicAt: i put: nil].
	firstIndex := 1.
	lastIndex := lastIndex + shift!

makeRoomAtFirstFor: anInteger
	"Private - Make room at the start of the receiver to accommodate anInteger elements."

	| newOrderedCollection |
	newOrderedCollection := self class new: self basicSize + anInteger.
	self basicReplaceElementsOf: newOrderedCollection from: anInteger + firstIndex to: anInteger + lastIndex startingAt: firstIndex.
	newOrderedCollection 
		firstIndex: anInteger + firstIndex
		lastIndex: anInteger + lastIndex.
	^self become: newOrderedCollection!

nextIdentityIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver's indexable
	variables between startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Override the inherited implementation to make use of the primitive as the receiver's elements
	are contiguous between the first and last indices."

	| offset index |
	offset := firstIndex - 1.
	index := self
				basicIdentityIndexOf: anElement
				from: start + offset
				to: stop + offset.
	^index == 0 ifTrue: [0] ifFalse: [index - offset]!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Implementation Note: Override the superclass to provide a more efficient
	inlined implementation (important for serial searches)."

	start to: stop do: [:i | (self basicAt: i+firstIndex-1) = anElement ifTrue: [^i]].
	^0!

removeAll
	"Empty the receiver of all contents"

	#todo "Implement more efficient mechanism (need a basic block write operation)".
	firstIndex to: lastIndex do: [:i | self basicAt: i put: nil].
	firstIndex := 1.
	lastIndex := 0!

removeAllSuchThat: aBlock 
	"Remove each element of the receiver for which aBlock evaluates to true. The method in
	Collection is O(N^2), this is O(N)."

	| n |
	n := firstIndex.
	firstIndex to: lastIndex
		do: 
			[:index | 
			| elem |
			elem := self basicAt: index.
			(aBlock value: elem) 
				ifFalse: 
					[self basicAt: n put: elem.
					n := n + 1]].
	n to: lastIndex do: [:i | self basicAt: i put: nil].
	lastIndex := n - 1!

removeAtIndex: anInteger
	"Remove, and answer, the element of the receiver at the specified <integer> index. Raise a `BoundsError` if there is no element with that index."

	| element basicIndex |
	element := self at: anInteger.
	(basicIndex := anInteger + firstIndex - 1) == firstIndex
		ifTrue: 
			[self basicAt: firstIndex put: nil.
			firstIndex := firstIndex + 1]
		ifFalse: 
			["Shuffle any succeeding elements down"
			self
				basicReplaceElementsOf: self
				from: basicIndex
				to: lastIndex - 1
				startingAt: basicIndex + 1.
			self basicAt: lastIndex put: nil.
			lastIndex := lastIndex - 1].
	^element!

replaceElementsOf: anIndexableObject from: startInteger to: stopInteger startingAt: startAtInteger
	"Private - Replace the indexable instance variables of the variable pointer object,
	anIndexableObject, between startInteger and stopInteger inclusive with elements of the
	receiver starting from startAtInteger. Answers anIndexableObject."

	| offset len |
	len := stopInteger - startInteger + 1.
	len == 0 ifTrue: [^anIndexableObject].
	(startAtInteger < 1 or: [(offset := startAtInteger + firstIndex - 1) > lastIndex])
		ifTrue: [self errorSubscriptBounds: startAtInteger].
	^self
		basicReplaceElementsOf: anIndexableObject
		from: startInteger
		to: stopInteger
		startingAt: offset!

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

	aSequencedReadableCollection
		replaceElementsOf: self
		from: startInteger + firstIndex - 1
		to: stopInteger + firstIndex - 1
		startingAt: startAtInteger!

resize: anInteger
	"Private - Resize the receiver to the specified number of elements. Elements are discarded, or new nil elements added to the end of the collection, as needed."

	self basicResize: firstIndex + anInteger - 1.
	lastIndex := firstIndex + anInteger - 1!

reversedFrom: startInteger to: stopInteger
	"Answer a new <sequencedReadableCollection> like the receiver containing those elements of the receiver between the <integer> indices startInteger and stopInteger, inclusive, but in reverse order."

	| answer offset len start stop |
	len := stopInteger - startInteger + 1.
	answer := OrderedCollection ofSize: len.
	len == 0 ifTrue: [^answer].
	offset := firstIndex - 1.
	(startInteger < 1 or: [(start := startInteger + offset) > lastIndex])
		ifTrue: [self errorSubscriptBounds: startInteger].
	(stopInteger < 1 or: [(stop := stopInteger + offset) > lastIndex])
		ifTrue: [self errorSubscriptBounds: stopInteger].
	offset := len + start.
	start to: stop do: [:i | answer basicAt: offset - i put: (self basicAt: i)].
	^answer!

reverseDo: aMonadicValuable 
	"Evaluate the <monadicValuable> argument against each of the element of the receiver in reverse
	order, from end to start. Answer the receiver."

	"Implementation Note: Override to avoid error checking in #at: for better performance."

	lastIndex to: firstIndex
		by: -1
		do: [:i | aMonadicValuable value: (self basicAt: i)]!

select: discriminator
	"Evaluate the monadic valuable argument, discriminator, for each of the receiver's elements.
	Answer a new Collection like the receiver containing only those elements for which 
	the discriminator evaluates to true."

	| newCollection |
	newCollection := self copyEmpty.
	self do: [:each | (discriminator value: each) ifTrue: [newCollection add: each]].
	^newCollection!

setSize: anInteger
	| newLast |
	newLast := firstIndex + anInteger - 1.
	"Nil out any slots after the new last index"
	newLast + 1 to: lastIndex do: [:each | self basicAt: each put: nil].
	"Resize if necessary"
	newLast > self basicSize ifTrue: [self makeRoomAtEndFor: newLast - lastIndex].
	"Making room may have shifted elements down so must recalc."
	lastIndex := firstIndex + anInteger - 1.!

size
	"Answer the number of elements in the receiver."

	^lastIndex - firstIndex + 1
!

sort
	"Perform an in-place sort of the contents of the receiver using the default sort algorithm and sort order, which is defined by the result of sending #<= to pairs of elements."

	self sortUsing: self class defaultSortAlgorithm!

sort: aDyadicValuable
	"Perform an in-place sort against the receiver using the specified <dyadicValuable> sort block."

	self sortUsing: (SortAlgorithm defaultSort: aDyadicValuable)!

sortUsing: aSortAlgorithm
	"Perform an in-place sort against the receiver using the specified sort algorithm"
	
	aSortAlgorithm 
		sort: self
		from: firstIndex
		to: lastIndex!

uncheckedFrom: startInteger to: stopInteger keysAndValuesDo: aDyadicValuable 
	"Private - Evaluate the <dyadicValuable> argument for each element of the receiver
	between the specified <integer> indices, inclusive, with the element and its index as
	respectively the second and first arguments. No bounds checks are performed."

	startInteger to: stopInteger
		do: [:i | aDyadicValuable value: i value: (self basicAt: i + firstIndex - 1)]! !

!Core.OrderedCollection categoriesForMethods!
add:afterIndex:!adding!public! !
addAllFirst:!adding!public! !
addAllLast:!adding!public! !
addAnsweringIndex:!adding!public! !
addFirst:!adding!public! !
addLast:!adding!public! !
allSatisfy:!enumerating!public! !
anySatisfy:!enumerating!public! !
asOrderedCollection!converting!public! !
at:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
basicAddAll:!adding!private! !
basicNextIdentityIndexOf:from:to:!private!searching! !
basicReplaceElementsOf:from:to:startingAt:!private!replacing! !
copyWith:!copying!public! !
copyWithoutIndex:!copying!public! !
detect:ifNone:!public!searching! !
do:!enumerating!public! !
do:separatedBy:!enumerating!public! !
findFirst:!public!searching! !
first!accessing!public! !
firstIndex:lastIndex:!accessing!private! !
identityIncludes:!public!searching! !
includes:!public!searching! !
initialize!initializing!public! !
inject:into:!enumerating!public! !
isEmpty!public!testing! !
last!accessing!public! !
lookup:!accessing!public! !
makeRoomAtEndFor:!adding!private! !
makeRoomAtFirstFor:!adding!private! !
nextIdentityIndexOf:from:to:!public!searching! !
nextIndexOf:from:to:!public!searching! !
removeAll!public!removing! !
removeAllSuchThat:!accessing!public! !
removeAtIndex:!public!removing! !
replaceElementsOf:from:to:startingAt:!private!replacing! !
replaceFrom:to:with:startingAt:!public!replacing! !
resize:!mutating!private! !
reversedFrom:to:!copying!public! !
reverseDo:!enumerating!public! !
select:!enumerating!public! !
setSize:!accessing!public! !
size!accessing!public! !
sort!public!sorting! !
sort:!public!sorting! !
sortUsing:!public!sorting! !
uncheckedFrom:to:keysAndValuesDo:!enumerating!private! !
!

!Core.OrderedCollection class methodsFor!

new
	"Answer a new instance of the receiver with sufficient capacity (initially)
	for the default number of elements."

	^self new: 5!

new: count
	"Answer a new instance of the receiver with sufficient initial capacity
	to hold the number of elements specified by the <integer> argument,
	count. The instance is initally empty (i.e.it reports 0 when sent #size)."

	^(self basicNew: count) initialize!

ofSize: count
	"Private - Answer a new instance of the receiver with the number of
	nil elements specified by the <integer> argument, count.

	This method differs from OrderedCollection>>new:, as that
	method answers an <OrderedCollection> with the capacity for
	anInteger elements, but which is initially empty (i.e. it
	reports a size of 0)."

	^(self basicNew: count)
		firstIndex: 1
		lastIndex: count! !

!Core.OrderedCollection class categoriesForMethods!
new!instance creation!public! !
new:!instance creation!public! !
ofSize:!instance creation!private! !
!

