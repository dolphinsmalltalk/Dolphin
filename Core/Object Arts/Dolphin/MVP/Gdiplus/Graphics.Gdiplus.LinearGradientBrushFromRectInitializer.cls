"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.LinearGradientBrushInitializer subclass: #'Graphics.Gdiplus.LinearGradientBrushFromRectInitializer'
	instanceVariableNames: 'rect color1 color2 mode'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.LinearGradientBrushFromRectInitializer guid: (Core.GUID fromString: '{e5737bca-1af2-4189-9de4-d6c506a8c20a}')!
Graphics.Gdiplus.LinearGradientBrushFromRectInitializer comment: ''!
!Graphics.Gdiplus.LinearGradientBrushFromRectInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.LinearGradientBrushFromRectInitializer methodsFor!

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
	gpHandle := Handle new.
	self library
		gdipCreateLineBrushFromRectI: rect asParameter
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
	mode := aLinearGradientMode! !
!Graphics.Gdiplus.LinearGradientBrushFromRectInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.LinearGradientBrushFromRectInitializer categoriesFor: #rect:color1:color2:mode:!initializing!private! !

