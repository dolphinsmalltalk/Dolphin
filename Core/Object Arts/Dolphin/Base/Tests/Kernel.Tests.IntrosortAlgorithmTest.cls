"Filed out from Dolphin Smalltalk"!

Core.Tests.SortAlgorithmTest subclass: #'Kernel.Tests.IntrosortAlgorithmTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.IntrosortAlgorithmTest guid: (Core.GUID fromString: '{95f49310-1090-4e7e-a46e-bc962a8ec984}')!
Kernel.Tests.IntrosortAlgorithmTest comment: ''!
!Kernel.Tests.IntrosortAlgorithmTest methodsFor!

algorithmToTest
	^IntrosortAlgorithm!

testBigStringSort
	self skipIfCiBuild. "Long running"
	self bigStringSort!

testNewSortBlock
	| algo1 algo2 block originalMethod testMethod |
	block := [:a :b | a < b].
	algo1 := self newTestSubject: block.
	self assert: algo1 sortBlock identicalTo: block.
	originalMethod := self algorithmToTest class lookupMethod: #newSortBlock:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	algo2 := testMethod value: self algorithmToTest withArguments: {block}.
	self assert: algo2 sortBlock identicalTo: block! !
!Kernel.Tests.IntrosortAlgorithmTest categoriesForMethods!
algorithmToTest!private!unit tests! !
testBigStringSort!public! !
testNewSortBlock!public!unit tests! !
!

