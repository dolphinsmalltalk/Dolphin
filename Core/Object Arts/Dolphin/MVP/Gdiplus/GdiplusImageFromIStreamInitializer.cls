"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusImageFromIStreamInitializer
	instanceVariableNames: 'iStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageFromIStreamInitializer guid: (GUID fromString: '{0A3984B0-2193-4A59-ABD8-6F6D3F8ED0F7}')!
GdiplusImageFromIStreamInitializer comment: ''!
!GdiplusImageFromIStreamInitializer categoriesForClass!Unclassified! !
!GdiplusImageFromIStreamInitializer methodsFor!

createHandle
	" Image::Image(
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
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error loading image'!

isPersistent
	^false!

iStream: pStream
	iStream := pStream! !
!GdiplusImageFromIStreamInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusImageFromIStreamInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!public!realizing/unrealizing! !
!GdiplusImageFromIStreamInitializer categoriesFor: #isPersistent!constants!public!realizing/unrealizing!testing! !
!GdiplusImageFromIStreamInitializer categoriesFor: #iStream:!accessing!constants!public!realizing/unrealizing!testing! !

!GdiplusImageFromIStreamInitializer class methodsFor!

iStream: pStream
	^self new iStream: pStream! !
!GdiplusImageFromIStreamInitializer class categoriesFor: #iStream:!instance creation!public! !

