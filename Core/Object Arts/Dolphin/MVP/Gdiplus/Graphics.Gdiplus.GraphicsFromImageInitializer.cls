"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.GraphicsFromImageInitializer'
	instanceVariableNames: 'image'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GraphicsFromImageInitializer guid: (Core.GUID fromString: '{2b0e6f89-db02-4889-b235-64d9b48047f7}')!
Graphics.Gdiplus.GraphicsFromImageInitializer comment: ''!
!Graphics.Gdiplus.GraphicsFromImageInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.GraphicsFromImageInitializer methodsFor!

createHandle
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
	self library gdipGetImageGraphicsContext: image asParameter graphics: gpHandle.
	^gpHandle!

image: aGdiplusImage
	image := aGdiplusImage! !
!Graphics.Gdiplus.GraphicsFromImageInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.GraphicsFromImageInitializer categoriesFor: #image:!initializing!private! !

!Graphics.Gdiplus.GraphicsFromImageInitializer class methodsFor!

image: aGdiplusImage
	^self new image: aGdiplusImage! !
!Graphics.Gdiplus.GraphicsFromImageInitializer class categoriesFor: #image:!instance creation!public! !

