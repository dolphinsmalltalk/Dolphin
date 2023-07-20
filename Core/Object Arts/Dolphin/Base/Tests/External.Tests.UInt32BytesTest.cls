"Filed out from Dolphin Smalltalk"!

External.Tests.IntegerBytesTest
	subclass: #'External.Tests.UInt32BytesTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.UInt32BytesTest guid: (Core.GUID fromString: '{df15ebf5-f6c2-4cd6-8d5a-59836c85f726}')!
External.Tests.UInt32BytesTest comment: ''!
!External.Tests.UInt32BytesTest methodsFor!

testStbRoundTrip
	| subject bytes rehydrated |
	subject := UInt32Bytes fromInteger: 16rDEADBEEF.
	bytes := subject binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: bytes.
	self assert: rehydrated size equals: 4.
	self assert: rehydrated class identicalTo: UInt32Bytes.
	self assert: rehydrated equals: subject! !
!External.Tests.UInt32BytesTest categoriesForMethods!
testStbRoundTrip!public! !
!

