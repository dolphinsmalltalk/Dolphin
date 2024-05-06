"Filed out from Dolphin Smalltalk"!

GdiplusPenInitializer subclass: #GdiplusPenFromBrushInitializer
	instanceVariableNames: 'brush width'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusPenFromBrushInitializer guid: (GUID fromString: '{3cebfbe5-f58d-442f-bf48-8d88151842cf}')!

GdiplusPenFromBrushInitializer comment: ''!

!GdiplusPenFromBrushInitializer categoriesForClass!Unclassified! !

!GdiplusPenFromBrushInitializer methodsFor!

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

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library
				gdipCreatePen2: brush asParameter
				width: (width ?? 1.0) asParameter
				unit: UnitWorld
				pen: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle! !

!GdiplusPenFromBrushInitializer categoriesForMethods!
brush!private!test accessing! !
brush:width:!initializing!private! !
createHandle!private!realizing/unrealizing! !
!

