"Filed out from Dolphin Smalltalk"!

SortAlgorithmTest subclass: #IntrosortAlgorithmTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IntrosortAlgorithmTest guid: (GUID fromString: '{95f49310-1090-4e7e-a46e-bc962a8ec984}')!
IntrosortAlgorithmTest comment: ''!
!IntrosortAlgorithmTest categoriesForClass!Unclassified! !
!IntrosortAlgorithmTest methodsFor!

algorithmToTest
	^IntrosortAlgorithm!

testNewSortBlock
	| algo1 algo2 block originalMethod testMethod |
	block := [:a :b | a < b].
	algo1 := self algorithmToTest newSortBlock: block.
	self assert: algo1 sortBlock identicalTo: block.
	originalMethod := self algorithmToTest class lookupMethod: #newSortBlock:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	algo2 := testMethod value: self algorithmToTest withArguments: {block}.
	self assert: algo2 sortBlock identicalTo: block! !
!IntrosortAlgorithmTest categoriesForMethods!
algorithmToTest!private!unit tests! !
testNewSortBlock!public!unit tests! !
!

