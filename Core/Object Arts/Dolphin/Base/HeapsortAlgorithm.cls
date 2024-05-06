"Filed out from Dolphin Smalltalk"!

PluggableSortAlgorithm subclass: #HeapsortAlgorithm
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

HeapsortAlgorithm guid: (GUID fromString: '{a9b201d1-a115-446f-8b89-c41a55566130}')!

HeapsortAlgorithm comment: 'HeapsortAlgorithm implements the Heapsort algorithm as a sorting strategy for use in conjunction with <SortedCollection>s.

Heapsort is an in-place sort that requires only about O(N log N) to sort N items. Worst cases differ little from average, but it is slower than Quicksort on average.'!

!HeapsortAlgorithm categoriesForClass!Kernel-Objects! !

!HeapsortAlgorithm methodsFor!

sort: anObject from: startInteger to: stopInteger 
	"Sort elements in the range of indexable instance variables of the <Object> argument from
	startInteger through stopInteger to be non-descending according to the receiver's sort
	block."

	self 
		heapsort: anObject
		from: startInteger
		to: stopInteger! !

!HeapsortAlgorithm categoriesForMethods!
sort:from:to:!operations!public! !
!

