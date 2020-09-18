"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.LinearGradientBrushInitializer subclass: #'Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer'
	instanceVariableNames: 'point1 point2 color1 color2'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer guid: (Core.GUID fromString: '{e82f4257-44c1-45f0-8130-6e92d59ab946}')!
Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer comment: ''!
!Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer methodsFor!

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

	| gpHandle |
	gpHandle := Handle new.
	self library
		gdipCreateLineBrushI: point1 asParameter
		point2: point2 asParameter
		color1: color1 argbCode
		color2: color2 argbCode
		wrapMode: WrapModeTile
		lineGradient: gpHandle.
	^gpHandle!

point1: aPoint1 point2: aPoint2 color1: startColor color2: endColor
	point1 := aPoint1.
	point2 := aPoint2.
	color1 := startColor.
	color2 := endColor! !
!Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer categoriesFor: #point1:point2:color1:color2:!initializing!private! !

