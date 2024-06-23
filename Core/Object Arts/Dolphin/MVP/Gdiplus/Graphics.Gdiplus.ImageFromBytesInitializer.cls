"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.AbstractImageFromBytesInitializer
	subclass: #'Graphics.Gdiplus.ImageFromBytesInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.ImageFromBytesInitializer guid: (Core.GUID fromString: '{351525b1-07b3-43c9-b7d0-bc92d49db495}')!

Graphics.Gdiplus.ImageFromBytesInitializer comment: ''!

!Graphics.Gdiplus.ImageFromBytesInitializer methodsFor!

basicCreateHandle
	"Private -  Bitmap::Bitmap(
	    IN IStream *stream, 
	    IN BOOL useEmbeddedColorManagement
	    )
	...
	 {
	        lastResult = DllExports::GdipCreateBitmapFromStream(stream, &bitmap);
	    }"

	| gpHandle stm |
	gpHandle := Handle new.
	stm := self iStream.
	Gdip gdipLoadImageFromStream: stm image: gpHandle.
	stm free.
	^gpHandle! !

!Graphics.Gdiplus.ImageFromBytesInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
!

