"Filed out from Dolphin Smalltalk 7"!

GdiplusTests subclass: #GdiplusPathGradientBrushTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusPathGradientBrushTest guid: (GUID fromString: '{fcef1a0f-834c-11d7-b609-00e0987e8081}')!
GdiplusPathGradientBrushTest comment: ''!
!GdiplusPathGradientBrushTest categoriesForClass!Unclassified! !
!GdiplusPathGradientBrushTest methodsFor!

rgb
	^{Color red. Color green. Color blue}!

setSample2Points
	model := GdiplusPathGradientBrush points: {100 @ 0. 200 @ 150}!

setSample3Points
	model := GdiplusPathGradientBrush points: {100 @ 0. 200 @ 200. 0 @ 200}!

setSample3PointsPath
	model := GdiplusPathGradientBrush path: (GdiplusGraphicsPath
						points: {100 @ 0. 200 @ 150. 0 @ 150}
						types: (ByteArray new: 3 withAll: PathPointTypeLine)
						fillMode: nil)!

setSampleEllipsePath
	model := GdiplusPathGradientBrush 
				path: (GdiplusGraphicsPath new addEllipse: (Point zero extent: 200 @ 100))!

setSamplePathEmpty
	model := GdiplusPathGradientBrush path: GdiplusGraphicsPath new!

testBlendColors
	| colors positions |
	self setSampleEllipsePath.
	colors := {Color red. Color green. Color blue. Color magenta}.
	positions := #(0 1.0e-001 0.5 1).
	model blendColors: colors positions: positions.
	self assert: model blendColorsCount equals: colors size.
	self assert: (model blendColors at: 1) equals: colors.
	(model blendColors at: 2) with: positions do: [:a :b | self assert: (self compare: a to: b)]!

testBlendFactors
	| factors positions |
	self setSampleEllipsePath.
	factors := #(0 0.3 0.9 1).
	positions := #(0 1.0e-001 0.5 1).
	model blendFactors: factors positions: positions.
	self assert: model blendFactorsCount equals: factors size.
	(model blendFactors at: 1) with: factors do: [:a :b | self assert: (self compare: a to: b)].
	(model blendFactors at: 2) with: positions do: [:a :b | self assert: (self compare: a to: b)]!

testBounds
	self setSampleEllipsePath.
	self assert: model bounds equals: (Point zero extent: 200 @ 100)!

testCenterColor
	self setSampleEllipsePath.
	model centerColor: Color red.
	self assert: model centerColor equals: Color red!

testCenterPoint
	| point |
	point := 100 @ 50.
	self setSampleEllipsePath.
	model centerPoint: point.
	self assert: model centerPoint equals: point!

testClone
	"force realize"

	| clone |
	self setSampleEllipsePath.
	model handle.
	clone := model clone.
	self assert: model initializer identicalTo: clone initializer.
	self denyIsNil: clone basicHandle!

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
	self assert: model focusScales equals: model focusScales!

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
	self assert: model pointCount equals: 2.
	self setSample3Points.
	self assert: model pointCount equals: 3.
	self setSample3PointsPath.
	self assert: model pointCount equals: 3.
	self setSampleEllipsePath.
	self assert: model pointCount equals: 13!

testScaleTransform
	self setSampleEllipsePath.
	model scaleTransform: 0.2 @ 1.2.
	model transform asArray with: #(0.2 0 0 1.2 0 0)
		do: [:a :b | self assert: (self compare: a to: b)]!

testSurroundColors
	self setSampleEllipsePath.
	model surroundColor: Color green.
	self assert: (model surroundColors allSatisfy: [:e | e = Color green]).
	self setSample3Points.
	model surroundColors: self rgb.
	self assert: model surroundColors equals: self rgb!

testTransform
	self setSampleEllipsePath.
	self assert: model transform asArray equals: #(1 0 0 1 0 0).
	model transform: (GdiplusMatrix fromArray: #(0.5 2 1.2 7 1 0.2)).
	model transform asArray with: #(0.5 2 1.2 7 1 0.2)
		do: [:a :b | self assert: (self compare: a to: b)].
	model resetTransform.
	self assert: model transform asArray equals: #(1 0 0 1 0 0)!

testTranslateTransform
	self setSampleEllipsePath.
	model translateTransform: 100 @ 50.
	self assert: model transform asArray equals: #(1 0 0 1 100 50)!

testWrapMode
	self setSampleEllipsePath.
	model class enumsWrapMode do: 
			[:e |
			model wrapMode: e value.
			self assert: model wrapMode equals: e value]! !
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

