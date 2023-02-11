"Filed out from Dolphin Smalltalk"!

Kernel.Tests.AbstractSTBFilerTest subclass: #'Kernel.Tests.STBTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.STBTest guid: (Core.GUID fromString: '{0e66d9d1-027f-4559-a87a-33e13ae709b8}')!
Kernel.Tests.STBTest comment: ''!
!Kernel.Tests.STBTest methodsFor!

deserialize: aByteArray
	^Object fromBinaryStoreBytes: aByteArray!

serialize: anObject
	^anObject binaryStoreBytes!

testEmptyStream
	self should: [Object fromBinaryStoreBytes: #[]] raise: STBError!

testInvalidStream
	self should: [Object fromBinaryStoreBytes: #[0 0 0 0 0]] raise: STBError!

testStringUpgradeFromStbVersion0
	"In STB version 0, Strings were not special cased and so the class data would appear rather than just an index into the pre-registered classes. The binary data here is from Dolphin 5."

	| ansi |
	ansi := Object
				fromBinaryStoreBytes: #[33 83 84 66 32 48 32 54 0 6 0 83 116 114 105 110 103 9 0 0 0 163 53 32 97 32 112 105 110 116].
	self assert: ansi class identicalTo: AnsiString.
	self assert: ansi equals: '£5 a pint'!

testStringUpgradeFromStbVersion3
	"Upgrade a String saved prior to Unicode support, in this case from Dolphin 6."

	| ansi |
	ansi := Object
				fromBinaryStoreBytes: #[33 83 84 66 32 48 32 54 0 6 0 83 116 114 105 110 103 9 0 0 0 163 53 32 97 32 112 105 110 116].
	self assert: ansi class identicalTo: AnsiString.
	self assert: ansi equals: '£5 a pint'!

testSymbolUpgrade
	| rehydrated |
	"Try deserializing an old format stream"

	"#(#testSymbols 'abc' #testSymbols) binaryStoreBytes"
	rehydrated := Object
				fromBinaryStoreBytes: #[33 83 84 66 32 49 32 98 0 0 0 3 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 11 0 0 0 116 101 115 116 83 121 109 98 111 108 115 82 0 0 0 3 0 0 0 97 98 99 160 1 0 0].
	self assert: rehydrated equals: #(#testSymbols 'abc' #testSymbols).
	self assert: rehydrated first identicalTo: rehydrated last.
	self assert: rehydrated first identicalTo: #testSymbols.

	"A more tricky case with a non-ASCII char filed out from Dolphin 5 and 6.x"
	#(#[33 83 84 66 32 48 32 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 9 0 0 0 163 53 32 97 32 112 105 110 116] #[33 83 84 66 32 51 32 178 0 0 0 9 0 0 0 163 53 32 97 32 112 105 110 116])
		do: 
			[:each |
			rehydrated := Object fromBinaryStoreBytes: each.
			self assert: rehydrated identicalTo: #'£5 a pint'].

	"From Dolphin 7.1 - no upgrade required"
	rehydrated := Object
				fromBinaryStoreBytes: #[33 83 84 66 32 52 32 178 0 0 0 10 0 0 0 194 163 53 32 97 32 240 159 144 172].
	self assert: rehydrated identicalTo: #'£5 a 🐬'!

testUnicodeStringUpgrade
	"UnicodeString instances from versions of Dolphin prior to 7.1 should be read as Utf16String instances."

	"D5 (STB v0), D6.1 (STB v3)"

	#(#[33 83 84 66 32 48 32 54 0 13 0 85 110 105 99 111 100 101 83 116 114 105 110 103 14 0 0 0 163 0 53 0 32 0 97 0 32 0 61 216 44 220] #[33 83 84 66 32 51 32 54 0 13 0 85 110 105 99 111 100 101 83 116 114 105 110 103 14 0 0 0 163 0 53 0 32 0 97 0 32 0 61 216 44 220])
		do: 
			[:each |
			| utf16 |
			utf16 := Object fromBinaryStoreBytes: each.
			self assert: utf16 class identicalTo: Utf16String.
			self assert: utf16 equals: '£5 a 🐬']! !
!Kernel.Tests.STBTest categoriesForMethods!
deserialize:!helpers!private! !
serialize:!helpers!private! !
testEmptyStream!public!unit tests! !
testInvalidStream!public!unit tests! !
testStringUpgradeFromStbVersion0!public! !
testStringUpgradeFromStbVersion3!public! !
testSymbolUpgrade!public!unit tests! !
testUnicodeStringUpgrade!public!unit tests! !
!

