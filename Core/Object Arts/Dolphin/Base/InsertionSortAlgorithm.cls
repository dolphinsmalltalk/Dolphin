"Filed out from Dolphin Smalltalk"!

PluggableSortAlgorithm subclass: #InsertionSortAlgorithm
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InsertionSortAlgorithm guid: (GUID fromString: '{7d2cd205-0902-49b4-8198-38602100293d}')!
InsertionSortAlgorithm comment: 'InsertionSortAlgorithm implements the simple Insertion Sort algorithm as a pluggable sorting strategy  for use in conjunction with <SortedCollection>s. 

Insertion sort is slow for anything but very small collections, or those which are already nearly sorted, where it is the sorting algorithm of choice.'!
!InsertionSortAlgorithm categoriesForClass!Kernel-Objects! !
!InsertionSortAlgorithm methodsFor!

sort: anObject from: startInteger to: stopInteger 
	"Sort elements in the range of indexable instance variables of the <Object> argument from
	startInteger through stopInteger to be non-descending according to the receiver's sort
	block."

	self 
		insertionSort: anObject
		from: startInteger
		to: stopInteger! !
!InsertionSortAlgorithm categoriesForMethods!
sort:from:to:!operations!public! !
!

