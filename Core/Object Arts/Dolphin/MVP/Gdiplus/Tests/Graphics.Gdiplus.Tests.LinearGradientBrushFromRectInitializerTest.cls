"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests
	subclass: #'Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest guid: (Core.GUID fromString: '{4159f1e0-74dd-4646-832a-12d38b4281c9}')!
Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest methodsFor!

subjectClass
	^LinearGradientBrushFromRectInitializer!

testCreateHandle
	| rectangle constructor |
	model
		rect: (rectangle := 1 @ 2 corner: 3 @ 4)
		color1: (Color fromArgbCode: 1)
		color2: (Color fromArgbCode: 2)
		mode: LinearGradientModeBackwardDiagonal.
	constructor := self createHandle single.
	self assert: constructor selector
		identicalTo: #gdipCreateLineBrushFromRectI:color1:color2:mode:wrapMode:lineGradient:.
	self assert: constructor arguments size equals: 6.
	self assert: constructor arguments first class identicalTo: Rect.
	self assert: constructor arguments first asRectangle equals: rectangle.
	self assert: constructor arguments second equals: 1.
	self assert: constructor arguments third equals: 2.
	self assert: constructor arguments fourth equals: LinearGradientModeBackwardDiagonal.
	self assert: (constructor arguments at: 5) equals: WrapModeTile.
	self assert: constructor arguments last isKindOf: Handle! !
!Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testCreateHandle!public!unit tests! !
!

