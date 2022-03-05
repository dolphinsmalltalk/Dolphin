"Filed out from Dolphin Smalltalk"!

SortAlgorithm subclass: #DefaultSortAlgorithm
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DefaultSortAlgorithm guid: (GUID fromString: '{4da46cbc-7732-4a19-b7ef-7548a1c4506f}')!
DefaultSortAlgorithm comment: 'DefaultSortAlgorithm implements the default sorting algorithm and sort-ordering as a sorting strategy for use in conjunction with <SortedCollection>s.

Currently DefaultSortAlgorithm is an implementation of the Introsort algorithm. This is a modified Quicksort that switches to Heapsort when it detects that quicksort is going quadratic. The sort-order relationship is fixed and always uses the #<= message to compare elements.

The default sort algorithm is not guaranteed to be a stable sort (in fact in the current implementation it definitely is not), i.e. if the collection has previously been sorted by some other criteria, then this previous ordering of sort equal elements is not maintained when resorting.'!
!DefaultSortAlgorithm categoriesForClass!Kernel-Objects! !
!DefaultSortAlgorithm methodsFor!

compare: operand1 with: operand2 
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^operand1 <= operand2!

insertionSort: anObject from: startInteger to: stopInteger 
	startInteger + 1 to: stopInteger
		do: 
			[:j | 
			| a t i |
			a := anObject basicAt: j.
			i := j.
			[i <= startInteger or: [(t := anObject basicAt: i - 1) <= a]] whileFalse: 
					[anObject basicAt: i put: t.
					i := i - 1].
			anObject basicAt: i put: a]!

sift: anObject from: anInteger between: startInteger and: stopInteger 
	"Private-"

	"Implementation Note: Override purely to inline the sort order comparison."

	| val i |
	val := anObject basicAt: anInteger.
	i := anInteger.
	
	[| left right max j leftVal rightVal |
	max := val.
	j := i.
	left := j + j + 1 - startInteger.
	(left <= stopInteger and: [max <= (leftVal := anObject basicAt: left)]) 
		ifTrue: 
			[i := left.
			max := leftVal].
	right := left + 1.
	(right <= stopInteger and: [max <= (rightVal := anObject basicAt: right)]) 
		ifTrue: 
			[i := right.
			max := rightVal].
	i == j 
		ifTrue: 
			[j > anInteger ifTrue: [anObject basicAt: j put: val].
			^self].
	anObject basicAt: j put: max] 
			repeat!

sort: anObject from: startInteger to: stopInteger 
	"Sort elements in the range of indexable instance variables of the <Object> argument from
	startInteger through stopInteger to be non-descending according to the #<= message."

	| n |
	n := stopInteger - startInteger + 1.
	n <= 1 ifTrue: [^self].
	self 
		sort: anObject
		from: startInteger
		to: stopInteger
		limit: (self quicksortRecursionLimit: n)!

sort: anObject from: startInteger to: stopInteger limit: limitInteger 
	"Private - Sort elements in the range of indexable instance variables of the <Object> argument from
	startInteger through stopInteger to be non-descending according to the receiver's sort
	block."

	"Implementation Note: This is a copy of IntrosortAlgorithm>>introsort:from:to:limit: with
	the default sort order comparison inlined."

	| i j up lo limit |
	up := stopInteger.
	lo := startInteger.
	limit := limitInteger.
	[up - lo > 7] whileTrue: 
			[| temp pivot |
			(limit := limit - 1) == 0 
				ifTrue: 
					["Appears to be degenerating, so heapsort this partition"
					self 
						heapsort: anObject
						from: lo
						to: up.
					^self].
			"Choose median and arrange so [lo+1] <= [lo] <= [up]"
			j := lo + up bitShift: -1.
			i := lo + 1.
			temp := anObject basicAt: j.
			anObject basicAt: j put: (anObject basicAt: i).
			anObject basicAt: i put: temp.
			(anObject basicAt: up) <= temp 
				ifTrue: 
					[anObject basicAt: i put: (anObject basicAt: up).
					anObject basicAt: up put: temp].
			(anObject basicAt: up) <= (anObject basicAt: lo) 
				ifTrue: 
					[temp := anObject basicAt: up.
					anObject basicAt: up put: (anObject basicAt: lo).
					anObject basicAt: lo put: temp].
			(anObject basicAt: lo) <= (anObject basicAt: i) 
				ifTrue: 
					[temp := anObject basicAt: lo.
					anObject basicAt: lo put: (anObject basicAt: i).
					anObject basicAt: i put: temp].

			"Partition...(note we must test that i and j remain in bounds because the sort block may use <= or >=."
			j := up.	"i.e. start from up-1"
			pivot := anObject basicAt: lo.
			
			[[i < j and: [(anObject basicAt: (i := i + 1)) <= pivot]] whileTrue.
			[j >= i and: [pivot <= (anObject basicAt: (j := j - 1))]] whileTrue.
			j < i] 
					whileFalse: 
						[temp := anObject basicAt: i.
						anObject basicAt: i put: (anObject basicAt: j).
						anObject basicAt: j put: temp].

			"Insert partitioning element"
			anObject basicAt: lo put: (anObject basicAt: j).
			anObject basicAt: j put: pivot.

			"Skip sort-equal elements to speed up worst cases - suggested by John Brant"
			[(j := j - 1) > lo and: [pivot <= (anObject basicAt: j)]] whileTrue.

			"Recursively sort smaller sub-interval and process larger remainder on the next loop iteration"
			up - i < (j - lo) 
				ifTrue: 
					[self 
						sort: anObject
						from: i
						to: up
						limit: limit.
					up := j]
				ifFalse: 
					[self 
						sort: anObject
						from: lo
						to: j
						limit: limit.
					lo := i]].

	"When interval size drops below threshold perform an insertion sort (quicker for small
	numbers of elements)"
	self 
		insertionSort: anObject
		from: lo
		to: up!

sortBlock
	"Answer a <dyadicVariable> that implements the sort-order comparison in use by the receiver."

	^[:a :b | a <= b]! !
!DefaultSortAlgorithm categoriesForMethods!
compare:with:!comparing!public! !
insertionSort:from:to:!private!sorting! !
sift:from:between:and:!private!sorting! !
sort:from:to:!public!sorting! !
sort:from:to:limit:!private!sorting! !
sortBlock!accessing!public! !
!

!DefaultSortAlgorithm class methodsFor!

current
	^Current!

initialize
	Current := self new!

newSortBlock: aDyadicValuable
	^self pluggableEquivalentClass newSortBlock: aDyadicValuable!

pluggableEquivalentClass
	^IntrosortAlgorithm! !
!DefaultSortAlgorithm class categoriesForMethods!
current!instance creation!public! !
initialize!development!initializing!public! !
newSortBlock:!instance creation!public! !
pluggableEquivalentClass!constants!public! !
!

