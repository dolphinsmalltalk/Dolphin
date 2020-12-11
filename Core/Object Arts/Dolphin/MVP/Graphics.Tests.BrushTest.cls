"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Graphics.Tests.BrushTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.BrushTest guid: (Core.GUID fromString: '{1128ddc3-7330-4539-bc63-7a60b93fe7bc}')!
Graphics.Tests.BrushTest comment: ''!
!Graphics.Tests.BrushTest categoriesForClass!Unclassified! !
!Graphics.Tests.BrushTest methodsFor!

testBitmapBrush
	| bmp bmp2 brush pels1 extent pels2 |
	bmp := DIBSection fromId: 'xhatch.bmp'.
	extent := bmp extent.
	pels1 := (0 to: extent x - 1)
				collect: [:x | (0 to: extent y - 1) collect: [:y | bmp canvas pixelAt: x @ y]].
	bmp2 := DIBSection
				width: extent x
				height: extent y
				depth: bmp depth.
	bmp2 setColorTable: bmp getColorTable.
	bmp freeDC.
	brush := Brush bitmap: bmp.
	"Comment out the next line, and the test will run without patch #1052"
	bmp := nil.
	Kernel.MemoryManager current
		collectGarbage;
		administerLastRites.
	bmp2 canvas
		brush: brush;
		fillRectangle: (0 @ 0 extent: extent).
	pels2 := (0 to: extent x - 1)
				collect: [:x | (0 to: extent y - 1) collect: [:y | bmp2 canvas pixelAt: x @ y]].
	bmp2 freeDC.
	self assert: pels1 equals: pels2

	"
bmp getColorTable asArray
bmp2 getColorTable
a StructureArray(a RGBQUAD(rgbBlue=0 rgbGreen=255 rgbRed=0) a RGBQUAD(rgbBlue=0 rgbGreen=0 rgbRed=0))
ImagePresenter showOn: bmp2
"!

testPrintString
	self assert: (Brush diagonal: Color goldenrod) printString
		equals: '(Brush diagonal: Color goldenrod)'.
	self assert: Brush cross printString equals: 'Brush cross'.
	self assert: Brush silver printString equals: 'Brush silver'.
	self assert: Brush transparent printString equals: 'Brush transparent'.
	self assert: Color face3d brush printString equals: '(Brush color: Color face3d)'.
	self assert: Color red brush printString equals: '(Brush color: Color red)'

!

testStbConversion
	"Test deserializing Brushes serialized at version 0"

	| brush version0bytes |
	"(Brush withStyle: BS_HATCHED color: (RGB red: 50 green: 150 blue: 250) hatch: HS_BDIAGONAL) binaryStoreBytes"
	version0bytes := #[33 83 84 66 32 50 32 6 3 5 0 66 114 117 115 104 0 0 0 0 0 0 0 0 16 0 0 0 6 1 8 0 76 79 71 66 82 85 83 72 0 0 0 0 114 0 0 0 12 0 0 0 2 0 0 0 50 150 250 0 3 0 0 0].
	brush := Object fromBinaryStoreBytes: version0bytes.
	self assert: brush class identicalTo: Brush.
	self assert: brush logBrush color
		equals: (Color
				r: 50
				g: 150
				b: 250).
	self assert: brush logBrush hatch equals: HS_BDIAGONAL.
	self assert: brush logBrush style equals: BS_HATCHED.
	"Color window brush binaryStoreBytes"
	version0bytes := #[33 83 84 66 32 52 32 6 4 13 0 83 121 115 67 111 108 111 114 66 114 117 115 104 0 0 0 0 32 0 0 0 0 0 0 0 11 0 0 0].
	brush := Object fromBinaryStoreBytes: version0bytes.
	self assert: brush class identicalTo: Brush sysColorBrushClass.
	self assert: brush color equals: Color window!

testStbConversion2
	"
	brush := Brush withStyle: BS_HATCHED color: (Color red: 50 green: 150 blue: 250) hatch: HS_BDIAGONAL.
	version0Stl := brush literalStoreArray
	"

	| brush version0Stl |
	version0Stl := #(#'!!STL' 4 328454 ##(Brush) nil true 524870 1 ##(LOGBRUSH) 8 #[2 0 0 0 50 150 250 0 3 0 0 0] 7).
	brush := Object fromLiteralStoreArray: version0Stl.
	self assert: brush class identicalTo: Brush.
	self assert: brush logBrush color
		equals: (Color
				r: 50
				g: 150
				b: 250).
	self assert: brush logBrush hatch equals: HS_BDIAGONAL.
	self assert: brush logBrush style equals: BS_HATCHED! !
!Graphics.Tests.BrushTest categoriesFor: #testBitmapBrush!public!unit tests! !
!Graphics.Tests.BrushTest categoriesFor: #testPrintString!public!unit tests! !
!Graphics.Tests.BrushTest categoriesFor: #testStbConversion!public!unit tests! !
!Graphics.Tests.BrushTest categoriesFor: #testStbConversion2!public!unit tests! !

