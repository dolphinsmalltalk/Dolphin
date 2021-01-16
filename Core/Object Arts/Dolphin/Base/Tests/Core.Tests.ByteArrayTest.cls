"Filed out from Dolphin Smalltalk 7"!

Core.Tests.ArrayedCollectionTest subclass: #'Core.Tests.ByteArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ByteArrayTest guid: (Core.GUID fromString: '{f83d3bb0-c4b4-4f92-9d89-fd89e6e25da1}')!
Core.Tests.ByteArrayTest comment: ''!
!Core.Tests.ByteArrayTest categoriesForClass!Unclassified! !
!Core.Tests.ByteArrayTest methodsFor!

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
			array basicDwordAtOffset: 0 put: (External.DWORD fromInteger: each).
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
			array dwordAtOffset: 0 put: (External.DWORD fromInteger: each).
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
			array sdwordAtOffset: 0 put: (External.SDWORD fromInteger: each).
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
			array wordAtOffset: 0 put: (External.WORD fromInteger: each).
			self assert: (array wordAtOffset: 0) equals: each].
	{-16r8001. 16rFFFF + 1} do: 
			[:each |
			self
				should: [array wordAtOffset: 0 put: each]
				raise: OS.HRESULTError
				matching: [:ex | ex hresult = (OS.HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.IntegerOutOfRange)]]!

wordValues
	^#(16r0 16r1 16r7F 16r80 16r7FFF 16r8000 16rFFFE 16rFFFF)! !
!Core.Tests.ByteArrayTest categoriesFor: #assimilate:!public!unit tests! !
!Core.Tests.ByteArrayTest categoriesFor: #collectionClass!helpers!private! !
!Core.Tests.ByteArrayTest categoriesFor: #dwordValues!constants!private! !
!Core.Tests.ByteArrayTest categoriesFor: #sdwordValues!constants!private! !
!Core.Tests.ByteArrayTest categoriesFor: #testBasicDwordAtOffsetPut!public!unit tests! !
!Core.Tests.ByteArrayTest categoriesFor: #testDwordAtOffsetPut!public!unit tests! !
!Core.Tests.ByteArrayTest categoriesFor: #testFromHexString!public! !
!Core.Tests.ByteArrayTest categoriesFor: #testMixedConcatenation!public! !
!Core.Tests.ByteArrayTest categoriesFor: #testSbyteAtOffset!public!unit tests! !
!Core.Tests.ByteArrayTest categoriesFor: #testSbyteAtOffsetPut!public!unit tests! !
!Core.Tests.ByteArrayTest categoriesFor: #testSDwordAtOffsetPut!public!unit tests! !
!Core.Tests.ByteArrayTest categoriesFor: #testWordAtOffsetPut!public!unit tests! !
!Core.Tests.ByteArrayTest categoriesFor: #wordValues!constants!private! !

