"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializerTests subclass: #GdiplusLinearGradientBrushFromPointsInitializerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusLinearGradientBrushFromPointsInitializerTest guid: (GUID fromString: '{2CA114C0-DEEE-48F6-ADE7-9BC53B50D22C}')!
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
		color1: (ARGB fromInteger: 1)
		color2: (ARGB fromInteger: 2).
	model createHandle.
	self assert: constructorArgs size = 6.
	self assert: constructorArgs first class == POINTL.
	self assert: constructorArgs first asPoint = (1 @ 2).
	self assert: constructorArgs second class == POINTL.
	self assert: constructorArgs second asPoint = (3 @ 4).
	self assert: constructorArgs third = 1.
	self assert: constructorArgs fourth = 2.
	self assert: (constructorArgs at: 5) = WrapModeTile! !
!GdiplusLinearGradientBrushFromPointsInitializerTest categoriesFor: #gdipCreateLineBrushI:point2:color1:color2:wrapMode:lineGradient:!accessing!public! !
!GdiplusLinearGradientBrushFromPointsInitializerTest categoriesFor: #setUp!public!setup! !
!GdiplusLinearGradientBrushFromPointsInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !

