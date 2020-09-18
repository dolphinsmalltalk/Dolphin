"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.ImageFromIStreamInitializer'
	instanceVariableNames: 'iStream'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.ImageFromIStreamInitializer guid: (Core.GUID fromString: '{0a3984b0-2193-4a59-abd8-6f6d3f8ed0f7}')!
Graphics.Gdiplus.ImageFromIStreamInitializer comment: ''!
!Graphics.Gdiplus.ImageFromIStreamInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.ImageFromIStreamInitializer methodsFor!

createHandle
	"Private -  Image::Image(
    IN IStream* stream,
    IN BOOL useEmbeddedColorManagement
    )
{
    nativeImage = NULL;
    if(useEmbeddedColorManagement)
    { ...
    }
    else
    {
        lastResult = DllExports::GdipLoadImageFromStream(
            stream, 
            &nativeImage
        );
    }
}"

	| gpHandle |
	gpHandle := Handle new.
	self library gdipLoadImageFromStream: iStream asParameter image: gpHandle.
	^gpHandle!

isPersistent
	"The IStream will no longer be valid when restoring from a saved image or binary filed content."

	^false!

iStream: pStream
	iStream := pStream! !
!Graphics.Gdiplus.ImageFromIStreamInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.ImageFromIStreamInitializer categoriesFor: #isPersistent!constants!public!realizing/unrealizing!testing! !
!Graphics.Gdiplus.ImageFromIStreamInitializer categoriesFor: #iStream:!constants!initializing!private!realizing/unrealizing!testing! !

!Graphics.Gdiplus.ImageFromIStreamInitializer class methodsFor!

iStream: pStream
	^self new iStream: pStream! !
!Graphics.Gdiplus.ImageFromIStreamInitializer class categoriesFor: #iStream:!instance creation!public! !

