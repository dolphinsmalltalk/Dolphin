"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'External.Tests.IntegerBytesTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.IntegerBytesTest guid: (Core.GUID fromString: '{d2ec9130-5bc5-4da7-8856-735f904ab458}')!

External.Tests.IntegerBytesTest isNonInstantiable: true!

External.Tests.IntegerBytesTest comment: ''!

!External.Tests.IntegerBytesTest methodsFor!

canonicalValue
	^self subclassResponsibility!

stlVersion4
	^self subclassResponsibility!

stlVersion6
	^self subclassResponsibility!

subjectClass
	^self subclassResponsibility!

testStbRoundTrip
	| subject bytes rehydrated |
	subject := self subjectClass fromInteger: self canonicalValue.
	bytes := subject binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: bytes.
	self assert: rehydrated size equals: self subjectClass elementSize.
	self assert: rehydrated class identicalTo: self subjectClass.
	self assert: rehydrated equals: subject!

testStlVersion4
	"STL 4 representation from D7 - the individual bytes are written to the stream"

	| subject stream |
	subject := Object fromLiteralStoreArray: self stlVersion4.
	self assert: subject size equals: self subjectClass elementSize.
	self assert: subject class identicalTo: self subjectClass.
	self assert: subject asInteger equals: self canonicalValue.
	stream := Array writeStream.
	(STLOutFiler4 on: stream) nextPut: subject.
	self assert: (STLPrinter printLiteralStoreArray: stream contents)
		equals: (STLPrinter printLiteralStoreArray: self stlVersion4)!

testStlVersion6
	"STL 6 representation from D8 - the bytes are written as a ByteArray. This is faster to read because it is precompiled. Note also that the class prefix doesn't encode the length of the class name as that is not needed"

	| subject stream |
	subject := Object fromLiteralStoreArray: self stlVersion6.
	self assert: subject size equals: self subjectClass elementSize.
	self assert: subject class identicalTo: self subjectClass.
	self assert: subject asInteger equals: self canonicalValue.
	stream := Array writeStream.
	(STLOutFiler on: stream) nextPut: subject.
	self assert: (STLPrinter printLiteralStoreArray: stream contents)
		equals: (STLPrinter printLiteralStoreArray: self stlVersion6)! !

!External.Tests.IntegerBytesTest categoriesForMethods!
canonicalValue!constants!private! !
stlVersion4!constants!private! !
stlVersion6!constants!private! !
subjectClass!constants!private! !
testStbRoundTrip!public!unit tests! !
testStlVersion4!public!unit tests! !
testStlVersion6!public!unit tests! !
!

