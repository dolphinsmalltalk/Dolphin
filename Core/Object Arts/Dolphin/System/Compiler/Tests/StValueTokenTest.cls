"Filed out from Dolphin Smalltalk"!

StTokenTest subclass: #StValueTokenTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StValueTokenTest guid: (GUID fromString: '{e1fb19ba-f9b5-4c51-b277-d6e1ffa5e66a}')!
StValueTokenTest isAbstract: true!
StValueTokenTest comment: ''!
!StValueTokenTest categoriesForClass!Unclassified! !
!StValueTokenTest methodsFor!

exampleSource
	^self subclassResponsibility!

exampleValue
	^self exampleSource!

testInstanceCreation
	| token token2 originalMethod testMethod |
	token := self subjectClass
				start: 5
				comments: nil
				value: self exampleValue.
	self assert: token isKindOf: self subjectClass.
	self assert: token start equals: 5.
	self assert: token stop equals: 5 + self exampleSource size - 1.
	self assertIsNil: token comments.
	self assert: token value equals: self exampleValue.
	"Now test that the Smalltalk backup code works without primitive: 157"
	originalMethod := self subjectClass class lookupMethod: #start:comments:value:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	token2 := testMethod value: self subjectClass withArguments: {20. nil. self exampleValue}.
	self assert: token isKindOf: self subjectClass.
	self assert: token2 start equals: 20.
	self assert: token2 stop equals: 20 + self exampleSource size - 1.
	self assertIsNil: token2 comments.
	self assert: token2 value equals: self exampleValue! !
!StValueTokenTest categoriesForMethods!
exampleSource!constants!private! !
exampleValue!constants!private! !
testInstanceCreation!public!unit tests! !
!

