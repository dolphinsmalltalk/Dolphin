"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GraphicsInitializer subclass: #'Graphics.Gdiplus.GraphicsFromHDCInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GraphicsFromHDCInitializer guid: (Core.GUID fromString: '{83cb0a86-604f-48a0-9336-619cfce00e47}')!
Graphics.Gdiplus.GraphicsFromHDCInitializer comment: ''!
!Graphics.Gdiplus.GraphicsFromHDCInitializer methodsFor!

basicCreateHandle
	"Private -  Graphics(IN HDC hdc)
    	{
	        GpGraphics *graphics = NULL;

	        lastResult = DllExports::GdipCreateFromHDC(hdc, &graphics);"

	"MSDN: When you use this constructor to create a Graphics object, make sure that the
	Graphics object is deleted or goes out of scope before the device context is released."

	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCreateFromHDC: surface asParameter graphics: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.GraphicsFromHDCInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
!

!Graphics.Gdiplus.GraphicsFromHDCInitializer class methodsFor!

canvas: aCanvas
	"Creates a Graphics object that is associated with a specified device context."

	^self new surface: aCanvas! !
!Graphics.Gdiplus.GraphicsFromHDCInitializer class categoriesForMethods!
canvas:!instance creation!public! !
!

