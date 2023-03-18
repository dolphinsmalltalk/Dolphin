"Filed out from Dolphin Smalltalk"!

Kernel.PluggableSortAlgorithm
	subclass: #'Kernel.IntrosortAlgorithm'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.IntrosortAlgorithm guid: (Core.GUID fromString: '{80197d56-08be-4a10-a209-700b5452c610}')!
Kernel.IntrosortAlgorithm comment: 'IntrosortAlgorithm implements David Musser''s introspective sort algorithm as a sorting strategy for use in conjunction with <SortedCollection>s.

Introsort is not a new sorting algorithm, but rather hybrid of two others. It exhibits high-performance of Quicksort on average, but without the latter''s worst cases. It achieves this by using Quicksort as its default algorithm, but switching to Heapsort when it appears that quicksort is going quadratic. It is still not as fast as Heapsort on Quicksorts worst cases, because Quicksort wastes some time before the advisability of switching to Heapsort is detected, but it is a reasonable compromise.

Introsort is not a stable sort, i.e. if the collection has previously been sorted by some other criteria, then the sort will not maintain this previous ordering for sort equal elements when resorting. Use <MergesortAlgorithm> if a stable sort is required.'!
!Kernel.IntrosortAlgorithm categoriesForClass!Kernel-Objects! !
!Kernel.IntrosortAlgorithm methodsFor!

sort: anObject from: startInteger to: stopInteger 
	"Sort elements in the range of indexable instance variables of the <Object> argument from
	startInteger through stopInteger to be non-descending according to the receiver's sort
	block."

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

	"Implementation Note: This is a modified copy of QuicksortAlgorithm>>sort:from:to: The only
	change is to add the recursion depth limit."

	| i j up lo limit |
	up := stopInteger.
	lo := startInteger.
	limit := limitInteger.
	[up - lo > 7] whileTrue: 
			[| a b |
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
			a := anObject basicAt: j.
			anObject basicAt: j put: (anObject basicAt: i).
			anObject basicAt: i put: a.
			(sortBlock value: (anObject basicAt: up) value: a)
				ifTrue: 
					[anObject basicAt: i put: (anObject basicAt: up).
					anObject basicAt: up put: a].
			(sortBlock value: (anObject basicAt: up) value: (anObject basicAt: lo))
				ifTrue: 
					[a := anObject basicAt: up.
					anObject basicAt: up put: (anObject basicAt: lo).
					anObject basicAt: lo put: a].
			(sortBlock value: (anObject basicAt: lo) value: (anObject basicAt: i))
				ifTrue: 
					[a := anObject basicAt: lo.
					anObject basicAt: lo put: (anObject basicAt: i).
					anObject basicAt: i put: a].

			"Partition...(note we must test that i and j remain in bounds because the sort block may use <= or >=."
			j := up.	"i.e. start from up-1"
			b := anObject basicAt: lo.
			
			[[i < j and: [sortBlock value: (anObject basicAt: (i := i + 1)) value: b]] whileTrue.
			[j >= i and: [sortBlock value: b value: (anObject basicAt: (j := j - 1))]] whileTrue.
			j < i]
					whileFalse: 
						[a := anObject basicAt: i.
						anObject basicAt: i put: (anObject basicAt: j).
						anObject basicAt: j put: a].

			"Insert partitioning element"
			anObject basicAt: lo put: (anObject basicAt: j).
			anObject basicAt: j put: b.

			"Skip sort-equal elements to speed up worst cases - suggested by John Brant"
			[(j := j - 1) > lo and: [sortBlock value: b value: (anObject basicAt: j)]] whileTrue.

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
		to: up! !
!Kernel.IntrosortAlgorithm categoriesForMethods!
sort:from:to:!operations!public! !
sort:from:to:limit:!operations!private! !
!

