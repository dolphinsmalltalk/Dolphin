"Filed out from Dolphin Smalltalk 7"!

SortAlgorithmTest subclass: #ShellsortAlgorithmTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ShellsortAlgorithmTest guid: (GUID fromString: '{eb6e9370-5bed-4714-8b47-c9bd05d65ba6}')!
ShellsortAlgorithmTest comment: ''!
!ShellsortAlgorithmTest categoriesForClass!Unclassified! !
!ShellsortAlgorithmTest methodsFor!

algorithmToTest
	^ShellsortAlgorithm!

integerSortSize
	"Shell sort is slow, so be a bit less ambitious"

	^1000! !
!ShellsortAlgorithmTest categoriesFor: #algorithmToTest!private!unit tests! !
!ShellsortAlgorithmTest categoriesFor: #integerSortSize!constants!private! !

