"Filed out from Dolphin Smalltalk 7"!

ArrayedCollectionTest subclass: #ByteArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ByteArrayTest guid: (GUID fromString: '{F83D3BB0-C4B4-4F92-9D89-FD89E6E25DA1}')!
ByteArrayTest comment: ''!
!ByteArrayTest categoriesForClass!Unclassified! !
!ByteArrayTest methodsFor!

assimilate: anObject 
	^anObject asInteger!

collectionClass
	^ByteArray!

dwordValues
	^#(16r0 16r1 16r7F 16r80 16r7FFF 16r8000 16r7FFFFFFF 16r80000000 16rFFFFFFFE 16rFFFFFFFF)!

testBasicDwordAtOffsetPut
	"#1457"

	| array |
	array := ByteArray new: 4.
	self assert: (array dwordAtOffset: 0) = 0.
	self dwordValues do: 
			[:each | 
			array basicDwordAtOffset: 0 put: each.
			self assert: (array dwordAtOffset: 0) = each.
			array basicDwordAtOffset: 0 put: (DWORD fromInteger: each).
			self assert: (array dwordAtOffset: 0) = each].
	self should: [array basicDwordAtOffset: 0 put: -16r80000001] raise: Error.
	self should: [array basicDwordAtOffset: 0 put: 16rFFFFFFFF + 1] raise: Error!

testDwordAtOffsetPut
	"#1457"

	| array |
	array := ByteArray new: 4.
	self assert: (array dwordAtOffset: 0) = 0.
	self dwordValues do: 
			[:each | 
			array dwordAtOffset: 0 put: each.
			self assert: (array dwordAtOffset: 0) = each.
			array dwordAtOffset: 0 put: (DWORD fromInteger: each).
			self assert: (array dwordAtOffset: 0) = each].
	self should: [array dwordAtOffset: 0 put: -16r80000001] raise: Error.
	self should: [array dwordAtOffset: 0 put: 16rFFFFFFFF + 1] raise: Error!

testSbyteAtOffset
	0 to: 127 do: [:each | self assert: ((ByteArray with: each) sbyteAtOffset: 0) = each].
	128 to: 255
		do: [:each | self assert: ((ByteArray with: each) sbyteAtOffset: 0) = (each - 256)]!

testSbyteAtOffsetPut
	| array |
	array := ByteArray new: 1.
	self assert: (array at: 1) = 0.
	127 to: 0
		by: -1
		do: 
			[:each | 
			array sbyteAtOffset: 0 put: each.
			self assert: (array at: 1) = each].
	-128 to: -1
		do: 
			[:each | 
			array sbyteAtOffset: 0 put: each.
			self assert: (array at: 1) = (each bitAnd: 255)]!

testWordAtOffsetPut
	"#1457"

	| array |
	array := ByteArray new: 4.
	self assert: (array wordAtOffset: 0) = 0.
	self wordValues do: 
			[:each | 
			array wordAtOffset: 0 put: each.
			self assert: (array wordAtOffset: 0) = each.
			array wordAtOffset: 0 put: (WORD fromInteger: each).
			self assert: (array wordAtOffset: 0) = each].
	self should: [array wordAtOffset: 0 put: -16r8001] raise: Error.
	self should: [array wordAtOffset: 0 put: 16rFFFF + 1] raise: Error!

wordValues
	^#(16r0 16r1 16r7F 16r80 16r7FFF 16r8000 16rFFFE 16rFFFF)! !
!ByteArrayTest categoriesFor: #assimilate:!public!unit tests! !
!ByteArrayTest categoriesFor: #collectionClass!helpers!private! !
!ByteArrayTest categoriesFor: #dwordValues!constants!private! !
!ByteArrayTest categoriesFor: #testBasicDwordAtOffsetPut!public!unit tests! !
!ByteArrayTest categoriesFor: #testDwordAtOffsetPut!public!unit tests! !
!ByteArrayTest categoriesFor: #testSbyteAtOffset!public!unit tests! !
!ByteArrayTest categoriesFor: #testSbyteAtOffsetPut!public!unit tests! !
!ByteArrayTest categoriesFor: #testWordAtOffsetPut!public!unit tests! !
!ByteArrayTest categoriesFor: #wordValues!constants!private! !

