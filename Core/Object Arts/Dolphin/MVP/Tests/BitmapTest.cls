"Filed out from Dolphin Smalltalk"!

AbstractBitmapTest subclass: #BitmapTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BitmapTest guid: (GUID fromString: '{198f053d-2783-437c-becd-ae8b1b956af5}')!

BitmapTest comment: ''!

!BitmapTest categoriesForClass!Unclassified! !

!BitmapTest methodsFor!

beachBallColorDepth
	^SystemMetrics current defaultColorDepth!

subjectClass
	^Bitmap!

testStbConvertFromVersion1
	| bytes bitmap |
	bytes := #[33 83 84 66 32 48 32 70 7 6 0 1 0 0 0 66 105 116 109 97 112 0 0 0 0 0 0 0 0 16 0 0 0 54 0 6 0 83 116 114 105 110 103 11 0 0 0 70 73 78 68 66 65 82 46 66 77 80 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 0 0 0 0 14 1 13 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 114 0 0 0 9 0 0 0 86 77 76 105 98 114 97 114 121 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 114 0 0 0 7 0 0 0 100 101 102 97 117 108 116 0 0 0 0 16 0 0 0 0 0 0 0].
	"STBDebugger dumpToTranscript: bytes readStream"
	bitmap := Object fromBinaryStoreBytes: bytes.
	self assert: bitmap isKindOf: Bitmap.
	self assert: bitmap ownsHandle.
	self assert: (bitmap instVarNamed: 'flags') equals: Bitmap.Map3DColorsMask.
	self assertIsNil: (bitmap instVarNamed: 'extent').
	self assert: bitmap identifier equals: 'findbar.bmp'.
	self assert: bitmap instanceHandle equals: VMLibrary default.
	bitmap free! !

!BitmapTest categoriesForMethods!
beachBallColorDepth!constants!private! !
subjectClass!constants!private! !
testStbConvertFromVersion1!public! !
!

