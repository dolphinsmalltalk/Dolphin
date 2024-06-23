"Filed out from Dolphin Smalltalk"!

Kernel.PluggableSortAlgorithm
	subclass: #'Kernel.InsertionSortAlgorithm'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.InsertionSortAlgorithm guid: (Core.GUID fromString: '{7d2cd205-0902-49b4-8198-38602100293d}')!

Kernel.InsertionSortAlgorithm comment: 'InsertionSortAlgorithm implements the simple Insertion Sort algorithm as a pluggable sorting strategy  for use in conjunction with <SortedCollection>s. 

Insertion sort is slow for anything but very small collections, or those which are already nearly sorted, where it is the sorting algorithm of choice.'!

!Kernel.InsertionSortAlgorithm categoriesForClass!Kernel-Objects! !

!Kernel.InsertionSortAlgorithm methodsFor!

sort: anObject from: startInteger to: stopInteger 
	"Sort elements in the range of indexable instance variables of the <Object> argument from
	startInteger through stopInteger to be non-descending according to the receiver's sort
	block."

	self 
		insertionSort: anObject
		from: startInteger
		to: stopInteger! !

!Kernel.InsertionSortAlgorithm categoriesForMethods!
sort:from:to:!operations!public! !
!

