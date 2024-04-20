"Filed out from Dolphin Smalltalk"!

GdiplusTests subclass: #GdiplusGraphicsTest
	instanceVariableNames: 'bitmap graphics canvas'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusGraphicsTest guid: (GUID fromString: '{c612875a-7f39-4ba6-80bf-c091a74986db}')!

GdiplusGraphicsTest comment: 'This TestCase is setup to provide a way to quickly ''test'' a GdiplusGraphics method.

Most of the current tests are kick-the-tyres tests. They all could be extended by adding more asserts, but they are better than nothing

'!

!GdiplusGraphicsTest categoriesForClass!Unclassified! !

!GdiplusGraphicsTest methodsFor!

createCanonicalSubject
	bitmap := GdiplusBitmap extent: 256 @ 256.
	bitmap erase.
	^self subjectClass fromImage: bitmap!

subjectClass
	^GdiplusGraphics!

tearDown
	super tearDown.
	bitmap free.
	bitmap := nil!

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
	image := GdiplusImage fromFile: self fileResource pafRgb0000FF_100x100bmp.
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
	model fillEllipse: (0 @ 0 extent: 100 @ 100) brush: GdiplusSolidBrush green.
	self assert: (bitmap pixelAt: 50 @ 50) equals: Color green!

testFillEllipse2
	"Kick the tyres test"

	self newCanonicalModel.
	model fillEllipse: (0 @ 0 extent: 100 @ 100) brush: self getSampleBrush!

testFillRectangle1
	"Kick the tyres test"

	self newCanonicalModel.
	model fillRectangle: (0 @ 0 extent: 100 @ 100) brush: GdiplusSolidBrush red.
	self assert: (bitmap pixelAt: 50 @ 50) equals: Color red!

testFillRectangle2
	"Kick the tyres test"

	self newCanonicalModel.
	model fillRectangle: (0 @ 0 extent: 100 @ 100) brush: self getSampleBrush!

testFromCanvas
	| bmp |
	bmp := self getSampleGDIBitmap.
	model := GdiplusGraphics fromCanvas: bmp canvas.
	self assert: model handle class identicalTo: ExternalHandle!

testFromImage
	| image pixelColor |
	image := GdiplusBitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := GdiplusGraphics fromImage: image.
	self assert: model handle class identicalTo: ExternalHandle.
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

testPageUnit
	self newCanonicalModel.
	self assert: model pageUnit equals: UnitDisplay.
	self assert: model pageUnitName equals: 'UnitDisplay'! !

!GdiplusGraphicsTest categoriesForMethods!
createCanonicalSubject!helpers!private! !
subjectClass!constants!private! !
tearDown!public!setup! !
testCompositingMode!public!unit tests! !
testCompositingQuality!public!unit tests! !
testDrawImageRectRect!public!unit tests! !
testDrawLine1!public!unit tests! !
testFillEllipse1!public!unit tests! !
testFillEllipse2!public!unit tests! !
testFillRectangle1!public!unit tests! !
testFillRectangle2!public!unit tests! !
testFromCanvas!public!unit tests! !
testFromImage!public!unit tests! !
testInterpolationMode!public!unit tests! !
testPageUnit!public!unit tests! !
!

