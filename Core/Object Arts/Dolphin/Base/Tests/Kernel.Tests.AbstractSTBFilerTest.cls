"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.AbstractSTBFilerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.AbstractSTBFilerTest guid: (Core.GUID fromString: '{5927e3bd-eb27-4032-a460-08beb17878b3}')!
Kernel.Tests.AbstractSTBFilerTest isNonInstantiable: true!
Kernel.Tests.AbstractSTBFilerTest comment: ''!
!Kernel.Tests.AbstractSTBFilerTest methodsFor!

deserialize: aString
	^self subclassResponsibility!

serialize: anObject
	^self subclassResponsibility!

testByteArray
	"#1483"

	#(#[] #[255] #[1 2] #[1 2 3 4 5]) do: 
			[:each |
			| a dessicated rehydrated s |
			s := 'abc'.
			a := {each. s. each. s. 'def'}.
			dessicated := self serialize: a.
			rehydrated := self deserialize: dessicated.
			self assert: rehydrated equals: a.
			self assert: (rehydrated at: 1) identicalTo: (rehydrated at: 3).
			self assert: (rehydrated at: 2) identicalTo: (rehydrated at: 4).
			self deny: (rehydrated at: 1) identicalTo: each]!

testCharacters
	{$a.
		Character value: 128.
		Character value: 163.
		Character value: 255.
		$€.
		$\xCE0.
		$\x16F0.
		Character dolphin} do: 
				[:each |
				| dessicated rehydrated |
				dessicated := self serialize: each.
				rehydrated := self deserialize: dessicated.
				self assert: rehydrated equals: each]!

testEmptyStream
	self subclassResponsibility!

testExistentClass
	| rehydrated dessicated |
	dessicated := self serialize: self class.
	rehydrated := self deserialize: dessicated.
	self assert: rehydrated identicalTo: self class!

testInvalidStream
	self subclassResponsibility!

testMetaclass
	| rehydrated dessicated |
	dessicated :=self serialize: self class class.
	rehydrated := self deserialize: dessicated.
	self assert: rehydrated identicalTo: self class class!

testNonExistentClass
	| testClass |
	testClass := Object
				subclass: #STBTest_TestClass
				instanceVariableNames: 'a b c'
				classVariableNames: 'A B C'
				poolDictionaries: ''
				classInstanceVariableNames: ''.
	
	[| rehydrated dessicated |
	dessicated := self serialize: testClass.
	testClass removeFromSystem.
	testClass := nil.
	self verifyRehydrateNonExistantClass: dessicated]
			ensure: [#{STBTest_TestClass} ifDefined: [:c | c removeFromSystem]]!

testProcessor
	self verifyRoundTripSingleton: Processor!

testSortedCollection
	| subject rehydrated dessicated sOriginal |
	subject := #('a' 'B' 'b' 'b' 'b' 'B' 'b' 'B' 'A' 'a' 'A' 'b')
				asSortedCollectionUsing: MergesortAlgorithm new.
	sOriginal := subject asArray.
	dessicated := self serialize: subject.
	"Mergesort is stable, so resorting should not affect the order at all."
	subject reSort.
	self assert: subject asArray equals: sOriginal.
	rehydrated := self deserialize: dessicated.
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
				dessicated := self serialize: a.
				rehydrated := self deserialize: dessicated.
				self assert: rehydrated equals: a.
				self assert: rehydrated first equals: each.
				self assert: rehydrated second equals: s]!

testStringWithNulls
	| string |
	string := #($a $\0 $b) asString.
	{string asAnsiString. string asUtf8String. string asUtf16String} do: 
			[:each |
			| dessicated rehydrated |
			dessicated := self serialize: each.
			rehydrated := self deserialize: dessicated.
			self assert: rehydrated equals: each.
			self assert: rehydrated second identicalTo: $\0.
			self deny: rehydrated isImmutable]!

testSymbols
	"#1479"

	| a dessicated rehydrated s sym |
	sym := #testSymbols.
	s := 'a' , Character dolphin asUtf8String , 'Symbol'.
	a := {sym. s. sym. s. sym asString asSymbol. s asSymbol}.
	dessicated := self serialize: a.
	rehydrated := self deserialize: dessicated.
	self assert: rehydrated equals: a.
	self assert: rehydrated first identicalTo: sym.
	self assert: (rehydrated at: 5) identicalTo: sym.
	self assert: (rehydrated at: 2) identicalTo: (rehydrated at: 4).
	self assert: (rehydrated at: 6) identicalTo: s asSymbol!

testSystemDictionary
	self verifyRoundTripSingleton: Smalltalk!

testTranscript
	self verifyRoundTripSingleton: Transcript!

verifyRehydrateNonExistantClass: dessicated
	| rehydrated |
	rehydrated := self deserialize: dessicated.
	#{ClassStub}
		ifDefined: [:classStub | self assert: rehydrated classLocator key equals: 'STBTest_TestClass']
		ifNotDefined: 
			["The class cannot be found so will be resolved to nil. Ought to be an error really, but this is the historic behavior."
			self assert: rehydrated isNil]!

verifyRoundTripSingleton: anObject
	| dessicated array rehydrated |
	dessicated := self serialize: anObject.
	rehydrated := self deserialize: dessicated.
	self assert: rehydrated identicalTo: anObject.
	array := {anObject}.
	dessicated := self serialize: array.
	rehydrated := self deserialize: dessicated.
	self assert: rehydrated equals: array.
	self assert: rehydrated first identicalTo: anObject! !
!Kernel.Tests.AbstractSTBFilerTest categoriesForMethods!
deserialize:!helpers!private! !
serialize:!helpers!private! !
testByteArray!public!unit tests! !
testCharacters!public!unit tests! !
testEmptyStream!public!unit tests! !
testExistentClass!public!unit tests! !
testInvalidStream!public!unit tests! !
testMetaclass!public!unit tests! !
testNonExistentClass!public!unit tests! !
testProcessor!public!unit tests! !
testSortedCollection!public!unit tests! !
testStrings!public!unit tests! !
testStringWithNulls!public!unit tests! !
testSymbols!public!unit tests! !
testSystemDictionary!public!unit tests! !
testTranscript!public!unit tests! !
verifyRehydrateNonExistantClass:!helpers!private! !
verifyRoundTripSingleton:!helpers!private! !
!

