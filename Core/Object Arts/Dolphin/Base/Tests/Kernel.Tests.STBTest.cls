"Filed out from Dolphin Smalltalk"!

Kernel.Tests.STxFilerTest
	subclass: #'Kernel.Tests.STBTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.STBTest guid: (Core.GUID fromString: '{0e66d9d1-027f-4559-a87a-33e13ae709b8}')!
Kernel.Tests.STBTest comment: ''!
!Kernel.Tests.STBTest methodsFor!

deserialize: aByteArray
	| objects |
	objects := (self newTestSubject: aByteArray) contents.
	^objects size = 1 ifTrue: [objects first] ifFalse: [objects]!

newTestSubject: aByteArray
	| stream |
	stream := aByteArray readStream.
	^STBInFiler on: stream!

serialize: anObject
	^anObject binaryStoreBytes!

testArrayClass0
	| bytes0 |
	bytes0 := #[33 83 84 66 32 48 32 14 1 13 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 5 0 0 0 65 114 114 97 121].
	self assert: (self deserialize: bytes0) identicalTo: Array!

testArrayClass5
	| bytes5 |
	bytes5 := #[33 83 84 66 32 53 32 96 0 0 0].
	self assert: (self deserialize: bytes5) identicalTo: Array!

testArrayMetaclass0
	| bytes0 |
	bytes0 := #[33 83 84 66 32 48 32 14 1 17 0 83 84 66 77 101 116 97 99 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 5 0 0 0 65 114 114 97 121].
	self assert: (self deserialize: bytes0) identicalTo: Array class!

testEggsBeforeChicken
	"In the original STB version, there was an obscure boundary case where String and STBClassFormat classes could not be deserialised from the STB bytes. This was fixed in v1 by pre-registering certain classes."

	| stream bytes subject |
	stream := ByteArray writeStream.
	subject := STBOutFiler on: stream.
	subject nextPut: STBClassProxy.
	subject nextPut: String.
	bytes := stream contents.
	self assert: (self deserialize: bytes) equals: { STBClassProxy. String }!

testEggsBeforeChickenVersion0
	"In the original STB version 0 format, String and STBClassProxy (the classes) could not be deserialised if it they were the first class appearing in the stream. If any other class appears beforehand, it was OK. This was a very obscure boundary condition and did not get fixed until Dolphin 5/6 when pre-registration of some classes was added."

	#(#[33 83 84 66 32 48 32 78 2 13 0 1 0 0 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 98 0 0 0 7 0 0 0 68 111 108 112 104 105 110 98 0 0 0 6 0 0 0 83 116 114 105 110 103] #[33 83 84 66 32 48 32 78 2 13 0 1 0 0 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 7 0 0 0 68 111 108 112 104 105 110 98 0 0 0 13 0 0 0 83 84 66 67 108 97 115 115 80 114 111 120 121])
		do: 
			[:each |
			self
				should: [self deserialize: each]
				raise: STBError
				matching: [:ex | ex description = 'STBFiler - STB input stream contains an invalid class reference (6)']]!

testEggsBeforeChickenVersion3
	self assert: (self deserialize: #[33 83 84 66 32 51 32 80 0 0 0]) equals: AnsiString!

testEmptyStream
	self should: [self deserialize: #[]] raise: STBError!

testInvalidStream
	self should: [self deserialize: #[0 0 0 0 0]] raise: STBError!

testStringUpgradeFromStbVersion0
	"In STB version 0, Strings were not special cased and so the class data would appear rather than just an index into the pre-registered classes. The binary data here is from Dolphin 5."

	| ansi |
	ansi := self
				deserialize: #[33 83 84 66 32 48 32 54 0 6 0 83 116 114 105 110 103 9 0 0 0 163 53 32 97 32 112 105 110 116].
	self assert: ansi class identicalTo: AnsiString.
	self assert: ansi equals: '£5 a pint'!

testStringUpgradeFromStbVersion3
	"Upgrade a String saved prior to Unicode support, in this case from Dolphin 6."

	| ansi |
	ansi := self
				deserialize: #[33 83 84 66 32 48 32 54 0 6 0 83 116 114 105 110 103 9 0 0 0 163 53 32 97 32 112 105 110 116].
	self assert: ansi class identicalTo: AnsiString.
	self assert: ansi equals: '£5 a pint'!

testSymbolUpgrade
	| rehydrated dessicated |
	"Try deserializing an old format stream"

	"#(#testSymbols 'abc' #testSymbols) binaryStoreBytes"
	dessicated := #[33 83 84 66 32 49 32 98 0 0 0 3 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 11 0 0 0 116 101 115 116 83 121 109 98 111 108 115 82 0 0 0 3 0 0 0 97 98 99 160 1 0 0].
	"Tools.STBDebugger dumpToTranscript: dessicated readStream"
	rehydrated := self deserialize: dessicated.
	self assert: rehydrated equals: #(#testSymbols 'abc' #testSymbols).
	self assert: rehydrated first identicalTo: rehydrated last.
	self assert: rehydrated first identicalTo: #testSymbols.

	"A more tricky case with a non-ASCII char filed out from Dolphin 5 and 6.x"
	#(#[33 83 84 66 32 48 32 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 9 0 0 0 163 53 32 97 32 112 105 110 116] #[33 83 84 66 32 51 32 178 0 0 0 9 0 0 0 163 53 32 97 32 112 105 110 116])
		do: 
			[:each |
			false ifTrue: [Tools.STBDebugger dumpToTranscript: each readStream].
			rehydrated := self deserialize: each.
			self assert: rehydrated identicalTo: #'£5 a pint'].

	"From Dolphin 7.1 - no upgrade required"
	rehydrated := self
				deserialize: #[33 83 84 66 32 52 32 178 0 0 0 10 0 0 0 194 163 53 32 97 32 240 159 144 172].
	self assert: rehydrated identicalTo: #'£5 a 🐬'!

testTruncatedHeader
	#(#[] #[33] #[33 83 84] #[33 83 84 66] #[33 83 84 66 48] #[33 83 84 66 32] #[33 83 84 66 32 32] #[33 83 84 66 32 48])
		do: 
			[:each |
			self
				should: [self deserialize: each]
				raise: STBError
				matching: [:ex | ex description = 'STBFiler - Input stream not in STB format']]!

testUnicodeStringUpgrade
	"UnicodeString instances from versions of Dolphin prior to 7.1 should be read as Utf16String instances."

	"D5 (STB v0), D6.1 (STB v3)"

	#(#[33 83 84 66 32 48 32 54 0 13 0 85 110 105 99 111 100 101 83 116 114 105 110 103 14 0 0 0 163 0 53 0 32 0 97 0 32 0 61 216 44 220] #[33 83 84 66 32 51 32 54 0 13 0 85 110 105 99 111 100 101 83 116 114 105 110 103 14 0 0 0 163 0 53 0 32 0 97 0 32 0 61 216 44 220])
		do: 
			[:each |
			| utf16 |
			utf16 := self deserialize: each.
			self assert: utf16 class identicalTo: Utf16String.
			self assert: utf16 equals: '£5 a 🐬']! !
!Kernel.Tests.STBTest categoriesForMethods!
deserialize:!helpers!private! !
newTestSubject:!helpers!private! !
serialize:!helpers!private! !
testArrayClass0!public!unit tests! !
testArrayClass5!public!unit tests! !
testArrayMetaclass0!public!unit tests! !
testEggsBeforeChicken!public!unit tests! !
testEggsBeforeChickenVersion0!public!unit tests! !
testEggsBeforeChickenVersion3!public!unit tests! !
testEmptyStream!public!unit tests! !
testInvalidStream!public!unit tests! !
testStringUpgradeFromStbVersion0!public! !
testStringUpgradeFromStbVersion3!public! !
testSymbolUpgrade!public!unit tests! !
testTruncatedHeader!public!unit tests! !
testUnicodeStringUpgrade!public!unit tests! !
!

