"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Core.SortAlgorithm'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.SortAlgorithm guid: (Core.GUID fromString: '{5bafb298-56ce-415c-a401-5d05f084e240}')!
Core.SortAlgorithm isNonInstantiable: true!
Core.SortAlgorithm comment: 'SortAlgorithm is the abstract class of singleton sort algorithms primarily used to implement the sorting strategy of <SortedCollection> instances, although in fact SortAlgorithms can be used to sort the indexable variables of any object. Concrete subclasses provide implementations of well-known sort algorithms for use in different circumstances. A <SortAlgorithm> is responsible for defining the order of elements (i..e. it implements or holds the comparison predicate, or sort block), and for performing the sorting of a requested range of indexable instance variables of some other object, typically a SortedCollection.

No one sort algorithm is best in all cases; the traditional Smalltalk sort algorithm is Quicksort. Quicksort is a reasonable default, but can exhibit poor performance for large numbers of sort-equal elements, or when the sort order is inverted. Another disadvantage of quicksort is that it is not stable, so any previous ordering of sort-equal elements in the list is lost. Heapsort is slower than Quicksort on average, but has no worst cases. Introsort is a recently developed algorithm that combines Quicksort with Heapsort. It starts off with Quicksort, and then monitors itself to see if the sort is performing poorly, at which point it will switch to Heapsort. Introsort performs nearly as well as Quicksort on its best cases, and is better on average, and it is thus the default sort algorithm in Dolphin. However, since it is based on Quicksort and Heapsort it is still unstable. Mergesort and Insertion sort are both stable sorts, making them preferable for use in cases where one wants to sort by multiple criteria but in multiple passes (e.g. when sorting the items in a list view by sorting on the columns). Insertion sort is, however, slow in general, although comes into its own when sorting small sequences or sequences that are already largely sorted - in fact it is the algorithm of choice in both cases. Mergesort is nearly as fast as Quicksort on average, has no worst cases, and is stable. However it has the disadvantage of requiring auxiliary storage equal to the size of the collection being sorted. 

If choosing a default sorting algorithm for Smalltalk today, as opposed to in the 1970s, the memory usage would not be such a significant issue, and Mergesort might be a better choice than Quicksort. Fortunately in Dolphin one has the flexibility to choose the sorting algorithm to suit the task: If sorting random data, use Quicksort; if the data is known to be mostly sorted, Insertion sort is (perhaps surprisingly) the algorithm of choice; if the data is sorted and one needs to reverse the sort order, avoid Quicksort because this is one of the cases for which it will perform very poorly, Heapsort or Mergesort are good choices in this case; for lists in a UI Mergesort is preferable because it is stable, as well as having no worse cases that can result in significant pauses when inverting the column sort order in a list view. You can even implement your own custom sorting algorithms - for example if you know you will be sorting strings, then a radix sort will beat the pants off any comparison based sorting algorithm. To squeeze the last ounce of speed from your sorting you can also implement a custom sorting algorithm in order to inline the comparison predicate, indeed <DefaultSortAlgorithm> is an example of this that uses #<= to compare elements in order to emulate the default SortedCollection sort block, or perhaps to implement some new sorting algorithm you want to try.
'!
!Core.SortAlgorithm categoriesForClass!Kernel-Objects! !
!Core.SortAlgorithm methodsFor!

compare: operand1 with: operand2 
	"Answer whether the <Object>, operand1, should sort before the <Object> argument, operand2,
	using the receiver's comparison method."

	^self sortBlock value: operand1 value: operand2!

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
			| a t i |
			a := anObject basicAt: j.
			i := j.
			[i <= startInteger or: [self compare: (t := anObject basicAt: i - 1) with: a]] whileFalse: 
					[anObject basicAt: i put: t.
					i := i - 1].
			anObject basicAt: i put: a]!

quicksortRecursionLimit: anInteger 
	^(2.0 * (anInteger log: 2)) floor!

sift: anObject from: anInteger between: startInteger and: stopInteger
	| val i |
	val := anObject basicAt: anInteger.
	i := anInteger.
	
	[| left right max j leftVal rightVal |
	max := val.
	j := i.
	left := j + j + 1 - startInteger.
	(left <= stopInteger and: [self compare: max with: (leftVal := anObject basicAt: left)])
		ifTrue: 
			[i := left.
			max := leftVal].
	right := left + 1.
	(right <= stopInteger and: [self compare: max with: (rightVal := anObject basicAt: right)])
		ifTrue: 
			[i := right.
			max := rightVal].
	i == j
		ifTrue: 
			[j > anInteger ifTrue: [anObject basicAt: j put: val].
			^self].
	anObject basicAt: j put: max]
			repeat!

sort: aCollection from: startInteger to: stopInteger
	"Sort elements in the range of indexable instance variables of the <Object> argument from
	startInteger through stopInteger to be non-descending according to the <DyadicValuable> sort
	block."

	^self subclassResponsibility!

sortBlock
	"Answer a <dyadicVariable> that implements the sort-order comparison in use by the receiver.
	Note that receiver may not actually use a block to perform comparisons, so the answer may
	not be the actual sort block, although in many cases it will be."

	^self subclassResponsibility! !
!Core.SortAlgorithm categoriesFor: #compare:with:!comparing!public! !
!Core.SortAlgorithm categoriesFor: #copyWithSortBlock:!copying!private! !
!Core.SortAlgorithm categoriesFor: #heapsort:from:to:!operations!private! !
!Core.SortAlgorithm categoriesFor: #insertionSort:from:to:!operations!private! !
!Core.SortAlgorithm categoriesFor: #quicksortRecursionLimit:!helpers!private! !
!Core.SortAlgorithm categoriesFor: #sift:from:between:and:!helpers!private! !
!Core.SortAlgorithm categoriesFor: #sort:from:to:!operations!public! !
!Core.SortAlgorithm categoriesFor: #sortBlock!accessing!public! !

!Core.SortAlgorithm class methodsFor!

defaultSort: aDyadicValuable
	^DefaultSortAlgorithm newSortBlock: aDyadicValuable!

introSort: aDyadicValuable
	^IntrosortAlgorithm newSortBlock: aDyadicValuable!

newSortBlock: aDyadicValuable
	^self subclassResponsibility! !
!Core.SortAlgorithm class categoriesFor: #defaultSort:!instance creation!public! !
!Core.SortAlgorithm class categoriesFor: #introSort:!instance creation!public! !
!Core.SortAlgorithm class categoriesFor: #newSortBlock:!instance creation!public! !

