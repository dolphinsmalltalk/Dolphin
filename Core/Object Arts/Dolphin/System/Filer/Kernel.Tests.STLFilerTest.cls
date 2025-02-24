﻿"Filed out from Dolphin Smalltalk"!

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

deserialize: aString version: anInteger
	self assert: (aString beginsWith: '(Object fromLiteralStoreArray: #(#''!!STL'' <d>' << anInteger).
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

simpleBlock
	^[1 + 2]!

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

testClassAndMetaclass3
	| predefinedClassOffset |
	predefinedClassOffset := 4.
	self assert: (STLOutFiler3 new
				nextPut: Association;
				nextPut: Association class;
				nextPut: { Association. Association class };
				contents)
		equals: {
				#'!!STL'.
				3.
				STxFiler.PrefixLiteralMask.
				Association.
				STxFiler.PrefixDataMask | STxFiler.PrefixProxyMask
					| ((STLInFiler3 predefinedClasses indexOf: STBMetaclassProxy) + predefinedClassOffset
							<< STxFiler.PrefixRefShift).
				STxFiler.PrefixLiteralMask.
				'Dolphin'.
				STxFiler.PrefixLiteralMask.
				'Association'.
				STxFiler.PrefixDataMask
					| ((STLInFiler3 predefinedClasses indexOf: Array) + predefinedClassOffset << STxFiler.PrefixRefShift).
				2.
				STxFiler.LastPredefinedClassRef + 1 << STxFiler.PrefixRefShift.
				STxFiler.LastPredefinedClassRef + 2 << STxFiler.PrefixRefShift
			}!

testClassAndMetaclass4
	self assert: (STLOutFiler4 new
				nextPut: Association;
				nextPut: Association class;
				nextPut: { Association. Association class };
				contents)
		equals: {
				#'!!STL'.
				4.
				Association.
				STxFiler.PrefixDataMask | STxFiler.PrefixProxyMask
					| ((STLInFiler4 predefinedClasses indexOf: STBMetaclassProxy) << STxFiler.PrefixRefShift).
				STxFiler.PrefixLiteralMask.
				'Dolphin'.
				STxFiler.PrefixLiteralMask.
				'Association'.
				STxFiler.PrefixDataMask
					| ((STLInFiler4 predefinedClasses indexOf: Array) << STxFiler.PrefixRefShift).
				2.
				Association.
				STxFiler.LastPredefinedClassRef + 1 << STxFiler.PrefixRefShift
			}!

testClassAndMetaclass5and6
	5 to: 6
		do: 
			[:ver |
			self assert: ((STLOutFiler version: ver)
						nextPut: Association;
						nextPut: Association class;
						nextPut: { Association. Association class };
						contents)
				equals: {
						#'!!STL'.
						ver.
						Association.
						Association class.
						STxFiler.PrefixLiteralMask.
						{ Association. Association class }
					}]!

testClassBeforeClassInstanceRequiringConversion
	"Regression test for bug described in STLInFiler3>>#registerPredefinedClasses, although note that the fix is potentially incomplete and more cases may be identified that need pre-registration."

	#(#(#'!!STL' 4 34 4 ##(Smalltalk.Icon) 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 65027 1 418 nil true 464 65031 1 416) #(#'!!STL' 3 98 4 8 ##(Smalltalk.Icon) 418 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 65027 1 418 0 16 464 65031 1 416))
		do: 
			[:stl |
			| deserialised |
			deserialised := (STLInFiler on: stl readStream) contents.
			self assert: deserialised single
				equals: { Graphics.Icon. Graphics.Icon error. Graphics.Icon warning. Graphics.Icon }]!

testClassReadWrite
	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifyClassReadWriteAtVersion: ver]!

testEmptyStream
	self should: [STLInFiler on: #() readStream] raise: STBError!

testExternalStructure
	5 to: STLOutFiler version
		do: 
			[:ver |
			| struct stl |
			struct := (123 @ 456) asParameter.
			stl := self literalStoreArrayOf: struct version: ver.
			self assert: stl
				equals: {
						#'!!STL'.
						ver.
						STxFiler.PrefixClassMask bitOr: (POINTL instSize bitShift: STxFiler.PrefixInstSizeShift).
						POINTL.
						STxFiler.PrefixLiteralMask.
						#[123 0 0 0 200 1 0 0]
					}]!

testExternalStructure3to4
	3 to: 4
		do: 
			[:ver |
			| struct stl |
			struct := (123 @ 456) asParameter.
			stl := self literalStoreArrayOf: struct version: ver.
			self assert: stl
				equals: {
						#'!!STL'.
						ver.
						STxFiler.PrefixClassMask | (POINTL instSize bitShift: STxFiler.PrefixInstSizeShift)
							| (#POINT size bitShift: STxFiler.PrefixLocatorLenShift).
						POINTL.
						STxFiler.PrefixLiteralMask.
						#[123 0 0 0 200 1 0 0]
					}]!

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
End of 6 objects'.
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
	rehydrated := self deserialize: dessicated version: 4.
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
			stl at: 11 put: (i bitShift: STxFiler.PrefixRefShift) | STxFiler.PrefixDataMask.
			self
				should: [Object fromLiteralStoreArray: stl]
				raise: Error
				matching: 
					[:ex |
					ex description = ('STBFiler - STL input stream contains an invalid class reference: <1d>' << i)]]!

testInvalidObjectReference
	| stl rehydrated |
	stl := { #'!!STL'. 6. 38. Array. 2. 6. Object. 64 }.
	rehydrated := Object fromLiteralStoreArray: stl.
	self assert: rehydrated size equals: 2.
	self assert: rehydrated first identicalTo: rehydrated second.
	"Now corrupt the stream by replacing the final class reference (to Association in the read map) with the ref index of an non-class object, and indices that are out of range"
	#(6 -1 0 1234) do: 
			[:i |
			stl at: 8 put: (i bitShift: STxFiler.PrefixRefShift).
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
			ex description = 'STBFiler - Input stream contains an invalid class (Kernel.STBClassProxy)']!

testInvalidStream
	self should: [STLInFiler on: #('Test') readStream] raise: STBError.
	self should: [STLInFiler on: #('!!STL' 9999) readStream] raise: STBError.
	self should: [STLInFiler on: #('') readStream] raise: STBError.
	self should: [STLInFiler on: #(#[]) readStream] raise: STBError!

testProcessor3
	"(Array with: Processor with: Processor) literalStoreArray"

	self
		verifyRoundTripSingleton: Processor
		version: 3
		expected: '(Object fromLiteralStoreArray: #(#''!!STL'' 3 98 2 64 64 ))'!

testProcessor4
	"(Array with: Processor with: Processor) literalStoreArray"

	self
		verifyRoundTripSingleton: Processor
		version: 4
		expected: '(Object fromLiteralStoreArray: #(#''!!STL'' 4 8 #(##(Smalltalk.Processor) ##(Smalltalk.Processor)) ))'!

testProcessor5plus
	"Special case global variable"

	5 to: self outfilerClass version
		do: 
			[:ver |
			self assert: (self serialize: Processor version: ver)
				equals: '(Object fromLiteralStoreArray: #(#''!!STL'' <1d> #{Core.Processor}))' << ver]!

testSmalltalk
	super testSmalltalk.
	self assert: (self serialize: Smalltalk version: 3)
		equals: '(Object fromLiteralStoreArray: #(#''!!STL'' 3 48 ))'.
	self assert: (self serialize: Smalltalk version: 4)
		equals: '(Object fromLiteralStoreArray: #(#''!!STL'' 4 ##(Smalltalk) ))'.
	5 to: self outfilerClass version
		do: 
			[:ver |
			self assert: (self serialize: Smalltalk version: ver)
				equals: '(Object fromLiteralStoreArray: #(#''!!STL'' <1d> #{Smalltalk}))' << ver]!

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
	literals := #(1 9223372036854775808 'a†b' #foo 1.0 true false nil #(123) #[123] $A $€ ##(Smalltalk) ##(Object) ##(Processor) ##(Win32Constants)).
	stl3 := #(#'!!STL' 3 98 16 3 8 9223372036854775808 8 'a†b' 8 #foo 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 240 63 16 32 0 98 1 247 8 #[123] 1044 2052 48 8 ##(Smalltalk.Object) 64 8 ##(Smalltalk.Win32Constants)).
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

	| literals storeArray actual |
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
				STxFiler.PrefixVariableMask | STxFiler.PrefixClassMask.
				Array.
				literals size.
				1 << 1 | 1.
				STxFiler.PrefixLiteralMask.
				SmallInteger minimum - 1.
				STxFiler.PrefixLiteralMask.
				'abc'.
				#foo.
				STxFiler.PrefixLiteralMask.
				1.125.
				#{Float.Infinity}.
				#{Float.NegativeInfinity}.
				#{Float.NaN}.
				STxFiler.PrefixLiteralMask.
				1.25s.
				true.
				false.
				nil.
				STxFiler.PrefixLiteralMask.
				#(123).
				STxFiler.PrefixLiteralMask.
				#[123].
				$a.
				8.
				$🐬.
				Object.
				STxFiler.PrefixLiteralMask.
				#{Core.Object}
			}.
	actual := Object fromLiteralStoreArray: storeArray.
	"Float.NaN doesn't compare equal to anything, even itself, but is a unique value so is identical to itself"
	self assert: (actual symmetricDifference: literals) asIdentitySet single identicalTo: Float.NaN!

testStringsVersion4
	| dessicated utf8WithNull utf16WithNull rehydrated |
	self
		verifyStrings: #('abc £12' 'árvízturo tükörfúrógép' 'кракозябры' '文字化け' 'ａｂｃ')
		atVersion: 4.
	"STL v4 didn't serialize Strings with nulls correctly - they just got trimmed"
	utf8WithNull := Utf8String fromByteArray: #[97 0 98].
	utf16WithNull := utf8WithNull asUtf16String.
	dessicated := self serialize: { utf8WithNull. utf16WithNull. utf8WithNull. utf16WithNull }
				version: 4.
	rehydrated := self deserialize: dessicated version: 4.
	self assert: rehydrated equals: #('a' 'a' 'a' 'a').
	self assert: rehydrated third identicalTo: rehydrated first.
	self assert: rehydrated fourth identicalTo: rehydrated second!

testSymbolReadWrite
	self outfilerClass version to: self minimumFilerVersion
		by: -1
		do: [:ver | self verifySymbolReadWriteAtVersion: ver]!

testTranscript3
	self
		verifyRoundTripSingleton: Transcript
		version: 3
		expected: '(Object fromLiteralStoreArray: #(#''!!STL'' 3 98 2 1114638 ##(Smalltalk.STBSingletonProxy) 8 ##(Smalltalk.TranscriptShell) 8 #current 432 ))'!

testTranscript4
	self
		verifyRoundTripSingleton: Transcript
		version: 4
		expected: '(Object fromLiteralStoreArray: #(#''!!STL'' 4 34 2 1114638 ##(Smalltalk.STBSingletonProxy) ##(Smalltalk.TranscriptShell) #current 432 ))'!

testVariableBindingsVersion4
	self
		verifyVariableBindings: '(Object fromLiteralStoreArray: #(#''!!STL'' 4 34 3 983558 ##(Smalltalk.VariableBinding) #Object ##(Smalltalk.Object) 418 8 ''PageSize'' 16385 418 #Processor ##(Smalltalk.Processor) ))'
		version: 4!

testVariableBindingsVersion5
	"STL is from earlier Dolphin 8, and has STB v2 VariableBindings with environment and flags."

	self
		verifyVariableBindings: '(Object fromLiteralStoreArray: #(#''!!STL'' 5 34 3 1094 2 #{Kernel.VariableBinding} #Object #{Core.Object} #{Core} 1 418 8 ''PageSize'' 16385 #{Core.FileStream} 5 418 #Processor #{Core.Processor} #{Core} 1))'
		version: 5!

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
	block1 := self simpleBlock.
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
	self should: [self deserialize: dessicated version: self outfilerClass version] raise: NotFoundError!

verifyRoundTripSingleton: anObject version: anInteger expected: aString
	super verifyRoundTripSingleton: anObject version: anInteger expected: aString.
	self assert: (Object fromLiteralStoreArray: anObject literalStoreArray) identicalTo: anObject!

verifyStringsAtPreUnicodeVersion: anInteger
	super verifyStringsAtPreUnicodeVersion: anInteger.
	self
		should: [self verifyString: '🐬' atVersion: anInteger]
		raise: STBError
		matching: 
			[:ex |
			ex description = 'STBFiler - String contains extended character that cannot be represented in STL 3: ''🐬''']!

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
deserialize:version:!helpers!private! !
infilerClass!public! !
literalStoreArrayOf:version:!helpers!private! !
minimumFilerVersion!constants!private! !
outfilerClass!constants!public! !
preUnicodeTestStrings!helpers!private! !
serialize:version:!helpers!private! !
simpleBlock!helpers!private! !
simpleReadWriteOf:context:version:!helpers!private! !
stxDebuggerClass!constants!private! !
testArrayOfAtomics!public!unit tests! !
testArraysWithSharedLiterals!public!unit tests! !
testBindingReferenceStoreArray!public!unit tests! !
testBlockReadWrite!public!unit tests! !
testClassAndMetaclass3!public!unit tests! !
testClassAndMetaclass4!public!unit tests! !
testClassAndMetaclass5and6!public!unit tests! !
testClassBeforeClassInstanceRequiringConversion!public!unit tests! !
testClassReadWrite!public!unit tests! !
testEmptyStream!public!unit tests! !
testExternalStructure!public! !
testExternalStructure3to4!public! !
testGlobalProxyingVersion3!public!unit tests! !
testGlobalProxyingVersion4!public!unit tests! !
testIntegerBytesStl4!public!unit tests! !
testIntegerReadWrite!public!unit tests! !
testInvalidClassReference!public!unit tests! !
testInvalidObjectReference!public!unit tests! !
testInvalidPredefinedClass!public!unit tests! !
testInvalidStream!public!unit tests! !
testProcessor3!public!unit tests! !
testProcessor4!public!unit tests! !
testProcessor5plus!public!unit tests! !
testSmalltalk!public! !
testStl3ExtendedChar!public!unit tests! !
testStl3Literals!public!unit tests! !
testStl4Literals!public!unit tests! !
testStl5Literals!public!unit tests! !
testStl6Literals!public!unit tests! !
testStringsVersion4!public!unit tests! !
testSymbolReadWrite!public!unit tests! !
testTranscript3!public!unit tests! !
testTranscript4!public!unit tests! !
testVariableBindingsVersion4!public!unit tests! !
testVariableBindingsVersion5!public!unit tests! !
verifyArrayOfAtomicsAtVersion:!helpers!private! !
verifyArraysWithSharedLiteralsAtVersion:!helpers!private! !
verifyBindingReferenceStoreArrayAtVersion:!helpers!private! !
verifyBlockReadWriteAtVersion:!helpers!private! !
verifyClassReadWriteAtVersion:!helpers!private! !
verifyIntegerReadWriteAtVersion:!helpers!private! !
verifyRehydrateNonExistantClass:!helpers!private! !
verifyRoundTripSingleton:version:expected:!helpers!private! !
verifyStringsAtPreUnicodeVersion:!helpers!private! !
verifySymbolReadWriteAtVersion:!helpers!private! !
!

