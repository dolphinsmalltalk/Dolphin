"Filed out from Dolphin Smalltalk X6"!

GdiplusLinearGradientBrushInitializer subclass: #GdiplusLinearGradientBrushFromRectInitializer
	instanceVariableNames: 'rect color1 color2 mode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusLinearGradientBrushFromRectInitializer guid: (GUID fromString: '{E5737BCA-1AF2-4189-9DE4-D6C506A8C20A}')!
GdiplusLinearGradientBrushFromRectInitializer comment: ''!
!GdiplusLinearGradientBrushFromRectInitializer categoriesForClass!Unclassified! !
!GdiplusLinearGradientBrushFromRectInitializer methodsFor!

createHandle
	" LinearGradientBrush(IN const Rect& rect,
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
				color1: color1 asParameter
				color2: color2 asParameter
				mode: mode
				wrapMode: WrapModeTile
				lineGradient: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

rect: aRectangle color1: anARGB1 color2: anARGB2 mode: aLinearGradientMode
	rect := aRectangle.
	color1 := anARGB1.
	color2 := anARGB2.
	mode := aLinearGradientMode! !
!GdiplusLinearGradientBrushFromRectInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusLinearGradientBrushFromRectInitializer categoriesFor: #rect:color1:color2:mode:!accessing!public! !

