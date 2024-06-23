"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.AbstractImageFromIStreamInitializer
	subclass: #'Graphics.Gdiplus.ImageFromIStreamInitializer'
	instanceVariableNames: 'iStream2'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.ImageFromIStreamInitializer guid: (Core.GUID fromString: '{0a3984b0-2193-4a59-abd8-6f6d3f8ed0f7}')!

Graphics.Gdiplus.ImageFromIStreamInitializer comment: ''!

!Graphics.Gdiplus.ImageFromIStreamInitializer methodsFor!

basicCreateHandle
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
	Gdip gdipLoadImageFromStream: iStream asParameter image: gpHandle.
	^gpHandle! !

!Graphics.Gdiplus.ImageFromIStreamInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
!

