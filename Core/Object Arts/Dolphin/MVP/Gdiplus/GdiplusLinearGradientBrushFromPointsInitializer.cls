"Filed out from Dolphin Smalltalk 7"!

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
	"LinearGradientBrush(IN const Point& point1,
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
				color1: color1 asParameter
				color2: color2 asParameter
				wrapMode: WrapModeTile
				lineGradient: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

point1: aPoint1 point2: aPoint2 color1: anARGB1 color2: anARGB2
	point1 := aPoint1.
	point2 := aPoint2.
	color1 := anARGB1.
	color2 := anARGB2! !
!GdiplusLinearGradientBrushFromPointsInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusLinearGradientBrushFromPointsInitializer categoriesFor: #point1:point2:color1:color2:!accessing!public! !

