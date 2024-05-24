"Filed out from Dolphin Smalltalk"!

GdiplusLinearGradientBrushInitializer subclass: #GdiplusLinearGradientBrushFromRectInitializer
	instanceVariableNames: 'rect color1 color2 mode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusLinearGradientBrushFromRectInitializer guid: (GUID fromString: '{e5737bca-1af2-4189-9de4-d6c506a8c20a}')!

GdiplusLinearGradientBrushFromRectInitializer comment: ''!

!GdiplusLinearGradientBrushFromRectInitializer categoriesForClass!Unclassified! !

!GdiplusLinearGradientBrushFromRectInitializer methodsFor!

color1
	^color1!

color2
	^color2!

createHandle
	"Private -  LinearGradientBrush(IN const Rect& rect,
                        IN const Color& color1,
                        IN const Color& color2,
                        IN LinearGradientMode mode)
    {
        GpLineGradient *brush = NULL;

        lastResult = DllExports::GdipCreateLineBrushFromRectI(&rect,
                                                              color1.GetValue(),
                                                              color2.GetValue(),
                                                              mode,
                                                              WrapModeTile,
                                                              &brush);"

	| gpHandle |
	gpHandle := ExternalHandle new.
	self library
		gdipCreateLineBrushFromRectI: (GpRect marshal: rect)
		color1: color1 argbCode
		color2: color2 argbCode
		mode: mode
		wrapMode: WrapModeTile
		lineGradient: gpHandle.
	^gpHandle!

rect: aRectangle color1: startColor color2: endColor mode: aLinearGradientMode
	rect := aRectangle.
	color1 := startColor.
	color2 := endColor.
	mode := aLinearGradientMode!

wrapMode
	^mode! !

!GdiplusLinearGradientBrushFromRectInitializer categoriesForMethods!
color1!accessing!private! !
color2!accessing!private! !
createHandle!private!realizing/unrealizing! !
rect:color1:color2:mode:!initializing!private! !
wrapMode!accessing!private! !
!

