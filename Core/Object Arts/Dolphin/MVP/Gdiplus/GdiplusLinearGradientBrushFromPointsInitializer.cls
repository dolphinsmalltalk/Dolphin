"Filed out from Dolphin Smalltalk"!

GdiplusLinearGradientBrushInitializer subclass: #GdiplusLinearGradientBrushFromPointsInitializer
	instanceVariableNames: 'point1 point2 color1 color2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusLinearGradientBrushFromPointsInitializer guid: (GUID fromString: '{e82f4257-44c1-45f0-8130-6e92d59ab946}')!
GdiplusLinearGradientBrushFromPointsInitializer comment: ''!
!GdiplusLinearGradientBrushFromPointsInitializer categoriesForClass!Unclassified! !
!GdiplusLinearGradientBrushFromPointsInitializer methodsFor!

createHandle
	"Private - LinearGradientBrush(IN const Point& point1,
                        IN const Point& point2,
                        IN const Color& color1,
                        IN const Color& color2)
    {
        GpLineGradient *brush = NULL;

        lastResult = DllExports::GdipCreateLineBrushI(&point1,
                                                      &point2,
                                                      color1.GetValue(),
                                                      color2.GetValue(),
                                                      WrapModeTile,
                                                      &brush);"

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library
				gdipCreateLineBrushI: point1 asParameter
				point2: point2 asParameter
				color1: color1 argbCode
				color2: color2 argbCode
				wrapMode: WrapModeTile
				lineGradient: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

point1: aPoint1 point2: aPoint2 color1: startColor color2: endColor
	point1 := aPoint1.
	point2 := aPoint2.
	color1 := startColor.
	color2 := endColor! !
!GdiplusLinearGradientBrushFromPointsInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
point1:point2:color1:color2:!initializing!private! !
!

