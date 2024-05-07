"Filed out from Dolphin Smalltalk"!

SortAlgorithmTest subclass: #DefaultSortAlgorithmTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DefaultSortAlgorithmTest guid: (GUID fromString: '{71c746e5-ead8-4695-8835-1778d1ca56fd}')!

DefaultSortAlgorithmTest comment: ''!

!DefaultSortAlgorithmTest categoriesForClass!Unclassified! !

!DefaultSortAlgorithmTest methodsFor!

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
				nextPutAll: ' objects to a SortedCollection taking '.
			duration printHumanReadableOn: Transcript.
			Transcript
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
				nextPutAll: ' objects taking '.
			duration printHumanReadableOn: Transcript.
			Transcript
				cr;
				flush].
	self assertSorted: sorted.
	self add: aCollection sortBlock: block.
	^sorted! !

!DefaultSortAlgorithmTest categoriesForMethods!
add:sortBlock:!helpers!private! !
algorithmToTest!private!unit tests! !
sort:sortBlock:!helpers!private! !
!

