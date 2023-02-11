"Filed out from Dolphin Smalltalk"!

Core.Tests.SortAlgorithmTest subclass: #'Kernel.Tests.HeapsortAlgorithmTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.HeapsortAlgorithmTest guid: (Core.GUID fromString: '{7d774650-ec2f-46fa-acae-1f6c9a99ab42}')!
Kernel.Tests.HeapsortAlgorithmTest comment: ''!
!Kernel.Tests.HeapsortAlgorithmTest methodsFor!

algorithmToTest
	^HeapsortAlgorithm!

testBigStringSort
	self skipIfCiBuild. "Long running"
	self bigStringSort! !
!Kernel.Tests.HeapsortAlgorithmTest categoriesForMethods!
algorithmToTest!private!unit tests! !
testBigStringSort!public! !
!

