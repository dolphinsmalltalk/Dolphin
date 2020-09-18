"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.FromBytesInitializer subclass: #'Graphics.Gdiplus.ImageFromBytesInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.ImageFromBytesInitializer guid: (Core.GUID fromString: '{351525b1-07b3-43c9-b7d0-bc92d49db495}')!
Graphics.Gdiplus.ImageFromBytesInitializer comment: ''!
!Graphics.Gdiplus.ImageFromBytesInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.ImageFromBytesInitializer methodsFor!

createHandle
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
	self library gdipLoadImageFromStream: stm image: gpHandle.
	stm free.
	^gpHandle! !
!Graphics.Gdiplus.ImageFromBytesInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

