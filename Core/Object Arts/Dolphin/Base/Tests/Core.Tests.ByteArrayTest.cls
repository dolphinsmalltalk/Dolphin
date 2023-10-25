"Filed out from Dolphin Smalltalk"!

Core.Tests.ArrayedCollectionTest
	subclass: #'Core.Tests.ByteArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ByteArrayTest guid: (Core.GUID fromString: '{f83d3bb0-c4b4-4f92-9d89-fd89e6e25da1}')!
Core.Tests.ByteArrayTest comment: ''!
!Core.Tests.ByteArrayTest methodsFor!

assimilate: anObject 
	^anObject asInteger!

collectionClass
	^ByteArray!

int32Values
	^#(-16r7FFFFFFF -16r8000 -16r7FFF -16r80 -16r7F -16r1 16r0 16r1 16r7F 16r80 16r7FFF 16r8000 16r7FFFFFFF)!

testAsHexString
	self assert: #[] asHexString equals: ''.
	self assert: #[0] asHexString equals: '00'.
	self assert: (0 to: 255) asByteArray asHexString
		equals: '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff'!

testAsUtf16String
	#(#[] '' #[65 0 16rAC 16r20] 'A€' #[16r7F 0] ##(Utf16String with: $\x7F) #[16rFF 16r0 16rA3 16r0 16rFF 16r7 16r0 16r8 16r0 16rD8 16r0 16rDC 16r3D 16rD8 16r2C 16rDC] 'ÿ£߿ࠀ𐀀🐬')
		pairsDo: [:bytes :expected | self assert: bytes asUtf16String equals: expected]!

testAsUtf8String
	#(#[] '' #[65] 'A' #[16r7F] ##(Utf8String with: $\x7F) #[16rC3 16rBF 16rC2 16rA3 16rDF 16rBF 16rE0 16rA0 16r80 16rF0 16r90 16r80 16r80 16rF0 16r9F 16r90 16rAC] 'ÿ£߿ࠀ𐀀🐬')
		pairsDo: [:bytes :expected | self assert: bytes asUtf8String equals: expected]!

testBasicUInt32AtOffsetPut
	"#1457"

	| array |
	array := ByteArray new: 4.
	self assert: (array uint32AtOffset: 0) equals: 0.
	self uint32Values do: 
			[:each |
			array basicUInt32AtOffset: 0 put: each.
			self assert: (array uint32AtOffset: 0) equals: each.
			array basicUInt32AtOffset: 0 put: (External.UInt32 fromInteger: each).
			self assert: (array uint32AtOffset: 0) equals: each].
	self should: [array basicUInt32AtOffset: 0 put: -16r80000001] raise: Error.
	self should: [array basicUInt32AtOffset: 0 put: 16rFFFFFFFF + 1] raise: Error!

testFromHexString
	| hex expected bytes |
	hex := String writeStream.
	expected := ByteArray writeStream.
	0 to: 255
		do: 
			[:each |
			expected nextPut: each.
			each < 16 ifTrue: [hex nextPut: $0].
			each
				printOn: hex
				base: 16
				showRadix: false].
	hex := hex contents.
	expected := expected contents.
	bytes := ByteArray fromHexString: hex.
	self assert: bytes equals: expected.
	self assert: bytes asHexString caseFolded equals: hex caseFolded.
	self assert: (ByteArray fromHexString: '') equals: #[].
	"We allow lower case chars too."
	self assert: (ByteArray fromHexString: 'fe') equals: #[254].
	#(' 0' '1 ' 'GH' '1') do: [:each | self should: [ByteArray fromHexString: each] raise: Error]!

testInt32AtOffsetPut
	| array |
	array := ByteArray new: 4.
	self assert: (array int32AtOffset: 0) equals: 0.
	self int32Values do: 
			[:each |
			array int32AtOffset: 0 put: each.
			self assert: (array int32AtOffset: 0) equals: each.
			array int32AtOffset: 0 put: (External.Int32 fromInteger: each).
			self assert: (array int32AtOffset: 0) equals: each].
	self should: [array int32AtOffset: 0 put: -16r80000001] raise: Error.
	self should: [array int32AtOffset: 0 put: 16r80000000] raise: Error!

testInt8AtOffset
	0 to: 127 do: [:each | self assert: ((ByteArray with: each) int8AtOffset: 0) equals: each].
	128 to: 255 do: [:each | self assert: ((ByteArray with: each) int8AtOffset: 0) equals: each - 256]!

testInt8AtOffsetPut
	| array |
	array := ByteArray new: 1.
	self assert: (array at: 1) equals: 0.
	127 to: 0
		by: -1
		do: 
			[:each |
			array int8AtOffset: 0 put: each.
			self assert: (array at: 1) equals: each].
	-128 to: -1
		do: 
			[:each |
			array int8AtOffset: 0 put: each.
			self assert: (array at: 1) equals: (each bitAnd: 255)]!

testMixedConcatenation
	"Test concatenating other types of sequenceable collection onto an array"

	| subjects |
	subjects := #(#[] #[1] #[1 2]).
	{String empty. Utf16String empty. Array new. OrderedCollection new. 1 to: 0} do: 
			[:eachEmpty |
			subjects do: 
					[:eachArray |
					| result |
					result := eachArray , eachEmpty.
					self deny: eachArray identicalTo: result.
					self assert: result equals: eachArray]].
	{'a' asAnsiString.
		#(255).
		OrderedCollection with: 123.
		100 to: 100.
		'ab' asAnsiString.
		#(1 255).
		OrderedCollection with: 123 with: 255.
		100 to: 101} do: 
				[:each |
				subjects do: 
						[:eachArray |
						| result |
						result := self verifyConcatenation: each with: eachArray.
						self deny: eachArray identicalTo: result.
						self assert: result class identicalTo: self collectionClass]].
	"It doesn't really make sense to catenate strings onto ByteArrays, but for historical reasons this can be done for AnsiStrings. However it doesn't work for UTF-encoded strings (by design)."
	self should: [#[] , Character dolphin asUtf8String] raise: Error.
	self should: [#[] , Character dolphin asUtf16String] raise: Error!

testStbRoundTrip
	| subject bytes rehydrated |
	subject := (0 to: 255) asByteArray.
	bytes := subject binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: bytes.
	self assert: rehydrated size equals: 256.
	self assert: rehydrated class identicalTo: ByteArray.
	self assert: rehydrated equals: subject!

testUInt16AtOffsetPut
	"#1457"

	| array |
	array := ByteArray new: 4.
	self assert: (array uint16AtOffset: 0) equals: 0.
	self uint16Values do: 
			[:each |
			array uint16AtOffset: 0 put: each.
			self assert: (array uint16AtOffset: 0) equals: each.
			array uint16AtOffset: 0 put: (External.UInt16 fromInteger: each).
			self assert: (array uint16AtOffset: 0) equals: each].
	{-16r8001. 16rFFFF + 1} do: 
			[:each |
			self
				should: [array uint16AtOffset: 0 put: each]
				raise: OS.HRESULTError
				matching: [:ex | ex hresult = (OS.HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.IntegerOutOfRange)]]!

testUInt32AtOffsetPut
	"#1457"

	| array |
	array := ByteArray new: 4.
	self assert: (array uint32AtOffset: 0) equals: 0.
	self uint32Values do: 
			[:each |
			array uint32AtOffset: 0 put: each.
			self assert: (array uint32AtOffset: 0) equals: each.
			array uint32AtOffset: 0 put: (External.UInt32 fromInteger: each).
			self assert: (array uint32AtOffset: 0) equals: each].
	self should: [array uint32AtOffset: 0 put: -16r80000001] raise: Error.
	self should: [array uint32AtOffset: 0 put: 16rFFFFFFFF + 1] raise: Error!

uint16Values
	^#(16r0 16r1 16r7F 16r80 16r7FFF 16r8000 16rFFFE 16rFFFF)!

uint32Values
	^#(16r0 16r1 16r7F 16r80 16r7FFF 16r8000 16r7FFFFFFF 16r80000000 16rFFFFFFFE 16rFFFFFFFF)! !
!Core.Tests.ByteArrayTest categoriesForMethods!
assimilate:!public!unit tests! !
collectionClass!helpers!private! !
int32Values!constants!private! !
testAsHexString!public! !
testAsUtf16String!public!unit tests! !
testAsUtf8String!public!unit tests! !
testBasicUInt32AtOffsetPut!public!unit tests! !
testFromHexString!public! !
testInt32AtOffsetPut!public!unit tests! !
testInt8AtOffset!public!unit tests! !
testInt8AtOffsetPut!public!unit tests! !
testMixedConcatenation!public! !
testStbRoundTrip!public! !
testUInt16AtOffsetPut!public!unit tests! !
testUInt32AtOffsetPut!public!unit tests! !
uint16Values!constants!private! !
uint32Values!constants!private! !
!

