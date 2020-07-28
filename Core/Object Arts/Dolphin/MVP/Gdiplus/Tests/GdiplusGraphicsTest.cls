"Filed out from Dolphin Smalltalk 7"!

GdiplusTests subclass: #GdiplusGraphicsTest
	instanceVariableNames: 'bitmap graphics canvas'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusGraphicsTest guid: (GUID fromString: '{c612875a-7f39-4ba6-80bf-c091a74986db}')!
GdiplusGraphicsTest comment: 'This TestCase is setup to provide a way to quickly ''test'' a GdiplusGraphics method.

Most of the current tests are kick-the-tyres tests. They all could be extended by adding more asserts, but they are better than nothing

'!
!GdiplusGraphicsTest categoriesForClass!Unclassified! !
!GdiplusGraphicsTest methodsFor!

setUp
	super setUp.
	bitmap := DIBSection displayCompatibleWithExtent: 256 @ 256.
	canvas := bitmap canvas.
	canvas erase.
	graphics := GdiplusGraphics fromCanvas: canvas!

tearDown
	graphics ifNotNil: 
			[:g | 
			graphics := nil.
			g free].
	canvas ifNotNil: 
			[:c | 
			canvas := nil.
			c free].
	bitmap ifNotNil: 
			[:b | 
			bitmap := nil.
			b free].
	super tearDown!

testCompositingMode
	graphics compositingMode: CompositingModeSourceOver.
	self assert: graphics compositingMode equals: CompositingModeSourceOver.
	graphics compositingMode: CompositingModeSourceCopy.
	self assert: graphics compositingMode equals: CompositingModeSourceCopy!

testCompositingQuality
	graphics compositingQuality: CompositingQualityHighQuality.
	self assert: graphics compositingQuality equals: CompositingQualityHighQuality.
	graphics compositingQuality: CompositingQualityGammaCorrected.
	self assert: graphics compositingQuality equals: CompositingQualityGammaCorrected!

testDrawImageRectRect
	| image |
	image := GdiplusImage fromFile: self fileResource pafRgb0000FF_100x100bmp.
	graphics
		drawImage: image
		at: 1 @ 1
		extent: 200 @ 200
		from: 0 @ 0
		extent: 100 @ 100.
	"what exactly am I testing?"
	self assert: (canvas pixelAt: 0 @ 0) equals: Color white.
	self assert: (canvas pixelAt: 1 @ 1) equals: Color blue.
	"mmm ... this edge has some kind of alaising?"
	self assert: (canvas pixelAt: 199 @ 199) equals: Color blue.
	self assert: (canvas pixelAt: 202 @ 202) equals: Color white!

testDrawLine1
	"Kick the tyres test"

	graphics 
		drawLineFrom: 0 @ 0
		to: 100 @ 100
		pen: self getSamplePen!

testFillEllipse1
	"Kick the tyres test"

	graphics fillEllipse: (0 @ 0 extent: 100 @ 100) brush: self getSampleBrush!

testFillEllipse2
	"Kick the tyres test"

	graphics fillEllipse: (0 @ 0 extent: 100 @ 100) brush: self getSampleBrush!

testFillRectangle1
	"Kick the tyres test"

	graphics fillRectangle: (0 @ 0 extent: 100 @ 100) brush: self getSampleBrush!

testFillRectangle2
	"Kick the tyres test"

	graphics fillRectangle: (0 @ 0 extent: 100 @ 100) brush: self getSampleBrush!

testFromCanvas
	| bmp |
	bmp := self getSampleGDIBitmap.
	model := GdiplusGraphics fromCanvas: bmp canvas.
	self assert: model handle class identicalTo: ExternalHandle!

testFromImage
	| image pixel pixelColor |
	image := GdiplusBitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := GdiplusGraphics fromImage: image.
	self assert: model handle class identicalTo: ExternalHandle.
	"Can the next 2 lines replace those below them?"
	pixelColor := image pixelAt: 50 @ 50.
	self assert: pixelColor equals: Color blue
	"model doWithCanvas: [:aCanvas | pixel := aCanvas getPixel: 50 @ 50]."
	"mmm ... format 'mismatch'?"
	"pixelColor := RGB fromInteger: pixel.
	self assert: pixel = ARGB blue code"!

testInterpolationMode
	"Default interpolation mode is bilinear"

	self assert: graphics interpolationMode equals: InterpolationModeBilinear.
	self should: [graphics interpolationMode: InterpolationModeInvalid] raise: GdiplusError.
	{InterpolationModeHighQuality. InterpolationModeHighQualityBicubic} do: 
			[:each |
			graphics interpolationMode: each.
			self assert: graphics interpolationMode equals: InterpolationModeHighQualityBicubic].
	{InterpolationModeBicubic. InterpolationModeNearestNeighbor. InterpolationModeHighQualityBilinear}
		do: 
			[:each |
			graphics interpolationMode: each.
			self assert: graphics interpolationMode equals: each].
	{InterpolationModeBilinear. InterpolationModeDefault. InterpolationModeLowQuality} do: 
			[:each |
			graphics interpolationMode: each.
			self assert: graphics interpolationMode equals: InterpolationModeBilinear]! !
!GdiplusGraphicsTest categoriesFor: #setUp!public!setup! !
!GdiplusGraphicsTest categoriesFor: #tearDown!public!setup! !
!GdiplusGraphicsTest categoriesFor: #testCompositingMode!public!unit tests! !
!GdiplusGraphicsTest categoriesFor: #testCompositingQuality!public!unit tests! !
!GdiplusGraphicsTest categoriesFor: #testDrawImageRectRect!public!unit tests! !
!GdiplusGraphicsTest categoriesFor: #testDrawLine1!public!unit tests! !
!GdiplusGraphicsTest categoriesFor: #testFillEllipse1!public!unit tests! !
!GdiplusGraphicsTest categoriesFor: #testFillEllipse2!public!unit tests! !
!GdiplusGraphicsTest categoriesFor: #testFillRectangle1!public!unit tests! !
!GdiplusGraphicsTest categoriesFor: #testFillRectangle2!public!unit tests! !
!GdiplusGraphicsTest categoriesFor: #testFromCanvas!public!unit tests! !
!GdiplusGraphicsTest categoriesFor: #testFromImage!public!unit tests! !
!GdiplusGraphicsTest categoriesFor: #testInterpolationMode!public!unit tests! !

