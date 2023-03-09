"Filed out from Dolphin Smalltalk"!

Kernel.Tests.StLiteralTokenTest
	subclass: #'Kernel.Tests.StNumberLiteralTokenTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.StNumberLiteralTokenTest guid: (Core.GUID fromString: '{0b7f81b0-219f-40ce-9090-d116cb09e568}')!
Kernel.Tests.StNumberLiteralTokenTest comment: ''!
!Kernel.Tests.StNumberLiteralTokenTest methodsFor!

exampleSource
	^'16rCD'!

exampleValue
	^205!

subjectClass
	^StNumberLiteralToken!

testInstanceCreation
	| token token2 originalMethod testMethod |
	token := self subjectClass
				start: 5
				comments: nil
				value: self exampleValue
				stop: 9
				source: self exampleSource.
	self assert: token isLiteralToken.
	self assert: token start equals: 5.
	self assert: token stop equals: 9.
	self assertIsNil: token comments.
	self assert: token value equals: self exampleValue.
	self assert: token source equals: self exampleSource.
	"Now test that the Smalltalk backup code works without primitive: 157"
	originalMethod := self subjectClass class lookupMethod: #start:comments:value:stop:source:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	token2 := testMethod value: self subjectClass withArguments: #(20 nil 0.125 27 '0.0125e1').
	self assert: token2 isLiteralToken.
	self assert: token2 start equals: 20.
	self assert: token2 stop equals: 27.
	self assertIsNil: token2 comments.
	self assert: token2 value equals: 0.125! !
!Kernel.Tests.StNumberLiteralTokenTest categoriesForMethods!
exampleSource!public!unit tests! !
exampleValue!public!unit tests! !
subjectClass!constants!private! !
testInstanceCreation!public!unit tests! !
!

