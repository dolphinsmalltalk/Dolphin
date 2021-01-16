"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.STBTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.STBTest guid: (Core.GUID fromString: '{0e66d9d1-027f-4559-a87a-33e13ae709b8}')!
Kernel.Tests.STBTest comment: ''!
!Kernel.Tests.STBTest categoriesForClass!Unclassified! !
!Kernel.Tests.STBTest methodsFor!

testByteArray
	"#1483"

	#(#[] #[255] #[1 2] #[1 2 3 4 5]) do: 
			[:each |
			| a dessicated rehydrated s |
			s := 'abc'.
			a := {each. s. each. s. 'def'}.
			dessicated := a binaryStoreBytes.
			rehydrated := Object fromBinaryStoreBytes: dessicated.
			self assert: rehydrated equals: a.
			self assert: (rehydrated at: 1) identicalTo: (rehydrated at: 3).
			self assert: (rehydrated at: 2) identicalTo: (rehydrated at: 4).
			self deny: (rehydrated at: 1) identicalTo: each]!

testCharacters
	{$a.
		Character value: 128.
		Character value: 163.
		Character value: 255.
		$\x20AC.
		$\xCE0.
		$\x16F0.
		Character dolphin} do: 
				[:each |
				| dessicated rehydrated |
				dessicated := each binaryStoreBytes.
				rehydrated := Object fromBinaryStoreBytes: dessicated.
				self assert: rehydrated equals: each]!

testEmptyStream
	self should: [Object fromBinaryStoreBytes: #[]] raise: STBError!

testExistentClass
	| rehydrated dessicated |
	dessicated := self class binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: dessicated.
	self assert: rehydrated identicalTo: self class!

testInvalidStream
	self should: [Object fromBinaryStoreBytes: #[0 0 0 0 0]] raise: STBError!

testNonExistentClass
	| testClass |
	testClass := Object
				subclass: #STBTest_TestClass
				instanceVariableNames: 'a b c'
				classVariableNames: 'A B C'
				poolDictionaries: ''
				classInstanceVariableNames: ''.
	
	[| rehydrated dessicated |
	dessicated := testClass binaryStoreBytes.
	testClass removeFromSystem.
	testClass := nil.
	rehydrated := Object fromBinaryStoreBytes: dessicated.
	#{ClassStub}
		ifDefined: [:classStub | self assert: rehydrated classLocator key equals: 'STBTest_TestClass']
		ifNotDefined: 
			["The class cannot be found so will be resolved to nil. Ought to be an error really, but this is the historic behavior."
			self assert: rehydrated isNil]]
			ensure: [#{STBTest_TestClass} ifDefined: [:c | c removeFromSystem]]!

testSortedCollection
	| subject rehydrated dessicated sOriginal |
	subject := #('a' 'B' 'b' 'b' 'b' 'B' 'b' 'B' 'A' 'a' 'A' 'b')
				asSortedCollectionUsing: MergesortAlgorithm new.
	sOriginal := subject asArray.
	dessicated := subject binaryStoreBytes.
	"Mergesort is stable, so resorting should not affect the order at all."
	subject reSort.
	self assert: subject asArray equals: sOriginal.
	rehydrated := Object fromBinaryStoreBytes: dessicated.
	self assert: rehydrated asArray equals: sOriginal.
	"If we didn't preserve a stable sort, then the order or sort-equal elements may not be preserved."
	rehydrated reSort.
	self assert: rehydrated asArray equals: sOriginal!

testStrings
	(#(#[97 98 99 32 194 163 49 50] #[111 195 177 97] #[195 161 114 118 195 173 122 116 117 114 111 32 116 195 188 107 195 182 114 102 195 186 114 195 179 103 195 169 112] #[97 0 98] #[208 186 209 128 208 176 208 186 208 190 208 183 209 143 208 177 209 128 209 139] #[230 150 135 229 173 151 229 140 150 227 129 145] #[208 188 208 176 208 185 208 188 209 131 208 189 208 184 209 134 208 176] #[239 189 129 239 189 130 239 189 131])
		collect: [:each | Utf8String fromByteArray: each]) do: 
				[:each |
				| a dessicated rehydrated s |
				s := each asUtf16String.
				a := {each. s}.
				dessicated := a binaryStoreBytes.
				rehydrated := Object fromBinaryStoreBytes: dessicated.
				self assert: rehydrated equals: a.
				self assert: rehydrated first equals: each.
				self assert: rehydrated second equals: s]!

testSymbols
	"#1479"

	| a dessicated rehydrated s sym |
	sym := #testSymbols.
	s := 'a' , Character dolphin asUtf8String , 'Symbol'.
	a := {sym. s. sym. s. sym asString asSymbol. s asSymbol}.
	dessicated := a binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: dessicated.
	self assert: rehydrated equals: a.
	self assert: rehydrated first identicalTo: sym.
	self assert: (rehydrated at: 5) identicalTo: sym.
	self assert: (rehydrated at: 2) identicalTo: (rehydrated at: 4).
	self assert: (rehydrated at: 6) identicalTo: s asSymbol.

	"Try deserializing an old format stream"
	"#(#testSymbols 'abc' #testSymbols) binaryStoreBytes"
	dessicated := #[33 83 84 66 32 49 32 98 0 0 0 3 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 11 0 0 0 116 101 115 116 83 121 109 98 111 108 115 82 0 0 0 3 0 0 0 97 98 99 160 1 0 0].
	rehydrated := Object fromBinaryStoreBytes: dessicated.
	self assert: rehydrated equals: #(#testSymbols 'abc' #testSymbols).
	self assert: rehydrated first identicalTo: rehydrated last.
	self assert: rehydrated first identicalTo: #testSymbols!

testTranscript
	| stb i t |
	i := Transcript identityHash.
	stb := Transcript binaryStoreBytes.
	t := Object fromBinaryStoreBytes: stb.
	self assert: t identityHash equals: i.
	self assert: t identicalTo: Transcript! !
!Kernel.Tests.STBTest categoriesFor: #testByteArray!public!unit tests! !
!Kernel.Tests.STBTest categoriesFor: #testCharacters!public!unit tests! !
!Kernel.Tests.STBTest categoriesFor: #testEmptyStream!public!unit tests! !
!Kernel.Tests.STBTest categoriesFor: #testExistentClass!public!unit tests! !
!Kernel.Tests.STBTest categoriesFor: #testInvalidStream!public!unit tests! !
!Kernel.Tests.STBTest categoriesFor: #testNonExistentClass!public!unit tests! !
!Kernel.Tests.STBTest categoriesFor: #testSortedCollection!public!unit tests! !
!Kernel.Tests.STBTest categoriesFor: #testStrings!public!unit tests! !
!Kernel.Tests.STBTest categoriesFor: #testSymbols!public!unit tests! !
!Kernel.Tests.STBTest categoriesFor: #testTranscript!public!unit tests! !

