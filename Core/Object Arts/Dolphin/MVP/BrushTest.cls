"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #BrushTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
BrushTest guid: (GUID fromString: '{1128ddc3-7330-4539-bc63-7a60b93fe7bc}')!
BrushTest comment: ''!
!BrushTest categoriesForClass!Unclassified! !
!BrushTest methodsFor!

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
	MemoryManager current
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

testStbConversion
	"brush := Brush withStyle: BS_HATCHED color: (RGB red: 50 green: 150 blue: 250) hatch: HS_BDIAGONAL.
	version0bytes := brush binaryStoreBytes"

	| brush version0bytes |
	version0bytes := #[33 83 84 66 32 50 32 6 3 5 0 66 114 117 115 104 0 0 0 0 0 0 0 0 16 0 0 0 6 1 8 0 76 79 71 66 82 85 83 72 0 0 0 0 114 0 0 0 12 0 0 0 2 0 0 0 50 150 250 0 3 0 0 0].
	brush := Object fromBinaryStoreBytes: version0bytes.
	self assert: brush class identicalTo: Brush.
	self assert: brush logBrush color
		equals: (RGB
				red: 50
				green: 150
				blue: 250).
	self assert: brush logBrush hatch equals: HS_BDIAGONAL.
	self assert: brush logBrush style equals: BS_HATCHED! !
!BrushTest categoriesFor: #testBitmapBrush!public!unit tests! !
!BrushTest categoriesFor: #testStbConversion!public!unit tests! !

