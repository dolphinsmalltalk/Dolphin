"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusGraphicsFromImageInitializer
	instanceVariableNames: 'image'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusGraphicsFromImageInitializer guid: (GUID fromString: '{2b0e6f89-db02-4889-b235-64d9b48047f7}')!

GdiplusGraphicsFromImageInitializer comment: ''!

!GdiplusGraphicsFromImageInitializer categoriesForClass!Unclassified! !

!GdiplusGraphicsFromImageInitializer methodsFor!

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
	gpHandle := ExternalHandle new.
	self library gdipGetImageGraphicsContext: image asParameter graphics: gpHandle.
	^gpHandle!

image: aGdiplusImage
	image := aGdiplusImage! !

!GdiplusGraphicsFromImageInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
image:!initializing!private! !
!

!GdiplusGraphicsFromImageInitializer class methodsFor!

image: aGdiplusImage
	^self new image: aGdiplusImage! !

!GdiplusGraphicsFromImageInitializer class categoriesForMethods!
image:!instance creation!public! !
!

