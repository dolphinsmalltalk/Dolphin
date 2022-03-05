"Filed out from Dolphin Smalltalk"!

GdiplusInitializerTests subclass: #GdiplusLinearGradientBrushFromRectInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusLinearGradientBrushFromRectInitializerTest guid: (GUID fromString: '{4159f1e0-74dd-4646-832a-12d38b4281c9}')!
GdiplusLinearGradientBrushFromRectInitializerTest comment: ''!
!GdiplusLinearGradientBrushFromRectInitializerTest categoriesForClass!Unclassified! !
!GdiplusLinearGradientBrushFromRectInitializerTest methodsFor!

gdipCreateLineBrushFromRectI: rect color1: color1 color2: color2 mode: mode wrapMode: wrapMode lineGradient: lineGradient 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusLinearGradientBrushFromRectInitializer new library: self!

testCreateHandle
	| rectangle |
	model
		rect: (rectangle := 1 @ 2 corner: 3 @ 4)
		color1: (Color fromArgbCode: 1)
		color2: (Color fromArgbCode: 2)
		mode: LinearGradientModeBackwardDiagonal.
	model createHandle.
	self assert: constructorArgs size equals: 6.
	self assert: constructorArgs first class identicalTo: RECT.
	self assert: constructorArgs first asRectangle equals: rectangle.
	self assert: constructorArgs second equals: 1.
	self assert: constructorArgs third equals: 2.
	self assert: constructorArgs fourth equals: LinearGradientModeBackwardDiagonal.
	self assert: (constructorArgs at: 5) equals: WrapModeTile.
	self assertLastArgIsHandle! !
!GdiplusLinearGradientBrushFromRectInitializerTest categoriesForMethods!
gdipCreateLineBrushFromRectI:color1:color2:mode:wrapMode:lineGradient:!accessing!public! !
setUp!public!setup! !
testCreateHandle!public!unit tests! !
!

