"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GraphicsInitializer subclass: #'Graphics.Gdiplus.GraphicsFromImageInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GraphicsFromImageInitializer guid: (Core.GUID fromString: '{2b0e6f89-db02-4889-b235-64d9b48047f7}')!
Graphics.Gdiplus.GraphicsFromImageInitializer comment: ''!
!Graphics.Gdiplus.GraphicsFromImageInitializer methodsFor!

basicCreateHandle
	"Private -  Graphics(IN Image* image)
    {
        GpGraphics *graphics = NULL;

        if (image !!= NULL)
        {
            lastResult = DllExports::GdipGetImageGraphicsContext(
                                                                image->nativeImage, &graphics);
        }"

	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipGetImageGraphicsContext: surface asParameter graphics: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.GraphicsFromImageInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
!

