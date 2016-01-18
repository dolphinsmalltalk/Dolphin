"Filed out from Dolphin Smalltalk 7"!

SortAlgorithmTest subclass: #DefaultSortAlgorithmTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DefaultSortAlgorithmTest guid: (GUID fromString: '{71C746E5-EAD8-4695-8835-1778D1CA56FD}')!
DefaultSortAlgorithmTest comment: ''!
!DefaultSortAlgorithmTest categoriesForClass!Unclassified! !
!DefaultSortAlgorithmTest methodsFor!

add: aCollection sortBlock: block 
	| ms sorted collection |
	collection := aCollection asArray.
	sorted := block == SortedCollection defaultSortBlock 
				ifTrue: [SortedCollection new]
				ifFalse: [SortedCollection sortBlock: block].
	ms := Time 
				millisecondsToRun: [1 to: (collection size min: 5000) do: [:i | sorted add: (collection at: i)]].
	collection size > 500 
		ifTrue: 
			[Transcript
				nextPutAll: 'Added ';
				print: sorted size;
				nextPutAll: ' objects to a SortedCollection taking ';
				print: ms;
				nextPutAll: ' mS';
				cr;
				flush].
	self assertSorted: sorted!

algorithmToTest
	^DefaultSortAlgorithm!

sort: aCollection sortBlock: block 
	| ms sorted |
	ms := Time millisecondsToRun: 
					[sorted := block == SortedCollection defaultSortBlock 
								ifTrue: [aCollection asSortedCollection]
								ifFalse: [aCollection asSortedCollection: block]].
	aCollection size > 500 
		ifTrue: 
			[Transcript
				nextPutAll: 'Sorted collection of ';
				print: aCollection size;
				nextPutAll: ' objects taking ';
				print: ms;
				nextPutAll: ' mS';
				cr;
				flush].
	self assertSorted: sorted.
	self add: aCollection sortBlock: block.
	^sorted!

testBigStringSort
	self bigStringSort! !
!DefaultSortAlgorithmTest categoriesFor: #add:sortBlock:!helpers!private! !
!DefaultSortAlgorithmTest categoriesFor: #algorithmToTest!private!unit tests! !
!DefaultSortAlgorithmTest categoriesFor: #sort:sortBlock:!helpers!private! !
!DefaultSortAlgorithmTest categoriesFor: #testBigStringSort!public!unit tests! !

