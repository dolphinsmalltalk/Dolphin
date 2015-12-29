"Filed out from Dolphin Smalltalk X6"!

GdiplusPenInitializer subclass: #GdiplusPenFromColorInitializer
	instanceVariableNames: 'color width'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPenFromColorInitializer guid: (GUID fromString: '{2F244647-43B8-40CB-92F6-F06F2B1CFDAE}')!
GdiplusPenFromColorInitializer comment: ''!
!GdiplusPenFromColorInitializer categoriesForClass!Unclassified! !
!GdiplusPenFromColorInitializer methodsFor!

color: anARGB width: aFloat
	color := anARGB.
	width := aFloat!

createHandle
	"GdiPlusPen.h
		    Pen(IN const Color& color, 
		        IN REAL width = 1.0f)
		    {
		        Unit unit = UnitWorld;
		        nativePen = NULL;
		        lastResult = DllExports::GdipCreatePen1(color.GetValue(),
                                    width, unit, &nativePen);"

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library 
				gdipCreatePen1: color asParameter
				width: (width ifNil: [1.0]) asParameter
				unit: UnitWorld
				pen: gpHandle.
	self assertStatusOk: status.
	^gpHandle! !
!GdiplusPenFromColorInitializer categoriesFor: #color:width:!accessing!public! !
!GdiplusPenFromColorInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !

