"Filed out from Dolphin Smalltalk"!

PluggableSortAlgorithm subclass: #QuicksortAlgorithm
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

QuicksortAlgorithm guid: (GUID fromString: '{4ecbb0ca-01f4-485f-9c80-3d77c661d26b}')!

QuicksortAlgorithm comment: 'QuicksortAlgorithm implements the Quicksort algorithm as a sorting strategy for use in conjunction with <SortedCollection>s.

Quicksort was invented by C.A.R. Hoare in the early 1960s. It is a fast sort with a short inner loop that requires only about O(N log N) on average to sort N items. Quicksort uses a divide-and-conquer approach, partitioning the elements into two parts and then recurively sorting them. Although it is the most efficient comparison based sorting algorithm on average, it has worst cases in which it can become quadratic. These cases are not only very time consuming, but since the algorithm is recursive they can also require a large amount of stack space (although this disadvantage can be largely overcome by sorting the larger partition iteratively rather than recursively, which limits the stack requirement to O(log N) rather than O(N)).

This particular Quicksort implementation in this class is a part iterative, part recursive, implementation based on that from ''Numerical Recipes in C'', Press, Teukolsky, et al.. It is marginally faster (about 5-15%) on average than the traditional Smalltalk-80 sort, and about twice as fast in some cases. In particular it exhibits better performance when used in conjunction with a #<= comparison, e.g. the default <SortedCollection> sort comparison, especially when the collection is already sorted.

Quick sort is not a stable sort, i.e. if the collection has previously been sorted by some other criteria, then quick sort will not maintain this previous ordering for sort equal elements when resorting.'!

!QuicksortAlgorithm categoriesForClass!Kernel-Objects! !

!QuicksortAlgorithm methodsFor!

sort: anObject from: startInteger to: stopInteger
	"Sort elements in the range of indexable instance variables of the <Object> argument from
	startInteger through stopInteger to be non-descending according to the receiver's sort
	block."

	| i j up lo |
	up := stopInteger.
	lo := startInteger.
	[up - lo > 7] whileTrue: 
			[| a b |
			"Choose median and arrange so [lo+1] <= [lo] <= [up]"
			j := lo + up bitShift: -1.
			i := lo + 1.
			a := anObject basicAt: j.
			anObject basicAt: j put: (anObject basicAt: i).
			anObject basicAt: i put: a.
			(self compare: (anObject basicAt: up) with: a)
				ifTrue: 
					[anObject basicAt: i put: (anObject basicAt: up).
					anObject basicAt: up put: a].
			(self compare: (anObject basicAt: up) with: (anObject basicAt: lo))
				ifTrue: 
					[a := anObject basicAt: up.
					anObject basicAt: up put: (anObject basicAt: lo).
					anObject basicAt: lo put: a].
			(self compare: (anObject basicAt: lo) with: (anObject basicAt: i))
				ifTrue: 
					[a := anObject basicAt: lo.
					anObject basicAt: lo put: (anObject basicAt: i).
					anObject basicAt: i put: a].
			"Partition...(note we must test that i and j remain in bounds because the
			sort block may use <= or >=."
			j := up.	"i.e. start from up-1"
			b := anObject basicAt: lo.
			
			[[i < j and: [self compare: (anObject basicAt: (i := i + 1)) with: b]] whileTrue.
			[j >= i and: [self compare: b with: (anObject basicAt: (j := j - 1))]] whileTrue.
			j < i]
					whileFalse: 
						[a := anObject basicAt: i.
						anObject basicAt: i put: (anObject basicAt: j).
						anObject basicAt: j put: a].
			"Insert partitioning element"
			anObject basicAt: lo put: (anObject basicAt: j).
			anObject basicAt: j put: b.
			"Skip sort-equal elements to speed up worst cases - suggested by John Brant"
			[(j := j - 1) > lo and: [self compare: b with: (anObject basicAt: j)]] whileTrue.
			"Recursively sort smaller sub-interval and process larger remainder on the
			next loop iteration"
			up - i < (j - lo)
				ifTrue: 
					[self
						sort: anObject
						from: i
						to: up.
					up := j]
				ifFalse: 
					[self
						sort: anObject
						from: lo
						to: j.
					lo := i]].
	"When interval size drops below threshold perform an insertion sort (quicker for small
	numbers of elements)"
	self
		insertionSort: anObject
		from: lo
		to: up! !

!QuicksortAlgorithm categoriesForMethods!
sort:from:to:!operations!public! !
!

