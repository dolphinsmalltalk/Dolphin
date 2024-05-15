"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ExternalIntegerBytesTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExternalIntegerBytesTest guid: (GUID fromString: '{ab593baa-2bef-4793-a647-ce2cc2e70e1a}')!

ExternalIntegerBytesTest isAbstract: true!

ExternalIntegerBytesTest comment: ''!

!ExternalIntegerBytesTest categoriesForClass!Unclassified! !

!ExternalIntegerBytesTest methodsFor!

integerValue
	^self subclassResponsibility!

subjectClass
	^self subclassResponsibility!

testStbRoundTrip
	| subject bytes rehydrated |
	subject := self subjectClass fromInteger: self integerValue.
	bytes := subject binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: bytes.
	self assert: rehydrated size equals: 4.
	self assert: rehydrated class identicalTo: self subjectClass.
	self assert: rehydrated equals: subject!

testStlRoundTrip
	| subject array rehydrated |
	subject := self subjectClass fromInteger: self integerValue.
	array := subject literalStoreArray.
	rehydrated := Object fromLiteralStoreArray: array.
	self assert: rehydrated size equals: 4.
	self assert: rehydrated class identicalTo: self subjectClass.
	self assert: rehydrated equals: subject! !

!ExternalIntegerBytesTest categoriesForMethods!
integerValue!constants!private! !
subjectClass!constants!private! !
testStbRoundTrip!public!unit tests! !
testStlRoundTrip!public!unit tests! !
!

