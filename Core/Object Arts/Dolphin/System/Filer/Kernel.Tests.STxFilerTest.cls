"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.STxFilerTest'
	instanceVariableNames: ''
	classVariableNames: 'TestVar'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.STxFilerTest guid: (Core.GUID fromString: '{5927e3bd-eb27-4032-a460-08beb17878b3}')!
Kernel.Tests.STxFilerTest isNonInstantiable: true!
Kernel.Tests.STxFilerTest comment: ''!
!Kernel.Tests.STxFilerTest methodsFor!

deserialize: aString version: anInteger
	^self subclassResponsibility!

dumpToTranscript: aByteArray
	self stxDebuggerClass dumpToTranscript: aByteArray readStream!

dumpToTranscriptIfDebug: serializedData
	self isDebug ifTrue: [self dumpToTranscript: serializedData]!

infilerClass
	^self subclassResponsibility!

minimumFilerVersion
	^self subclassResponsibility!

newInFilerOn: anArray
	^self infilerClass on: anArray readStream!

newOutFilerVersion: anInteger
	^self outfilerClass version: anInteger!

outfilerClass
	^self subclassResponsibility!

preUnicodeTestStrings
	^self subclassResponsibility!

serialize: anObject
	^self serialize: anObject version: self outfilerClass version!

serialize: anObject version: anInteger
	^self subclassResponsibility!

stxDebuggerClass
	^self subclassResponsibility!

testAddresses
	"Addresses should always be replaced by nil"

	| object dessicated rehydrated |
	object := Address fromInteger: 16rDEADBEEF.
	dessicated := self serialize: object.
	rehydrated := self deserialize: dessicated version: self outfilerClass version.
	self assertIsNil: rehydrated!

testBindingReferences
	"BindingReferences are a special case because they are used to represent classes in the literal array in STL 5, as well as themselves. This is to test that binding references can themselves be round tripped and don't get dereferenced when they should not be."

	5 to: self outfilerClass version do: [:ver | self verifyBindingReferencesAtVersion: 5]!

testByteArrays
	"#1483"

	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifyByteArraysAtVersion: ver]!

testCharacters
	| characters |
	characters := {
				$a.
				Character value: 128.
				Character value: 163.
				Character value: 255.
				$€.
				$\xCE0.
				$\x16F0.
				Character dolphin
			}.
	characters do: 
			[:each |
			| dessicated rehydrated |
			dessicated := self serialize: each.
			rehydrated := self deserialize: dessicated version: self outfilerClass version.
			self assert: rehydrated equals: each].
	self assert: (self deserialize: (self serialize: characters) version: self outfilerClass version)
		equals: characters!

testDictionary
	self minimumFilerVersion to: self outfilerClass version
		do: [:ver | self verifyDictionaries: Dictionary atVersion: ver]!

testEmptyStream
	self subclassResponsibility!

testExistentClass
	| rehydrated dessicated |
	dessicated := self serialize: self class.
	rehydrated := self deserialize: dessicated version: self outfilerClass version.
	self assert: rehydrated identicalTo: self class!

testExternalResourceLibrary
	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifyResourceLibraryAtVersion: ver]!

testFloats
	self minimumFilerVersion to: self outfilerClass version do: [:ver | self verifyFloatsAtVersion: ver]!

testHandles
	"Handles should always be replaced by nil"

	| object dessicated rehydrated |
	object := Handle fromInteger: 16rDEADBEEF.
	dessicated := self serialize: object.
	rehydrated := self deserialize: dessicated version: self outfilerClass version.
	self assertIsNil: rehydrated!

testIntegerBytes
	"IntegerBytes is a subclass of ByteArray, which has special handling for STB"

	| object dessicated rehydrated |
	object := UInt32Bytes fromInteger: 16rDEADBEEF.
	dessicated := self serialize: object.
	rehydrated := self deserialize: dessicated version: self outfilerClass version.
	self assert: rehydrated equals: object!

testInvalidStream
	self subclassResponsibility!

testLookupTable
	self minimumFilerVersion to: self outfilerClass version
		do: [:ver | self verifyLookupTablesAtVersion: ver]!

testMetaclass
	| rehydrated dessicated |
	dessicated := self serialize: self class class.
	rehydrated := self deserialize: dessicated version: self outfilerClass version.
	self assert: rehydrated identicalTo: self class class!

testNonExistentClass
	| testClass |
	testClass := Object
				subclass: #STBTest_TestClass
				instanceVariableNames: 'a b c'
				classVariableNames: 'A B C'
				poolDictionaries: ''
				classInstanceVariableNames: ''.
	
	[| dessicated dessicatedInstance |
	dessicated := self serialize: testClass.
	dessicatedInstance := self serialize: testClass new.
	testClass removeFromSystem.
	testClass := nil.
	self verifyRehydrateNonExistantClass: dessicated.
	self should: [self deserialize: dessicatedInstance version: self outfilerClass version]
		raise: NotFoundError]
			ensure: [#{STBTest_TestClass} ifDefined: [:c | c removeFromSystem]]!

testOrderedCollections
	self minimumFilerVersion to: self outfilerClass version
		do: [:ver | self verifyOrderedCollectionsAtVersion: ver]!

testPoolDictionary
	self outfilerClass version to: self minimumFilerVersion by: -1
		do: [:ver | self verifyDictionaries: PoolDictionary atVersion: ver]!

testProcessor
	"Special case global variable that has a pre-allocated reference index in STB (and STL prior to v6)."

	self minimumFilerVersion to: self outfilerClass version
		do: [:ver | self verifyRoundTripSingleton: Processor version: ver]!

testSaveStaticVariableReference
	"Requires BindingReferences, not available before v5"

	self minimumFilerVersion to: 4
		do: 
			[:ver |
			self
				should: [(self newOutFilerVersion: ver) saveStatic: #{TestVar}]
				raise: STBError
				matching: 
					[:ex |
					ex description = ('STBFiler - Static variable references are not supported in <2d> version <1d>'
								<< { ver. self outfilerClass stxFormatName })]].
	5 to: self outfilerClass version do: [:ver | self verifySaveStaticVariableReferenceAtVersion: ver]!

testScaledDecimals
	self minimumFilerVersion to: self outfilerClass version do: [:ver | self verifyScaledDecimalsAtVersion: ver]!

testSets
	self minimumFilerVersion to: self outfilerClass version
		do: [:ver | self verifySetsAtVersion: ver]!

testSmalltalk
	"Special case global variable"

	self minimumFilerVersion to: self outfilerClass version
		do: [:ver | self verifyRoundTripSingleton: Smalltalk version: ver]!

testSortedCollections
	| subject rehydrated dessicated sOriginal |
	subject := #('a' 'B' 'b' 'b' 'b' 'B' 'b' 'B' 'A' 'a' 'A' 'b')
				asSortedCollectionUsing: MergesortAlgorithm new.
	sOriginal := subject asArray.
	dessicated := self serialize: subject.
	"Mergesort is stable, so resorting should not affect the order at all."
	subject reSort.
	self assert: subject asArray equals: sOriginal.
	rehydrated := self deserialize: dessicated version: self outfilerClass version.
	self assert: rehydrated asArray equals: sOriginal.
	"If we didn't preserve a stable sort, then the order or sort-equal elements may not be preserved."
	rehydrated reSort.
	self assert: rehydrated asArray equals: sOriginal!

testStrings
	self verifyStringsAtVersion: self outfilerClass version!

testStringsVersion3
	self verifyStringsAtPreUnicodeVersion: 3!

testStringsVersion4
	self verifyStringsAtVersion: 4.
	"Strings with embedded nulls can be round tripped in STB 4"
	self verifyString: #[97 0 98] asUtf8String atVersion: 4!

testStringsVersion5
	self verifyStringsAtVersion: 5.
	"Strings with embedded nulls can be round tripped"
	self verifyString: #[97 0 98] asUtf8String atVersion: 5!

testStringWithNulls
	| string |
	string := #($a $\0 $b) asString.
	{ string asAnsiString. string asUtf8String. string asUtf16String } do: 
			[:each |
			| dessicated rehydrated |
			dessicated := self serialize: each.
			rehydrated := self deserialize: dessicated version: self outfilerClass version.
			self assert: rehydrated equals: each.
			self assert: rehydrated second identicalTo: $\0.
			self deny: rehydrated isImmutable]!

testSymbols
	"#1479"

	self minimumFilerVersion to: STLOutFiler version do: [:ver | self verifySymbolsAtVersion: ver]!

testSystemDictionary
	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifyRoundTripSingleton: Smalltalk version: ver]!

testTranscript
	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifyTranscriptRoundTripAtVersion: ver]!

testVariableBinding
	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifyVariableBindingsAtVersion: ver]!

testVariableBindingsVersion4
	self subclassResponsibility!

testVariableBindingsVersion5
	self subclassResponsibility!

verifyBindingReferencesAtVersion: anInteger
	| array assoc ref dessicated rehydrated |
	ref := #{Core.Object}.
	dessicated := self serialize: ref version: anInteger.
	rehydrated := self deserialize: dessicated version: anInteger.
	self assert: rehydrated class identicalTo: FullBindingReference.
	self assert: rehydrated equals: ref.
	array := { ref. 2. ref }.
	dessicated := self serialize: array version: anInteger.
	rehydrated := self deserialize: dessicated version: anInteger.
	self assert: rehydrated first class identicalTo: FullBindingReference.
	self assert: rehydrated last identicalTo: rehydrated first.
	self assert: rehydrated equals: array.
	assoc := ref -> Object.
	dessicated := self serialize: assoc version: anInteger.
	rehydrated := self deserialize: dessicated version: anInteger.
	self assert: rehydrated key class identicalTo: FullBindingReference.
	self assert: rehydrated key equals: ref.
	self assert: rehydrated value identicalTo: Object!

verifyByteArraysAtVersion: anInteger
	#(#[] #[255] #[1 2] #[1 2 3 4 5]) do: 
			[:each |
			| a dessicated rehydrated s |
			s := 'abc'.
			a := { each. s. each. s. 'def' }.
			dessicated := self serialize: a version: anInteger.
			rehydrated := self deserialize: dessicated version: anInteger.
			self assert: rehydrated equals: a.
			self assert: (rehydrated at: 1) identicalTo: (rehydrated at: 3).
			self assert: (rehydrated at: 2) identicalTo: (rehydrated at: 4).
			self deny: (rehydrated at: 1) identicalTo: each]!

verifyDictionaries: aClass atVersion: anInteger
	| array dessicated rehydrated dict |
	{
		aClass new.
		aClass new
			at: 'origin' put: 10 @ 20;
			yourself.
		aClass new
			at: 'origin' put: 10 @ 20;
			at: 2 put: 100 @ 200;
			yourself
	} do: 
				[:each |
				dessicated := self serialize: each version: anInteger.
				rehydrated := self deserialize: dessicated version: anInteger.
				self assert: rehydrated equals: each].
	"The identity of the associations should be preserved"
	dict := aClass new.
	dict at: 'a' put: 1.
	dict at: 'b' put: 2.
	array := { dict associationAt: 'a'. dict. dict associationAt: 'b' }.
	dessicated := self serialize: array version: anInteger.
	rehydrated := self deserialize: dessicated version: anInteger.
	self assert: array first identicalTo: (array second associationAt: 'a').
	self assert: array last identicalTo: (array second associationAt: 'b').
	dict := rehydrated at: 2.
	self assert: dict size equals: 2.
	self assert: dict isHealthy!

verifyFloatsAtVersion: anInteger
	| dessicated array rehydrated float |
	float := 1.25.
	array := { float. Float infinity. float. Float nan }.
	dessicated := self serialize: array version: anInteger.
	rehydrated := self deserialize: dessicated version: anInteger.
	self assert: rehydrated size equals: 4.
	self assert: (rehydrated allSatisfy: [:each | each class == Float]).
	self assert: rehydrated first equals: float.
	self assert: rehydrated second equals: Float infinity.
	self assert: rehydrated third identicalTo: rehydrated first.
	self assert: rehydrated fourth isNaN!

verifyLookupTablesAtVersion: anInteger
	^{
		LookupTable new.
		LookupTable with: 'origin' -> (10 @ 20).
		LookupTable with: 'origin' -> (10 @ 20) with: 2 -> (100 @ 200)
	} do: 
				[:each |
				| rehydrated dessicated |
				dessicated := self serialize: each version: anInteger.
				rehydrated := self deserialize: dessicated version: anInteger.
				self assert: rehydrated equals: each]!

verifyOrderedCollectionsAtVersion: anInteger
	^#(#('abc') #('def' 'abc') #('def' 'abc' $d)) do: 
			[:each |
			| subject rehydrated dessicated |
			subject := OrderedCollection withAll: each.
			dessicated := self serialize: subject version: anInteger.
			rehydrated := self deserialize: dessicated version: anInteger.
			self assert: rehydrated equals: subject.
			subject removeFirst.
			dessicated := self serialize: subject version: anInteger.
			rehydrated := self deserialize: dessicated version: anInteger.
			self assert: rehydrated equals: subject]!

verifyRehydrateNonExistantClass: dessicated
	| rehydrated |
	rehydrated := self deserialize: dessicated version: self outfilerClass version.
	#{ClassStub}
		ifDefined: [:classStub | self assert: rehydrated classLocator key equals: 'STBTest_TestClass']
		ifNotDefined: 
			["The class cannot be found so will be resolved to nil. Ought to be an error really, but this is the historic behavior."
			self assert: rehydrated isNil]!

verifyResourceLibraryAtVersion: anInteger
	| dessicated rehydrated libs lib1 lib2 |
	lib1 := ResourceLibrary new
				fileName: 'dolphindr006.dll';
				loadFlags: ResourceLibrary defaultLoadFlags.
	"This will actually open the current res lib"
	lib2 := ResourceLibrary open: 'dolphindr006.dll'.
	libs := { lib1. lib2. lib1. lib2 }.
	dessicated := self serialize: libs version: anInteger.
	rehydrated := self deserialize: dessicated version: anInteger.
	self assert: rehydrated size equals: 4.
	self assert: rehydrated asIdentitySet single identicalTo: lib2!

verifyRoundTripSingleton: anObject version: anInteger
	self
		verifyRoundTripSingleton: anObject
		version: anInteger
		expected: (self serialize: { anObject. anObject } version: anInteger)!

verifyRoundTripSingleton: anObject version: anInteger expected: aByteArray
	| dessicated array rehydrated |
	rehydrated := self deserialize: aByteArray version: anInteger.
	array := { anObject. anObject }.
	self assert: rehydrated equals: array.
	self assert: rehydrated first identicalTo: anObject.
	self assert: rehydrated second identicalTo: anObject.
	dessicated := self serialize: array version: anInteger.
	self assert: dessicated equals: aByteArray!

verifySaveStaticVariableReferenceAtVersion: ver
	| serialised filer |
	filer := self newOutFilerVersion: ver.
	filer saveStatic: #{TestVar}.
	serialised := filer stream contents.
	TestVar := 'Foo'.
	self assert: (self newInFilerOn: serialised) next equals: 'Foo'.
	TestVar := 'Bar'.
	^self assert: (self newInFilerOn: serialised) next equals: 'Bar'!

verifyScaledDecimalsAtVersion: anInteger
	| dessicated array rehydrated literal nonLiteral |
	literal := 1.25s.
	nonLiteral := 2 / 3 asScaledDecimal: 2.
	array := { literal. nonLiteral. literal. nonLiteral }.
	dessicated := self serialize: array version: anInteger.
	rehydrated := self deserialize: dessicated version: anInteger.
	self assert: rehydrated size equals: 4.
	self assert: (rehydrated allSatisfy: [:each | each class == ScaledDecimal]).
	self assert: rehydrated first equals: literal.
	self assert: rehydrated second equals: nonLiteral.
	self assert: rehydrated third identicalTo: rehydrated first.
	self assert: rehydrated fourth identicalTo: rehydrated second!

verifySetsAtVersion: anInteger
	^{
		Set new.
		Set with: 'foo'.
		Set with: 'foo' with: 'bar'.
		IdentitySet new.
		IdentitySet with: #foo.
		IdentitySet with: #foo with: #bar
	} do: 
				[:each |
				| rehydrated dessicated |
				dessicated := self serialize: each version: anInteger.
				rehydrated := self deserialize: dessicated version: anInteger.
				self assert: rehydrated equals: each]!

verifyString: aString atVersion: anInteger
	| s dessicated rehydrated a |
	s := aString asUtf16String.
	a := { aString. s. aString. s }.
	dessicated := self serialize: a version: anInteger.
	rehydrated := self deserialize: dessicated version: anInteger.
	self assert: rehydrated equals: a.
	self assert: rehydrated first equals: aString.
	self assert: rehydrated second equals: s.
	self deny: rehydrated second identicalTo: rehydrated first.
	self assert: rehydrated third identicalTo: rehydrated first.
	self assert: rehydrated fourth identicalTo: rehydrated second.
	^rehydrated!

verifyStrings: anArray atVersion: anInteger
	anArray do: [:each | self verifyString: each atVersion: anInteger]!

verifyStringsAtPreUnicodeVersion: anInteger
	"We use $† (U+2020) because it is an extended character but is common to Windows code pages as code unit 134. This should prevent sensitivity to the OS code page, but just in case we skip if it does not convert as expected."

	self skipUnless: ['†' asAnsiString single = $\x2020].
	self verifyStrings: self preUnicodeTestStrings atVersion: anInteger!

verifyStringsAtVersion: anInteger
	self
		verifyStrings: (#(#[97 98 99 32 194 163 49 50] #[111 195 177 97] #[195 161 114 118 195 173 122 116 117 114 111 32 116 195 188 107 195 182 114 102 195 186 114 195 179 103 195 169 112] #[97 0 98] #[208 186 209 128 208 176 208 186 208 190 208 183 209 143 208 177 209 128 209 139] #[230 150 135 229 173 151 229 140 150 227 129 145] #[208 188 208 176 208 185 208 188 209 131 208 189 208 184 209 134 208 176] #[239 189 129 239 189 130 239 189 131])
				collect: [:each | Utf8String fromByteArray: each])
		atVersion: anInteger!

verifySymbolsAtVersion: anInteger
	| a sym s dessicated rehydrated |
	sym := #testSymbols.
	s := 'a' , (anInteger < 4 ifTrue: [$†] ifFalse: [$🐬]) asUtf8String , 'Symbol'.
	a := { sym. s. sym. s. sym asString asSymbol. s asSymbol }.
	dessicated := self serialize: a version: anInteger.
	rehydrated := self deserialize: dessicated version: anInteger.
	self assert: rehydrated equals: a.
	self assert: rehydrated first identicalTo: sym.
	self assert: (rehydrated at: 5) identicalTo: sym.
	self assert: (rehydrated at: 2) identicalTo: (rehydrated at: 4).
	^self assert: (rehydrated at: 6) identicalTo: s asSymbol!

verifyTranscriptRoundTripAtVersion: anInteger
	^self verifyRoundTripSingleton: Transcript version: anInteger!

verifyVariableBindings: expected version: anInteger
	| actual rehydrated array var |
	array := { Object binding. #{_.FileStream.PageSize} binding. #{Processor} binding }.
	actual := self serialize: array version: anInteger.
	self assert: actual equals: expected.
	rehydrated := self deserialize: expected version: anInteger.
	self assert: rehydrated first identicalTo: array first.
	self assert: rehydrated last identicalTo: array last.
	anInteger > 4
		ifTrue: [self assert: rehydrated second identicalTo: array second]
		ifFalse: 
			["The owning class of the class variable is lost"
			var := rehydrated second.
			self assertIsNil: var environment.
			self assert: var isClassVariable.
			self assert: var key equals: 'PageSize'.
			self assert: var value equals: FileStream.PageSize]!

verifyVariableBindingsAtVersion: ver
	ver < 4
		ifTrue: 
			[| dessicated rehydrated |
			dessicated := self serialize: Object binding version: ver.
			rehydrated := self deserialize: dessicated version: ver.
			self assert: rehydrated equals: #Object -> Object]
		ifFalse: 
			[self verifyRoundTripSingleton: Object binding version: ver.
			self verifyRoundTripSingleton: #{Processor} binding version: ver].
	ver >= 5
		ifTrue: 
			[self verifyRoundTripSingleton: #{Core.String.LineDelimiter} binding
				version: ver]! !
!Kernel.Tests.STxFilerTest categoriesForMethods!
deserialize:version:!helpers!private! !
dumpToTranscript:!helpers!private! !
dumpToTranscriptIfDebug:!helpers!private! !
infilerClass!constants!public! !
minimumFilerVersion!constants!private! !
newInFilerOn:!helpers!private! !
newOutFilerVersion:!helpers!private! !
outfilerClass!constants!public! !
preUnicodeTestStrings!helpers!private! !
serialize:!helpers!private! !
serialize:version:!helpers!private! !
stxDebuggerClass!constants!private! !
testAddresses!public!unit tests! !
testBindingReferences!public!unit tests! !
testByteArrays!public!unit tests! !
testCharacters!public!unit tests! !
testDictionary!public!unit tests! !
testEmptyStream!public!unit tests! !
testExistentClass!public!unit tests! !
testExternalResourceLibrary!public!unit tests! !
testFloats!public!unit tests! !
testHandles!public!unit tests! !
testIntegerBytes!public!unit tests! !
testInvalidStream!public!unit tests! !
testLookupTable!public!unit tests! !
testMetaclass!public!unit tests! !
testNonExistentClass!public!unit tests! !
testOrderedCollections!public!unit tests! !
testPoolDictionary!public!unit tests! !
testProcessor!public!unit tests! !
testSaveStaticVariableReference!public!unit tests! !
testScaledDecimals!public!unit tests! !
testSets!public!unit tests! !
testSmalltalk!public!unit tests! !
testSortedCollections!public!unit tests! !
testStrings!public!unit tests! !
testStringsVersion3!public!unit tests! !
testStringsVersion4!public!unit tests! !
testStringsVersion5!public!unit tests! !
testStringWithNulls!public!unit tests! !
testSymbols!public!unit tests! !
testSystemDictionary!public!unit tests! !
testTranscript!public!unit tests! !
testVariableBinding!public!unit tests! !
testVariableBindingsVersion4!public!unit tests! !
testVariableBindingsVersion5!public!unit tests! !
verifyBindingReferencesAtVersion:!helpers!private! !
verifyByteArraysAtVersion:!helpers!private! !
verifyDictionaries:atVersion:!helpers!private! !
verifyFloatsAtVersion:!helpers!private! !
verifyLookupTablesAtVersion:!helpers!private! !
verifyOrderedCollectionsAtVersion:!helpers!private! !
verifyRehydrateNonExistantClass:!helpers!private! !
verifyResourceLibraryAtVersion:!helpers!private! !
verifyRoundTripSingleton:version:!helpers!private! !
verifyRoundTripSingleton:version:expected:!helpers!private! !
verifySaveStaticVariableReferenceAtVersion:!helpers!private! !
verifyScaledDecimalsAtVersion:!helpers!private! !
verifySetsAtVersion:!helpers!private! !
verifyString:atVersion:!helpers!private! !
verifyStrings:atVersion:!helpers!private! !
verifyStringsAtPreUnicodeVersion:!helpers!private! !
verifyStringsAtVersion:!helpers!private! !
verifySymbolsAtVersion:!helpers!private! !
verifyTranscriptRoundTripAtVersion:!public!unit tests! !
verifyVariableBindings:version:!helpers!private! !
verifyVariableBindingsAtVersion:!helpers!private! !
!

