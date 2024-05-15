"Filed out from Dolphin Smalltalk"!

AbstractBitmapTest subclass: #DIBSectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DIBSectionTest guid: (GUID fromString: '{7cc7f7b0-9a77-4ae5-b984-9eaea2c7e885}')!

DIBSectionTest comment: ''!

!DIBSectionTest categoriesForClass!Unclassified! !

!DIBSectionTest methodsFor!

subjectClass
	^DIBSection!

testStbConvertFromVersion1
	| bytes dib |
	bytes := #[33 83 84 66 32 48 32 70 9 10 0 1 0 0 0 68 73 66 83 101 99 116 105 111 110 0 0 0 0 0 0 0 0 16 0 0 0 54 0 6 0 83 116 114 105 110 103 17 0 0 0 68 111 108 112 104 105 110 83 112 108 97 115 104 46 98 109 112 14 2 31 0 83 84 66 69 120 116 101 114 110 97 108 82 101 115 111 117 114 99 101 76 105 98 114 97 114 121 80 114 111 120 121 0 0 0 0 114 0 0 0 13 0 0 0 68 111 108 112 104 105 110 68 101 118 82 101 115 0 0 0 0 0 0 0 0 32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	dib := Object fromBinaryStoreBytes: bytes.
	self assert: dib isKindOf: DIBSection.
	self assert: dib ownsHandle.
	self assert: (dib instVarNamed: 'flags') equals: 0.
	#('extent' 'depth' 'imageBits') do: [:each | self assertIsNil: (dib instVarNamed: each)].
	self assert: dib identifier equals: 'dolphinsplash.bmp'.! !

!DIBSectionTest categoriesForMethods!
subjectClass!constants!private! !
testStbConvertFromVersion1!public!unit tests! !
!

