"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #STBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBTest guid: (GUID fromString: '{0E66D9D1-027F-4559-A87A-33E13AE709B8}')!
STBTest comment: ''!
!STBTest categoriesForClass!Unclassified! !
!STBTest methodsFor!

testByteArray
	"#1483"

	#(#[] #[255] #[1 2] #[1 2 3 4 5]) do: 
			[:each | 
			| a dessicated rehydrated s |
			s := 'abc'.
			a := Array 
						with: each
						with: s
						with: each
						with: s
						with: 'def'.
			dessicated := a binaryStoreBytes.
			rehydrated := Object fromBinaryStoreBytes: dessicated.
			self assert: rehydrated = a.
			self assert: (rehydrated at: 1) == (rehydrated at: 3).
			self assert: (rehydrated at: 2) == (rehydrated at: 4).
			self assert: (rehydrated at: 1) ~~ each]!

testSymbols
	"#1479"

	| a dessicated rehydrated s sym |
	sym := #testSymbols.
	s := 'abc'.
	a := Array 
				with: sym
				with: s
				with: sym
				with: s
				with: sym asString asSymbol.
	dessicated := a binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: dessicated.
	self assert: rehydrated = a.
	self assert: (rehydrated at: 1) == (rehydrated at: 3).
	self assert: (rehydrated at: 1) == (rehydrated at: 5).
	self assert: (rehydrated at: 2) == (rehydrated at: 4).
	self assert: (rehydrated at: 1) == sym.

	"Try deserializing an old format stream"
	"#(#testSymbols 'abc' #testSymbols) binaryStoreBytes"
	dessicated := #[33 83 84 66 32 49 32 98 0 0 0 3 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 11 0 0 0 116 101 115 116 83 121 109 98 111 108 115 82 0 0 0 3 0 0 0 97 98 99 160 1 0 0].
	rehydrated := Object fromBinaryStoreBytes: dessicated.
	self assert: rehydrated = #(#testSymbols 'abc' #testSymbols).
	self assert: rehydrated first == rehydrated last.
	self assert: rehydrated first == #testSymbols!

testTranscript
	| stb i t |
	i := Transcript identityHash.
	stb := Transcript binaryStoreBytes.
	t := Object fromBinaryStoreBytes: stb.
	self assert: t identityHash = i.
	self assert: t == Transcript! !
!STBTest categoriesFor: #testByteArray!public!unit tests! !
!STBTest categoriesFor: #testSymbols!public!unit tests! !
!STBTest categoriesFor: #testTranscript!public!unit tests! !

