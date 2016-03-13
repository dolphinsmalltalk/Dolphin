"Filed out from Dolphin Smalltalk 7"!

GdiplusTests subclass: #GdiplusPathGradientBrushTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPathGradientBrushTest guid: (GUID fromString: '{FCEF1A0F-834C-11D7-B609-00E0987E8081}')!
GdiplusPathGradientBrushTest comment: ''!
!GdiplusPathGradientBrushTest categoriesForClass!Unclassified! !
!GdiplusPathGradientBrushTest methodsFor!

rgb
	^Array 
		with: ARGB red
		with: ARGB green
		with: ARGB blue!

setSample2Points
	model := GdiplusPathGradientBrush points: (Array with: 100 @ 0 with: 200 @ 150)!

setSample3Points
	model := GdiplusPathGradientBrush points: (Array 
						with: 100 @ 0
						with: 200 @ 200
						with: 0 @ 200)!

setSample3PointsPath
	model := GdiplusPathGradientBrush path: (GdiplusGraphicsPath 
						points: (Array 
								with: 100 @ 0
								with: 200 @ 150
								with: 0 @ 150)
						types: (Array new: 3 withAll: PathPointTypeLine)
						fillMode: nil)!

setSampleEllipsePath
	model := GdiplusPathGradientBrush 
				path: (GdiplusGraphicsPath new addEllipse: (Point zero extent: 200 @ 100))!

setSamplePathEmpty
	model := GdiplusPathGradientBrush path: GdiplusGraphicsPath new!

testBlendColors
	| colors positions |
	self setSampleEllipsePath.
	colors := Array 
				with: ARGB red
				with: ARGB green
				with: ARGB blue
				with: ARGB magenta.
	positions := #(0 1.0e-001 0.5 1).
	model blendColors: colors positions: positions.
	self assert: model blendColorsCount = colors size.
	self assert: (model blendColors at: 1) = colors.
	(model blendColors at: 2) with: positions
		do: [:a :b | self assert: (self compare: a to: b)]!

testBlendFactors
	| factors positions |
	self setSampleEllipsePath.
	factors := #(0 0.3 0.9 1).
	positions := #(0 1.0e-001 0.5 1).
	model blendFactors: factors positions: positions.
	self assert: model blendFactorsCount = factors size.
	(model blendFactors at: 1) with: factors
		do: [:a :b | self assert: (self compare: a to: b)].
	(model blendFactors at: 2) with: positions
		do: [:a :b | self assert: (self compare: a to: b)]!

testBounds
	self setSampleEllipsePath.
	self assert: model bounds = (Point zero extent: 200 @ 100)!

testCenterColor
	self setSampleEllipsePath.
	model centerColor: ARGB red.
	self assert: model centerColor = ARGB red!

testCenterPoint
	| point |
	point := 100 @ 50.
	self setSampleEllipsePath.
	model centerPoint: point.
	self assert: model centerPoint = point!

testClone
	"force realize"

	| clone |
	self setSampleEllipsePath.
	model handle.
	clone := model clone.
	self assert: model initializer == clone initializer.
	self assert: clone basicHandle notNil!

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
	self should: [self assertPersistedValid] raise: Error.
	self setSamplePathEmpty.
	self should: [model asParameter] raise: GdiplusError!

testFocusScales
	self setSampleEllipsePath.
	model focusScales: 0.2 @ 0.6.
	self assert: model focusScales = model focusScales!

testIsGammaCorrected
	self setSampleEllipsePath.
	model isGammaCorrected: true.
	self assert: model isGammaCorrected.
	model isGammaCorrected: false.
	self deny: model isGammaCorrected!

testIsPersistent
	self setSample3Points.
	self assert: model isPersistent.
	self setSample3PointsPath.
	self assert: model isPersistent.
	self setSampleEllipsePath.
	self deny: model isPersistent!

testPointCount
	self setSample2Points.
	self assert: model pointCount = 2.
	self setSample3Points.
	self assert: model pointCount = 3.
	self setSample3PointsPath.
	self assert: model pointCount = 3.
	self setSampleEllipsePath.
	self assert: model pointCount = 13!

testScaleTransform
	self setSampleEllipsePath.
	model scaleTransform: 0.2 @ 1.2.
	model transform asArray with: #(0.2 0 0 1.2 0 0)
		do: [:a :b | self assert: (self compare: a to: b)]!

testSurroundColors
	self setSampleEllipsePath.
	model surroundColor: ARGB green.
	self assert: (model surroundColors allSatisfy: [:e | e = ARGB green]).
	self setSample3Points.
	model surroundColors: self rgb.
	self assert: model surroundColors = self rgb!

testTransform
	self setSampleEllipsePath.
	self assert: model transform asArray = #(1 0 0 1 0 0).
	model transform: (GdiplusMatrix fromArray: #(0.5 2 1.2 7 1 0.2)).
	model transform asArray with: #(0.5 2 1.2 7 1 0.2)
		do: [:a :b | self assert: (self compare: a to: b)].
	model resetTransform.
	self assert: model transform asArray = #(1 0 0 1 0 0)!

testTranslateTransform
	self setSampleEllipsePath.
	model translateTransform: 100 @ 50.
	self assert: model transform asArray = #(1 0 0 1 100 50)!

testWrapMode
	self setSampleEllipsePath.
	model class enumsWrapMode do: 
			[:e | 
			model wrapMode: e value.
			self assert: model wrapMode = e value]! !
!GdiplusPathGradientBrushTest categoriesFor: #rgb!accessing!public! !
!GdiplusPathGradientBrushTest categoriesFor: #setSample2Points!accessing!public! !
!GdiplusPathGradientBrushTest categoriesFor: #setSample3Points!accessing!public! !
!GdiplusPathGradientBrushTest categoriesFor: #setSample3PointsPath!accessing!public! !
!GdiplusPathGradientBrushTest categoriesFor: #setSampleEllipsePath!accessing!public! !
!GdiplusPathGradientBrushTest categoriesFor: #setSamplePathEmpty!accessing!public! !
!GdiplusPathGradientBrushTest categoriesFor: #testBlendColors!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testBlendFactors!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testBounds!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testCenterColor!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testCenterPoint!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testClone!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testConstructors!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testFocusScales!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testIsGammaCorrected!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testIsPersistent!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testPointCount!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testScaleTransform!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testSurroundColors!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testTransform!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testTranslateTransform!public!unit tests! !
!GdiplusPathGradientBrushTest categoriesFor: #testWrapMode!public!unit tests! !

