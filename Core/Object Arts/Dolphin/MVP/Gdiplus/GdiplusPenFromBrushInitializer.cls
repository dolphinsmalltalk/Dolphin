"Filed out from Dolphin Smalltalk X6"!

GdiplusPenInitializer subclass: #GdiplusPenFromBrushInitializer
	instanceVariableNames: 'brush width'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPenFromBrushInitializer guid: (GUID fromString: '{3CEBFBE5-F58D-442F-BF48-8D88151842CF}')!
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
	"GdiPlusPen.h
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
				width: (width ifNil: [1.0]) asParameter
				unit: UnitWorld
				pen: gpHandle.
	self assertStatusOk: status.
	^gpHandle! !
!GdiplusPenFromBrushInitializer categoriesFor: #brush!private!test accessing! !
!GdiplusPenFromBrushInitializer categoriesFor: #brush:width:!accessing!public! !
!GdiplusPenFromBrushInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !

