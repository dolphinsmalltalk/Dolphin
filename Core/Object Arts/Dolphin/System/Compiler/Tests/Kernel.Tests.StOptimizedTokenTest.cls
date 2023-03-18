"Filed out from Dolphin Smalltalk"!

Kernel.Tests.StTokenTest
	subclass: #'Kernel.Tests.StOptimizedTokenTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.StOptimizedTokenTest guid: (Core.GUID fromString: '{9b15fc9c-7c2c-41cb-b2b9-7a8e037ee1be}')!
Kernel.Tests.StOptimizedTokenTest comment: ''!
!Kernel.Tests.StOptimizedTokenTest methodsFor!

subjectClass
	^StOptimizedToken!

testInstanceCreation
	| token token2 originalMethod testMethod |
	token := self subjectClass
				start: 1
				comments: nil
				stop: 3.
	self assert: token isOptimized.
	self assert: token start equals: 1.
	self assert: token stop equals: 3.
	self assertIsNil: token comments.
	"Now test that the Smalltalk backup code works without primitive: 157"
	originalMethod := self subjectClass class compiledMethodAt: #start:comments:stop:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	token2 := testMethod value: self subjectClass withArguments: #(20 nil 22).
	self assert: token2 start equals: 20.
	self assert: token2 stop equals: 22.
	self assert: token2 comments equals: nil! !
!Kernel.Tests.StOptimizedTokenTest categoriesForMethods!
subjectClass!constants!private! !
testInstanceCreation!public!unit tests! !
!

