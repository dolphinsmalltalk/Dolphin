"Filed out from Dolphin Smalltalk"!

Kernel.Tests.StableSortAlgorithmTest
	subclass: #'Kernel.Tests.MergesortAlgorithmTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.MergesortAlgorithmTest guid: (Core.GUID fromString: '{0b95c1d0-7833-43d1-9d22-fa3129287940}')!

Kernel.Tests.MergesortAlgorithmTest comment: ''!

!Kernel.Tests.MergesortAlgorithmTest methodsFor!

algorithmToTest
	^MergesortAlgorithm!

testBigStringSort
	<knownSlowTest>
	self bigStringSort!

testTempArrayLargeEnough
	| sorted |
	sorted := SortedCollection sortAlgorithm: self newTestSubject.
	sorted addAll: (100 to: 200).
	60 timesRepeat: [sorted removeFirst].
	sorted addAll: (130 to: 200).
	self assertSorted: sorted! !

!Kernel.Tests.MergesortAlgorithmTest categoriesForMethods!
algorithmToTest!private!unit tests! !
testBigStringSort!public! !
testTempArrayLargeEnough!public!unit tests! !
!

