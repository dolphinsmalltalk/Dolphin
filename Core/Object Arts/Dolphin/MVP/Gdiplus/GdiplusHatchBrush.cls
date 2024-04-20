"Filed out from Dolphin Smalltalk"!

GdiplusBrush subclass: #GdiplusHatchBrush
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusHatchBrush guid: (GUID fromString: '{1a1a5ea4-6151-11d7-b609-00e0987e8081}')!

GdiplusHatchBrush comment: 'A hatch brush paints a background and paints, over that background, a foreground that consists of a pattern of lines, dots, dashes, squares, crosshatch, or some variation of these. The hatch brush consists of two colors: one for the background and one for the foreground.'!

!GdiplusHatchBrush categoriesForClass!Unclassified! !

!GdiplusHatchBrush class methodsFor!

style: aNumber forecolor: foreARGB backcolor: backARGB
	^self fromInitializer: (GdiplusHatchBrushInitializer 
				style: aNumber
				forecolor: foreARGB
				backcolor: backARGB)! !

!GdiplusHatchBrush class categoriesForMethods!
style:forecolor:backcolor:!instance creation!public! !
!

