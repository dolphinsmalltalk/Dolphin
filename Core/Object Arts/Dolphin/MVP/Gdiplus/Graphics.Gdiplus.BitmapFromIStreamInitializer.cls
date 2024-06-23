"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.AbstractImageFromIStreamInitializer
	subclass: #'Graphics.Gdiplus.BitmapFromIStreamInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.BitmapFromIStreamInitializer guid: (Core.GUID fromString: '{f3cd9058-7788-4cff-95d9-04dda741ef4e}')!

Graphics.Gdiplus.BitmapFromIStreamInitializer comment: ''!

!Graphics.Gdiplus.BitmapFromIStreamInitializer methodsFor!

basicCreateHandle
	"Private -  Bitmap::Bitmap(
	    IN IStream *stream, 
	    IN BOOL useEmbeddedColorManagement
	    )
	...
	 {
	        lastResult = DllExports::GdipCreateBitmapFromStream(stream, &bitmap);
	    }"

	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCreateBitmapFromStream: iStream asParameter bitmap: gpHandle.
	^gpHandle! !

!Graphics.Gdiplus.BitmapFromIStreamInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
!

