"Filed out from Dolphin Smalltalk"!

Kernel.Tests.AbstractSTBFilerTest
	subclass: #'Kernel.Tests.STLFilerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.STLFilerTest guid: (Core.GUID fromString: '{5f151d4d-927e-4254-aed9-c51056aef954}')!
Kernel.Tests.STLFilerTest comment: ''!
!Kernel.Tests.STLFilerTest methodsFor!

checkSimpleReadWriteOf: value 
	^self checkSimpleReadWriteOf: value context: nil!

checkSimpleReadWriteOf: value context: anObject
	| in streamContents |
	streamContents := self writeLiteralsFor: value.
	in := STLInFiler on: streamContents readStream.
	in context: anObject.
	self assert: in next equals: value.
	^streamContents!

deserialize: aString
	^Compiler evaluate: aString!

serialize: anObject
	^anObject literalStoreEvaluationString!

simpleReadWriteOf: value 
	^self simpleReadWriteOf: value context: nil!

simpleReadWriteOf: value context: anObject
	| streamContents in |
	streamContents := self writeLiteralsFor: value.
	in := STLInFiler on: streamContents readStream.
	in context: anObject.
	^in next!

stl5Literals
	"Private - STL v5 format from Dolphin 8 of: #(1 'abc' 1.0 true false nil #(123) #[123] $🐬) 
	Note that the top-level array itself cannot be written in literal form because some of the objects it contains are not atomic. It has to be written as individual elements in case the non-atomic content is referenced from more than one location in the object stream, in order to maintain identity of the shared references."

	^#(#'!!STL' 5 34 9 3 8 'abc' 8 1.0 true false nil 8 #(123) 8 #[123] $🐬)!

testArrayOfAtomics
	| array1 storeArray rehydrated array2 |
	array1 := {Object. #abc. 123. $a}.
	self assert: (array1 allSatisfy: [:each | each isAtomic]).
	storeArray := array1 literalStoreArray.
	self assert: (storeArray identityIncludes: array1).
	rehydrated := Object fromLiteralStoreArray: storeArray.
	"We must not get back a direct copy of the array, as this would mean it was shared and any modifications to the restored array would affect the original and the literal store array (which might be a literal in a method)"
	self deny: rehydrated identicalTo: array1.
	"Check that the array itself is properly shared"
	array2 := { array1. array1 }.
	storeArray := array2 literalStoreArray.
	self assert: (storeArray occurrencesOf: array1) equals: 1!

testArraysWithSharedLiterals
	"Verify that the identity of shared literals that are not atomic is preserved."

	| float arrays deserialized bindingRef relativeBindingRef storeArray |
	float := 1.23.
	bindingRef := #{Kernel.Tests.STLFilerTest}.
	relativeBindingRef := #{STLFilerTest}.
	arrays := {{1. float. bindingRef}. {2. float. relativeBindingRef}. bindingRef. relativeBindingRef}.
	storeArray := arrays literalStoreArray.
	self assert: (storeArray select: [:each | each == float]) size equals: 1.
	self assert: (storeArray select: [:each | each == bindingRef]) size equals: 1.
	"Relative binding references cannot be filed in literal form"
	self assert: (storeArray select: [:each | each == relativeBindingRef]) size equals: 0.
	deserialized := Compiler evaluate: arrays literalStoreEvaluationString.
	self assert: deserialized equals: arrays.
	self deny: deserialized third identicalTo: bindingRef.
	self deny: deserialized first second identicalTo: float.
	self assert: deserialized first second identicalTo: deserialized second second.
	self assert: deserialized third identicalTo: deserialized first third.
	self assert: deserialized fourth identicalTo: deserialized second third!

testBindingReference
	"BindingReferences are a special case because they are used to represent classes in the literal array in STL 5, as well as themselves. This is to test that binding references can themselves be round tripped and don't get dereferenced when they should not be."

	| ref storeArray rehydrated array assoc text restoredArray |
	ref := #{Core.Object}.
	storeArray := ref literalStoreArray.
	rehydrated := Object fromLiteralStoreArray: storeArray.
	self assert: rehydrated class identicalTo: FullBindingReference.
	self assert: rehydrated equals: ref.
	array := {ref. 2. ref}.
	storeArray := array literalStoreArray.
	rehydrated := Object fromLiteralStoreArray: storeArray.
	self assert: rehydrated first class identicalTo: FullBindingReference.
	self assert: rehydrated last identicalTo: rehydrated first.
	self assert: rehydrated equals: array.
	assoc := ref -> Object.
	storeArray := assoc literalStoreArray.
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
	self assert: rehydrated value identicalTo: Object.
	!

testBlockReadWrite
	| block1 contents1 in contents2 block2 block3 |
	block1 := [1 + 2].
	contents1 := self writeLiteralsFor: block1.
	in := STLInFiler on: contents1 readStream.
	block2 := in next.
	self assert: block2 method literalCount equals: block1 method literalCount.
	self assert: block2 equals: block1.
	contents2 := self writeLiteralsFor: block2.
	in := STLInFiler on: contents2 readStream.
	block3 := in next.
	self assert: block3 equals: block1.
	self assert: contents1 size equals: contents2 size
!

testClassReadWrite
	| contents answer data |
	contents := self checkSimpleReadWriteOf: STLFilerTest.
	self assert: (contents includes: STLFilerTest).

	"Check multiple references "
	data := {STLFilerTest. STLFilerTest}.
	answer := self simpleReadWriteOf: data.
	self assert: answer equals: data.
	self assert: answer first identicalTo: STLFilerTest.
	self assert: answer first identicalTo: answer last!

testEmptyStream
	self should: [STLInFiler on: #() readStream] raise: STBError!

testIntegerBytesStl4
	"IntegerBytes is a subclass of ByteArray, which has special handling for STB"

	| dessicated rehydrated |
	dessicated := '(Object fromLiteralStoreArray: #(#''!!STL'' 4 655414 ##(Smalltalk.DWORDBytes) 4 239 190 173 222))'.
	rehydrated := self deserialize: dessicated.
	self assert: rehydrated equals: (External.UInt32Bytes fromInteger: 16rDEADBEEF)!

testIntegerReadWrite

	| contents int |
	"SmallInteger"
	#(##(SmallInteger minimum) -1 0 1 ##(SmallInteger maximum))
		do: [:each | self checkSimpleReadWriteOf: each].
	"LargeInteger"
	int := SmallInteger maximum + 1.
	contents := self checkSimpleReadWriteOf: int.
	self assert: (contents includes: int)!

testInvalidStream
	self should: [STLInFiler on: #('Test') readStream] raise: STBError.
	self should: [STLInFiler on: #('!!STL' 9999) readStream] raise: STBError.
	self should: [STLInFiler on: #('') readStream] raise: STBError.
	self should: [STLInFiler on: #(#[]) readStream] raise: STBError!

testStl3Literals
	"STL v3 format from Dolphin 6. Only SmallIntegers, Strings and ByteArrays actually get emitted as literals, not even nil, true and false. Classes were emitted as ##() expression, as (weirdly) were PoolConstantDictionary objects, although in practice the latter are very unlikely to be encountered. Processor and Smalltalk globals were pre-registered."

	| stl3Literals |
	stl3Literals := #(#'!!STL' 3 98 13 3 8 'abc' 8 #foo 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 240 63 16 32 0 98 1 247 8 #[123] 1044 48 64 8 ##(Smalltalk.Win32Constants)).
	self assert: (Object fromLiteralStoreArray: stl3Literals)
		equals: #(1 'abc' #foo 1.0 true false nil #(123) #[123] $A ##(Smalltalk) ##(Processor) ##(Win32Constants))!

testStl4Literals
	"Private - STL v4 format from Dolphin 7 of: #(1 'abc' 1.0 true false nil #(123) #[123] $🐬 ##(Object)).
	In STL4 nils and Characters (which can be non-ascii) are written as literals. Main difference from 5 for this case is that the Float is not written as a literal in STL4."

	self assert: (Object
				fromLiteralStoreArray: #(#'!!STL' 4 34 14 3 8 'abc' #foo 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 240 63 true false nil 8 #(123) 8 #[123] $\x1F42C ##(Smalltalk.Object) ##(Smalltalk) ##(Smalltalk.Processor) ##(Smalltalk.Win32Constants)))
		equals: #(1 'abc' #foo 1.0 true false nil #(123) #[123] $🐬 ##(Object) ##(Smalltalk) ##(Smalltalk.Processor) ##(Smalltalk.Win32Constants))!

testStl5Literals
	self assert: (Object fromLiteralStoreArray: self stl5Literals)
		equals: #(1 'abc' 1.0 true false nil #(123) #[123] $🐬)!

testStl6Literals
	"STL v6 format from Dolphin 8 of: #(1 'abc' 1.0 true false nil #(123) #[123] $🐬 Object. #{Core.Object}) 
	Differs from STL5 in that there are no pre-registered classes, so the class ref for the top level Array is included."

	| literals storeArray |
	literals := { 1. 'abc'. #foo. 1.0. true. false. nil. #(123). #[123]. $🐬. Object. #{Core.Object} }.
	self assert: (Object
				fromLiteralStoreArray: #(#'!!STL' 6 38 #{Core.Array} 12 3 8 'abc' #foo 8 1.0 true false nil 8 #(123) 8 #[123] $🐬 #{Core.Object} 8 #{Core.Object}))
		equals: literals.
	storeArray := literals literalStoreArray.
	"This helps to show how the stream is structured. Atomic objects (i.e. Symbols, booleans, nil, Characters, class references) do not need the literal prefix because for any one value they can have only one instance (or, in the case of classes, are the single instance of a metaclass). String and floats requires the prefix because these may have more than one instance with the same value and must be inserted into the read-map to preserve identity across potentially multiple references in the object graph"
	self assert: storeArray
		equals: {
				#'!!STL'.
				6.
				STBFiler.PrefixVariableMask | STBFiler.PrefixClassMask.
				Array.
				literals size.
				1 << 1 | 1.
				STBFiler.PrefixLiteralMask.
				'abc'.
				#foo.
				STBFiler.PrefixLiteralMask.
				1.0.
				true.
				false.
				nil.
				STBFiler.PrefixLiteralMask.
				#(123).
				STBFiler.PrefixLiteralMask.
				#[123].
				$🐬.
				Object.
				STBFiler.PrefixLiteralMask.
				#{Core.Object}
			}!

testSymbolReadWrite
	| contents deserialized data testSymbol |
	testSymbol := 'testSymbol' asSymbol.
	contents := self checkSimpleReadWriteOf: testSymbol.
	self assert: (contents identityIncludes: testSymbol).

	"Now test that multiple references only occur once"
	data := {testSymbol. testSymbol. 'otherSymbol' asSymbol}.
	deserialized := self simpleReadWriteOf: data.
	self assert: deserialized equals: data.

	"Check that muliple references are identical"
	self assert: deserialized first identicalTo: testSymbol.
	self assert: deserialized first identicalTo: deserialized second!

verifyRehydrateNonExistantClass: dessicated
	self should: [self deserialize: dessicated] raise: NotFoundError!

writeLiteralsFor: anObject
	| out |
	out := STLOutFiler on: Array writeStream.
	out nextPut: anObject.
	^out stream contents! !
!Kernel.Tests.STLFilerTest categoriesForMethods!
checkSimpleReadWriteOf:!private!unit tests! !
checkSimpleReadWriteOf:context:!private!unit tests! !
deserialize:!helpers!private! !
serialize:!helpers!private! !
simpleReadWriteOf:!private!unit tests! !
simpleReadWriteOf:context:!private!unit tests! !
stl5Literals!constants!private! !
testArrayOfAtomics!public!unit tests! !
testArraysWithSharedLiterals!public!unit tests! !
testBindingReference!public!unit tests! !
testBlockReadWrite!public!unit tests! !
testClassReadWrite!public!unit tests! !
testEmptyStream!public!unit tests! !
testIntegerBytesStl4!public!unit tests! !
testIntegerReadWrite!public!unit tests! !
testInvalidStream!public!unit tests! !
testStl3Literals!public!unit tests! !
testStl4Literals!public!unit tests! !
testStl5Literals!public!unit tests! !
testStl6Literals!public!unit tests! !
testSymbolReadWrite!public!unit tests! !
verifyRehydrateNonExistantClass:!helpers!private! !
writeLiteralsFor:!private!unit tests! !
!

