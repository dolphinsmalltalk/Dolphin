"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests
	subclass: #'Graphics.Gdiplus.Tests.LinearGradientBrushFromPointsInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.LinearGradientBrushFromPointsInitializerTest guid: (Core.GUID fromString: '{2ca114c0-deee-48f6-ade7-9bc53b50d22c}')!

Graphics.Gdiplus.Tests.LinearGradientBrushFromPointsInitializerTest comment: ''!

!Graphics.Gdiplus.Tests.LinearGradientBrushFromPointsInitializerTest methodsFor!

subjectClass
	^LinearGradientBrushFromPointsInitializer!

testCreateHandle
	| constructor |
	model
		point1: 1 @ 2
		point2: 3 @ 4
		color1: (Color fromArgbCode: 1)
		color2: (Color fromArgbCode: 2)
		wrapMode: WrapModeTile.
	constructor := self createHandle single.
	self assert: constructor selector
		identicalTo: #gdipCreateLineBrushI:point2:color1:color2:wrapMode:lineGradient:.
	self assert: constructor arguments size equals: 6.
	self assert: constructor arguments first class identicalTo: POINTL.
	self assert: constructor arguments first value equals: 1 @ 2.
	self assert: constructor arguments second class identicalTo: POINTL.
	self assert: constructor arguments second value equals: 3 @ 4.
	self assert: constructor arguments third equals: 1.
	self assert: constructor arguments fourth equals: 2.
	self assert: (constructor arguments at: 5) equals: WrapModeTile! !

!Graphics.Gdiplus.Tests.LinearGradientBrushFromPointsInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testCreateHandle!public!unit tests! !
!

