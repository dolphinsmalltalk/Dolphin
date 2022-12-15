"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.Brush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Brush guid: (Core.GUID fromString: '{9a229a16-873b-4102-946a-b33879a9b261}')!
Graphics.Gdiplus.Brush isNonInstantiable: true!
Graphics.Gdiplus.Brush comment: 'GdiplusBrush is an abstract class that defines an object used to paint the interior of graphics shapes, such as rectangles, ellipses, pies, polygons, strings, regions and paths.

'!
!Graphics.Gdiplus.Brush methodsFor!

createGpPen: aFloat
	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreatePen2: self handle
		width: aFloat
		unit: UnitWorld
		pen: gpHandle.
	^gpHandle!

gdiplusBrush: aPoint
	"Answer a Gdiplus.Brush configured for painting with a brush like the receiver but with the specified extent."

	^self!

isNone
	"Answer whether the receiver paints nothing (is transparent)."

	^false!

luminance
	"Answer a <Number> in the range [0,1] representing the luminance of the receiver, a brightness value weighted by the human eye's color sensitivity. 
	For a brush this is often very approximate, although correct for solid brushes."

	^0.5

	!

type
	| buf |
	buf := UInt32Bytes new.
	Gdip gdipGetBrushType: self handle type: buf.
	^buf asInteger! !
!Graphics.Gdiplus.Brush categoriesForMethods!
createGpPen:!operations!private! !
gdiplusBrush:!converting!public! !
isNone!public!testing! !
luminance!accessing!public! !
type!accessing!public! !
!

!Graphics.Gdiplus.Brush class methodsFor!

black
	^self color: Color.Black!

blue
	^self color: Color blue!

color: aColor
	"Creates a SolidBrush object based on a color."

	^SolidBrush color: aColor!

green
	^self color: Color green!

red
	^self color: Color red! !
!Graphics.Gdiplus.Brush class categoriesForMethods!
black!instance creation!public! !
blue!instance creation!public! !
color:!instance creation!public! !
green!instance creation!public! !
red!instance creation!public! !
!

