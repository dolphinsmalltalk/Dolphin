"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusLinearGradientBrushInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusLinearGradientBrushInitializer guid: (GUID fromString: '{5dd72bf9-0464-4f05-b1b3-faa11a8e112e}')!
GdiplusLinearGradientBrushInitializer isAbstract: true!
GdiplusLinearGradientBrushInitializer comment: ''!
!GdiplusLinearGradientBrushInitializer categoriesForClass!Unclassified! !
!GdiplusLinearGradientBrushInitializer methodsFor!

gdiplusConstructorErrorDescription
	^'Error creating LinearGradientBrush'! !
!GdiplusLinearGradientBrushInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusLinearGradientBrushInitializer class methodsFor!

point1: point1 point2: point2 color1: aColor1 color2: aColor2
	"SW: The C++ class has a separate constructor for these parameters, and there is a separate FlatAPI constructor.
		- I *think* this is equivalent ... if not, we need another GdiplusLinearGradientBrushInitializer class"

	"SW: Update: I switched to using a separate initializer as it wasnt clear to me that using the rect initializer was identical.
	In addition, I was getting 'out of memory' errors when passing rectangles with an extent with a 0 height/width"

	^GdiplusLinearGradientBrushFromPointsInitializer new
		point1: point1
		point2: point2
		color1: aColor1
		color2: aColor2!

rect: rect color1: color1 color2: color2 mode: aLinearGradientMode
	"Creates a LinearGradientBrush object from a set of boundary points and boundary colors."

	"typedef enum {
	    LinearGradientModeHorizontal = 0,
	    LinearGradientModeVertical = 1,
	    LinearGradientModeForwardDiagonal = 2,
	    LinearGradientModeBackwardDiagonal = 3
	} LinearGradientMode;"

	^GdiplusLinearGradientBrushFromRectInitializer new 
		rect: rect
		color1: color1
		color2: color2
		mode: aLinearGradientMode! !
!GdiplusLinearGradientBrushInitializer class categoriesFor: #point1:point2:color1:color2:!instance creation!public! !
!GdiplusLinearGradientBrushInitializer class categoriesFor: #rect:color1:color2:mode:!instance creation!public! !

