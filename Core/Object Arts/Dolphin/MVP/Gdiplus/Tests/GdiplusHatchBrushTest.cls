"Filed out from Dolphin Smalltalk X6"!

GdiplusTests subclass: #GdiplusHatchBrushTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusHatchBrushTest guid: (GUID fromString: '{BE9147C0-8247-11D7-B609-00E0987E8081}')!
GdiplusHatchBrushTest comment: ''!
!GdiplusHatchBrushTest categoriesForClass!Unclassified! !
!GdiplusHatchBrushTest methodsFor!

setSampleDiagCross
	model := GdiplusHatchBrush 
				style: HatchStyleDiagonalCross
				forecolor: ARGB red
				backcolor: ARGB blue!

setUp
	self setSampleDiagCross!

tearDown
	super tearDown.
	model notNil ifTrue: [model free]!

testClone
	"force realize"

	| clone |
	model handle.
	clone := model clone.
	self assert: model initializer == clone initializer.
	self assert: clone basicHandle notNil!

testConstructors
	self setSampleDiagCross.
	model asParameter.
	self assertPersistedValid!

testFillingCrossDiagonal
	| bitmap |
	self setSampleDiagCross.
	bitmap := GdiplusBitmap extent: 200 @ 150.
	bitmap graphics fillRectangle: (Point zero extent: bitmap extent) brush: model.
	self assert: (bitmap pixelAt: 0 @ 0) = (bitmap pixelAt: 1 @ 1).
	self assert: (bitmap pixelAt: 0 @ 0) ~= (bitmap pixelAt: 1 @ 0)! !
!GdiplusHatchBrushTest categoriesFor: #setSampleDiagCross!public! !
!GdiplusHatchBrushTest categoriesFor: #setUp!public! !
!GdiplusHatchBrushTest categoriesFor: #tearDown!public!setup! !
!GdiplusHatchBrushTest categoriesFor: #testClone!public!unit tests! !
!GdiplusHatchBrushTest categoriesFor: #testConstructors!public! !
!GdiplusHatchBrushTest categoriesFor: #testFillingCrossDiagonal!public!unit tests! !

