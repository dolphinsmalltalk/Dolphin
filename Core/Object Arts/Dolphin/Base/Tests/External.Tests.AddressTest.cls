"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'External.Tests.AddressTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.AddressTest guid: (Core.GUID fromString: '{55d8e17d-e5d8-4060-b20d-34dd8826180f}')!

External.Tests.AddressTest comment: ''!

!External.Tests.AddressTest methodsFor!

stringFromAddressTestClass: aStringClass
	| abc abc2 |
	abc := aStringClass fromString: 'abc'.
	abc2 := aStringClass fromAddress: abc yourAddress.
	self deny: abc identicalTo: abc2.
	self assert: abc asString equals: abc2 asString.
	abc := nil.
	MemoryManager current collectGarbage.
	self assert: abc2 asString equals: 'abc'!

testExternalAddressAtAddress
	self assert: (External.Address fromAddress: 1) asInteger equals: 1!

testExternalAddressFromAddress
	self assert: (External.Address fromAddress: 1) asInteger equals: 1!

testIsNonNullPointer
	self assert: nil isNull.
	self deny: #[1 2 3 4] isNull.
	self assert: 0 asExternalAddress isNull.
	self deny: 1 asExternalAddress isNull!

testREFGUIDfromAddress
	| g ref |
	g := GUID newUnique.
	ref := REFGUID fromAddress: g yourAddress.
	self assert: g equals: ref.
	self assert: g yourAddress equals: ref yourAddress.
	self assert: g asString equals: ref asString!

testStbRoundTrip
	| subject bytes rehydrated |
	subject := Address fromInteger: 16rDEADBEEF.
	bytes := subject binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: bytes.
	"Addresses are never saved in STB - we always get back nil"
	self assertIsNil: rehydrated!

testStringsFromAddress
	{AnsiString. Utf8String. Utf16String} do: 
			[:each |
			self stringFromAddressTestClass: each.
			self assertIsNil: (each fromAddress: nil).
			self assertIsNil: (each fromAddress: 0)]! !

!External.Tests.AddressTest categoriesForMethods!
stringFromAddressTestClass:!helpers!public! !
testExternalAddressAtAddress!public!unit tests! !
testExternalAddressFromAddress!public!unit tests! !
testIsNonNullPointer!public! !
testREFGUIDfromAddress!public!unit tests! !
testStbRoundTrip!public!unit tests! !
testStringsFromAddress!public!unit tests! !
!

