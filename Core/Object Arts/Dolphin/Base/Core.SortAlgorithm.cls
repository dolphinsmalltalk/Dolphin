"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.SortAlgorithm'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SortAlgorithm guid: (Core.GUID fromString: '{5bafb298-56ce-415c-a401-5d05f084e240}')!
Core.SortAlgorithm comment: '`SortAlgorithm` is a class of policy objects that implement sort algorithms. A `SortAlgorithm` is responsible for defining the order of elements (i..e. it implements or holds the comparison predicate, or sort block), and for performing the sorting of a requested range of indexable instance variables of some other object, typically a `SortedCollection`, although in fact `SortAlgorithm`s can be used to sort the indexable variables of any object (see `Array>>#sort:`). 

SortAlgorithm itself implements the default sorting algorithm using Introsort. Introsort is a modified Quicksort that switches to Heapsort when it detects that quicksort is going quadratic. The sort-order relationship is fixed and always uses the #<= message to compare elements. 

Subclasses provide implementations of well-known sort algorithms for use in different circumstances. These include IntrosortAlgorithm,  which implements the same default sorting algorithm, but allows for different sort-order relationships through a pluggable sort block. Note that Introsort is not a stable sort, i.e. if the collection has previously been sorted by some other criteria, then this previous ordering of sort equal elements is not maintained when resorting. Some other subclasses implement sort algorithms that are stable.

No one sort algorithm is best in all cases; the traditional Smalltalk sort algorithm is Quicksort. Quicksort is a reasonable default, but can exhibit poor performance for large numbers of sort-equal elements, or when the sort order is inverted. Another disadvantage of quicksort is that it is not stable, so any previous ordering of sort-equal elements in the list is lost. Heapsort is slower than Quicksort on average, but has no worst cases. Introsort is a recently developed algorithm that combines Quicksort with Heapsort. It starts off with Quicksort, and then monitors itself to see if the sort is performing poorly, at which point it will switch to Heapsort. Introsort performs nearly as well as Quicksort on its best cases, and is better on average, and it is thus the default sort algorithm in Dolphin. However, since it is based on Quicksort and Heapsort it is still unstable. Mergesort and Insertion sort are both stable sorts, making them preferable for use in cases where one wants to sort by multiple criteria but in multiple passes (e.g. when sorting the items in a list view by sorting on the columns). Insertion sort is, however, slow in general, although comes into its own when sorting small sequences or sequences that are already largely sorted - in fact it is the algorithm of choice in both cases. Mergesort is nearly as fast as Quicksort on average, has no worst cases, and is stable. However it has the disadvantage of requiring auxiliary storage equal to the size of the collection being sorted. 

If choosing a default sorting algorithm for Smalltalk today, as opposed to in the 1970s, the memory usage would not be such a significant issue, and Mergesort might be a better choice than Quicksort. Fortunately in Dolphin one has the flexibility to choose the sorting algorithm to suit the task: If sorting random data, use Quicksort; if the data is known to be mostly sorted, Insertion sort is (perhaps surprisingly) the algorithm of choice; if the data is sorted and one needs to reverse the sort order, avoid Quicksort because this is one of the cases for which it will perform very poorly, Heapsort or Mergesort are good choices in this case; for lists in a UI Mergesort is preferable because it is stable, as well as having no worse cases that can result in significant pauses when inverting the column sort order in a list view. You can even implement your own custom sorting algorithms - for example if you know you will be sorting strings, then a radix sort will beat the pants off any comparison based sorting algorithm. To squeeze the last ounce of speed from your sorting you can also implement a custom sorting algorithm in order to inline the comparison predicate, indeed `SortAlgorithm` is an example of this that uses #<= to compare elements in order to emulate the default SortedCollection sort block, or perhaps to implement some new sorting algorithm you want to try.
'!
!Core.SortAlgorithm categoriesForClass!Kernel-Objects! !
!Core.SortAlgorithm methodsFor!

compare: operand1 with: operand2 
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^operand1 <= operand2!

copyWithSortBlock: aDyadicValuable
	^self class newSortBlock: aDyadicValuable!

heapsort: anObject from: startInteger to: stopInteger 
	| i |
	i := (stopInteger + startInteger) // 2.
	[i < startInteger] whileFalse: 
			[self 
				sift: anObject
				from: i
				between: startInteger
				and: stopInteger.
			i := i - 1].
	i := stopInteger.
	[i <= startInteger] whileFalse: 
			[| temp |
			temp := anObject basicAt: startInteger.
			anObject basicAt: startInteger put: (anObject basicAt: i).
			anObject basicAt: i put: temp.
			self 
				sift: anObject
				from: startInteger
				between: startInteger
				and: (i := i - 1)]!

insertionSort: anObject from: startInteger to: stopInteger 
	startInteger + 1 to: stopInteger
		do: 
			[:j | 
			| i t a |
			a := anObject basicAt: j.
			i := j.
			[i <= startInteger or: [(t := anObject basicAt: i - 1) <= a]] whileFalse: 
					[anObject basicAt: i put: t.
					i := i - 1].
			anObject basicAt: i put: a]!

quicksortRecursionLimit: anInteger
	^(2.0 * (anInteger asFloat ln / ##(2.0 ln))) floor!

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
	"Private - Sort elements in the range of indexable instance variables of the <Object> argument from startInteger through stopInteger to be non-descending according to the receiver's sort order."

	"Implementation Note: This is a copy of IntrosortAlgorithm>>introsort:from:to:limit: with the default sort order comparison inlined."

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
!Core.SortAlgorithm categoriesForMethods!
compare:with:!comparing!public! !
copyWithSortBlock:!copying!private! !
heapsort:from:to:!operations!private! !
insertionSort:from:to:!private!sorting! !
quicksortRecursionLimit:!helpers!private! !
sift:from:between:and:!private!sorting! !
sort:from:to:!public!sorting! !
sort:from:to:limit:!private!sorting! !
sortBlock!accessing!public! !
!

!Core.SortAlgorithm class methodsFor!

default
	^Default!

defaultSort: aDyadicValuable
	^self pluggableEquivalentClass newSortBlock: aDyadicValuable!

introSort: aDyadicValuable
	^IntrosortAlgorithm newSortBlock: aDyadicValuable!

newSortBlock: aDyadicValuable
	^self pluggableEquivalentClass newSortBlock: aDyadicValuable!

pluggableEquivalentClass
	^IntrosortAlgorithm! !
!Core.SortAlgorithm class categoriesForMethods!
default!instance creation!public! !
defaultSort:!instance creation!public! !
introSort:!instance creation!public! !
newSortBlock:!instance creation!public! !
pluggableEquivalentClass!constants!public! !
!

