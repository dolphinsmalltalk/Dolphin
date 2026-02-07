"Filed out from Dolphin Smalltalk"!

External.Tests.GenericExternalArrayTest
	subclass: #'External.Tests.StructureArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.StructureArrayTest guid: (Core.GUID fromString: '{1ab5e35e-9c82-4aa7-9c28-f51cb3baa646}')!

External.Tests.StructureArrayTest comment: ''!

!External.Tests.StructureArrayTest methodsFor!

newTestSubjectOfSize: anInteger
	^self arrayClass withAll: (self exampleElements: anInteger)
		elementClass: self class numericElementClass!

newTestSubjectWithElements: anArray
	^self arrayClass withAll: anArray
		elementClass: self class numericElementClass!

testCollectGuids
	| guids strings |
	guids := StructureArray length: 2 elementClass: GUID.
	guids at: 1 put: StructureArray guid.
	guids at: 2 put: self class guid.
	strings := guids collect: [:each | each printString].
	self assert: strings equals: {StructureArray guid printString. self class guid printString}!

testMarshal
	self
		should: [super testMarshal]
		raise: Error
		matching: [:ex | ex description beginsWith: 'StructureArray class should not implement']!

testStbConvertFrom0
	| bytes array |
	bytes := #[33 83 84 66 32 48 32 6 3 14 0 83 116 114 117 99 116 117 114 101 65 114 114 97 121 0 0 0 0 54 0 9 0 66 121 116 101 65 114 114 97 121 12 0 0 0 1 0 0 0 4 0 0 0 9 0 0 0 7 0 0 0 14 1 13 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 5 0 0 0 68 87 79 82 68].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	array := Object fromBinaryStoreBytes: bytes.
	self assert: array isKindOf: StructureArray.
	self assert: array elementClass equals: UInt32.
	self assert: array asArray equals: ((1 to: 3) collect: [:i | i * i])!

testStlConvertFrom1
	| array |
	array := Object
				fromLiteralStoreArray: #(#'!!STL' 6 1350 1 #{External.StructureArray} 8 #[1 0 0 0 4 0 0 0 9 0 0 0] 7 #{External.UInt32} nil 9).
	self assert: array isKindOf: StructureArray.
	self assert: array elementClass equals: UInt32.
	self assert: array asArray equals: ((1 to: 3) collect: [:i | i * i])!

testStlConvertFrom2
	
	| stl2 array |
	stl2 := #(#'!!STL' 6 1350 2 #{External.StructureArray} 8 #[1 0 0 0 4 0 0 0 9 0 0 0] nil 7 #{External.UInt32} 9).
	array := Object fromLiteralStoreArray: stl2.
	self assert: array isKindOf: StructureArray.
	self assert: array elementClass equals: UInt32.
	self assert: array asArray equals: ((1 to: 3) collect: [:i | i * i])! !

!External.Tests.StructureArrayTest categoriesForMethods!
newTestSubjectOfSize:!helpers!private! !
newTestSubjectWithElements:!helpers!private! !
testCollectGuids!public!unit tests! !
testMarshal!public!unit tests! !
testStbConvertFrom0!public!unit tests! !
testStlConvertFrom1!public!unit tests! !
testStlConvertFrom2!public!unit tests! !
!

!External.Tests.StructureArrayTest class methodsFor!

arrayClass
	^StructureArray! !

!External.Tests.StructureArrayTest class categoriesForMethods!
arrayClass!constants!private! !
!

