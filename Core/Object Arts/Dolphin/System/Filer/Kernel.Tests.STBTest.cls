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

deserialize: aByteArray version: anInteger
	| objects result inFiler |
	inFiler := self newInFilerOn: aByteArray.
	self assert: inFiler version equals: anInteger.
	objects := inFiler contents.
	result := objects size = 1 ifTrue: [objects first] ifFalse: [objects].
	self dumpToTranscriptIfDebug: aByteArray.
	^result!

infilerClass
	^STBInFiler!

minimumFilerVersion
	^0!

outfilerClass
	^STBOutFiler!

preUnicodeTestStrings
	^#(#[97 98 99 32 226 128 160 49 50] #[195 161 114 118 195 173 122 116 117 114 111 32 116 195 188 107 195 182 114 102 195 186 114 195 179 103 195 169 112] #[97 0 98])
		collect: [:each | Utf8String fromByteArray: each]!

serialize: anObject version: anInteger
	| bytes filer |
	filer := self newOutFilerVersion: anInteger.
	filer nextPut: anObject.
	bytes := filer stream contents.
	self dumpToTranscriptIfDebug: bytes.
	^bytes!

stxDebuggerClass
	^Tools.STBDebugger!

testArrayClass0
	| expectedBytes actualBytes |
	expectedBytes := #[33 83 84 66 32 48 32 78 2 13 0 1 0 0 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 7 0 0 0 68 111 108 112 104 105 110 114 0 0 0 5 0 0 0 65 114 114 97 121].
	self dumpToTranscriptIfDebug: expectedBytes.
	actualBytes := self serialize: Array version: 0.
	self assert: actualBytes equals: expectedBytes.
	self assert: (self deserialize: expectedBytes version: 0) identicalTo: Array!

testArrayClass1
	"Array binaryStoreBytes from STB 1"

	| expectedBytes actualBytes |
	expectedBytes := #[33 83 84 66 32 49 32 96 0 0 0].
	self dumpToTranscriptIfDebug: expectedBytes.
	actualBytes := self serialize: Array version: 1.
	self assert: actualBytes equals: expectedBytes.
	self assert: (self deserialize: expectedBytes version: 1)
		identicalTo: Array!

testArrayClass5
	"Array binaryStoreBytes from STB 5. Note that this only differs by STB version from STB 1 because Array is pre-registered."

	| expectedBytes actualBytes |
	expectedBytes := #[33 83 84 66 32 53 32 96 0 0 0].
	self dumpToTranscriptIfDebug: expectedBytes.
	actualBytes := self serialize: Array version: 5.
	self assert: actualBytes equals: expectedBytes.
	self assert: (self deserialize: expectedBytes version: 5)
		identicalTo: Array!

testArrayMetaclass0
	| actualBytes expectedBytes |
	expectedBytes := #[33 83 84 66 32 48 32 78 2 17 0 1 0 0 0 83 84 66 77 101 116 97 99 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 7 0 0 0 68 111 108 112 104 105 110 114 0 0 0 5 0 0 0 65 114 114 97 121].
	self dumpToTranscriptIfDebug: expectedBytes.
	actualBytes := self serialize: Array class version: 0.
	self dumpToTranscriptIfDebug: actualBytes.
	self assert: actualBytes equals: expectedBytes.
	self assert: (self deserialize: expectedBytes version: 0) identicalTo: Array class!

testClassProxy0
	"This is Array binaryStoreBytes from a very early Dolphin version with the original STBClassProxy that did not include a package name. The package name was added to support dynamic loading of binary packages for web applets, although it is redundant now really. In theory it could be used for on-demand loading of packages still. It does marginally increase the size of the STB stream, but each class is only written once."

	| expectedBytes |
	expectedBytes := #[33 83 84 66 32 48 32 14 1 13 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 5 0 0 0 65 114 114 97 121].
	self dumpToTranscriptIfDebug: expectedBytes.
	self assert: (self deserialize: expectedBytes version: 0)
		identicalTo: Array!

testEggsBeforeChicken
	"In the original STB version, there was an obscure boundary case where String and STBClassFormat classes could not be deserialised from the STB bytes. This was fixed in v1 by pre-registering certain classes."

	6 to: 1
		by: -1
		do: [:ver | self verifyEggsBeforeChicken: ver]!

testEggsBeforeChickenVersion0
	"In the original STB version 0 format, String and STBClassProxy (the classes) could not be deserialised if it they were the first class appearing in the stream. If any other class appears beforehand, it was OK. This was a very obscure boundary condition and did not get fixed until Dolphin 5/6 when pre-registration of some classes was added."

	| stringClassBytes newStringClassBytes |
	stringClassBytes := #[33 83 84 66 32 48 32 78 2 13 0 1 0 0 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 98 0 0 0 7 0 0 0 68 111 108 112 104 105 110 98 0 0 0 6 0 0 0 83 116 114 105 110 103].
	self dumpToTranscriptIfDebug: stringClassBytes.
	newStringClassBytes := self serialize: String version: 0.
	self assert: newStringClassBytes equals: stringClassBytes.
	{
		newStringClassBytes.
		#[33 83 84 66 32 48 32 78 2 13 0 1 0 0 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 7 0 0 0 68 111 108 112 104 105 110 98 0 0 0 13 0 0 0 83 84 66 67 108 97 115 115 80 114 111 120 121]
	} do: 
				[:each |
				self
					should: [self deserialize: each version: 0]
					raise: STBError
					matching: [:ex | ex description = 'STBFiler - STB input stream contains an invalid class reference: 6']]!

testEggsBeforeChickenVersion1
	"In STB version 1, some classes were pre-registered. This was not only more compact, but fixed the boundary cases of trying to serialize String class and a few others."

	| expectedBytes actualBytes |
	expectedBytes := #[33 83 84 66 32 49 32 80 0 0 0].
	self dumpToTranscriptIfDebug: expectedBytes.
	actualBytes := self serialize: AnsiString version: 1.
	self assert: actualBytes equals: expectedBytes.
	"String was actually written, but this was equivalent to the AnsiString of D7.1 and later"
	self assert: (self deserialize: actualBytes version: 1) equals: AnsiString!

testEmptyStream
	self should: [self deserialize: #[] version: self outfilerClass version] raise: STBError!

testGlobalProxyingVersion0
	"Pre-D8 STB/STL had a mechanism from the early Dolphin days, added to support binary packages, that installed global variables (i.e. created variables in Smalltalk). This used the STBGlobalObjectProxy and STBOutFiler>>#register:asGlobal:. It hasn't been used by the base system for many years, but remained present long after it should really have been removed. It is now deprecated: The version 6 filers do not support it, although previous version object streams containing uses can be read (and written)."

	| stb0 deserialised filer object serialised |
	stb0 := #[33 83 84 66 32 48 32 14 2 20 0 83 84 66 71 108 111 98 97 108 79 98 106 101 99 116 80 114 111 120 121 0 0 0 0 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 3 0 0 0 70 111 111 146 0 0 0 3 0 0 0 66 97 114 90 0 0 0 0 0 0 0 122 0 0 0 0 0 0 0 146 0 0 0 3 0 0 0 66 97 114 0 0 0 0].
	self assert: (Tools.STBDebugger dump: stb0 readStream)
		equals: 'STB version 0:
000007 [STBGlobalObjectProxy;]
000035     [STBSymbolProxy;]
000057         [String;0] 10: ''Foo''
000074     [String] 11: ''Bar''

000085 [STBGlobalObjectProxy]
000093     [STBSymbolProxy]
000101         [String] 14: ''Bar''
000112     [<0: nil>]
End of 7 objects'.
	"Verify that we can write it in exactly the same form as the original (from Dolphin 2.0)"
	filer := self newOutFilerVersion: 0.
	object := 'Bar' copy.
	filer register: object asGlobal: #Foo.
	filer nextPut: object.
	"Also the ability to translate the next nil to a global (can't remember what that was for)"
	filer
		register: nil asGlobal: #Bar;
		nextPut: nil.
	serialised := filer stream contents.
	self assert: serialised equals: stb0.
	
	[deserialised := self deserialize: stb0 version: 0.
	self assert: deserialised equals: { 'Bar'. nil }.
	self assert: (Smalltalk includesKey: #Foo).
	self assert: (Smalltalk at: #Foo) equals: 'Bar'.
	self assert: (Smalltalk includesKey: #Bar).
	self assertIsNil: (Smalltalk at: #Bar)]
			ensure: [#(#Foo #Bar) do: [:each | Smalltalk removeKey: each ifAbsent: []]]!

testGlobalProxyingVersion1
	| stb1 deserialised filer object serialised |
	stb1 := #[33 83 84 66 32 49 32 14 2 20 0 83 84 66 71 108 111 98 97 108 79 98 106 101 99 116 80 114 111 120 121 0 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 3 0 0 0 70 111 111 82 0 0 0 3 0 0 0 66 97 114 154 1 0 0 0 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 3 0 0 0 66 97 114 0 0 0 0].
	self assert: (Tools.STBDebugger dump: stb1 readStream)
		equals: 'STB version 1:
000007 [STBGlobalObjectProxy;]
000035     [STBSymbolProxy]
000043         [String] 28: ''Foo''
000054     [String] 29: ''Bar''

000065 [STBGlobalObjectProxy]
000073     [STBSymbolProxy]
000081         [String] 32: ''Bar''
000092     [<0: nil>]
End of 7 objects'.
	"Verify that we can write it in exactly the same form as the original (from Dolphin 2.0)"
	filer := self newOutFilerVersion: 1.
	object := 'Bar' copy.
	filer register: object asGlobal: #Foo.
	filer nextPut: object.
	"Also the ability to translate the next nil to a global (can't remember what that was for)"
	filer
		register: nil asGlobal: #Bar;
		nextPut: nil.
	serialised := filer stream contents.
	self assert: serialised equals: stb1.
	
	[deserialised := self deserialize: stb1 version: 1.
	self assert: deserialised equals: { 'Bar'. nil }.
	self assert: (Smalltalk includesKey: #Foo).
	self assert: (Smalltalk at: #Foo) equals: 'Bar'.
	self assert: (Smalltalk includesKey: #Bar).
	self assertIsNil: (Smalltalk at: #Bar)]
			ensure: [#(#Foo #Bar) do: [:each | Smalltalk removeKey: each ifAbsent: []]]!

testGlobalProxyingVersion3
	| stb3 deserialised filer object serialised |
	stb3 := #[33 83 84 66 32 51 32 14 2 20 0 83 84 66 71 108 111 98 97 108 79 98 106 101 99 116 80 114 111 120 121 178 0 0 0 3 0 0 0 70 111 111 82 0 0 0 3 0 0 0 66 97 114 154 1 0 0 178 0 0 0 3 0 0 0 66 97 114 0 0 0 0].
	self assert: (Tools.STBDebugger dump: stb3 readStream)
		equals: 'STB version 3:
000007 [STBGlobalObjectProxy;]
000031     [Symbol] 27: #Foo
000042     [String] 28: ''Bar''

000053 [STBGlobalObjectProxy]
000057     [Symbol] 30: #Bar
000068     [<0: nil>]
End of 5 objects'.
	"Note that proxying of global nils was actually broken in D6 due to an optimisation added for writing nils, so this content was created with a patch in D6."
	filer := self newOutFilerVersion: 3.
	object := 'Bar' copy.
	filer register: object asGlobal: #Foo.
	filer nextPut: object.
	"Also the ability to translate the next nil to a global (can't remember what that was for)"
	filer
		register: nil asGlobal: #Bar;
		nextPut: nil.
	serialised := filer stream contents.
	self assert: serialised equals: stb3.
	
	[deserialised := self deserialize: stb3 version: 3.
	self assert: deserialised equals: { 'Bar'. nil }.
	self assert: (Smalltalk includesKey: #Foo).
	self assert: (Smalltalk at: #Foo) equals: 'Bar'.
	self assert: (Smalltalk includesKey: #Bar).
	self assertIsNil: (Smalltalk at: #Bar)]
			ensure: [#(#Foo #Bar) do: [:each | Smalltalk removeKey: each ifAbsent: []]]!

testGlobalProxyingVersion4
	| stb4 deserialised filer object serialised |
	stb4 := #[33 83 84 66 32 52 32 14 2 20 0 83 84 66 71 108 111 98 97 108 79 98 106 101 99 116 80 114 111 120 121 178 0 0 0 3 0 0 0 70 111 111 82 0 0 0 3 0 0 0 66 97 114 154 1 0 0 178 0 0 0 3 0 0 0 66 97 114 0 0 0 0].
	self assert: (Tools.STBDebugger dump: stb4 readStream)
		equals: 'STB version 4:
000007 [STBGlobalObjectProxy;]
000031     [Symbol] 27: #Foo
000042     [AnsiString] 28: ''Bar''

000053 [STBGlobalObjectProxy]
000057     [Symbol] 30: #Bar
000068     [<0: nil>]
End of 5 objects'.
	"Note that proxying of global nils was actually broken in D7 due to an optimisation added for writing nils, so this content was created with a patch in D7.1"
	filer := self newOutFilerVersion: 4.
	object := 'Bar' copy asAnsiString.
	filer register: object asGlobal: #Foo.
	filer nextPut: object.
	"Also the ability to translate the next nil to a global (can't remember what that was for)"
	filer
		register: nil asGlobal: #Bar;
		nextPut: nil.
	serialised := filer stream contents.
	"	(Tools.STBDebugger dump: serialised readStream)
STB version 4:
000007 [STBGlobalObjectProxy;]
000031     [Symbol] 27: #Foo
000042     [AnsiString] 28: 'Bar'

000053 [STBGlobalObjectProxy]
000057     [Symbol] 30: #Bar
000068     [<0: nil>]
End of 30 objects
"
	self assert: serialised equals: stb4.
	
	[deserialised := self deserialize: stb4 version: 4.
	self assert: deserialised equals: { 'Bar'. nil }.
	self assert: (Smalltalk includesKey: #Foo).
	self assert: (Smalltalk at: #Foo) equals: 'Bar'.
	self assert: (Smalltalk includesKey: #Bar).
	self assertIsNil: (Smalltalk at: #Bar)]
			ensure: [#(#Foo #Bar) do: [:each | Smalltalk removeKey: each ifAbsent: []]]!

testInvalidStream
	self should: [self deserialize: #[0 0 0 0 0] version: self outfilerClass version] raise: STBError!

testLargeIntegers0
	| expectedBytes actualBytes rehydrated array |
	expectedBytes := #[33 83 84 66 32 48 32 38 0 5 0 65 114 114 97 121 2 0 0 0 54 0 12 0 76 97 114 103 101 73 110 116 101 103 101 114 12 0 0 0 0 0 0 0 0 0 0 128 0 0 0 0 114 0 0 0 8 0 0 0 0 0 0 0 0 0 0 128].
	self dumpToTranscriptIfDebug: expectedBytes.
	array := #(9223372036854775808 -9223372036854775808).
	actualBytes := self serialize: array version: 0.
	self assert: actualBytes equals: expectedBytes.
	rehydrated := self deserialize: expectedBytes version: 0.
	self assert: rehydrated equals: array!

testLargeIntegers1to4
	1 to: 4 do: [:ver | self verifyLargeIntegersAtVersion: ver]!

testMetaclassProxy0
	"As testClassProxy0, early STBMetaclassProxy without package name. Obviously STB version 0 too. This is just `Array class binaryStoreBytes` from a very early Dolphin beta version"

	| bytes0 |
	bytes0 := #[33 83 84 66 32 48 32 14 1 17 0 83 84 66 77 101 116 97 99 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 5 0 0 0 65 114 114 97 121].
	self dumpToTranscriptIfDebug: bytes0.
	self assert: (self deserialize: bytes0 version: 0) identicalTo: Array class!

testProcessor0
	"(Array with: Processor with: Processor) binaryStoreBytes"
	self verifyRoundTripSingleton: Processor version: 0
		expected: #[33 83 84 66 32 48 32 38 0 5 0 65 114 114 97 121 2 0 0 0 64 0 0 0 64 0 0 0]!

testProcessor1
	"(Array with: Processor with: Processor) binaryStoreBytes"
	self verifyRoundTripSingleton: Processor version: 1
		expected:#[33 83 84 66 32 49 32 98 0 0 0 2 0 0 0 64 0 0 0 64 0 0 0]!

testProcessor3
	"(Array with: Processor with: Processor) binaryStoreBytes"
	self verifyRoundTripSingleton: Processor version: 3
		expected: #[33 83 84 66 32 51 32 98 0 0 0 2 0 0 0 64 0 0 0 64 0 0 0]!

testSmallInteger
	0 to: STBOutFiler version
		do: 
			[:ver |
			| expectedBytes actualBytes rehydrated |
			expectedBytes := #[33 83 84 66 32 0 32 247 0 0 0] copy
						at: 6 put: $0 asciiValue + ver;
						yourself.
			self dumpToTranscriptIfDebug: expectedBytes.
			actualBytes := self serialize: 123 version: ver.
			self assert: actualBytes equals: expectedBytes.
			rehydrated := self deserialize: expectedBytes version: ver.
			self assert: rehydrated identicalTo: 123]!

testStringsVersion0
	| expectedBytes actualBytes ansi unicode rehydrated array |
	expectedBytes := #[33 83 84 66 32 48 32 38 0 5 0 65 114 114 97 121 4 0 0 0 54 0 6 0 83 116 114 105 110 103 3 0 0 0 97 134 98 54 0 13 0 85 110 105 99 111 100 101 83 116 114 105 110 103 4 0 0 0 61 216 44 220 128 0 0 0 160 0 0 0].
	self dumpToTranscriptIfDebug: expectedBytes.
	"We use $† (U+2020) because it is an extended character but is common to Windows code pages as code unit 134. This should prevent sensitivity to the OS code page, but just in case we skip if it does not convert as expected."
	ansi := 'a†b'.
	self skipUnless: [ansi asAnsiString asByteArray = #[97 134 98]].
	unicode := Character dolphin asUtf16String.
	array := { ansi. unicode. ansi. unicode }.
	actualBytes := self serialize: array version: 0.
	self assert: actualBytes equals: expectedBytes.
	rehydrated := self deserialize: expectedBytes version: 0.
	self assert: rehydrated equals: array.
	"AnsiStrings get converted to Utf8Strings"
	self assert: rehydrated first isKindOf: Utf8String.
	self assert: rehydrated second isKindOf: Utf16String.
	self assert: rehydrated first identicalTo: rehydrated third.
	self assert: rehydrated second identicalTo: rehydrated fourth.
	self verifyStringsAtPreUnicodeVersion: 0!

testStringsVersion1
	| expectedBytes ansi unicode array actualBytes rehydrated |
	expectedBytes := #[33 83 84 66 32 49 32 98 0 0 0 4 0 0 0 82 0 0 0 3 0 0 0 97 134 98 54 0 13 0 85 110 105 99 111 100 101 83 116 114 105 110 103 4 0 0 0 61 216 44 220 160 1 0 0 192 1 0 0].
	self dumpToTranscriptIfDebug: expectedBytes.
	ansi := 'a†b'.	"We use $† (U+2020) because it is an extended character but is common to Windows code pages as code unit 134. This should prevent sensitivity to the OS code page, but just in case we skip if it does not convert as expected."
	self skipUnless: [ansi asAnsiString asByteArray = #[97 134 98]].
	unicode := Character dolphin asUtf16String.
	array := { ansi. unicode. ansi. unicode }.
	actualBytes := self serialize: array version: 1.
	self assert: actualBytes equals: expectedBytes.
	rehydrated := self deserialize: expectedBytes version: 1.
	self assert: rehydrated equals: array.
	self assert: rehydrated first isKindOf: AnsiString.
	self assert: rehydrated second isKindOf: Utf16String.
	self assert: rehydrated first identicalTo: rehydrated third.
	self assert: rehydrated second identicalTo: rehydrated fourth.
	self verifyStringsAtPreUnicodeVersion: 1!

testStringsVersion2
	self verifyStringsAtPreUnicodeVersion: 2!

testStringsVersion4
	| expectedBytes ansi utf8 utf16 array actualBytes rehydrated |
	expectedBytes := #[33 83 84 66 32 52 32 98 0 0 0 6 0 0 0 82 0 0 0 3 0 0 0 97 134 98 18 1 0 0 5 0 0 0 97 226 128 160 98 18 1 0 0 5 0 0 0 97 226 128 160 98 160 1 0 0 176 1 0 0 18 1 0 0 5 0 0 0 97 226 128 160 98].
	self dumpToTranscriptIfDebug: expectedBytes.
	utf8 := 'a†b'.	"We use $† (U+2020) because it is an extended character but is common to Windows code pages as code unit 134. This should prevent sensitivity to the OS code page, but just in case we skip if it does not convert as expected."
	ansi := utf8 asAnsiString.
	self skipUnless: [ansi asAnsiString asByteArray = #[97 134 98]].
	utf16 := utf8 asUtf16String.
	array := { ansi. utf8. utf16. ansi. utf8. utf16 }.
	actualBytes := self serialize: array version: 4.
	"The bytes will not be identical because at present Dolphin 7.1 has a bug that it doesn't preserve the identity of Utf16Strings when translating to Utf8Strings. This is fixed in D8, and the result is compatible and can be read by D7.1"
	self deny: actualBytes equals: expectedBytes.
	rehydrated := self deserialize: actualBytes version: 4.
	self assert: rehydrated equals: array.
	self assert: rehydrated first isKindOf: AnsiString.
	self assert: rehydrated second isKindOf: Utf8String.
	self assert: rehydrated third isKindOf: Utf8String.
	1 to: 3 do: [:i | self assert: (rehydrated at: i) identicalTo: (rehydrated at: i + 3)]!

testSymbolsVersion0
	"Symbols were represented by STBSymbolProxy instances originally"

	| rehydrated expectedBytes actualBytes |
	"#(#foo #bar #foo) binaryStoreBytes"
	expectedBytes := #[33 83 84 66 32 48 32 38 0 5 0 65 114 114 97 121 3 0 0 0 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 3 0 0 0 102 111 111 122 0 0 0 0 0 0 0 146 0 0 0 3 0 0 0 98 97 114 128 0 0 0].
	self dumpToTranscriptIfDebug: expectedBytes.
	actualBytes := self serialize: #(#foo #bar #foo) version: 0.
	self assert: actualBytes equals: expectedBytes.
	rehydrated := self deserialize: actualBytes version: 0.
	self assert: rehydrated equals: #(#foo #bar #foo).
	self assert: rehydrated first identicalTo: #foo.
	self assert: rehydrated last identicalTo: #foo.
	self assert: rehydrated second identicalTo: #bar!

testSymbolsVersion1
	"Symbols were represented by STBSymbolProxy instances originally"

	| rehydrated expectedBytes actualBytes |
	"#(#foo #bar #foo) binaryStoreBytes"
	expectedBytes := #[33 83 84 66 32 49 32 98 0 0 0 3 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 3 0 0 0 102 111 111 186 0 0 0 0 0 0 0 82 0 0 0 3 0 0 0 98 97 114 160 1 0 0].
	self dumpToTranscriptIfDebug: expectedBytes.
	actualBytes := self serialize: #(#foo #bar #foo) version: 1.
	self assert: actualBytes equals: expectedBytes.
	rehydrated := self deserialize: actualBytes version: 1.
	self assert: rehydrated equals: #(#foo #bar #foo).
	self assert: rehydrated first identicalTo: #foo.
	self assert: rehydrated last identicalTo: #foo.
	self assert: rehydrated second identicalTo: #bar!

testSymbolsVersion3
	"Symbols not proxied"

	| rehydrated expectedBytes actualBytes |
	"#(#foo #bar #foo) binaryStoreBytes"
	expectedBytes := #[33 83 84 66 32 51 32 98 0 0 0 3 0 0 0 178 0 0 0 3 0 0 0 102 111 111 178 0 0 0 3 0 0 0 98 97 114 160 1 0 0].
	self dumpToTranscriptIfDebug: expectedBytes.
	actualBytes := self serialize: #(#foo #bar #foo) version: 3.
	self assert: actualBytes equals: expectedBytes.
	rehydrated := self deserialize: actualBytes version: 3.
	self assert: rehydrated equals: #(#foo #bar #foo).
	self assert: rehydrated first identicalTo: #foo.
	self assert: rehydrated last identicalTo: #foo.
	self assert: rehydrated second identicalTo: #bar!

testSymbolUpgrade
	| rehydrated dessicated |
	"Try deserializing an old format stream"

	"#(#testSymbols 'abc' #testSymbols) binaryStoreBytes"
	dessicated := #[33 83 84 66 32 49 32 98 0 0 0 3 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 11 0 0 0 116 101 115 116 83 121 109 98 111 108 115 82 0 0 0 3 0 0 0 97 98 99 160 1 0 0].
	rehydrated := self deserialize: dessicated version: 1.
	self assert: rehydrated equals: #(#testSymbols 'abc' #testSymbols).
	self assert: rehydrated first identicalTo: rehydrated last.
	self assert: rehydrated first identicalTo: #testSymbols.

	"From Dolphin 7.1 - no upgrade required. UTF-8 encoded symbols, so works with $£ regardless of code page."
	rehydrated := self
				deserialize: #[33 83 84 66 32 52 32 178 0 0 0 10 0 0 0 194 163 53 32 97 32 240 159 144 172]
				version: 4.
	self assert: rehydrated identicalTo: #'£5 a 🐬'.

	"A more tricky case with a non-ASCII char filed out from Dolphin 4 and 5.x. The first is STB 0, and usea a STBSymbolProxy. The STB 1 stream no longer uses the proxy so is more compact, but the string representation is still Ansi code page dependent"
	 rehydrated := self deserialize: #[33 83 84 66 32 48 32 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 3 0 0 0 97 134 98] version: 0.
	self assert: rehydrated identicalTo: #'a†b'.
	rehydrated := self deserialize: #[33 83 84 66 32 49 32 186 0 0 0 0 0 0 0 82 0 0 0 3 0 0 0 97 134 98] version: 1.
	self assert: rehydrated identicalTo: #'a†b'.!

testTranscript0
	"Dolphin 4.x and earlier did not actually serialize Transcript specially, just as any other Presenter instance. They will be able to deserialize this correctly into `(Array with: Transcript with: Transcript)` though."

	self
		verifyRoundTripSingleton: Transcript
		version: 0
		expected: #[33 83 84 66 32 48 32 38 0 5 0 65 114 114 97 121 2 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 0 0 0 0 78 2 13 0 1 0 0 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 18 0 0 0 68 111 108 112 104 105 110 32 84 114 97 110 115 99 114 105 112 116 178 0 0 0 15 0 0 0 84 114 97 110 115 99 114 105 112 116 83 104 101 108 108 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 178 0 0 0 7 0 0 0 99 117 114 114 101 110 116 128 0 0 0]!

testTranscript1
	"Dolphin 5.x did not actually serialize Transcript specially, just as any other Presenter instance. They will be able to deserialize this correctly into `(Array with: Transcript with: Transcript)` though."

	self
		verifyRoundTripSingleton: Transcript
		version: 1
		expected: #[33 83 84 66 32 49 32 98 0 0 0 2 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 0 0 0 0 154 0 0 0 0 0 0 0 82 0 0 0 18 0 0 0 68 111 108 112 104 105 110 32 84 114 97 110 115 99 114 105 112 116 82 0 0 0 15 0 0 0 84 114 97 110 115 99 114 105 112 116 83 104 101 108 108 186 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 99 117 114 114 101 110 116 176 1 0 0]!

testTranscript3
	"Dolphin 6.x did serialize Transcript specially using an STBSingletonProxy."

	self
		verifyRoundTripSingleton: Transcript
		version: 3
		expected: #[33 83 84 66 32 51 32 98 0 0 0 2 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 154 0 0 0 82 0 0 0 18 0 0 0 68 111 108 112 104 105 110 32 84 114 97 110 115 99 114 105 112 116 82 0 0 0 15 0 0 0 84 114 97 110 115 99 114 105 112 116 83 104 101 108 108 178 0 0 0 7 0 0 0 99 117 114 114 101 110 116 176 1 0 0]!

testTruncatedHeader
	#(#[] #[33] #[33 83 84] #[33 83 84 66] #[33 83 84 66 48] #[33 83 84 66 32] #[33 83 84 66 32 32] #[33 83 84 66 32 48])
		do: 
			[:each |
			self
				should: [self deserialize: each version: self outfilerClass version]
				raise: STBError
				matching: [:ex | ex description = 'STBFiler - Input stream not in STB format']]!

testUnicodeStringUpgrade0
	"UnicodeString instances from versions of Dolphin prior to 7.1 should be read as Utf16String instances."

	"D5 (STB v0)"

	| bytes utf16 |
	bytes := #[33 83 84 66 32 48 32 54 0 13 0 85 110 105 99 111 100 101 83 116 114 105 110 103 14 0 0 0 163 0 53 0 32 0 97 0 32 0 61 216 44 220].
	utf16 := self deserialize: bytes version: 0.
	self assert: utf16 class identicalTo: Utf16String.
	self assert: utf16 equals: '£5 a 🐬'!

testUnicodeStringUpgrade3
	"UnicodeString instances from versions of Dolphin prior to 7.1 should be read as Utf16String instances."

	"D6.1 (STB v3)"

	| bytes utf16 |
	bytes := #[33 83 84 66 32 51 32 54 0 13 0 85 110 105 99 111 100 101 83 116 114 105 110 103 14 0 0 0 163 0 53 0 32 0 97 0 32 0 61 216 44 220].
	utf16 := self deserialize: bytes version: 3.
	self assert: utf16 class identicalTo: Utf16String.
	self assert: utf16 equals: '£5 a 🐬'!

testUnicodeStringVersion0
	| expectedBytes actualBytes |
	expectedBytes := #[33 83 84 66 32 48 32 54 0 13 0 85 110 105 99 111 100 101 83 116 114 105 110 103 6 0 0 0 97 0 98 0 99 0].
	self dumpToTranscriptIfDebug: expectedBytes.
	"We can recreate version 0 format"
	actualBytes := self serialize: 'abc' asUtf16String version: 0.
	self assert: actualBytes equals: expectedBytes.
	self assert: (self deserialize: actualBytes version: 0) equals: 'abc'.
	self verifyStringsAtPreUnicodeVersion: 0!

testVariableBindingsVersion1
	| expected actual rehydrated array |
	expected := #[33 83 84 66 32 49 32 98 0 0 0 2 0 0 0 6 2 11 0 65 115 115 111 99 105 97 116 105 111 110 0 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 6 0 0 0 79 98 106 101 99 116 154 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 68 111 108 112 104 105 110 82 0 0 0 6 0 0 0 79 98 106 101 99 116 162 1 0 0 0 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 9 0 0 0 80 114 111 99 101 115 115 111 114 64 0 0 0].
	self dumpToTranscriptIfDebug: expected.
	array := { Object binding. #{Processor} binding }.
	actual := self serialize: array version: 1.
	self assert: actual equals: expected.
	rehydrated := self deserialize: expected version: 1.
	self assert: rehydrated first equals: array first key -> array first value.
	self assert: rehydrated last equals: array last key -> array last value!

testVariableBindingsVersion4
	self
		verifyVariableBindings: #[33 83 84 66 32 52 32 98 0 0 0 3 0 0 0 6 2 15 0 86 97 114 105 97 98 108 101 66 105 110 100 105 110 103 178 0 0 0 6 0 0 0 79 98 106 101 99 116 154 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 6 0 0 0 79 98 106 101 99 116 162 1 0 0 18 1 0 0 8 0 0 0 80 97 103 101 83 105 122 101 1 64 0 0 162 1 0 0 178 0 0 0 9 0 0 0 80 114 111 99 101 115 115 111 114 64 0 0 0]
		version: 4!

testVariableBindingsVersion5
	"STB5 is from earlier Dolphin 8, and has STB v2 VariableBindings with environment and flags."

	self
		verifyVariableBindings: #[33 83 84 66 32 53 32 98 0 0 0 3 0 0 0 70 4 22 0 2 0 0 0 75 101 114 110 101 108 46 86 97 114 105 97 98 108 101 66 105 110 100 105 110 103 178 0 0 0 6 0 0 0 79 98 106 101 99 116 146 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 11 0 0 0 67 111 114 101 46 79 98 106 101 99 116 146 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 4 0 0 0 67 111 114 101 1 0 0 0 162 1 0 0 18 1 0 0 8 0 0 0 80 97 103 101 83 105 122 101 1 64 0 0 146 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 15 0 0 0 67 111 114 101 46 70 105 108 101 83 116 114 101 97 109 5 0 0 0 162 1 0 0 178 0 0 0 9 0 0 0 80 114 111 99 101 115 115 111 114 64 0 0 0 0 2 0 0 1 0 0 0]
		version: 5!

verifyEggsBeforeChicken: ver
	| bytes subject stream |
	stream := ByteArray writeStream.
	subject := self outfilerClass on: stream version: ver.
	subject nextPut: STBClassProxy.
	subject nextPut: String.
	bytes := stream contents.
	self dumpToTranscriptIfDebug: bytes.
	^self assert: (self deserialize: bytes version: ver) equals: { STBClassProxy. String }!

verifyLargeIntegersAtVersion: anInteger
	| actualBytes array rehydrated expectedBytes |
	expectedBytes := #[33 83 84 66 32 49 32 98 0 0 0 2 0 0 0 130 0 0 0 12 0 0 0 0 0 0 0 0 0 0 128 0 0 0 0 130 0 0 0 8 0 0 0 0 0 0 0 0 0 0 128]
				copy.
	expectedBytes at: 6 put: $0 codeUnit + anInteger.
	self dumpToTranscriptIfDebug: expectedBytes.
	array := #(9223372036854775808 -9223372036854775808).
	actualBytes := self serialize: array version: anInteger.
	self assert: actualBytes equals: expectedBytes.
	rehydrated := self deserialize: expectedBytes version: anInteger.
	^self assert: rehydrated equals: array!

verifyStringsAtPreUnicodeVersion: anInteger
	super verifyStringsAtPreUnicodeVersion: anInteger.
	self verifyString: '🐬' atVersion: anInteger! !

!Kernel.Tests.STBTest categoriesForMethods!
deserialize:version:!helpers!private! !
infilerClass!constants!public! !
minimumFilerVersion!constants!private! !
outfilerClass!constants!public! !
preUnicodeTestStrings!helpers!private! !
serialize:version:!helpers!private! !
stxDebuggerClass!helpers!private! !
testArrayClass0!public!unit tests! !
testArrayClass1!public!unit tests! !
testArrayClass5!public!unit tests! !
testArrayMetaclass0!public!unit tests! !
testClassProxy0!public!unit tests! !
testEggsBeforeChicken!public!unit tests! !
testEggsBeforeChickenVersion0!public!unit tests! !
testEggsBeforeChickenVersion1!public!unit tests! !
testEmptyStream!public!unit tests! !
testGlobalProxyingVersion0!public!unit tests! !
testGlobalProxyingVersion1!public!unit tests! !
testGlobalProxyingVersion3!public!unit tests! !
testGlobalProxyingVersion4!public!unit tests! !
testInvalidStream!public!unit tests! !
testLargeIntegers0!public!unit tests! !
testLargeIntegers1to4!public!unit tests! !
testMetaclassProxy0!public!unit tests! !
testProcessor0!public!unit tests! !
testProcessor1!public!unit tests! !
testProcessor3!public!unit tests! !
testSmallInteger!public!unit tests! !
testStringsVersion0!public!unit tests! !
testStringsVersion1!public!unit tests! !
testStringsVersion2!public!unit tests! !
testStringsVersion4!public!unit tests! !
testSymbolsVersion0!public!unit tests! !
testSymbolsVersion1!public!unit tests! !
testSymbolsVersion3!public!unit tests! !
testSymbolUpgrade!public!unit tests! !
testTranscript0!public!unit tests! !
testTranscript1!public!unit tests! !
testTranscript3!public!unit tests! !
testTruncatedHeader!public!unit tests! !
testUnicodeStringUpgrade0!public!unit tests! !
testUnicodeStringUpgrade3!public!unit tests! !
testUnicodeStringVersion0!public!unit tests! !
testVariableBindingsVersion1!public!unit tests! !
testVariableBindingsVersion4!public!unit tests! !
testVariableBindingsVersion5!public!unit tests! !
verifyEggsBeforeChicken:!helpers!private! !
verifyLargeIntegersAtVersion:!helpers!private! !
verifyStringsAtPreUnicodeVersion:!helpers!private! !
!

