"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusImageFromIStreamInitializer
	instanceVariableNames: 'iStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageFromIStreamInitializer guid: (GUID fromString: '{0a3984b0-2193-4a59-abd8-6f6d3f8ed0f7}')!
GdiplusImageFromIStreamInitializer comment: ''!
!GdiplusImageFromIStreamInitializer categoriesForClass!Unclassified! !
!GdiplusImageFromIStreamInitializer methodsFor!

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

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipLoadImageFromStream: iStream asParameter image: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error loading image'!

isPersistent
	"The IStream will no longer be valid when restoring from a saved image or binary filed content."

	^false!

iStream: pStream
	iStream := pStream! !
!GdiplusImageFromIStreamInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
gdiplusConstructorErrorDescription!constants!public!realizing/unrealizing! !
isPersistent!constants!public!realizing/unrealizing!testing! !
iStream:!constants!initializing!private!realizing/unrealizing!testing! !
!

!GdiplusImageFromIStreamInitializer class methodsFor!

iStream: pStream
	^self new iStream: pStream! !
!GdiplusImageFromIStreamInitializer class categoriesForMethods!
iStream:!instance creation!public! !
!

