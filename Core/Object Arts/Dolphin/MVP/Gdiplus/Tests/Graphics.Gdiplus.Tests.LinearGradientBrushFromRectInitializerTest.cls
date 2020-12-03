"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest guid: (Core.GUID fromString: '{4159f1e0-74dd-4646-832a-12d38b4281c9}')!
Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest methodsFor!

gdipCreateLineBrushFromRectI: rect color1: color1 color2: color2 mode: mode wrapMode: wrapMode lineGradient: lineGradient 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := LinearGradientBrushFromRectInitializer new library: self!

testCreateHandle
	| rectangle |
	model
		rect: (rectangle := 1 @ 2 corner: 3 @ 4)
		color1: (Color fromArgbCode: 1)
		color2: (Color fromArgbCode: 2)
		mode: LinearGradientModeBackwardDiagonal.
	model createHandle.
	self assert: constructorArgs size equals: 6.
	self assert: constructorArgs first class identicalTo: RECTL.
	self assert: constructorArgs first asRectangle equals: rectangle.
	self assert: constructorArgs second equals: 1.
	self assert: constructorArgs third equals: 2.
	self assert: constructorArgs fourth equals: LinearGradientModeBackwardDiagonal.
	self assert: (constructorArgs at: 5) equals: WrapModeTile.
	self assertLastArgIsHandle! !
!Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest categoriesFor: #gdipCreateLineBrushFromRectI:color1:color2:mode:wrapMode:lineGradient:!accessing!public! !
!Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.LinearGradientBrushFromRectInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !

