"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.PenInitializer subclass: #'Graphics.Gdiplus.PenFromColorInitializer'
	instanceVariableNames: 'color width'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PenFromColorInitializer guid: (Core.GUID fromString: '{2f244647-43b8-40cb-92f6-f06f2b1cfdae}')!
Graphics.Gdiplus.PenFromColorInitializer comment: ''!
!Graphics.Gdiplus.PenFromColorInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.PenFromColorInitializer methodsFor!

color: anARGB width: aFloat
	color := anARGB.
	width := aFloat!

createHandle
	"Private - GdiPlusPen.h
		    Pen(IN const Color& color, 
		        IN REAL width = 1.0f)
		    {
		        Unit unit = UnitWorld;
		        nativePen = NULL;
		        lastResult = DllExports::GdipCreatePen1(color.GetValue(),
                                    width, unit, &nativePen);"

	| gpHandle |
	gpHandle := Handle new.
	self library
		gdipCreatePen1: color argbCode
		width: (width ?? 1.0) asParameter
		unit: UnitWorld
		pen: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.PenFromColorInitializer categoriesFor: #color:width:!initializing!private! !
!Graphics.Gdiplus.PenFromColorInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

