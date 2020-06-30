"Filed out from Dolphin Smalltalk 7"!

StableSortAlgorithmTest subclass: #MergesortAlgorithmTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MergesortAlgorithmTest guid: (GUID fromString: '{0b95c1d0-7833-43d1-9d22-fa3129287940}')!
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

