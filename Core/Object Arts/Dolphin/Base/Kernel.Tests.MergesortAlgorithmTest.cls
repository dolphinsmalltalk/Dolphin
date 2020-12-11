"Filed out from Dolphin Smalltalk 7"!

Kernel.Tests.StableSortAlgorithmTest subclass: #'Kernel.Tests.MergesortAlgorithmTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.MergesortAlgorithmTest guid: (Core.GUID fromString: '{0b95c1d0-7833-43d1-9d22-fa3129287940}')!
Kernel.Tests.MergesortAlgorithmTest comment: ''!
!Kernel.Tests.MergesortAlgorithmTest categoriesForClass!Unclassified! !
!Kernel.Tests.MergesortAlgorithmTest methodsFor!

algorithmToTest
	^MergesortAlgorithm!

testTempArrayLargeEnough
	| sorted |
	sorted := SortedCollection sortAlgorithm: self algorithmToTest new.
	sorted addAll: (100 to: 200).
	60 timesRepeat: [sorted removeFirst].
	sorted addAll: (130 to: 200).
	self assertSorted: sorted! !
!Kernel.Tests.MergesortAlgorithmTest categoriesFor: #algorithmToTest!private!unit tests! !
!Kernel.Tests.MergesortAlgorithmTest categoriesFor: #testTempArrayLargeEnough!public!unit tests! !

