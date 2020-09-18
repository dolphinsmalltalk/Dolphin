"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.SolidBrushFromColorInitializer'
	instanceVariableNames: 'color'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.SolidBrushFromColorInitializer guid: (Core.GUID fromString: '{02b80350-515e-40c3-8ec4-b328a7a4bcbb}')!
Graphics.Gdiplus.SolidBrushFromColorInitializer comment: ''!
!Graphics.Gdiplus.SolidBrushFromColorInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.SolidBrushFromColorInitializer methodsFor!

color: aColor
	color := aColor!

createHandle
	"Private -  SolidBrush(IN const Color& color)
    	{
       	 GpSolidFill *brush = NULL;

	        lastResult = DllExports::GdipCreateSolidFill(color.GetValue(), &brush);
	    };"

	| gpHandle |
	gpHandle := Handle new.
	self library gdipCreateSolidFill: color argbCode brush: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.SolidBrushFromColorInitializer categoriesFor: #color:!initializing!private! !
!Graphics.Gdiplus.SolidBrushFromColorInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!Graphics.Gdiplus.SolidBrushFromColorInitializer class methodsFor!

color: aColor
	^self new color: aColor! !
!Graphics.Gdiplus.SolidBrushFromColorInitializer class categoriesFor: #color:!instance creation!public! !

