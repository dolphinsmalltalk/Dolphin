"Filed out from Dolphin Smalltalk"!

GenericExternalArrayTest subclass: #StructureArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StructureArrayTest guid: (GUID fromString: '{1ab5e35e-9c82-4aa7-9c28-f51cb3baa646}')!

StructureArrayTest comment: ''!

!StructureArrayTest categoriesForClass!Unclassified! !

!StructureArrayTest methodsFor!

arrayClass
	^StructureArray!

newArrayOfIntegers: anArray
	^self arrayClass withAll: (anArray collect: [:each | self elementFromValue: each])
		elementClass: self numericElementClass!

testMarshal
	self
		should: [super testMarshal]
		raise: Error
		matching: [:ex | ex description = 'StructureArray class should not implement #withAll:']!

testStbConvertFromVersion0
	| bytes array |
	bytes := #[33 83 84 66 32 48 32 6 3 14 0 83 116 114 117 99 116 117 114 101 65 114 114 97 121 0 0 0 0 54 0 9 0 66 121 116 101 65 114 114 97 121 12 0 0 0 1 0 0 0 4 0 0 0 9 0 0 0 7 0 0 0 14 1 13 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 5 0 0 0 68 87 79 82 68].
	"STBDebugger dumpToTranscript: bytes readStream"
	array := Object fromBinaryStoreBytes: bytes.
	self assert: array isKindOf: StructureArray.
	self assert: array elementClass equals: DWORD.
	self assert: array asArray equals: ((1 to: 3) collect: [:i | i * i])! !

!StructureArrayTest categoriesForMethods!
arrayClass!constants!private! !
newArrayOfIntegers:!helpers!private! !
testMarshal!public! !
testStbConvertFromVersion0!public! !
!

