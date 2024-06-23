"Filed out from Dolphin Smalltalk"!

Core.Tests.SortAlgorithmTest
	subclass: #'Kernel.Tests.ShellsortAlgorithmTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.ShellsortAlgorithmTest guid: (Core.GUID fromString: '{eb6e9370-5bed-4714-8b47-c9bd05d65ba6}')!

Kernel.Tests.ShellsortAlgorithmTest comment: ''!

!Kernel.Tests.ShellsortAlgorithmTest methodsFor!

algorithmToTest
	^ShellsortAlgorithm!

integerSortSize
	"Shell sort is slow, so be a bit less ambitious"

	^1000! !

!Kernel.Tests.ShellsortAlgorithmTest categoriesForMethods!
algorithmToTest!private!unit tests! !
integerSortSize!constants!private! !
!

