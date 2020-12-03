"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.GdiplusTest subclass: #'Graphics.Gdiplus.Tests.GdiplusGraphicsTest'
	instanceVariableNames: 'bitmap graphics canvas'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GdiplusGraphicsTest guid: (Core.GUID fromString: '{c612875a-7f39-4ba6-80bf-c091a74986db}')!
Graphics.Gdiplus.Tests.GdiplusGraphicsTest comment: 'This TestCase is setup to provide a way to quickly ''test'' a GdiplusGraphics method.

Most of the current tests are kick-the-tyres tests. They all could be extended by adding more asserts, but they are better than nothing

'!
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest methodsFor!

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
	image := Image fromFile: self fileResource pafRgb0000FF_100x100bmp.
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
	self assert: model handle class identicalTo: Handle!

testFromImage
	| image pixelColor |
	image := Bitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := GdiplusGraphics fromImage: image.
	self assert: model handle class identicalTo: Handle.
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
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #tearDown!public!setup! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #testCompositingMode!public!unit tests! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #testCompositingQuality!public!unit tests! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #testDrawImageRectRect!public!unit tests! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #testDrawLine1!public!unit tests! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #testFillEllipse1!public!unit tests! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #testFillEllipse2!public!unit tests! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #testFillRectangle1!public!unit tests! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #testFillRectangle2!public!unit tests! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #testFromCanvas!public!unit tests! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #testFromImage!public!unit tests! !
!Graphics.Gdiplus.Tests.GdiplusGraphicsTest categoriesFor: #testInterpolationMode!public!unit tests! !

