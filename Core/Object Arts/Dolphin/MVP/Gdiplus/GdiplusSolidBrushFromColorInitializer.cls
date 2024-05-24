"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusSolidBrushFromColorInitializer
	instanceVariableNames: 'color'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusSolidBrushFromColorInitializer guid: (GUID fromString: '{02b80350-515e-40c3-8ec4-b328a7a4bcbb}')!

GdiplusSolidBrushFromColorInitializer comment: ''!

!GdiplusSolidBrushFromColorInitializer categoriesForClass!Unclassified! !

!GdiplusSolidBrushFromColorInitializer methodsFor!

color: aColor
	color := aColor!

createHandle
	"Private -  SolidBrush(IN const Color& color)
    	{
       	 GpSolidFill *brush = NULL;

	        lastResult = DllExports::GdipCreateSolidFill(color.GetValue(), &brush);
	    };"

	| gpHandle |
	gpHandle := ExternalHandle new.
	self library gdipCreateSolidFill: color argbCode brush: gpHandle.
	^gpHandle! !

!GdiplusSolidBrushFromColorInitializer categoriesForMethods!
color:!initializing!private! !
createHandle!private!realizing/unrealizing! !
!

!GdiplusSolidBrushFromColorInitializer class methodsFor!

color: aColor
	^self new color: aColor! !

!GdiplusSolidBrushFromColorInitializer class categoriesForMethods!
color:!instance creation!public! !
!

