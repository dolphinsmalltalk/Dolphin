"Filed out from Dolphin Smalltalk"!

PluggableSortAlgorithm subclass: #MergesortAlgorithm
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MergesortAlgorithm guid: (GUID fromString: '{cc7f696a-5bc0-4ad0-a342-d93af7cca0a3}')!

MergesortAlgorithm comment: 'MergesortAlgorithm implements the Mergesort algorithm as a pluggable sorting strategy for use in conjunction with <SortedCollection>s.

Mergesort is a simple, recursive, divide-and-conquer sort that works by dividing the range to sort in half, recursively sorting the two halves, and then merging the two halves. It requires auxiliary storage of the same size as the range to be sorted.

Mergesort is a fast O(n log n) algorithm with no worst cases that has the additional advantage of preserving the existing positions of sort-equal elements (i.e. it is stable). Although theoretically slower than Quicksort, in Smalltalk there is not a great deal of difference because Quicksort will typically perform more comparisons, and the speed of evaluation of the comparison block can become dominant in all but simple cases. Mergesort''s only significant disadvantage is that it requires auxiliary storage of a size sufficient to hold the sorted interval, typically doubling a collections space requirement while it is being sorted.'!

!MergesortAlgorithm categoriesForClass!Kernel-Objects! !

!MergesortAlgorithm methodsFor!

merge: anObject aux: anArray from: startInteger to: stopInteger pivot: midInteger 
	| i j k a cmp |
	i := startInteger.
	j := midInteger + 1.
	k := 0.
	a := anObject basicAt: i.
	cmp := sortBlock.
	[i <= midInteger and: [j <= stopInteger]] whileTrue: 
			[(cmp value: a value: (anObject basicAt: j)) 
				ifTrue: 
					[anArray at: (k := k + 1) put: a.
					a := anObject basicAt: (i := i + 1)]
				ifFalse: 
					[anArray at: (k := k + 1) put: (anObject basicAt: j).
					j := j + 1]].
	"Copy any leftovers from the first sub-list (leftovers from second sub-list already in place)"
	i to: midInteger do: [:each | anArray at: (k := k + 1) put: (anObject basicAt: each)].
	"Copy the merged data back into the source object"
	1 to: k do: [:each | anObject basicAt: startInteger + each - 1 put: (anArray at: each)]!

sort: anObject from: startInteger to: stopInteger 
	"Sort elements in the range of indexable instance variables of the <Object> argument
	(usually a <SequenceableCollection>) from startInteger through stopInteger to be
	non-descending according to the receiver's sortBlock."

	self 
		sort: anObject
		from: startInteger
		to: stopInteger
		aux: (Array new: (stopInteger - startInteger) + 1)!

sort: anObject from: startInteger to: stopInteger aux: anArray 
	"Private - "

	"Implementation Note: Empirical testing shows that the best point to switch over to
	insertion sort varies depending on the speed of the comparison. We can minimize the number
	of comparisons by choosing a cut-over of one (i.e. eschew insertion sort altogether), but
	this will be slower if the comparisons are fast and indeed the best cut-over point is around
	13 when sorting SmallIntegers with the default sort block. If however the sort block is
	relatively slow, then it is desirable to minimize the number of comparisons. Since the speed
	up achieved by using a larger cutover is relatively insignificant compared to the increase
	in time that may cause when sorting with a slow comparison, it seems best to choose a
	compromise cutover value somewhere close to one."

	| mid |
	stopInteger - startInteger < 5 
		ifTrue: 
			[^self 
				insertionSort: anObject
				from: startInteger
				to: stopInteger].
	mid := (startInteger + stopInteger) // 2.
	self 
		sort: anObject
		from: startInteger
		to: mid
		aux: anArray.
	self 
		sort: anObject
		from: mid + 1
		to: stopInteger
		aux: anArray.
	self 
		merge: anObject
		aux: anArray
		from: startInteger
		to: stopInteger
		pivot: mid! !

!MergesortAlgorithm categoriesForMethods!
merge:aux:from:to:pivot:!operations!private! !
sort:from:to:!operations!public! !
sort:from:to:aux:!operations!private! !
!

