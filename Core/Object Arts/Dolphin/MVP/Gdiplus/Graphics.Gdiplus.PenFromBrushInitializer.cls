"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.PenInitializer subclass: #'Graphics.Gdiplus.PenFromBrushInitializer'
	instanceVariableNames: 'brush width'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PenFromBrushInitializer guid: (Core.GUID fromString: '{3cebfbe5-f58d-442f-bf48-8d88151842cf}')!
Graphics.Gdiplus.PenFromBrushInitializer comment: ''!
!Graphics.Gdiplus.PenFromBrushInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.PenFromBrushInitializer methodsFor!

brush
	"Private - Unit test accessor"

	^brush!

brush: aGdiplusBrush width: aFloat
	brush := aGdiplusBrush.
	width := aFloat!

createHandle
	"Private - GdiPlusPen.h
		Pen(IN const Brush* brush, IN REAL width = 1.0f)
		    {
		        Unit unit = UnitWorld;
		        nativePen = NULL;
		        lastResult = DllExports::GdipCreatePen2(brush->nativeBrush,
                      		              width, unit, &nativePen);"

	| gpHandle |
	gpHandle := Handle new.
	self library
		gdipCreatePen2: brush asParameter
		width: (width ?? 1.0) asParameter
		unit: UnitWorld
		pen: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.PenFromBrushInitializer categoriesFor: #brush!private!test accessing! !
!Graphics.Gdiplus.PenFromBrushInitializer categoriesFor: #brush:width:!initializing!private! !
!Graphics.Gdiplus.PenFromBrushInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

