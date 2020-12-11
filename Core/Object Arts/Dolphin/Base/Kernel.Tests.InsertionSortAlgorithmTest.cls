"Filed out from Dolphin Smalltalk 7"!

Kernel.Tests.StableSortAlgorithmTest subclass: #'Kernel.Tests.InsertionSortAlgorithmTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.InsertionSortAlgorithmTest guid: (Core.GUID fromString: '{6bc1bf9a-866d-4812-9e23-a22fa19d54c6}')!
Kernel.Tests.InsertionSortAlgorithmTest comment: ''!
!Kernel.Tests.InsertionSortAlgorithmTest categoriesForClass!Unclassified! !
!Kernel.Tests.InsertionSortAlgorithmTest methodsFor!

algorithmToTest
	^InsertionSortAlgorithm!

integerSortSize
	"Insertion sort is very slow, so be a bit less ambitious"

	^500! !
!Kernel.Tests.InsertionSortAlgorithmTest categoriesFor: #algorithmToTest!private!unit tests! !
!Kernel.Tests.InsertionSortAlgorithmTest categoriesFor: #integerSortSize!constants!private! !

