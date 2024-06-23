"Filed out from Dolphin Smalltalk"!

Kernel.Tests.StValueTokenTest
	subclass: #'Kernel.Tests.StLiteralTokenTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.StLiteralTokenTest guid: (Core.GUID fromString: '{6c7db873-cac7-4f7a-96ec-691eaf779d2d}')!

Kernel.Tests.StLiteralTokenTest comment: ''!

!Kernel.Tests.StLiteralTokenTest methodsFor!

subjectClass
	^StLiteralToken!

testInstanceCreation
	| token token2 originalMethod testMethod |
	token := self subjectClass
				start: 5
				comments: nil
				value: 'abc'
				stop: 8.
	self assert: token isLiteralToken.
	self assert: token start equals: 5.
	self assert: token stop equals: 8.
	self assertIsNil: token comments.
	self assert: token value equals: 'abc'.
	"And the value: class method"
	token := self subjectClass value: 'abc'.
	self assert: token isLiteralToken.
	self assertIsNil: token start.
	self assertIsNil: token stop.
	self assertIsNil: token comments.
	self assert: token value equals: 'abc'.
	token := self subjectClass value: #('abc' 'def').
	self assert: token isLiteralToken.
	self assert: (token value allSatisfy: [:each | each isLiteralToken]).
	self assert: token value first value equals: 'abc'.

	"Now test that the Smalltalk backup code works without primitive: 157"
	originalMethod := self subjectClass class compiledMethodAt: #start:comments:value:stop:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	token2 := testMethod value: self subjectClass withArguments: #(20 nil #hello 25).
	self assert: token2 isLiteralToken.
	self assert: token2 start equals: 20.
	self assert: token2 stop equals: 25.
	self assertIsNil: token2 comments.
	self assert: token2 value equals: #hello! !

!Kernel.Tests.StLiteralTokenTest categoriesForMethods!
subjectClass!constants!private! !
testInstanceCreation!public!unit tests! !
!

