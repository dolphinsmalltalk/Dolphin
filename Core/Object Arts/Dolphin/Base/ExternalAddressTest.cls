"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ExternalAddressTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalAddressTest guid: (GUID fromString: '{55d8e17d-e5d8-4060-b20d-34dd8826180f}')!
ExternalAddressTest comment: ''!
!ExternalAddressTest categoriesForClass!Unclassified! !
!ExternalAddressTest methodsFor!

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
	self assert: (ExternalAddress fromAddress: 1) asInteger equals: 1!

testExternalAddressFromAddress
	self assert: (ExternalAddress fromAddress: 1) asInteger equals: 1!

testREFGUIDfromAddress
	| g ref |
	g := GUID newUnique.
	ref := REFGUID fromAddress: g yourAddress.
	self assert: g equals: ref.
	self assert: g yourAddress equals: ref yourAddress.
	self assert: g asString equals: ref asString!

testStringsFromAddress
	#(#{BSTR} #{AnsiString} #{Utf8String} #{Utf16String})
		do: [:each | self stringFromAddressTestClass: each value]! !
!ExternalAddressTest categoriesFor: #stringFromAddressTestClass:!helpers!public! !
!ExternalAddressTest categoriesFor: #testExternalAddressAtAddress!public!unit tests! !
!ExternalAddressTest categoriesFor: #testExternalAddressFromAddress!public!unit tests! !
!ExternalAddressTest categoriesFor: #testREFGUIDfromAddress!public!unit tests! !
!ExternalAddressTest categoriesFor: #testStringsFromAddress!public!unit tests! !

