"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializerTests subclass: #GdiplusLinearGradientBrushFromPointsInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusLinearGradientBrushFromPointsInitializerTest guid: (GUID fromString: '{2ca114c0-deee-48f6-ade7-9bc53b50d22c}')!
GdiplusLinearGradientBrushFromPointsInitializerTest comment: ''!
!GdiplusLinearGradientBrushFromPointsInitializerTest categoriesForClass!Unclassified! !
!GdiplusLinearGradientBrushFromPointsInitializerTest methodsFor!

gdipCreateLineBrushI: point1 point2: point2 color1: color1 color2: color2 wrapMode: wrapMode lineGradient: lineGradient 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GdiplusLinearGradientBrushFromPointsInitializer new library: self!

testCreateHandle
	model
		point1: 1 @ 2
		point2: 3 @ 4
		color1: (Color fromArgbCode: 1)
		color2: (Color fromArgbCode: 2).
	model createHandle.
	self assert: constructorArgs size equals: 6.
	self assert: constructorArgs first class identicalTo: POINTL.
	self assert: constructorArgs first asPoint equals: 1 @ 2.
	self assert: constructorArgs second class identicalTo: POINTL.
	self assert: constructorArgs second asPoint equals: 3 @ 4.
	self assert: constructorArgs third equals: 1.
	self assert: constructorArgs fourth equals: 2.
	self assert: (constructorArgs at: 5) equals: WrapModeTile! !
!GdiplusLinearGradientBrushFromPointsInitializerTest categoriesFor: #gdipCreateLineBrushI:point2:color1:color2:wrapMode:lineGradient:!accessing!public! !
!GdiplusLinearGradientBrushFromPointsInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusLinearGradientBrushFromPointsInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !

