"Filed out from Dolphin Smalltalk"!

Graphics.Tests.AbstractBitmapTest
	subclass: #'Graphics.Tests.BitmapTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.BitmapTest guid: (Core.GUID fromString: '{e775dfbb-e3db-47cd-aec2-8b0ebe5b7498}')!

Graphics.Tests.BitmapTest comment: ''!

!Graphics.Tests.BitmapTest methodsFor!

stlVersion3_file
	^#(#'!!STL' 3 395334 3 ##(Smalltalk.Bitmap) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'resources\Beach Ball.bmp' 0 0 1 0)!

stlVersion3_resource
	^#(#'!!STL' 3 395334 3 ##(Smalltalk.Bitmap)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'tools.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 1 0)!

subjectClass
	^Bitmap!

testStbConvertFromVersion1
	| bytes bitmap |
	bytes := #[33 83 84 66 32 48 32 70 7 6 0 1 0 0 0 66 105 116 109 97 112 0 0 0 0 0 0 0 0 16 0 0 0 54 0 6 0 83 116 114 105 110 103 11 0 0 0 70 73 78 68 66 65 82 46 66 77 80 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 0 0 0 0 14 1 13 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 114 0 0 0 9 0 0 0 86 77 76 105 98 114 97 114 121 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 114 0 0 0 7 0 0 0 100 101 102 97 117 108 116 0 0 0 0 16 0 0 0 0 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	bitmap := Object fromBinaryStoreBytes: bytes.
	self assert: bitmap isKindOf: Bitmap.
	self assert: bitmap ownsHandle.
	self assert: (bitmap instVarNamed: 'flags') equals: 0.
	self assertIsNil: (bitmap instVarNamed: 'extent').
	self assert: bitmap initializer isKindOf: ImageFromStringResourceInitializer.
	self assert: bitmap initializer identifier equals: 'FINDBAR.BMP'.
	self assert: bitmap initializer module equals: VM.
	self assert: bitmap initializer isLoadMap3dColors.
	bitmap free!

testStbConvertFromVersion3
	| bytes bitmap |
	bytes := #[33 83 84 66 32 49 32 70 8 6 0 3 0 0 0 66 105 116 109 97 112 0 0 0 0 0 0 0 0 16 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 0 0 0 0 154 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 68 111 108 112 104 105 110 82 0 0 0 24 0 0 0 73 109 97 103 101 82 101 108 97 116 105 118 101 70 105 108 101 76 111 99 97 116 111 114 186 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 99 117 114 114 101 110 116 82 0 0 0 9 0 0 0 84 111 111 108 115 46 98 109 112 14 2 31 0 83 84 66 69 120 116 101 114 110 97 108 82 101 115 111 117 114 99 101 76 105 98 114 97 114 121 80 114 111 120 121 0 0 0 0 82 0 0 0 16 0 0 0 100 111 108 112 104 105 110 100 114 48 48 53 46 100 108 108 0 0 0 0 0 0 0 0 71 0 0 0 6 2 5 0 80 111 105 110 116 0 0 0 0 33 7 0 0 33 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	bitmap := Object fromBinaryStoreBytes: bytes.
	self assert: bitmap isKindOf: Bitmap.
	self assert: bitmap ownsHandle.
	self assert: bitmap isShared.
	self assert: bitmap initializer isKindOf: ImageFromStringResourceInitializer.
	self assert: bitmap initializer identifier equals: 'Tools.bmp'.
	self assert: bitmap initializer module equals: SessionManager current defaultResourceLibrary.
	self assert: bitmap initializer isLoadMap3dColors.
	self assert: bitmap extent y equals: 16.
	bitmap free! !

!Graphics.Tests.BitmapTest categoriesForMethods!
stlVersion3_file!constants!private! !
stlVersion3_resource!constants!private! !
subjectClass!constants!private! !
testStbConvertFromVersion1!public!unit tests! !
testStbConvertFromVersion3!public!unit tests! !
!

