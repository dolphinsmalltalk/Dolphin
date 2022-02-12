"Filed out from Dolphin Smalltalk"!

Core.OrderedCollection variableSubclass: #'Core.SortedCollection'
	instanceVariableNames: 'algorithm'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SortedCollection guid: (Core.GUID fromString: '{87b4c525-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.SortedCollection comment: 'SortedCollection is a class of <SequencedGrowableCollection>s whose elements are ordered in the sequence specified by a user-definable sort order function (the sort "block", actually a <dyadicValuable>). Note that unlike traditional Smalltalk implementations of SortedCollection, Dolphin''s implementation (as of D6) holds a <SortAlgorithm> instance rather than a <dyadicValuable> sort-order block. This allows the sorting algorithm to be pluggable, as well as the sort ordering. Another advantage is that the default sort order need not use a block at all, allowing for improved performance of the default sort by avoiding the need for block activations to perform element comparisons.

SortedCollection complies with the ANSI protocols:
	Object
	collection
	extensibleCollection
	sequencedCollection
	sequencedContractibleCollection
	sequencedReadableCollection
	SortedCollection

Elements can be added, removed or inserted, and can be accessed using external integer keys. However, it is an error to attempt to insert or replace elements at specific indices using any of the methods such as #at:put:, as this might invalidate the sort order.
 
Instance Variables:
	sortBlock		<dyadicValuable>
	algorithm		<SortAlgorithm>'!
!Core.SortedCollection categoriesForClass!Collections-Sequenceable! !
!Core.SortedCollection methodsFor!

, operand
	"This is the concatenation operation. Answer a copy of the receiver with each element of the
	<sequencedReadableCollection> argument, operand, added, in the receiver's sort order."

	^self copy
		addAll: operand;
		yourself!

add: newElement
	"Add the <Object>, newElement, as a new element of the receiver, inserting it in the correct
	place to maintain the sort ordering of the receiver. Answers newElement."

	self addAnsweringIndex: newElement.
	^newElement!

add: anObject afterIndex: anInteger
	"Add the <Object> first argument to the receiver immediately after the element currently at the specified <integer> index. The index must be between 0 and the receiver's current size (if not raise an exception). Answer the new element.
	SortedCollections maintain their own ordering, so this is not a valid operation."

	^self shouldNotImplement!

add: newElement beforeIndex: index
	"Add newElement to the receiver immediately before the element currently at the specified
	index (i.e. the newElement will then have that index). index must be between 1 and the
	receiver's current size plus 1 (if not raise an exception). Answer newElement.
	SortedCollections maintain their own ordering, so this is not a valid operation."

	^self shouldNotImplement!

addAll: aCollection
	"Include all the elements of the <collection> argument as elements of the receiver. Answer
	aCollection."

	aCollection size > (self size // 3)
		ifTrue: 
			[self basicAddAll: aCollection.
			self reSort]
		ifFalse: [aCollection do: [:each | self add: each]].
	^aCollection!

addAllFirst: aCollection
	"Prepend all elements of the <collection> argument to the receiver, in the order that they appear in the argument, as determined by its implementation of #do:. Answer the new elements.
	SortedCollections maintain their own ordering, so this is not a valid operation."

	^self shouldNotImplement!

addAllLast: aCollection
	"Append the elements of the <collection> argument to the receiver, in the order that they appear in that collection (as defined by its implementation of #do:). Answer the collection.
	SortedCollections maintain their own ordering, so this is not a valid operation."

	^self shouldNotImplement!

addAnsweringIndex: anObject 
	"Add anObject as a new element of the receiver, inserting it in the correct place to
	maintain the ascending ordering of the receiver as determined by sortBlock. Answer the index
	at which anObject was added."

	^self insert: anObject before: (self indexForInserting: anObject)!

addFirst: anObject
	"Insert newObject as the first element of the receiver.
	SortedCollections maintain their own ordering, so this is not a valid operation."

	^self shouldNotImplement
!

addLast: anObject
	"Append newObject as the last element of the receiver. Answer newObject.
	SortedCollections maintain their own ordering, so this is not a valid operation."

	^self shouldNotImplement
!

algorithm
	"Answer the SortAlgorithm which the receiver is currently using to sort its elements."

	<nonBrowsable>
	^algorithm!

algorithm: aSortAlgorithm 
	"Set the <SortAlgorithm> which the receiver uses to sort its elements."

	algorithm := aSortAlgorithm.
	self notEmpty ifTrue: [self reSort]!

anyIndexOf: anObject
	"Answer the <integer> index of any element of the receiver, not necessarily the first, which is equal to the <Object> argument. If the receiver does not contain any elements equal to target, answer 0.
	This search is performed using a binary chop, and so should be faster than #indexOf: for larger collections most circumstances, however the argument must be compatible with the receiver's sort block."

	| index low high searchBlock |
	searchBlock := self sortBlock.
	low := firstIndex.
	high := lastIndex.
	
	[index := (high + low) // 2.
	low > high] whileFalse: 
				[(searchBlock value: (self basicAt: index) value: anObject)
					ifTrue: [low := index + 1]
					ifFalse: [high := index - 1]].
	^(index < firstIndex or: [index > lastIndex or: [(self basicAt: index) ~= anObject]])
		ifTrue: [0]
		ifFalse: [index + firstIndex - 1]!

asOrderedCollection
	"Answer an OrderedCollection containing the same elements as the receiver. The elements of
	the OrderedCollection will be sorted (at least initially) in the sort order of the
	receiver."

	" Implementation Note: Revert to the Collection implementation."

	^(OrderedCollection new: self size)
		addAll: self;
		yourself!

asSortedCollection
	"Answer a <SortedCollection> containing the same elements as the receiver with the same sort
	block (i.e the receiver)."

	^self!

at: index put: newElement 
	"Replace the element at the specified index of the receiver with newElement. Raise an
	exception if there is no such element. 
	This is not a valid operation for SortedCollections, as they are not writeable via index."

	^self shouldNotImplement!

binaryIncludes: anObject 
	"Answer whether the receiver includes the specified <Object>. Unlike #includes:, which is a
	serial search, this is a fast binary search performed using the receiver's sort block, and
	consequently the argument must be compatible with the receiver's sort block."

	| index |
	index := (self indexForInserting: anObject) - 1.
	^(index between: firstIndex and: lastIndex) and: [(self basicAt: index) = anObject]!

collect: transformer 
	"Evaluate the <monadicValuable> argument, transformer, for each of the receiver's elements.
	Answer a new collection like the receiver containing the values returned by the transformer
	on each evaluation."

	"Implementation Note: Override to return an <sequencedCollection> (in fact an
	OrderedCollection). We can't use the #species/#copyLike mechanism, because in general we
	want our copies to remain sorted in the current order."

	| answer |
	answer := OrderedCollection new: self size.
	self do: [:each | answer addLast: (transformer value: each)].
	^answer!

copyEmpty: anInteger 
	"Private - Answer an empty copy of the receiver, with enough space for anInteger
	number of elements."

	"Implementation Note: We must override in order to preserve the algorithm."

	^(super copyEmpty: anInteger) setSortAlgorithm: algorithm!

copyFrom: start to: stop 
	"Answer a copy of a subset of the receiver, starting from element at index start, until
	element at index stop."

	"Implementation Note: We must reimplement, because we disallow a number of the methods used
	by the superclass implementation."

	| answer offset size |
	stop < start ifTrue: [^self copyEmpty: stop - start + 1].
	start < 1 ifTrue: [^self errorSubscriptBounds: start].
	stop > self size ifTrue: [^self errorSubscriptBounds: stop].
	size := stop - start + 1.
	answer := self copyLikeOfSize: size.
	"We assume the copy sorts in the same order"
	offset := start + firstIndex - 2.
	1 to: size do: [:i | answer basicAt: i put: (self basicAt: i + offset)].
	^answer!

copyLikeOfSize: anInteger 
	"Private - Answer an new collection of the same species as the receiver but with anInteger
	nil elements - i.e. not just with sufficient capacity for, but actually holding, anInteger
	nil elements."

	^(super copyLikeOfSize: anInteger) setSortAlgorithm: algorithm!

indexForInserting: anObject
	"Private - Answer the index at which anObject would be added. This is located using a binary
	chop."

	| index low high |
	low := firstIndex.
	high := lastIndex.
	
	[index := high + low bitShift: -1.
	low > high] whileFalse: 
				[(algorithm compare: (self basicAt: index) with: anObject)
					ifTrue: [low := index + 1]
					ifFalse: [high := index - 1]].
	^low!

insert: newElement before: anInteger
	"Private - Insert the argument, newElement, into the receiver at the basic index
	specified by the argument, anInteger, shuffling any subsequent elements down.
	index must be between 0 and the receiver's current basic size (if not an exception
	is raised), however no check is made to ensure that it lies within the current
	first and last indices. Answer the index at which the element was actually
	inserted."

	| basicIndex |
	basicIndex := lastIndex == self basicSize
				ifTrue: 
					[| offset |
					offset := anInteger - firstIndex.
					self makeRoomAtEndFor: 1.
					firstIndex + offset]
				ifFalse: [anInteger].

	"Slide the elements down the collection toward the new end to make room for the insertion"
	self
		basicReplaceElementsOf: self
		from: basicIndex + 1
		to: (lastIndex := lastIndex + 1)
		startingAt: basicIndex.
	self basicAt: basicIndex put: newElement.
	^basicIndex - firstIndex + 1!

replaceFrom: startInteger to: stopInteger with: aSequencedReadableCollection startingAt: startAtInteger
	"Destructively replace the elements of the receiver between the <integer> arguments
	startInteger and stopInteger inclusive with the <Object> elements of the
	<sequencedReadableCollection> argument, aSequencedReadableCollection, beginning with its
	element with <integer> index startAtInteger. Answer the receiver."

	"This is not a valid operation for SortedCollections, as it would mess up the sort order."

	^self shouldNotImplement!

resize: anInteger
	"Private - Resize the receiver to the specified number of elements. Elements are discarded, or new nil elements added to the end of the collection, as needed."

	"Implementation Note: SortedCollections can be reduced in size, but not grown - in general we don't know if nils are a valid element that have a sort order
	relationship recognised by the receiver's sort block."

	anInteger > self size ifTrue: [^self error: 'SortedCollections cannot be grown to include nils'].
	super resize: anInteger!

reSort
	"Resort the entire contents of the receiver in the order specified by the current
	<SortAlgorithm>."

	self sortFrom: firstIndex to: lastIndex!

reverse
	"Answer a copy of the receiver but with its elements in reverse order."

	" Implementation Note: Refine in order to answer an OrderedCollection because obviously
	reversing the receiver's elements would require inverting the sort block if the answer was
	to remain a sorted collection."

	| answer |
	answer := OrderedCollection new: self size.
	self reverseDo: [:element | answer addLast: element].
	^answer!

select: aMonadicValuable
	"Answer a new Collection like the receiver containing only those elements for which the <monadicValuable> argument evaluates to true."

	"Implementation Note: The superclass implementation works, but ends up sorting the selected elements again, which is unnecessary since we know they will be selected in sorted order."

	| j newCollection |
	newCollection := self copyEmpty.
	j := 0.
	firstIndex to: lastIndex
		do: 
			[:i |
			| each |
			(aMonadicValuable value: (each := self basicAt: i))
				ifTrue: [newCollection basicAt: (j := j + 1) put: each]].
	newCollection firstIndex: 1 lastIndex: j.
	^newCollection!

setSortAlgorithm: aSortAlgorithm 
	algorithm := aSortAlgorithm!

sortBlock
	"Answer a <dyadicValuable> (not necessarily a block) which implements the sort order
	comparison in use by the receiver's current <SortAlgorithm>. Note that the SortAlgorithm
	might not actually be using this sort block, but it will perform comparisons in the same
	way."

	^algorithm sortBlock!

sortBlock: aDyadicValuable 
	"Set the <dyadicValuable> which is evaluated to sort elements of the receiver to the
	argument, and then resort the receiver if necessary."

	self algorithm: (algorithm copyWithSortBlock: aDyadicValuable)!

sortFrom: startInteger to: stopInteger 
	"Private - Sort the receiver's indexed instance variables between the two <integer> indices,
	startInteger and stopInteger, using the receiver's current <SortAlgorithm>."

	algorithm 
		sort: self
		from: startInteger
		to: stopInteger!

sortUsing: aSortAlgorithm
	"Perform an in-place sort against the receiver using the specified sort algorithm.
	Note that this must change the receiver's sort algorithm, as well as perform an in-place sort, in order to maintain the invariant that the receiver's elements are maintained in the order determined by the receiver's sort comparison."

	algorithm := aSortAlgorithm.
	super sortUsing: aSortAlgorithm!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler."

	algorithm ~~ self class defaultSortAlgorithm
		ifTrue: [^anSTBOutFiler saveObject: self as: (STBSortedCollectionProxy forCollection: self)].
	super stbSaveOn: anSTBOutFiler! !
!Core.SortedCollection categoriesForMethods!
,!copying!public! !
add:!adding!public! !
add:afterIndex:!adding!public! !
add:beforeIndex:!adding!public! !
addAll:!adding!public! !
addAllFirst:!adding!public! !
addAllLast:!adding!public! !
addAnsweringIndex:!adding!public! !
addFirst:!adding!public! !
addLast:!adding!public! !
algorithm!accessing!public! !
algorithm:!accessing!operations!public! !
anyIndexOf:!public!searching! !
asOrderedCollection!converting!public! !
asSortedCollection!converting!public! !
at:put:!accessing!public! !
binaryIncludes:!adding!public! !
collect:!enumerating!public! !
copyEmpty:!copying!private! !
copyFrom:to:!copying!public! !
copyLikeOfSize:!copying!private! !
indexForInserting:!adding!private! !
insert:before:!adding!private! !
replaceFrom:to:with:startingAt:!public!replacing! !
resize:!mutating!private! !
reSort!operations!public! !
reverse!copying!public! !
select:!enumerating!public! !
setSortAlgorithm:!initializing!private! !
sortBlock!accessing!public! !
sortBlock:!accessing!operations!public! !
sortFrom:to:!algorithms!private! !
sortUsing:!public!sorting! !
stbSaveOn:!binary filing!public! !
!

Core.SortedCollection methodProtocol: #SortedCollection attributes: #(#ansi #readOnly) selectors: #(#, #add: #addAll: #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #before: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #notEmpty #occurrencesOf: #rehash #reject: #remove: #remove:ifAbsent: #removeAll: #removeAtIndex: #removeFirst #removeLast #reverse #reverseDo: #select: #size #sortBlock #sortBlock: #with:do:)!

!Core.SortedCollection class methodsFor!

caseSensitiveSortBlock
	"Answer a <dyadicValuable> which can be used to sort <String>s into ascending order on a
	case sensitive basis (String's implementation of the #<= message, used by the default sort
	block, is case-insensitive).."

	^[:a :b | (a <==> b) <= 0]!

defaultSortBlock
	"Answer a <dyadicValuable> that implements the default sort-order relationship."

	"ANSI standard specifies #< as default sort block comparison, but this is presumably a typo,
	since Smalltalk has historically used #<=, and furthermore it is useful in conjunction with
	stable sort algorithms."

	^[:a :b | a <= b]!

new: anInteger 
	"Answer an instance of the receiver with capacity for the specified <integer> number of
	elements, sorted using the default <SortAlgorithm>."

	^(super new: anInteger)
		setSortAlgorithm: self defaultSortAlgorithm;
		yourself!

sortAlgorithm: aSortAlgorithm
	"Answer a new instance of the receiver which uses the specified <SortAlgorithm>."

	^(super new: 5)
		setSortAlgorithm: aSortAlgorithm;
		yourself!

sortBlock: aDyadicValuable
	"Answer a new instance of the receiver which uses the <dyadicValuable> argument (referred to
	as the 'sort block') to sort its elements. When evaluated the sort block should answer
	whether its first parameter should be ordered before the second parameter.

	Note: The discriminator does not need to be a BlockClosure (despite the #sortBlock: message,
	which is historic), it must simply understand the #value:value: message from the
	<dyadicValuable> protocol."

	^self sortAlgorithm: (self defaultSortAlgorithmClass newSortBlock: aDyadicValuable)!

withNilsSortBlock
	^[:a :b | a isNil ifTrue: [true] ifFalse: [b isNil ifTrue: [false] ifFalse: [a <= b]]]
! !
!Core.SortedCollection class categoriesForMethods!
caseSensitiveSortBlock!constants!public! !
defaultSortBlock!constants!public! !
new:!instance creation!public! !
sortAlgorithm:!instance creation!public! !
sortBlock:!instance creation!public! !
withNilsSortBlock!instance creation!public! !
!

Core.SortedCollection class methodProtocol: #'SortedCollection factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #sortBlock: #with: #with:with: #with:with:with: #with:with:with:with: #withAll:)!

