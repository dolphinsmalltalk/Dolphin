"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'External.Tests.AddressTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.AddressTest guid: (Core.GUID fromString: '{55d8e17d-e5d8-4060-b20d-34dd8826180f}')!
External.Tests.AddressTest comment: ''!
!External.Tests.AddressTest categoriesForClass!Unclassified! !
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

testREFGUIDfromAddress
	| g ref |
	g := GUID newUnique.
	ref := REFGUID fromAddress: g yourAddress.
	self assert: g equals: ref.
	self assert: g yourAddress equals: ref yourAddress.
	self assert: g asString equals: ref asString!

testStringsFromAddress
	{AnsiString. Utf8String. Utf16String} do: 
			[:each |
			self stringFromAddressTestClass: each.
			self assertIsNil: (each fromAddress: nil).
			self assertIsNil: (each fromAddress: 0)]! !
!External.Tests.AddressTest categoriesFor: #stringFromAddressTestClass:!helpers!public! !
!External.Tests.AddressTest categoriesFor: #testExternalAddressAtAddress!public!unit tests! !
!External.Tests.AddressTest categoriesFor: #testExternalAddressFromAddress!public!unit tests! !
!External.Tests.AddressTest categoriesFor: #testREFGUIDfromAddress!public!unit tests! !
!External.Tests.AddressTest categoriesFor: #testStringsFromAddress!public!unit tests! !

