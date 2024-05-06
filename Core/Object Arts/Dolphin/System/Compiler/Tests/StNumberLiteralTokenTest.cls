"Filed out from Dolphin Smalltalk"!

StLiteralTokenTest subclass: #StNumberLiteralTokenTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StNumberLiteralTokenTest guid: (GUID fromString: '{0b7f81b0-219f-40ce-9090-d116cb09e568}')!

StNumberLiteralTokenTest comment: ''!

!StNumberLiteralTokenTest categoriesForClass!Unclassified! !

!StNumberLiteralTokenTest methodsFor!

subjectClass
	^StNumberLiteralToken!

testInstanceCreation
	| token token2 originalMethod testMethod |
	token := self subjectClass
				start: 5
				comments: nil
				value: 205
				stop: 9
				source: '16rCD'.
	self assert: token isLiteralToken.
	self assert: token start equals: 5.
	self assert: token stop equals: 9.
	self assertIsNil: token comments.
	self assert: token value equals: 205.
	self assert: token source equals: '16rCD'.
	"Now test that the Smalltalk backup code works without primitive: 157"
	originalMethod := self subjectClass class compiledMethodAt: #start:comments:value:stop:source:.
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
	self assert: token2 value equals: 0.125

! !

!StNumberLiteralTokenTest categoriesForMethods!
subjectClass!constants!private! !
testInstanceCreation!public!unit tests! !
!

