"Filed out from Dolphin Smalltalk 7"!

GdiplusLinearGradientBrushInitializer subclass: #GdiplusLinearGradientBrushFromRectInitializer
	instanceVariableNames: 'rect color1 color2 mode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusLinearGradientBrushFromRectInitializer guid: (GUID fromString: '{e5737bca-1af2-4189-9de4-d6c506a8c20a}')!
GdiplusLinearGradientBrushFromRectInitializer comment: ''!
!GdiplusLinearGradientBrushFromRectInitializer categoriesForClass!Unclassified! !
!GdiplusLinearGradientBrushFromRectInitializer methodsFor!

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

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library
				gdipCreateLineBrushFromRectI: rect asParameter
				color1: color1 argbCode
				color2: color2 argbCode
				mode: mode
				wrapMode: WrapModeTile
				lineGradient: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

rect: aRectangle color1: startColor color2: endColor mode: aLinearGradientMode
	rect := aRectangle.
	color1 := startColor.
	color2 := endColor.
	mode := aLinearGradientMode! !
!GdiplusLinearGradientBrushFromRectInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusLinearGradientBrushFromRectInitializer categoriesFor: #rect:color1:color2:mode:!initializing!private! !

