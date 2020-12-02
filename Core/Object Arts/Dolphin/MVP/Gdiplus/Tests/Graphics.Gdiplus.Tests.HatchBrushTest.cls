"Filed out from Dolphin Smalltalk 7"!

GdiplusTests subclass: #GdiplusHatchBrushTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusHatchBrushTest guid: (GUID fromString: '{be9147c0-8247-11d7-b609-00e0987e8081}')!
GdiplusHatchBrushTest comment: ''!
!GdiplusHatchBrushTest categoriesForClass!Unclassified! !
!GdiplusHatchBrushTest methodsFor!

setSampleDiagCross
	model := GdiplusHatchBrush
				style: HatchStyleDiagonalCross
				forecolor: Color red
				backcolor: Color blue!

setUp
	self setSampleDiagCross!

testClone
	"force realize"

	| clone |
	model handle.
	clone := model clone.
	self assert: model initializer identicalTo: clone initializer.
	self denyIsNil: clone basicHandle!

testConstructors
	self setSampleDiagCross.
	model asParameter.
	self assertPersistedValid!

testFillingCrossDiagonal
	| bitmap |
	self setSampleDiagCross.
	bitmap := GdiplusBitmap extent: 200 @ 150.
	bitmap graphics fillRectangle: (Point zero extent: bitmap extent) brush: model.
	self assert: (bitmap pixelAt: 0 @ 0) equals: (bitmap pixelAt: 1 @ 1).
	self deny: (bitmap pixelAt: 0 @ 0) equals: (bitmap pixelAt: 1 @ 0)! !
!GdiplusHatchBrushTest categoriesFor: #setSampleDiagCross!public! !
!GdiplusHatchBrushTest categoriesFor: #setUp!public! !
!GdiplusHatchBrushTest categoriesFor: #testClone!public!unit tests! !
!GdiplusHatchBrushTest categoriesFor: #testConstructors!public! !
!GdiplusHatchBrushTest categoriesFor: #testFillingCrossDiagonal!public!unit tests! !

