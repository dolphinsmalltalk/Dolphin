"Filed out from Dolphin Smalltalk"!

ArrayedCollectionTest subclass: #ByteArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ByteArrayTest guid: (GUID fromString: '{f83d3bb0-c4b4-4f92-9d89-fd89e6e25da1}')!

ByteArrayTest comment: ''!

!ByteArrayTest categoriesForClass!Unclassified! !

!ByteArrayTest methodsFor!

assimilate: anObject 
	^anObject asInteger!

collectionClass
	^ByteArray!

dwordValues
	^#(16r0 16r1 16r7F 16r80 16r7FFF 16r8000 16r7FFFFFFF 16r80000000 16rFFFFFFFE 16rFFFFFFFF)!

sdwordValues
	^#(-16r7FFFFFFF -16r8000 -16r7FFF -16r80 -16r7F -16r1 16r0 16r1 16r7F 16r80 16r7FFF 16r8000 16r7FFFFFFF)!

testBasicDwordAtOffsetPut
	"#1457"

	| array |
	array := ByteArray new: 4.
	self assert: (array dwordAtOffset: 0) equals: 0.
	self dwordValues do: 
			[:each |
			array basicDwordAtOffset: 0 put: each.
			self assert: (array dwordAtOffset: 0) equals: each.
			array basicDwordAtOffset: 0 put: (DWORD fromInteger: each).
			self assert: (array dwordAtOffset: 0) equals: each].
	self should: [array basicDwordAtOffset: 0 put: -16r80000001] raise: Error.
	self should: [array basicDwordAtOffset: 0 put: 16rFFFFFFFF + 1] raise: Error!

testDwordAtOffsetPut
	"#1457"

	| array |
	array := ByteArray new: 4.
	self assert: (array dwordAtOffset: 0) equals: 0.
	self dwordValues do: 
			[:each |
			array dwordAtOffset: 0 put: each.
			self assert: (array dwordAtOffset: 0) equals: each.
			array dwordAtOffset: 0 put: (DWORD fromInteger: each).
			self assert: (array dwordAtOffset: 0) equals: each].
	self should: [array dwordAtOffset: 0 put: -16r80000001] raise: Error.
	self should: [array dwordAtOffset: 0 put: 16rFFFFFFFF + 1] raise: Error!

testFromHexString
	| hex expected |
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
	self assert: (ByteArray fromHexString: hex) equals: expected.
	self assert: (ByteArray fromHexString: '') equals: #[].
	"We allow lower case chars too."
	self assert: (ByteArray fromHexString: 'fe') equals: #[254].
	#(' 0' '1 ' 'GH' '1') do: [:each | self should: [ByteArray fromHexString: each] raise: Error]!

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
	{'a'.
		#(255).
		OrderedCollection with: 123.
		100 to: 100.
		'ab'.
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

testSbyteAtOffset
	0 to: 127 do: [:each | self assert: ((ByteArray with: each) sbyteAtOffset: 0) equals: each].
	128 to: 255 do: [:each | self assert: ((ByteArray with: each) sbyteAtOffset: 0) equals: each - 256]!

testSbyteAtOffsetPut
	| array |
	array := ByteArray new: 1.
	self assert: (array at: 1) equals: 0.
	127 to: 0
		by: -1
		do: 
			[:each |
			array sbyteAtOffset: 0 put: each.
			self assert: (array at: 1) equals: each].
	-128 to: -1
		do: 
			[:each |
			array sbyteAtOffset: 0 put: each.
			self assert: (array at: 1) equals: (each bitAnd: 255)]!

testSDwordAtOffsetPut

	| array |
	array := ByteArray new: 4.
	self assert: (array sdwordAtOffset: 0) equals: 0.
	self sdwordValues do: 
			[:each |
			array sdwordAtOffset: 0 put: each.
			self assert: (array sdwordAtOffset: 0) equals: each.
			array sdwordAtOffset: 0 put: (SDWORD fromInteger: each).
			self assert: (array sdwordAtOffset: 0) equals: each].
	self should: [array sdwordAtOffset: 0 put: -16r80000001] raise: Error.
	self should: [array sdwordAtOffset: 0 put: 16r80000000] raise: Error!

testWordAtOffsetPut
	"#1457"

	| array |
	array := ByteArray new: 4.
	self assert: (array wordAtOffset: 0) equals: 0.
	self wordValues do: 
			[:each |
			array wordAtOffset: 0 put: each.
			self assert: (array wordAtOffset: 0) equals: each.
			array wordAtOffset: 0 put: (WORD fromInteger: each).
			self assert: (array wordAtOffset: 0) equals: each].
	{-16r8001. 16rFFFF + 1} do: 
			[:each |
			self
				should: [array wordAtOffset: 0 put: each]
				raise: HRESULTError
				matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.IntegerOutOfRange)]]!

wordValues
	^#(16r0 16r1 16r7F 16r80 16r7FFF 16r8000 16rFFFE 16rFFFF)! !

!ByteArrayTest categoriesForMethods!
assimilate:!public!unit tests! !
collectionClass!helpers!private! !
dwordValues!constants!private! !
sdwordValues!constants!private! !
testBasicDwordAtOffsetPut!public!unit tests! !
testDwordAtOffsetPut!public!unit tests! !
testFromHexString!public! !
testMixedConcatenation!public! !
testSbyteAtOffset!public!unit tests! !
testSbyteAtOffsetPut!public!unit tests! !
testSDwordAtOffsetPut!public!unit tests! !
testWordAtOffsetPut!public!unit tests! !
wordValues!constants!private! !
!

