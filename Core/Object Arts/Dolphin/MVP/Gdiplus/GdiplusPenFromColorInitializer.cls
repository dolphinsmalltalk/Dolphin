﻿"Filed out from Dolphin Smalltalk 7"!

GdiplusPenInitializer subclass: #GdiplusPenFromColorInitializer
	instanceVariableNames: 'color width'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPenFromColorInitializer guid: (GUID fromString: '{2f244647-43b8-40cb-92f6-f06f2b1cfdae}')!
GdiplusPenFromColorInitializer comment: ''!
!GdiplusPenFromColorInitializer categoriesForClass!Unclassified! !
!GdiplusPenFromColorInitializer methodsFor!

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

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library
				gdipCreatePen1: color argbCode
				width: (width ?? 1.0) asParameter
				unit: UnitWorld
				pen: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle! !
!GdiplusPenFromColorInitializer categoriesFor: #color:width:!initializing!private! !
!GdiplusPenFromColorInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

