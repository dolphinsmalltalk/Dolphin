"Filed out from Dolphin Smalltalk"!

Core.Tests.SortAlgorithmTest subclass: #'Kernel.Tests.DefaultSortAlgorithmTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.DefaultSortAlgorithmTest guid: (Core.GUID fromString: '{71c746e5-ead8-4695-8835-1778d1ca56fd}')!
Kernel.Tests.DefaultSortAlgorithmTest comment: ''!
!Kernel.Tests.DefaultSortAlgorithmTest categoriesForClass!Unclassified! !
!Kernel.Tests.DefaultSortAlgorithmTest methodsFor!

add: aCollection sortBlock: block
	| duration sorted collection |
	collection := aCollection asArray.
	sorted := block == SortedCollection defaultSortBlock
				ifTrue: [SortedCollection new]
				ifFalse: [SortedCollection sortBlock: block].
	duration := [1 to: (collection size min: 5000) do: [:i | sorted add: (collection at: i)]] timeToRun.
	collection size > 500
		ifTrue: 
			[Transcript
				nextPutAll: 'Added ';
				print: sorted size;
				nextPutAll: ' objects to a SortedCollection taking ';
				display: duration;
				cr;
				flush].
	self assertSorted: sorted!

algorithmToTest
	^DefaultSortAlgorithm!

sort: aCollection sortBlock: block
	| duration sorted |
	duration := 
			[sorted := block == SortedCollection defaultSortBlock
						ifTrue: [aCollection asSortedCollection]
						ifFalse: [aCollection asSortedCollection: block]]
					timeToRun.
	aCollection size > 500
		ifTrue: 
			[Transcript
				nextPutAll: 'Sorted collection of ';
				print: aCollection size;
				nextPutAll: ' objects taking ';
				display: duration;
				cr;
				flush].
	self assertSorted: sorted.
	self add: aCollection sortBlock: block.
	^sorted! !
!Kernel.Tests.DefaultSortAlgorithmTest categoriesForMethods!
add:sortBlock:!helpers!private! !
algorithmToTest!private!unit tests! !
sort:sortBlock:!helpers!private! !
!

