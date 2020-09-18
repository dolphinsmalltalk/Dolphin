"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.GraphicsFromHDCInitializer'
	instanceVariableNames: 'canvas'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GraphicsFromHDCInitializer guid: (Core.GUID fromString: '{83cb0a86-604f-48a0-9336-619cfce00e47}')!
Graphics.Gdiplus.GraphicsFromHDCInitializer comment: ''!
!Graphics.Gdiplus.GraphicsFromHDCInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.GraphicsFromHDCInitializer methodsFor!

canvas: aCanvas
	canvas := aCanvas!

createHandle
	"Private -  Graphics(IN HDC hdc)
    	{
	        GpGraphics *graphics = NULL;

	        lastResult = DllExports::GdipCreateFromHDC(hdc, &graphics);"

	"MSDN: When you use this constructor to create a Graphics object, make sure that the
	Graphics object is deleted or goes out of scope before the device context is released."

	| gpHandle |
	gpHandle := Handle new.
	self library gdipCreateFromHDC: canvas asParameter graphics: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.GraphicsFromHDCInitializer categoriesFor: #canvas:!initializing!private! !
!Graphics.Gdiplus.GraphicsFromHDCInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!Graphics.Gdiplus.GraphicsFromHDCInitializer class methodsFor!

canvas: aCanvas
	"Creates a Graphics object that is associated with a specified device context."

	^self new canvas: aCanvas! !
!Graphics.Gdiplus.GraphicsFromHDCInitializer class categoriesFor: #canvas:!instance creation!public! !

