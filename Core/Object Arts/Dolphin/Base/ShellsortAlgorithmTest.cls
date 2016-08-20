"Filed out from Dolphin Smalltalk 7"!

SortAlgorithmTest subclass: #ShellsortAlgorithmTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ShellsortAlgorithmTest guid: (GUID fromString: '{EB6E9370-5BED-4714-8B47-C9BD05D65BA6}')!
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

