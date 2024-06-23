"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GradientBrushTest
	subclass: #'Graphics.Gdiplus.Tests.PathGradientBrushTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.PathGradientBrushTest guid: (Core.GUID fromString: '{fcef1a0f-834c-11d7-b609-00e0987e8081}')!

Graphics.Gdiplus.Tests.PathGradientBrushTest comment: ''!

!Graphics.Gdiplus.Tests.PathGradientBrushTest methodsFor!

brushType
	^BrushTypePathGradient!

createCanonicalSubject
	^self subjectClass path: (GraphicsPath ellipse: (5 @ 10 extent: 200 @ 100))!

gdipGetTransform: aHandle matrix: matrix
	Gdip gdipGetPathGradientTransform: aHandle matrix: matrix handle!

setSample2Points
	model ifNotNil: [model free].
	model := self subjectClass points: {100 @ 0. 200 @ 150}!

setSample3Points
	model := self subjectClass points: {100 @ 0. 200 @ 200. 0 @ 200} wrapMode: WrapModeTile!

setSample3PointsPath
	model := self subjectClass path: (GraphicsPath points: {100 @ 0. 200 @ 150. 0 @ 150}
						types: {PathPointTypeLine. PathPointTypeLine. PathPointTypeLine})
				wrapMode: WrapModeTile!

setSampleEllipsePath
	model := self subjectClass path: (GraphicsPath ellipse: (5 @ 10 extent: 200 @ 100))!

setSamplePathEmpty
	model := self subjectClass path: GraphicsPath new!

subjectClass
	^PathGradientBrush!

testBounds
	self newCanonicalModel.
	model centerColor: Color blue.
	self assert: model bounds equals: (5 @ 10 extent: 200 @ 100).
	"The brush is translated within its original bounds so the bounds do not change, which is somewhat surprising"
	model translate: 20 @ 30.
	self assert: model bounds equals: (5 @ 10 extent: 200 @ 100)!

testCenterColor
	| bitmap graphics path color ellipseRect recreated center |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	ellipseRect := 0 @ 0 extent: 200 @ 100.

	"Create a path that consists of a single ellipse."
	path := GraphicsPath ellipse: ellipseRect.

	"Use the path to construct a brush."
	model := PathGradientBrush path: path.
	self assert: model centerColor equals: Color white.

	center := model centerPoint.

	"Set the color along the entire boundary of the path to aqua."
	model surroundColors: {Color aqua}.
	self assert: model centerColor equals: Color white.
	"Check it persists"
	recreated := self assertPersistedValid.

	"Fill the ellipse with (a copy of) the path gradient brush."
	graphics fillEllipse: ellipseRect brush: recreated.
	self assert: recreated centerColor equals: Color white.
	self assert: recreated centerPoint equals: center.

	"May be some inaccuracy, and so a little green"
	color := bitmap pixelAt: recreated centerPoint.
	self assert: color blue equals: 255.

	"Fill a rectangle with the retrieved color."
	model free.
	model := PathGradientBrush points: (0 @ 120 extent: 200 @ 30) vertices.
	model surroundColors: {color}.
	self assert: model centerColor equals: Color black.
	graphics fillRectangle: model bounds brush: model.

	"Tidy up"
	recreated free.
	graphics free.
	false ifTrue: [bitmap showExample] ifFalse: [bitmap free]!

testCenterPoint
	| point recreated |
	point := 100 @ 50.
	self setSampleEllipsePath.
	model centerPoint: point.
	self assert: model centerPoint equals: point.
	recreated := self assertPersistedValid.
	self assert: recreated centerPoint equals: point.
	recreated free!

testConstructors
	self setSample2Points.
	model asParameter.
	self assertPersistedValid.
	self setSample3Points.
	model asParameter.
	self assertPersistedValid.
	self setSample3PointsPath.
	model asParameter.
	self assertPersistedValid.
	self setSampleEllipsePath.
	model asParameter.
	self assertPersistedValid.
	self setSamplePathEmpty.
	self should: [model asParameter] raise: GdiplusError!

testFocusScales
	| copy focusScales |
	self newCanonicalModel.
	self assert: model focusScales equals: 0 @ 0.
	copy := self assertClonedValid.
	model focusScales: 0 @ 0.
	self assert: model equals: copy.
	self assert: copy equals: model.
	focusScales := 0.2 @ 0.6.
	model focusScales: focusScales.
	self assert: model focusScales equals: focusScales.
	self deny: model equals: copy.
	self deny: copy equals: model.
	copy free.
	copy := self assertPersistedValid.
	self assert: copy focusScales equals: focusScales!

testIsPersistent
	super testIsPersistent.
	self setSample3Points.
	self assert: model isPersistent.
	self setSample3PointsPath.
	self assert: model isPersistent!

testLumninance
	self newCanonicalModel.
	model centerColor: Color red.
	self assert: model luminance equals: 0.299!

testPointCount
	self setSample2Points.
	self assert: model pointCount equals: 2.
	self setSample3Points.
	self assert: model pointCount equals: 3.
	self setSample3PointsPath.
	self assert: model pointCount equals: 3.
	self setSampleEllipsePath.
	self assert: model pointCount equals: 13!

testPrintString1
	| printed model2 |
	self newCanonicalModel.
	printed := model printString.
	self assert: printed
		equals: '(Gdiplus.PathGradientBrush path: (Gdiplus.GraphicsPath points: {(205@60). (205@88). (160@110). (105@110). (50@110). (5@88). (5@60). (5@32). (50@10). (105@10). (160@10). (205@32). (205@60)} types: {Gdiplus.PathPointTypeStart. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier|Gdiplus.PathPointTypeCloseSubpath}))'.
	model2 := Compiler evaluate: printed.
	self assert: model2 equals: model!

testPrintString2
	| printed model2 |
	self setSample2Points.
	printed := model printString.
	self assert: printed equals: '(Gdiplus.PathGradientBrush points: {(100@0). (200@150)})'.
	model2 := Compiler evaluate: printed.
	self assert: model2 equals: model!

testPrintString3
	| printed model2 |
	self setSample3Points.
	printed := model printString.
	self assert: printed equals: '(Gdiplus.PathGradientBrush points: {(100@0). (200@200). (0@200)} wrapMode: Gdiplus.WrapModeTile)'.
	model2 := Compiler evaluate: printed.
	self assert: model2 equals: model!

testPrintString4
	| printed model2 |
	self setSample3PointsPath.
	printed := model printString.
	self assert: printed
		equals: '(Gdiplus.PathGradientBrush path: (Gdiplus.GraphicsPath points: {(100@0). (200@150). (0@150)} types: {Gdiplus.PathPointTypeLine. Gdiplus.PathPointTypeLine. Gdiplus.PathPointTypeLine}) wrapMode: Gdiplus.WrapModeTile)'.
	model2 := Compiler evaluate: printed.
	self assert: model2 equals: model!

testPrintString5
	| printed model2 |
	self setSampleEllipsePath.
	printed := model printString.
	self assert: printed
		equals: '(Gdiplus.PathGradientBrush path: (Gdiplus.GraphicsPath points: {(205@60). (205@88). (160@110). (105@110). (50@110). (5@88). (5@60). (5@32). (50@10). (105@10). (160@10). (205@32). (205@60)} types: {Gdiplus.PathPointTypeStart. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier|Gdiplus.PathPointTypeCloseSubpath}))'.
	model2 := Compiler evaluate: printed.
	self assert: model2 equals: model!

testPrintString6
	| printed model2 |
	self setSamplePathEmpty.
	printed := model printString.
	self assert: printed
		equals: '(Gdiplus.PathGradientBrush path: (Gdiplus.GraphicsPath points: #() types: #[]))'.
	model2 := Compiler evaluate: printed.
	self assert: model2 equals: model!

testPrintString7
	self newCanonicalModel.
	model translate: 5 @ 10.
	model surroundColor: Color green.
	self assert: model printString
		equals: 'a Gdiplus.PathGradientBrush(path: (Gdiplus.GraphicsPath points: {(205@60). (205@88). (160@110). (105@110). (50@110). (5@88). (5@60). (5@32). (50@10). (105@10). (160@10). (205@32). (205@60)} types: {Gdiplus.PathPointTypeStart. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier. Gdiplus.PathPointTypeBezier|Gdiplus.PathPointTypeCloseSubpath}); transform: (Gdiplus.Matrix fromArray: #(1.0 0.0 0.0 1.0 5.0 10.0)); surroundColors: {Color green})'!

testStlUpgradeFromD7
	| brushes |
	brushes := Object
				fromLiteralStoreArray: #(#'!!STL' 4 34 2 1573638 ##(Smalltalk.GdiplusPathGradientBrush) nil true 2622214 ##(Smalltalk.GdiplusPathGradientFromPointsInitializer) nil 34 3 328198 ##(Smalltalk.Point) 201 1 498 401 401 498 1 401 1 418 nil true 2490886 ##(Smalltalk.GdiplusPathGradientFromPathInitializer) nil 1245958 ##(Smalltalk.GdiplusGraphicsPath) nil true 2622470 ##(Smalltalk.GdiplusGraphicsPathFromPointsInitializer) nil 34 13 498 601 211 498 601 315 498 471 401 498 311 401 498 151 401 498 21 315 498 21 211 498 21 107 498 151 21 498 311 21 498 471 21 498 601 107 498 601 211 8 #[0 3 3 3 3 3 3 3 3 3 3 3 131] 1).
	self assert: brushes first
		equals: (PathGradientBrush points: {100 @ 0. 200 @ 200. 0 @ 200} wrapMode: WrapModeTile).
	self assert: brushes second
		equals: (PathGradientBrush path: (GraphicsPath ellipse: (10 @ 10 corner: 300 @ 200)))!

testSurroundColors
	| recreated rgb |
	self setSampleEllipsePath.
	model surroundColor: Color green.
	model surroundColors do: [:each | self assert: each equals: Color green].
	self setSample3Points.
	rgb := {Color red. Color green. Color blue}.
	model surroundColors: rgb.
	self assert: model surroundColors equals: rgb.
	recreated := self assertPersistedValid.
	self assert: recreated surroundColors equals: rgb.
	recreated free!

verifyEqualToModel: aGdiplusObject
	super verifyEqualToModel: aGdiplusObject.
	self assert: aGdiplusObject path equals: model path.
	self assert: aGdiplusObject centerColor equals: model centerColor.
	self assert: aGdiplusObject centerPoint equals: model centerPoint.
	self assert: aGdiplusObject focusScales equals: model focusScales.
	self assert: aGdiplusObject surroundColors equals: model surroundColors! !

!Graphics.Gdiplus.Tests.PathGradientBrushTest categoriesForMethods!
brushType!constants!private! !
createCanonicalSubject!initializing!private! !
gdipGetTransform:matrix:!operations!private!transformations! !
setSample2Points!initializing!private! !
setSample3Points!initializing!private! !
setSample3PointsPath!initializing!private! !
setSampleEllipsePath!initializing!private! !
setSamplePathEmpty!initializing!private! !
subjectClass!constants!initializing!private! !
testBounds!public!unit tests! !
testCenterColor!public!unit tests! !
testCenterPoint!public!unit tests! !
testConstructors!public!unit tests! !
testFocusScales!public!unit tests! !
testIsPersistent!public!unit tests! !
testLumninance!public!unit tests! !
testPointCount!public!unit tests! !
testPrintString1!public!unit tests! !
testPrintString2!public!unit tests! !
testPrintString3!public!unit tests! !
testPrintString4!public!unit tests! !
testPrintString5!public!unit tests! !
testPrintString6!public!unit tests! !
testPrintString7!public!unit tests! !
testStlUpgradeFromD7!public!unit tests! !
testSurroundColors!public!unit tests! !
verifyEqualToModel:!helpers!private! !
!

