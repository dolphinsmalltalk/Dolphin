"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusGraphicsFromImageInitializer
	instanceVariableNames: 'image'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipGetImageGraphicsContext: image asParameter graphics: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Graphics'!

image: aGdiplusImage
	image := aGdiplusImage! !
!GdiplusGraphicsFromImageInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusGraphicsFromImageInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusGraphicsFromImageInitializer categoriesFor: #image:!initializing!private! !

!GdiplusGraphicsFromImageInitializer class methodsFor!

image: aGdiplusImage
	^self new image: aGdiplusImage! !
!GdiplusGraphicsFromImageInitializer class categoriesFor: #image:!instance creation!public! !

