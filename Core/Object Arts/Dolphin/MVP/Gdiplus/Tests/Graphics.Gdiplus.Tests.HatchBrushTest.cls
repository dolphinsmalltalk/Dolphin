"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.GdiplusTest subclass: #'Graphics.Gdiplus.Tests.HatchBrushTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.HatchBrushTest guid: (Core.GUID fromString: '{be9147c0-8247-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.Tests.HatchBrushTest comment: ''!
!Graphics.Gdiplus.Tests.HatchBrushTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.HatchBrushTest methodsFor!

setSampleDiagCross
	model := HatchBrush
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
	bitmap := Bitmap extent: 200 @ 150.
	bitmap graphics fillRectangle: (Point zero extent: bitmap extent) brush: model.
	self assert: (bitmap pixelAt: 0 @ 0) equals: (bitmap pixelAt: 1 @ 1).
	self deny: (bitmap pixelAt: 0 @ 0) equals: (bitmap pixelAt: 1 @ 0)! !
!Graphics.Gdiplus.Tests.HatchBrushTest categoriesFor: #setSampleDiagCross!public! !
!Graphics.Gdiplus.Tests.HatchBrushTest categoriesFor: #setUp!public! !
!Graphics.Gdiplus.Tests.HatchBrushTest categoriesFor: #testClone!public!unit tests! !
!Graphics.Gdiplus.Tests.HatchBrushTest categoriesFor: #testConstructors!public! !
!Graphics.Gdiplus.Tests.HatchBrushTest categoriesFor: #testFillingCrossDiagonal!public!unit tests! !

