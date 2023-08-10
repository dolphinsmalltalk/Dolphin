"Filed out from Dolphin Smalltalk"!

Kernel.Tests.STxFilerTest
	subclass: #'Kernel.Tests.STLFilerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.STLFilerTest guid: (Core.GUID fromString: '{5f151d4d-927e-4254-aed9-c51056aef954}')!
Kernel.Tests.STLFilerTest comment: ''!
!Kernel.Tests.STLFilerTest methodsFor!

checkSimpleReadWriteOf: anObject
	^self checkSimpleReadWriteOf: anObject version: self outfilerClass version!

checkSimpleReadWriteOf: anObject version: anInteger
	| in stl |
	stl := self literalStoreArrayOf: anObject version: anInteger.
	in := STLInFiler on: stl readStream.
	self assert: in next equals: anObject.
	^stl!

deserialize: aString
	^Compiler evaluate: aString!

infilerClass
	^STLInFiler!

literalStoreArrayOf: anObject version: anInteger
	| filer |
	filer := self newOutFilerVersion: anInteger.
	filer nextPut: anObject.
	^filer stream contents!

minimumFilerVersion
	^3!

outfilerClass
	^STLOutFiler!

preUnicodeTestStrings
	"Embedded nulls were (effectively) just trimmed out in STL 3"

	^#(#[97 98 99 32 226 128 160 49 50] #[195 161 114 118 195 173 122 116 117 114 111 32 116 195 188 107 195 182 114 102 195 186 114 195 179 103 195 169 112])
		collect: [:each | Utf8String fromByteArray: each]!

serialize: anObject version: anInteger
	| stream stl |
	stl := self literalStoreArrayOf: anObject version: anInteger.
	stream := String writeStream.
	stream nextPutAll: '(Object fromLiteralStoreArray: '.
	STLPrinter printLiteralStoreArray: stl on: stream.
	stream nextPut: $).
	^stream contents!

simpleReadWriteOf: anObject context: ctxtObject version: anInteger
	| stl in |
	stl := self literalStoreArrayOf: anObject version: anInteger.
	in := STLInFiler on: stl readStream.
	in context: ctxtObject.
	^in next!

stxDebuggerClass
	^Tools.STLDebugger!

testArrayOfAtomics
	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifyArrayOfAtomicsAtVersion: ver]!

testArraysWithSharedLiterals
	"Verify that the identity of shared literals that are not atomic is preserved."

	self outfilerClass version to: 5
		by: -1
		do: [:ver | self verifyArraysWithSharedLiteralsAtVersion: ver]!

testBindingReferenceStoreArray
	"BindingReferences are a special case because they are used to represent classes in the literal array in STL 5, as well as themselves. This is to test that binding references can themselves be round tripped and don't get dereferenced when they should not be."

	self outfilerClass version to: 5
		by: -1
		do: [:ver | self verifyBindingReferenceStoreArrayAtVersion: ver]!

testBlockReadWrite
	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifyBlockReadWriteAtVersion: ver]!

testClassReadWrite
	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifyClassReadWriteAtVersion: ver]!

testEmptyStream
	self should: [STLInFiler on: #() readStream] raise: STBError!

testGlobalProxyingVersion3
	| stl3 deserialised filer object serialised |
	stl3 := #(#'!!STL' 3 1311246 ##(Smalltalk.STBGlobalObjectProxy) 8 #Foo 8 'Bar' 410 8 #Bar 0).
	self assert: (Tools.STLDebugger dump: stl3 readStream)
		equals: 'STL version 3:
000002 [STBGlobalObjectProxy]
000004     27: #Foo
000006     28: ''Bar''

000008 [STBGlobalObjectProxy]
000009     30: #Bar
000011     [<0: nil>]
End of 30 objects
'.
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
	self assert: serialised equals: stl3.
	
	[deserialised := (STLInFiler on: stl3 readStream) contents.
	self assert: deserialised equals: { 'Bar'. nil }.
	self assert: (Smalltalk includesKey: #Foo).
	self assert: (Smalltalk at: #Foo) equals: 'Bar'.
	self assert: (Smalltalk includesKey: #Bar).
	self assertIsNil: (Smalltalk at: #Bar)]
			ensure: [#(#Foo #Bar) do: [:each | Smalltalk removeKey: each ifAbsent: []]]!

testGlobalProxyingVersion4
	| stl4 deserialised filer object serialised |
	stl4 := #(#'!!STL' 4 1311246 ##(Smalltalk.STBGlobalObjectProxy) #Foo 8 'Bar' 410 #Bar nil).
	self assert: (Tools.STLDebugger dump: stl4 readStream)
		equals: 'STL version 4:
000002 [STBGlobalObjectProxy]
000004     #Foo
000005     27: ''Bar''

000007 [STBGlobalObjectProxy]
000008     #Bar
000009     nil
End of 28 objects
'.
	"Note that proxying of global nils was actually broken in D7 due to an optimisation added for writing nils, so this content was created with a patch in D7."
	filer := self newOutFilerVersion: 4.
	object := 'Bar' copy.
	filer register: object asGlobal: #Foo.
	filer nextPut: object.
	"Also the ability to translate the next nil to a global (can't remember what that was for)"
	filer
		register: nil asGlobal: #Bar;
		nextPut: nil.
	serialised := filer stream contents.
	self assert: serialised equals: stl4.
	
	[deserialised := (STLInFiler on: stl4 readStream) contents.
	self assert: deserialised equals: { 'Bar'. nil }.
	self assert: (Smalltalk includesKey: #Foo).
	self assert: (Smalltalk at: #Foo) equals: 'Bar'.
	self assert: (Smalltalk includesKey: #Bar).
	self assertIsNil: (Smalltalk at: #Bar)]
			ensure: [#(#Foo #Bar) do: [:each | Smalltalk removeKey: each ifAbsent: []]]!

testIntegerBytesStl4
	"IntegerBytes is a subclass of ByteArray, which has special handling for STB"

	| dessicated rehydrated |
	dessicated := '(Object fromLiteralStoreArray: #(#''!!STL'' 4 655414 ##(Smalltalk.DWORDBytes) 4 239 190 173 222))'.
	rehydrated := self deserialize: dessicated.
	self assert: rehydrated equals: (External.UInt32Bytes fromInteger: 16rDEADBEEF)!

testIntegerReadWrite
	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifyIntegerReadWriteAtVersion: ver]!

testInvalidClassReference
	| stl rehydrated |
	stl := { #'!!STL'. 6. 38. Array. 2. 518. Association. #foo. 6. Object. 50. #bar. 96 }.
	rehydrated := Object fromLiteralStoreArray: stl.
	self assert: rehydrated size equals: 2.
	self assert: rehydrated first key equals: #foo.
	self assert: rehydrated second key equals: #bar.
	self assert: rehydrated first value identicalTo: rehydrated second value.
	"Now corrupt the stream by replacing the final class reference (to Association in the read map) with the ref index of an non-class object, and indices that are out of range"
	#(6 -1 0 1234) do: 
			[:i |
			stl at: 11 put: (i bitShift: STxVersionPolicy.PrefixRefShift) | STxVersionPolicy.PrefixDataMask.
			self
				should: [Object fromLiteralStoreArray: stl]
				raise: Error
				matching: 
					[:ex |
					ex description = ('STBFiler - STL input stream contains an invalid class reference (<1d>)' << i)]]!

testInvalidObjectReference
	| stl rehydrated |
	stl := { #'!!STL'. 6. 38. Array. 2. 6. Object. 64 }.
	rehydrated := Object fromLiteralStoreArray: stl.
	self assert: rehydrated size equals: 2.
	self assert: rehydrated first identicalTo: rehydrated second.
	"Now corrupt the stream by replacing the final class reference (to Association in the read map) with the ref index of an non-class object, and indices that are out of range"
	#(6 -1 0 1234) do: 
			[:i |
			stl at: 8 put: (i bitShift: STxVersionPolicy.PrefixRefShift).
			self
				should: [Object fromLiteralStoreArray: stl]
				raise: Error
				matching: 
					[:ex |
					ex description = ('STBFiler - STL input stream is inconsistent (object <1d> referenced but not yet defined)' << i)]]!

testInvalidPredefinedClass
	"Test error for a reference to STBClassProxy, which is not expected in STL."

	self
		should: [(STLInFiler on: #(#'!!STL' 5 82 8 'Dolphin' 8 'Core.Object') readStream) next]
		raise: Error
		matching: 
			[:ex |
			ex description = 'STBFiler - STL input stream contains an invalid class (Kernel.STBClassProxy)']!

testInvalidStream
	self should: [STLInFiler on: #('Test') readStream] raise: STBError.
	self should: [STLInFiler on: #('!!STL' 9999) readStream] raise: STBError.
	self should: [STLInFiler on: #('') readStream] raise: STBError.
	self should: [STLInFiler on: #(#[]) readStream] raise: STBError!

testStl3ExtendedChar
	"STL v3 format from Dolphin 6, which did not have proper Unicode support. Characters with code points > 255 could not be represented. Literal strings were ansi byte-strings, so any extended characters would not be read correctly in D6 either."

	self
		should: [self literalStoreArrayOf: $\xFFFD version: 3]
		raise: STBError
		matching: 
			[:ex |
			ex description = 'STBFiler - Character code point cannot be represented in STL 3: U+FFFD (�)'].
	self
		should: [	self literalStoreArrayOf: Character dolphin asString version: 3]
		raise: STBError
		matching: 
			[:ex |
			ex description = 'STBFiler - String contains extended character that cannot be represented in STL 3: ''🐬'''].

!

testStl3Literals
	"STL v3 format from Dolphin 6. Only Integers (small and large), Strings, Symbols and ByteArrays actually get emitted as literals, not Characters, nil, true and false. Classes were emitted as ##() expression, as were PoolConstantDictionary objects since these were known globals, although in practice very unlikely to be encountered. Processor and Smalltalk globals were pre-registered."

	| stl3 rehydrated literals |
	literals := #(1 9223372036854775808 'a†b' #foo 1.0 true false nil #(123) #[123] $A ##(Smalltalk) ##(Object) ##(Processor) ##(Win32Constants)).
	"(Object fromLiteralStoreArray: #(#'!!STL' 3 98 15 3 8 9223372036854775808 8 'a†b' 8 #foo 327734 ##(Smalltalk.Float)  8 0 0 0 0 0 0 240 63 16 32 0 98 1 247 8 #[123] 1044 48 8 ##(Smalltalk.Object)  64 8 ##(Smalltalk.Win32Constants) ))"
	stl3 := #(#'!!STL' 3 98 15 3 8 9223372036854775808 8 'a†b' 8 #foo 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 240 63 16 32 0 98 1 247 8 #[123] 1044 48 8 ##(Smalltalk.Object) 64 8 ##(Smalltalk.Win32Constants)).
	rehydrated := Object fromLiteralStoreArray: stl3.
	self assert: rehydrated equals: literals.
	self assert: (self literalStoreArrayOf: rehydrated version: 3) equals: stl3!

testStl4Literals
	"Private - STL v4 format from Dolphin 7.
	In STL4 nils and Characters (which can be non-ascii) are written as literals. Main difference from 5 for this case is that the Float is not written as a literal in STL4."

	| literals stl |
	literals := {
				1.
				'abc'.
				#foo.
				1.0.
				1.25s.
				true.
				false.
				nil.
				#(123).
				#[123].
				$🐬.
				Object.
				Smalltalk.
				Processor.
				Win32Constants
			}.
	stl := self literalStoreArrayOf: literals version: 4.
	self assert: stl
		equals: #(#'!!STL' 4 34 15 3 8 'abc' #foo 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 240 63 852486 ##(Smalltalk.ScaledDecimal) 524806 ##(Smalltalk.Fraction) 11 9 5 true false nil 8 #(123) 8 #[123] $\x1F42C ##(Smalltalk.Object) ##(Smalltalk) ##(Smalltalk.Processor) ##(Smalltalk.Win32Constants)).
	self assert: (Object fromLiteralStoreArray: stl) equals: literals!

testStl5Literals
	"Private - STL v5 format from early Dolphin 8 of: #(1 'abc' 1.0 true false nil #(123) #[123] $🐬 #{Core.Object}) literalStoreArray
	Note that the top-level array itself cannot be written in literal form because some of the objects it contains are not atomic. It has to be written as individual elements in case the non-atomic content is referenced from more than one location in the object stream, in order to maintain identity of the shared references. Each literal that is not atomic is emitted with the literal prefix, 8. The non-atomic objects are 1.0 (Float),  'abc' (Utf8String), #(123) (Array), $🐬 (extended, non-byte, Character), and #{Core.Object} (binding reference)."

	| literals stl |
	literals := { 1. 'abc'. 1.125. 1.25s. true. false. nil. #(123). #[123]. $🐬. Object. #{Core.Object} }.
	stl := self literalStoreArrayOf: literals version: 5.
	"In STL v5 all Characters were emitted without the literal prefix, although this should not have been the case for non-byte characters."
	self assert: stl
		equals: {
				#'!!STL'.
				5.
				34.
				12.
				3.
				8.
				'abc'.
				8.
				1.125.
				8.
				1.25s.
				true.
				false.
				nil.
				8.
				#(123).
				8.
				#[123].
				$🐬.
				Object.
				8.
				#{Core.Object}
			}.
	self assert: (Object fromLiteralStoreArray: stl) equals: literals!

testStl6Literals
	"STL v6 format from Dolphin 8. 
	A notable difference from the earlier Dolphin 8 representation, STL5, is that there are no pre-registered classes, so the class ref for the top level Array is included."

	| literals storeArray |
	literals := {
				1.
				SmallInteger minimum - 1.
				'abc'.
				#foo.
				1.125.
				Float infinity.
				Float negativeInfinity.
				Float nan.
				1.25s.
				true.
				false.
				nil.
				#(123).
				#[123].
				$a.
				$🐬.
				Object.
				#{Core.Object}
			}.
	storeArray := self literalStoreArrayOf: literals version: 6.
	"This helps to show how the STL stream is structured. Atomic objects (i.e. Symbols, booleans, nil, byte Characters, class references, SmallIntegers) do not need the literal prefix because for any one value they can have only one instance (or, in the case of classes, are the single instance of a metaclass). Arrays, ByteArrays, BindingReferences, LargeIntegers, Strings, ScaledDecimals and Floats requires the prefix because these may have more than one instance with the same value and must be inserted into the read-map to preserve identity across potentially multiple references in the object graph, although note that non-finite Floats are a special case and get translated to BindingReferences that will resolve back to the singleton instances for infinity, negative infinity and NaN. Similarly any non-byte Character (like the Dolphin emoji) must have a literal prefix to ensure the same identical instance is shared. Arrays of atomic objects are written as literals (with literal prefix), but if they contain non-atomic objects they must be broken down (tested elsewhere). The direct class references in the literal array are translated to binding references by the literal printer in order to convert to source form. This means that unlike earlier STL versions, in Dolphin 8 the STL arrays for resources need not contain any ##() expressions - they are true literals."
	self assert: storeArray
		equals: {
				#'!!STL'.
				6.
				STxVersionPolicy.PrefixVariableMask | STxVersionPolicy.PrefixClassMask.
				Array.
				literals size.
				1 << 1 | 1.
				STLVersionPolicy.PrefixLiteralMask.
				SmallInteger minimum - 1.
				STLVersionPolicy.PrefixLiteralMask.
				'abc'.
				#foo.
				STLVersionPolicy.PrefixLiteralMask.
				1.125.
				#{Float.Infinity}.
				#{Float.NegativeInfinity}.
				#{Float.NaN}.
				STLVersionPolicy.PrefixLiteralMask.
				1.25s.
				true.
				false.
				nil.
				STLVersionPolicy.PrefixLiteralMask.
				#(123).
				STLVersionPolicy.PrefixLiteralMask.
				#[123].
				$a.
				8.
				$🐬.
				Object.
				STLVersionPolicy.PrefixLiteralMask.
				#{Core.Object}
			}.
	"Float.NaN doesn't compare equal to anything, even itself"
	self assert: ((Object fromLiteralStoreArray: storeArray) reject: [:each | each == Float.NaN]) equals: (literals reject: [:each | each == Float.NaN]).
!

testStringsVersion4
	| dessicated utf8WithNull |
	self
		verifyStrings: #('abc £12' 'árvízturo tükörfúrógép' 'кракозябры' '文字化け' 'ａｂｃ')
		atVersion: 4.
	"STL v4 didn't serialize Strings with nulls correctly - they just got trimmed"
	utf8WithNull := Utf8String fromByteArray: #[97 0 98].
	dessicated := self serialize: { utf8WithNull. utf8WithNull asUtf16String } version: 4.
	self assert: (self deserialize: dessicated) equals: #('a' 'a')!

testSymbolReadWrite
	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifySymbolReadWriteAtVersion: ver]!

verifyArrayOfAtomicsAtVersion: anInteger
	| array1 array2 storeArray rehydrated |
	array1 := { Object. #abc. 123. $a }.
	self assert: (array1 allSatisfy: [:each | each isAtomic]).
	storeArray := self literalStoreArrayOf: array1 version: anInteger.
	self assert: (storeArray identityIncludes: array1) equals: anInteger > 3.
	rehydrated := Object fromLiteralStoreArray: storeArray.
	"We must not get back a direct copy of the array, as this would mean it was shared and any modifications to the restored array would affect the original and the literal store array (which might be a literal in a method)"
	self deny: rehydrated identicalTo: array1.
	"Check that the array itself is properly shared"
	array2 := { array1. array1 }.
	storeArray := self literalStoreArrayOf: array2 version: anInteger.
	self assert: (storeArray occurrencesOf: array1) equals: (anInteger > 3) asParameter!

verifyArraysWithSharedLiteralsAtVersion: anInteger
	"Verify that the identity of shared literals that are not atomic is preserved."

	| deserialized float relativeBindingRef storeArray bindingRef arrays |
	float := 1.23.
	bindingRef := #{Kernel.Tests.STLFilerTest}.
	relativeBindingRef := #{STLFilerTest}.
	arrays := {
				{ 1. float. bindingRef }.
				{ 2. float. relativeBindingRef }.
				bindingRef.
				relativeBindingRef
			}.
	storeArray := self literalStoreArrayOf: arrays version: anInteger.
	self assert: (storeArray select: [:each | each == float]) size equals: 1.
	self assert: (storeArray select: [:each | each == bindingRef]) size equals: 1.
	"Relative binding references cannot be filed in literal form"
	self assert: (storeArray select: [:each | each == relativeBindingRef]) size equals: 0.
	deserialized := Object fromLiteralStoreArray: storeArray.
	self assert: deserialized equals: arrays.
	self deny: deserialized third identicalTo: bindingRef.
	"Immutable objects are normally copied, but not numbers are these always immutable, not just because they are in literal form"
	self assert: deserialized first second identicalTo: float.
	self assert: deserialized first second identicalTo: deserialized second second.
	self assert: deserialized third identicalTo: deserialized first third.
	self assert: deserialized fourth identicalTo: deserialized second third!

verifyBindingReferenceStoreArrayAtVersion: anInteger
	| restoredArray text ref assoc storeArray rehydrated |
	ref := #{Core.Object}.
	assoc := ref -> Object.
	storeArray := self literalStoreArrayOf: assoc version: anInteger.
	self assert: (storeArray identityIncludes: Object).
	self assert: (storeArray identityIncludes: ref).
	rehydrated := Object fromLiteralStoreArray: storeArray.
	self assert: rehydrated key class identicalTo: FullBindingReference.
	self assert: rehydrated key equals: ref.
	self assert: rehydrated value identicalTo: Object.
	text := STLPrinter printLiteralStoreArray: storeArray.
	restoredArray := Compiler evaluate: text.
	self deny: (restoredArray includes: Object).
	rehydrated := Object fromLiteralStoreArray: restoredArray.
	self assert: rehydrated key equals: ref.
	self assert: rehydrated value identicalTo: Object!

verifyBlockReadWriteAtVersion: anInteger
	| block3 block2 block1 contents1 in contents2 |
	block1 := [1 + 2].
	contents1 := self literalStoreArrayOf: block1 version: anInteger.
	in := STLInFiler on: contents1 readStream.
	block2 := in next.
	self assert: block2 method literalCount equals: block1 method literalCount.
	self assert: block2 equals: block1.
	contents2 := self literalStoreArrayOf: block2 version: anInteger.
	in := STLInFiler on: contents2 readStream.
	block3 := in next.
	self assert: block3 equals: block1.
	self assert: contents1 size equals: contents2 size!

verifyClassReadWriteAtVersion: anInteger
	| answer contents data |
	contents := self checkSimpleReadWriteOf: STLFilerTest version: anInteger.
	self assert: (contents includes: STLFilerTest).

	"Check multiple references "
	data := { STLFilerTest. STLFilerTest }.
	answer := self
				simpleReadWriteOf: data
				context: nil
				version: anInteger.
	self assert: answer equals: data.
	self assert: answer first identicalTo: STLFilerTest.
	self assert: answer first identicalTo: answer last!

verifyIntegerReadWriteAtVersion: anInteger
	| contents int |
	#(##("SmallInteger"
	SmallInteger minimum) -1 0 1 ##(SmallInteger maximum))
			do: [:each | self checkSimpleReadWriteOf: each version: anInteger].	"SmallInteger"
	"LargeInteger"
	int := SmallInteger maximum + 1.
	contents := self checkSimpleReadWriteOf: int version: anInteger.
	self assert: (contents includes: int)!

verifyRehydrateNonExistantClass: dessicated
	self should: [self deserialize: dessicated] raise: NotFoundError!

verifyRoundTripSingleton: anObject version: anInteger
	super verifyRoundTripSingleton: anObject version: anInteger.
	self assert: (Object fromLiteralStoreArray: anObject literalStoreArray) identicalTo: anObject!

verifySymbolReadWriteAtVersion: anInteger
	| contents testSymbol deserialized data |
	testSymbol := 'testSymbol' asSymbol.
	contents := self checkSimpleReadWriteOf: testSymbol version: anInteger.
	self assert: (contents identityIncludes: testSymbol).

	"Now test that multiple references only occur once"
	data := { testSymbol. testSymbol. 'otherSymbol' asSymbol }.
	deserialized := self
				simpleReadWriteOf: data
				context: nil
				version: anInteger.
	self assert: deserialized equals: data.

	"Check that muliple references are identical"
	self assert: deserialized first identicalTo: testSymbol.
	self assert: deserialized first identicalTo: deserialized second! !
!Kernel.Tests.STLFilerTest categoriesForMethods!
checkSimpleReadWriteOf:!helpers!private! !
checkSimpleReadWriteOf:version:!helpers!private! !
deserialize:!helpers!private! !
infilerClass!public! !
literalStoreArrayOf:version:!helpers!private! !
minimumFilerVersion!constants!private! !
outfilerClass!constants!public! !
preUnicodeTestStrings!helpers!private! !
serialize:version:!helpers!private! !
simpleReadWriteOf:context:version:!helpers!private! !
stxDebuggerClass!constants!private! !
testArrayOfAtomics!public!unit tests! !
testArraysWithSharedLiterals!public!unit tests! !
testBindingReferenceStoreArray!public!unit tests! !
testBlockReadWrite!public!unit tests! !
testClassReadWrite!public!unit tests! !
testEmptyStream!public!unit tests! !
testGlobalProxyingVersion3!public!unit tests! !
testGlobalProxyingVersion4!public!unit tests! !
testIntegerBytesStl4!public!unit tests! !
testIntegerReadWrite!public!unit tests! !
testInvalidClassReference!public!unit tests! !
testInvalidObjectReference!public!unit tests! !
testInvalidPredefinedClass!public!unit tests! !
testInvalidStream!public!unit tests! !
testStl3ExtendedChar!public!unit tests! !
testStl3Literals!public!unit tests! !
testStl4Literals!public!unit tests! !
testStl5Literals!public!unit tests! !
testStl6Literals!public!unit tests! !
testStringsVersion4!public!unit tests! !
testSymbolReadWrite!public!unit tests! !
verifyArrayOfAtomicsAtVersion:!helpers!private! !
verifyArraysWithSharedLiteralsAtVersion:!helpers!private! !
verifyBindingReferenceStoreArrayAtVersion:!helpers!private! !
verifyBlockReadWriteAtVersion:!helpers!private! !
verifyClassReadWriteAtVersion:!helpers!private! !
verifyIntegerReadWriteAtVersion:!helpers!private! !
verifyRehydrateNonExistantClass:!helpers!private! !
verifyRoundTripSingleton:version:!helpers!private! !
verifySymbolReadWriteAtVersion:!helpers!private! !
!

