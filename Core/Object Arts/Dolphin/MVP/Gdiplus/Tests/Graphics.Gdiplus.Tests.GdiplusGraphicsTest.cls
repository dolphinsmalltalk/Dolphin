"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusObjectTest
	subclass: #'Graphics.Gdiplus.Tests.GdiplusGraphicsTest'
	instanceVariableNames: 'bitmap'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GdiplusGraphicsTest guid: (Core.GUID fromString: '{c612875a-7f39-4ba6-80bf-c091a74986db}')!
Graphics.Gdiplus.Tests.GdiplusGraphicsTest comment: 'This TestCase is setup to provide a way to quickly ''test'' a GdiplusGraphics method.

Most of the current tests are kick-the-tyres tests. They all could be extended by adding more asserts, but they are better than nothing

'!
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest methodsFor!

createCanonicalSubject
	bitmap := Bitmap extent: 256 @ 256.
	bitmap erase.
	^self subjectClass fromImage: bitmap!

subjectClass
	^GdiplusGraphics!

tearDown
	super tearDown.
	bitmap free.
	bitmap := nil!

testClone
	self newCanonicalModel.
	self should: [model clone] raise: Error!

testCompositingMode
	self newCanonicalModel.
	model compositingMode: CompositingModeSourceOver.
	self assert: model compositingMode equals: CompositingModeSourceOver.
	model compositingMode: CompositingModeSourceCopy.
	self assert: model compositingMode equals: CompositingModeSourceCopy!

testCompositingQuality
	self newCanonicalModel.
	model compositingQuality: CompositingQualityHighQuality.
	self assert: model compositingQuality equals: CompositingQualityHighQuality.
	model compositingQuality: CompositingQualityGammaCorrected.
	self assert: model compositingQuality equals: CompositingQualityGammaCorrected!

testDrawImageRectRect
	| image |
	self newCanonicalModel.
	image := Image fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model
		drawImage: image
		at: 1 @ 1
		extent: 200 @ 200
		from: 0 @ 0
		extent: 100 @ 100.
	"what exactly am I testing?"
	self assert: (bitmap pixelAt: 0 @ 0) equals: Color white.
	self assert: (bitmap pixelAt: 1 @ 1) equals: Color blue.
	"mmm ... this edge has some kind of alaising?"
	self assert: (bitmap pixelAt: 199 @ 199) equals: Color blue.
	self assert: (bitmap pixelAt: 202 @ 202) equals: Color white.
	image free!

testDrawLine1
	"Kick the tyres test"

	self newCanonicalModel.
	self assert: (bitmap pixelAt: 1 @ 1) equals: Color white.
	model
		drawLineFrom: 0 @ 0
		to: 100 @ 100
		pen: self getSamplePen.
	self assert: (bitmap pixelAt: 1 @ 1) equals: Color red!

testFillEllipse1
	"Kick the tyres test"

	self newCanonicalModel.
	self assert: (bitmap pixelAt: 50 @ 50) equals: Color white.
	model fillEllipse: (0 @ 0 extent: 100 @ 100) brush: Brush green.
	self assert: (bitmap pixelAt: 50 @ 50) equals: Color green!

testFillRectangle1
	"Kick the tyres test"

	self newCanonicalModel.
	model fillRectangle: (0 @ 0 extent: 100 @ 100) brush: Brush red.
	self assert: (bitmap pixelAt: 50 @ 50) equals: Color red!

testFromImage
	| image pixelColor |
	image := Bitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := GdiplusGraphics fromImage: image.
	self assert: model handle class identicalTo: Handle.
	model fillRectangle: (10 @ 20 extent: 10 @ 10) color: Color red.
	pixelColor := image pixelAt: 15 @ 25.
	self assert: pixelColor equals: Color red.
	image free!

testInterpolationMode
	"Default interpolation mode is bilinear"

	self newCanonicalModel.
	self assert: model interpolationMode equals: InterpolationModeBilinear.
	self should: [model interpolationMode: InterpolationModeInvalid] raise: GdiplusError.
	{InterpolationModeHighQuality. InterpolationModeHighQualityBicubic} do: 
			[:each |
			model interpolationMode: each.
			self assert: model interpolationMode equals: InterpolationModeHighQualityBicubic].
	{InterpolationModeBicubic. InterpolationModeNearestNeighbor. InterpolationModeHighQualityBilinear}
		do: 
			[:each |
			model interpolationMode: each.
			self assert: model interpolationMode equals: each].
	{InterpolationModeBilinear. InterpolationModeDefault. InterpolationModeLowQuality} do: 
			[:each |
			model interpolationMode: each.
			self assert: model interpolationMode equals: InterpolationModeBilinear]!

testIsPersistent
	self newCanonicalModel.
	self deny: model isPersistent!

testPageUnit
	self newCanonicalModel.
	self assert: model pageUnit equals: UnitDisplay.
	self assert: model pageUnitName equals: 'UnitDisplay'!

testStbUpgradeFromD7
	| path |
	path := Object
				fromBinaryStoreBytes: #[33 83 84 66 32 52 32 6 3 19 0 71 100 105 112 108 117 115 71 114 97 112 104 105 99 115 80 97 116 104 0 0 0 0 16 0 0 0 6 4 40 0 71 100 105 112 108 117 115 71 114 97 112 104 105 99 115 80 97 116 104 70 114 111 109 80 111 105 110 116 115 73 110 105 116 105 97 108 105 122 101 114 0 0 0 0 98 0 0 0 4 0 0 0 6 2 5 0 80 111 105 110 116 101 0 0 0 71 0 0 0 226 1 0 0 141 0 0 0 71 0 0 0 226 1 0 0 141 0 0 0 151 0 0 0 226 1 0 0 101 0 0 0 151 0 0 0 114 0 0 0 4 0 0 0 0 1 1 129 3 0 0 0].
	self assert: path points equals: (50 @ 35 extent: 20 @ 40) vertices.
	self assert: path types equals: #[0 1 1 129].
	self assert: path fillMode equals: FillModeWinding!

testStlUpgradeFromD7
	| path |
	path := Object
				fromLiteralStoreArray: #(#'!!STL' 4 1245958 ##(Smalltalk.GdiplusGraphicsPath) nil true 2622470 ##(Smalltalk.GdiplusGraphicsPathFromPointsInitializer) nil 34 4 328198 ##(Point) 101 71 482 141 71 482 141 151 482 101 151 8 #[0 1 1 129] 3).
	self assert: path points equals: (50 @ 35 extent: 20 @ 40) vertices.
	self assert: path types equals: #[0 1 1 129].
	self assert: path fillMode equals: FillModeWinding!

testTouchesPoint
	| rect |
	rect := 15 @ 25 extent: 50 @ 100.
	model := GraphicsPath fromRectangle: rect.
	self assert: (model touchesPoint: rect origin).
	self assert: (model touchesPoint: rect corner).
	self deny: (model touchesPoint: rect origin + 1).
	self deny: (model touchesPoint: rect corner - 1).
	self assert: (model touchesPoint: rect origin + 1 pen: (Pen color: Color black width: 3))!

testWiden
	| rect bitmap graphics pen |
	model := GraphicsPath new.
	rect := 15 @ 25 extent: 50 @ 100.
	model := GraphicsPath fromRectangle: rect.
	self assert: (model containsPoint: rect center).
	pen := Pen black width: 5.
	"Widening with a centred pen creates artefacts at the line joins"
	pen beInset.
	bitmap := Bitmap extent: 300 @ 150.
	graphics := bitmap graphics.
	graphics
		fillPath: model brush: Brush red;
		drawPath: model pen: pen.
	model
		widen: nil
		pen: pen
		flatness: 1.
	self deny: (model containsPoint: rect center).
	0 to: 4 do: [:i | self assert: (model containsPoint: rect origin + i)].
	graphics
		translate: (rect width + 10) @ 0;
		fillPath: model brush: Brush green;
		drawPath: model pen: Pen black.
	"With curves"
	model := GraphicsPath new.
	model addEllipse: rect.
	self assert: (model containsPoint: rect center).
	graphics
		translate: (rect width + 10) @ 0;
		fillPath: model brush: Brush blue;
		drawPath: model pen: pen.
	model
		widen: nil
		pen: pen
		flatness: 0.25.
	self deny: (model containsPoint: rect center).
	0 to: 4 do: [:i | self assert: (model containsPoint: rect leftCenter + (i @ 0))].
	graphics
		translate: (rect width + 10) @ 0;
		fillPath: model brush: Brush green;
		drawPath: model pen: Pen black.
	false ifTrue: [bitmap showExample]! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesForMethods!
createCanonicalSubject!private!running! !
subjectClass!constants!private! !
tearDown!public!running! !
testClone!public!unit tests! !
testCompositingMode!public!unit tests! !
testCompositingQuality!public!unit tests! !
testDrawImageRectRect!public!unit tests! !
testDrawLine1!public!unit tests! !
testFillEllipse1!public!unit tests! !
testFillRectangle1!public!unit tests! !
testFromImage!public!unit tests! !
testInterpolationMode!public!unit tests! !
testIsPersistent!public!unit tests! !
testPageUnit!public!unit tests! !
testStbUpgradeFromD7!public!unit tests! !
testStlUpgradeFromD7!public!unit tests! !
testTouchesPoint!public!unit tests! !
testWiden!public!unit tests! !
!

