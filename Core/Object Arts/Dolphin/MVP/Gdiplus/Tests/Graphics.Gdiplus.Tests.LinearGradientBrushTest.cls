"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GradientBrushTest
	subclass: #'Graphics.Gdiplus.Tests.LinearGradientBrushTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.LinearGradientBrushTest guid: (Core.GUID fromString: '{da79074f-df9f-4e17-85cb-3cbe8999807f}')!
Graphics.Gdiplus.Tests.LinearGradientBrushTest comment: ''!
!Graphics.Gdiplus.Tests.LinearGradientBrushTest methodsFor!

brushType
	^BrushTypeLinearGradient!

createCanonicalSubject
	^self subjectClass
		point1: 0 @ 0
		point2: 255 @ 0
		color1: Color red
		color2: Color blue
		wrapMode: Gdiplus.WrapModeTileFlipXY!

gdipGetTransform: aHandle matrix: matrix
	Gdip gdipGetLineTransform: aHandle matrix: matrix handle!

subjectClass
	^LinearGradientBrush!

testColors
	| recreated blend bitmap newColors |
	self newCanonicalModel.
	self assert: model colors equals: {Color red. Color blue}.
	newColors := {Color green. Color blue}.
	model colors: newColors.
	self assert: model colors equals: newColors.
	self assert: (model initializer colorsGet: model handle) equals: newColors.
	"Should round trip via STB"
	recreated := self assertPersistedValid.
	self assert: recreated colors equals: newColors.
	"What happens if we change the colours with a blend?"
	blend := GradientPresetBlend colors: {Color red. Color green. Color magenta} positions: #(0 0.2 1).
	model blend: blend.
	"Original linear colours are not changed"
	self assert: model colors equals: newColors.
	self assert: (model initializer colorsGet: model handle) equals: newColors.
	false
		ifTrue: 
			[bitmap := Bitmap extent: model bounds extent + 20.
			bitmap graphics
				fillRectangle: (10 @ 10 extent: model bounds extent) brush: model;
				free.
			bitmap showExample]!

testConstructFromPoints
	self newCanonicalModel.
	model asParameter!

testConstructFromRectangle
	| recreated rect |
	rect := 5 @ 15 extent: 250 @ 240.
	model := self subjectClass
				rect: rect
				color1: Color red
				color2: Color blue
				mode: LinearGradientModeHorizontal.
	self assert: model bounds equals: rect.
	self assert: model colors equals: {Color red. Color blue}.
	self deny: model isGammaCorrected.
	self assert: model wrapMode equals: WrapModeTile.
	model isGammaCorrected: true.
	recreated := self assertPersistedValid.
	self assert: recreated isGammaCorrected!

testHorizontalGradient
	| bitmap |
	self newCanonicalModel.
	bitmap := Bitmap extent: 256 @ 256.
	bitmap graphics
		fillRectangle: (0 @ 0 extent: 256 @ 256) brush: model;
		free.
	false ifTrue: [bitmap showExample].
	self assert: (bitmap pixelAt: 0 @ 0) equals: Color red.
	self assert: (bitmap pixelAt: 128 @ 0) equals: Color purple.
	self assert: (bitmap pixelAt: 255 @ 0) equals: Color blue.
	self assert: (bitmap pixelAt: 0 @ 128) equals: Color red.
	self assert: (bitmap pixelAt: 0 @ 255) equals: Color red.
	self assert: (bitmap pixelAt: 255 @ 255) equals: Color blue!

testLumninance
	model := self subjectClass
				point1: 0 @ 0
				point2: 255 @ 0
				color1: Color white
				color2: Color gray.
	self assert: (model luminance roundTo: 0.01) equals: 0.75!

testPersistentArgument
	"Create an object that has a constructor argument that itself needs to be realised"

	| pen |
	self newCanonicalModel.
	pen := Pen brush: model.
	"realize it"
	pen asParameter.
	self assert: model isRealized.
	"re-realize it"
	pen free.
	pen asParameter.
	"re-realize all"
	pen free.
	model free.
	pen asParameter.
	self assert: model isRealized.
	self assert: pen ink identicalTo: model
	"for gc reasons .. the pen must always hold a reference to the brush"!

testPrintString
	| expr |
	self newCanonicalModel.
	expr := model printString.
	self assert: expr
		equals: '(Gdiplus.LinearGradientBrush point1: (0@0) point2: (255@0) color1: Color red color2: Color blue wrapMode: Gdiplus.WrapModeTileFlipXY)'.
	self assert: (Compiler evaluate: expr) equals: model.
	model rotate: 45.
	self assert: model printString
		equals: 'a Gdiplus.LinearGradientBrush(point1: (0@0) point2: (255@0) color1: Color red color2: Color blue wrapMode: Gdiplus.WrapModeTileFlipXY; transform: (Gdiplus.Matrix fromArray: #(0.707106709 0.70710665 -0.707106709 0.707106709 -0.0 -0.0)))'!

testStlUpgradeFromD7
	| brushes |
	brushes := Object
				fromLiteralStoreArray: #(#'!!STL' 4 34 2 1704710 ##(Smalltalk.GdiplusLinearGradientBrush) nil true 2950406 ##(Smalltalk.GdiplusLinearGradientBrushFromRectInitializer) nil 590342 ##(Smalltalk.Rectangle) 328198 ##(Smalltalk.Point) 3 5 514 151 101 327686 ##(Smalltalk.Color) #blue 562 #cyan 5 418 nil true 3081478 ##(Smalltalk.GdiplusLinearGradientBrushFromPointsInitializer) nil 514 11 21 514 401 21 562 #black 562 #red).
	self assert: brushes first
		equals: (self subjectClass
				rect: (1 @ 2 corner: 75 @ 50)
				color1: Color blue
				color2: Color cyan
				mode: LinearGradientModeForwardDiagonal).
	self assert: brushes second
		equals: (self subjectClass
				point1: 5 @ 10
				point2: 200 @ 10
				color1: Color black
				color2: Color red)!

testVerticalGradient
	| bitmap |
	bitmap := Bitmap extent: 256 @ 256.
	model := self subjectClass
				point1: 0 @ 0
				point2: 0 @ 255
				color1: Color red
				color2: Color blue.
	bitmap graphics
		fillRectangle: (0 @ 0 extent: 256 @ 256) brush: model;
		free.
	false ifTrue: [bitmap showExample].
	self assert: (bitmap pixelAt: 0 @ 0) equals: Color red.
	self assert: (bitmap pixelAt: 128 @ 0) equals: Color red.
	self assert: (bitmap pixelAt: 255 @ 0) equals: Color red.
	self assert: (bitmap pixelAt: 0 @ 128) equals: Color purple.
	self assert: (bitmap pixelAt: 0 @ 255) equals: Color blue.
	self assert: (bitmap pixelAt: 255 @ 255) equals: Color blue!

validWrapModes
	^super validWrapModes copyWithout: WrapModeClamp!

verifyEqualToModel: aGdiplusObject
	super verifyEqualToModel: aGdiplusObject.
	self assert: aGdiplusObject startingColor equals: model startingColor.
	self assert: aGdiplusObject endingColor equals: model endingColor.
	self assert: aGdiplusObject mode equals: model mode! !
!Graphics.Gdiplus.Tests.LinearGradientBrushTest categoriesForMethods!
brushType!constants!private! !
createCanonicalSubject!initializing!private! !
gdipGetTransform:matrix:!private!transformations! !
subjectClass!constants!initializing!private! !
testColors!public!unit tests! !
testConstructFromPoints!public!unit tests! !
testConstructFromRectangle!public!unit tests! !
testHorizontalGradient!public!unit tests! !
testLumninance!public!unit tests! !
testPersistentArgument!public!unit tests! !
testPrintString!public!unit tests! !
testStlUpgradeFromD7!public!unit tests! !
testVerticalGradient!public!unit tests! !
validWrapModes!constants!private! !
verifyEqualToModel:!helpers!private! !
!

