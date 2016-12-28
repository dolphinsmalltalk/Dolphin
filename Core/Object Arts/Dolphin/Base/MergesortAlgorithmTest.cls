"Filed out from Dolphin Smalltalk 7"!

StableSortAlgorithmTest subclass: #MergesortAlgorithmTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MergesortAlgorithmTest guid: (GUID fromString: '{0B95C1D0-7833-43D1-9D22-FA3129287940}')!
MergesortAlgorithmTest comment: ''!
!MergesortAlgorithmTest categoriesForClass!Unclassified! !
!MergesortAlgorithmTest methodsFor!

algorithmToTest
	^MergesortAlgorithm!

testTempArrayLargeEnough
	| sorted |
	sorted := SortedCollection sortAlgorithm: self algorithmToTest new.
	sorted addAll: (100 to: 200).
	60 timesRepeat: [sorted removeFirst].
	sorted addAll: (130 to: 200).
	self assertSorted: sorted! !
!MergesortAlgorithmTest categoriesFor: #algorithmToTest!private!unit tests! !
!MergesortAlgorithmTest categoriesFor: #testTempArrayLargeEnough!public!unit tests! !

